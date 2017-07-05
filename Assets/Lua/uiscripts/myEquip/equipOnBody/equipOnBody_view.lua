---
--- Created by Administrator.
--- DateTime: 2017/6/30 17:55
---

local euqipOnbody_view = {}
local view
function euqipOnbody_view:init_view(args)
    view = args
    self.equipItems = {}
    self.equipIcon = {}
    self.equipLevel = {}
    self.addSpr = {}
    self.background = {}
    for i = 1, 8 do
        self.equipItems[i] = view.transform:Find("onBody/equipItems/eqBg"..i).gameObject
        self.equipIcon[i] = self.equipItems[i].transform:Find("eqSpr").gameObject
        self.equipLevel[i] = self.equipItems[i].transform:Find("level").gameObject
        self.addSpr[i] = self.equipItems[i].transform:Find("addSpr").gameObject
        self.background[i] = self.equipItems[i].transform:Find("diSpr").gameObject
    end
    self.selectBox = view.transform:Find("onBody/equipItems/selectKuang").gameObject
end

return euqipOnbody_view