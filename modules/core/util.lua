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

function util.simpleSerialize(tbl)
  local str = ""

  -- if we have a table
  if type(tbl) == "table" then
    str = str .. "{" -- opening bracket

    -- for each entry in the table
    for k, v in pairs(tbl) do
      -- tostring the key
      -- check if value is table, string, or function
        -- if table, recurse
        -- if string, add quotes
        -- if function, state "func"
      -- format: "[key] = value"
      str = str .. string.format(
        type(k) == "string" and '["%s"] = %s,' or "[%s] = %s,",
        tostring(k),
        type(v) == "table" and util.simpleSerialize(v)
          or type(v) == "string" and string.format('"%s"', v)
          or type(v) == "function" and "func"
          or tostring(v)
      )
    end
    str = str .. "}" -- closing bracket
  else
    -- If we're attempting to serialize something that is not a table, just add
    -- quotes to it if it is a string, or say "func" if it is a func
    -- else just return it but tostring'd
    return type(tbl) == "string" and string.format('"%s"', tbl)
           or type(tbl) == "function" and "func"
           or tostring(tbl)
  end

  return str
end

function util.dCopy(x)
  local ret = {}
  for k, v in pairs(x) do
    if type(v) == "table" then
      ret[k] = util.dCopy(v)
    else
      ret[k] = v
    end
  end
  return ret
end

--[[
  tempCreate

  Creates a temporary file and returns the name and file handle for it.
]]
function util.tempCreate(mode)
  -- if the tmp folder doesnt exist, easy.
  if not fs.isDir("/tmp/") then
    return "/tmp/1.tmp", io.open("/tmp/1.tmp", mode)
  end

  local fname = "/tmp/%d.tmp"
  local cname = fname:format(1)
  local i = 1

  -- iterate through each file until it no longer exists
  repeat
    local nomatch = false
    if fs.exists(cname) then
      i = i + 1
      cname = fname:format(i)
    else
      nomatch = true
    end
  until nomatch

  return cname, io.open(cname, mode)
end

return util
