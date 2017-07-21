local class = require("common/middleclass")

wnd_cardyc_model = class("wnd_cardyc_model")

--获取数据库信息
function wnd_cardyc_model:getDatas(cardIndex)
    print("================wnd_cardyc_model:getDatas============start===========")
    ---获取角色表中的数据
    local _userRoleTbl = userModel:getUserRoleTbl()
    if _userRoleTbl == nil  then
        return false
    end
    self.userRoleLv= _userRoleTbl["lv"]
    self.userRoleLv= 80

    ---获取卡牌表中的数据。
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
    self.synergyLvTbl = _cardTbl[cardIndex].team--协同表
    self.soldierLv = _cardTbl[cardIndex].slv
    self.skill_Lv_Table = _cardTbl[cardIndex].skill
    self.cardExp  = _cardTbl[cardIndex].exp
    self.slotState = _cardTbl[cardIndex].slot

    ---获取经济表中的数据
    local _currencyTbl = currencyModel:getCurrentTbl()
    if _currencyTbl == nil then
        return false
    end
    self.expPool = _currencyTbl.expPool--经验池
    self.badgeNum = _currencyTbl.coin --兵牌
    self.goldNum = _currencyTbl.gold --金币
    self.totalSkPt = _currencyTbl.skillPt --技能点

    local _itemTbl = itemModel:getItemTbl()
    if _itemTbl == nil  then
        return false
    end
    self.itemList = _itemTbl

    print("================wnd_cardyc_model:getDatas============end===========")
    return true
    
end

--获取卡牌数量
function wnd_cardyc_model:getCardNum()
    return #cardModel:getCardTbl()
end



return wnd_cardyc_model