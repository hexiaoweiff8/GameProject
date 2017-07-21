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
    获取套装Icon
    suitID     套装ID
]]
function equipSuitUtil:getEquipSuitIcon(suitID)
    return sdata_equipsuit_data:GetFieldV("SuitIcon", suitID)
end
--[[
    获取套装属性所需的装备数量表
    suitID     套装ID
]]
function equipSuitUtil:getSuitNumList(suitID)
    local list = {}
    for i = 1, Const.EQUIP_ONBODY_MAX_NUM do
        if sdata_equipsuit_data:IsHaveCloumName("SuitEffect"..i) then
            if sdata_equipsuit_data:GetFieldV("SuitEffect"..i, suitID) ~= -1 then
                table.insert(list, i)
            end
        end
    end
    return list
end

--[[
    获取套装属性最少装备数量
    suitID     套装ID
]]
function equipSuitUtil:getMinSuitEquipNum(suitID)
    local list = equipSuitUtil:getSuitNumList(suitID)
    if list and #list ~= 0 then
        return list[1]
    end
    return nil
end
--[[
    获取套装属性最多装备数量
    suitID     套装ID
]]
function equipSuitUtil:getMaxSuitEquipNum(suitID)
    local list = equipSuitUtil:getSuitNumList(suitID)
    if list and #list ~= 0 then
        return list[#list]
    end
    return nil
end


--[[
    获取套装属性的ID
    suitID      套装ID
    equipNum    套装装备数量
]]
function equipSuitUtil:getSuitAttributeID(suitID, equipNum)
    if sdata_equipsuit_data:IsHaveCloumName("SuitEffect"..equipNum) then
        local id = sdata_equipsuit_data:GetFieldV("SuitEffect"..equipNum, suitID)
        if id ~= -1 then
            return id
        end
    end
    logWarnings("equipSuitUtil:getSuitAttributeID error!!!")
    return nil
end
--[[
    获取套装属性的值
    suitID      套装ID
    equipNum    套装装备数量
]]
function equipSuitUtil:getSuitAttributeValue(suitID, equipNum)
    if sdata_equipsuit_data:IsHaveCloumName("Effect"..equipNum.."Point") then
        local id = sdata_equipsuit_data:GetFieldV("Effect"..equipNum.."Point", suitID)
        if id ~= -1 then
            return id
        end
    end
    logWarnings("equipSuitUtil:getSuitAttributeID error!!!")
    return nil
end

--[[
    获取套装属性字符串表

]]
function equipSuitUtil:getEquipSuitAttrbuteStringList(SuitID)
    local list = {}

    local suitNumList = equipSuitUtil:getSuitNumList(SuitID)

    for i = 1, #suitNumList do
        local suitAttrID = equipSuitUtil:getSuitAttributeID(SuitID, suitNumList[i])
        local suitAttrPoint = equipSuitUtil:getSuitAttributeValue(SuitID, suitNumList[i])
        local suitName = attributeUtil:getAttributeName(suitAttrID)
        local suitSymbol = attributeUtil:getAttributeSymbol(suitAttrID)


        local suitStr = string.format(stringUtil:getString(0xFE19), suitNumList[i])
            ..suitName.."+"..suitAttrPoint..suitSymbol

        table.insert(list, suitStr)
    end
    return list
end


return equipSuitUtil