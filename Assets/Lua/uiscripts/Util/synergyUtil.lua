
--[[
    卡牌协同相关数据表的工具类（协同等级功能，尚未开放，后期添加）
    armycardunion_c
    armycardunioncost_c
]]

local class = require("common/middleclass")
synergyUtil = class("synergyUtil")

--[[
    获取各个协同所增加的属性id
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getSynergyAttribute(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("UnionAttribute%d", index),uid)
end

--[[
    获取各个协同所增加的属性数值
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getSynergyPoint(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("Point%d", index),uid)
end
--[[
    获取各个协同升级所需星级
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getRequireCardStar(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("RequireCardStar%d", index),uid)
end
--[[
    获取各个协同升级所需卡牌等级
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getRequireCardLevel(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("RequireCardLevel%d", index),uid)
end
--[[
    获取各个协同升级所需卡牌阶品等级
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getRequireCardQuality(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("RequireCardQuality%d", index),uid)
end


--[[
    获取卡牌协同附加属性ID
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getSynergyAttributeAdd(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("UnionAttributeAdd%d", index),uid)
end

--[[
    获取卡牌协同附加属性的数值
    cardId      卡牌id
    index       协同Index（第几个协同卡牌）
    synergyLv   协同等级
]]
function synergyUtil:getSynergyAddPoint(cardId,index,synergyLv)
    local uid = tonumber(string.format("%d%.2d",cardId,1))
    return sdata_armycardunion_data:GetFieldV(string.format("AddPoint%d", index),uid)
end

--[[
    获取协同升级至改等级所需的金币数量
    synergyLv   协同等级
]]
function synergyUtil:getNeedGold(synergyLv)
    return sdata_armycardunioncost_data:GetFieldV("Gold",synergyLv)
end
--[[
    获取协同升级至改等级所需的兵牌数量
    synergyLv   协同等级
]]
function synergyUtil:getNeedCoin(synergyLv)
    return sdata_armycardunioncost_data:GetFieldV("Coin",synergyLv)
end


return synergyUtil