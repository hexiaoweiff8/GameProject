---
--- Created by Administrator.
--- DateTime: 2017/7/12 19:43
---
local class = require("common/middleclass")
local equipDetail_model = class("equipDetail_model")


function equipDetail_model:initDatas(equip)


    ---设置要显示的装备
    self.equipToShow = equip
    ---
    ---获取要显示的字符串
    ---
    self.EquipisEquipped = EquipModel:isEquipped(equip.id)
    self.MainAttributeStr = EquipUtil:getEquipmentMainAttributeStr(equip["EquipID"],equip.fst_attr,equip.lv)
    self.SubAttributeStr = EquipUtil:getEquipmentSubAttributeStr(equip)

    self.EquipPlusCost = EquipUtil:getEquipmentPlusCost(equip.lv,equip.rarity)
    self.EquipFixCost = EquipUtil:getEquipmentFixCost(equip.lv,equip.rarity)
    self.HavePower = currencyModel:getCurrentTbl().power
    self.LevelUpOffset = EquipUtil:getEquipmentLevelUpOffsetStr(equip)


    self.str_load = sdata_UILiteral.mData.body[0xFE11][sdata_UILiteral.mFieldName2Index["Literal"]]
    self.str_unload = sdata_UILiteral.mData.body[0xFE12][sdata_UILiteral.mFieldName2Index["Literal"]]
    self.str_repair = sdata_UILiteral.mData.body[0xFE16][sdata_UILiteral.mFieldName2Index["Literal"]]
    self.str_plus = sdata_UILiteral.mData.body[0xFE17][sdata_UILiteral.mFieldName2Index["Literal"]]
    self.str_remake = sdata_UILiteral.mData.body[0xFE18][sdata_UILiteral.mFieldName2Index["Literal"]]
end




---
---点击穿戴按钮，获取全部穿戴的装备列表
---
function equipDetail_model:getList_equipLoad(equip)
    for i = #EquipModel.serv_fitEquipmentList,1,-1 do
        if EquipModel:getLocalEquipmentTypeByServID(EquipModel.serv_fitEquipmentList[i]) == equip.EquipType then
            EquipModel.serv_fitEquipmentList[i] = equip.id
            return EquipModel.serv_fitEquipmentList
        end
    end
    table.insert(EquipModel.serv_fitEquipmentList,equip.id)
    return EquipModel.serv_fitEquipmentList
end
---
---点击卸下按钮，获取全部穿戴的装备列表
---
function equipDetail_model:getList_equipDrop(equip)
    for i = #EquipModel.serv_fitEquipmentList,1,-1 do
        if EquipModel.serv_fitEquipmentList[i] == equip.id then
            table.remove(EquipModel.serv_fitEquipmentList,i)
            break
        end
    end
    return EquipModel.serv_fitEquipmentList
end
return equipDetail_model