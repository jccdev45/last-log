---@meta Chatterino2

local pluginName = "last-log"
local cooldownTime = 10  -- seconds
local lastExecution = {} -- User-specific cooldown

local function extractLastMessage(jsonString)
  local lastMessage = nil
  for message in string.gmatch(jsonString, '"text":"([^"]*)"') do
    lastMessage = message
  end

  if lastMessage then
    return lastMessage
  else
    return "No messages found or error occurred"
  end
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
    local message = extractLastMessage(data)
    local formattedMessage = string.format("%s's last message in %s: %s", user, channel, message)
    ctx.channel:add_system_message(formattedMessage)
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
