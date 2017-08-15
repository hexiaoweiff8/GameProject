require('uiscripts/shop/timeUtil/TimeUtil')
require('uiscripts/tips/ui_tips_item')
require('uiscripts/tips/ui_tips_equip')
--[[
	wnd_shop_controller:
		variable:
			_selectedYekaButton
			ShopRefreshTimer 商店刷新计时器
			OnPressTimer 商品tips按钮计时器
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			initListener() 初始化界面按钮事件逻辑
			initTabButton() 初始化页卡Btn
			initShoppingList() 初始化商品表格
			showShoppingListByShopID() 显示对应商店ID的商店列表
			showPurchaseDetails() 显示购买详情界面
]]
wnd_shop_controller = require("common/middleclass")("wnd_shop_controller",wnd_base)

local this = wnd_shop_controller
local instance = nil

this._bTipsIsShow = false -- 当前界面是否有tips处于显示状态

function wnd_shop_controller:OnShowDone()
	this.view = require('uiscripts/shop/wnd_shop_view')
	this.model = require('uiscripts/shop/wnd_shop_model')
	this.view:initView(self)

	instance = self

	this:initTabButton()
	this.view:initCollider()
	this:initShoppingList()
	this:initListener()

	this:showDebugTimer()
	-- UIToast.Show(tostring(os.date("%X", os.time())),nil,UIToast.ShowType.Upwards)

	this.view.Panel_PurchaseDetails.panel:SetActive(false)

	this:SelectYekaButton(this.view.Panel_Tab.TabButtons[1])
	-- 获取刷新卡数量
	this.view.Refresh.lRefreshCardCount.text = require('uiscripts/cangku/wnd_cangku_model'):getServItemCountByItemID(470009)
end
----------------------------------------------------------------
--★DebugTimer
function wnd_shop_controller:showDebugTimer()
	local onTick = function()
			local str = TimeUtil:getRemainTimeStr(TimeUtil:getNextShopRefreshTimeStr())
			this.view.Refresh.lAutoRefresh.text = string.format(
				sdata_UILiteral.mData.body[0xFD02][sdata_UILiteral.mFieldName2Index["Literal"]],
				str)
			-- print(str.." compare 00:00:02")
			if str == '00:00:00' or str == '00:00:01' then
				print("Kill the Timer.")
				this.ShopRefreshTimer:Kill()
			end
		end
	local onKill = function()
			-- DONE: 倒计时结束刷新商店
			-- 使所有本地缓存数据失效
			for i = 1,#this.model.local_Tabs do
				if this.model.serv_ShopCacheData[this.model.local_Tabs[i]["ShopID"]] then
					this.model.serv_ShopCacheData[this.model.local_Tabs[i]["ShopID"]].UpdateTime = nil
				end
			end
			-- 刷新当前商店列表界面
			this:refreshShopListByCurrentShopID()
			UIToast.Show(sdata_UILiteral:GetFieldV("Literal", 0xFD03))
			this.ShopRefreshTimer = TimeUtil:CreateLoopTimer(1,onTick,onKill)
		end
	this.ShopRefreshTimer = TimeUtil:CreateLoopTimer(1,onTick,onKill)
end
----------------------------------------------------------------
--★Init 
function wnd_shop_controller:initListener()
	UIEventListener.Get(this.view.Button_back).onClick = function()
			-- TODO: 商店界面：返回按钮的实现
			instance:Hide(0)
		end
	-- 页卡
	for i = 1,#this.model.local_Tabs do
		UIEventListener.Get(this.view.Panel_Tab.TabButtons[i]).onClick = function (go)
			this:SelectYekaButton(go)
		end
	end
	-- 商品列表
	for i = 0,this.view.Panel_ShoppingList.transform.childCount - 1 do
		UIEventListener.Get(this.view.Panel_ShoppingList.transform:GetChild(i).gameObject).onPress = function (go,isPressed)
			this:HandleOnItemPress(go,isPressed)
		end
	end
	-- 商品购买详细界面按钮
	UIEventListener.Get(this.view.Panel_PurchaseDetails.btnClose).onClick = function()
		this.view.Panel_PurchaseDetails.panel:SetActive(false)
		end
	-- 刷新按钮
	UIEventListener.Get(this.view.Refresh.bRefresh).onClick = function()
			-- DONE: 商店界面：刷新按钮的实现/优化
			-- 刷新卡id:470009
			if require('uiscripts/cangku/wnd_cangku_model'):getServItemCountByItemID(470009) == 0 then
				UIToast.Show(sdata_UILiteral:GetFieldV("Literal", 0xFD04))
			else
				this:refreshShopListByCurrentShopID()
			end
		end
