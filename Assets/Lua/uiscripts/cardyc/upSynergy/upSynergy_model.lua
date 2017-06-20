local upSynergy_model = {}

--获取数据库信息
function upSynergy_model:getDatas(cardIndex)
    print("================upSynergy_model:getDatas============start===========")
    if currencyTbl == nil or cardTbl == nil or userRoleTbl == nil  then
        return false
    end 
    if not cardTbl[cardIndex] then
        return false
    end 
    self.goldNum = currencyTbl["gold"] --金币
    self.badgeNum = currencyTbl["coin"] --兵牌
    self.cardId =cardTbl[cardIndex].id
    self.cardLv =cardTbl[cardIndex].lv
    self.starLv =cardTbl[cardIndex].star
    self.synergyLvTbl = cardTbl[cardIndex].team--协同表
    self:init_synergyIDTbl()
    self:init_synergyStateTbl()
    print("================upSynergy_model:getDatas============end===========")
    return true
    
end


--[[
                        协同部分
]]
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
    for k,v in ipairs(cardTbl) do 
        if self.synergyIDTbl[index] == v.id then 
            if v.star < synergyUtil:getRequireCardStar(self.synergyIDTbl[index],index) then 
                print("协同---卡牌星级不足！！！")
                tipsText = stringUtil:getString(20601)
                return tipsText
            end
            if v.lv < synergyUtil:getRequireCardLevel(self.synergyIDTbl[index],index) then 
                print("协同---卡牌等级不足！！！")
                tipsText = stringUtil:getString(20602)
                return tipsText
            end
            if v.rlv < synergyUtil:getRequireCardQuality(self.synergyIDTbl[index],index) then 
                print("协同---卡牌阶品不足！！！")
                tipsText = stringUtil:getString(20603)
                return tipsText
            end
            isCardCan = true
        end 
    end
    if not isCardCan then 
        print("协同---卡牌不存在！！！")
        tipsText = stringUtil:getString(20604)
        return tipsText
    end 
    if self.synergyLvTbl[index] >= Const.MAX_SYNERGY_LV then
        print("协同---已达最大等级")
        tipsText = stringUtil:getString(20605)
        return tipsText
    end
    --兵牌
    local needCoin = synergyUtil:getNeedCoin(self.synergyLvTbl[index] + 1)
    if self.badgeNum < needCoin then
        print("协同---不够..")
        tipsText = stringUtil:getString(20606)
        return tipsText
    end
    
    --金币
    local needgold = synergyUtil:getNeedGold(self.synergyLvTbl[index] + 1)
    if self.goldNum < needgold then
        print("协同---金币不够..")
        tipsText = stringUtil:getString(20607)
        return tipsText
    end

    return 0
end

--获取卡牌对象
function upSynergy_model:getCardByID(cardId)
    for k,v in ipairs(cardTbl) do
        if v.id == cardId then
            return v
        end
    end
    return nil
end


return upSynergy_model