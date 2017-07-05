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
require("uiscripts/commonGameObj/equipItem")


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
    ---
    ---设置一键装备和一键修理按钮的显示文字
    ---
    view.btn_equipOnce.transform:Find("lab1"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10013)
    view.btn_equipOnce.transform:Find("lab2"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10014)
    view.btn_fixOnce.transform:Find("lab1"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10013)
    view.btn_fixOnce.transform:Find("lab2"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10015)

    ---
    ---初始化装备界面的显示
    ---
    self:initShow()

end



function equip_controller:initShow()

    view.rightDetail:SetActive(false)
    view.otherEquip:SetActive(false)

    equipOnBody:showEquipsOnBody()
    ---
    ---初始化右侧界面
    ---
    self:showRightPanel(equipOnBody:getCurrentSelectEquipType())


end



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
    view.btn_comPropR:SetActive(false)
    view.btn_comPropL:SetActive(true)
end

---
---根据装备类型显示我拥有的所有该类型装备
---EquipType    装备类型
---
function equip_controller:showEquipsByType(EquipType)

    equipPage:showEquipsByType(EquipType)
    view.rightDetail:SetActive(false)
    view.otherEquip:SetActive(true)
    view.btn_comPropR:SetActive(true)
    view.btn_comPropL:SetActive(false)
end


---
---装备卸下成功后调用
---装备主界面中只有卸下功能
---
function equip_controller:equipLoadOrNotRefresh()
    ---
    ---更新数据
    ---
    data:getDatas()
    ---
    ---刷新左侧装备信息
    ---
    equipOnBody:refresh()
    ---
    ---刷新右侧界面显示
    ---
    if view.rightDetail.activeSelf then
        view.rightDetail:SetActive(false)
        view.otherEquip:SetActive(true)
        view.btn_comPropR:SetActive(true)
        view.btn_comPropL:SetActive(false)
    end
    equipPage:refresh(equipOnBody:getCurrentSelectEquipType())


end


---
---装备升级后调用
---
function equip_controller:equipPlusRefresh()

    ---
    ---更新数据
    ---
    data:getDatas()

    equipOnBody:refresh()

    if view.rightDetail.activeSelf then
        detailPage:refresh()
        return
    end
    if view.otherEquip.activeSelf then
        equipPage:refresh(equipOnBody:getCurrentSelectEquipType())
    end
end


return equip_controller


