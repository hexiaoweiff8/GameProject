---
--- Created by Administrator.
--- DateTime: 2017/7/20 17:31
---
local cardInHand_controller = {}
local _view = require("uiscripts/fight/cardInHand/cardInHand_view")
local _data = require("uiscripts/fight/cardInHand/cardInHand_model")
local _cardAction = require("uiscripts/fight/cardInHand/cardAction")


local _isDrag---判断是否拖拽的标志位
local _isClickDrop---判断是否点击出牌的标志位

local _onPressCoroutine---onPress方法的携程

function cardInHand_controller:Init(view)

    ---初始化数据
    _view:initView(view)
    _data:initDatas(_view)

    ---卡牌动作方法
    _cardAction:Init(_view,_data)
    ---初始化手牌数据
    _data:initHandCardsData()

    self:Refresh()
    self:AddListener()
end

---
---界面刷新方法
---cardIndex    可选为nil时刷新所有，否则刷新对应index的卡牌
---
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
                _view.handCards_Lv[var]:GetComponent("UILabel").text = "LV.".._data.nowHandpaiKutb[var].lv
                _view.handCards_StarLv[var]:GetComponent("UILabel").text = "X".._data.nowHandpaiKutb[var].starLv

                TweenPosition.Begin( _view.handCards[var], 0.2, _data.myCardConstPostb[var], true)
                TweenScale.Begin( _view.handCards[var], 0.2, Vector3.one)
            else
                _view.handCards[var]:SetActive(false)
            end
        end
    end

    --if not cardIndex then
    --    ModelControl:InitMyModels(_data.nowHandpaiKutb)
    --else
    --    ModelControl:RefreshMyModels( _data.nowHandpaiKutb[cardIndex],cardIndex)
    --end

end


