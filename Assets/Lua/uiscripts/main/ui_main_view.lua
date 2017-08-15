ui_main_view = {}

local m = ui_main_view

function ui_main_view:initView(root)
	self = root

	m.btn_battle = self.transform:Find("btn_battle").gameObject

	m.Widget_AdditionalSystem = self.transform:Find("Widget_AdditionalSystem").gameObject
	m.Widget_AdditionalSystem_Item = self.transform:Find("Widget_AdditionalSystem/pSprite").gameObject

	m.AvoidWarTimerIcon = self.transform:Find("btn_battle/timer_icon").gameObject
	m.AvoidWarTimer = self.transform:Find("btn_battle/timer").gameObject:GetComponent(typeof(UILabel))
end

function ui_main_view:initCollider()
	local colliders = {}

	table.insert(colliders,m.btn_battle)
	table.insert(colliders,m.Widget_AdditionalSystem)

	local collider = nil
	for index,button in pairs(colliders) do
		collider = button:AddComponent(typeof(UnityEngine.BoxCollider))
		collider.isTrigger = true
		collider.center = Vector3.zero
		collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0) 
	end
end

return ui_main_view