end
function wnd_shop_controller:initTabButton()

	local Tabs = this.model.local_Tabs

	local _spacing = this.view.pButton_yeka.transform:GetComponent(typeof(UIWidget)).localSize.y

	local yeka
	
	for i = 1,#this.model.local_Tabs do
		if i ~= 1 then
			yeka = GameObject.Instantiate(this.view.pButton_yeka)
			yeka.name = Tabs[i]["ShopID"]..'_'..Tabs[i]["ShopType"]
			yeka.transform:SetParent(this.view.pButton_yeka.transform.parent)
			yeka.transform.localScale = Vector3.one
			yeka.transform.localPosition = Vector3(this.view.pButton_yeka.transform.localPosition.x,this.view.pButton_yeka.transform.localPosition.y - (i-1) * _spacing,this.view.pButton_yeka.transform.localPosition.z)
			yeka:GetComponentInChildren(typeof(UILabel)).text = Tabs[i]["Label"]
			
			table.insert(this.view.Panel_Tab.TabButtons,yeka)
		else 
			this.view.pButton_yeka.name = Tabs[1]["ShopID"]..'_'..Tabs[1]["ShopType"]
			this.view.pButton_yeka:GetComponentInChildren(typeof(UILabel)).text = Tabs[1]["Label"]

			table.insert(this.view.Panel_Tab.TabButtons,this.view.pButton_yeka)		
		end
		
	end
end
function wnd_shop_controller:initShoppingList()
	-- 4x2 GlobalCoordinate (-309,103,0)
	-- 4x2 RelativeCoordinate (1,-52,0)
	local _spacing_x = 60
	local _spacing_y = 66
	for i = 0,1 do
		for j = 0,3 do
			if j == 0 and i == 0 then
				this.view.pShopItem.transform:SetParent(this.view.Panel_ShoppingList.transform)
					this.view.pShopItem.transform.localScale = Vector3.one
					this.view.pShopItem.transform.localPosition = Vector3(1,-52,0)
					table.insert(this.view.ShoppingListItems,this.view.pShopItem)
			else
				local base = this.view.pShopItem.transform.localPosition
				local iShopItem = GameObject.Instantiate(this.view.pShopItem,this.view.pShopItem.transform.parent)
				iShopItem.transform.localScale = Vector3.one
				iShopItem.transform.localPosition = Vector3(
					base.x + (_spacing_x + iShopItem:GetComponent(typeof(UIWidget)).width) * j,
					base.y - (_spacing_y + iShopItem:GetComponent(typeof(UIWidget)).height) * i,
					0)
				table.insert(this.view.ShoppingListItems,iShopItem)
			end
		end
	end
