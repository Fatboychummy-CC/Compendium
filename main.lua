--[[
  Proper name to be determined.
]]

-- -- Information about ourself -- --
local mainFileLocation = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/main.lua"
local packageFileLocation = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/packages/package.lua"

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
