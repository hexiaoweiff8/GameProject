require('uiscripts/cangku/const/wnd_cangku_Const')
--[[
	wnd_cardshop_controller:
		variable:
			_selectedYekaButton
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			OnDestroyDone() extend wnd_base:OnDestroyDone()
			initListener() 初始化界面按钮事件逻辑
			initTabButton() 初始化页卡Btn
			initCurrencyView() 初始化货币UI值
			showShoppingListByShopType() 显示对应商店ID的商店列表
]]
wnd_cardshop_controller = require("common/middleclass")("wnd_cardshop_controller",wnd_base)

local this = wnd_cardshop_controller

function wnd_cardshop_controller:OnShowDone()
	this.view = require('uiscripts/shop_card/wnd_cardshop_view')
	this.model = require('uiscripts/shop_card/wnd_cardshop_model')
	this.scrollViewController = require("uiscripts/shop_card/wnd_cardshop_scrollView_controller")

	this.model:initModel()
	this.view:initView(self)
	this.scrollViewController:init(self)

	this:initTabButton()
	this:initListener()
	this.view:initCollider()

	this:initCurrencyView()

	this:SelectYekaButton(this.view.Panel_Tab.TabButtons[1])

	this.scrollViewController:ToggleIndicator()
	this.scrollViewController:BindingAll()
	this.scrollViewController:StartAllToggleAnime()
end
function wnd_cardshop_controller:OnDestroyDone()
	-- 该界面关闭时,销毁所有绑定动画
	this.scrollViewController:KillAllToggleAnime()
end
----------------------------------------------------------------
--★Init 
function wnd_cardshop_controller:initTabButton()

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
function wnd_cardshop_controller:initListener()
	UIEventListener.Get(this.view.Button_close).onClick = function()
			-- TODO: 商店界面：关闭按钮的实现
			ui_manager:DestroyWB(self)
		end
	-- 页卡
	for i = 1,#this.model.local_Tabs do
		UIEventListener.Get(this.view.Panel_Tab.TabButtons[i]).onClick = function (go)
			this:SelectYekaButton(go)
		end
	end
end
function wnd_cardshop_controller:initCurrencyView()
	this.view.Currency.lHumanPt.text = currencyModel:getCurrentTbl().HumanPt
	this.view.Currency.lOrcPt.text = currencyModel:getCurrentTbl().OrcPt
	this.view.Currency.lOmnicPt.text = currencyModel:getCurrentTbl().OmnicPt
end
----------------------------------------------------------------
--★Control YekaButton
function wnd_cardshop_controller:SelectYekaButton(selectedButton)

	if selectedButton == this._selectedYekaButton then
		return
	end

	if mAtlas == nil then
		mAtlas = this.view.Button_close:GetComponent(typeof(UISprite)).atlas
	end

	if this._selectedYekaButton ~= nil then
		this._selectedYekaButton:GetComponent(typeof(UISprite)).atlas = nil
	end

	selectedButton:GetComponent(typeof(UISprite)).atlas = mAtlas
	selectedButton:GetComponent(typeof(UISprite)).spriteName = cstr.SELECTED_YEKA_EX

	local start, e = string.find(selectedButton.name, '_')
	local ShopID = string.sub(selectedButton.name,1,start-1)
	local ShopType = string.sub(selectedButton.name,e+1,string.len(selectedButton.name))

	this:showShoppingListByShopType(ShopType)

	this._selectedYekaButton = selectedButton
end
----------------------------------------------------------------
--★Show
function wnd_cardshop_controller:showShoppingListByShopType(shopType)
	this.scrollViewController:filterBy(shopType)
end
----------------------------------------------------------------
--★Buy
function wnd_cardshop_controller:BuyCard(CardID,item)
	if CardID == nil or type(CardID) ~= 'number' then
		error("传入CardID不正确")
		return
	end
	local on_10031_rec = function(body)
		local gw2c = gw2c_pb.BuyCard()
	    gw2c:ParseFromString(body)

	    cardModel:setCardInfo(gw2c.card)
	    currencyModel:initCurrencyTbl(gw2c.currency)

	    this:initCurrencyView()

	    this.scrollViewController:RefreshPriceDisplay(item)

	    Event.RemoveListener("10031", on_10031_rec)
	end
	Message_Manager:SendPB_10031(CardID,on_10031_rec)
end

function wnd_cardshop_controller:HaveEnoughMoney2Buy(cardPrice,currencyType)
	local currentMoney = (
		currencyType == 'HumanPt' and {currencyModel:getCurrentTbl().HumanPt} or 
		{(currencyType == 'OrcPt' and {currencyModel:getCurrentTbl().OrcPt} or 
			{currencyModel:getCurrentTbl().OmnicPt})[1]})[1]

	if currentMoney < cardPrice then
		return false
	else
		return true
	end
end

return wnd_cardshop_controller