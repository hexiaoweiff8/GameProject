
local class = require("common/middleclass")
ItemSlot = class("ItemSlot")


function ItemSlot:initialize(parent, positon ,index, func)

    self.itemhead = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "armyMedalPanel", parent).gameObject
    self.itemhead_Sprite = self.itemhead.transform:Find("Sprite").gameObject
    self.itemhead_lockSp = self.itemhead.transform:Find("lockSp").gameObject
    self.itemhead_itemSp = self.itemhead.transform:Find("itemSp").gameObject
    self.itemhead_plusSp = self.itemhead.transform:Find("plusSp").gameObject
    self.itemhead_numLab = self.itemhead.transform:Find("label").gameObject

    local depthNum = parent.transform:GetComponent("UIWidget").depth
    self.itemhead.transform.localPosition = positon
    self.itemhead_Sprite.transform:GetComponent("UISprite").depth = depthNum + 1
    self.itemhead_lockSp.transform:GetComponent("UISprite").depth = depthNum + 2
    self.itemhead_itemSp.transform:GetComponent("UISprite").depth = depthNum + 3
    self.itemhead_plusSp.transform:GetComponent("UISprite").depth = depthNum + 4
    self.itemhead_numLab.transform:GetComponent("UILabel").depth = depthNum + 5
    self.itemhead_plusSp:SetActive(false)
    UIEventListener.Get(self.itemhead_itemSp).onClick = function()
        func(_,index)
    end
end

--刷新物品插槽
function ItemSlot:refresh(itemId, haveItemsNum, needItemsNum, state)
    self.itemhead_itemSp.transform:GetComponent("UISprite").spriteName = itemUtil:getItemIcon(itemId)
    self.itemhead_numLab.transform:GetComponent("UILabel").text = string.format("%d/%d",haveItemsNum,needItemsNum)    
    self.itemhead_Sprite:SetActive(false)
    self.itemhead_lockSp:SetActive(true)
    if state == qualityUtil.EquipState.Enable_NotEnough then
        self.itemhead_itemSp.transform:GetComponent("UISprite").color = COLOR.Gray
        self.itemhead_plusSp:SetActive(false)
        self.itemhead_numLab:SetActive(true)
    elseif state == qualityUtil.EquipState.Enable_Enough then
        self.itemhead_itemSp.transform:GetComponent("UISprite").color = COLOR.White
        self.itemhead_plusSp:SetActive(true)
        self.itemhead_numLab:SetActive(true)
    elseif state == qualityUtil.EquipState.Active then
        self.itemhead_Sprite:SetActive(true)
        self.itemhead_lockSp:SetActive(false)
        self.itemhead_plusSp:SetActive(false)
        self.itemhead_numLab:SetActive(false)
        self.itemhead_itemSp.transform:GetComponent("UISprite").color = COLOR.White
    end
end




return ItemSlot