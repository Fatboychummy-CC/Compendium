--[[
  Resources.lua
  Contains locations of all required files.
]]

-- if we are running this file with arguments, we're checking for updates.
local information = {
  _VERSION = "0.0.2",
  _BUILD = 2,
  _UPDATE_INFO = ""
}
local tArg = ...
if tArg then
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

-- deep copy function, for protection of resources.
local function dCopy(x)
  -- if we aren't copying a table, return nothing.
  if type(x) ~= "table" then
    return
  end

  -- otherwise continue and recursively grab everything in the table
  local ret = {}
  for k, v in pairs(x) do
    if type(v) == "table" then
      -- if we find another table, recurse into it
      ret[k] = dCopy(v)
    else
      -- otherwise set whatever the value is to our value
      ret[k] = v
    end
  end
  return ret
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

return module
