local restCard_controller = {}
local _view = require("uiscripts/fight/restCard/restCard_view")
local _data = require("uiscripts/fight/restCard/restCard_model")

function restCard_controller:Init(view)
    _view:initView(view)

    self:AddListener()

    self:Refresh()
end

---刷新方法
function restCard_controller:Refresh()
    self:initLeftMilitaryStrength()
    self:initNextCard()
end


---刷新剩余卡牌的显示
function restCard_controller:initLeftCardsPanel()

    --显示和隐藏9个卡牌UI
    local leftCardLength = #_data.paiKutb
    ---根据剩余卡牌的数量判断剩余卡牌界面的显示状态。
        --如果剩余卡牌数量大于九个，则最后一个显示为第九个以后的剩余卡牌的总数
    if leftCardLength > 9 then
        leftCardLength = 8
        _view.leftCardItem[9]:GetComponent(typeof(UISprite)).spriteName = spriteNameUtil.FIGHT_LEFTCARD_MORE
        _view.leftCardItem[9]:Find("paikuSpr").gameObject:SetActive(false)
        _view.leftCardItem[9]:Find("feiBg").gameObject:SetActive(false)
        local cardNum = 0
        for i = 9, #_data.paiKutb do
            cardNum = cardNum + _data.paiKutb[i].num
        end
        _view.leftCardItem[9]:Find("quan/remainNumLabel"):GetComponent(typeof(UILabel)).text = cardNum
        _view.leftCardItem[9].gameObject:SetActive(true)
        --剩余九张卡牌时，最后一个正常显示第九张卡牌
    elseif leftCardLength == 9 then
        _view.leftCardItem[9]:GetComponent(typeof(UISprite)).spriteName = spriteNameUtil.FIGHT_LEFTCARD_BG
        _view.leftCardItem[9]:Find("feiBg").gameObject:SetActive(true)
        _view.leftCardItem[9]:Find("paikuSpr").gameObject:SetActive(true)
    else
        --小于九张时，关闭不必要的显示
        for i = leftCardLength + 1, 9 do
            _view.paiKuBg.transform:Find("paikuCard" .. i).gameObject:SetActive(false)
        end
    end
    local sortList = _data:sortLeftCard(_data.paiKutb)
    --设置每个卡牌UI显示内容
    for i = 1, leftCardLength do
        _view.leftCardItem[i]:Find("paikuSpr"):GetComponent(typeof(UISprite)).spriteName = cardUtil:getCardIcon(sortList[i].id)
        _view.leftCardItem[i]:Find("feiBg/costLabel"):GetComponent(typeof(UILabel)).text = sortList[i].TrainCost
        _view.leftCardItem[i]:Find("quan/remainNumLabel"):GetComponent(typeof(UILabel)).text = sortList[i].num
        _view.leftCardItem[i].gameObject:SetActive(true)
    end

end

---刷新剩余兵力的显示
function restCard_controller:initLeftMilitaryStrength()
    _view.Left_MS_curLab:GetComponent("UILabel").text = stringUtil:getString(10031)--剩余兵力
    _view.allBingLiLabel:GetComponent("UILabel").text = _data:getRestTrainCost()
end

---刷新下一张卡牌的显示
function restCard_controller:initNextCard()
    if _data.nextCard then
        _view.nextCardBg:SetActive(true)
        _view.nextCardBg:GetComponent(typeof(UILabel)).text = stringUtil:getString(10032)
        _view.nextCardSpr.spriteName = cardUtil:getCardIcon(_data.nextCard.id)
        _view.nextCardLabel.text = _data.nextCard.TrainCost
        _view.nextCardLv:GetComponent("UILabel").text = "LV.".._data.nextCard.lv
        _view.nextCardStarLv:GetComponent("UILabel").text = "X".._data.nextCard.starLv
    else
        _view.nextCardBg:SetActive(false)
    end
end

---
---为界面中的按钮添加监听
---
function restCard_controller:AddListener()
    --牌库显示
    UIEventListener.Get(_view.Left_MilitaryStrength).onPress = function(go, args)
        if args then -- 开启协程
            --设置牌库信息
            self:initLeftCardsPanel()
            _view.paiKuBg:SetActive(true)
        else -- 停止协程
            _view.paiKuBg:SetActive(false)
        end
    end

end


return restCard_controller