end
----------------------------------------------------------------
--★Control YekaButton
function wnd_shop_controller:SelectYekaButton(selectedButton)

	if selectedButton == this._selectedYekaButton then
		return
	end

	if this.mAtlas == nil then
		this.mAtlas = this.view.Button_back:GetComponent(typeof(UISprite)).atlas
	end

	if this._selectedYekaButton ~= nil then
		this._selectedYekaButton:GetComponent(typeof(UISprite)).atlas = nil
	end

	selectedButton:GetComponent(typeof(UISprite)).atlas = this.mAtlas
	selectedButton:GetComponent(typeof(UISprite)).spriteName = cstr.SELECTED_YEKA
	-- this.view.Panel_Tab.sTabTop.transform.localPosition = Vector3(selectedButton.transform.localPosition.x,
	-- 	selectedButton.transform.localPosition.y + selectedButton:GetComponent(typeof(UIWidget)).height / 2 + this.view.Panel_Tab.sTabTop:GetComponent(typeof(UIWidget)).height / 2,
	-- 	selectedButton.transform.localPosition.z)

	local start, e = string.find(selectedButton.name, '_')
	local ShopID = string.sub(selectedButton.name,1,start-1)
	local ShopType = string.sub(selectedButton.name,e+1,string.len(selectedButton.name))

	this:showShoppingListByShopID(tonumber(ShopID))
	this:refreshCurrency(ShopType)

	this._selectedYekaButton = selectedButton
end
----------------------------------------------------------------
--★Show/Refresh UI
function wnd_shop_controller:refreshCurrency(ShopType)
    this.view.Currency.lDiamond.text = currencyModel:getCurrentTbl().diamond

    if ShopType == "diamond" then
    	this.view.Currency.sMoneyType.gameObject:SetActive(false)
    	this.view.Currency.sMoneyTypeContainer.gameObject:SetActive(false)
	elseif ShopType == "gold" then
		this.view.Currency.sMoneyType.gameObject:SetActive(true)
    	this.view.Currency.sMoneyTypeContainer.gameObject:SetActive(true)
    	this.view.Currency.sMoneyType.spriteName = this.model:getShopCurrencyIconByField(ShopType)
	    this.view.Currency.lMoney.text = currencyModel:getCurrentTbl().gold
    elseif ShopType == "energy" then
    	this.view.Currency.sMoneyType.gameObject:SetActive(true)
    	this.view.Currency.sMoneyTypeContainer.gameObject:SetActive(true)
    	this.view.Currency.sMoneyType.spriteName = this.model:getShopCurrencyIconByField(ShopType)
	    this.view.Currency.lMoney.text = currencyModel:getCurrentTbl().tili
	elseif ShopType == "power" then
    	this.view.Currency.sMoneyType.gameObject:SetActive(true)
    	this.view.Currency.sMoneyTypeContainer.gameObject:SetActive(true)
    	this.view.Currency.sMoneyType.spriteName = this.model:getShopCurrencyIconByField(ShopType)
	    this.view.Currency.lMoney.text = currencyModel:getCurrentTbl().power
    elseif ShopType == "skillPt" then
    	this.view.Currency.sMoneyType.gameObject:SetActive(true)
    	this.view.Currency.sMoneyTypeContainer.gameObject:SetActive(true)
    	this.view.Currency.sMoneyType.spriteName = this.model:getShopCurrencyIconByField(ShopType)
	    this.view.Currency.lMoney.text = currencyModel:getCurrentTbl().skillPt
	elseif ShopType == "PkPt" then
    	this.view.Currency.sMoneyType.gameObject:SetActive(true)
    	this.view.Currency.sMoneyTypeContainer.gameObject:SetActive(true)
    	this.view.Currency.sMoneyType.spriteName = this.model:getShopCurrencyIconByField(ShopType)
	    this.view.Currency.lMoney.text = currencyModel:getCurrentTbl().skillPt  
	end
end

function wnd_shop_controller:showShoppingListByShopID(shopId)
	local on_10027_rec = function(body)
		local gw2c = gw2c_pb.GetShopDetail()
	    	  gw2c:ParseFromString(body)

	    this:saveServData(shopId,gw2c.shop)
	    this:loadShopCacheData(shopId)

	    Event.RemoveListener("10027", on_10027_rec)
	end

	if this.model.serv_ShopCacheData[shopId] == nil or 
		(this.model.serv_ShopCacheData[shopId] ~= nil and this.model.serv_ShopCacheData[shopId].UpdateTime ~= TimeUtil:getNextShopRefreshTimeStr()) then
		UIToast.Show("Conect...")
		Message_Manager:SendPB_10027(shopId,on_10027_rec)
	else
		this:loadShopCacheData(shopId)
	end
