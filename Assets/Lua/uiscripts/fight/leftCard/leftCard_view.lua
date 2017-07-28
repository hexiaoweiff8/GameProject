---
--- Created by Administrator.
--- DateTime: 2017/7/19 17:49
---

local leftCard_view = {}

local view
function leftCard_view:initView(arg)
    view = arg
    self.paiKuBg = view.transform:Find("paiKuBg").gameObject

    self.Left_MilitaryStrength = view.transform:Find("shengyu_bg").gameObject
    self.Left_MS_curLab = self.Left_MilitaryStrength.transform:Find("curBingLi").gameObject
    --剩余兵力Label
    self.allBingLiLabel = view.transform:Find("shengyu_bg/allBingLi").gameObject


    ---下一张卡牌
    self.nextCardBg = view.transform:Find("nextCard_bg").gameObject
    self.nextCardSpr = view.transform:Find("nextCard_bg/nextCard/cardSprite"):GetComponent(typeof(UISprite))
    -- 下一张卡牌的UILabel
    self.nextCardLabel = view.transform:Find("nextCard_bg/nextCard/feiBg/costLabel"):GetComponent(typeof(UILabel))

    self.leftCardItem = {}
    for i = 1, 9 do
        self.leftCardItem[i] = self.paiKuBg.transform:Find("paikuCard" .. i)
    end

end

return leftCard_view