---
--- Created by Administrator.
--- DateTime: 2017/7/25 12:19
---
local enemyCard_view = {}

local _view
function enemyCard_view:initView(view)
    _view = view

    -- 敌方出的卡牌Grid
    self.enemyUsedCardsGrid = _view.transform:Find("enemyUsedCardsGrid").gameObject
    -- 敌方出的卡牌
    self.enemyUsedCard = self.enemyUsedCardsGrid.transform:Find("enemyUsedCard").gameObject
    -- PTZCamera相机
    self.PTZCameraTf = GameObject.Find("/PTZCamera").transform
    -- 相机跟随UIFollow
    self.UIFollow = self.PTZCameraTf:GetComponent(typeof(UIFollow))

    ---测试UI

    self.AITEST = view.transform:Find("test").gameObject
    self.AIINFO = view.transform:Find("test/tip/scrollView/AIINFO").gameObject
    self.PLAYERINFO = view.transform:Find("test/tip/scrollView/PLAYERINFO").gameObject
    self.console = view.transform:Find("test/console/scrollView/cons").gameObject
    self.result = view.transform:Find("test/result/scrollView/cons").gameObject


    self.AITEST:SetActive(false)
end

return enemyCard_view