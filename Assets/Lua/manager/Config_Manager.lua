local class = require("common/middleclass")
Config_Manager = class("Config_Manager")

--==============================--
--desc:装填常驻内存的lua部分配置表 如果需要c#使用 则需要在c#部分添加调用
--time:2017-06-17 04:50:45
--@return 
--==============================--
function Config_Manager:LoadConfig()
    --常量表
    sdata_constant_data = luacsv.new(require("pk_tabs/Constant")) 
    --读取士兵阵型表
    sdata_array_data = luacsv.new(require("pk_tabs/array_c"))
    --读取士兵模型表
    sdata_soldierRender_data = luacsv.new(require("pk_tabs/soldierRender_data"))
    --读取装备数据表
    sdata_equip_data = luacsv.new(require("pk_tabs/equip_c"))
    --读取属性名数据表
    sdata_attribute_data = luacsv.new(require("pk_tabs/attribute_c"))
    --读取装备属性成长值表
    sdata_attributeplan_data = luacsv.new(require("pk_tabs/attributeplan_c"))
    --读取装备套装数据表
    sdata_equipsuit_data = luacsv.new(require("pk_tabs/equipsuit_c"))
    --读取装备属性方案数据表
    sdata_EquipPlan_data = require("pk_tabs/EquipPlan_data")
    --读取语言本地化数据表
    sdata_UILiteral = luacsv.new(require("pk_tabs/UILiteral"))
    --科技表
    sdata_tech_data = luacsv.new(require("pk_tabs/tech_c"))


    --用户角色表
    sdata_userrose_data = luacsv.new(require("pk_tabs/userdata_c"))
    --单位目标权重表
    sdata_armyaim_data = luacsv.new(require("pk_tabs/armyaim_c"))
    --单位aoe表
    sdata_armyaoe_data = luacsv.new(require("pk_tabs/armyaoe_c"))
    --卡牌表
    sdata_armybase_data = luacsv.new(require("pk_tabs/armybase_c"))
    --卡牌基础表
    sdata_armycardbase_data = luacsv.new(require("pk_tabs/armycardbase_c"))
    --卡牌经验表
    sdata_armycardexp_data = luacsv.new(require("pk_tabs/armycardexp_c"))
    --品质表
    sdata_armycardquality_data = luacsv.new(require("pk_tabs/armycardquality_c"))
    --品质消耗表
    sdata_armycardqualitycost_data = luacsv.new(require("pk_tabs/armycardqualitycost_c"))
    --品质显示表
    sdata_armycardqualityshow_data = luacsv.new(require("pk_tabs/armycardqualityshow_c"))
    --技能消耗表
    sdata_armycardskillcost_data = luacsv.new(require("pk_tabs/armycardskillcost_c"))
    --星级表
    sdata_armycardstar_data = luacsv.new(require("pk_tabs/armycardstar_c"))
    --星级消耗表
    sdata_armycardstarcost_data = luacsv.new(require("pk_tabs/armycardstarcost_c"))
    --协同表
    sdata_armycardunion_data = luacsv.new(require("pk_tabs/armycardunion_c"))
    --协同消耗表
    sdata_armycardunioncost_data = luacsv.new(require("pk_tabs/armycardunioncost_c"))
    --兵员表
    sdata_armycarduselimit_data = luacsv.new(require("pk_tabs/armycarduselimit_c"))
    --兵员消耗表
    sdata_armycarduselimitcost_data = luacsv.new(require("pk_tabs/armycarduselimitcost_c"))
    --技能表
    sdata_skill_data = luacsv.new(require("pk_tabs/skill_c"))
	--克制关系表
    sdata_kezhi_data = luacsv.new(require("pk_tabs/kezhi_c"))
    --手选宝箱表
    sdata_selectchest_data = luacsv.new(require("pk_tabs/selectchest_c"))
    --仓库物品表
    sdata_item_data = luacsv.new(require("pk_tabs/item_c"))
    --仓库页卡标签表
    sdata_pack_data = luacsv.new(require("pk_tabs/pack_c"))
    --装备强化所需能量表
    sdata_equippower_data = luacsv.new(require("pk_tabs/equippower_c")) 
    
    -----------------------------------C#需要调用的配置表在以下位置添加---------------------------------------
    SDataUtils.setData("constant", sdata_constant_data.mData.head, sdata_constant_data.mData.body)
    SDataUtils.setData("armyaim_c", sdata_armyaim_data.mData.head, sdata_armyaim_data.mData.body)
    SDataUtils.setData("armyaoe_c", sdata_armyaoe_data.mData.head, sdata_armyaoe_data.mData.body)
    SDataUtils.setData("armybase_c", sdata_armybase_data.mData.head, sdata_armybase_data.mData.body)
    SDataUtils.setData("armycardbase_c", sdata_armycardbase_data.mData.head, sdata_armycardbase_data.mData.body)
    SDataUtils.setData("array_c", sdata_array_data.mData.head, sdata_array_data.mData.body)
    SDataUtils.setData("soldierRender", sdata_soldierRender_data.mData.head, sdata_soldierRender_data.mData.body)
    SDataUtils.setData("kezhi_c", sdata_kezhi_data.mData.head, sdata_kezhi_data.mData.body)

end

return Config_Manager