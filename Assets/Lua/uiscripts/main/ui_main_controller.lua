require('uiscripts/shop/timeUtil/TimeUtil')
--[[
	ui_main_controller:
		variable:
			AvoidTimer 免战计时器
			AdditionalSystemBarItems 周边栏Item
			playerInfoWidget 玩家信息卡模块
			mainSystemBar 主系统栏模块
			mainCurrencyBar 主货币模块
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			OnDestroyDone() extend wnd_base:OnDestroyDone()
			initListener() 初始化界面按钮事件逻辑
]]
ui_main_controller = require("common/middleclass")("ui_main_controller",wnd_base)

local this = ui_main_controller
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_main_controller:OnShowDone()
	this.view = require('uiscripts/main/ui_main_view')
	this.model = require('uiscripts/main/ui_main_model')
	this.playerInfoWidget = require('uiscripts/main/PlayerInfoWidget')
	this.mobileInfoWidget = require('uiscripts/main/MobileInfoWidget')
	this.mainSystemBar = require('uiscripts/main/mainSystemBar')
	this.mainCurrencyBar = require('uiscripts/main/mainCurrencyBar')

	this.view:initView(self)
	this.model:initModel()
	this.playerInfoWidget.show()
	this.mobileInfoWidget.show()
	this.mainSystemBar.toggleBar()
	this.mainCurrencyBar.show()

	-- this:initListener()
	this.view:initCollider()
	this:initAdditionalSystemItem()
	this:toggleBar()
	this:checkAvoidTime()

	UnityEngine.SceneManagement.SceneManager.LoadScene("testMainScene",UnityEngine.SceneManagement.LoadSceneMode.Additive)
end

function ui_main_controller:OnDestroyDone()

end
----------------------------------------------------------------
--★周边系统栏模块控制
local touchSize = Vector3(66,66,0) -- 周边系统栏触摸范围大小
local itemLocalPosition = Vector3(-64,0,0) -- 周边系统栏图标起始相对位置
local itemOutPosition = Vector3(64,0,0) -- 周边系统栏图标屏幕外相对位置
local spacing = 20 -- 图标间距
local currentState = nil -- 周边系统栏当前状态
this.eBarState = {
	OPEN = 1,
	CLOSE = 2,
}
function ui_main_controller:initAdditionalSystemItem()
	this.AdditionalSystemBarItems = {}

	for i = 1,#this.model.local_AddtionalSystemBarData do
		if i == 1 then
			this.view.Widget_AdditionalSystem_Item.name = this.model.local_AddtionalSystemBarData[i]["ID"]
			this.view.Widget_AdditionalSystem_Item.transform:Find("Icon").gameObject:GetComponent(typeof(UISprite)).spriteName
				= this.model.local_AddtionalSystemBarData[i]["Icon"]
			this.view.Widget_AdditionalSystem_Item.transform:Find("Name").gameObject:GetComponent(typeof(UILabel)).text
				= this.model.local_AddtionalSystemBarData[i]["Name"]

			local collider = this.view.Widget_AdditionalSystem_Item:AddComponent(typeof(UnityEngine.BoxCollider))
			collider.isTrigger = true
			collider.center = Vector3.zero
			collider.size = touchSize

			this:attachListener(this.model.local_AddtionalSystemBarData[i]["ID"],this.view.Widget_AdditionalSystem_Item)

			table.insert(this.AdditionalSystemBarItems,this.view.Widget_AdditionalSystem_Item)
		else
			local pItem = GameObject.Instantiate(this.view.Widget_AdditionalSystem_Item,this.view.Widget_AdditionalSystem_Item.transform.parent)
			pItem.name = this.model.local_AddtionalSystemBarData[i]["ID"]
			pItem.transform.localScale = Vector3.one

			pItem.transform:Find("Icon").gameObject:GetComponent(typeof(UISprite)).spriteName
				= this.model.local_AddtionalSystemBarData[i]["Icon"]
			pItem.transform:Find("Name").gameObject:GetComponent(typeof(UILabel)).text
				= this.model.local_AddtionalSystemBarData[i]["Name"]

			this:attachListener(this.model.local_AddtionalSystemBarData[i]["ID"],pItem)

			table.insert(this.AdditionalSystemBarItems,pItem)
		end
	end

	UIEventListener.Get(this.view.Widget_AdditionalSystem).onClick = function()
		this.toggleBar()
	end