end

function wnd_shop_controller:showPurchaseDetails(goodsSlot,goodsID)
	this.view.Panel_PurchaseDetails.panel:SetActive(true)
	print("插槽:"..goodsSlot.." id:"..goodsID)
	local _CommodityData = this.model:getShopCommodityDataRefByGoodItemID(goodsID)
   	local _ItemData = nil
   	local _HoldCount = nil
   	local _Name = nil
   	local _Icon = nil
   	local _Quality = nil
   	local _FuncDes = nil
   	local _SuitEffect = nil

   	if _CommodityData["DropType"] == "item" then
   		_ItemData = require("uiscripts/cangku/wnd_cangku_model"):getLocalItemDataRefByItemID(tonumber(_CommodityData["DropID"]))
   		_Name = _ItemData["Name"]
	   	_Icon = _ItemData["Icon"]
	   	_Quality = _ItemData["Quality"]
	   	_FuncDes = _ItemData["FunctionDes"]
	   	_HoldCount = require("uiscripts/cangku/wnd_cangku_model"):getServItemCountByItemID(tonumber(_CommodityData["DropID"]))
	   	-- 时装碎片性别显示处理
		if _ItemData["UseType"] == 2 then
			local Male,Female = require('uiscripts/cangku/wnd_cangku_controller'):analysisFashionFragmentStr(_Name)
			_Name = (userModel:getUserRoleTbl().sex == 0 and {Male} or {Female})[1]
		end
	elseif _CommodityData["DropType"] == "equip" then
		_ItemData = require("uiscripts/commonModel/equip_Model"):getLocalEquipmentDetailByEquipID(tonumber(_CommodityData["DropID"]))
   		_Name = _ItemData["EquipName"]
	   	_Icon = _ItemData["EquipIcon"]
	   	_Quality = _ItemData.rarity
	   	_FuncDes = require("uiscripts/tips/ui_tips_equip"):getRandomMainAttrStr(_ItemData["MainAttribute"])
	   	_SuitEffect = '[f15c03]'..
			sdata_equipsuit_data.mData.body[_ItemData["SuitID"]][sdata_equipsuit_data.mFieldName2Index['SuitName']]..
			'[-]:\n'..
			require('uiscripts/Util/equipUtil'):getEquipmentSuitEffectNormalStr(_ItemData["SuitID"])
	   	-- _HoldCount = require("uiscripts/cangku/wnd_cangku_model"):getServEquipCountByEquipID(tonumber(_CommodityData["DropID"]))
	elseif _CommodityData["DropType"] == "currency" then
		_ItemData = this.model:getShopCurrencyDataRefByField(_CommodityData["DropID"])
   		_Name = _ItemData["Name"]
	   	_Icon = _ItemData["Icon"]
	   	_FuncDes = _ItemData["FunctionDes"]
   		_HoldCount = currencyModel:getCurrentTbl()[_CommodityData["DropID"]]
	elseif _CommodityData["DropType"] == "card" then
		_ItemData = nil
   		_Name = cardUtil:getCardName(tonumber(_CommodityData["DropID"]))
	   	_Icon = cardUtil:getCardIcon(tonumber(_CommodityData["DropID"]))
	   	_FuncDes = cardUtil:getCardDes(tonumber(_CommodityData["DropID"]))
	   	-- _HoldCount = require("uiscripts/cangku/wnd_cangku_model"):getServCardCountByCardID(tonumber(_CommodityData["DropID"]))
	end
		-- 处理品质值为空的情况
		_Quality = _Quality or 1 
   	
   	this.view.Panel_PurchaseDetails.Item_name.text = _Name
   	this.view.Panel_PurchaseDetails.Item_price.text = _CommodityData["Value"]
   	this.view.Panel_PurchaseDetails.Item_count.text = 
   	(_HoldCount ~= nil and {sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]].._HoldCount} or
   		{''})[1]
   	this.view.Panel_PurchaseDetails.Item_description.text = _FuncDes
   	this.view.Panel_PurchaseDetails.Equip_SuitEffect.text = _SuitEffect
   	this.view.Panel_PurchaseDetails.lPurchaseQuantity.text = 
   		string.format(sdata_UILiteral.mData.body[0xFD01][sdata_UILiteral.mFieldName2Index["Literal"]],_CommodityData["DropNum"]) 

   	this.view.Panel_PurchaseDetails.sMoneyType.spriteName = 
   		(_CommodityData["MoneyType"] == "diamond" and {this.model.cstr.DIAMOND} or 
   			{(_CommodityData["MoneyType"] == "gold" and {this.model.cstr.GOLD} or {this.model.cstr.PKPT})[1]})[1]
   	this.view.Panel_PurchaseDetails.Item_icon.spriteName = _Icon
   	this.view.Panel_PurchaseDetails.Item_Frame.spriteName,
   	this.view.Panel_PurchaseDetails.Item_Layer.spriteName = this.model:getQualitySpriteStr(_Quality)

   	if _ItemData and _ItemData["ComposeNum"] and _ItemData["ComposeNum"] ~= -1 then
   		this.view.Panel_PurchaseDetails.Composite_mark:SetActive(true)
   	else
   		this.view.Panel_PurchaseDetails.Composite_mark:SetActive(false)
   	end

   	UIEventListener.Get(this.view.Panel_PurchaseDetails.btnBuy).onClick = function()
		-- DONE: 购买商品,已测试
		local start, e = string.find(this._selectedYekaButton.name, '_')
		local ShopID = tonumber(string.sub(this._selectedYekaButton.name,1,start-1))
		local on_10029_rec = function(body)
			local gw2c = gw2c_pb.BuyShopGood()
	    	  gw2c:ParseFromString(body)

	    	this:savePurchaseItem(_CommodityData["DropType"],gw2c)
	    	 -- DONE:完成购买后添加已购买图标
	    	this.view.Panel_ShoppingList.transform:GetChild(goodsSlot).
	    	 	transform:Find("pItem/Icon_isSold").gameObject:GetComponent(typeof(UISprite)).spriteName = 
	    	 	this.model.cstr.SOLD
	    	this:refreshCurrency(this:getCurrentShopType())
	    	 -- DONE: 验证服务器数据
	    	 this:saveServData(this:getCurrentShopID(),gw2c.shop)
	    	 UIToast.Show(sdata_UILiteral:GetFieldV("Literal", 0xFD05))

	    	 this.view.Panel_PurchaseDetails.panel:SetActive(false)
	    	 Event.RemoveListener("10029",on_10029_rec)
		end
		-- DONE: 添加货币是否可以购买判定
		local _enough = false
		local _info = nil

		if _CommodityData["MoneyType"] == 'gold' then
			if currencyModel:getCurrentTbl().gold >= _CommodityData["Value"] then
				_enough = true
			else _enough = false _info = '金币' end
		elseif _CommodityData["MoneyType"] == 'diamond' then
		    if currencyModel:getCurrentTbl().diamond >= _CommodityData["Value"] then
		    	_enough = true
			else _enough = false _info = '钻石' end
		elseif _CommodityData["MoneyType"] == 'PkPt' then
			if currencyModel:getCurrentTbl().PkPt >= _CommodityData["Value"] then
		    	_enough = true
			else _enough = false _info = '竞技点数' end
		end
		if _enough then
			Message_Manager:SendPB_10029(ShopID,goodsSlot,this.model:getCommIDBySlotIndex(ShopID,goodsSlot),on_10029_rec)
		else UIToast.Show(_info..sdata_UILiteral:GetFieldV("Literal", 0xFD06)) end
	end
	UIEventListener.Get(this.view.Panel_PurchaseDetails.Mask).onClick = function()
		this.view.Panel_PurchaseDetails.panel:SetActive(false)
	end
