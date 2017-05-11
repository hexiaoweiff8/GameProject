
--重绑所有ui事件
function debug.ReBindUIEvent()
	local wnds = GameObject.Find("/wnds")
	CMUIEvent.ReBindAll(wnds)
end

--输出所有全局变量
function debug.DumpGlobalVar(dbgName)
	table.dump(dbgName,_G)
end


--MemSnapshot = {}
--MemSnapshotIdx = 1

--生成lua内存快照
function debug.MemSnapshot()
    return table.deepCopy(_G)
end

--对比两次快照，找出新增
function debug.MemSnapshotCompare(Snapshot1,Snapshot2)
    local lookup_table = {}

    local function _MemSnapshotCompare(Snapshot1,Snapshot2,Path)
        local  re = {}
        
        
        --路径
        for k, v in pairs(Snapshot2 or {}) do        
            if type(v) ~= "table" then--普通值
                if Snapshot1[k]==nil then --旧快照中不存在
                   table.insert(re, Path.."/" .. k )
                end
            else--表
                if not lookup_table[v] then--如果是记录内存快照的表，则跳过比对
                    lookup_table[v] = 1

                    local tmpTab = {}

                    local p = Path .. "/[tab]" .. k 
                    if Snapshot1[k]==nil then --旧快照中不存在
                        --table.insert(re, p)
                        tmpTab = _MemSnapshotCompare({},v,p)
                    else--存在在旧快照中
                        if type(Snapshot1[k])~= "table" then --旧快照中不是表
                            tmpTab = _MemSnapshotCompare({},v,p)
                        else
                            tmpTab = _MemSnapshotCompare(Snapshot1[k],v,p)
                        end
                    end
                    for k1, v1 in pairs(tmpTab) do
                        table.insert(re, v1 )
                    end
                end
            end
        end
        return re
    end
    return _MemSnapshotCompare(Snapshot1,Snapshot2,"")
end 