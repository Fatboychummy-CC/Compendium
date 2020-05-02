--[[
  Resources.lua
  Contains locations of all required files.
]]

-- if we are running this file with arguments, we're checking for updates.
local information = {
  _VERSION = "0.0.6",
  _BUILD = 6,
  _UPDATE_INFO = "This is an example of the update notes that may be displayed when attempting to update."
}
local tArg = ...
if tArg == "INFO" then
  return information
end

local modules = {
  ["main"] = {
    saveas = "/main.lua",
    location = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/main.lua",
    depends = {},
    t = "all"
  },
  ["moduleManager"] = {
    saveas = "/modules/module.lua",
    location = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/modules/module.lua",
    depends = {},
    t = "all"
  }
}

local initRequired = {
  "main",
  "moduleManager",
  "util"
}

local function dPrint(..., debugTo)
  if debugTo then
    debugTo(...)
  end
end

-- Download file
local function download(from, to, debugTo)

  dPrint(string.format("Connecting to %s...", from), debugTo)
  local h, err = http.get(from)
  if h then
    dPrint("Connected.", debugTo)
    local data = h.readAll()
    h.close()

    dPrint(string.format("Opening file %s for writing...", to), debugTo)
    local h2, err2 = io.open(to, 'w')
    if h2 then
      dPrint("OK. Writing...", debugTo)
      h2:write(data):close()
      dPrint("Wrote data to file.", debugTo)
    else
      error(string.format("Failed to open file '%s' due to '%s'.", tostring(to), tostring(err2)), 2)
    end
  else
    error(string.format("Failed to connect to '%s' due to '%s'.", tostring(from), tostring(err)), 2)
  end
  dPrint("Done.", debugTo)
end

-- Stuff that is returned
local module = {}

-- clone information about a module (or all modules)
function module.get(mod)
  if mod then
    -- grab only one
    return dCopy(modules[mod])
  end
  -- else grab all
  return dCopy(modules)
end

-- get dependencies for a module
function module.getDependencies(mod)
  -- if the module exists
  if modules[mod] then
    -- get the dependencies
    local cdepends = dCopy(modules[mod].depends)
    local depends = {}

    -- get the dependencies' dependencies
    for i = 1, #cdepends do
      depends[cdepends[i]] = module.getDependencies(cdepends[i])
    end

    -- return them
    return depends
  end

  -- no module
  error(string.format("No module %s in storage.", tostring(mod)), 2)
end

-- update a module
-- returns true if the module is ok
function module.update(mod, force)

end

function module.updateAll(force)

end

return module