end
--@Des 根据商品id信息填充内容到pShopItem上
--@Params shoppingListItem:pShopItem
--		  goodsID:商品id
--		  goodsIsSold:商品是否已出售
function wnd_shop_controller:ContentsInflate(shoppingListItem,goodsID,goodsIsSold,goodsSlot)
	shoppingListItem.name = tostring(goodsSlot)..'_'..tostring(goodsID)
	local _CommodityData = this.model:getShopCommodityDataRefByGoodItemID(goodsID)
   	local _ItemData = nil
   	local _Name = nil
   	local _Icon = nil
   	local _Quality = nil
   	local _IsSold = (goodsIsSold == 0 and {false} or {true})[1]

   	if _CommodityData["DropType"] == "item" then
   		_ItemData = require("uiscripts/cangku/wnd_cangku_model"):getLocalItemDataRefByItemID(tonumber(_CommodityData["DropID"]))
   		_Name = _ItemData["Name"]
	   	_Icon = _ItemData["Icon"]
	   	_Quality = _ItemData["Quality"]
	   	-- 时装碎片性别显示处理
		if _ItemData["UseType"] == 2 then
			local Male,Female = require('uiscripts/cangku/wnd_cangku_controller'):analysisFashionFragmentStr(_Name)
			_Name = (userModel:getUserRoleTbl().sex == 0 and {Male} or {Female})[1]
		end
	elseif _CommodityData["DropType"] == "equip" then
		_ItemData = require("uiscripts/commonModel/equip_Model"):getLocalEquipmentDetailByEquipID(tonumber(_CommodityData["DropID"]))
   		_Name = _ItemData["EquipName"]
	   	_Icon = _ItemData["EquipIcon"]
	   	_Quality = _CommodityData["Quality"]
	elseif _CommodityData["DropType"] == "currency" then
		_ItemData = this.model:getShopCurrencyDataRefByField(_CommodityData["DropID"])
   		_Name = _ItemData["Name"]
	   	_Icon = _ItemData["Icon"]
	   	_Quality = _CommodityData["Quality"]
	elseif _CommodityData["DropType"] == "card" then
		_ItemData = nil
   		_Name = cardUtil:getCardName(tonumber(_CommodityData["DropID"]))
	   	_Icon = cardUtil:getCardIcon(tonumber(_CommodityData["DropID"]))
	   	_Quality = _CommodityData["Quality"]
	end
		-- 处理品质值为-1的情况
		if _Quality == -1 then
			_Quality = 1
		end

   	local Label_name = shoppingListItem.transform:Find("Item_name").gameObject:GetComponent(typeof(UILabel))
   	local Sprite_moneyType = shoppingListItem.transform:Find("sCoin").gameObject:GetComponent(typeof(UISprite))
   	local Label_cost = shoppingListItem.transform:Find("Item_cost").gameObject:GetComponent(typeof(UILabel))
   	local Sprite_icon = shoppingListItem.transform:Find("pItem/Icon").gameObject:GetComponent(typeof(UISprite))
   	local Label_count = shoppingListItem.transform:Find("pItem/Item_Count").gameObject:GetComponent(typeof(UILabel))
   	local Sprite_frame = shoppingListItem.transform:Find("pItem/Icon_Frame").gameObject:GetComponent(typeof(UISprite))
   	local Sprite_layer = shoppingListItem.transform:Find("pItem/Icon_Layer").gameObject:GetComponent(typeof(UISprite))
   	local Sprite_mark = shoppingListItem.transform:Find("pItem/Composite_mark").gameObject:GetComponent(typeof(UISprite))
   	local Sprite_isSold = shoppingListItem.transform:Find("pItem/Icon_isSold").gameObject:GetComponent(typeof(UISprite))
   	
   	Label_name.text = _Name
   	Label_cost.text = _CommodityData["Value"]
   	Label_count.text = _CommodityData["DropNum"]

   	Sprite_moneyType.spriteName = 
   		(_CommodityData["MoneyType"] == "diamond" and {this.model.cstr.DIAMOND} or 
   			{(_CommodityData["MoneyType"] == "gold" and {this.model.cstr.GOLD} or {this.model.cstr.PKPT})[1]})[1]
   	Sprite_icon.spriteName = _Icon
   	Sprite_frame.spriteName,Sprite_layer.spriteName = this.model:getQualitySpriteStr(_Quality)

   	if _ItemData and _ItemData["ComposeNum"] and _ItemData["ComposeNum"] ~= -1 then
   		Sprite_mark.gameObject:SetActive(true)
   	else
   		Sprite_mark.gameObject:SetActive(false)
   	end
   	-- DONE: 添加已售出图标
   	if _IsSold then
   		Sprite_isSold.spriteName = this.model.cstr.SOLD
   	else
   		Sprite_isSold.spriteName = nil
   	end