end
function ui_main_controller:attachListener(ID,pItem)
	if ID == 201 then -- 显示邮件
		UIEventListener.Get(pItem).onClick = function()
			-- ui_manager:ShowWB(WNDTYPE.ui_equip2)
		end
	elseif ID == 202 then -- 显示VIP界面
		UIEventListener.Get(pItem).onClick = function()
			-- ui_manager:ShowWB(WNDTYPE.BianDui)
		end
	elseif ID == 203 then -- 显示首充界面
		UIEventListener.Get(pItem).onClick = function()
			-- ui_manager:ShowWB(WNDTYPE.Cangku)
		end
	elseif ID == 204 then -- 显示签到界面
		UIEventListener.Get(pItem).onClick = function()
			ui_manager:ShowWB(WNDTYPE.QianDao)
		end
	elseif ID == 205 then -- 显示活动界面
		UIEventListener.Get(pItem).onClick = function()

		end
	end
end
function ui_main_controller.toggleBar()
	if currentState == this.eBarState.OPEN then
		this.playCloseAnime()
		currentState = this.eBarState.CLOSE
		this.view.Widget_AdditionalSystem:GetComponent(typeof(UISprite)).spriteName = "tongyong_jiantou_you"
	else
		this.playOpenAnime()
		currentState = this.eBarState.OPEN
		this.view.Widget_AdditionalSystem:GetComponent(typeof(UISprite)).spriteName = "tongyong_jiantou_zuo"
	end
end
function ui_main_controller.playOpenAnime()
	local skipCount = 0
	local currentLV = userModel:getUserRoleTbl().lv

	for i = 1,#this.AdditionalSystemBarItems do
		local ID = tonumber(this.AdditionalSystemBarItems[i].name)

		if currentLV < sdata_maininterface_data:GetFieldV("UnlockLevel",ID) then
			skipCount = skipCount + 1
		else
			this.AdditionalSystemBarItems[i].transform:DOLocalMove(
			Vector3(
				itemLocalPosition.x - (i - skipCount - 1) * (spacing + this.view.Widget_AdditionalSystem_Item:GetComponent(typeof(UIWidget)).localSize.x),
				itemLocalPosition.y,
				itemLocalPosition.z
			)
			,0.5,true)
		end
	end
end
function ui_main_controller.playCloseAnime()
	for i = 1,#this.AdditionalSystemBarItems do
		if this.AdditionalSystemBarItems[i].transform.localPosition ~= itemOutPosition then
			this.AdditionalSystemBarItems[i].transform:DOLocalMove(itemOutPosition,0.5,true)
		end
	end
end
----------------------------------------------------------------
--★免战计时器模块控制
function ui_main_controller:checkAvoidTime()
	if this.model.AvoidWarCardTimestamp > require('os').time() then
		this:showAvoidTimer()
	else
		this:hideAvoidTImer()
	end
end
function ui_main_controller:showAvoidTimer()
	this.view.AvoidWarTimer.gameObject:SetActive(true)
	local onTick = function()
			local str = TimeUtil:getRemainTime(this.model.AvoidWarCardTimestamp - os.time())
			this.view.AvoidWarTimer.text = str
			-- print(str.." compare 00:00:02")
			if str == '00:00:00' or str == '00:00:01' then
				this.AvoidTimer:Kill()
			end
		end
	local onKill = function()
			-- TODO: 免战倒计时结束
			this:hideAvoidTImer()
		end
	this.AvoidTimer = TimeUtil:CreateLoopTimer(1,onTick,onKill)
end
function ui_main_controller:hideAvoidTImer()
	this.view.AvoidWarTimer.gameObject:SetActive(false)
	this.view.AvoidWarTimerIcon:SetActive(false)
end

return ui_main_controller