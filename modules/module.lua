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
    depends = {"logger"},
    t = "all"
  },
  ["logger"] = {
    saveas = "/modules/logger.lua",
    location = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/modules/logger.lua",
    depends = {},
    t = "all"
  }
}

local initRequired = {
  "main",
  "moduleManager",
  "util",
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
      error(string.format("Failed to open file '%s' due to '%s'.", tostring(to), tostring(err2)), 2)
    end
  else
    error(string.format("Failed to connect to '%s' due to '%s'.", tostring(from), tostring(err)), 2)
  end
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
function module.update(mod)

end

function module.updateAll()

end

local function installerWorker(mod, action)

end

function module.install(mod)
  if type(mod) == "table" then
  elseif type(mod) == "string" then
  end
end

return module
