---
--- Created by GX
--- DateTime: 2017/6/21 12:11
---
local class = require("common/middleclass")
equip_model = class("equip_model")


function equip_model:getDatas()
    --equip_Model = equip_ModelC()
    if EquipModel.serv_Equipment == nil then
        return
    end
    self.allEquipmentTbl = EquipModel.serv_Equipment
    self.equipOnBodyList = {}
    self:initEquipOnBodyList()
end
---
---初始化八个装备栏的装备ID
----  -1    表示未装备
---
function equip_model:initEquipOnBodyList()
    for i = 1, 8 do
        self.equipOnBodyList[i] = -1
    end

    for k, v in ipairs(EquipModel.serv_fitEquipmentList) do
        self.equipOnBodyList[EquipModel:getLocalEquipmentTypeByServID(v)] = v
    end
end

---
---根据装备的ID获取装备对象
---equipID  装备ID
---
function equip_model:getEquipByOnlyID(equipOnlyID)
    for k, v in ipairs(self.allEquipmentTbl) do
        if v.id == equipOnlyID then
            return v
        end
    end
    return nil
end


return equip_model