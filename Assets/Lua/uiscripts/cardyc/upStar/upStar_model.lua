local class = require("common/middleclass")
local upStar_model=class("upStar_model", wnd_cardyc_model)



--判断是否可以升星
function upStar_model:isCan_UpStar()
    --是否达到最大星级
    if self.starLv == Const.MAX_STAR_LV then
        print("卡牌已达最大星级")
        return stringUtil:getString(20301)
    end
    --所需碎片是否足够
    if starUtil:getUpStarNeedFragment(self.starLv + 1) > self.cardFragment then
        print("卡牌升星所需碎片不足")
        return stringUtil:getString(20302)
    end
    --所需兵牌是否足够
    if starUtil:getUpStarNeedCoin(self.starLv + 1) > self.badgeNum then
        print("卡牌升星所需兵牌不足")
        return stringUtil:getString(20303)
    end
    return 0
end



return upStar_model