---
--- Created by Administrator.
--- DateTime: 2017/6/21 12:10
---
local equip_view = {}
local view
function equip_view:init(args)
    view = args
end
function equip_view:getView()

    self.btn_comPropL = view.transform:Find("comProp/btn_propDetail_L").gameObject
    self.btn_comPropR = view.transform:Find("comProp/btn_propDetail_R").gameObject
    self.comProp_L = view.transform:Find("comProp/comProp_L").gameObject
    self.comProp_R = view.transform:Find("comProp/comProp_R").gameObject

    self.otherEquip = view.transform:Find("allEquip").gameObject
    self.rightDetail = view.transform:Find("rightDetailParent").gameObject

end

return equip_view