--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--header
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
wnd_cangku_model = {

	-- 道具数据
	Depository_itemsTotal = 0,
	Item_Attributes = { 
		_ItemID,
		_UseType,
		_RelationID,
		_Name,
		_Des,
		_FunctionDes,
		_Icon,
		_AvatarMode,
		_Quality,
		_OverlapUse,
		_OverlapLimit,
		_SaleGold,
		_ComposeNum,
		_SelfUse,
	},
	

	-- 仓库标签数据
	DepositoryTab_Count = 0,
	DepositoryTab_Attributes = {
		_LabelID,
		_Label,
		_TextID,
		_Goods,
		_Maintype,
	},

	-- 手选宝箱数据
	SelectChest_Attributes = {
		_UniqueID,
		_SelectChestID,
		_Type,
		_ID,
		_Quality,
		_Num,
	},

	-- AvatarData
	AvatarData_Attributes = {
		_UniqueID,
		_AvatarID,
		_AvatarLevel,
		_CostNum,
		_Gold,
		_AttributeID,
		_Point,
	},
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
	local_Equipment = {},-- 本地Equipment表

	serv_Items = {},-- 从服务器获取的Items数据(id,num)
	serv_Equipment = {},-- 从服务器获取的Equipment数据

	decomposition_Equipment = {},-- 装备分解状态时使用的临时表
	Processed_Items = {},-- 处理后的仓库数据(全部,装备在前,道具在后)，用于显示在ScrollView上

	-- function
	initModel,
	initLocalTabsData,-- 读本地表页卡数据
	initLocalItemsData,-- 读本地Item表数据
	initLocalEquipData,-- 读本地装备表数据
	
	getLocalItemDetailByItemID,-- 在本地Item表查询对应ItemID的数据
	getLocalEquipmentDetailByEquipID,-- 在本地装备表查询对应EquipID的数据
}

local this = wnd_cangku_model

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_cangku_model:initModel()
	this:initLocalTabsData()
	this:initLocalItemsData()
	this:initLocalEquipData()
end

