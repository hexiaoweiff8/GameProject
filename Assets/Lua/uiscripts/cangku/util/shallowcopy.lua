-- 工具函数，用于浅拷贝数据
function table.shallowcopy( object )
    if object == nil then
        return nil
    end
    if type( object ) ~= "table" then
        return object
    end

    local shell = {}
    for k,v in pairs(object) do
        shell[k] = v
    end
    return shell
end

