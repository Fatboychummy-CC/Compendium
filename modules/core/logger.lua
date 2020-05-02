--[[
  Resources.lua
  Contains locations of all required files.
]]

-- if we are running this file with arguments, we're checking for updates.
local information = {
  _VERSION = "0.0.1",
  _BUILD = 1,
  _UPDATE_INFO = ""
}
local tArg = ...
if tArg == "INFO" then
  return information
end

local log = {}
local isWriting = false
local logLevel = 1 -- 1 = all, 2 = exclude info/other, 3 = exclude warn/info/other
local file
local logFolder = "/logs/"
local latest = logFolder .. "Latest.log"

local function box(box, info)
  return string.format("[%s]: %s", box, info)
end

local function open()
  if fs.exists(latest) then
    local f = io.open(latest, 'r')
    local name = f:read("*l")
    f:close()
    fs.move(latest, string.format(logFolder .. "%s.log", name))
  end
  file = io.open(latest, 'w')
end

local function close()
  if file then
    file:close()
  end
end

local function writeLog(info)
  if isWriting and not file then
    open()
  end
  file:write(tostring(info) .. "\n")
  file:flush()
end

--[[
  setWriting <bool:set>

  sets the writing status
]]
function log.setWriting(tf)
  isWriting = tf
end

--[[
  logLevel <number:level[1,2,3]>

  set the log level to 1, 2, or 3
  1 = all
  2 = exclude info/other
  3 = exclude warn/info/other
]]
function log.logLevel(level)
  if level == 1 or level == 2 or level == 3 then
    logLevel = level
    log.info(string.format("Set log level to %d", level))
  end
end

function log.info(info)
  if logLevel < 2 then
    writeLog(box("INFO", info))
  end
end

function log.warn(warn)
  if logLevel < 3 then
    writeLog(box("WARN", warn))
  end
end

function log.err(err)
  writeLog(box("ERR ", err))
end

function log.open()
  open()
end

function log.close()
  close()
end

return log
