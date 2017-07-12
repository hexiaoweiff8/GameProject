---
--- Created by Administrator.
--- DateTime: 2017/6/30 17:55
---
local class = require("common/middleclass")
local equipOnBody_model = class("equipOnBody_model",equip_model)


local _bestEquipList = {}

---
---获取最好的未损坏的装备
---
function equipOnBody_model:getBestEquipIDList()
    local bestEquips = {}
    for equipType = 1, Const.EQUIP_TYPE_NUM do
        local list = self.equipListByType[equipType]
        if #list ~= 0 then
            for i = 1, #list do
                if list[i].isBad ~= 1 then
                    table.insert(bestEquips, list[i].id)
                    table.insert(_bestEquipList, list[i])
                    break
                end
            end
        end
    end
    return bestEquips
end

---
---获取穿戴中的损坏的装备list
---
function equipOnBody_model:getBadEquipList()
    local badEquips = {}
    for k, v in ipairs(EquipModel.serv_fitEquipmentList) do
        local equip = self:getEquipByOnlyID(v)
        if equip.isBad == 1 then
            table.insert(badEquips, equip)
        end
    end
    return badEquips
end

---
---判断是否可以一键装备，即是否存在更好的装备
---
function equipOnBody_model:isCanEquipOnce()
    for i = 1, #_bestEquipList do
        if _bestEquipList[i].id ~= self.equipOnBodyList[_bestEquipList[i].EquipType] then
            return true
        end
    end
    return false
end

return equipOnBody_model