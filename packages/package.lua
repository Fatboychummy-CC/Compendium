--[[
  Resources.lua
  Contains locations of all required files.
]]

local packages = {
  ["main.lua"] = {
    location = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/main.lua",
    depends = {}
  },
  ["resources.lua"] = {
    location = "https://raw.githubusercontent.com/fatboychummy/Compendium/master/resources.lua"
    depends = {}
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
local package = {}

-- clone information about a package (or all packages)
function package.get(pack)
  if pack then
    -- grab only one
    return dCopy(packages[pack])
  end
  -- else grab all
  return dCopy(packages)
end

-- get dependencies for a package
function package.getDependencies(pack)
  -- if the package exists
  if packages[pack] then
    -- get the dependencies
    local cdepends = dCopy(packages[pack].depends)
    local depends = {}

    -- get the dependencies' dependencies
    for i = 1, #cdepends do
      depends[cdepends[i]] = package.getDependencies(cdepends[i])
    end

    -- return them
    return depends
  end

  -- no package
  error(string.format("No package %s in storage.", tostring(pack), 2)
end

return package
