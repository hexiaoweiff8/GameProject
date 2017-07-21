
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
    if attributeId == 1 then
        attributeId = 10001
    end
    return sdata_attribute_data:GetFieldV("AttributeName", attributeId)
end
--[[
    获取该属性的数值的符号（分为 % 和 无符号）
    attributeId     属性ID
]]
function attributeUtil:getAttributeSymbol(attributeId)
    if attributeId == 1 then
        attributeId = 10001
    end
    return sdata_attribute_data:GetFieldV("Symbol", attributeId)
end
--[[
    获取装备属性的最大值
    planId  装备属性策略id
    attributeId  属性Id
]]
function attributeUtil:getAttributeMaxValue(planId, attributeId)
    local uid = tonumber(planId..attributeId)
    return sdata_attributeplan_data:GetFieldV("Max", uid)
end
--[[
    获取装备属性的最小值
    planId  装备属性策略id
    attributeId  属性Id
]]
function attributeUtil:getAttributeMinValue(planId, attributeId)
    local uid = tonumber(planId..attributeId)
    return sdata_attributeplan_data:GetFieldV("Min", uid)
end

return attributeUtil