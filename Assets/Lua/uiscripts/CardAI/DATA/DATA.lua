local DATA = {}


---是否劣势
DATA.INFERIORITY = false

---我方能量数据
DATA.MY_POWER = {

    CAN_USE= 0,
    IN_USE = 0,

    ---所有克制单位能量和
    ALL_KILL_SKY = 0,
    ALL_KILL_GROUND = 0,

    ---群单位能量和
    GROUP_KILL_SKY = 0,
    GROUP_KILL_GROUNG = 0,

    ---隐形能量和
    INVISIBILITY_KILL_SKY = 0,
    INVISIBILITY_KILL_GROUND = 0,

    ---智械能量和
    MACHINE_KILL_SKY = 0,
    MACHINE_KILL_GROUND = 0,

    ---人族能量和
    PEOPLE_KILL_SKY = 0,
    PEOPLE_KILL_GROUND = 0,

    ---妖族能量和
    GHOAST_KILL_SKY = 0,
    GHOAST_KILL_GROUND = 0,

}

---敌人能量数据
DATA.ENEMY_POWER = {

    IN_USE = 0,

    ---所有单位能量和
    ALL_GROUND = 0,
    ALL_SKY = 0,

    ---群单位能量和
    GROUP_SKY = 0,
    GROUP_GROUNG = 0,
    GROUP_KILL_SKY = 0,
    GROUP_KILL_GROUNG = 0,

    ---隐形单位能量和
    INVISIBILITY_SKY = 0,
    INVISIBILITY_GROUND = 0,

    ---智械能量和
    MACHINE_SKY = 0,
    MACHINE_GROUND = 0,
    MACHINE_KILL_SKY = 0,
    MACHINE_KILL_GROUND = 0,

    ---人族能量和
    PEOPLE_SKY = 0,
    PEOPLE_GROUND = 0,
    PEOPLE_KILL_SKY = 0,
    PEOPLE_KILL_GROUND = 0,

    ---妖族能量和
    GHOAST_SKY = 0,
    GHOAST_GROUND = 0,
    GHOAST_KILL_SKY = 0,
    GHOAST_KILL_GROUND = 0,
}


---我方卡牌数量（无序）
DATA.CARD_NUM = {
    --[cardID_1] = num_1,
    --[cardID_2] = num_2,
    --...
}
---类型卡牌表（各类型卡牌有序，按单费战斗力从大到小排序）
DATA.CARD_TYPE = {
    --[typeId1] = {cardId1,...},
    --[typeId2] = {cardId1,...}
}


---卡牌单费战斗力表(无序)
DATA.CARD_FIHGT = {
    --[cardId1] = DANFEI,
    --[cardId2] = DANFEI,
}

---可吞牌库（有序：按单费战斗力从小到大排序）
DATA.CARD_EAT = {
    --cardId1,
    --cardId2
}

---卡牌平均单费战斗力
DATA.AVERAGE_FIGHT = nil

---最大单费战斗力卡牌
DATA.maxFightCard = nil




---
DATA.ATTRIBUTE = {
    --[1] = {
    --    attributeID,
    --    attributeCard = {
    --        [1] = {
    --            cardID,
    --            DANFEI
    --        },
    --        [2] = {
    --            cardID,
    --            DANFEI
    --        }
    --        ...
    --    }
    --}
    --...
}




return DATA