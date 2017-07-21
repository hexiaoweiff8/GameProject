wnd_shop_view = {
	Button_back,

	Panel_Tab={
		TabButtons = {},
		sTabTop,
	},
	Panel_ShoppingList,
	ShoppingListItems = {}, -- 商品表格项Object
	Panel_PurchaseDetails = {
		btnClose,
		btnBuy,
		Item_icon,
		Item_Layer,
		Item_Frame,
		Composite_mark,
		Item_name,
		Item_count,
		Item_description,
		Equip_SuitEffect,
		lPurchaseQuantity,
		sMoneyType,
		Item_price,
	},
	Currency = {
		lMoney,
		lDiamond,
		bDiamond,
		lRefreshPoint,
	},
	Refresh = {
		lAutoRefresh,
		lManualRefresh,
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

	m.Panel_ShoppingList = self.transform:Find("Panel_Fragment").gameObject

	m.Panel_PurchaseDetails = {
		Mask = self.transform:Find("Panel_PurchaseDetails/Mask").gameObject,
		btnClose = self.transform:Find("Panel_PurchaseDetails/Button_close").gameObject,
		btnBuy = self.transform:Find("Panel_PurchaseDetails/Button_buy").gameObject,
		Item_icon = self.transform:Find("Panel_PurchaseDetails/pItem/Icon").gameObject:GetComponent(typeof(UISprite)),
		Item_Layer = self.transform:Find("Panel_PurchaseDetails/pItem/Icon_Layer").gameObject:GetComponent(typeof(UISprite)),
		Item_Frame = self.transform:Find("Panel_PurchaseDetails/pItem/Icon_Frame").gameObject:GetComponent(typeof(UISprite)),
		Composite_mark = self.transform:Find("Panel_PurchaseDetails/pItem/Composite_mark").gameObject,
		Item_name = self.transform:Find("Panel_PurchaseDetails/Item_name").gameObject:GetComponent(typeof(UILabel)),
		Item_count = self.transform:Find("Panel_PurchaseDetails/Item_count").gameObject:GetComponent(typeof(UILabel)),
		Item_description = self.transform:Find("Panel_PurchaseDetails/Item_description").gameObject:GetComponent(typeof(UILabel)),
		Equip_SuitEffect = self.transform:Find("Panel_PurchaseDetails/Equip_SuitEffect").gameObject:GetComponent(typeof(UILabel)),
		lPurchaseQuantity = self.transform:Find("Panel_PurchaseDetails/Label_Container/Label").gameObject:GetComponent(typeof(UILabel)),
		sMoneyType = self.transform:Find("Panel_PurchaseDetails/Label_Container/Sprite").gameObject:GetComponent(typeof(UISprite)),
		Item_price = self.transform:Find("Panel_PurchaseDetails/Label_Container/Label_price").gameObject:GetComponent(typeof(UILabel)),
	}
	m.Panel_PurchaseDetails.panel = self.transform:Find("Panel_PurchaseDetails").gameObject

	m.Currency = {
		sMoneyType = self.transform:Find("Widget_Currency/sMoneyType").gameObject:GetComponent(typeof(UISprite)),
		sMoneyTypeContainer = self.transform:Find("Widget_Currency/sMoneyTypeContainer").gameObject,
		lMoney = self.transform:Find("Widget_Currency/sMoneyTypeContainer/lMoney").gameObject:GetComponent(typeof(UILabel)),
		lDiamond = self.transform:Find("Widget_Currency/sDiamondContainer/lDiamond").gameObject:GetComponent(typeof(UILabel)),
		bDiamond = self.transform:Find("Widget_Currency/sDiamondContainer/bDiamond").gameObject,
	}

	m.Refresh = {
		lAutoRefresh = self.transform:Find("Widget_Refresh/lAutoRefresh").gameObject:GetComponent(typeof(UILabel)),
		lManualRefresh = self.transform:Find("Widget_Refresh/lManualRefresh").gameObject:GetComponent(typeof(UILabel)),
		bRefresh = self.transform:Find("Widget_Refresh/bRefresh").gameObject,
		lRefreshCardCount = self.transform:Find("Widget_Refresh/bRefresh/Label").gameObject:GetComponent(typeof(UILabel)),
	}

	m.pButton_yeka = self.transform:Find("Panel_Tab/Widget_Tab/pButton").gameObject
	m.pShopItem = self.transform:Find("ui_shop_Prefabs/pShopItem").gameObject
end

function wnd_shop_view:initCollider()
	local colliders = {}

	for i = 1,#model.local_Tabs do
		table.insert(colliders,m.Panel_Tab.TabButtons[i])
	end

	table.insert(colliders,m.Button_back)
	table.insert(colliders,m.Panel_PurchaseDetails.btnClose)
	table.insert(colliders,m.Panel_PurchaseDetails.btnBuy)
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