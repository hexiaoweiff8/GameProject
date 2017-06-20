local wnd_cardyc_model={}

--获取数据库信息
function wnd_cardyc_model:getDatas(cardIndex)
    print("================wnd_cardyc_model:getDatas============start===========")
    if currencyTbl == nil or cardTbl == nil or userRoleTbl == nil  then
        return false
    end 
    if not cardTbl[cardIndex] then
        return false
    end 

  
    self.cardId =cardTbl[cardIndex].id
    self.cardLv = cardTbl[cardIndex].lv
    self.starLv = cardTbl[cardIndex].star
    self.qualityLv = cardTbl[cardIndex].rlv
    self.cardFragment = cardTbl[cardIndex].num
    print("================wnd_cardyc_model:getDatas============end===========")
    return true
    
end

--获取卡牌数量
function wnd_cardyc_model:getCardNum()
    return #cardTbl
end

return wnd_cardyc_model