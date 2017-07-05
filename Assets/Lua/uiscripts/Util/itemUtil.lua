--[[
    物品数据表的工具类
    item_c
]]
local class = require("common/middleclass")
itemUtil = class("itemUtil")


--[[
    获取物品名称
    itemID  物品ID
]]
function itemUtil:getItemName(itemID)
    return sdata_item_data:GetFieldV("Name", itemID)
end

--[[
    获取物品Icon名称
    itemID  物品ID
]]
function itemUtil:getItemIcon(itemID)
    return sdata_item_data:GetFieldV("Icon", itemID)
end

return itemUtil