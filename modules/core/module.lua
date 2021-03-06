--[[
  module.lua

  Contains locations of all required files.
]]

-- if we are running this file with arguments, we're checking for updates.
local information = {
  _VERSION = "0.0.8",
  _BUILD = 8,
  _UPDATE_INFO = "Logging."
}
local tArg = ...
if tArg == "INFO" then
  return information
end

local urlPrefix = "https://raw.githubusercontent.com/Fatboychummy-CC/Compendium/master/"
local modules = {
  ["main"] = {
    saveas = "/main.lua",
    depends = {},
    t = "all"
  },
  ["moduleManager"] = {
    saveas = "/modules/core/module.lua",
    depends = {"logger", "util"},
    t = "all"
  },
  ["logger"] = {
    saveas = "/modules/core/logger.lua",
    depends = {},
    t = "all"
  },
  ["util"] = {
    saveas = "/modules/core/util.lua",
    depends = {},
    t = "all"
  }
}

local initRequired = {
  "main",
  "moduleManager",
}
local lastCheck = -1000

local log = fs.exists(modules.logger.saveas) and dofile(modules.logger.saveas)
            or setmetatable(
               {
                 info   = function(...) print(...) end,
                 warn   = function(...) print(...) end,
                 err    = function(...) print(...) end,
                 open   = function(...) print(...) end,
                 close  = function(...) print(...) end,
                 logLevel = function() end,
                 setWriting = function() end
               },
               {
                 __call = function(...) print(...) end,
               }
             )
local util = fs.exists(modules.util.saveas) and dofile(modules.util.saveas)

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
    return util and util.dCopy(modules[mod]) or modules[mod]
  end
  -- else grab all
  return util and util.dCopy(modules) or modules
end

local function dependencyWorker(mod)
  -- get the dependencies
  local cdepends = mod.depends
  local depends = {}

  -- get the dependencies' dependencies
  for i = 1, #cdepends do
    depends[cdepends[i]] = module.getDependencies(cdepends[i])
  end

  -- return them
  return depends
end
-- get dependencies for a module
function module.getDependencies(mod)

  if type(mod) == "table" then
    return dependencyWorker(mod)
  elseif type(mod) == "string" then
    -- if the module exists
    if modules[mod] then
      return dependencyWorker(modules[mod])
    end
  end

  -- no module
  error(string.format("No module %s in storage.", tostring(mod)), 2)
end

--[[
  installerWorker <table:module>, <string:action["install","uninstall","update"]>

  Uses a table of information to install, uninstall, or update a module
]]
local function installerWorker(tab, action, ignoreDependencies)
  module.status()
  local save = tab.saveas
  local loc = urlPrefix .. save:sub(2)
  local dependencies = tab.depends
  local installed = tab.installed
  local didAction = false
  log.info("Module information:")
  log(string.format("  Filename     : %s", save))
  log(string.format("  Location     : %s", loc))
  log(string.format("  Is installed?: %s", installed and "Yes" or "No"))
  log(string.format("  Dependencies :"))
  for i = 1, #dependencies do
    log(string.format("    %d: %s", i, dependencies[i]))
  end
  if #dependencies == 0 then
    log("    None.")
  end
  if ignoreDependencies then
    log("*** IGNORING DEPENDENCIES ***")
  end
  if action == "install" then
    log.info("Selected INSTALL")
    if not installed then
      log("Not installed, installing.")
      download(loc, save)
      didAction = true
    else
      log("Already installed.")
    end
    if not ignoreDependencies then
      local rdm = math.random(1, 100000)
      log("DPND", string.format("##### INSTALLING DEPENDENCIES %d #####", rdm))
      for i = 1, #dependencies do
        didAction = module.install(dependencies[i]) or didAction
      end
      log("DPND", string.format("#####    DONE DEPENDENCIES    %d #####", rdm))
    end
  elseif action == "uninstall" then
    log.info("Selected UNINSTALL")
    fs.delete(save)
    didAction = true
  elseif action == "update" then
    log.info("Selected UPDATE")
    fs.delete(save)
    didAction = installerWorker(tab, "install", ignoreDependencies)
    if not ignoreDependencies then
      local rdm = math.random(1, 100000)
      log("DPND", string.format("##### UPDATING DEPENDENCIES %d #####", rdm))
      for i = 1, #dependencies do
        didAction = module.update(dependencies[i]) or didAction
      end
      log("DPND", string.format("#####   DONE DEPENDENCIES   %d #####", rdm))
    end
  end
  return didAction
end

-- update a module
-- returns true if the module is ok
function module.update(mod, ignoreDependencies)
  if type(mod) == "table" then
    log.warn("Attempting direct update of module.")
    return installerWorker(mod, "update", ignoreDependencies)
  elseif type(mod) == "string" then
    log.info(string.format("Attempting update of module '%s'", mod))
    local d = module.get(mod)
    return installerWorker(d, "update", ignoreDependencies)
  end
end

function module.updateAll()
  for k, v in pairs(modules) do
    module.update(k, true)
  end
