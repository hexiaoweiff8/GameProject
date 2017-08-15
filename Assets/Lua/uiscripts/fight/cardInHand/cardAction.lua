---
--- Created by Administrator.
--- DateTime: 2017/8/2 16:57
---
local CanNotArea = require("uiscripts/fight/CanNotArea")
local cardAction = {}

---初始化数据
local _data
local _view
local _powerController
function cardAction:Init(view,data)
    _data = data
    _view = view
    _powerController = require("uiscripts/fight/power/power_controller")
end

---
---控制不可下兵区域的显隐
---
function cardAction:showCanNotArea()
    CanNotArea:Show()
end
function cardAction:hideCanNotArea()
    CanNotArea:Hide()
end

---
---控制卡牌详细信息的显隐
---
function cardAction:showCardInfo(cardIndex)
    local card = _data.nowHandpaiKutb[cardIndex]
    _view.cardInfoBg.gameObject:SetActive(true)
    _view.cardInfoBg.transform.parent = _data.nowMyCardtb[cardIndex].transform.parent
    _view.cardInfoBg.localPosition = _data.nowMyCardtb[cardIndex].transform.localPosition + Vector3(0,_data.nowMyCardtb[cardIndex]:GetComponent("UIWidget").height / 2,0)

    _view.targetType:GetComponent("UILabel").text = cardUtil:getCardPropValue("AimGeneralType", card.id, card.lv)
    _view.attackValue:GetComponent("UILabel").text = cardUtil:getCardPropValue("Attack1", card.id, card.lv)
    _view.defenceValue:GetComponent("UILabel").text = cardUtil:getCardPropValue("Defence", card.id, card.lv)
    _view.HPValue:GetComponent("UILabel").text = cardUtil:getCardPropValue("HP", card.id, card.lv)
end
function cardAction:hideCardInfo()
    _view.cardInfoBg.gameObject:SetActive(false)
end




---
---控制能量提示的显隐
---
local isShowRecycleTips = {false,false,false,false}
function cardAction:showRecycleTips(cardIndex)
    if not isShowRecycleTips[cardIndex] then
        _powerController:addRecyclePower(_data.nowHandpaiKutb[cardIndex].TrainCost)
        _powerController:showRecycleTips()
        isShowRecycleTips[cardIndex] = true
    end
end
function cardAction:hideRecycleTips(cardIndex)
    if isShowRecycleTips[cardIndex] then
        _powerController:subRecyclePower(_data.nowHandpaiKutb[cardIndex].TrainCost)
        _powerController:hideRecycleTips()
        isShowRecycleTips[cardIndex] = false
    end
end


---
---根据触摸点的位置获取功能
---
function cardAction:doEvent(go,cardIndex)
    ---通过滑动位置判断相应的功能。
    local area = _data:getArea(go.transform.localPosition,cardIndex)
    ---没有出手牌区域，还原手牌显示
    if area == _data.AREA_TODO.NOTHING then
        go.transform.localScale = Vector3.one
        ModelControl:DestroyModel(cardIndex)
        --- 放下模型
    elseif area == _data.AREA_TODO.DROP then
        ---能量不足
        if _data.nowFei < _data.nowHandpaiKutb[cardIndex].TrainCost then
            UIToast.Show("能量不足")
            go.transform.localScale = Vector3.one
            ModelControl:DestroyModel(cardIndex)
        else
            go.transform.localScale = Vector3.zero
            Event.Brocast(GameEventType.DROP_CARD, cardIndex)

        end
        ---卡牌回收
    elseif area == _data.AREA_TODO.RECYCLE then
        if _data.nowFei >= _data.allFei then
            UIToast.Show("能量已满")
            go.transform.localScale = Vector3.one
        else
            go.transform.localScale = Vector3.zero
            Event.Brocast(GameEventType.RECOVERY_CARD, cardIndex)
        end
        ModelControl:DestroyModel(cardIndex)
    end

    ---还原卡牌位置
    _data.isCardSelected[cardIndex] = false
    go.transform.position = _data.myCardConstPostb[cardIndex]
    --显示卡牌CD
    _view.handCards_CDSpr[cardIndex].gameObject:SetActive(true)

    _view.handCards_bigCollider[cardIndex].enabled = false


    ---隐藏不可下兵区域和点击出兵事件,如果还有已选中的卡牌则取消隐藏
    for i = 1, Const.FIGHT_HANDCARD_NUM do
        if _data.isCardSelected[i] then
            --显示点击下兵的相应事件
            self:showCanNotArea()
            return
        end
    end
    self:hideCanNotArea()
end

return cardAction