local class = require("common/middleclass")
Const = class("Const")


    Const.MAX_STAR_LV = 7
    Const.MAX_QUALITY_LV = 16
    Const.MAX_USERROLE_LV = 80
    Const.MAX_CARD_LV = 80
    Const.MAX_SKILL_LV = 16
    Const.MAX_ARMY_LV  = 8
    Const.MAX_SYNERGY_LV = 1
    Const.SLOT_NUM = 4
    Const.EQUIP_TYPE_NUM = 8
    Const.EQUIP_NORMALPROP_NUM = 5
    Const.EQUIP_ONBODY_MAX_NUM = 8
    Const.FIGHT_SKILLNUM = 3
    Const.FIGHT_HANDCARD_NUM = 4

    -- UIRoot的locationScale
    Const.urlc = GameObject.Find("/UIRoot").transform.localScale.x
return Const