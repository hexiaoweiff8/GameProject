---
--- Created by Administrator.
--- DateTime: 2017/7/4 11:45
---
local class = require("common/middleclass")
equipSuitUtil = class("equipSuitUtil")
--[[
    获取套装名称
    suitID     套装ID
]]
function equipSuitUtil:getEquipSuitName(suitID)
    return sdata_equipsuit_data:GetFieldV("SuitName", suitID)
end
--[[
    获取该属性的数值的符号（分为 % 和 无符号）
    attributeId     属性ID
]]
--function equipSuitUtil:getEquipSuitSymbol(suitID)
--    return sdata_attribute_data:GetFieldV("Symbol", suitID)
--end

return equipSuitUtil