local urlPrefix = "https://raw.githubusercontent.com/Fatboychummy-CC/Compendium/master"
return {
  ["main"] = {
    saveas = "/main.lua",
    location = urlPrefix .. "/main.lua",
    depends = {},
    t = "all"
  },
  ["moduleManager"] = {
    saveas = "/modules/core/module.lua",
    location = urlPrefix .. "/modules/core/module.lua",
    depends = {"logger", "util"},
    t = "all"
  },
  ["logger"] = {
    saveas = "/modules/core/logger.lua",
    location = urlPrefix .. "/modules/core/logger.lua",
    depends = {},
    t = "all"
  },
  ["util"] = {
    saveas = "/modules/core/util.lua",
    location = urlPrefix .. "/modules/core/util.lua",
    depends = {},
    t = "all"
  }
}
