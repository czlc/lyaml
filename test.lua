﻿package.path = package.path .. ";" .. "D:\\github\\czlc\\lyaml\\lib\\?.lua"
package.cpath = package.cpath .. ";" .. "D:\\github\\czlc\\lyaml\\product\\?.dll"
local function print_table(root)
	assert(type(root) == "table")
	local cache = {  [root] = "." }
	local ret = ""
	
	local function _new_line(level)
		local ret = ""
		ret = ret.."\n"
		for i = 1, level do
			ret = ret.."\t"
		end
		return ret
	end
	
	local function _format(value)
		if (type(value) == "string") then
			return "\""..value.."\""
		else
			return tostring(value)
		end
	end

	local function _enter_level(t, level, name)
		local ret = ""
		local _keycache = {}
		for k, v in ipairs(t) do
			ret = ret.._new_line(level + 1)
			if (cache[v]) then
					ret = ret.."["..tostring(k).."]".." = "..cache[v]..","
			elseif (type(v) == "table") then
					local newname = name.."."..tostring(k)
					cache[v] = newname
					ret = ret.."["..tostring(k).."]".." = ".."{"
					ret = ret.._enter_level(v, level + 1, newname)
					ret = ret.._new_line(level + 1)
					ret = ret.."},"
					
			else
					if (type(v) == "string") then
						ret = ret.."["..tostring(k).."]".." = ".."\""..v.."\""..","
					else
						ret = ret.."["..tostring(k).."]".." = "..tostring(v)..","
					end
			end
			_keycache[k] = true
		end
		
		for k, v in pairs(t) do
			if (not _keycache[k]) then
				ret = ret.._new_line(level + 1)
				if (cache[v]) then
					ret = ret.."[".._format(k).."]".." = "..cache[v]..","
				elseif (type(v) == "table") then
					local newname = name.."."..tostring(k)
					cache[v] = newname
					ret = ret.."[".._format(k).."]".." = ".."{"
					ret = ret.._enter_level(v, level + 1, newname)
					ret = ret.._new_line(level + 1)
					ret = ret.."},"
				else
					if (type(v) == "string") then
						ret = ret.."[".._format(k).."]".." = ".."\""..v.."\""..","
					else
						ret = ret.."[".._format(k).."]".." = "..tostring(v)..","
					end
				end
			end
		end
		return ret
	end
	
	ret = ret .. "{"	
	ret = ret .. _enter_level(root, 0, "")
	ret = ret .. "\n}\n"
	print(ret)
end

local src = [[
---
loot:
- - 1
  - 3
- - 2
  - 4
...


]]

local lyaml = require "lyaml"
print_table(lyaml.load(src,{ all = true }) )

--print(lyaml.dump({ { loot = {{1,3}, {2, 4}} } }))
