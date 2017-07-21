---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:33
---

local class = require("common/middleclass")
local comPropty_model = class("comPropty_model", equip_model)

---
---获取基础信息表
---
function comPropty_model:getBasicPropsList()
    local list = {}
    for i = 1, #self.equipOnBodyList do
        if self.equipOnBodyList[i] ~= -1 then
            local equip = self:getEquipByOnlyID(self.equipOnBodyList[i])
            ---如果装备未损坏
            if equip.isBad ~= 1 then
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
    end
    return list
end

---
---获取穿戴中的装备的所有套装的件数
---return     list  保存套装信息的表
---         k   套装ID
---         v   套装件数
---
function comPropty_model:getSuitList()
    local list = {}
    for i = 1, #self.equipOnBodyList do
        if self.equipOnBodyList[i] ~= -1 then
            local equip = self:getEquipByOnlyID(self.equipOnBodyList[i])
            if equip.isBad ~= 1 then
                if list[equip.SuitID] then
                    list[equip.SuitID] = list[equip.SuitID] + 1
                else
                    list[equip.SuitID] = 1
                end
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