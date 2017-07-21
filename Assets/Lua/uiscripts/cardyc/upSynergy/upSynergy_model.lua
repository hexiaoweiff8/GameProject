local class = require("common/middleclass")
local upSynergy_model=class("upSynergy_model", wnd_cardyc_model)

upSynergy_model.SynergyState = { --协同状态
    unactive = 0,--未激活
    canActive = 1,--可激活
    activated = 2,--已解锁
}
upSynergy_model.synergyStateTbl = {}        --协同状态
upSynergy_model.synergyIDTbl={}   -----协同ID

function upSynergy_model:init_synergyStateTbl()
    -- body
    for i = 1,#self.synergyLvTbl do
        if self.synergyLvTbl[i] > 0 then
            self.synergyStateTbl[i] = self.SynergyState.activated
        else
            if self:isCan_UpSynergy(i) == 0 then
                self.synergyStateTbl[i] = self.SynergyState.canActive
            else
                self.synergyStateTbl[i] = self.SynergyState.unactive
            end
        end
    end
end

function upSynergy_model:init_synergyIDTbl()
    for i = 1,#self.synergyLvTbl do
        self.synergyIDTbl[i] = 101001+i
    end
end




function upSynergy_model:isCan_UpSynergy(index)
    local isCardCan = false
    for k,v in ipairs(cardModel:getCardTbl()) do
        if self.synergyIDTbl[index] == v.id then 
            if v.star < synergyUtil:getRequireCardStar(self.synergyIDTbl[index],index) then 
                print("协同---卡牌星级不足！！！")
                return stringUtil:getString(20601)
            end
            if v.lv < synergyUtil:getRequireCardLevel(self.synergyIDTbl[index],index) then 
                print("协同---卡牌等级不足！！！")
                return stringUtil:getString(20602)
            end
            if v.rlv < synergyUtil:getRequireCardQuality(self.synergyIDTbl[index],index) then 
                print("协同---卡牌阶品不足！！！")
                return stringUtil:getString(20603)
            end
            isCardCan = true
        end 
    end
    if not isCardCan then 
        print("协同---卡牌不存在！！！")
        return stringUtil:getString(20604)
    end 
    if self.synergyLvTbl[index] >= Const.MAX_SYNERGY_LV then
        print("协同---已达最大等级")
        return stringUtil:getString(20605)
    end
    --兵牌
    local needCoin = synergyUtil:getNeedCoin(self.synergyLvTbl[index] + 1)
    if self.badgeNum < needCoin then
        print("协同---不够..")
        return stringUtil:getString(20606)
    end
    
    --金币
    local needgold = synergyUtil:getNeedGold(self.synergyLvTbl[index] + 1)
    if self.goldNum < needgold then
        print("协同---金币不够..")
        return stringUtil:getString(20607)
    end

    return 0
end

--获取卡牌对象
function upSynergy_model:getCardByID(cardId)
    for k,v in ipairs(cardModel:getCardTbl()) do
        if v.id == cardId then
            return v
        end
    end
    return nil
end


return upSynergy_model