--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--header
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
wnd_cangku_model = {

	-- 仓库标签数据
	DepositoryTab_Count = 0,

	-- 道具ID
	ItemType = {
		[2] = '时装碎片',
		[3] = '消耗品',
		[4] = '随机宝箱',
		[5] = '手选宝箱',
		[6] = '升阶材料',
		[7] = '功能材料',
		[8] = '收藏品',
	},
	-- 装备碎片ID
	EquipmentFragmentType = {
		[4] = '紫',
		[5] = '橙',
		[6] = '红',
	},

	local_Tabs = {},-- 本地页卡表

	local_Items = {},-- 本地Items表
	-- local_Equipment = {},-- 本地Equipment表

	serv_Items = {},-- 从服务器获取的Items数据(id,num)
	-- serv_Equipment = {},-- 从服务器获取的Equipment数据
	-- serv_fitEquipmentList = {},-- 从服务器获取的已穿戴装备的id列表
	-- serv_CurrencyInfo = {},-- 从服务器获取的货币类信息

	decomposition_Equipment = {},-- 装备分解状态时使用的临时表
	Processed_Items = {},-- 处理后的仓库数据(全部,装备在前,道具在后)，用于显示在ScrollView上

	-- function
	initModel,
	initLocalTabsData,-- 读本地表页卡数据
	initLocalItemsData,-- 读本地Item表数据
	initLocalEquipData,-- 读本地装备表数据
	
	getLocalItemDetailByItemID,-- 在本地Item表查询对应ItemID的数据
	getLocalEquipmentDetailByEquipID,-- 在本地装备表查询对应EquipID的数据
	getEquipmentMainAttributeStr,-- 获取装备主属性字符串
}

local this = wnd_cangku_model

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_cangku_model:initModel()
	setmetatable(self,{__index = EquipModel})
	this:initLocalTabsData()
	this:initLocalItemsData()
end

function wnd_cangku_model:initLocalTabsData()
	if sdata_pack_data == nil then
		print("没获取到以下数据：sdata_pack_data")
		return
	end

	local Tab = {}

	this.DepositoryTab_Count = #sdata_pack_data.mData.body

	local offset = 1
	for k,v in pairs(sdata_pack_data.mData.body) do
		Tab["LabelID"] = v[sdata_pack_data.mFieldName2Index['LabelID']]
		Tab["TextID"] = v[sdata_pack_data.mFieldName2Index['TextID']]
		Tab["Goods"] = v[sdata_pack_data.mFieldName2Index['Goods']]
		Tab["Maintype"] = v[sdata_pack_data.mFieldName2Index['Maintype']]
		local _LabelID = Tab["LabelID"]
		Tab["Text"] = sdata_UILiteral.mData.body[0xFFFF-_LabelID+offset][sdata_UILiteral.mFieldName2Index["Literal"]]
		table.insert(this.local_Tabs,Tab)
		Tab = {}
	end

	table.sort(this.local_Tabs,function(a,b)
		return a["LabelID"] < b["LabelID"]
	end)

	print("read "..#this.local_Tabs.." Tabs(Local).")

	-- 由于是浅拷贝的原因不能这样赋值
	-- this.local_Tabs = Tabs
end

function wnd_cangku_model:initLocalItemsData()

	if sdata_item_data == nil then
		print("没获取到以下数据：sdata_item_data")
		return
	end	

	local Item = {}

	-- mFieldName2Index
	-- mData
	for k,v in pairs(sdata_item_data.mData.body) do

		Item["ItemID"] = v[sdata_item_data.mFieldName2Index['ItemID']]
		Item["UseType"] = v[sdata_item_data.mFieldName2Index['UseType']]
		Item["RelationID"] = v[sdata_item_data.mFieldName2Index['RelationID']]
		Item["Name"] = v[sdata_item_data.mFieldName2Index['Name']]
		Item["Des"] = v[sdata_item_data.mFieldName2Index['Des']]
		Item["FunctionDes"] = v[sdata_item_data.mFieldName2Index['FunctionDes']]
		Item["Icon"] =  v[sdata_item_data.mFieldName2Index['Icon']]
		Item["AvatarMode"] = v[sdata_item_data.mFieldName2Index['AvatarMode']]
		Item["Quality"] = v[sdata_item_data.mFieldName2Index['Quality']]
		Item["OverlapUse"] = v[sdata_item_data.mFieldName2Index['OverlapUse']]
		Item["OverlapLimit"] = v[sdata_item_data.mFieldName2Index['OverlapLimit']]
		Item["SaleGold"] = v[sdata_item_data.mFieldName2Index['SaleGold']]
		Item["ComposeNum"] = v[sdata_item_data.mFieldName2Index['ComposeNum']]
		Item["SelfUse"] = v[sdata_item_data.mFieldName2Index['SelfUse']]

		table.insert(this.local_Items,Item)

		Item = {}
	end

	table.sort(this.local_Items,function(a,b)
		return a["ItemID"] < b["ItemID"]
	end)

	print("read "..#this.local_Items.." Items(Local).")

	-- this.local_Items = Items
end

function wnd_cangku_model:getLocalItemDetailByItemID(itemID)
	for i = 1,#this.local_Items do
		if this.local_Items[i]["ItemID"] == itemID then
			return table.deepcopy(this.local_Items[i])
		end
	end
	Debugger.LogWarning(itemID.." not found in wnd_cangku_model:getLocalItemDetailByItemID(itemID)")
	return nil	
end

function wnd_cangku_model:getLocalEquipmentDetailByEquipID(equipmentID)
	for i = 1,#this.local_Equipment do
		if this.local_Equipment[i]["EquipID"] == equipmentID then
			return table.deepcopy(this.local_Equipment[i])
		end
	end
	Debugger.LogWarning(equipmentID.." not found in wnd_cangku_model:getLocalEquipmentDetailByEquipID(equipmentID)")
	return nil
end
--@params id:服务器传来的装备唯一id
--@return EquipType(Int32)
function wnd_cangku_model:getLocalEquipmentTypeByServID(id)
	for i = 1,#this.Processed_Items do
		if this.Processed_Items[i].id == id then
			return this.Processed_Items[i]["EquipType"]
		end
	end
	Debugger.LogWarning(id.." not found in wnd_cangku_model:getLocalEquipmentTypeByServID(id)")
	return nil
end

--@params EquipID:装备ID，AttributeID:属性ID(从服务器获取),lv:装备等级
--@return 装备主属性字符串
function wnd_cangku_model:getEquipmentMainAttributeStr(EquipID,AttributeID,lv)
	local _PlanID = this:getLocalEquipmentDetailByEquipID(EquipID)["MainAttribute"]
	local _AttributeID = AttributeID
	local _lv = lv
	local _UniqueID = tostring(_PlanID)..tostring(_AttributeID)

	if sdata_attributeplan_data.mData.body[tonumber(_UniqueID)] == nil then
		Debugger.LogWarning("没找到主属性,UniqueID = ".._UniqueID)
		return
	end

	local _AttributeMin = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['Min']]
	local _GrowthValue = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['up']]
	-- 主属性值 = 最小值 + 装备等级 * 成长系数
	local _AttributeValue = _AttributeMin + _lv * _GrowthValue

	local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
	local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

	local str = AttributeName.."+".._AttributeValue..Symbol

	return str
