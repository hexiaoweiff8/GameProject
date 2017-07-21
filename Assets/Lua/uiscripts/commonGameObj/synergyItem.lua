
local class = require("common/middleclass")
SynergyItem = class("SynergyItem")

SynergyItem.SynergyState = { --协同状态
    unactive = 0,--未激活
    canActive = 1,--可激活
    activated = 2,--已解锁
}
--创建协同选项
function SynergyItem:initialize(parent,index,func)
    -- body
    self.synergyItem = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "itemPanel", parent).gameObject
    self.synergyItem_Sp = self.synergyItem.transform:Find("Sprite").gameObject
    self.synergyItem_itemBg = self.synergyItem.transform:Find("bkSp").gameObject
    self.synergyItem_redDot = self.synergyItem.transform:Find("redDot").gameObject
    self.synergyItem_plusSp = self.synergyItem.transform:Find("plusSp").gameObject
    self.synergyItem_upSp = self.synergyItem.transform:Find("upSp").gameObject
    self.synergyItem_nowPropL = self.synergyItem.transform:Find("Container/atdAddLab").gameObject
    self.synergyItem_nextPropL = self.synergyItem.transform:Find("Container/atdAddNextLab").gameObject

    self.synergyItem.transform.localPosition = Vector3(0, 180-104*(index-1))


    UIEventListener.Get(self.synergyItem).onClick = function()
        func(_,index)
    end

end
--刷新协同选项
function SynergyItem:refresh(synergyCardID, state, isCanUp, index)


    local CardName = cardUtil:getCardName(synergyCardID)
    local spriteName = cardUtil:getCardIcon(synergyCardID)

    local needStarLv = synergyUtil:getRequireCardStar(synergyCardID,index)
    local needCardLv = synergyUtil:getRequireCardLevel(synergyCardID,index)
    local needQualityLv = synergyUtil:getRequireCardQuality(synergyCardID,index)

    local synergyAttributeID = synergyUtil:getSynergyAttribute(synergyCardID,index)

    local attributeName = attributeUtil:getAttributeName(synergyAttributeID)
    local attributePoint = synergyUtil:getSynergyPoint(synergyCardID,index)
    local attributeSymbol = attributeUtil:getAttributeSymbol(synergyAttributeID)
    --初始化协同选项


    --设置卡牌头像图片
    
    self.synergyItem_Sp.transform:GetComponent("UISprite").spriteName = spriteName
    self.synergyItem_Sp.transform:GetComponent("UISprite").color = COLOR.Gray
    self.synergyItem_itemBg.transform:GetComponent("UISprite").color = COLOR.Gray
    self.synergyItem_upSp:SetActive(false)
    self.synergyItem_plusSp:SetActive(false)
    self.synergyItem_redDot:SetActive(redDotFlag.RD_SYNERGYITEMS[index])
    
    if needStarLv ~= -1 then
        self.synergyItem_nowPropL.transform:GetComponent("UILabel").text 
            = string.format(stringUtil:getString(20608), CardName, needStarLv, "00FF00", attributeName, attributePoint, attributeSymbol)
    elseif needCardLv ~= -1 then
        self.synergyItem_nowPropL.transform:GetComponent("UILabel").text 
            = string.format(stringUtil:getString(20609), CardName, needCardLv, "00FF00", attributeName, attributePoint, attributeSymbol)
    elseif needQualityLv ~= -1 then
        self.synergyItem_nowPropL.transform:GetComponent("UILabel").text 
            = string.format(stringUtil:getString(20610), CardName, needQualityLv, "00FF00", attributeName, attributePoint, attributeSymbol)
    end
    

    self.synergyItem_nextPropL:SetActive(false)
    self.synergyItem_nextPropL.transform:GetComponent("UILabel").text 
        = string.format("%s","已激活")


    if state == self.SynergyState.unactive  then
        self.synergyItem_nowPropL.transform:GetComponent("UILabel").color = COLOR.Gray
        self.synergyItem_nextPropL.transform:GetComponent("UILabel").color = COLOR.Gray
    --如果可以激活显示激活加号图标
    elseif state == self.SynergyState.canActive  then
        self.synergyItem_nowPropL.transform:GetComponent("UILabel").color = COLOR.Gray
        self.synergyItem_nextPropL.transform:GetComponent("UILabel").color = COLOR.Gray
        self.synergyItem_plusSp:SetActive(true)

    --如果已经激活字体和图片颜色变亮
    elseif state == self.SynergyState.activated  then
        self.synergyItem_nextPropL:SetActive(true)
        self.synergyItem_Sp.transform:GetComponent("UISprite").color = COLOR.White
        self.synergyItem_itemBg.transform:GetComponent("UISprite").color = COLOR.White
        self.synergyItem_nowPropL.transform:GetComponent("UILabel").color = COLOR.White
        self.synergyItem_nextPropL.transform:GetComponent("UILabel").color = COLOR.White
        if isCanUp == 0 then 
            self.synergyItem_upSp:SetActive(true)
        end
    end
end


return SynergyItem