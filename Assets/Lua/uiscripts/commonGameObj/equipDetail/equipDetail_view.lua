---
--- Created by Administrator.
--- DateTime: 2017/7/12 19:42
---
local class = require("common/middleclass")
local equipDetail_view = class("equipDetail_view")

function equipDetail_view:init()
    self.equipDetail = GameObjectExtension.InstantiateFromPacket("commonU", "Panel_Detail_equipment", self.gameObject).gameObject
    self.bg = self.equipDetail.transform:Find("Detail_bg").gameObject
    self.btn_decomposition = self.equipDetail.transform:Find("Widget_DetailContainer/Button_decomposition").gameObject
    self.btn_share = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_share").gameObject
    self.btn_commander = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_commander").gameObject
    self.btn_lock = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_lock").gameObject
    self.equipIcon = self.equipDetail.transform:Find("Widget_DetailContainer/Item_icon").gameObject
    self.equipFrame = self.equipDetail.transform:Find("Widget_DetailContainer/Item_icon/Item_Frame").gameObject
    self.equipNameLab = self.equipDetail.transform:Find("Widget_DetailContainer/Item_name/Label_name").gameObject
    self.equipLV = self.equipDetail.transform:Find("Widget_DetailContainer/Item_icon/Item_Level/Label_Level").gameObject
    self.btn_share = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_share").gameObject
    self.btn_loadOrNot = self.equipDetail.transform:Find("Widget_DetailContainer/Button_load-unload").gameObject
    self.lab_loadOrNot = self.btn_loadOrNot.transform:Find("Label_unload").gameObject
    self.sprite_equipped = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_equipped").gameObject

    self.lab_mainAttribute = self.equipDetail.transform:Find("Widget_DetailContainer/Label_MainAttribute").gameObject
    self.lab_subAttribute = self.equipDetail.transform:Find("Widget_DetailContainer/Label_ViceAttribute").gameObject
    self.lab_suitEffect = self.equipDetail.transform:Find("Widget_DetailContainer/Label_SuitEffect").gameObject
    self.suitAttr_lab = {}
    self.suitAttr_actNum = {}

    self.spr_nextLevel = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_nextLevel").gameObject
    self.lab_nextLevel = self.spr_nextLevel.transform:Find("Label_nextLevel").gameObject
    self.spr_nextLevel:SetActive(false)
    self.costSp = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_plus_cost").gameObject
    self.costLab = self.costSp.transform:Find("Label_plus_cost").gameObject
    self.btn_plus = self.equipDetail.transform:Find("Widget_DetailContainer/Button_plus").gameObject
    self.lab_plus = self.btn_plus.transform:Find("Label_plus").gameObject
end


return equipDetail_view