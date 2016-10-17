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
---
type:item
data:
-   id          : 1
    name        : shortsword
    price       : 28
    iron        : 2

---
type:buildings
iron_mine_grade: &grade_1
    -   level       : 1
        cost        : 0
        boost       : 10
data:
-   id          : 1
    name        : iron_mine
    grade       : *grade_1
---
type: furniture
]]
local src = [[
---
type: items
data:
  剑:    
  - level: 1
    price: 28
    resources:
      铁: 2

  - level: 2
    price: 32
    resources:
      铁: 2
      木: 2
    components:
      剑.1.绿: 2

---
type: buildings
铁矿级别: &iron_mine_grade
- level: 2
  cost: 30
  boost: 10

- level: 3
  cost: 30
  boost: 10

data:
- name: 铁矿
  rate_per_hour: 80
  grade: *iron_mine_grade

---
type: furniture
道具容器级别: &的
- level: 2
  cost: 20
  storage: 8

- level: 3
  cost: 20
  storage: 10

资源容器级别: &resource_storage_grade
- level: 2
  cost: 20
  storage_capacity: 8
  refill_capacity: 10

- level: 3
  cost: 20
  storage_capacity: 10
  refill_capacity: 12

data:
- name: 木柜
  storage: 8
  grade: *item_storage_grade
  
- name: 铁桶
  storage_capacity: 8
  refill_capacity: 10
  grade: *resource_storage_grade
]]

local lyaml = require "lyaml"
print_table(lyaml.load(src,{ all = true }) )