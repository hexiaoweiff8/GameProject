--[[
mem_a = {}
--mem_b = {}
--mem_c = {}
--mem_d = {}
--mem_e = {}
--mem_f = {}
--mem_g = {}
mem_a[1] = {}
local tab = mem_a[1]
for i=1,100000 do tab[i]="xxwsajf;sajfwekjjlljnnnm87808027304732904732947923747327032749327849328432840284028440804084048048304824083402849380483299" end  
--table.dump("_G",_G)
--]]

local MemSnapshot1 = nil;
local MemSnapshot2 = nil;

--创建快照
function GMemSnapshot()
    if MemSnapshot1==nil then
        MemSnapshot1 =  debug.MemSnapshot()
    else
        if MemSnapshot2==nil then
            MemSnapshot2 =  debug.MemSnapshot()
        else
            MemSnapshot1 = MemSnapshot2
            MemSnapshot2 =  debug.MemSnapshot()
        end
    end
end

 
--比对快照
function GMemSnapshotCompare()

    if MemSnapshot1==nil or MemSnapshot2==nil then
        print("至少需要两份快照")
        return
    end
    print("-----------------GMemSnapshotCompare----------------")
    local tab = debug.MemSnapshotCompare(MemSnapshot1,MemSnapshot2)
     for k, v in pairs(tab or {}) do
        print(v)
     end
    print("-----------------GMemSnapshotCompareEnd----------------")
end