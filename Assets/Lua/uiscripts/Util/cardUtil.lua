
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
    根据卡牌ID获取卡牌描述
    cardId  卡牌ID
]]
function cardUtil:getCardDes(cardId)
    return sdata_armycardbase_data:GetFieldV("Des",cardId)
end
--[[
    根据卡牌ID获取卡牌模型单位数量
    cardId  卡牌ID
]]
function cardUtil:getCardArmyUnit(cardId)
    return sdata_armycardbase_data:GetFieldV("ArmyUnit",cardId)
end
--[[
    获取卡牌升至该级所需的经验值
    cardLv  卡牌等级
]]
function cardUtil:getNeedExp(cardLv)
    return sdata_armycardexp_data:GetFieldV("CardExp",cardLv)
end

--[[
    获取卡牌技能ID
    cardId  卡牌ID
    index   技能index
]]
function cardUtil:getSkillID(cardId, index)
    local uid = tonumber(string.format("%d%.3d",cardId,1))
    local value = sdata_armybase_data:GetFieldV("Skill"..tostring(index), uid)
    return value
end

--[[
    获取卡牌每一等级的各个属性的实际数值
    property    属性字段名
    cardId      卡牌id
    cardLv      卡牌等级
]]
function cardUtil:getCardProp(property, cardId, cardLv)
    local uid = tonumber(string.format("%d%.3d",cardId,cardLv))
    local value = sdata_armybase_data:GetFieldV(property, uid)
    return value
end

--[[
    获取卡牌每一等级的各个属性的显示数值
    property    属性字段名
    cardId      卡牌id
    cardLv      卡牌等级
]]
function cardUtil:getCardPropValue(property, cardId, cardLv)
    local uid = tonumber(string.format("%d%.3d",cardId,cardLv))
    if property == "ArmyUnit" then
        local value = sdata_armycardbase_data:GetFieldV(property, cardId)
        return value
    elseif property == "RangeType" or
    property == "ArmyType" or
    property == "GeneralType" or
    property == "IsCreature" or
    property == "AimGeneralType" or
    property == "AttackType" then
        local value = sdata_armybase_data:GetFieldV(property, uid)
        local stringID = tonumber(Const.CARD_PROP_NAME_TO_STRING_ID[property]..value)
        return stringUtil:getString(stringID)
    else
        local value = math.floor(sdata_armybase_data:GetFieldV(property, uid))
        return value
    end
end

--[[
    获取属性名称
    property    字段名
]]
function cardUtil:getCardPropName(property)
    return stringUtil:getString(Const.CARD_PROP_NAME_TO_STRING_ID[property])
end


--[[
    获取创建模型的参数
    cardId      卡牌id
    cardLv      卡牌等级
]]
function cardUtil:GetCreateModelParams(cardId,cardLv)
    local KEY = tonumber(string.format("%d%.3d",cardId,cardLv))
    return sdata_armybase_data:GetFieldV("Pack",KEY), sdata_armybase_data:GetFieldV("Prefab",KEY)
end

--[[
    获取卡牌兵种
    cardId  卡牌id
]]
function cardUtil:getCardArmyType(cardId)
    --return cardId % 101000
    return 1
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