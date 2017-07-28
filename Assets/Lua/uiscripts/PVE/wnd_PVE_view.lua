wnd_pve_view = {}
--[[
	wnd_pve_view:
		Button_back
		Button_avoidWar
		Panel_Secondary
]]
local m = wnd_pve_view

function wnd_pve_view:initView(root)
	self = root

	m.Button_back = self.transform:Find("Button_back").gameObject
	m.Button_avoidWar = self.transform:Find("Button_avoidWar").gameObject

	m.Panel_Secondary = self.transform:Find("Panel_Secondary").gameObject
	-- 确认免战 View
	m.Layout_buyAvoidWar = {
		btn_close = self.transform:Find("Panel_Secondary/buyAvoidWar_Layout/btn_close").gameObject,
		btn_ok = self.transform:Find("Panel_Secondary/buyAvoidWar_Layout/btn_ok").gameObject,
		btn_cancel = self.transform:Find("Panel_Secondary/buyAvoidWar_Layout/btn_cancel").gameObject,
		confirmInfo = self.transform:Find("Panel_Secondary/buyAvoidWar_Layout/Label").gameObject,
		panel = self.transform:Find("Panel_Secondary/buyAvoidWar_Layout").gameObject,
	}
	-- 选择免战卡 View
	m.Layout_selectAvoidWar = {
		btn_close = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/btn_close").gameObject,
		btn_info = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/btn_info").gameObject,
		panel_info = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/Info").gameObject,
		AW_card_1 = {
			item = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_1").gameObject,
			lcard = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_1/lcard").gameObject:GetComponent(typeof(UILabel)),
			lvalue = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_1/lvalue").gameObject:GetComponent(typeof(UILabel)),
		},
		AW_card_2 = {
			item = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_2").gameObject,
			lcard = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_2/lcard").gameObject:GetComponent(typeof(UILabel)),
			lvalue = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_2/lvalue").gameObject:GetComponent(typeof(UILabel)),
		},
		AW_card_3 = {
			item = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_3").gameObject,
			lcard = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_3/lcard").gameObject:GetComponent(typeof(UILabel)),
			lvalue = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout/AW_card_3/lvalue").gameObject:GetComponent(typeof(UILabel)),
		},
		panel = self.transform:Find("Panel_Secondary/selectAvoidWar_Layout").gameObject,
	}

end

function wnd_pve_view:initCollider()
	local colliders = {}

	table.insert(colliders,m.Button_back)
	table.insert(colliders,m.Button_avoidWar)

	table.insert(colliders,m.Layout_buyAvoidWar.btn_close)
	table.insert(colliders,m.Layout_buyAvoidWar.btn_ok)
	table.insert(colliders,m.Layout_buyAvoidWar.btn_cancel)

	table.insert(colliders,m.Layout_selectAvoidWar.btn_close)
	table.insert(colliders,m.Layout_selectAvoidWar.btn_info)
	table.insert(colliders,m.Layout_selectAvoidWar.AW_card_1.item)
	table.insert(colliders,m.Layout_selectAvoidWar.AW_card_2.item)
	table.insert(colliders,m.Layout_selectAvoidWar.AW_card_3.item)



	local collider = nil
	for index,button in pairs(colliders) do
		collider = button:AddComponent(typeof(UnityEngine.BoxCollider))
		collider.isTrigger = true
		collider.center = Vector3.zero
		collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0) 
	end
end

return wnd_pve_view