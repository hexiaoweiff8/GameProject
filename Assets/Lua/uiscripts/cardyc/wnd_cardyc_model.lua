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
    local _cardSortTbl = cardModel:getCardSortTbl()
    local _cardId = _cardSortTbl[cardIndex]
    ---判断卡牌是否存在
    if not _cardId and not _cardTbl[_cardId] then
        return false
    end
    self.cardId = _cardTbl[_cardId].id
    self.cardLv = _cardTbl[_cardId].lv
    self.starLv = _cardTbl[_cardId].star
    self.qualityLv = _cardTbl[_cardId].rlv
    self.cardFragment = _cardTbl[_cardId].num
    self.synergyLvTbl = _cardTbl[_cardId].team--协同表
    self.soldierLv = _cardTbl[_cardId].slv
    self.skill_Lv_Table = _cardTbl[_cardId].skill
    self.cardExp  = _cardTbl[_cardId].exp
    self.slotState = _cardTbl[_cardId].slot

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




return wnd_cardyc_model