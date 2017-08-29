---
--- Created by Administrator.
--- DateTime: 2017/7/12 12:29
---
local remake_view = {}
function remake_view:init(parent)
    ---初始化控件
    self.RemakePanel = GameObjectExtension.InstantiateFromPacket("commonu", "RemakePanel", parent).gameObject
    self.btn_back = self.RemakePanel.transform:Find("Btn_backSp").gameObject
    self.maskPanel = self.RemakePanel.transform:Find("MaskPanel").gameObject
    self.Btn_RemakeAndExchange = self.RemakePanel.transform:Find("Btn_RemakeAndExchange").gameObject
    self.Lab_RemakeAndExchange = self.Btn_RemakeAndExchange.transform:Find("lab").gameObject

    ---装备头像
    self.equipItem = self.RemakePanel.transform:Find("equipItem").gameObject
    self.equipItem_Icon = self.equipItem.transform:Find("Icon").gameObject
    self.equipItem_RarityIcon = self.equipItem.transform:Find("rarity_Icon").gameObject
    self.equipItem_Level = self.equipItem.transform:Find("Level/Level_Lab").gameObject
    self.equipItem_Name = self.equipItem.transform:Find("Name/Name_Lab").gameObject
    ---属性列表
    self.mainPropLab = self.RemakePanel.transform:Find("proptyList/mainProp/lab").gameObject
    self.normalProps = {}
    self.normalProps_prop = {}
    self.normalProps_lab = {}
    self.normalProps_max = {}
    self.normalProps_remakeMark = {}
    self.normalProps_lock = {}
    for i = 1, Const.EQUIP_NORMALPROP_NUM do
        self.normalProps[i] = self.RemakePanel.transform:Find("proptyList/normalProp_"..i).gameObject
        self.normalProps_prop[i] = self.normalProps[i].transform:Find("Prop").gameObject
        self.normalProps_lab[i] = self.normalProps_prop[i].transform:Find("lab").gameObject
        self.normalProps_max[i] = self.normalProps_prop[i].transform:Find("max").gameObject
        self.normalProps_remakeMark[i] = self.normalProps_prop[i].transform:Find("remakeMark").gameObject
        self.normalProps_lock[i] = self.RemakePanel.transform:Find("proptyList/normalProp_"..i.."/lock_bg").gameObject
    end
    self.normalProps_selected = self.RemakePanel.transform:Find("proptyList/selected").gameObject

    ---重铸材料界面
    self.needItem = self.RemakePanel.transform:Find("needItems").gameObject
    self.needItem_Bg = self.needItem.transform:Find("item/bg").gameObject
    self.needItem_Icon = self.needItem.transform:Find("item/Item_Icon").gameObject
    self.needItem_NumLab = self.needItem.transform:Find("item/Num_Label").gameObject
    self.needItem_NameLab = self.needItem.transform:Find("item/Name/Name_Lab").gameObject


    ---重铸属性界面
    self.chooseProps = self.RemakePanel.transform:Find("chooseProps").gameObject
    self.chooseProps_props = {}
    self.chooseProps_PropLabs = {}
    self.chooseProps_Max = {}
    for i = 1, 3 do
        self.chooseProps_props[i] = self.chooseProps.transform:Find("Prop_"..i).gameObject
        self.chooseProps_PropLabs[i] = self.chooseProps_props[i].transform:Find("lab").gameObject
        self.chooseProps_Max[i] = self.chooseProps_props[i].transform:Find("max").gameObject
    end
    self.chooseSp = self.RemakePanel.transform:Find("chooseProps/choose").gameObject
end



return remake_view