function wnd_cangku_model:initLocalTabsData()
	if sdata_tab_data == nil then
		print("没获取到以下数据：sdata_tab_data")
		return
	end

	local Tab = {}

	this.DepositoryTab_Count = #sdata_tab_data.mData.body

	for k,v in pairs(sdata_tab_data.mData.body) do
		Tab["LabelID"] = v[sdata_tab_data.mFieldName2Index['LabelID']]
		Tab["TextID"] = v[sdata_tab_data.mFieldName2Index['TextID']]
		Tab["Goods"] = v[sdata_tab_data.mFieldName2Index['Goods']]
		Tab["Maintype"] = v[sdata_tab_data.mFieldName2Index['Maintype']]
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

	if sdata_cangku_data == nil then
		print("没获取到以下数据：sdata_cangku_data")
		return
	end	

	local Item = {}

	this.Depository_itemsTotal = #sdata_cangku_data.mData.body
	-- mFieldName2Index
	-- mData
	for k,v in pairs(sdata_cangku_data.mData.body) do

		Item["ItemID"] = v[sdata_cangku_data.mFieldName2Index['ItemID']]
		Item["UseType"] = v[sdata_cangku_data.mFieldName2Index['UseType']]
		Item["RelationID"] = v[sdata_cangku_data.mFieldName2Index['RelationID']]
		Item["Name"] = v[sdata_cangku_data.mFieldName2Index['Name']]
		Item["Des"] = v[sdata_cangku_data.mFieldName2Index['Des']]
		Item["FunctionDes"] = v[sdata_cangku_data.mFieldName2Index['FunctionDes']]
		Item["Icon"] =  v[sdata_cangku_data.mFieldName2Index['Icon']]
		Item["AvatarMode"] = v[sdata_cangku_data.mFieldName2Index['AvatarMode']]
		Item["Quality"] = v[sdata_cangku_data.mFieldName2Index['Quality']]
		Item["OverlapUse"] = v[sdata_cangku_data.mFieldName2Index['OverlapUse']]
		Item["OverlapLimit"] = v[sdata_cangku_data.mFieldName2Index['OverlapLimit']]
		Item["SaleGold"] = v[sdata_cangku_data.mFieldName2Index['SaleGold']]
		Item["ComposeNum"] = v[sdata_cangku_data.mFieldName2Index['ComposeNum']]
		Item["SelfUse"] = v[sdata_cangku_data.mFieldName2Index['SelfUse']]

		table.insert(this.local_Items,Item)

		Item = {}
	end

	table.sort(this.local_Items,function(a,b)
		return a["ItemID"] < b["ItemID"]
	end)

	print("read "..#this.local_Items.." Items(Local).")

	-- this.local_Items = Items
end

function wnd_cangku_model:initLocalEquipData()
	if sdata_equip_data == nil then
		print("没获取到以下数据：sdata_equip_data")
		return
	end	

	local Equipment = {}

	for k,v in pairs(sdata_equip_data.mData.body) do

		Equipment["EquipID"] = v[sdata_equip_data.mFieldName2Index['EquipID']]
		Equipment["EquipName"] = v[sdata_equip_data.mFieldName2Index['EquipName']]
		Equipment["EquipIcon"] = v[sdata_equip_data.mFieldName2Index['EquipIcon']]
		Equipment["EquipType"] = v[sdata_equip_data.mFieldName2Index['EquipType']]
		Equipment["SuitID"] = v[sdata_equip_data.mFieldName2Index['SuitID']]
		Equipment["MainAttribute"] = v[sdata_equip_data.mFieldName2Index['MainAttribute']]
	
		table.insert(this.local_Equipment,Equipment)

		Equipment = {}
	end

	table.sort(this.local_Equipment,function(a,b)
		return a["EquipID"] < b["EquipID"]
	end)

	print("read "..#this.local_Equipment.." Equipments(Local).")

	-- this.local_Equipment = Equipments

end

function wnd_cangku_model:initDepositoryItemsDataFromServer()
	local Items = {}
	local Equipment = {}
	-- TODO 从服务器获取数据
	local serv_Items
	local serv_Equipment

	-- TODO 模拟服务器数据
	local item
	for k,v in pairs(serv_Items) do
		item = {
			id = v.id,
			num = v.num,
		}
		table.insert(Items,item)
		item = {}
	end

	local equip
	for k,v in pairs(serv_Equipment) do
		equip = {
			id = serv_Equipment.id,
			eid = serv_Equipment.eid,
			lv = serv_Equipment.lv,
			rarity = serv_Equipment.rarity,
			fst_attr = serv_Equipment.fst_attr,
			snd_attr = {
				id = serv_Equipment.snd_attr.id,
				val = serv_Equipment.snd_attr.val,
				isRemake = serv_Equipment.snd_attr.isRemake,
				remake = {
					id = serv_Equipment.snd_attr.remake.id,
					val = serv_Equipment.snd_attr.remake.val,
				},
			},
			isBad = serv_Equipment.isBad,
		}
		table.insert(Equipment,equip)
		equip = {}
	end

	this.serv_Items = Items
	this.serv_Equipment = Equipment
end

function wnd_cangku_model:getLocalItemDetailByItemID(itemID)
	for i = 1,#this.local_Items do
		if this.local_Items[i]["ItemID"] == itemID then
			return this.local_Items[i]
		end
	end
	Debugger.LogWarning(itemID.." not found in wnd_cangku_model:getLocalItemDetailByItemID(itemID)")
	return nil	
end

function wnd_cangku_model:getLocalEquipmentDetailByEquipID(equipmentID)
	for i = 1,#this.local_Equipment do
		if this.local_Equipment[i]["EquipID"] == equipmentID then
			return this.local_Equipment[i]
		end
	end
	Debugger.LogWarning(equipmentID.." not found in wnd_cangku_model:getLocalEquipmentDetailByEquipID(equipmentID)")
	return nil
end


return wnd_cangku_model