---
--- Created by Administrator.
--- DateTime: 2017/7/20 17:31
---
local cardInHand_controller = {}
local _view = require("uiscripts/fight/cardInHand/cardInHand_view")
local _data = require("uiscripts/fight/cardInHand/cardInHand_model")

---判断是否拖拽的标志位
local _isDrag
local _isClickDrop
---
---onPress方法的携程
local _onPressCoroutine

function cardInHand_controller:Init(view)

    _view:initView(view)
    _data:initDatas(_view)
    ---初始化手牌数据
    _data:initHandCardsData()

    self:Refresh()
    self:AddListener()
end


---界面刷新方法
---cardIndex    可选为nil时刷新所有，否则刷新对应index的卡牌
function cardInHand_controller:Refresh(cardIndex)

    for var = 1, Const.FIGHT_HANDCARD_NUM do
        if not cardIndex or (cardIndex and cardIndex == var) then
            if _data.nowHandpaiKutb[var] then
                _view.handCards[var]:SetActive(true)
                _view.handCards[var].transform.localPosition = _data.flyStartPosition
                _view.handCards[var].transform.localScale = Vector3.zero
                _view.handCards_Icon[var]:GetComponent(typeof(UISprite)).spriteName = cardUtil:getCardIcon(_data.nowHandpaiKutb[var].id)
                _view.handCards_costLab[var]:GetComponent(typeof(UILabel)).text = cardUtil:getTrainCost(_data.nowHandpaiKutb[var].id)
                _view.handCards_bigCollider[var].center = _data.bigColliderCenter
                _view.handCards_bigCollider[var].size = _data.bigColliderSize
                _view.handCards_bigCollider[var].enabled = false


                TweenPosition.Begin( _view.handCards[var], 0.2, _data.myCardConstPostb[var], true)
                TweenScale.Begin( _view.handCards[var], 0.2, Vector3.one)
            else
                _view.handCards[var]:SetActive(false)
            end
        end
    end

    if not cardIndex then
        ModelControl:InitMyModels(_data.nowHandpaiKutb)
    else
        ModelControl:RefreshMyModels( _data.nowHandpaiKutb[cardIndex],cardIndex)
    end

end



---为卡牌选项添加监听
function cardInHand_controller:AddListener()

    for cardIndex = 1, Const.FIGHT_HANDCARD_NUM do

        ---拖动开始事件添加监听
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onDragStart = function(go)
            --拖动事件
            print("onDragStart")
            _isDrag = true

            --显示不可下兵区域
            self:showCanNotArea()
            --隐藏卡牌CD
            _view.handCards_CDSpr[cardIndex].gameObject:SetActive(false)
            --关闭卡牌详细信息
            if _onPressCoroutine then
                coroutine.stop(_onPressCoroutine)
                self:hideCardInfo()
            end
        end

        ---拖动事件添加监听
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onDrag = function(go,delta)
            --拖动事件
            --print("onDrag")
            local touchPoint = TouchControl:getTouchPoint(cardIndex)
            ---
            ---卡牌跟随鼠标移动
            ---
            local cardWordPosition = _view.nowUICamera:ScreenToWorldPoint(touchPoint) / _data._urlc
            local model = ModelControl:getMyModel(cardIndex)
            go.transform.localPosition = Vector3(cardWordPosition.x, cardWordPosition.y, 0)
            ---通过滑动的位置判断相应的功能。
            local area , scale = _data:getArea(cardWordPosition,cardIndex)
            if area == _data.AREA_TODO.NOTHING then
                if not scale then
                    scale = 1
                end
                model.gameObject:SetActive(false)
                go.transform.localScale = Vector3(scale,scale,scale)
            elseif area == _data.AREA_TODO.DROP then---显示模型
            go.transform.localScale = Vector3.zero
                model.gameObject:SetActive(true)
                -- 模型跟随鼠标位置移动
                local ray = _view.nowWorldCamera:ScreenPointToRay(touchPoint)
                local isC, hit = UnityEngine.Physics.Raycast(ray, hit, 1000, 256)--256 == bit.lshift(1, 8) == 1<<8
                AStarControl:setZhangAi(hit.point, cardIndex)

            elseif area == _data.AREA_TODO.RECYCLE then---卡牌回收
            go.transform.localScale = Vector3.one
                model.gameObject:SetActive(false)
            end

        end

        ---拖动结束事件添加监听
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onDragEnd = function(go)
            --拖动事件
            print("onDragEnd")
            self:doEvent(go,cardIndex)
        end

        ---点击事件添加监听
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onClick = function(go)
            --拖动事件
            print("onClick")

            ---当不是点击出牌时，则只是进行卡牌的选中和取消选择。
            if not _isClickDrop then
                if not _data.isCardSelected[cardIndex] then
                    self:cardUp(cardIndex)
                    self:showCanNotArea()

                else
                    self:cardDown(cardIndex)
                    self:hideCanNotArea()
                end
            else
                _isClickDrop = false
            end
        end

        ---长按事件添加监听
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onPress = function(go, args)
            if args then
                print("onPress true")
                --添加触控点
                TouchControl:addTouch(cardIndex)


                if _data.isCardSelected[cardIndex] then
                    local touchPoint = TouchControl:getTouchPoint(cardIndex)
                    local cardWordPosition = _view.nowUICamera:ScreenToWorldPoint(touchPoint) / _data._urlc
                    local clickPosition = Vector3(cardWordPosition.x, cardWordPosition.y, 0)
                    if Vector3.Distance(clickPosition,_data.nowMyCardtb[cardIndex].transform.localPosition) > _data.max_Y then
                        _isClickDrop = true
                        local model = ModelControl:getMyModel(cardIndex)
                        model.gameObject:SetActive(true)
                        -- 模型跟随鼠标位置移动
                        local ray = _view.nowWorldCamera:ScreenPointToRay(touchPoint)
                        local isC, hit = UnityEngine.Physics.Raycast(ray, hit, 1000, 256)--256 == bit.lshift(1, 8) == 1<<8
                        AStarControl:setZhangAi(hit.point, cardIndex)
                        go.transform.localScale = Vector3.zero
                        go.transform.localPosition = Vector3(cardWordPosition.x, cardWordPosition.y, 0)
                    end
                end

                _onPressCoroutine = coroutine.start(function()
                    coroutine.wait(1)
                    if not _isDrag and not _isClickDrop then
                        self:showCardInfo(cardIndex)
                    end
                end)
            else
                print("onPress false")

                ---点击出牌且没有拖动时
                if _isClickDrop and not _isDrag then
                    self:doEvent(go, cardIndex)
                else    ---重置标志位
                _isClickDrop = false
                    _isDrag = false
                end
                ---删除无用触点
                TouchControl:removeTouch(cardIndex)
                coroutine.stop(_onPressCoroutine)
                self:hideCardInfo()
            end
        end


    end
