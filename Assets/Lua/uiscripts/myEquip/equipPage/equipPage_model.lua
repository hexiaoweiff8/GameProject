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
local _EquipsList = {}
function equipPage_model:getEquipListByType(equipType)
    _EquipsList = {}
    for i = 1, #self.equipListByType[equipType] do
        _EquipsList[i] = self.equipListByType[equipType][i]
    end
    return self.equipListByType[equipType]
end



---
---判断要显示的列表是否改变，
---
function equipPage_model:isListChanged(equipType)
    print(#self.equipListByType[equipType])
    if #self.equipListByType[equipType] ~= #_EquipsList then
        return true
    end
    for i = 1, #_EquipsList do
        if _EquipsList[i] ~= self.equipListByType[equipType][i] then
            return true
        end
    end
    return false
end

return equipPage_model