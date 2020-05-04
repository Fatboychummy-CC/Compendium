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
local moduleFileLocation = urlPrefix .. "modules/core/module.lua"
local moduleFileSave = "/modules/core/module.lua"

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

--[[
  Core init.
  Init globals and locals which modules have access to (Too lazy to make a different way)
]]
local module = fs.exists(moduleFileSave) and require(moduleFileSave:sub(1, -5))
--[[
  getModules

  Returns the modules file
  If the modules file is not found, download it.
]]
function _G.getModules()
  if not module then
    local h = http.get(moduleFileLocation)
    if h then
      local dat = h.readAll()
      h.close()
      local h2 = io.open(moduleFileSave, 'w')
      h2:write(dat):close()
      print("Main module has been installed, rebooting.")
      os.sleep(3)
      os.reboot()
    else
      error(string.format("Failed to get file from %s", moduleFileLocation))
    end
  end
  return module and module.load
end

getModules()
