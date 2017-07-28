wnd_cardshop_view = {
	Button_close,

	Panel_Tab={
		TabButtons = {},
		sTabTop,
	},
	Panel_ShoppingList,
	ShoppingListItems = {}, -- 商品表格项Object
	Currency = {
		lHumanPt,
		lOrcPt,
		lOmnicPt,
	},
	pButton_yeka,
	pShopItem,
}
local m = wnd_cardshop_view

function wnd_cardshop_view:initView(root)
	self = root

	model = self.model

	m.Button_close = self.transform:Find("Button_close").gameObject

	m.Panel_ShoppingList = self.transform:Find("Panel_ShopList/ListView").gameObject

	m.Currency = {
		lHumanPt = self.transform:Find("Widget_Currency/lHumanPt").gameObject:GetComponent(typeof(UILabel)),
		lOrcPt = self.transform:Find("Widget_Currency/lOrcPt").gameObject:GetComponent(typeof(UILabel)),
		lOmnicPt = self.transform:Find("Widget_Currency/lOmnicPt").gameObject:GetComponent(typeof(UILabel)),
	}

	m.pButton_yeka = self.transform:Find("Widget_Tab/pButton").gameObject
	m.pShopItem = self.transform:Find("ui_shop_Prefabs/pShopItem").gameObject
end

function wnd_cardshop_view:initCollider()
	local colliders = {}

	for i = 1,#model.local_Tabs do
		table.insert(colliders,m.Panel_Tab.TabButtons[i])
	end

	table.insert(colliders,m.Button_close)
	table.insert(colliders,m.Currency.bDiamond)
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

return wnd_cardshop_view