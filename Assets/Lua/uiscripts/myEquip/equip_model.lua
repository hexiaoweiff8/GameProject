---
--- Created by GX
--- DateTime: 2017/6/21 12:11
---
local class = require("common/middleclass")
equip_model = class("equip_model")

local isFirst = true

equip_model.equipListByType = {}

function equip_model:getDatas()

    if EquipModel.serv_Equipment == nil then
        return
    end
    self.allEquipmentTbl = EquipModel.serv_Equipment
    self.equipOnBodyList = {}
    self.myPower = currencyModel:getCurrentTbl().power
    self:initEquipOnBodyList()
    if isFirst then
        isFirst = false
        self:badTest()
    end
    self:initEquipListByType()
end


function equip_model:badTest()
    for k, v in ipairs(self.allEquipmentTbl) do
        if v.id % 2 == 0 then
            v.isBad = 1
        end
    end
end



---
---初始化八个装备栏的装备ID
---  -1    表示未装备
---
function equip_model:initEquipOnBodyList()
    for i = 1, Const.EQUIP_TYPE_NUM do
        self.equipOnBodyList[i] = -1
    end

    for k, v in ipairs(EquipModel.serv_fitEquipmentList) do
        self.equipOnBodyList[EquipModel:getLocalEquipmentTypeByServID(v)] = v
    end
end


---
---根据装备类型将装备分类，并进行排序
---
function equip_model:initEquipListByType()
    for i = 1, Const.EQUIP_TYPE_NUM do
        self.equipListByType[i] = {}
    end
    for i = 1, #self.allEquipmentTbl do
        local equipType = self.allEquipmentTbl[i].EquipType
        table.insert(self.equipListByType[equipType], self.allEquipmentTbl[i])
    end
    for i = 1, #self.equipListByType do
        if #self.equipListByType[i] ~= 0 then
            EquipUtil:sortEquipment(self.equipListByType[i])
        end
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