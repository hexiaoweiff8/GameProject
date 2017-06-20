local upStar_model={}


--获取数据库信息
function upStar_model:getDatas(cardIndex)
    print("================upStar_model:getDatas============start===========")
    if currencyTbl == nil or cardTbl == nil or userRoleTbl == nil  then
        return false
    end 
    if not cardTbl[cardIndex] then
        return false
    end 
    self.expPool = currencyTbl["expPool"]--经验池
    self.badgeNum = currencyTbl["coin"] --兵牌
    self.cardId =cardTbl[cardIndex].id
    self.cardLv=cardTbl[cardIndex].lv
    self.starLv =cardTbl[cardIndex].star
    self.cardFragment = cardTbl[cardIndex].num
    print("================upStar_model:getDatas============end===========")
    return true
    
end

--判断是否可以升星
function upStar_model:isCan_UpStar()
    --是否达到最大星级
    if self.starLv == Const.MAX_STAR_LV then
        print("卡牌已达最大星级")
        tipsText = stringUtil:getString(20301)
        return tipsText
    end
    --所需碎片是否足够
    if starUtil:getUpStarNeedFragment(self.starLv + 1) > self.cardFragment then
        print("卡牌升星所需碎片不足")
        tipsText = stringUtil:getString(20302)
        return tipsText
    end
    --所需兵牌是否足够
    if starUtil:getUpStarNeedCoin(self.starLv + 1) > self.badgeNum then
        print("卡牌升星所需兵牌不足")
        tipsText = stringUtil:getString(20303)
        return tipsText
    end
    return 0
end



return upStar_model