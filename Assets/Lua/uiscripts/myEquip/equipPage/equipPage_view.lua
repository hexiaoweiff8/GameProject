---
--- Created by Administrator.
--- DateTime: 2017/6/28 17:59
---
local equipPage_view = {}
local view
function equipPage_view:init_view(args)
    view = args
    self.otherEquip = view.transform:Find("allEquip").gameObject
    self.otherEquip_DetailP = self.otherEquip.transform:Find("detailParent").gameObject
    self.otherEquip_DetailL = self.otherEquip_DetailP.transform:Find("left").gameObject
    self.otherEquip_DetailR = self.otherEquip_DetailP.transform:Find("right").gameObject
    self.otherEquip_DetailMask = self.otherEquip_DetailP.transform:Find("mask").gameObject
    self.otherEquip_EquipsP = self.otherEquip.transform:Find("equips").gameObject
    self.otherEquip_Scroll = self.otherEquip_EquipsP.transform:Find("Scroll View").gameObject
    self.otherEquip_Grid = self.otherEquip_Scroll.transform:Find("eqGrid").gameObject
end


return equipPage_view