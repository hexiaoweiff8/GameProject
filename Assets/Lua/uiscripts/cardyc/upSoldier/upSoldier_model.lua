local class = require("common/middleclass")
local upSoldier_model=class("upSoldier_model", wnd_cardyc_model)


--[[
                        兵员部分
]]
--判断是否可以提升兵员等级
function upSoldier_model:isCan_UpSoldier()
    --判断等级
    if self.soldierLv >= Const.MAX_ARMY_LV then
        print("兵员等级已达上限，不可提升")
        return stringUtil:getString(20501)
    end
    --判断卡牌碎片是否足够
    if soldierUtil:getUpSoldierNeedCardNum(self.soldierLv) > self.cardFragment then
        print("卡牌碎片不足")
        return stringUtil:getString(20502)
    end
    --判断兵牌是否足够
    if soldierUtil:getUpSoldierNeedCoinNum(self.soldierLv) > self.badgeNum then
        print("兵牌碎片不足")
        return stringUtil:getString(20503)
    end
    return 0
end

return upSoldier_model