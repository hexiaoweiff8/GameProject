

--[[
敏感词工具
]]--
local class = require("common/middleclass")
subtlecodeUtil = class("subtlecodeUtil")

function subtlecodeUtil:GetSensitiveById(UniqueID)
    return sdata_subtlecode_data:GetFieldV("text",UniqueID)
end

function subtlecodeUtil:GetTable()
    return sdata_subtlecode_data
end