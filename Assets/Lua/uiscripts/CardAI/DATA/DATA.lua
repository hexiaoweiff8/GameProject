local DATA = {}


---是否劣势
DATA.AI_STATE_BAD = true

---我方能量数据
DATA.AI_POWER = {}
---AI在战场上的全部费用
DATA.AI_ALL_POWER = 0

---敌人能量数据
DATA.ENEMY_POWER = {}
---敌人在战场上的全部费用
DATA.ENEMY_ALL_POWER = 0


---剩余卡牌数量
DATA.LEFT_CARD_NUM = 0
---卡牌总数
DATA.ALL_CARD_NUM  = 0
---我方卡牌数量表（无序）
DATA.CARD_NUM = {
    --[cardID_1] = num_1,
    --[cardID_2] = num_2,
    --...
}

---类型卡牌表（各类型卡牌有序，按单费战斗力从大到小排序）
DATA.TYPE_CARD = {
    --[typeId1] = {cardId1,...},
    --[typeId2] = {cardId1,...}
}

---卡牌平均单费战斗力
DATA.AVERAGE_FIGHT = 0
---最大单费战斗力卡牌
DATA.maxFightCard = nil
---卡牌总单费战斗力
DATA.ALL_CARD_FIGHT  = 0
---卡牌单费战斗力表(无序)
DATA.CARD_FIGHT = {
    --[cardId1] = DANFEI,
    --[cardId2] = DANFEI,
}


---可吞牌库（有序：按单费战斗力从小到大排序）
DATA.EAT_CARD = {
    --cardId1,
    --cardId2
}



---下一张卡牌
DATA.NEXT_CARD = 0
DATA.NEED_POWER = 0

---套路条件表
DATA.COMBO_FILTER = {}


---能量槽
DATA.POOL_COST = 0

return DATA