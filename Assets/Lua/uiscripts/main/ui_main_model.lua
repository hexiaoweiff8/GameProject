ui_main_model = {
	--[[免战卡时间戳,python time.time()+cardTime(s)]]
	AvoidWarCardTimestamp,
	local_AddtionalSystemBarData = {},
}

local this = ui_main_model
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_main_model:initModel()
	if not this.AvoidWarCardTimestamp then
		this.AvoidWarCardTimestamp = os.time()
	end
	this:initLocalInterfaceData()
end

function ui_main_model:initLocalInterfaceData()
	for k,v in pairs(sdata_maininterface_data.mData.body) do
		if v[sdata_maininterface_data.mFieldName2Index['Type']] == 2 then
			local Item = {}
			Item["ID"] = v[sdata_maininterface_data.mFieldName2Index['ID']]
			Item["Name"] = v[sdata_maininterface_data.mFieldName2Index['Name']]
			Item["Type"] = v[sdata_maininterface_data.mFieldName2Index['Type']]
			Item["UnlockLevel"] = v[sdata_maininterface_data.mFieldName2Index['UnlockLevel']]
			Item["UnlockEvent"] = v[sdata_maininterface_data.mFieldName2Index['UnlockEvent']]
			Item["Prompt"] = v[sdata_maininterface_data.mFieldName2Index['Prompt']]
			Item["Icon"] = v[sdata_maininterface_data.mFieldName2Index['Icon']]
			Item["UIDefine"] = v[sdata_maininterface_data.mFieldName2Index['UIDefine']]
			Item["RedDotRefreshAPI"] = v[sdata_maininterface_data.mFieldName2Index['RedDotRefreshAPI']]
			table.insert(this.local_AddtionalSystemBarData,Item)
		end
	end
	table.sort(this.local_AddtionalSystemBarData,function(a,b)
		return a["ID"] < b["ID"]
	end)
end

function ui_main_model:getIDByUIDefine(_uiDefine)
	for _,v in ipairs(this.local_AddtionalSystemBarData) do
		if v["UIDefine"] == _uiDefine then
			return v["ID"]
		end
	end
end

function ui_main_model:getRefreshAPIStrByUIDefine(_uiDefine)
	for _,v in ipairs(this.local_AddtionalSystemBarData) do
		if v["UIDefine"] == _uiDefine then
			return v["RedDotRefreshAPI"]
		end
	end
end

function ui_main_model:showShop()
	-- ui_manager:ShowWB(WNDTYPE.Prefight)
end
--@Des 测试表内刷新红点API
--@Return int32 _num 红点/计数器数量
--		  类型1：_num > 0 显示红点，反之则不显示
--		  类型2：_num > 0 显示红点数量，反之则不显示
function ui_main_model:testReadRedDot()
	printe("loadstring方式调用ui_main_model.testReadRedDot()")
	return 10
end

function ui_main_model.testReadRedDotNoRequire()
	printe("loadstring方式调用ui_main_model.testReadRedDotNoRequire()")
	return 0
end

return ui_main_model