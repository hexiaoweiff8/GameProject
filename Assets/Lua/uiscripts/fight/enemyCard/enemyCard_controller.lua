---
--- Created by Administrator.
--- DateTime: 2017/7/25 12:19
---

local enemyCard_controller = {}
local _view = require("uiscripts/fight/enemyCard/enemyCard_view")
local _data = require("uiscripts/fight/enemyCard/enemyCard_model")
local _CardAI = require("uiscripts/CardAI/main")
---初始化
local timerTbl = {}
local cardTbl = {}
function enemyCard_controller:Init(view)
    _view:initView(view)
    local cardNumTbl = {}
    sdata_cardplanenemy_data:Foreach(
    function (key, value)
        cardNumTbl[value[1]] = value[2]
    end)
    --_CardAI:Init(cardModel:getCardTbl(), cardNumTbl)
end

---
---敌人下兵
---
function enemyCard_controller:AIDropCard()
    --如果敌人费够
    if _data.enemyNextCard and _data.enemyNowFei >= _data.enemyNextCard.TrainCost then
        self:addEnemyCardHistoryUI(_data.enemyNextCard.id)
        Event.Brocast(GameEventType.ENEMY_DROP_CARD)
    end
end


---添加敌人卡牌历史记录的UI
function enemyCard_controller:addEnemyCardHistoryUI(cardID)

    if #cardTbl == 5 then
        Object.Destroy(cardTbl[1])
        table.remove(cardTbl,1)
        timerTbl[1]:Kill()
        table.remove(timerTbl, 1)
    end
    --增加敌人出牌UI
    local euc = GameObject.Instantiate(_view.enemyUsedCard)
    euc:SetActive(true)
    euc.transform.parent = _view.enemyUsedCardsGrid.transform
    euc.transform.localScale = _view.enemyUsedCard.transform.localScale
    euc.transform:Find("Sprite"):GetComponent(typeof(UISprite)).spriteName = cardUtil:getCardIcon(cardID)
    --重新排列
    _view.enemyUsedCardsGrid.transform:GetComponent(typeof(UIGrid)):Reposition()
    table.insert(cardTbl, euc)
    --敌人出牌UI几秒后消失
    local cardTimer = TimeUtil:CreateTimer(10, function ()
        Object.Destroy(euc.gameObject)
        timerTbl[1]:Kill()
    end)
    table.insert(timerTbl, cardTimer)

    for i = 1, #cardTbl do
        --点击敌人出的卡牌相机跟随该敌兵
        UIEventListener.Get(euc).onPress = function(go, args)
            if args then
                local model = ModelControl:getEnemyModel(i)
                if model then
                    _view.UIFollow.Target = model
                end
            end
        end
    end

end

return enemyCard_controller