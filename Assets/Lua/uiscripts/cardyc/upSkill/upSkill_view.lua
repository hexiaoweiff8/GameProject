local upSkill_view={}
local view 
function upSkill_view:init_view(arg)
    view = arg

    --兵员部分
    self.skillPanel = view.transform:Find("right/skill").gameObject
    self.skillP_btnResetPoint = self.skillPanel.transform:Find("bgSp/pointReset_Sp").gameObject
    self.skillP_pointLab = self.skillPanel.transform:Find("bgSp/pointNum_Lab").gameObject


end

function upSkill_view:init_skillPointResetPanels()
    -- body
    self.sPtRPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "sPtReset",  view.gameObject)
    self.sPtRP_titleL = self.sPtRPanel.transform:Find("title_Lab").gameObject
    self.sPtRP_desL = self.sPtRPanel.transform:Find("des_Lab").gameObject
    self.sPtRP_btnBack = self.sPtRPanel.transform:Find("Btn_backSp").gameObject
    self.sPtRP_norResetCostL = self.sPtRPanel.transform:Find("Sprite/comCostNumLab")
    self.sPtRP_perResetCostL = self.sPtRPanel.transform:Find("Sprite/perCostNumLab")
    self.sPtRP_norResetB = self.sPtRPanel.transform:Find("Btn_comReset").gameObject
    self.sPtRP_perResetB = self.sPtRPanel.transform:Find("Btn_perReset").gameObject
    

end

function upSkill_view:init_skillInfoPanel()
    -- body
    self.skillInfoPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "skillItemUpLayer",  view.gameObject)
    self.skillInfoP_BtnBack = self.skillInfoPanel.transform:Find("Btn_backSp").gameObject
    self.skillInfoP_lv_Lab = self.skillInfoPanel.transform:Find("lv_Lab").gameObject
    self.skillInfoP_lvProLab = self.skillInfoPanel.transform:Find("lvProgress_Lab").gameObject
    self.skillInfoP_sdes_Lab = self.skillInfoPanel.transform:Find("skilldes_Lab").gameObject--说明描述
    self.skillInfoP_btn_unlock = self.skillInfoPanel.transform:Find("Btn_unLockSp").gameObject 
    self.skillInfoP_btn_unlock_Label = self.skillInfoP_btn_unlock.transform:Find("unlock_Lab").gameObject
    self.skillInfoP_btn_upLv = self.skillInfoPanel.transform:Find("Btn_updateSp").gameObject
    self.skillInfoP_costLab = self.skillInfoP_btn_upLv.transform:Find("skillPtNum_Lab").gameObject--
    self.skillInfoP_maxSkillLv = self.skillInfoPanel.transform:Find("maxSkillLv").gameObject
end


return upSkill_view