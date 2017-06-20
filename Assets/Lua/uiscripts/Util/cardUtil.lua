
--[[
    卡牌信息相关表的工具类
    armycardbase_c
    armycardexp_c
    armybase_c
    kezhi_c
]]
local class = require("common/middleclass")
cardUtil = class("cardUtil")

--[[
    根据卡牌ID获取卡牌名称
    cardId  卡牌ID
]]
function cardUtil:getCardName(cardId)
    return sdata_armycardbase_data:GetFieldV("Name", cardId)
end
--[[
    根据卡牌ID获取卡牌IconID
    cardId  卡牌ID
]]
function cardUtil:getCardIcon(cardId)
    return sdata_armycardbase_data:GetFieldV("IconID", cardId)
end
--[[
    根据卡牌ID获取卡牌价值
    cardId  卡牌ID
]]
function cardUtil:getTrainCost(cardId)
    return sdata_armycardbase_data:GetFieldV("TrainCost",cardId)
end

--[[
    获取卡牌升至该级所需的经验值
    cardLv  卡牌等级
]]
function cardUtil:getNeedExp(cardLv)
    return sdata_armycardexp_data:GetFieldV("CardExp",cardLv)
end

--[[
    获取卡牌每一等级的各个属性的数值
    property    属性字段名
    cardId      卡牌id
    cardLv      卡牌等级
]]
function cardUtil:getCardProperty(property, cardId, cardLv)
    if cardId then 
        local uid = tonumber(string.format("%d%.3d",cardId,cardLv))
        return sdata_armybase_data:GetFieldV(property, uid)
    end
end



--[[
    获取卡牌兵种
    cardId  卡牌id
]]
function cardUtil:getCardArmyType(cardId)
    return cardId % 101000
end
--[[
    获取克制关系信息,后期要改
    property    属性字段名
    armyType    兵种类型id
]]
function cardUtil:getSuppressInfo(property,armyType)
    return sdata_kezhi_data:GetFieldV(property, armyType)
end

return cardUtil