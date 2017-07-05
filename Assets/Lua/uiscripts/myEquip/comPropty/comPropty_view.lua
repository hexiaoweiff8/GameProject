---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:33
---
local comPropty_view = {}

local view = nil
function comPropty_view:init_view(args)
    view = args
    self.btn_comPropL = view.transform:Find("comProp/btn_propDetail_L").gameObject
    self.btn_comPropR = view.transform:Find("comProp/btn_propDetail_R").gameObject
    self.comProp_L = view.transform:Find("comProp/comProp_L").gameObject
    self.comProp_R = view.transform:Find("comProp/comProp_R").gameObject
    self.otherEquip = view.transform:Find("allEquip").gameObject
end

function comPropty_view:getView(parent)
    self.comPropty = GameObjectExtension.InstantiateFromPacket("ui_equip", "comProp", parent).gameObject
end

return comPropty_view