--[[
    卡牌进阶相关数据表的工具类
    armycardquality_c
    armycardqualitycost_c
    armycardqualityshow_c
]]
local class = require("common/middleclass")
qualityUtil = class("qualityUtil")


--[[
    插槽装备状态
]]
qualityUtil.EquipState = {
    Enable_NotEnough= 0,  --未激活 材料不足
    Active = 1,           --已激活
    Enable_Enough = 2,    --未激活 有材料
}
--[[
    阶品票中的进阶升级属性字段名
]]
qualityUtil.qualityPropName={
    "CardQualityAttack",
    "CardQualityHP",
    "CardQualityDefense"
}

--[[
    获取卡牌进阶所提升的基础属性数值
    property   属性字段名
    cardId     卡牌ID
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getUpQualityAttribute( property ,cardId, qualityLv )
    -- body
    local uid = tonumber(string.format("%d%.2d",cardId,qualityLv))
    return sdata_armycardquality_data:GetFieldV(property, uid)
end

--[[
    获取卡牌进阶所需物品的id
    index      插槽位置index
    cardId     卡牌ID
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getItemID(index, cardId, qualityLv)
    local uid = tonumber(string.format("%d%.2d",cardId,qualityLv))
    return sdata_armycardquality_data:GetFieldV("ItemID"..index, uid)
end
--[[
    获取卡牌进阶所需物品的数量
    index      插槽位置index
    cardId     卡牌ID
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getItemNum(index, cardId, qualityLv)
    local uid = tonumber(string.format("%d%.2d",cardId,qualityLv))
    return sdata_armycardquality_data:GetFieldV("Num"..index, uid)
end

--[[
    获取每个插槽对应属性的ID
    index      插槽位置index
    cardId     卡牌ID
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getSlotAttributeID(index, cardId, qualityLv)
    local uid = tonumber(string.format("%d%.2d",cardId,qualityLv))
    return sdata_armycardquality_data:GetFieldV("CardEquip"..index, uid)
end

--[[
    获取每个插槽对应属性数值
    index      插槽位置index
    cardId     卡牌ID
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getSlotAttributePoint(index, cardId, qualityLv)
    local uid = tonumber(string.format("%d%.2d",cardId,qualityLv))
    return sdata_armycardquality_data:GetFieldV("Point"..index, uid)
end

--[[
    获取卡牌阶品升级至该等级所需的金币
    qualityLv   卡牌阶品等级
]]
function qualityUtil:getUpQualityNeedGold(qualityLv)
    -- body
    return sdata_armycardqualitycost_data:GetV(sdata_armycardqualitycost_data.I_Gold, qualityLv) 
end

--[[
    获取卡牌阶品升级至该等级所需卡牌等级
    qualityLv   卡牌阶品等级
]]
function qualityUtil:getLimitLvFromQualityLv(qualityLv)
    -- body
    return sdata_armycardqualityshow_data:GetFieldV("CardLevel", qualityLv)
end

--[[    
    获得卡牌显示名(名+品质等级)
    cardId     卡牌ID
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getCardName_With_Quality(cardId, qualityLv)
    local name = cardUtil:getCardName(cardId)
    if qualityLv ~= nil then
        local plusNum = sdata_armycardqualityshow_data:GetFieldV("PlusNum", qualityLv)--@1
        if plusNum>0 then 
            name = string.format("%s+%d",name,plusNum)
        end
    end
    return name
end
--[[
    根据品阶获得该品阶的颜色
    qualityLv  卡牌阶品等级
]]
function qualityUtil:getColor_With_Quality(qualityLv)
    local colorType = sdata_armycardqualityshow_data:GetFieldV("QualityColor", qualityLv)
    if colorType == 1 then
        Color = Color(255/255,255/255,255/255,255/255)--白
    elseif  colorType == 2 then
         Color = Color(0/255,128/255,0/255,255/255)--绿
    elseif  colorType == 3 then
         Color = Color(0/255,0/255,255/255,255/255)--蓝
    elseif  colorType == 4 then
         Color = Color(128/255,0/255,128/255,255/255)--紫
    elseif  colorType == 5 then
         Color = Color(255/255,165/255,0/255,255/255)--橙
    elseif  colorType == 6 then
         Color = Color(255/255,0/255,0/255,255/255)--红
    end
    return Color
end

return qualityUtil