---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:33
---

local class = require("common/middleclass")
local comPropty_model = class("comPropty_model", equip_model)


function comPropty_model:getBasicPropsList()
    local list = {}
    for i = 1, #self.equipOnBodyList do
        if self.equipOnBodyList[i] ~= -1 then
            local equip = self:getEquipByOnlyID(self.equipOnBodyList[i])
            if list[equip.fst_attr] then
                list[equip.fst_attr] = list[equip.fst_attr] + EquipUtil:getMainAttributeValue(equip)
            else
                list[equip.fst_attr] = EquipUtil:getMainAttributeValue(equip)
            end
            for _,v in ipairs(equip.sndAttr) do
                if list[v.id] then
                    list[v.id] = list[v.id] + v.val
                else
                    list[v.id] = v.val
                end
            end
        end
    end
    return list
end

function comPropty_model:getSuitList()
    local list = {}
    for i = 1, #self.equipOnBodyList do
        if self.equipOnBodyList[i] ~= -1 then
            local equip = self:getEquipByOnlyID(self.equipOnBodyList[i])
            if list[equip.SuitID] then
                list[equip.SuitID] = list[equip.SuitID] + 1
            else
                list[equip.SuitID] = 1
            end
        end
    end
    return list
end

function comPropty_model:Math_abs(value)
    if value < 0 then
        return -value
    else
        return value
    end
end

return comPropty_model