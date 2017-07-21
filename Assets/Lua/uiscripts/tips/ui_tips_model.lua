ui_tips_model = {

	local_AttributePlan = {}, -- 本地装备属性成长值表

}
local this = ui_tips_model
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_tips_model:initModel()
	ui_tips_model:initLocalAttributePlanData()
end

function ui_tips_model:initLocalAttributePlanData()
	if sdata_attributeplan_data == nil then
		Debugger.LogWarning("没获取到以下数据：sdata_attributeplan_data")
		return
	end

	for k,v in pairs(sdata_attributeplan_data.mData.body) do
		local Plan = {}
		Plan["UniqueID"] = v[sdata_attributeplan_data.mFieldName2Index['UniqueID']]
		Plan["PlanID"] = v[sdata_attributeplan_data.mFieldName2Index['PlanID']]
		Plan["AttributeID"] = v[sdata_attributeplan_data.mFieldName2Index['AttributeID']]
		Plan["Value"] = v[sdata_attributeplan_data.mFieldName2Index['Value']]
		Plan["Min"] = v[sdata_attributeplan_data.mFieldName2Index['Min']]
		Plan["up"] = v[sdata_attributeplan_data.mFieldName2Index['up']]
		Plan["Max"] = v[sdata_attributeplan_data.mFieldName2Index['Max']]
		table.insert(this.local_AttributePlan,Plan)
	end

	table.sort(this.local_AttributePlan,function(a,b)
		return a["UniqueID"] < b["UniqueID"]
	end)

	print("read "..#this.local_AttributePlan.." Plans(Local).")
end

--@Des 根据PlanID获取多个相关属性ID数组
--@params PlanID(I32$MainAttribute)
function ui_tips_model:getEquipmentAttributeIDArrayByPlanID(PlanID)
	local AttributeIDArray = {}
	for i = 1,#this.local_AttributePlan do
		if this.local_AttributePlan[i]["PlanID"] == PlanID then
			table.insert(AttributeIDArray,this.local_AttributePlan[i]["AttributeID"])
		end
	end
	return AttributeIDArray
end 

return ui_tips_model