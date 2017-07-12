---
--- Created by Administrator.
--- DateTime: 2017/7/4 20:36
---

local equipItemControl = {}

local _ctrl
local _view

---要显示的装备表
local _ItemsToShow
---装备数据控制组件
local _scrollViewAdapter
---当前穿戴的装备在装备栏中对应的属性组件
local _equippedItem
---当前选框在在装备栏中对应的属性组件
local _selectItem
---当前选框在装备栏中的Index
local _selectIndex
---装备点击回调事件
local _onItemClickEvent

---
---初始化装备控制
---
function equipItemControl:init(ctrl, view)
    _ctrl = ctrl
    _view = view
    _scrollViewAdapter = _view.otherEquip_Scroll:GetComponent(typeof(UIScrollViewAdapter))
    local equipItem = self:initEquipItem()

    _scrollViewAdapter.onItemLoaded = function(go)
        self:HandleOnItemLoadedHandler(go)
    end
    _scrollViewAdapter.onItemSelected = function(go)
        self:HandleOnItemSelectedHandler(go)
    end
    _scrollViewAdapter:Create(0, equipItem)

    equipItem.gameObject:SetActive(false)

end

---
---设置点击事件的回调方法
---
function equipItemControl:setItemClickEvent(_func)
    _onItemClickEvent = _func
end

---
---装备选项点击事件回调
---
function equipItemControl:HandleOnItemClickedHandler(item_Component)
    _onItemClickEvent(_ItemsToShow[item_Component.Index + 1])
    self:HandleOnItemSelectedHandler(item_Component)
end

---
---装备选项被选中时回调
---
function equipItemControl:HandleOnItemSelectedHandler(item_Component)
    if _selectItem and _selectItem.Index ~= item_Component.Index then
        _selectItem:setIconSelectFrame(nil)
    end
    if _selectItem and _selectIndex and _selectIndex ~= _selectItem.Index then
        local item = self:getEquipItemByIndex(_selectIndex)
        if item then
            item:setIconSelectFrame(nil)
        end
    end
    item_Component:setIconSelectFrame(spriteNameUtil.SELECTED)
    _selectItem = item_Component
    _selectIndex = _selectItem.Index
end

---
---装备选项刷新回调
---
function equipItemControl:HandleOnItemLoadedHandler(item)

    local item_Component = item.gameObject:GetComponent(typeof(UI_Equip_Item))
    if item_Component.Index+1 > #_ItemsToShow then
        return
    end
    item_Component.gameObject.name = "Index_"..item_Component.Index
    if item_Component.cEquipment == nil then
        item_Component.cEquipment = item_Component.transform:Find("Equipment").gameObject
    end


    item_Component._EquipID = _ItemsToShow[item_Component.Index+1]["EquipID"]
    item_Component.cEquipment:SetActive(true)

    ---
    ---获取要显示的信息
    ---
    local _lv = _ItemsToShow[item_Component.Index + 1].lv
    local _rarity = _ItemsToShow[item_Component.Index + 1].rarity
    local _equipped = _ItemsToShow[item_Component.Index + 1].equipped
    local _isBad = _ItemsToShow[item_Component.Index + 1].isBad
    local _isLock
    if _ItemsToShow[item_Component.Index + 1].isLock == 0 then
        _isLock = false
    else _isLock = true end


    ---
    ---设置显示内容
    ---
    item_Component:setIconSelectFrame(nil)
    if _selectItem and item_Component.Index == _selectIndex then
        item_Component:setIconSelectFrame(spriteNameUtil.SELECTED)
    end
    item_Component:setIconFrame(spriteNameUtil["EQUIPRARITY_".._rarity])
    item_Component:setIcon(spriteNameUtil["ICON"])
    if _isBad == 1 then
        item_Component:setIcon(spriteNameUtil["RED"])
    end
    --item_Component:setIcon(_ItemsToShow[item_Component.Index+1]['EquipIcon'])
    --item_Component:setIcon(equipment_Atlas,_ItemsToShow[item_Component.Index+1]['EquipIcon']..".PNG")
    item_Component:setEquipmentLevel(_lv)
    item_Component:setEquipmentLock(_isLock)
    item_Component:setEquipped(_equipped)
    if _equipped then
        _equippedItem = item_Component
    end

    UIEventListener.Get(item_Component.gameObject).onClick = function(go)
        self:HandleOnItemClickedHandler(go:GetComponent(typeof(UI_Equip_Item)))
    end

end

---
---初始化装备选项
---
function equipItemControl:initEquipItem()
    local Item = _view.equipItem:AddComponent(typeof(UI_Equip_Item))
    Item._widgetTransform = _view.equipItem:GetComponent(typeof(UIWidget))

    Item.gameObject:AddComponent(typeof(UIDragScrollView))
    Item.transform.localPosition = Vector3(0,0,0)
    Item.transform.localScale = Vector3(1,1,1)

    local collider = Item.gameObject:AddComponent(typeof(UnityEngine.BoxCollider))
    collider.isTrigger = true
    collider.center = Vector3.zero
    collider.size = Vector3(Item._widgetTransform.localSize.x,Item._widgetTransform.localSize.y,0)
    return Item
end

---
---根据装备list显示物品栏
---list     要显示的装备表
---
function equipItemControl:show(list)
    _ItemsToShow = list
    self:refreshList()
end

---
---外部根据装备的唯一ID设置列表中已装备的装备
---
function equipItemControl:set_selectItem(equipId)
    for k, v in ipairs(_ItemsToShow) do
        if v.id == equipId then
            if self:getEquipItemByIndex(k - 1) then
                _selectItem =  self:getEquipItemByIndex(k - 1)
                return
            end
        end
    end
end


---
---根据index获取装备item
---
function equipItemControl:getEquipItemByIndex(Index)
    local itemsPanel = _view.otherEquip_Scroll.transform:GetChild(0)
    for i = 1, itemsPanel.childCount do
        if itemsPanel.transform:GetChild(i-1).gameObject.activeSelf then
            local item = itemsPanel.transform:GetChild(i-1):GetComponent(typeof(UI_Equip_Item))
            if item.Index == Index then
                return item
            end
        end
    end
end
---
---部分刷新
---
function equipItemControl:refresh()
    if _equippedItem then
        self:HandleOnItemLoadedHandler(_equippedItem)
    end
    if _selectItem then
        self:HandleOnItemLoadedHandler(_selectItem)
    end

end

---
---全部刷新
---
function equipItemControl:refreshList()
    -- ListView重新加载方法
    local _itemsVisible_row = _scrollViewAdapter._itemsVisible_row
    local _itemsVisible_line = _scrollViewAdapter._itemsVisible_line
    _scrollViewAdapter:Reload(#_ItemsToShow)
end

return equipItemControl