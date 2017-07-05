---
--- Created by Administrator.
--- DateTime: 2017/6/28 17:59
---
local equipPage_controller = {}
local view = require("uiscripts/myEquip/equipPage/equipPage_view")
local data = require("uiscripts/myEquip/equipPage/equipPage_model")
local EquipDetail = require("uiscripts/commonGameObj/equipDetail")

---
---装备信息显示界面
---
local onBodyDetail
local otherEquipDetail
---
---正选中的装备栏装备
---
local equipItems = {}
local currentEquip
local beforeEquip

---
---装备栏正显示的装备类型
---
local showEquipType
function equipPage_controller:init(equipController)
    view:init_view(equipController)
    --data:getDatas()
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
    showEquipType = equipType
    local equipList = data:getEquipListByType(equipType)
    equipItems = {}
    for i = 1, #equipList do
        equipItems[i] = EquipItem(view.otherEquip_Grid, equipList[i])
        equipItems[i]:refresh()
        equipItems[i]:SetListener(onEquipClicked)
        ---
        ---如果该装备已装备，则设为当前选择的装备
        ---
        if equipList[i].equipped then
            currentEquip = equipItems[i]
            beforeEquip = currentEquip
        end
    end
    view.otherEquip_Grid.transform:GetComponent("UIGrid"):Reposition()

end
---
---刷新右侧装备栏界面
---equipType    装备的类型
---
function equipPage_controller:refreshEquipsByType(equipType)
    if showEquipType and showEquipType == equipType then
        if currentEquip then
            currentEquip:refresh()
        end
        if beforeEquip then
            beforeEquip:refresh()
        end
        beforeEquip = currentEquip
    else
        equipPage_controller:showEquipsByType(equipType)
    end

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
    otherEquipDetail:showEquip(equip, view.otherEquip_DetailR, 14)
    otherEquipDetail:setListener()
    view.otherEquip_DetailR:SetActive(true)


    ---获取穿戴中同类型的装备ID
    local onBodyEquipID = data.equipOnBodyList[equip.EquipType]
    ---判断是否装备同类型装备，以及是否为同一件装备
    if onBodyEquipID ~= -1 and onBodyEquipID ~= equip.id then
        if not onBodyDetail then
            onBodyDetail = EquipDetail(0)
        end
        onBodyDetail:showEquip(data:getEquipByOnlyID(onBodyEquipID), view.otherEquip_DetailL, 14)
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
    if view.otherEquip.activeSelf then
        equipPage_controller:refreshEquipsByType(equipType)
    end

    if view.otherEquip_DetailP.activeSelf then
        equipPage_controller:refreshDetails(currentEquip:getEquipToShow())
    end

end

---
---当点击装备栏的装备时
---equip    装备对象
---self     装备Item对象
---
function onEquipClicked(equip, self)
    ---
    ---屏蔽重复点击事件
    ---
    if currentEquip == self and view.otherEquip_DetailP.activeSelf then
        return
    end
    currentEquip = self
    equipPage_controller:showDetails(equip)
end


return equipPage_controller