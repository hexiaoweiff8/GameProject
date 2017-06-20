
--[[
    属性数据表的工具类
    attribute_c
]]
local class = require("common/middleclass")
attributeUtil = class("attributeUtil")
--[[
    获取属性名称
    attributeId     属性ID
]]
function attributeUtil:getAttributeName(attributeId)
    return sdata_attribute_data:GetFieldV("AttributeName", attributeId)
end
--[[
    获取该属性的数值的符号（分为 % 和 无符号）
    attributeId     属性ID
]]
function attributeUtil:getAttributeSymbol(attributeId)
    return sdata_attribute_data:GetFieldV("Symbol", attributeId)
end

return attributeUtil