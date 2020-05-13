--[[
  module.lua

  Handles module loading and etc
]]

-- if we are running this file with argument 'INFO', we're checking for updates.
local information = {
  _VERSION = "0.0.1",
  _BUILD = 1,
  _UPDATE_INFO = ""
}
local tArg = ...
if tArg == "INFO" then
  return information
end

local log = require("modules.core.logger")
local sources = {"https://raw.githubusercontent.com/Fatboychummy-CC/Compendium/master/source.lua"}
local data = {}

local module = {}

function module.updateSources()
  for i = 1, #sources do
    local source = sources[i]
    log.info(string.format("Updating source %s", source))
    local h = http.get(source)
    if h then
      local hdata = h.readAll()
      h.close()
      local sourceData, err = load(hdata, source)
      if sourceData then
        data[source] = sourceData
      else
        log.warn(err)
      end
    else
      log.warn(string.format("Failed to get source '%s'.", source)
    end
  end
end

function module.getData()
  return data
end

module.updateSources()
return module