end

--[[
  install <table:module/string:module_name>

  Install a module
]]
function module.install(mod, ignoreDependencies)
  if type(mod) == "table" then
    log.warn("Attempting direct installation of module.")
    return installerWorker(mod, "install", ignoreDependencies)
  elseif type(mod) == "string" then
    log.info(string.format("Attempting installation of module '%s'", mod))
    local d = module.get(mod)
    return installerWorker(d, "install", ignoreDependencies)
  end
end

--[[
  uninstall <table:module/string:module_name>

  Uninstalls a module
]]
function module.uninstall(mod)
  if type(mod) == "table" then
    log.warn("Attempting direct uninstallation of module.")
    return installerWorker(mod, "uninstall")
  elseif type(mod) == "string" then
    log.info(string.format("Attempting uninstallation of module '%s'", mod))
    local d = module.get(mod)
    return installerWorker(d, "uninstall")
  end
end

local function loader(tab)
  if tab.saveas and fs.exists(tab.saveas) then
    return dofile(tab.saveas)
  else
    log.warn("Failed to load.")
  end
end

--[[
  load <module>

  loads a module much like require, but doesn't need paths.  Just names.
]]
function module.load(mod)
  if type(mod) == "table" then
    log.warn("Attempting direct load of module.")
    return loader(mod)
  elseif type(mod) == "string" then
    log.info(string.format("Attempting to load module '%s'.", mod))
    local d = module.get(mod)
    return loader(d)
  end
end

--[[
  setLogStatus <boolean:on/off>

  Sets the logging status
]]
function module.setLogStatus(tf, level, ext)
  level = level or 1
  ext = ext or ""
  if tf then
    log.open(ext and string.format("module-%s", ext) or "module")
    log.logLevel(level)
    log.setWriting(true)
    log.info("Started logging.")
  else
    log.close()
  end
end

--[[
  status

  updates the status of all modules.
]]
function module.status()
  log.info("Module status check started.")
  if lastCheck + 5 > os.clock() then
    log("Module status check aborted, status check was recently completed.")
    return
  end
  for k, v in pairs(modules) do
    log("STAT", string.format("  %s:", tostring(k)))
    if fs.exists(v.saveas) then
      log("    Installed.")
      local vFunc, err = loadfile(v.saveas)
      if not vFunc then
        error(string.format(
          "Failed to load file '%s' due to '%s'.",
          tostring(v.saveas),
          tostring(err)
        ))
      end
      local vData = vFunc("INFO")
      log(string.format("    Version: %s", vData._VERSION))
      log(string.format("    Build #: %d", vData._BUILD))
      v.version = vData._VERSION
      v.build = vData._BUILD
      v.installed = true
    else
      log("    Not installed.")
      v.installed = false
    end
  end
  log.info("All modules checked.")
  lastCheck = os.clock()
end

local function clone()
  --[[
    finalized module handler
  ]]
  local ret = {}

  --[[
    For each function in the module, collect its inputs and then pcall.
    If error, log it, else return what would normally be returned.

    Requires the module module, and loads the util and logger modules.
  ]]

  -- load modules (or replace them with non-erroring false-modules)
  local log = log or module.load("logger") or setmetatable({
    info  = function(...) print(...) end,
    warn  = function(...) print(...) end,
    err   = function(...) print(...) end,
    open  = function(...) print(...) end,
    close = function(...) print(...) end
  }, {__call = function(...) print(...) end})
  local util = util or module.load("util")

  -- clone everything
  for k, v in pairs(module) do
    if type(v) == "function" then
      ret[k] = function(...) -- handler function
        local inps = table.pack(...) -- pack inputs
        local dat = table.pack(pcall(v, table.unpack(inps, 1, inps.n))) -- pcall origin func

        -- if ok
        if dat[1] then
          return table.unpack(dat, 2, dat.n)
        end

        -- else error occured.
        log.err(string.format("Function call to '%s' failed.", k))
        log(tostring(dat[2]))
        log("DATA", "Function inputs:")
        -- output function inputs
        for i = 1, inps.n do
          log(string.format("%d: %s", i, util and util.simpleSerialize(inps[i]) or "Util not installed!"))
        end
        -- generate error
        error(dat[2], 2)
      end
    else
      -- output the module.
      ret[k] = v
    end
  end

  return ret
end



--[[
  Initial setup

  Install all dependencies for self.
]]
-- start init logging.
module.setLogStatus(true, 1, "Init")

local ret = clone()
ret.status()

log.info("Checking init modules")
local installFlag = false
for i = 1, #initRequired do
  log("CHCK", initRequired[i], 1)
  installFlag = ret.install(initRequired[i]) or installFlag
  log("DONE", initRequired[i] .. " complete.", 1)
  log("")
end
if installFlag then
  print("We've installed some new core modules and need to reboot.")
  log.warn("New core modules installed, rebooting.")
  ret.setLogStatus(false)
  os.sleep(3)
  os.reboot()
end

ret.setLogStatus(false)
return ret
