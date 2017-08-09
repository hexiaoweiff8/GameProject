---
--- Created by GX
--- DateTime: 2017/6/21 12:03
---

local class = require("common/middleclass")
equip_controller = class("equip_controller", wnd_base)
local view = require("uiscripts/myEquip/equip_view")
local data = require("uiscripts/myEquip/equip_model")
local equipPage = require("uiscripts/myEquip/equipPage/equipPage_controller")
local detailPage = require("uiscripts/myEquip/detailPage/detailPage_controller")
local equipOnBody = require("uiscripts/myEquip/equipOnBody/equipOnBody_controller")
local comPropty = require("uiscripts/myEquip/comPropty/comPropty_controller")
local UIModel = require("uiscripts/commonGameObj/UIModel")
local Model

local Remake = require("uiscripts/commonGameObj/remake/remake_controller")
local remakePanel = nil   ---



---
---显示界面时执行
---
function equip_controller:OnShowDone()
    ---
    ---初始化view和数据
    ---
    view:init(self)
    view:getView()
    data:getDatas()

    ---
    ---初始化各部分界面
    ---
    equipPage:init(self)
    detailPage:init(self)
    equipOnBody:init(self)
    comPropty:init(self)

    ---初始化重铸界面
    remakePanel = Remake()


    Model = UIModel(view.UIModelPosition)
    ---
    ---初始化装备界面的显示
    ---
    self:initShow()



end


---
---初始化界面显示
---
function equip_controller:initShow()

    view.rightDetail:SetActive(false)
    view.otherEquip:SetActive(false)
    ---
    ---显示穿戴装备
    ---
    equipOnBody:showEquipsOnBody()
    ---
    ---初始化右侧界面
    ---
    self:showRightPanel(equipOnBody:getCurrentSelectEquipType())


end

---
---获取重铸界面
---
function equip_controller:getRemakePanel()
    return remakePanel
end
function equip_controller:showRemakePanel(equip)

    remakePanel:show(equip, view.remakeP, 21)
    remakePanel:setExchangeRefreshFunc(equip_controller.remakeExchangeRefresh)
end
---
---
---控制右侧界面的显示状态
---index    已穿戴装备的代码，也是该穿戴装备的类型
---注：已穿戴装备的代号和该装备的类型一一对应
---
function equip_controller:showRightPanel(Index)
    ---
    ---如果当前选项已经穿戴了装备
    ---显示该装备的信息
    ---
    if data.equipOnBodyList[Index] ~= -1 then
        if not view.rightDetail.activeSelf or equipOnBody:getCurrentSelectEquipType() ~= Index then
            self:showDetailByType(Index)
        end
    else
        ---
        ---如果未穿戴装备，判断当前要显示的装备类型和已经显示的类型是否相同
        ---
        if not view.otherEquip.activeSelf or equipOnBody:getCurrentSelectEquipType() ~= Index then
            self:showEquipsByType(Index)
        end
    end
end

---
---根据装备类型显示穿戴的该类型的装备的信息
---EquipType    装备类型
---
function equip_controller:showDetailByType(EquipType)
    local equip = data:getEquipByOnlyID(data.equipOnBodyList[EquipType])
    detailPage:show(equip, view.rightDetail)
    detailPage:setListenerToBtnChange(self.showEquipsByType)
    view.otherEquip:SetActive(false)
    view.rightDetail:SetActive(true)
    view.comProp_L:SetActive(false)
    view.comProp_R:SetActive(false)
    view.btn_comPropR:SetActive(false)
    view.btn_comPropL:SetActive(true)
end

---
---根据装备类型显示我拥有的所有该类型装备
---EquipType    装备类型
---
function equip_controller:showEquipsByType(EquipType)

    view.rightDetail:SetActive(false)
    view.otherEquip:SetActive(true)
    view.comProp_L:SetActive(false)
    view.comProp_R:SetActive(false)
    view.btn_comPropR:SetActive(true)
    view.btn_comPropL:SetActive(false)
    equipPage:showEquipsByType(EquipType)
end


---
---装备或卸下成功后调用
---
function equip_controller:equipLoadOrNotRefresh()
    ---
    ---更新数据
    ---
    data:getDatas()
    ---
    ---装备有变化，刷新左侧装备信息
    ---
    equipOnBody:equipChangeRefresh()
    ---
    ---刷新右侧界面显示
    ---
    if view.rightDetail.activeSelf then
        self:showEquipsByType(equipOnBody:getCurrentSelectEquipType())
        return
    end
    ---
    ---
    ---
    if view.otherEquip.activeSelf then
        equipPage:refresh(equipOnBody:getCurrentSelectEquipType())
    end

end

---
---一键装备后调用
---
function equip_controller:equipLoadBestRefresh()
    ---
    ---更新数据
    ---
    data:getDatas()
    ---
    ---装备有变化，刷新左侧装备信息
    ---
    equipOnBody:equipChangeRefresh()
    ---
    ---刷新右侧界面显示
    ---
    if view.rightDetail.activeSelf then
        local equipType = equipOnBody:getCurrentSelectEquipType()
        local equip = data:getEquipByOnlyID(data.equipOnBodyList[equipType])
        detailPage:refresh(equip)
    end
    ---
    ---
    ---
    if view.otherEquip.activeSelf then
        equipPage:onceEquipRefresh(equipOnBody:getCurrentSelectEquipType())
    end
end

---
---装备修理，升级，加锁后调用
---
function equip_controller:normalRefresh()
    ---
    ---更新数据
    ---
    data:getDatas()

    ---
    ---刷新左侧装备信息
    ---
    equipOnBody:refresh(equipOnBody:getCurrentSelectEquipType())

    if view.rightDetail.activeSelf then
        detailPage:refresh()
        return
    end
    if view.otherEquip.activeSelf then
        equipPage:refresh(equipOnBody:getCurrentSelectEquipType())
    end
end

---
---一键修理后调用
---
function equip_controller:equipFixRefreshAll()
    ---
    ---更新数据
    ---
    data:getDatas()

    ---
    ---刷新左侧装备信息
    ---
    equipOnBody:refreshAll()

    if view.rightDetail.activeSelf then
        detailPage:refresh()
        return
    end
    if view.otherEquip.activeSelf then
        equipPage:refresh(equipOnBody:getCurrentSelectEquipType())
    end
end

---
---属性重铸替换后调用
---
function equip_controller:remakeExchangeRefresh()
    if view.rightDetail.activeSelf then
        detailPage:refresh()
    end
end

return equip_controller