end
----------------------------------------------------------------
--★HandleOnItem Event
function wnd_shop_controller:HandleOnItemPress(gItem,isPressed)
	local start, e = string.find(gItem.name, '_')
	this.goodsSlot = tonumber(string.sub(gItem.name,1,start-1))
	this.goodsID = tonumber(string.sub(gItem.name,e+1,string.len(gItem.name)))

	local OnComplete = function()

		local _CommodityData = this.model:getShopCommodityDataRefByGoodItemID(this.goodsID)
		print("_CommodityData[DropType] = ".._CommodityData["DropType"])
		if _CommodityData["DropType"] == 'item' then
			-- ui_tips_item.Show(require('uiscripts/cangku/wnd_cangku_model'):getLocalItemDataRefByItemID(tonumber(_CommodityData["DropID"])),
			-- 		this:genTipsLocalPosition(this.goodsSlot))
			this._bTipsIsShow = true
		elseif _CommodityData["DropType"] == 'equip' then
			-- DONE: 显示装备Tips
			ui_tips_equip.Show(require('uiscripts/commonModel/equip_Model'):getLocalEquipmentRefByEquipID(tonumber(_CommodityData["DropID"])),
					this:genTipsLocalPosition(this.goodsSlot))
			this._bTipsIsShow = true
		elseif _CommodityData["DropType"] == 'card' then
			-- DONE: 显示卡牌Tips
			this._bTipsIsShow = true
		end
	end
	if isPressed then
		if this.OnPressTimer then
			if this.OnPressTimer.IsStop then
				this.OnPressTimer:Start()
			end
		else
			this.OnPressTimer = TimeUtil:CreateTimer(0.5,OnComplete)
		end
	else
		this.OnPressTimer:Kill()
		-- DONE: 如果装备Tips处于显示状态,则隐藏装备Tips,而不显示购买界面
		-- DONE: 显示购买界面
		if this._bTipsIsShow then
			if ui_tips_item.bIsShowing then
				ui_tips_item.Hide()
			elseif ui_tips_equip.bIsShowing then
				ui_tips_equip.Hide()
			end
			this._bTipsIsShow = false
		else
			-- DONE: 添加商品已售出判定
			local _isSold = this.model:whether_The_Goods_have_been_sold(this:getCurrentShopID(),this.goodsSlot)
			if not _isSold then
				this:showPurchaseDetails(this.goodsSlot,this.goodsID)
			else UIToast.Show(sdata_UILiteral:GetFieldV("Literal", 0xFD07)) end
		end
	end
