---
--- Created by Administrator.
--- DateTime: 2017/6/28 18:00
---

local class = require("common/middleclass")
local equipPage_model = class("equipPage_model",equip_model)

---
---根据装备的类型获取所有该类型装备的list
---equipType    装备类型
---
function equipPage_model:getEquipListByType(equipType)
    local equipList = {}
    for i = 1, #self.allEquipmentTbl do
        if self.allEquipmentTbl[i].EquipType == equipType then
            table.insert(equipList, self.allEquipmentTbl[i])
        end
    end
    return equipList
end
return equipPage_model