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