end
----------------------------------------------------------------
--★Save Serv Data
--@Des 保存服务器缓存数据
function wnd_shop_controller:saveServData(shopId,gw2c_shop)
	-- 初始化本地服务器缓存数据
	this.model.serv_ShopCacheData[shopId] = {}
	local shoppingListIndex = 1
	for k, v in ipairs(gw2c_shop.good) do
		-- 添加槽位字段
		-- print("槽位:"..(shoppingListIndex - 1).." id:"..v.id)
		table.insert(this.model.serv_ShopCacheData[shopId],{id = v.id, isSold = v.isSold, slot = shoppingListIndex - 1})
	   	shoppingListIndex = shoppingListIndex + 1
	end
	print("ItemCount = "..(shoppingListIndex-1))
	-- 创建字段记录此shopId的商品列表的刷新时间,用于检查是否过期
	this.model.serv_ShopCacheData[shopId].UpdateTime = TimeUtil:getNextShopRefreshTimeStr()
	print(gw2c_shop.cnt)
end
--@Des 加载服务器缓存数据
function wnd_shop_controller:loadShopCacheData(shopId)
	-- DONE: 读取本地服务器缓存数据
	for i = 1,#this.model.serv_ShopCacheData[shopId] do
		this:ContentsInflate(this.view.ShoppingListItems[i],
			this.model.serv_ShopCacheData[shopId][i].id,
			this.model.serv_ShopCacheData[shopId][i].isSold,
			this.model.serv_ShopCacheData[shopId][i].slot)
	end
