--[[
  logger.lua

  Logs stuff
]]

-- if we are running this file with arguments, we're checking for updates.
local information = {
  _VERSION = "0.0.5",
  _BUILD = 5,
  _UPDATE_INFO = ""
}
local tArg = ...
if tArg == "INFO" then
  return information
end

local logFolder = fs.combine(shell.dir(), "logs")
local latest = "LATEST"
local ext = ".log"
local masterLevel = 1
local file
local log = {}

--[[
  writeLog

  Writes a log to file.
]]
local function writeLog(info, level)
  --[[
    level == 1 and masterLevel == 1 is ok
    level == 1 and masterLevel == 2 is not ok
  ]]
  if level < masterLevel then
    return
  end

  -- open the log if it's not opened.
  if not file then
    log.open()
  end

  -- write the information, and flush it to the file.
  file:write(string.format("%s%s%s%s%s", "[", os.date("%H:%M:%S"), "]", tostring(info), "\n"))
  file:flush()
end


--[[
  open()

  Opens the log file for writing.
]]
function log.open()
  -- if already open, close it then reopen
  if file then
    log.close()
  end
  local lname = fs.combine(logFolder, latest .. ext)

  -- if the latest log exists
  if fs.exists(lname) then
    -- get the time it was written
    local f = io.open(lname, 'r')
    local name = f:read("*l")
    f:close()
    -- rename the file to be the time of writing
    fs.move(lname, fs.combine(logFolder, name .. ext))
  end
  -- open the log and write what time it is when written
  file = io.open(lname, 'w')
  file:write(os.date("%m_%d_%y-%H_%M_%S") .. "\n")
  file:flush()
end

--[[
  close()

  Closes the log file, if the file is not opened, does nothing.
]]
function log.close()
  if file then
    writeLog("[Log]: Log exited gracefully.", 1)
    file:close()
    file = nil
  end
end

--[[
  setMasterLevel(<lvl:int[0,1,2,3]>)

  Sets the master log level (overrides each module's log level if module log level is below)

  1: info/warn/error
  2: warn/error
  3: error only
]]
function log.setMasterLevel(lvl)
  if lvl == 1 or lvl == 2 or lvl == 3 then
    masterLevel = lvl
  end
end

local function box(module, label, line)
  return string.format("[%s][%s]: %s", module, label, line)
end

log = setmetatable(
  log,
  {
    __call = function(tbl, initName)
      local module = {}
      local lastLevel = 1
      local lastLen = 0
      local name = initName

      function module.info(info)
        lastLevel = 1
        lastLen = 4
        writeLog(box(name, "INFO", info), 1)
      end

      function module.warn(warn)
        lastLevel = 2
        lastLen = 4
        writeLog(box(name, "WARN", warn), 2)
      end

      function module.err(err)
        lastLevel = 3
        lastLen = 4
        writeLog(box(name, "ERR ", err), 3)
      end

      module = setmetatable(module, {
        __call = function(tbl, label, line, manualLevel)
          if label and not line then
            line = label
            label = string.rep(' ', lastLen)
          end
          if manualLevel then
            lastLevel = manualLevel
          end
          lastLen = #label

          writeLog(box(name, label, line), lastLevel)
        end
      })

      module.info("Connected.")
      return module
    end
  }
)

return log
