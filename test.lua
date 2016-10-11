package.path = package.path .. ";" .. "D:\\github\\czlc\\lyaml\\lib\\?.lua"
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
local l = [[



tax  : 251.42
total: 4443.52
]]
local src = [[
invoice: 34843
date   : 2001-01-23
comments: >
    Late afternoon is best.
    Backup contact is Nancy
    Billsmer @ 338-4338.
bill-to: &id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
]]
      
local lyaml = require "lyaml"
print_table(lyaml.load(src))