--[[
  util.lua

  Contains some utilities.
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

local util = {}

function util.serialize(tbl)

end

return util
