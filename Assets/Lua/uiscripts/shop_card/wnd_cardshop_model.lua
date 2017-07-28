wnd_cardshop_model = {

	local_Tabs = {},-- 本地页卡表

	local_CardBase = {},
	--[[
		ShoppingList {
			[shopType] = {[1] = cardbaseRef,[2] = cardbaseRef,[n] = cardbaseRef},
			[shopType] = {...},
			[...] = {...},
		}
	]]
	local_ShoppingList = {},

}

local this = wnd_cardshop_model
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_cardshop_model:initModel()
	wnd_cardshop_model:initLocalTabsData()
	wnd_cardshop_model:initLocalCardBaseData()
	wnd_cardshop_model:initShopingListByShopType()
end

function wnd_cardshop_model:initLocalTabsData()
	if sdata_cardshop_data == nil then
		Debugger.LogWarning("没导入lua数据：sdata_cardshop_data")
		return
	end

	for k,v in pairs(sdata_cardshop_data.mData.body) do
		local Tab = {}
		Tab["ShopID"] = v[sdata_cardshop_data.mFieldName2Index['ShopID']]
		Tab["ShopType"] = v[sdata_cardshop_data.mFieldName2Index['ShopType']]
		Tab["Label"] = v[sdata_cardshop_data.mFieldName2Index['Label']]
		Tab["Icon"] = v[sdata_cardshop_data.mFieldName2Index['Icon']]
		table.insert(this.local_Tabs,Tab)
	end

	table.sort(this.local_Tabs,function(a,b)
		return a["ShopID"] < b["ShopID"]
	end)

	print("read "..#this.local_Tabs.." cardShopTabs(Local).")
end

function wnd_cardshop_model:initLocalCardBaseData()
	if sdata_armycardbase_data == nil then
		Debugger.LogWarning("没导入lua数据：sdata_armycardbase_data")
		return
	end

	for k,v in pairs(sdata_armycardbase_data.mData.body) do
		local Card = {}
		Card["ArmyCardID"] = v[sdata_armycardbase_data.mFieldName2Index['ArmyCardID']]
		Card["Name"] = v[sdata_armycardbase_data.mFieldName2Index['Name']]
		Card["Des"] = v[sdata_armycardbase_data.mFieldName2Index['Des']]
		Card["Rarity"] = v[sdata_armycardbase_data.mFieldName2Index['Rarity']]
		Card["TrainCost"] = v[sdata_armycardbase_data.mFieldName2Index['TrainCost']]
		Card["IconID"] = v[sdata_armycardbase_data.mFieldName2Index['IconID']]
		Card["ModelID"] = v[sdata_armycardbase_data.mFieldName2Index['ModelID']]
		Card["ArrayID"] = v[sdata_armycardbase_data.mFieldName2Index['ArrayID']]
		Card["AreaLimit"] = v[sdata_armycardbase_data.mFieldName2Index['AreaLimit']]
		Card["ArmyID"] = v[sdata_armycardbase_data.mFieldName2Index['ArmyID']]
		Card["ArmyUnit"] = v[sdata_armycardbase_data.mFieldName2Index['ArmyUnit']]
		Card["IsExchange"] = v[sdata_armycardbase_data.mFieldName2Index['IsExchange']]
		Card["ShopType"] = v[sdata_armycardbase_data.mFieldName2Index['ShopType']]
		Card["Type"] = v[sdata_armycardbase_data.mFieldName2Index['Type']]
		Card["BasePrice"] = v[sdata_armycardbase_data.mFieldName2Index['BasePrice']]
		Card["UpPrice"] = v[sdata_armycardbase_data.mFieldName2Index['UpPrice']]

		table.insert(this.local_CardBase,Card)
	end

	table.sort(this.local_CardBase,function(a,b)
		return a["ArmyCardID"] < b["ArmyCardID"]
	end)

	print("read "..#this.local_CardBase.." cardBase(Local).")
end

function wnd_cardshop_model:initShopingListByShopType()
	require('uiscripts/shop_card/util/table_containKey')
	-- 向local_ShoppingList中添加键
	for _,v in ipairs(this.local_Tabs) do
		this.local_ShoppingList[v['ShopType']] = {}
	end
	-- 将对应类型的卡牌添加到商品列表中
	for _,v in ipairs(this.local_CardBase) do
		if table.containKey(this.local_ShoppingList,v['ShopType']) then
			table.insert(this.local_ShoppingList[v['ShopType']],v)
		end
	end
	-- 商品列表排序
	for _,v in ipairs(this.local_ShoppingList) do
		table.sort(v,function(a,b)
			return a['ArmyCardID'] < b['ArmyCardID']
		end)
	end
end

wnd_cardshop_model.cstr = {
	SELECTED_YEKA = "",
}

return wnd_cardshop_model