end
--@Des 根据当前页卡ShopID连接服务器刷新商店
function wnd_shop_controller:refreshShopListByCurrentShopID()

	local start, e = string.find(this._selectedYekaButton.name, '_')
	local ShopID = tonumber(string.sub(this._selectedYekaButton.name,1,start-1))
	
    local on_10028_rec = function(body)
		local gw2c = gw2c_pb.RefreshShop()
    	  gw2c:ParseFromString(body)
    	--更新本地刷新卡数据
    	require('uiscripts/cangku/wnd_cangku_model'):addOrUpdateItemData(gw2c.item)
    	--更新商店货币信息
    	this:refreshCurrency(this:getCurrentShopType())

		wnd_shop_controller:saveServData(ShopID,gw2c.shop)
	    wnd_shop_controller:loadShopCacheData(ShopID)

	    this.view.Refresh.lRefreshCardCount.text = require('uiscripts/cangku/wnd_cangku_model'):getServItemCountByItemID(470009)
		Event.RemoveListener("10028",on_10028_rec)
	end
	Message_Manager:SendPB_10028(ShopID,on_10028_rec)
end
--@Des 保存购买界面的商品信息
--@Params DropType:商品类型
--		  gw2c:确认购买后,由服务器传回的数据
function wnd_shop_controller:savePurchaseItem(DropType,gw2c)
	-- print("保存商品类型："..DropType)
	if DropType == "item" then
   		require("uiscripts/cangku/wnd_cangku_model"):addOrUpdateItemData(gw2c.item)
	elseif DropType == "equip" then
	   	require("uiscripts/cangku/wnd_cangku_model"):addEquipData(gw2c.equip)
	elseif DropType == "currency" then
		-- DONE:追加货币
		this:refreshCurrency(this:getCurrentShopType())
	elseif DropType == "card" then
		-- DONE:追加卡牌
		cardModel:addCards(gw2c.card)
	end
	currencyModel:initCurrencyTbl(gw2c.currency)
end
----------------------------------------------------------------
--★Util
function wnd_shop_controller:getCurrentShopID()
	local start, e = string.find(this._selectedYekaButton.name, '_')
	local ShopID = string.sub(this._selectedYekaButton.name,1,start-1)
	return tonumber(ShopID)
end
function wnd_shop_controller:getCurrentShopType()
	local start, e = string.find(this._selectedYekaButton.name, '_')
	local ShopID = string.sub(this._selectedYekaButton.name,1,start-1)
	local ShopType = string.sub(this._selectedYekaButton.name,e+1,string.len(this._selectedYekaButton.name))
	return ShopType
end
function wnd_shop_controller:genTipsLocalPosition(SlotIndex)
	if SlotIndex == 1 or SlotIndex == 5 then
		return Vector3(250,0,0)
	elseif SlotIndex == 2 or SlotIndex == 6 then
		return Vector3(-150,0,0)
	else
		return Vector3.zero
	end
end

return wnd_shop_controller