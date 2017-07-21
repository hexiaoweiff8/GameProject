---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:33
---
local comPropty_view = {}

local view = nil
function comPropty_view:init_view(args)
    view = args
    self.btn_comPropL = view.transform:Find("comProp/comProp_btn/btn_propDetail_L").gameObject
    self.btn_comPropR = view.transform:Find("comProp/comProp_btn/btn_propDetail_R").gameObject
    self.btn_comPropL_Spr = self.btn_comPropL.transform:Find("Sprite").gameObject
    self.btn_comPropR_Spr = self.btn_comPropR.transform:Find("Sprite").gameObject
    self.comProp_L = view.transform:Find("comProp/comProp_pos/comProp_L").gameObject
    self.comProp_R = view.transform:Find("comProp/comProp_pos/comProp_R").gameObject
    self.otherEquip = view.transform:Find("allEquip").gameObject
end

function comPropty_view:getView(parent)
    self.comPropty = GameObjectExtension.InstantiateFromPacket("ui_equip", "comProp", parent).gameObject
    self.basicProp_ScrollV = self.comPropty.transform:Find("basicProp/Scroll View").gameObject
    self.basicProp_Grid = self.basicProp_ScrollV.transform:Find("Grid").gameObject
    self.suitProp_ScrollV = self.comPropty.transform:Find("suitProp/Scroll View").gameObject
    self.suitProp_StartPoint = self.suitProp_ScrollV.transform:Find("startPoint").gameObject
end

function comPropty_view:createBasicProp(parent)
    return GameObjectExtension.InstantiateFromPacket("ui_equip", "propty", parent).gameObject
end
function comPropty_view:createSuit(parent)
    return GameObjectExtension.InstantiateFromPacket("ui_equip", "suit", parent).gameObject
end

return comPropty_view