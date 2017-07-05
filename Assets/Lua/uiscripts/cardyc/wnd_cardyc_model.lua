local wnd_cardyc_model={}

--获取数据库信息
function wnd_cardyc_model:getDatas(cardIndex)
    print("================wnd_cardyc_model:getDatas============start===========")
    local _cardTbl = cardModel:getCardTbl()
    if _cardTbl == nil then
        return false
    end 
    if not _cardTbl[cardIndex] then
        return false
    end 

  
    self.cardId = _cardTbl[cardIndex].id
    self.cardLv = _cardTbl[cardIndex].lv
    self.starLv = _cardTbl[cardIndex].star
    self.qualityLv = _cardTbl[cardIndex].rlv
    self.cardFragment = _cardTbl[cardIndex].num
    print("================wnd_cardyc_model:getDatas============end===========")
    return true
    
end

--获取卡牌数量
function wnd_cardyc_model:getCardNum()
    return #cardModel:getCardTbl()
end

return wnd_cardyc_model