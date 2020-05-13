--[[
  Proper name to be determined.
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

-- -- Information about ourself -- --
local urlPrefix = "https://raw.githubusercontent.com/Fatboychummy-CC/Compendium/master/"
local loggerSave = "modules/core/logger.lua"
local moduleSave = "modules/core/module.lua"
local utilSave   = "modules/core/util.lua"
local settingsSave = "/.syssettings"

local requirements = {
  loggerSave,
  moduleSave,
  utilSave
}

-- Download file
local function download(from, to)
  local h, err = http.get(from)
  if h then
    local data = h.readAll()
    h.close()

    local h2, err2 = io.open(to, 'w')
    if h2 then
      h2:write(data):close()
    else
      error(string.format("Failed to open file '%s' due to '%s'.", to, err2), 2)
    end
  else
    error(string.format("Failed to connect to '%s' due to '%s'.", from, err), 2)
  end
end
-- install requirements to run
for i = 1, #requirements do
  if not fs.exists(fs.getDir(shell.getRunningProgram()) .. "/" .. requirements[i]) then
    print(string.format("%s is not installed, installing.", requirements[i]))
    download(urlPrefix .. requirements[i], requirements[i])
  end
end

settings.load(settingsSave)
local logger = require("modules.core.logger")
logger.setMasterLevel(settings.get("system.logLevel") or 1)
local log = logger(settings.get("system.name") or "System")
log.info("Starting up...")


local function set(what, to)
  settings.set(what, to)
  print(string.format("%s --> %s", what, to))
  log("SETTINGS-SET", string.format("%s --> %s", what, to), 1)
end

local function get(what)
  local val = settings.get(what)
  print(string.format("%s is %s", what, val))
  log("SETTINGS-GET", string.format("%s is %s", what, val), 1)
  return val
end

if not get("system.initialRun") then
  print("Initial run has not occurred.")
  log.info("Initial run has not occured.")
  set("system.initialRun", true)
  set("system.logLevel", 1)
  set("system.name", "System")
  settings.save(settingsSave)
  print("Set up initial settings.")
  log.info("Initial settings set.")
end


local function run()
  local util = require("modules.core.util")

  -- determine computer type
  local sType = "computer"
  local aFlag = false
  if turtle then
    sType = "turtle"
  elseif commands then
    sType = "command"
  elseif pocket then
    sType = "pocket"
  end

  -- determine if advanced
  if term.isColor() then
    aFlag = true
  end

  -- log computer info
  log.info("Detected computer info:")
  log(string.format("  %s (%s)", sType, aFlag and "advanced" or "basic"))
  error("Ah fuck I can't believe you've done this.")
end

local ok, err = pcall(run)
if not ok then
  log.err("Uh oh! System crashed!")
  log("####", "#################################")
  log("Known data:")
  log(string.format("  %s", err))
  log("####", "#################################")
  printError(err)
end
logger.close()
