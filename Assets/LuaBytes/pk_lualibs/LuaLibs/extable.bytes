--深复制
 function table.deepCopy(object)
      local lookup_table = {}
      local function _copy(object)
          if type(object) ~= "table" then
              return object
         elseif lookup_table[object] then
             return lookup_table[object]
         end
         local new_table = {}
         lookup_table[object] = new_table
         for index, value in pairs(object) do
             new_table[_copy(index)] = _copy(value)
         end
         return setmetatable(new_table, getmetatable(object))
     end
     return _copy(object)
 end
--[[
function table.deepCopy(st)
     
	local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            if v["DebugRefd"]==nil then
                v["DebugRefd"] = 1
                tab[k] = table.deepCopy(v,refd)
                v["DebugRefd"] = nil
            end
        end
    end
     

    return tab
end--]]


--浅复制
function table.shallowCopy(st)
	local tab = {}
    for k, v in pairs(st or {}) do
        tab[k] = v
    end
    return tab
end

function table.foreach(tb,func)
	for k, v in pairs(tb or {}) do
		func(k,v)
	end
end

--- <summary>
--- 表中是否存在item
--- </summary>
function table.hasItem(tb)
	for k, v in pairs(tb or {}) do
		return true
	end
	return false
end

--- <summary>
--- 获取表中的首个item
--- </summary>
function table.firstItem(tb)
	for k, v in pairs(tb or {}) do
		return k,v
	end
	return nil,nil
end

function table.dump(dbgname,tb)
    debug.LogDebug( string.sformat("-----table.dump---- dbgname:{0} len:{1}\n",dbgname, #tb ) )
    for k, v in pairs( tb) do 
         debug.LogDebug(  string.sformat("{0}\t{1}\n",k,v) )
    end
end


--- <summary>
--- 清空表中所有元素
--- </summary>
 function table.clear(tb)
    local  keys = {};
    for k, v in pairs( tb) do 
        table.insert(keys,k)
    end

    for _,k in pairs( keys) do 
        tb[k] = nil
    end
 end