wnd_shop_model = {

	local_Tabs = {},-- 本地页卡表

	local_ShopRefreshTime = {},-- 本地刷新时间表

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
end

function wnd_shop_model:initLocalTabsData()
	if sdata_shop_data == nil then
		Debugger.LogWarning("没获取到以下数据：sdata_shop_data")
		return
	end

	local Tab = {}

	for k,v in pairs(sdata_shop_data.mData.body) do
		Tab["ShopID"] = v[sdata_shop_data.mFieldName2Index['ShopID']]
		Tab["ShopType"] = v[sdata_shop_data.mFieldName2Index['ShopType']]
		Tab["Label"] = v[sdata_shop_data.mFieldName2Index['Label']]
		Tab["Icon"] = v[sdata_shop_data.mFieldName2Index['Icon']]
		table.insert(this.local_Tabs,Tab)
		Tab = {}
	end

	table.sort(this.local_Tabs,function(a,b)
		return a["ShopID"] < b["ShopID"]
	end)

	print("read "..#this.local_Tabs.." Tabs(Local).")
end

function wnd_shop_model:initLocalShopRefreshTimeData()
	if sdata_shoprefresh_data == nil then
		Debugger.LogWarning("没获取到以下数据：sdata_shop_data")
		return
	end

	local Time = {}

	for k,v in pairs(sdata_shoprefresh_data.mData.body) do
		Time["ID"] = v[sdata_shoprefresh_data.mFieldName2Index['ID']]
		Time["Time"] = v[sdata_shoprefresh_data.mFieldName2Index['Time']]
		table.insert(this.local_ShopRefreshTime,Time)
		Time = {}
	end
	
	table.sort(this.local_ShopRefreshTime,function(a,b)
		return a["ID"] < b["ID"]
	end)

	print("read "..#this.local_ShopRefreshTime.." ShopRefreshTimes(Local).")
end

return wnd_shop_model