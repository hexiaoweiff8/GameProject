---
--- Created by Administrator.
--- DateTime: 2017/7/20 17:32
---

local cardInHand_view = {}

local view
function cardInHand_view:initView(arg)
    view = arg
    self.handCards_bg = view.transform:Find("bg/bg").gameObject
    ---出兵碰撞事件触发碰撞器
    self.handCards = {}
    self.handCards_CDSpr = {}
    self.handCards_Icon = {}
    self.handCards_costLab = {}
    self.handCards_bigCollider = {}
    self.handCards_Lv = {}
    self.handCards_StarLv = {}
    for i = 1, Const.FIGHT_HANDCARD_NUM do
        self.handCards[i] = view.transform:Find("handCards/currentCard" .. i).gameObject
        self.handCards_CDSpr[i] = self.handCards[i].transform:Find("CDBar").gameObject
        self.handCards_Icon[i] = self.handCards[i].transform:Find("cardSprite").gameObject
        self.handCards_costLab[i] = self.handCards[i].transform:Find("feiBg/costLabel").gameObject
        self.handCards_bigCollider[i] = self.handCards[i].gameObject:AddComponent(typeof(UnityEngine.BoxCollider))
        self.handCards_Lv[i] = self.handCards[i].transform:Find("LVLab").gameObject
        self.handCards_StarLv[i] = self.handCards[i].transform:Find("feiBg/star/Lab").gameObject
    end

    ---卡牌详细信息
    -- 卡牌信息tf
    self.cardInfoBg = view.transform:Find("cardInfoBg")
    self.targetType = self.cardInfoBg.transform:Find("target").gameObject
    self.attackValue = self.cardInfoBg.transform:Find("attack/value").gameObject
    self.defenceValue = self.cardInfoBg.transform:Find("defence/value").gameObject
    self.HPValue= self.cardInfoBg.transform:Find("HP/value").gameObject

    -- 当前UI相机
    self.nowUICamera = GameObject.Find("/UIRoot/Camera_UI"):GetComponent(typeof(UnityEngine.Camera))
    -- PTZCamera相机
    self.PTZCameraTf = GameObject.Find("/PTZCamera").transform
    -- 当前3d相机
    self.nowWorldCamera = self.PTZCameraTf:Find("SceneryCamera"):GetComponent(typeof(UnityEngine.Camera))


    -- 能量部分
    self.power = view.transform:Find("power").gameObject

    self.leftCard = view.transform:Find("shengyu_bg").gameObject
end

return cardInHand_view