end

--@params equip:装备Data
--@return 装备副属性字符串
function wnd_cangku_model:getEquipmentSubAttributeStr(equip)
	local _AttributeID 
	local _lv = equip.lv
	local _UniqueID 

	local str = ""

	for i = 1,math.floor(_lv / cint.SUBATTR_NEED) do

		_AttributeID = equip.sndAttr[i].id

		local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

		if AttributeName == nil then
			Debugger.LogWarning("没找到副属性,AttributeID = ".._AttributeID)
			return
		end

		str = str..AttributeName.."+"..equip.sndAttr[i].val..Symbol.."\n"
	end

	return str
end
--@params SuitID:套装id
--@return 套装效果字符串
function wnd_cangku_model:getEquipmentSuitEffectStr(SuitID)
	local nilValue = -1
	local SuitEffect_2_AttributeID = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['SuitEffect2']]
	local SuitEffect_3_AttributeID = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['SuitEffect3']]
	local SuitEffect_5_AttributeID = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['SuitEffect5']]
	local SuitCount = 0
	local str = ""

	for i = 1,#this.serv_fitEquipmentList do
		if this:getEquipmentSuitIDByID(this.serv_fitEquipmentList[i]) == SuitID then
			SuitCount = SuitCount + 1
		end
	end
	-- gray #707070
	if SuitEffect_2_AttributeID ~= nilValue then
		local SuitEffect_2_AttributeName = sdata_attribute_data.mData.body[SuitEffect_2_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local SuitEffect_2_AttributePoint = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['Effect2Point']]
		local Symbol = sdata_attribute_data.mData.body[SuitEffect_2_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
		if SuitCount >= 2 then 
			str = str..
				sdata_UILiteral.mData.body[0xFE13][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_2_AttributeName.."+"..
				SuitEffect_2_AttributePoint..Symbol.."\n"
		else
			str = str.."[707070]"..
				sdata_UILiteral.mData.body[0xFE13][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_2_AttributeName.."+"..
				SuitEffect_2_AttributePoint..Symbol.."[-]".."\n"
		end
	end
	if SuitEffect_3_AttributeID ~= nilValue then
		local SuitEffect_3_AttributeName = sdata_attribute_data.mData.body[SuitEffect_3_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local SuitEffect_3_AttributePoint = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['Effect3Point']]
		local Symbol = sdata_attribute_data.mData.body[SuitEffect_3_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
		if SuitCount >= 3 then 
			str = str..
				sdata_UILiteral.mData.body[0xFE14][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_3_AttributeName.."+"..
				SuitEffect_3_AttributePoint..Symbol.."\n"
		else
			str = str.."[707070]"..
				sdata_UILiteral.mData.body[0xFE14][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_3_AttributeName.."+"..
				SuitEffect_3_AttributePoint..Symbol.."[-]".."\n"
		end
	end
	if SuitEffect_5_AttributeID ~= nilValue then
		local SuitEffect_5_AttributeName = sdata_attribute_data.mData.body[SuitEffect_5_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local SuitEffect_5_AttributePoint = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['Effect5Point']]
		local Symbol = sdata_attribute_data.mData.body[SuitEffect_5_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
		if SuitCount >= 5 then 
			str = str..
				sdata_UILiteral.mData.body[0xFE15][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_5_AttributeName.."+"..
				SuitEffect_5_AttributePoint..Symbol.."\n"
		else
			str = str.."[707070]"..
				sdata_UILiteral.mData.body[0xFE15][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_5_AttributeName.."+"..
				SuitEffect_5_AttributePoint..Symbol.."[-]".."\n"
		end
	end

	return str
end
--@params equip:装备Data
--@return 强化到下一等级提升数值
function wnd_cangku_model:getEquipmentLevelUpOffsetStr(equip)
	local _PlanID = equip["MainAttribute"]
	local _AttributeID = equip.fst_attr
	local _UniqueID = tostring(_PlanID)..tostring(_AttributeID)
	local _GrowthValue = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['up']]
	local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
	local str = nil
	if equip.lv + 1 <= this:getEquipmentPlusMAXLevel(equip.rarity) then
		str = "+".._GrowthValue..Symbol
		return str
	else
		str = "+0"
		return str
	end
end

--@params id:装备唯一id
--@return 装备eid
function wnd_cangku_model:getEquipmentIDByID(id)
	for i = 1,#this.Processed_Items do
		if this.Processed_Items[i].id == id then
			return this.Processed_Items[i]["EquipID"]
		end
	end
	Debugger.LogWarning(id.." not found in wnd_cangku_model:getEquipmentIDByID(id)")
	return nil
end
--@params id:装备唯一id
--@return 装备SuitID
function wnd_cangku_model:getEquipmentSuitIDByID(id)
	for i = 1,#this.serv_Equipment do
		if this.serv_Equipment[i].id == id then
			return this.serv_Equipment[i]["SuitID"]
		end
	end
	Debugger.LogWarning(id.." not found in wnd_cangku_model:getEquipmentSuitIDByID(id)")
	return nil
end

--@params Quality:装备品质
--@return 装备最高强化等级
function wnd_cangku_model:getEquipmentPlusMAXLevel(Quality)
	require('uiscripts/cangku/const/wnd_cangku_Const')
	if Quality == 1 then
		return cint.QUALITY_1_MAXLEVEL
	elseif Quality == 2 then
		return cint.QUALITY_2_MAXLEVEL
	elseif Quality == 3 then
		return cint.QUALITY_3_MAXLEVEL
	elseif Quality == 4 then
		return cint.QUALITY_4_MAXLEVEL
	elseif Quality == 5 then
		return cint.QUALITY_5_MAXLEVEL	
	else
		return cint.QUALITY_6_MAXLEVEL end
end
--@params currentLV:装备当前等级,Quality:装备品质
--@return 强化到下一等级所需要的能量点
function wnd_cangku_model:getEquipmentPlusCost(currentLV,Quality)

	if currentLV + 1 <= this:getEquipmentPlusMAXLevel(Quality) then
		local cost = sdata_equippower_data.mData.body[currentLV + 1][sdata_equippower_data.mFieldName2Index['Quality'..Quality]]
		if this.serv_CurrencyInfo.power < cost then
			local str = "[FF6600]"..cost.."[-]"
			return str
		else
			return cost
		end
	else
		return "[707070]no pls[-]"
	end
end
--@params currentLV:装备当前等级,Quality:装备品质
--@return 分解后获得的能量
function wnd_cangku_model:getEquipmentDecomposeReturn(currentLV,Quality)
	return sdata_equippower_data.mData.body[currentLV][sdata_equippower_data.mFieldName2Index['Quality'..Quality]]
end
--@params id:装备唯一id
function wnd_cangku_model:getIndexByID(id)
	for k,v in ipairs(this.serv_Equipment) do
		if v.id == id then
			return k
		end
	end
	Debugger.LogWarning(id.." not found in wnd_cangku_model:getIndexByID(id)")
	return nil
end
return wnd_cangku_model