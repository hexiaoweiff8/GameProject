wnd_shop_view = {
	Button_back,

	Panel_Tab={
		TabButtons = {},
		sTabTop,
	},
	Currency = {
		lGold,
		lDiamond,
		bDiamond,
		lRefreshPoint,
	},
	Refresh = {
		lAutoRefresh,
		lManualRefresh,
	},
	TimerDebugTools = {
		targetTime,
		remainTime,
	},

	pButton_yeka,
	pShopItem,
}
local m = wnd_shop_view

function wnd_shop_view:initView(root)
	self = root

	model = self.model

	m.Button_back = self.transform:Find("Button_back").gameObject

	m.Panel_Tab.sTabTop = self.transform:Find("Panel_Tab/Widget_Tab/sTabTop").gameObject

	m.Currency = {
		sGold = self.transform:Find("Widget_Currency/sGold").gameObject:GetComponent(typeof(UISprite)),
		sGoldContainer = self.transform:Find("Widget_Currency/sGoldContainer").gameObject,
		lGold = self.transform:Find("Widget_Currency/sGoldContainer/lGold").gameObject:GetComponent(typeof(UILabel)),
		lDiamond = self.transform:Find("Widget_Currency/sDiamondContainer/lDiamond").gameObject:GetComponent(typeof(UILabel)),
		bDiamond = self.transform:Find("Widget_Currency/sDiamondContainer/bDiamond").gameObject,
		sRefreshPoint = self.transform:Find("Widget_Currency/sRefreshPoint").gameObject:GetComponent(typeof(UISprite)),
		sRefreshPointContainer = self.transform:Find("Widget_Currency/sRefreshPointContainer").gameObject,
		lRefreshPoint = self.transform:Find("Widget_Currency/sRefreshPointContainer/lRefreshPoint").gameObject:GetComponent(typeof(UILabel)),
	}

	m.Refresh = {
		lAutoRefresh = self.transform:Find("Widget_Refresh/lAutoRefresh").gameObject:GetComponent(typeof(UILabel)),
		lManualRefresh = self.transform:Find("Widget_Refresh/lManualRefresh").gameObject:GetComponent(typeof(UILabel)),
		bRefresh = self.transform:Find("Widget_Refresh/bRefresh").gameObject,
	}

	m.pButton_yeka = self.transform:Find("Panel_Tab/Widget_Tab/pButton").gameObject
	m.pShopItem = self.transform:Find("ui_shop_Prefabs/pShopItem").gameObject

	m.TimerDebugTools = {
		targetTime = self.transform:Find("DebugTools/targetTime").gameObject:GetComponent(typeof(UILabel)),
		remainTime = self.transform:Find("DebugTools/remainTime").gameObject:GetComponent(typeof(UILabel)),
	}
end

function wnd_shop_view:initCollider()
	local colliders = {}

	for i = 1,#model.local_Tabs do
		table.insert(colliders,m.Panel_Tab.TabButtons[i])
	end

	table.insert(colliders,m.Button_back)
	table.insert(colliders,m.Currency.bDiamond)
	table.insert(colliders,m.Refresh.bRefresh)
	table.insert(colliders,m.pButton_yeka)
	table.insert(colliders,m.pShopItem)

	local collider = nil
	for index,button in pairs(colliders) do
		collider = button:AddComponent(typeof(UnityEngine.BoxCollider))
		collider.isTrigger = true
		collider.center = Vector3.zero
		collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0) 
	end
end

return wnd_shop_view