---
--- Created by Administrator.
--- DateTime: 2017/7/25 12:19
---

local enemyCard_controller = {}
local _view = require("uiscripts/fight/enemyCard/enemyCard_view")
local _data = require("uiscripts/fight/enemyCard/enemyCard_model")


function enemyCard_controller:Init(view)
    _view:initView(view)
    -- 敌方下次出的卡牌费
    self.nextEnemyCardFei = nil
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
    --敌人出牌UI几秒后消失
    coroutine.start(function()
        coroutine.wait(10)
        Object.Destroy(euc.gameObject)
    end)

end

return enemyCard_controller