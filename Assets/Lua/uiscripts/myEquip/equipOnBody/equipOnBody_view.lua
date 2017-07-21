---
--- Created by Administrator.
--- DateTime: 2017/6/30 17:55
---

local euqipOnbody_view = {}
local view
function euqipOnbody_view:init_view(args)
    view = args

    self.btn_equipOnce = view.transform:Find("onBody/btn_equipOnce").gameObject
    self.btn_fixOnce = view.transform:Find("onBody/btn_fixOnce").gameObject
    self.onceFixCost_lab = self.btn_fixOnce.transform:Find("costLab").gameObject

    self.equipItems = {}
    self.equipIcon = {}
    self.equipLevel = {}
    self.addSpr = {}
    self.lockSpr = {}
    self.background = {}
    for i = 1, Const.EQUIP_TYPE_NUM do
        self.equipItems[i] = view.transform:Find("onBody/equipItems/eqBg"..i).gameObject
        self.equipIcon[i] = self.equipItems[i].transform:Find("eqSpr").gameObject
        self.equipLevel[i] = self.equipItems[i].transform:Find("level").gameObject
        self.addSpr[i] = self.equipItems[i].transform:Find("addSpr").gameObject
        self.lockSpr[i] = self.equipItems[i].transform:Find("lockSpr").gameObject
        self.background[i] = self.equipItems[i].transform:Find("diSpr").gameObject
    end
    self.selectBox = view.transform:Find("onBody/equipItems/selectKuang").gameObject
end

return euqipOnbody_view