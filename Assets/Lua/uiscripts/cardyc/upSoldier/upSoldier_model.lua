local upSoldier_model={}


--获取数据库信息
function upSoldier_model:getDatas(cardIndex)
    print("================upSoldier_model:getDatas============start===========")
    if currencyTbl == nil or cardTbl == nil or userRoleTbl == nil  then
        return false
    end 
    if not cardTbl[cardIndex] then
        return false
    end 
    self.badgeNum = currencyTbl["coin"] --兵牌
    self.cardId =cardTbl[cardIndex].id
    self.cardLv =cardTbl[cardIndex].lv
    self.starLv =cardTbl[cardIndex].star
    self.soldierLv = cardTbl[cardIndex].slv
    self.cardFragment = cardTbl[cardIndex].num
    print("================upSoldier_model:getDatas============end===========")
    return true
    
end




--[[
                        兵员部分
]]
--判断是否可以提升兵员等级
function upSoldier_model:isCan_UpSoldier()
    --判断等级
    if self.soldierLv >= 8 then
        print("兵员等级已达上限，不可提升")
        tipsText = stringUtil:getString(20501)
        return tipsText
    end
    --判断卡牌碎片是否足够
    if self:getUpSoldierNeedGoods("Card",self.soldierLv + 1) > self.cardFragment then
        print("卡牌碎片不足")
        tipsText = stringUtil:getString(20502)
        return tipsText
    end
    --判断兵牌是否足够
    if self:getUpSoldierNeedGoods("Coin",self.soldierLv + 1) > self.badgeNum then
        print("兵牌碎片不足")
        tipsText = stringUtil:getString(20503)
        return tipsText
    end
    return 0
end
function upSoldier_model:getUpSoldierNeedGoods(property,soldierLv)
    return sdata_armycarduselimitcost_data:GetFieldV(property,soldierLv)
end
function upSoldier_model:getSoldierLimit(soldierLv)
    local uid = tonumber(string.format("%d%.2d",self.cardId,soldierLv))
    return sdata_armycarduselimit_data:GetFieldV("UseLimit",uid)
end


return upSoldier_model