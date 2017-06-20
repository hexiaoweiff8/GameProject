local upSynergy_view={}
local view 
function upSynergy_view:init_view(arg)
    view = arg

    self.synergyPanel = view.transform:Find("right/synergy").gameObject
    self.synergyP_tipLab = self.synergyPanel.transform:Find("atbAddPanel/tipLab").gameObject --加成提示信息
    self.synergyP_addProperty_1 = self.synergyPanel.transform:Find("atbAddPanel/addProperty_1").gameObject --加成属性1
    self.synergyP_addProperty_2 = self.synergyPanel.transform:Find("atbAddPanel/addProperty_2").gameObject --加成属性2
    self.synergyP_addProperty_3 = self.synergyPanel.transform:Find("atbAddPanel/addProperty_3").gameObject --加成属性3
end

function upSynergy_view:init_upSynergyPanel()
    self.upSynergyP = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "xtupLayer",  self.gameObject)
    self.upSynergyP_title = self.upSynergyP.transform:Find("title_Lab").gameObject

    self.upSynergyP_cardNameL = self.upSynergyP.transform:Find("xtLab").gameObject
    self.upSynergyP_desL = self.upSynergyP.transform:Find("tipLab").gameObject
    self.upSynergyP_coinL = self.upSynergyP.transform:Find("costNameLab_1").gameObject
    self.upSynergyP_goldL = self.upSynergyP.transform:Find("costNameLab_2").gameObject
    self.upSynergyP_coinSp = self.upSynergyP.transform:Find("costSp_1").gameObject
    self.upSynergyP_goldSp = self.upSynergyP.transform:Find("costSp_2").gameObject
    self.upSynergyP_coinNeedNumL = self.upSynergyP.transform:Find("neednumLab_1").gameObject
    self.upSynergyP_goldNeedNumL = self.upSynergyP.transform:Find("neednumLab_2").gameObject
    self.upSynergyP_coinHaveNumL = self.upSynergyP.transform:Find("numLab_1").gameObject
    self.upSynergyP_goldHaveNumL = self.upSynergyP.transform:Find("numLab_2").gameObject

    self.upSynergyP_btnBack = self.upSynergyP.transform:Find("Btn_backSp").gameObject
    self.upSynergyP_btnP = self.upSynergyP.transform:Find("btn_upSynergy").gameObject
    self.upSynergyP_btnOk = self.upSynergyP.transform:Find("btn_upSynergy/btn_ok").gameObject
    self.upSynergyP_btnOkL = self.upSynergyP.transform:Find("btn_upSynergy/btn_ok/Label").gameObject
    self.upSynergyP_btnCancle = self.upSynergyP.transform:Find("btn_upSynergy/btn_cancle").gameObject
    self.upSynergyP_maxSynergyP = self.upSynergyP.transform:Find("maxSynergy").gameObject

end

return upSynergy_view