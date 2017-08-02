---
--- Created by Administrator.
--- DateTime: 2017/7/19 14:25
---

local fight_view = {}

local view
function fight_view:init(arg)
    view = arg
    self.time_txt = view.transform:Find("basic/time_bg/txt"):GetComponent("UILabel")
    --self.myBloodBar = view.transform:Find("defence_widget1/bg/hp_fg"):GetComponent("UISprite")

    ---不可下兵区域的父物体
    self.canotRectP = GameObject.Find("/SceneRoot/canotRectGo")

    ---已准备好的卡牌
    -- 装载ui卡牌的panel
    self.currentCards_bg = view.transform:Find("handCards")

    --费Bounds
    --费barUISprite
    self.feiBg = view.transform:Find("currentCards_bg/feiBg/feiBg")


    ---卡牌详细信息
    -- 卡牌信息tf
    self.cardInfoBg = view.transform:Find("cardInfoBg")

    ---地方出牌信息
    -- 敌方出的卡牌Grid
    self.enemyUsedCardsGridTf = view.transform:Find("enemyUsedCardsGrid")
    -- 敌方出的卡牌Grid组件
    self.enemyUsedCardsGrid = view.transform:Find("enemyUsedCardsGrid"):GetComponent(typeof(UIGrid))
    -- 敌方出的卡牌
    self.enemyUsedCard = self.enemyUsedCardsGridTf:Find("enemyUsedCard")


    ---暂停部分
    -- 暂停按钮
    self.btn_pause = view.transform:Find("basic/btn_pause")
    -- 暂停倒计时
    self.daojishi = view.transform:Find("daojishi")


    -- PTZCamera相机
    self.PTZCameraTf = GameObject.Find("/PTZCamera").transform
    -- 相机跟随UIFollow
    self.UIFollow = self.PTZCameraTf:GetComponent(typeof(UIFollow))
    -- 相机移动BoxScrollObject
    self.BoxScrollObject = self.PTZCameraTf:GetComponent(typeof(BoxScrollObject))
    -- 当前3d相机
    self.nowWorldCamera = self.PTZCameraTf:Find("SceneryCamera"):GetComponent(typeof(UnityEngine.Camera))
    -- 当前UI相机
    self.nowUICamera = GameObject.Find("/UIRoot/Camera_UI"):GetComponent(typeof(UnityEngine.Camera))
    -- DragDropRoot
    self.DragDropRoot = GameObject.Find("/UIRoot/DragDropRoot").transform
    --HUDText
    self.hudtext = view.transform:Find("HUDText"):GetComponent(typeof(HUDText))

    ---跳转按钮
    self.jumpToMyMain = view.transform:Find("btn_main").gameObject
    self.jumpToFirst = view.transform:Find("btn_first").gameObject

end

function fight_view:getView()

end

return fight_view