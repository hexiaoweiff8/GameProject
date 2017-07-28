---
--- Created by Administrator.
--- DateTime: 2017/7/20 17:32
---

local class = require("common/middleclass")
local cardInHand_model = class("cardInHand_model", fight_model)

local _view
---初始化数据，计算一些常量
function cardInHand_model:initDatas(view)
    _view = view

    -- UIRoot的locationScale
    self._urlc = GameObject.Find("/UIRoot").transform.localScale.x
    self.max_Y = _view.handCards_bg:GetComponent("UIWidget").height / 2

    self.bigColliderSize = Vector3(3000, 420, 0)
    self.bigColliderCenter = Vector3(0, self.bigColliderSize.y / 2 + self.max_Y,0)

    self.power_leftX = _view.power.transform.localPosition.x - _view.power:GetComponent("UIWidget").width / 2
    self.power_rightX = _view.power.transform.localPosition.x + _view.power:GetComponent("UIWidget").width / 2


    ---
    self.flyStartPosition = _view.leftCard.transform.localPosition
end



---初始化卡牌最原始的数据
function cardInHand_model:initHandCardsData()
    ---手牌
    self.nowMyCardtb = {}
    ---手牌原始位置
    self.myCardConstPostb = {}

    for var = 1, Const.FIGHT_HANDCARD_NUM do
        self.nowMyCardtb[var] = _view.handCards[var]
        self.myCardConstPostb[var] = _view.handCards[var].transform.position
    end
end


---区域功能
cardInHand_model.AREA_TODO={
    NOTHING = 0,    --什么都不做
    DROP = 1,       --放下模型
    RECOVERY = 2    --卡牌回收
}
---根据触摸点所在的位置判断当前位置的功能
function cardInHand_model:getArea(Vec3, cardIndex)
    ---计算在Y轴移动的距离
    local curCardY = Vec3.y
    local orgCardY = self.myCardConstPostb[cardIndex].y / self._urlc
    local move_Y = curCardY - orgCardY


    if move_Y < self.max_Y then
        print(Vec3.x)
        if Vec3.x > self.power_leftX and Vec3.x < self.power_rightX then
            return 2
        elseif move_Y > 0 then
            return 0 ,  ( self.max_Y - move_Y ) / self.max_Y
        else
            return 0
        end
    elseif move_Y >= self.max_Y then---显示模型
        return 1
    else
        return 0
    end

end

return cardInHand_model