---
---为卡牌选项添加监听
---
function cardInHand_controller:AddListener()

    for cardIndex = 1, Const.FIGHT_HANDCARD_NUM do

        ---
        ---拖动开始事件添加监听
        ---
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onDragStart = function(go)
            ---拖动开始事件
            print("onDragStart")
            _isDrag = true
            self:upDepth(go, 20)
            --显示不可下兵区域
            _cardAction:showCanNotArea()

            if not _isClickDrop then
                ModelControl:CreateModel(_data.nowHandpaiKutb[cardIndex].id, cardIndex)
            end

            --隐藏卡牌CD
            _view.handCards_CDSpr[cardIndex].gameObject:SetActive(false)
            --关闭卡牌详细信息
            if _onPressCoroutine then
                coroutine.stop(_onPressCoroutine)
                _cardAction:hideCardInfo()
            end
        end

        ---
        ---拖动事件添加监听
        ---
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onDrag = function(go,delta)
            ---拖动事件
            --print("onDrag")
            ---
            ---卡牌跟随鼠标移动
            ---
            local touchPoint = TouchControl:getTouchPoint(cardIndex)
            local cardWordPosition = _view.nowUICamera:ScreenToWorldPoint(touchPoint) / _data._urlc
            go.transform.localPosition = Vector3(cardWordPosition.x, cardWordPosition.y, 0)
            ---通过滑动的位置判断相应的功能。
            local area , scale = _data:getArea(cardWordPosition,cardIndex)
            if area == _data.AREA_TODO.NOTHING then ---卡牌处于原始位置
            if not scale then
                scale = 1
            end
                ---卡牌缩放效果
                go.transform.localScale = Vector3(scale,scale,scale)
                ModelControl:HideModel(cardIndex)
                _cardAction:hideRecycleTips(cardIndex)
            elseif area == _data.AREA_TODO.DROP then ---显示模型并使模型跟随触摸点
            go.transform.localScale = Vector3.zero
                ModelControl:ShowModel(cardIndex)
                local ray = _view.nowWorldCamera:ScreenPointToRay(touchPoint)-- 模型跟随鼠标位置移动
                local isC, hit = UnityEngine.Physics.Raycast(ray, hit, 1000, 256)--256 == bit.lshift(1, 8) == 1<<8
                ModelControl:MoveModel(hit.point, cardIndex)
                _cardAction:hideRecycleTips(cardIndex)
            elseif area == _data.AREA_TODO.RECYCLE then ---卡牌回收
            go.transform.localScale = Vector3.one
                ModelControl:HideModel(cardIndex)
                _cardAction:showRecycleTips(cardIndex)
            end

        end

        ---
        ---拖动结束事件添加监听
        ---
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onDragEnd = function(go)
            ---拖动结束事件
            print("onDragEnd")
            self:upDepth(go, -20)
            _cardAction:hideRecycleTips(cardIndex)
            _cardAction:doEvent(go,cardIndex)
        end

        ---
        ---点击事件添加监听
        ---
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onClick = function(go)
            ---点击事件事件
            print("onClick")

            ---当不是点击出牌时，则只是进行卡牌的选中和取消选择。
            if not _isClickDrop then
                if not _data.isCardSelected[cardIndex] then
                    self:cardUp(cardIndex)
                    _cardAction:showCanNotArea()

                else
                    self:cardDown(cardIndex)
                    _cardAction:hideCanNotArea()
                end
            else
                _isClickDrop = false
            end
        end

        ---
        ---长按事件添加监听
        ---
        UIEventListener.Get(_data.nowMyCardtb[cardIndex]).onPress = function(go, args)
            if args then
                print("onPress true")
                ---初始化标志位
                _isClickDrop = false
                ---添加触控点
                TouchControl:addTouch(cardIndex)
                if _data.isCardSelected[cardIndex] then
                    local touchPoint = TouchControl:getTouchPoint(cardIndex)
                    local cardWordPosition = _view.nowUICamera:ScreenToWorldPoint(touchPoint) / _data._urlc
                    local clickPosition = Vector3(cardWordPosition.x, cardWordPosition.y, 0)
                    if Vector3.Distance(clickPosition,_data.nowMyCardtb[cardIndex].transform.localPosition) > _data.max_Y then
                        _isClickDrop = true
                        ModelControl:CreateModel(_data.nowHandpaiKutb[cardIndex].id, cardIndex)
                        -- 模型跟随鼠标位置移动
                        local ray = _view.nowWorldCamera:ScreenPointToRay(touchPoint)
                        local isC, hit = UnityEngine.Physics.Raycast(ray, hit, 1000, 256)--256 == bit.lshift(1, 8) == 1<<8
                        ModelControl:ShowModel(cardIndex)
                        ModelControl:MoveModel(hit.point, cardIndex)
                        go.transform.localScale = Vector3.zero
                        go.transform.localPosition = clickPosition
                    end
                end

                ---长按事件响应显示卡牌信息
                _onPressCoroutine = coroutine.start(function()
                    coroutine.wait(1)
                    if not _isDrag and not _isClickDrop then
                        _cardAction:showCardInfo(cardIndex)
                    end
                end)
            else
                print("onPress false")
                ---点击出牌且没有拖动时
                if _isClickDrop and not _isDrag then
                    _cardAction:doEvent(go, cardIndex)
                    _isClickDrop = false
                else    ---重置标志位
                    _isClickDrop = false
                    _isDrag = false
                    --ModelControl:DestroyModel(cardIndex)
                end
                ---删除无用触点
                TouchControl:removeTouch(cardIndex)
                coroutine.stop(_onPressCoroutine)
                _cardAction:hideCardInfo()
            end
        end


    end
end

---
---刷新卡牌CD显示，由fight_controller的update方法调用
---
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

---
---手牌上下移动
---
function cardInHand_controller:cardDown(index)
    _data.isCardSelected[index] = false
    _view.handCards_bigCollider[index].enabled = false
    TweenPosition.Begin(_data.nowMyCardtb[index].gameObject, 0, _data.myCardConstPostb[index], true)
end
function cardInHand_controller:cardUp(index)
    _data.isCardSelected[index] = true
    _view.handCards_bigCollider[index].enabled = true
    TweenPosition.Begin(_data.nowMyCardtb[index].gameObject, 0, _data.myCardConstPostb[index] + Vector3(0,0.1,0), true)
    for i = 1, Const.FIGHT_HANDCARD_NUM do
        if i ~= index then
            self:cardDown(i)
        end
    end
end

---
---设置一个物体及其所有子物体的层级
---gameObj		要是设置的物体
---depthDelta	层级增量
---
function cardInHand_controller:upDepth(gameObj,depthDelta)
    gameObj:GetComponent("UIWidget").depth = gameObj:GetComponent("UIWidget").depth + depthDelta
    for i = 0, gameObj.transform.childCount - 1 do
        self:upDepth(gameObj.transform:GetChild(i), depthDelta)
    end
    return
end

return cardInHand_controller