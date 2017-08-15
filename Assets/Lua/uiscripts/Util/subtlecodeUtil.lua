

--[[
敏感词工具
]]--
local class = require("common/middleclass")
subtlecodeUtil = class("subtlecodeUtil")



function subtlecodeUtil:GetSensitiveById(UniqueID)
    return sdata_subtlecode_data:GetFieldV("text",UniqueID)
end

function subtlecodeUtil:FitWord(str)
    ----Boolean WordFilter.filter(String content,String& result_str,Int32 filter_deep,Boolean check_only,Boolean bTrim,String replace_str)
    local result_str
    result_str = WordFilter.filter(str,result_str,3,false,true,"*")
    return result_str
end

function subtlecodeUtil:GetTable()
    return sdata_subtlecode_data.mData.body
end
--吧Lua的本地敏感词库传给C#
function InitCiKu()
    --local socket = require "socket"
    --local s = socket.gettime()
    for index=1,#(subtlecodeUtil:GetTable()) do
        local str = subtlecodeUtil:GetSensitiveById(index)
        WordFilter.AddStirngToFilters(str)
    end
    --local e = socket.gettime()
    --print("添加敏感词用时："..e-s.." ms")
end

InitCiKu()