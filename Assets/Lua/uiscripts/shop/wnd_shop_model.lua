wnd_shop_model = {

	local_Tabs = {},-- 本地页卡表

	local_ShopRefreshTime = {},-- 本地刷新时间表

	local_ShopCurrency = {},-- 本地商店货币表

	local_ShopCommodity = {},-- 本地商店商品表
	--[[
		serv_ShopCacheData{
			[shopID] = {UpdateTime = string,
						{good.id,good.isSold,good.slot}...}
		}
	]]
	serv_ShopCacheData = {},-- 服务器商店物品缓存

	--function
	initLocalTabsData,-- 读本地表页卡数据
}

local this = wnd_shop_model
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_shop_model:initModel()
	wnd_shop_model:initLocalTabsData()
	wnd_shop_model:initLocalShopRefreshTimeData()
	wnd_shop_model:initLocalShopCurrencyData()
	wnd_shop_model:initLocalShopCommodityData()
end

function wnd_shop_model:initLocalTabsData()
	if sdata_shop_data == nil then
		Debugger.LogWarning("没获取到以下数据：sdata_shop_data")
		return
	end

	for k,v in pairs(sdata_shop_data.mData.body) do
		local Tab = {}
		Tab["ShopID"] = v[sdata_shop_data.mFieldName2Index['ShopID']]
		Tab["ShopType"] = v[sdata_shop_data.mFieldName2Index['ShopType']]
		Tab["Label"] = v[sdata_shop_data.mFieldName2Index['Label']]
		Tab["Icon"] = v[sdata_shop_data.mFieldName2Index['Icon']]
		table.insert(this.local_Tabs,Tab)
	end

	table.sort(this.local_Tabs,function(a,b)
		return a["ShopID"] < b["ShopID"]
	end)

	print("read "..#this.local_Tabs.." Tabs(Local).")
end

function wnd_shop_model:initLocalShopRefreshTimeData()
	if sdata_shoprefresh_data == nil then
		Debugger.LogWarning("sdata_shoprefresh_data")
		return
	end

	for k,v in pairs(sdata_shoprefresh_data.mData.body) do
		local Time = {}
		Time["ID"] = v[sdata_shoprefresh_data.mFieldName2Index['ID']]
		Time["Time"] = v[sdata_shoprefresh_data.mFieldName2Index['Time']]
		table.insert(this.local_ShopRefreshTime,Time)
	end

	table.sort(this.local_ShopRefreshTime,function(a,b)
		return a["ID"] < b["ID"]
	end)

	print("read "..#this.local_ShopRefreshTime.." ShopRefreshTimes(Local).")
end

function wnd_shop_model:initLocalShopCurrencyData()
	if sdata_shopcurrency_data == nil then
		Debugger.LogWarning("sdata_shopcurrency_data")
		return
	end

	for k,v in pairs(sdata_shopcurrency_data.mData.body) do
		local Currency = {}
		Currency["ID"] = v[sdata_shopcurrency_data.mFieldName2Index['ID']]
		Currency["Field"] = v[sdata_shopcurrency_data.mFieldName2Index['Field']]
		Currency["Name"] = v[sdata_shopcurrency_data.mFieldName2Index['Name']]
		Currency["Icon"] = v[sdata_shopcurrency_data.mFieldName2Index['Icon']]
		Currency["FunctionDes"] = v[sdata_shopcurrency_data.mFieldName2Index['FunctionDes']]
		table.insert(this.local_ShopCurrency,Currency)
	end
	
	table.sort(this.local_ShopCurrency,function(a,b)
		return a["ID"] < b["ID"]
	end)

	print("read "..#this.local_ShopCurrency.." ShopCurrency(Local).")
end

function wnd_shop_model:initLocalShopCommodityData()
	if sdata_shopcommodity_data == nil then
		Debugger.LogWarning("sdata_shopcommodity_data")
		return
	end

	for k,v in pairs(sdata_shopcommodity_data.mData.body) do
		local Goods = {}
		Goods["CommID"] = v[sdata_shopcommodity_data.mFieldName2Index['CommID']]
		Goods["DropType"] = v[sdata_shopcommodity_data.mFieldName2Index['DropType']]
		Goods["DropID"] = v[sdata_shopcommodity_data.mFieldName2Index['DropID']]
		Goods["DropNum"] = v[sdata_shopcommodity_data.mFieldName2Index['DropNum']]
		Goods["Quality"] = v[sdata_shopcommodity_data.mFieldName2Index['Quality']]
		Goods["MoneyType"] = v[sdata_shopcommodity_data.mFieldName2Index['MoneyType']]
		Goods["Value"] = v[sdata_shopcommodity_data.mFieldName2Index['Value']]
		table.insert(this.local_ShopCommodity,Goods)
	end
	
	table.sort(this.local_ShopCommodity,function(a,b)
		return a["CommID"] < b["CommID"]
	end)

	print("read "..#this.local_ShopCommodity.." ShopCommodity(Local).")
end
----------------------------------------------------------------
--★GetData
function wnd_shop_model:getShopCommodityDataRefByGoodItemID(id)
	for i = 1,#this.local_ShopCommodity do
		if this.local_ShopCommodity[i]["CommID"] == id then
			return this.local_ShopCommodity[i]
		end
	end
	Debugger.LogWarning(id.." not found in wnd_shop_model:getShopCommodityDataByGoodItemID(id)")
	return nil
end

function wnd_shop_model:getShopCurrencyDataRefByField(field)
	for i = 1,#this.local_ShopCurrency do
		if this.local_ShopCurrency[i]["Field"] == field then
			return this.local_ShopCurrency[i]
		end
	end
	Debugger.LogWarning(field.." not found in wnd_shop_model:getShopCurrencyDataRefByField(field)")
	return nil
end

function wnd_shop_model:getShopCurrencyIconByField(field)
	for i = 1,#this.local_ShopCurrency do
		if this.local_ShopCurrency[i]["Field"] == field then
			return this.local_ShopCurrency[i]["Icon"]
		end
	end
	Debugger.LogWarning(field.." not found in wnd_shop_model:getShopCurrencyIconByField(field)")
	return nil
end

function wnd_shop_model:getShopCommodityQualityByDropID(DropID)
	for i = 1,#this.local_ShopCommodity do
		if this.local_ShopCommodity[i]["DropID"] == DropID then
			return this.local_ShopCommodity[i]["Quality"]
		end
	end
	Debugger.LogWarning(field.." not found in wnd_shop_model:getShopCommodityQualityByDropID(DropID)")
	return nil
end

function wnd_shop_model:getShopTypeByShopID(ShopID)
	for i = 1,#this.local_Tabs do
		if this.local_Tabs[i]["ShopID"] == ShopID then
			return this.local_Tabs[i]["ShopType"]
		end
	end
	Debugger.LogWarning(field.." not found in wnd_shop_model:getShopTypeByShopID(ShopID)")
	return nil
end
--@Des 根据商店id,槽位索引,獲取CommID
--@Params ShopID:商店ID
--		  SlotIndex:槽位索引
--@Return CommID:商品ID
function wnd_shop_model:getCommIDBySlotIndex(ShopID,SlotIndex)
	for i = 1,#this.serv_ShopCacheData[ShopID] do
		if this.serv_ShopCacheData[ShopID][i].slot == SlotIndex then
			return this.serv_ShopCacheData[ShopID][i].id
		end
	end
	Debugger.LogWarning("商店本地緩存未就緒,或該槽位沒找到"..SlotIndex)
	return nil
end
--@Des 根据商店id,槽位索引,获取该商品是否售出
function wnd_shop_model:whether_The_Goods_have_been_sold(ShopID,SlotIndex)
	for i = 1,#this.serv_ShopCacheData[ShopID] do
		if this.serv_ShopCacheData[ShopID][i].slot == SlotIndex then
			return (this.serv_ShopCacheData[ShopID][i].isSold == 0 and {false} or {true})[1]
		end
	end
	Debugger.LogWarning("商店本地緩存未就緒,或該槽位沒找到"..SlotIndex)
	return nil
end
--@Des 根据CommID/goodsID获取DropType
--@Params CommID:商品ID
--@Return DropType:商品类型
function wnd_shop_model:getDropTypeByCommID(CommID)
	for i = 1,#this.local_ShopCommodity do
		if this.local_ShopCommodity[i]["CommID"] == CommID then
			return this.local_ShopCommodity[i]["DropType"]
		end
	end
	Debugger.LogWarning(CommID.." not found in wnd_shop_model:getDropTypeByCommID(CommID)")
	return nil
end
--@Des 获取品质框/品质底图spriteName字符串
--@Return string,string
function wnd_shop_model:getQualitySpriteStr(Quality)
	require('uiscripts/cangku/const/wnd_cangku_Const')
	if Quality == 1 then
		return cstr.QUALITY_WHITE,cstr.QUALITY_WHITE_LAYER
	elseif Quality == 2 then
		return cstr.QUALITY_GREEN,cstr.QUALITY_GREEN_LAYER
	elseif Quality == 3 then
		return cstr.QUALITY_BLUE,cstr.QUALITY_BLUE_LAYER
	elseif Quality == 4 then
		return cstr.QUALITY_PURPLE,cstr.QUALITY_PURPLE_LAYER
	elseif Quality == 5 then
		return cstr.QUALITY_ORANGE,cstr.QUALITY_ORANGE_LAYER
	else return cstr.QUALITY_RED,cstr.QUALITY_RED_LAYER end
end

wnd_shop_model.cstr = {
	GOLD = "tongyong_tubiao_jinbi",
	DIAMOND = "tongyong_tubiao_zuanshi",
	PKPT = "tongyong_tubiao_tili",
}

return wnd_shop_model