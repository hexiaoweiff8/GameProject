local upLevel_model={}


--获取数据库信息
function upLevel_model:getDatas(cardIndex)
    print("================upLevel_model:getDatas============start===========")
    if currencyTbl == nil or cardTbl == nil or userRoleTbl == nil  then
        return false
    end 
    if not cardTbl[cardIndex] then
        return false
    end 
    self.expPool = currencyTbl["expPool"]--经验池
    self.userRoleLv= userRoleTbl["lv"]
    self.userRoleLv= 80
    self.cardId =cardTbl[cardIndex].id
    self.cardLv =cardTbl[cardIndex].lv
    self.starLv =cardTbl[cardIndex].star
    self.cardExp  = cardTbl[cardIndex].exp
    print("================upLevel_model:getDatas============end===========")
    return true
    
end



--判断是否可以升级
function upLevel_model:isCan_UpLevel()
    if self.cardLv == Const.MAX_CARD_LV then
        print("已达最大卡牌等级")
        tipsText = stringUtil:getString(20201)
        return tipsText
    end
    if self.cardLv >= self.userRoleLv then
        print("卡牌等级不能超过角色等级，请先提升角色等级")
        tipsText = stringUtil:getString(20203)
        return tipsText
    end
    if self.expPool == 0 then
        print("可分配经验不足") 
        tipsText = stringUtil:getString(20202)
        return tipsText
    end
    return 0
end




return upLevel_model