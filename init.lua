---@meta Chatterino2

local pluginName = "last-log"
local cooldownTime = 10  -- seconds
local lastExecution = {} -- User-specific cooldown

local function extractLastMessageAndTime(jsonString)
  local messages = {}
  for message in string.gmatch(jsonString, '"text":"([^"]*)"') do
    table.insert(messages, message)
  end

  local timestamps = {}
  for timestamp in string.gmatch(jsonString, '"timestamp":"([^"]*)"') do
    table.insert(timestamps, timestamp)
  end

  if #messages > 0 and #timestamps > 0 then
    return messages[#messages], timestamps[#timestamps]
  else
    return nil, nil
  end
end

local function formatTimestamp(timestamp)
  local year, month, day, hour, min, sec = timestamp:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
  return string.format("(%s-%s-%s %s:%s)", year, month, day, hour, min)
end

local function fetchLastLog(ctx)
  local args = ctx.words
  local user = args[2]
  local channel = args[3]
  if not user or not channel then
    ctx.channel:add_system_message("Usage: /lastlog <username> <channel>")
    return
  end

  local now = (os and os.time()) or 0
  if lastExecution[ctx.channel] and now - lastExecution[ctx.channel] < cooldownTime then
    local timeLeft = cooldownTime - (now - lastExecution[ctx.channel])
    ctx.channel:add_system_message(
      string.format("Cooldown: Please wait %.1f seconds before using this command again.", timeLeft))
    return
  end
  lastExecution[ctx.channel] = now

  local url = string.format("https://logs.ivr.fi/channel/%s/user/%s?json=true", channel, user)
  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  request:set_timeout(5000)
  request:on_success(function(res)
    local data = res:data()
    c2.log(c2.LogLevel.Info, "Raw API response (first 1000 chars): " .. data:sub(1, 1000))

    local message, timestamp = extractLastMessageAndTime(data)
    if message and timestamp then
      local formattedTime = formatTimestamp(timestamp)
      local formattedMessage = string.format("%s %s (%s): %s", user, formattedTime, channel, message)
      ctx.channel:add_system_message(formattedMessage)
    else
      ctx.channel:add_system_message("No messages found for " .. user .. " in " .. channel)
    end
  end)
  request:on_error(function(res)
    ctx.channel:add_system_message("Error fetching logs: " .. res:error())
  end)
  request:execute()
end

local function lastLogHelp(ctx)
  ctx.channel:add_system_message("Last Log Command:")
  ctx.channel:add_system_message("/lastlog <username> <channel> - Fetches the last message of a user in a channel.")
  ctx.channel:add_system_message("Example: /lastlog jccdev45 nmplol")
end

c2.register_command("/lastlog", fetchLastLog)
c2.register_command("/lastloghelp", lastLogHelp)
c2.log(c2.LogLevel.Info, pluginName .. " plugin loaded")
