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
			Item["Icon"] = v[sdata_maininterface_data.mFieldName2Index['Icon']]
			table.insert(this.local_AddtionalSystemBarData,Item)
		end
	end
	table.sort(this.local_AddtionalSystemBarData,function(a,b)
		return a["ID"] < b["ID"]
	end)
end

return ui_main_model