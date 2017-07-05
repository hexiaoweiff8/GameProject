local class = require("common/middleclass")
CardHead = class("CardHead")


function CardHead:initialize(parent, positon)
    -- body
    --获取控件
    self.cardhead = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "cardhead", parent).gameObject
    self.cardhead_bg = self.cardhead.transform:Find("bg").gameObject
    self.cardhead_imgSp = self.cardhead.transform:Find("img_Sp").gameObject--卡牌图
    self.cardhead_lv_bg = self.cardhead.transform:Find("lv_bg").gameObject--等级
    self.cardhead_lv_Lab = self.cardhead.transform:Find("lv_bg/lv_Lab").gameObject --等级
    self.cardhead_medalSp = self.cardhead.transform:Find("medal_Sp").gameObject--军阶图
    self.cardhead_starPanel = self.cardhead.transform:Find("StarPanel").gameObject   

    --计算父对象深度
    local depthNum = 1
    if parent.transform:GetComponent("UIWidget") then 
        depthNum = parent.transform:GetComponent("UIWidget").depth
    end 
    --初始化卡牌头像显示信息
    self.cardhead.transform.localPosition = positon
    --设置图集
    -- self.cardhead_imgSp.transform:GetComponent("UISprite").atlas = TestAtlas
    for i=1 , Const.MAX_STAR_LV do
        self.cardhead_starPanel.transform:Find("star_"..i).gameObject:GetComponent("UISprite").depth=depthNum+3
    end
    --设置各个控件的层级
    self.cardhead.transform:GetComponent("UIWidget").depth = depthNum
    self.cardhead_bg.transform:GetComponent("UISprite").depth =depthNum
    self.cardhead_imgSp.transform:GetComponent("UISprite").depth = depthNum+1
    self.cardhead_lv_bg.transform:GetComponent("UISprite").depth =depthNum+2
    self.cardhead_lv_Lab.transform:GetComponent("UILabel").depth =depthNum+2
    self.cardhead_medalSp.transform:GetComponent("UISprite").depth = depthNum+2
    self.cardhead_starPanel.transform:GetComponent("UIWidget").depth = depthNum+3
end

function CardHead:refresh(cardId, cardLv, starLv)
    --设置级数
    self.cardhead_lv_Lab.transform:GetComponent("UILabel").text = cardLv
    --设置卡牌头像图片
    
    self.cardhead_imgSp.transform:GetComponent("UISprite").spriteName = cardUtil:getCardIcon(cardId)
    --设置卡牌星级显示
    for i=1,Const.MAX_STAR_LV do
        local star = self.cardhead_starPanel.transform:Find("star_"..i).gameObject
        star:SetActive(true)
        if i > starLv then
            star:SetActive(false)
        end
    end
end
return CardHead