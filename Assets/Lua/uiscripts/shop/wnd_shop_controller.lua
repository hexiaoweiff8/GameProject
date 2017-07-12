require('uiscripts/shop/timeUtil/TimeUtil')
--[[
	wnd_shop_controller:
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			initListener() 初始化界面按钮事件逻辑
			initTabButton() 初始化页卡Btn
]]
wnd_shop_controller = require("common/middleclass")("wnd_shop_controller",wnd_base)

local this = wnd_shop_controller

function wnd_shop_controller:OnShowDone()
	this.view = require('uiscripts/shop/wnd_shop_view')
	this.model = require('uiscripts/shop/wnd_shop_model')
	this.view:initView(self)
	this.model:initModel()

	this:initTabButton()
	this.view:initCollider()
	this:initListener()

	this:showDebugTimer()
	UIToast.Show(tostring(os.date("%X", os.time())),nil,UIToast.ShowType.Upwards)
end
----------------------------------------------------------------
--★DebugTimer
function wnd_shop_controller:showDebugTimer()
	this.view.TimerDebugTools.targetTime.text = TimeUtil:getNextShopRefreshTimeStr()

	local ShopTimer = startTimer(
		TimeUtil:getRemainTimeSec(this.view.TimerDebugTools.targetTime.text),
		function()
			this.view.TimerDebugTools.remainTime.text = TimeUtil:getRemainTimeStr(this.view.TimerDebugTools.targetTime.text)
		end,
		nil,'ShopTimer')
end
----------------------------------------------------------------
--★Init
function wnd_shop_controller:initListener()
	-- 页卡
	for i = 1,#this.model.local_Tabs do
		UIEventListener.Get(this.view.Panel_Tab.TabButtons[i]).onClick = function (go)
			this:SelectYekaButton(go)
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
----------------------------------------------------------------
--★Control YekaButton
function wnd_shop_controller:SelectYekaButton(selectedButton)

	if selectedButton == this._selectedYekaButton then
		return
	end

	if mAtlas == nil then
		mAtlas = this.view.Button_back:GetComponent(typeof(UISprite)).atlas
	end

	if this._selectedYekaButton ~= nil then
		this._selectedYekaButton:GetComponent(typeof(UISprite)).atlas = nil
	end

	selectedButton:GetComponent(typeof(UISprite)).atlas = mAtlas
	selectedButton:GetComponent(typeof(UISprite)).spriteName = cstr.SELECTED_YEKA
	this.view.Panel_Tab.sTabTop.transform.localPosition = Vector3(selectedButton.transform.localPosition.x,
		selectedButton.transform.localPosition.y + selectedButton:GetComponent(typeof(UIWidget)).height / 2 + this.view.Panel_Tab.sTabTop:GetComponent(typeof(UIWidget)).height / 2,
		selectedButton.transform.localPosition.z)

	local start, e = string.find(selectedButton.name, '_')
	local ShopID = string.sub(selectedButton.name,1,start-1)
	local ShopType = string.sub(selectedButton.name,e+1,string.len(selectedButton.name))

	this._selectedYekaButton = selectedButton
end

return wnd_shop_controller