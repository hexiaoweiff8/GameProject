local upSoldier_view={}
local view 
function upSoldier_view:init_view(arg)
    view = arg

    --兵员部分
    self.soldierPanel = view.transform:Find("right/soldier").gameObject
    self.soldierP_LvProLab = self.soldierPanel.transform:Find("lvProgress_Lab").gameObject
    self.soldierP_desLab = self.soldierPanel.transform:Find("des_Lab").gameObject
    self.soldierP_cost = self.soldierPanel.transform:Find("cost").gameObject--兵员升级消耗物品显示
    self.soldierP_cardNameL = self.soldierPanel.transform:Find("cost/cardName_Lab").gameObject --卡牌名
    self.soldierP_badgeNameL = self.soldierPanel.transform:Find("cost/badgeName_Lab").gameObject--兵牌
    self.soldierP_cardSp = self.soldierPanel.transform:Find("cost/soldier_Sp").gameObject--卡牌图
    self.soldierP_badgeSp = self.soldierPanel.transform:Find("cost/badge_Sp").gameObject--兵牌图
    self.soldierP_cardNeedL = self.soldierPanel.transform:Find("cost/neednumLab_1").gameObject
    self.soldierP_badgeNeednumL = self.soldierPanel.transform:Find("cost/neednumLab_2").gameObject
    self.soldierP_cardHavaLab = self.soldierPanel.transform:Find("cost/numLab_1").gameObject
    self.soldierP_badgeHaveLab = self.soldierPanel.transform:Find("cost/numLab_2").gameObject
    self.soldierP_btnUpSoldier = self.soldierPanel.transform:Find("Btn_soldierUpLv").gameObject
    self.soldierP_btnUpSoldier_Lab = self.soldierPanel.transform:Find("Btn_soldierUpLv/lab").gameObject
    self.soldierP_maxSoldierP = self.soldierPanel.transform:Find("maxSoldier").gameObject
    self.soldierP_btnUpSoldier_redDot = self.soldierPanel.transform:Find("Btn_soldierUpLv/redDot").gameObject


end




return upSoldier_view