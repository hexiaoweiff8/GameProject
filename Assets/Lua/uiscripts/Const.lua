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


    Const.CARDYC_INFORMATION_PROP_NUM = 8
    -- UIRoot的locationScale
    Const.urlc = GameObject.Find("/UIRoot").transform.localScale.x
    Const.CARD_PROP_NAME_TO_STRING_ID =
    {
        ["HP"] = 20801,
        ["Attack1"] = 20802,
        ["Defence"] = 20803,
        ["ArmyUnit"] = 20804,
        ["RangeType"] = 20805,
        ["ArmyType"] = 20806,
        ["GeneralType"] = 20807,
        ["IsCreature"] = 20808,
        ["AimGeneralType"] = 20809,
        ["AttackType"] = 20810,



        --["DeployTime"] = ,
        --["IsSummoned"] = ,
        --["Clipsize1"] = ,
        --["AttackRate1"] = ,
        --["ReloadTime1"] = ,
        --["Accuracy"] = ,
        --["SpaceSet"] = ,
        --["SpreadRange"] = ,
        --["MoveSpeed"] = ,
        --["Dodge"] = ,
        --["Hit"] = ,
        --["AntiArmor"] = ,
        --["Armor"] = ,
        --["AntiCrit"] = ,
        --["Crit"] = ,
        --["CritDamage"] = ,
        --["BulletType"] = ,
        --["BulletSpeed"] = ,
        --["BulletModel"] = ,
        --["BulletPath"] = ,
        --["MuzzleFlash"] = ,
        --["Ballistic"] = ,
        --["GetHit"] = ,
        --["AttackRange"] = ,
        --["SightRange"] = ,
        --["IsHide"] = ,
        --["IsAntiHide"] = ,
        --["LifeTime"] = ,
        --["Skill1"] = ,
        --["Skill2"] = ,
        --["Skill3"] = ,
        --["Skill4"] = ,
        --["Skill5"] = ,
        --["Pack"] = ,
        --["Texture"] = ,
        --["Prefab"] = ,


    }
    Const.CARD_PROP_NAME_TO_SPRITE_NAME =
    {
        ["HP"] = "tongyong_tubiao_shengming",
        ["Attack1"] = "tongyong_tubiao_huoli",
        ["Defence"] = "tongyong_tubiao_fangyu",
        ["ArmyUnit"] = "tongyong_tubiao_shengming",
        ["RangeType"] = "tongyong_tubiao_shecheng",
        ["ArmyType"] = "tongyong_tubiao_bingzhong",
        ["GeneralType"] = "tongyong_tubiao_shengming",
        ["IsCreature"] = "tongyong_tubiao_shengming",
        ["AimGeneralType"] = "tongyong_tubiao_mubiao",
        ["AttackType"] = "tongyong_tubiao_fanwei",
    }
return Const