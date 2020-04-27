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

-- -- -- Utility functions which cannot be loaded externally -- -- --

-- get user input
local function request(question, wrong, answers)
  local flag = false
  while true do
    print(flag and wrong or question)
    local input = string.lower(io.read())
    for i = 1, #answers do
      if input == answers[i] then
        return input
      end
    end
  end
end

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


local function doMove(tempFile, saveTo)
  fs.delete(saveTo)
  fs.move(tempFile, saveTo)
end
-- update a module
function module.update(mod, force)
  -- determine if a module was passed or a string name of module was passed
  local p = type(mod) == "table" and mod
         or type(mod) == "string" and module.get(mod)
         or error(string.format("Bad argument #1, expected string or table, got %s", type(mod)))
  if p then
    local tempFileN = string.format("/.temp%d", math.random(1, 100000))
    fs.delete(tempFileN)
    download(p.location, tempFileN)
    local netInfo = loadfile(tempFileN)(true)
    local currentInfo = loadfile(p.saveas)(true)
    if netInfo._BUILD > currentInfo._BUILD then
      if force then
        doMove(tempFileN, p.saveas)
      else
        local ans = request(
          string.format("Would you like to update file '%s'?", p.saveas),
          "Please answer yes or no.",
          {"yes", "no", "y", "n"}
        )
        if ans == "y" or ans == "yes" then
          doMove(tempFileN, p.saveas)
        end
      end
    end
  else
    error(string.format("Module '%s' does not exist!", tostring(mod)), 2)
  end
end

return module
