--[[
  logger.lua

  Logs stuff
]]

-- if we are running this file with arguments, we're checking for updates.
local information = {
  _VERSION = "0.0.3",
  _BUILD = 3,
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
local latest = logFolder .. "Latest_"
local ext = ".log"
local lastLen = 0
local lastLevel = 1

local function box(box, info)
  lastLen = #box
  return string.format("[%s]: %s", box, info)
end

local function open(fname)
  local lname = latest .. fname .. ext
  if fs.exists(lname) then
    local f = io.open(lname, 'r')
    local name = f:read("*l")
    f:close()
    fs.move(lname, string.format(logFolder .. "%s" .. ext, name))
  end
  file = io.open(lname, 'w')
  file:write(os.date("%m_%d_%y-%H_%M_%S") .. "\n")
  file:flush()
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
  if isWriting then
    file:write(tostring(info) .. "\n")
    file:flush()
  end
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
  if logLevel == 1 then
    writeLog(box("INFO", info))
  end
  lastLevel = 1
end

function log.warn(warn)
  if logLevel < 3 then
    writeLog(box("WARN", warn))
  end
  lastLevel = 2
end

function log.err(err)
  writeLog(box("ERR ", err))
  lastLevel = 3
end

function log.open(fname)
  open(fname)
end

function log.close()
  close()
end

log = setmetatable(log, {
  __call = function(tbl, b, out, manualLevel)
    if b and not out then
      out = b
      b = string.rep(' ', lastLen)
    end
    if manualLevel then
      lastLevel = manualLevel
    end
    if lastLevel >= logLevel then
      writeLog(box(b, out))
    end
  end
})

return log
