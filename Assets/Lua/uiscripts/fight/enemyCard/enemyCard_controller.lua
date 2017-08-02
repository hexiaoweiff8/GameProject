---
--- Created by Administrator.
--- DateTime: 2017/7/25 12:19
---

local enemyCard_controller = {}
local _view = require("uiscripts/fight/enemyCard/enemyCard_view")
local _data = require("uiscripts/fight/enemyCard/enemyCard_model")

local timerTbl = {}
local cardTbl = {}
local index = 0
function enemyCard_controller:Init(view)
    _view:initView(view)
end

function enemyCard_controller:AIDropCard()
    if #_data.enemyPaiKutb == 0 then
        return
    end
    --如果敌人费够
    if _data.enemyNowFei >= _data.enemyPaiKutb[1].TrainCost then
        self:addEnemyCardHistoryUI(_data.enemyPaiKutb[1].id)
        Event.Brocast(GameEventType.ENEMY_DROP_CARD)
    end
end



function enemyCard_controller:addEnemyCardHistoryUI(cardID)
    index = index + 1
    if index > 5 then
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
    --点击敌人出的卡牌相机跟随该敌兵
    UIEventListener.Get(euc).onPress = function(go, args)
        if args then
            local model = ModelControl:getEnemyModel(cardID)
            if model then
                _view.UIFollow.target = model
            end
        end
    end

    table.insert(cardTbl, euc)
    --敌人出牌UI几秒后消失
    local cardTimer = TimeUtil:CreateTimer(10, function ()
        Object.Destroy(euc.gameObject)
        timerTbl[1]:Kill()
    end)
    table.insert(timerTbl, cardTimer)

end

return enemyCard_controller