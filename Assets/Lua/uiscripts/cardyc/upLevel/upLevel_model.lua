local class = require("common/middleclass")
local upLevel_model=class("upLevel_model", wnd_cardyc_model)



--判断是否可以升级
function upLevel_model:isCan_UpLevel()
    if self.cardLv == Const.MAX_CARD_LV then
        print("已达最大卡牌等级")
        return stringUtil:getString(20201)
    end
    if self.cardLv >= self.userRoleLv then
        print("卡牌等级不能超过角色等级，请先提升角色等级")
        return stringUtil:getString(20203)
    end
    if self.expPool == 0 then
        print("可分配经验不足")
        return stringUtil:getString(20202)
    end
    return 0
end




return upLevel_model