end


---刷新卡牌CD显示，由fight_controller的update方法调用
function cardInHand_controller:refreshCardCD()
    --卡牌CD
    for var = 1, 4 do
        if _data.nowHandpaiKutb[var] then
            local tempInt = _data.nowHandpaiKutb[var].TrainCost
            if _data.nowFei < tempInt then
                _view.handCards_CDSpr[var]:GetComponent("UISprite").fillAmount = 1 - _data.nowFei / tempInt
            else
                _view.handCards_CDSpr[var]:GetComponent("UISprite").fillAmount = 0
            end
        end
    end
end

---控制不可下兵区域的显隐
function cardInHand_controller:showCanNotArea()
    _view.canotRect.gameObject:SetActive(true)
end
function cardInHand_controller:hideCanNotArea()
    _view.canotRect.gameObject:SetActive(false)
end

---控制卡牌详细信息的显隐
function cardInHand_controller:showCardInfo(cardIndex)
    _view.cardInfoBg.gameObject:SetActive(true)
    _view.cardInfoBg.transform.parent = _data.nowMyCardtb[cardIndex].transform.parent
    _view.cardInfoBg.localPosition = _data.nowMyCardtb[cardIndex].transform.localPosition + Vector3(0, 100, 0)
end
function cardInHand_controller:hideCardInfo()
    _view.cardInfoBg.gameObject:SetActive(false)
end

---手牌上下移动
function cardInHand_controller:cardDown(index)
    _data.isCardSelected[index] = false
    _view.handCards_bigCollider[index].enabled = false
    TweenPosition.Begin(_data.nowMyCardtb[index].gameObject, 0.2, _data.myCardConstPostb[index], true)
end
function cardInHand_controller:cardUp(index)
    _data.isCardSelected[index] = true
    _view.handCards_bigCollider[index].enabled = true
    TweenPosition.Begin(_data.nowMyCardtb[index].gameObject, 0.2, _data.myCardConstPostb[index] + Vector3(0,0.1,0), true)
    for i = 1, Const.FIGHT_HANDCARD_NUM do
        if i ~= index then
            self:cardDown(i)
        end
    end
end

---根据触摸点的位置获取功能
function cardInHand_controller:doEvent(go,cardIndex)


    ---通过滑动位置判断相应的功能。
    local area = _data:getArea(go.transform.localPosition,cardIndex)
    ---没有出手牌区域，还原手牌显示
    if area == _data.AREA_TODO.NOTHING then
        go.transform.localScale = Vector3.one
        --- 放下模型
    elseif area == _data.AREA_TODO.DROP then
        --能量不足
        if _data.nowFei < _data.nowHandpaiKutb[cardIndex].TrainCost then
            UIToast.Show("能量不足", nil, UIToast.ShowType.Upwards)
            go.transform.localScale = Vector3.one
            ModelControl:getMyModel(cardIndex).gameObject:SetActive(false)
        else
            go.transform.localScale = Vector3.zero
            Event.Brocast(GameEventType.DROP_CARD, cardIndex)
        end
        ---卡牌回收
    elseif area == _data.AREA_TODO.RECYCLE then
        if _data.nowFei >= _data.allFei then
            UIToast.Show("能量已满", nil, UIToast.ShowType.Upwards)
            go.transform.localScale = Vector3.one
        else
            go.transform.localScale = Vector3.zero
            Event.Brocast(GameEventType.RECOVERY_CARD, cardIndex)
        end
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
return cardInHand_controller