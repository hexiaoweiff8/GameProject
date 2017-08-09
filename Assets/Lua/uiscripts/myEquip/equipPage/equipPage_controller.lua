---
--- Created by Administrator.
--- DateTime: 2017/6/28 17:59
---
local equipPage_controller = {}
local view = require("uiscripts/myEquip/equipPage/equipPage_view")
local data = require("uiscripts/myEquip/equipPage/equipPage_model")
local EquipDetail = require("uiscripts/commonGameObj/equipDetail/equipDetail_controller")
local equipItemControl = require("uiscripts/myEquip/equipPage/equipItemControl")
---
---装备信息显示界面
---
local onBodyDetail
local otherEquipDetail
---
---正选中的装备栏装备
---
local currentEquip

---
---装备栏正显示的装备类型
---
function equipPage_controller:init(equipController)
    view:init_view(equipController)
    view.otherEquip_DetailP:SetActive(false)
    equipItemControl:init(self, view)
    equipItemControl:setItemClickEvent(onEquipClicked)
    borderUtil:AddBorder(view.otherEquip_Scroll)
    UIEventListener.Get(view.otherEquip_DetailMask).onClick = function()
        view.otherEquip_DetailL:SetActive(false)
        view.otherEquip_DetailR:SetActive(false)
        view.otherEquip_DetailP:SetActive(false)
        currentEquip = nil
    end
    UIEventListener.Get(view.otherEquip_EquipsP).onClick = function()
        view.otherEquip_DetailL:SetActive(false)
        view.otherEquip_DetailR:SetActive(false)
        view.otherEquip_DetailP:SetActive(false)
        currentEquip = nil
    end
end

---
---显示右侧装备栏信息界面
---equipType    装备的类型
---
function equipPage_controller:showEquipsByType(equipType)
    equipItemControl:show(data:getEquipListByType(equipType))
end

---
---显示装备信息界面
---equip    要显示的装备对象
---
function equipPage_controller:showDetails(equip)

    ---显示选择的装备信息界面
    if not otherEquipDetail then
        otherEquipDetail = EquipDetail(1)
    end

    otherEquipDetail:showEquip(equip, view.otherEquip_DetailR, 18)
    otherEquipDetail:setShowRemakePanelFunc(self.showRemakePanel)
    otherEquipDetail:setListener()
    view.otherEquip_DetailR:SetActive(true)

    ---获取穿戴中同类型的装备ID
    local onBodyEquipID = data.equipOnBodyList[equip.EquipType]
    ---判断是否装备同类型装备，以及是否为同一件装备
    if onBodyEquipID ~= -1 and onBodyEquipID ~= equip.id then
        if not onBodyDetail then
            onBodyDetail = EquipDetail(0)
        end

        onBodyDetail:showEquip(data:getEquipByOnlyID(onBodyEquipID), view.otherEquip_DetailL, 18)
        view.otherEquip_DetailL:SetActive(true)
    else
        view.otherEquip_DetailL:SetActive(false)
    end

    ---显示信息界面
    view.otherEquip_DetailP:SetActive(true)
end

---
---刷新装备信息界面
---
function equipPage_controller:refreshDetails(equip)
    ---显示选择的装备信息界面
    if otherEquipDetail then
        otherEquipDetail:refresh()
        view.otherEquip_DetailR:SetActive(true)
    end
    ---获取穿戴中同类型的装备ID
    local onBodyEquipID = data.equipOnBodyList[equip.EquipType]
    ---判断是否装备同类型装备，以及是否为同一件装备
    if onBodyEquipID ~= -1 and onBodyEquipID ~= equip.id then
        if onBodyDetail then
            onBodyDetail:refresh()
            view.otherEquip_DetailL:SetActive(true)
        end
    else
        view.otherEquip_DetailL:SetActive(false)
    end
    ---显示信息界面
    view.otherEquip_DetailP:SetActive(true)
end

---
---刷新装备的显示和装备信息界面
---
function equipPage_controller:refresh(equipType)
    if view.otherEquip_DetailP.activeSelf then
        equipPage_controller:refreshDetails(currentEquip)
    end


    if view.otherEquip.activeSelf then
        equipItemControl:refresh()
    end

end

---
---一键装备后刷新
---
function equipPage_controller:onceEquipRefresh(equipType)
    if view.otherEquip.activeSelf then
        if equipType then
            equipItemControl:set_selectItem(data.equipOnBodyList[equipType])
        end
        equipItemControl:refresh()
    end


    if view.otherEquip_DetailP.activeSelf then
        equipPage_controller:refreshDetails(currentEquip)
    end
end

---
---当点击装备栏的装备时
---equip    装备对象
---self     装备Item对象
---

function onEquipClicked(equip)
    ---
    ---屏蔽重复点击事件
    ---
    if currentEquip and currentEquip.id == equip.id and view.otherEquip_DetailP.activeSelf then
        return
    end
    currentEquip = equip

    equipPage_controller:showDetails(equip)
end

function equipPage_controller:showRemakePanel(equip)

    if view.otherEquip_DetailP.activeSelf then
        view.otherEquip_DetailP:SetActive(false)
    end

    equip_controller:showRemakePanel(equip)
end

return equipPage_controller