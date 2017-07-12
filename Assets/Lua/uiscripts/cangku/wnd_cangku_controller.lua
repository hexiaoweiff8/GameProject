require('uiscripts/cangku/util/deepcopy')
require('uiscripts/cangku/util/shallowcopy')
require('uiscripts/cangku/const/wnd_cangku_Const')
wnd_cangku_controller = {

	view,
	model,
	scrollViewController,

	-- variable
	_DecompositionPanelState = nil,--记录装备分解面板checkbox勾选状态
	_selectedYekaButton,--记录已选择的页卡按钮
	_currentPanel_right,--记录当前显示在右边的panel

	-- function
	initTabButton,--初始化页卡按钮
	initListener,--添加按钮事件

	SelectYekaButton,--切换页卡功能

	show,--显示，隐藏panel
	hide,
	showPanelByItemData,--通过Item数据决定显示何面板
	showEquipmentDetailsPanel,--显示装备详细面板

	processServData, -- 处理服务器数据
	sortServData, -- 对服务器数据列表排序
	mergeServData, -- 合并 装备/道具数据
	updateServData, -- 更新model服务器数据
}
local class = require("common/middleclass")
wnd_cangku_controller = class("wnd_cangku_controller",wnd_base)

local this = wnd_cangku_controller

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_cangku_controller:OnShowDone()
	this.view = require("uiscripts/cangku/wnd_cangku_view")
	this.model = require("uiscripts/cangku/wnd_cangku_model")
	this.scrollViewController = require("uiscripts/cangku/scrollview/wnd_cangku_ScrollView_controller")

	this.view:initView(self)
	-- this.model:initModel()
	this.scrollViewController:init(self)

	this:initTabButton()
	this.view:initCollider()
	this:initListener()

	this.view.Panel_Detail_decomposition.panel:SetActive(false)
	this:hide(this.view.Panel_Detail_item)
	this:hide(this.view.Panel_Detail_equipment)
	this.view.MessageBox.mBox.panel:SetActive(false)
	this.view.MessageBox.mBox_decomposition_tips.panel:SetActive(false)
	this.view.MessageBox.mBox_decomposition_detail_tips.panel:SetActive(false)
	this.view.MessageBox.mBox_chestBox.panel:SetActive(false)
	this.view.MessageBox.panel:SetActive(true)
	-- local tween = this.view.MessageBox.mBox.panel.transform:DOPunchScale(Vector3(1.5, 1.5, 0), 1, 1, 1)

	-- 默认选中第一个按钮
	this:SelectYekaButton(this.view.Panel_Tab.TabButtons[1])
end
----------------------------------------------------------------
--★Init
function wnd_cangku_controller:initListener()

	UIEventListener.Get(this.view.Button_back).onClick = function()
			-- TODO: 仓库界面：返回按钮的实现
			UIToast.Show("返回上一界面",nil,UIToast.ShowType.Upwards)
		end
	-- 页卡
	for i = 1,this.model.DepositoryTab_Count do
		UIEventListener.Get(this.view.Panel_Tab.TabButtons[i]).onClick = function (go)
			this:SelectYekaButton(go)
		end 
	end
	
	-- 装备分解界面
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Button_close).onClick = function()
			this:hide(this.view.Panel_Detail_decomposition)
			if before_panel ~= nil then
				this:show(before_panel)
			end
			this.scrollViewController:filterBy('Equip',-1)
		end
	
	Checkbox_OnCheck = function(go)
			local checkbox = go.transform:GetChild(0):GetComponent(typeof(UISprite))
			local _Quality
			if go == this.view.Panel_Detail_decomposition.Checkbox.Button_white then
				_Quality = 1
			elseif go == this.view.Panel_Detail_decomposition.Checkbox.Button_green then
				_Quality = 2
			elseif go == this.view.Panel_Detail_decomposition.Checkbox.Button_blue then
				_Quality = 3
			elseif go == this.view.Panel_Detail_decomposition.Checkbox.Button_purple then
				_Quality = 4
			elseif go == this.view.Panel_Detail_decomposition.Checkbox.Button_golden then
				_Quality = 5
			else
				_Quality = 6 end

			if checkbox.spriteName == cstr.SELECTED_CB then -- 如果已选中
				checkbox.spriteName = 'nil'
				-- DONE: 取消显示所有对应品质装备
				this.scrollViewController:removeEquipmentShowByQuality(_Quality)
			else
				checkbox.spriteName = cstr.SELECTED_CB
				-- DONE: 显示所有对应品质装备
				this.scrollViewController:addEquipmentShowByQuality(_Quality)
			end
		end
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_white).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_green).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_blue).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_purple).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_golden).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_red).onClick = Checkbox_OnCheck
	-- 确认分解逻辑
	local OnConfirmDecomposition = function(_sellType,_Cost)
		local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的和)
	    for i,v in ipairs(this.model.serv_CurrencyInfo.diamond) do
	    	diamondNum = diamondNum + v
	    end
		if (_sellType == 1 and {diamondNum} or {this.model.serv_CurrencyInfo.gold})[1] < _Cost then
			print("当前钻石："..diamondNum)
			print("当前金币："..this.model.serv_CurrencyInfo.gold)
			UIToast.Show("货币不足，无法分解",nil,UIToast.ShowType.Upwards)
			return
		end

		local _equipList = {}

		for i = 1,#this.scrollViewController._selectedItems do
			table.insert(_equipList,this.scrollViewController._selectedItems[i].id)
		end
		local on_10023_rec = function(body)
			Event.RemoveListener("10023", on_10023_rec)
			UIToast.Show("所选装备已分解.",nil,UIToast.ShowType.Queue)
			local gw2c = gw2c_pb.SellEquip()
		    gw2c:ParseFromString(body)
		    this:updateServData(gw2c.currency,nil)
		    -- 从装备表中删除装备，并刷新界面
		    this:removeEquipmentByIDList(_equipList)
		    -- 隐藏Mbox
		    if this.view.MessageBox.mBox_decomposition_tips.panel.activeInHierarchy then
		    	this.view.MessageBox.mBox_decomposition_tips.panel:SetActive(false)
		    end
		    if this.view.MessageBox.mBox_decomposition_detail_tips.panel.activeInHierarchy then
		    	this.view.MessageBox.mBox_decomposition_detail_tips.panel:SetActive(false)
		    end
		    this.scrollViewController._State_InDECOMPOSITION = false
			this.model.decomposition_Equipment = {} -- 清空临时数据
			this:SaveDecompositionPanelState()
			this:LoadDecompositionPanelState()
		end
		Message_Manager:SendPB_10023(_sellType,_equipList,on_10023_rec)
	end
	-- 完美分解按钮，弹出提示框
	local OnPerfectClick = function()

		if #this.scrollViewController._selectedItems == 0 then
			UIToast.Show("还没有选中任何要分解的装备",nil,UIToast.ShowType.Upwards)
			return
		end
		
		this.view.MessageBox.mBox_decomposition_tips.panel:SetActive(true)

		local _Power = this.scrollViewController:calcTotalEquipmentDecomposeReturn()
		local _Cost = this:calcDecomposePrice(_Power)

		this.view.MessageBox.mBox_decomposition_tips.Label_tips:GetComponent("UILabel").text = 
			sdata_UILiteral.mData.body[0xFE23][sdata_UILiteral.mFieldName2Index["Literal"]]
		this.view.MessageBox.mBox_decomposition_tips.Label_energy:GetComponent("UILabel").text = '('.._Power
		this.view.MessageBox.mBox_decomposition_tips.Label_cost:GetComponent("UILabel").text = _Cost

		-- 分解装备中包含高品质装备时显示提示
		this.view.MessageBox.mBox_decomposition_tips.Label_confirm_tips:GetComponent("UILabel").text =
			sdata_UILiteral.mData.body[0xFE24][sdata_UILiteral.mFieldName2Index["Literal"]]
		this.view.MessageBox.mBox_decomposition_tips.Label_confirm_tips:SetActive(false)
		for i = 1,#this.scrollViewController._selectedItems do
			if this.scrollViewController._selectedItems[i].rarity == 5 or this.scrollViewController._selectedItems[i].rarity == 6 then
				this.view.MessageBox.mBox_decomposition_tips.Label_confirm_tips:SetActive(true)
				break
			end
		end

		UIEventListener.Get(this.view.MessageBox.mBox_decomposition_tips.Button_back).onClick = function()
			this.view.MessageBox.mBox_decomposition_tips.panel:SetActive(false)
		end
		UIEventListener.Get(this.view.MessageBox.mBox_decomposition_tips.Button_confirm).onClick = function()
			-- DONE: 提示框：完美分解按钮实现
			OnConfirmDecomposition(1,_Cost)
		end
		-- DONE: 提示框：分解提示内容显示
	end
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Button_decomposition_perfect).onClick = function()
		OnPerfectClick()
	end
	-- 普通分解按钮，弹出详细提示框
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Button_decomposition_normal).onClick = function()

		if #this.scrollViewController._selectedItems == 0 then
			UIToast.Show("还没有选中任何要分解的装备",nil,UIToast.ShowType.Upwards)
			return
		end
		
		this.view.MessageBox.mBox_decomposition_detail_tips.panel:SetActive(true)

		local _Power = this.scrollViewController:calcTotalEquipmentDecomposeReturn()
		local _Cost = this:calcDecomposePrice(_Power)
		local normalDec = _Power * 0.75
		local perfectDec = _Power
		
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_tips:GetComponent("UILabel").text = 
			sdata_UILiteral.mData.body[0xFE21][sdata_UILiteral.mFieldName2Index["Literal"]]
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_tips_2:GetComponent("UILabel").text = 
			sdata_UILiteral.mData.body[0xFE22][sdata_UILiteral.mFieldName2Index["Literal"]]
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_energy_normal:GetComponent("UILabel").text = '('..normalDec
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_energy_perfect:GetComponent("UILabel").text = '('..perfectDec
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_cost_perfect:GetComponent("UILabel").text = _Cost
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_cost_normal:GetComponent("UILabel").text = _Cost * cint.ExchangeRate

		-- 分解装备中包含高品质装备时显示提示
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_confirm_tips:GetComponent("UILabel").text = 
			sdata_UILiteral.mData.body[0xFE24][sdata_UILiteral.mFieldName2Index["Literal"]]
		this.view.MessageBox.mBox_decomposition_detail_tips.Label_confirm_tips:SetActive(false)
		for i = 1,#this.scrollViewController._selectedItems do
			if this.scrollViewController._selectedItems[i].rarity == 5 or this.scrollViewController._selectedItems[i].rarity == 6 then
				this.view.MessageBox.mBox_decomposition_detail_tips.Label_confirm_tips:SetActive(true)
				break
			end
		end

		UIEventListener.Get(this.view.MessageBox.mBox_decomposition_detail_tips.Button_back).onClick = function()
			this.view.MessageBox.mBox_decomposition_detail_tips.panel:SetActive(false)
		end
		UIEventListener.Get(this.view.MessageBox.mBox_decomposition_detail_tips.Button_confirm).onClick = function()
			-- DONE: 详细提示框：普通分解按钮实现
			OnConfirmDecomposition(0,_Cost * cint.ExchangeRate)
		end
		UIEventListener.Get(this.view.MessageBox.mBox_decomposition_detail_tips.Button_perfect).onClick = function()
			-- DONE: 详细提示框：完美分解按钮实现
			this.view.MessageBox.mBox_decomposition_detail_tips.panel:SetActive(false)
			OnPerfectClick()
		end
		-- DONE: 详细提示框：分解提示内容显示

	end
end

function wnd_cangku_controller:initTabButton()

	local Tabs = this.model.local_Tabs

	local _spacing = this.view.pButton_yeka.transform:GetComponent(typeof(UIWidget)).localSize.y

	local yeka

	for i = 1,this.model.DepositoryTab_Count do
		if i ~= 1 then
			yeka = GameObject.Instantiate(this.view.pButton_yeka)
			yeka.name = Tabs[i]["Goods"]..'_'..Tabs[i]["Maintype"]
			yeka.transform:SetParent(this.view.pButton_yeka.transform.parent)
			yeka.transform.localScale = Vector3.one
			yeka.transform.localPosition = Vector3(this.view.pButton_yeka.transform.localPosition.x,this.view.pButton_yeka.transform.localPosition.y - (i-1) * _spacing,this.view.pButton_yeka.transform.localPosition.z)
			yeka:GetComponentInChildren(typeof(UILabel)).text = Tabs[i]["Text"]
			
			table.insert(this.view.Panel_Tab.TabButtons,yeka)
		else 
			this.view.pButton_yeka.name = Tabs[1]["Goods"]..'_'..Tabs[1]["Maintype"]
			this.view.pButton_yeka:GetComponentInChildren(typeof(UILabel)).text = Tabs[1]["Text"]

			table.insert(this.view.Panel_Tab.TabButtons,this.view.pButton_yeka)		
		end
		
	end
	-- 默认选中第一个按钮
	-- this:SelectYekaButton(this.view.Panel_Tab.TabButtons[1])

end
----------------------------------------------------------------
--★Control YekaButton
function wnd_cangku_controller:SelectYekaButton(selectedButton)

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
	local Goods = string.sub(selectedButton.name,1,start-1)
	local Maintype = string.sub(selectedButton.name,e+1,string.len(selectedButton.name))
	-- 如果在装备分解界面点击页卡，则退出装备分解状态
	if this.scrollViewController._State_InDECOMPOSITION then
		this:hide(this.view.Panel_Detail_decomposition)
	end

	this.scrollViewController:filterBy(Goods,Maintype)

	this._selectedYekaButton = selectedButton
end
----------------------------------------------------------------
--★Control Panel show&hide
function wnd_cangku_controller:show(ui_cangku_panel)
	if this._currentPanel_right ~= nil and this._currentPanel_right ~= ui_cangku_panel then
		this:hide(this._currentPanel_right)
	end

	if ui_cangku_panel.panel ~= nil then
		ui_cangku_panel.panel:SetActive(true)
		this._currentPanel_right = ui_cangku_panel
	end	
end

function wnd_cangku_controller:hide(ui_cangku_panel)
	if ui_cangku_panel.panel ~= nil then
		ui_cangku_panel.panel:SetActive(false)

		if ui_cangku_panel == this.view.Panel_Detail_decomposition then
			this.scrollViewController._State_InDECOMPOSITION = false -- 隐藏装备分解界面时改变标记
			this.model.decomposition_Equipment = {} -- 清空临时数据
			this:SaveDecompositionPanelState()
		end
	end
end

function wnd_cangku_controller:showPanelByItemData(ItemData)
	local _UseType = ItemData["UseType"]
	local _Name = ItemData["Name"]
	local _Des = ((ItemData["Des"] == '-1') and {nil} or {ItemData["Des"]})[1] 
	local _FunctionDes = ItemData["FunctionDes"]
	local _Icon = ItemData["Icon"]
	local _Quality = ItemData["Quality"]
	local _SaleGold = ItemData["SaleGold"]

	if _UseType == 1 or _UseType == 2 then -- 显示碎片详细面板
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_path:SetActive(true)
		this.view.Panel_Detail_item.Button_use:SetActive(false)
		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Label_Container:SetActive(false)
		-- 如果是时装碎片，则根据性别显示
		if _UseType == 2 then
			local Male,Female = this:analysisFashionFragmentStr(_Name)
			_Name = (userModel:getUserRoleTbl().sex == 0 and {Male} or {Female})[1]
		end

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]]..ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = _Icon
		this.view.Panel_Detail_item.Item_frame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_Quality)
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes
		-- 如果碎片达到可合成数量，则显示合成
		local str1 = sdata_UILiteral.mData.body[0xFF02][sdata_UILiteral.mFieldName2Index["Literal"]]
		local str2 = sdata_UILiteral.mData.body[0xFF03][sdata_UILiteral.mFieldName2Index["Literal"]]
		if ItemData["ComposeNum"] == -1 then
			this.view.Panel_Detail_item.Button_path:GetComponentInChildren(typeof(UILabel)).text = str1
		else
			this.view.Panel_Detail_item.Button_path:GetComponentInChildren(typeof(UILabel)).text = (ItemData.num >= ItemData["ComposeNum"] and {str2} or {str1})[1]
		end
	
		UIEventListener.Get(this.view.Panel_Detail_item.Button_path).onClick = function()
				-- TODO: 碎片详细面板:添加途径/合成按钮的实现
				if ItemData.num >= ItemData["ComposeNum"] then
					local on_10024_rec = function(body)
						local gw2c = gw2c_pb.ComposeEquip()
					    gw2c:ParseFromString(body)
					    local equip = gw2c.equip
					    local items = gw2c.item
					    for k,v in ipairs(items) do
					    	this:updateServData(nil,nil,v)
					    	UIToast.Show("碎片剩余："..v.num,nil,UIToast.ShowType.Upwards)
					    end
					    this:insertServData(equip)
					    Event.RemoveListener("10024",on_10024_rec)	
					end
					Message_Manager:SendPB_10024(ItemData["ItemID"],on_10024_rec)
				end
			end
	end
	if _UseType == 3 then -- 显示消耗品详细面板
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(true)
		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Label_Container:SetActive(false)
				
		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]]..ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = _Icon -- DONE: 消耗品详细面板：显示消耗品的图标
		this.view.Panel_Detail_item.Item_frame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_Quality)
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes
		
		UIEventListener.Get(this.view.Panel_Detail_item.Button_use).onClick = function()
				-- TODO: 消耗品详细面板：添加使用按钮的实现
				print("使用按钮")
			end	
	end
	if _UseType == 4 then -- 显示随机宝箱
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(true)
		this.view.Panel_Detail_item.Label_Container:SetActive(false)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]]..ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = _Icon -- DONE: 随机宝箱：显示随机宝箱的图标
		this.view.Panel_Detail_item.Item_frame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_Quality)
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes

		UIEventListener.Get(this.view.Panel_Detail_item.Button_use).onClick = function()
				-- TODO: 随机宝箱：添加使用按钮的实现
				print("使用按钮")
			end
	end
	if _UseType == 5 then -- 显示手选宝箱
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(true)
		this.view.Panel_Detail_item.Label_Container:SetActive(false)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]]..ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = _Icon -- DONE: 随机宝箱：显示随机宝箱的图标
		this.view.Panel_Detail_item.Item_frame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_Quality)
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes

		UIEventListener.Get(this.view.Panel_Detail_item.Button_use).onClick = function()
				this:show(this.view.MessageBox.mBox_chestBox)
		
				-- DONE: 手选宝箱：添加宝箱图标
				this.view.MessageBox.mBox_chestBox.Items.item_1:GetComponent(typeof(UISprite)).spriteName = _Icon
				this.view.MessageBox.mBox_chestBox.Items.item_2:GetComponent(typeof(UISprite)).spriteName = _Icon
				this.view.MessageBox.mBox_chestBox.Items.item_3:GetComponent(typeof(UISprite)).spriteName = _Icon
				this.view.MessageBox.mBox_chestBox.Items.item_4:GetComponent(typeof(UISprite)).spriteName = _Icon
				this.view.MessageBox.mBox_chestBox.Items.item_5:GetComponent(typeof(UISprite)).spriteName = _Icon

				UIEventListener.Get(this.view.MessageBox.mBox_chestBox.Button_back).onClick = function()
						this:hide(this.view.MessageBox.mBox_chestBox)
					end
				UIEventListener.Get(this.view.MessageBox.mBox_chestBox.Button_confirm).onClick = function()
						-- TODO: 手选宝箱：添加确认按钮的实现
						print("确认选择按钮")
					end
				-- TODO: 手选宝箱：添加宝箱按钮实现
			end
	end
	if _UseType == 6 or _UseType == 7 then -- DONE: 显示升阶材料面板
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(false)
		this.view.Panel_Detail_item.Label_Container:SetActive(false)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]]..ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = _Icon -- DONE: 升阶材料界面：显示升阶材料的图标
		this.view.Panel_Detail_item.Item_frame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_Quality)
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes
	end
	if _UseType == 8 then 
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(true)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(false)
		this.view.Panel_Detail_item.Label_Container:SetActive(true)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]]..ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = _Icon -- DONE: 收藏品界面：显示收藏品图标
		this.view.Panel_Detail_item.Item_frame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_Quality)
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes
		this.view.Panel_Detail_item.Label_sellCoins:GetComponent(typeof(UILabel)).text = _SaleGold

		UIEventListener.Get(this.view.Panel_Detail_item.Button_sale).onClick = function()
				-- FIXME: 收藏品界面：添加出售按钮的实现
				local Items = {{id = ItemData.id,num = ItemData.num}}
				Message_Manager:SendPB_10022(Items)
				local on_10022_rec = function(body)
					local gw2c = gw2c_pb.SellItem()
				    gw2c:ParseFromString(body)
				    local items = gw2c.item

				    for k,v in ipairs(items) do
				    	print("出售："..v.id..v.num)
				    end

					Event.RemoveListener("10022",on_10022_rec)
				end
				Event.AddListener("10022",on_10022_rec)
			end
	end
	-- 数量工具条
	if ItemData["OverlapUse"] == 1 or ItemData["SaleGold"] ~= -1 then
		this.view.Panel_Detail_item.Sprite_Container:SetActive(true)
		this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text = "1/"..ItemData.num

		UIEventListener.Get(this.view.Panel_Detail_item.Button_jian).onClick = function()
			local str = this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text
			local pos = string.find(str,'/')
			local count = tonumber(string.sub(str,1,pos-1))
			if count - 1 > 0 then
				this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text = (count-1)..'/'..ItemData.num
			end
		end
		UIEventListener.Get(this.view.Panel_Detail_item.Button_jia).onClick = function()
			local str = this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text
			local pos = string.find(str,'/')
			local count = tonumber(string.sub(str,1,pos-1))
			if count + 1 <= ItemData.num then
				this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text = (count+1)..'/'..ItemData.num
			end
		end
		UIEventListener.Get(this.view.Panel_Detail_item.Button_max).onClick = function()
			local str = this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text
			this.view.Panel_Detail_item.Label_count:GetComponent(typeof(UILabel)).text = ItemData.num..'/'..ItemData.num
		end
	else
		this.view.Panel_Detail_item.Sprite_Container:SetActive(false)
	end		
end

function wnd_cangku_controller:showEquipmentDetailsPanel(equip,cangkuItem)
	this:show(this.view.Panel_Detail_equipment)

	local mDepth = GameObject.Find("ui_cangku"):GetComponent("UIPanel").depth

	equipDetail:showEquip(equip,this.view.Panel_Detail_equipment.panel,mDepth + 1)
	---------------------------------------------------------------
	UIEventListener.Get(this.view.Panel_Detail_equipment.Button_decomposition).onClick = function()
		-- DONE: 装备界面：装备分解按钮
			before_panel = this._currentPanel_right
			
			this:show(this.view.Panel_Detail_decomposition)
			
			this:LoadDecompositionPanelState()

		end
	UIEventListener.Get(this.view.Panel_Detail_equipment.Button_share).onClick = function (go)
			-- TODO: 装备界面：分享按钮
		end
	UIEventListener.Get(this.view.Panel_Detail_equipment.Button_commander).onClick = function (go)
			-- TODO: 装备界面：指挥官按钮
		end	
	UIEventListener.Get(this.view.Panel_Detail_equipment.Button_lock).onClick = function (go)
			-- DONE: 装备界面：锁定按钮
			if equip.isLock == 0 then
				Lock = 1
				this.view.Panel_Detail_equipment.Button_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_UNLOCKED
			else 
				Lock = 0
				this.view.Panel_Detail_equipment.Button_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_LOCKED
			end
			local on_10005_rec = function(body)
				local gw2c = gw2c_pb.EquipLock()
			    gw2c:ParseFromString(body)
			    local serv_equip = gw2c.equip
			    if serv_equip.isLock == 0 then
			    	UIToast.Show("装备已解锁",nil,UIToast.ShowType.Upwards)
			    	cangkuItem:setEquipmentLock(false)
			    	this.view.Panel_Detail_equipment.Button_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_UNLOCKED
			    else
			    	UIToast.Show("装备已锁定",nil,UIToast.ShowType.Upwards)
			    	cangkuItem:setEquipmentLock(true)
			    	this.view.Panel_Detail_equipment.Button_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_LOCKED
			    end
			    -- 服务器返回数据后修改表内容
			    equip.isLock = serv_equip.isLock
			    -- 响应事件后移除Listener
			    Event.RemoveListener("10005", on_10005_rec)
			end
			Message_Manager:SendPB_10005(equip.id,Lock,on_10005_rec)
		end	
	UIEventListener.Get(this.view.Panel_Detail_equipment.Button_unload).onClick = function (go)
			if equip.equipped then
				-- DONE: 装备界面：卸下按钮
				for i = #this.model.serv_fitEquipmentList,1,-1 do
					if this.model.serv_fitEquipmentList[i] == equip.id then
						table.remove(this.model.serv_fitEquipmentList,i)
					end
				end
			else
				-- DONE: 装备界面：穿戴按钮
				local _repeat,_repeatIndex = EquipUtil:whetherRepeatEquipped(equip)
				-- 如果存在重复部件，则使用带装备物品替换已装备物品
				if _repeat then
					this:unloadEquipmentByID(this.model.serv_fitEquipmentList[_repeatIndex])
					table.remove(this.model.serv_fitEquipmentList,_repeatIndex)
					UIToast.Show("存在相同部位装备,将卸下之前装备",nil,UIToast.ShowType.Upwards)
				end
				table.insert(this.model.serv_fitEquipmentList,equip.id)
			end
			local on_10021_rec = function(body)
				local gw2c = gw2c_pb.EquipFit()
			    gw2c:ParseFromString(body)
			    Event.RemoveListener("10021",on_10021_rec)
			    -- FIXME: 未验证服务器返回数据
			    -- print(gw2c.lst)
			    -- for k,v in pairs(gw2c) do
			    -- 	print(k..type(v))
			    -- end
			    print("接收已穿戴数据")
			    local _str1 = sdata_UILiteral.mData.body[0xFE11][sdata_UILiteral.mFieldName2Index["Literal"]]
				local _str2 = sdata_UILiteral.mData.body[0xFE12][sdata_UILiteral.mFieldName2Index["Literal"]]
			    equip.equipped = not equip.equipped
			    -- 完成操作后刷新界面显示
			    cangkuItem:setEquipped(equip.equipped)
			    this:showEquipmentDetailsPanel(equip,cangkuItem)
				-- this.view.Panel_Detail_equipment.Button_unload:GetComponentInChildren(typeof(UILabel)).text = (equip.equipped and {_str2} or {_str1})[1]
			end
			Message_Manager:SendPB_10021(this.model.serv_fitEquipmentList,on_10021_rec)
		end	
	UIEventListener.Get(this.view.Panel_Detail_equipment.Button_plus).onClick = function (go)
			-- TODO: 装备界面：当装备损坏时的处理
			if equip.isBad == 1 then
				local on_10006_rec = function(body)
					local gw2c = gw2c_pb.EquipRepair()
					gw2c:ParseFromString(body)
					this:updateServData(gw2c.currency,gw2c.equip)
					equipDetail:showEquip(equip,this.view.Panel_Detail_equipment.panel,mDepth + 1)
				end
				Message_Manager:SendPB_10006(equip.id,on_10006_rec)
				return
			end
			-- DONE: 装备界面：强化按钮
			if equip.lv + 1 <= EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) then

				if this.model.serv_CurrencyInfo.power < equipDetail._EquipPlusCost then
					UIToast.Show("能量点不足",nil,UIToast.ShowType.Upwards)
					return
				end
				local on_10004_rec = function(body)
					local gw2c = gw2c_pb.EquipLvlup()
					gw2c:ParseFromString(body)
					local serv_equip = gw2c.equip
					local serv_currency = gw2c.currency

					Event.RemoveListener("10004", on_10004_rec)
					-- 强化后刷新界面
					this:updateServData(gw2c.currency,gw2c.equip)
					cangkuItem:setEquipmentLevel(gw2c.equip.lv)
					this:showEquipmentDetailsPanel(equip,cangkuItem)
					UIToast.Show("已强化到+"..serv_equip.lv,nil,UIToast.ShowType.Upwards)
				end
				Message_Manager:SendPB_10004(equip.id,on_10004_rec)
			else
				if equip.rarity == 4 or equip.rarity == 5 or equip.rarity == 6 then 
					-- TODO:装备重铸

				else
					UIToast.Show("该装备无法重铸",nil,UIToast.ShowType.Upwards)
				end
			end
		end
end

function wnd_cangku_controller:showTipsBox(messageToShow)
	this.view.MessageBox.mBox.panel:SetActive(true)
	this.view.MessageBox.mBox.Label:GetComponent(typeof(UILabel)).text = messageToShow
	local sq = DG.Tweening.DOTween.Sequence()
	local tweener = this.view.MessageBox.mBox.panel.transform:DOPunchScale(Vector3(0.5, 0.5, 0), 0.5, 1, 1)
	sq:Append(this.view.MessageBox.mBox.panel.transform:DOScale(1,0))
	sq:Append(tweener)
	UIEventListener.Get(this.view.MessageBox.mBox.Button_back).onClick = function()
		local sq = DG.Tweening.DOTween.Sequence()
		local tweener = this.view.MessageBox.mBox.panel.transform:DOScale(0,0.5)
		-- local tweener = this.view.MessageBox.mBox.panel.transform:DOFade(0,0.5)
		tweener:OnComplete(function() this:hide(this.view.MessageBox.mBox) end)
		sq:Append(tweener)
	end
end

----------------------------------------------------------------
--★Process Server Data
--@params user_equip:服务器装备列表,user_item:服务器物品列表,user_fitEquip:服务器已穿戴装备列表
function wnd_cangku_controller:processServData(user_item)
	if not this.model then
		this.model = require("uiscripts/cangku/wnd_cangku_model")
	end
	for k, v in ipairs(user_item) do
    	local item = {}
		item = this.model:getLocalItemDetailByItemID(v.id)

		if item ~= nil then
			local _OverlapLimit = item["OverlapLimit"]
			if _OverlapLimit ~= 1 and _OverlapLimit ~= nil then
				if v.num <= _OverlapLimit then -- 堆叠数量处理
					-- print("物品数量："..v.num.."  堆叠限制：".._OverlapLimit)
					item.id = v.id
					item.num = v.num
					table.insert(this.model.serv_Items,item)
				else 
					-- print("物品数量超出限制："..v.num.."  堆叠限制：".._OverlapLimit)
					for i = 1,math.ceil(v.num / _OverlapLimit) do
						item.id = v.id
						if i ~= math.ceil(v.num / _OverlapLimit) then
							item = table.deepcopy(item)
							item.num = _OverlapLimit
							table.insert(this.model.serv_Items,item)
						else
							item = table.deepcopy(item)
							-- TODO: 未详细测试计算结果，数量可能与预期不同
							item.num = v.num - _OverlapLimit * (math.ceil(v.num / _OverlapLimit) - 1)
							table.insert(this.model.serv_Items,item)
						end
					end
				end
			end
		end
		item = {}
    end
    print("Items："..#this.model.serv_Items)
end

function wnd_cangku_controller:sortServData()
	--非装备道具：合成 => 功能类型<UseType>  => 品质<Quality> => ID => 专有ID（仅对不可叠加的物品有效）
	table.sort(this.model.serv_Items,
		function(a,b)
			if a["ItemID"] ~= nil and b["ItemID"] ~= nil then
				if a.num >= a["ComposeNum"] and b.num < b["ComposeNum"] then -- 可以合成的在前
					return true
				elseif a.num < a["ComposeNum"] and b.num >= b["ComposeNum"] then
					return false
				elseif a["UseType"] ~= b["UseType"] then
					return a["UseType"] < b["UseType"] -- UseType小的在前
				elseif a["Quality"] ~= b["Quality"] then
					return a["Quality"] > b["Quality"] -- Quality大的在前
				elseif a["ItemID"] ~= b["ItemID"] then
					return a["ItemID"] < b["ItemID"] -- ItemID小的在前
				else
					return a.num > b.num -- 另外一种情况，物品堆叠数量超出时，数量多的在前
				end 
			end
			return false
		end)
	print("serv_Items排序完成..")
	table.sort(this.model.serv_Equipment,
		function(a,b)
			if a.isBad ~= b.isBad then
				return (a.isBad == 1 and {true} or {false})[1] -- 损坏度,坏的在前
			elseif a.rarity ~= b.rarity then
				return a.rarity > b.rarity -- 装备品质高的在前
			elseif a.lv ~= b.lv then
				return a.lv > b.lv -- lv大的在前
			else
				return a.id < b.id -- id小的在前
			end
		end)
	print("serv_Equipment排序完成..")
end

function wnd_cangku_controller:mergeServData()
	-- 先插入装备，后插入道具
	for i = 1,#this.model.serv_Equipment do
		table.insert(this.model.Processed_Items,this.model.serv_Equipment[i])
	end
	for i = 1,#this.model.serv_Items do
		table.insert(this.model.Processed_Items,this.model.serv_Items[i])
	end
end
--@params user_currency:服务器货币信息,user_equip:服务器装备数据
function wnd_cangku_controller:updateServData(user_currency,user_equip,user_items)
	if user_currency then
		this.model.serv_CurrencyInfo = user_currency
	end
	if user_equip then
		-- 根据装备唯一id查找本地待更新数据
		for i = 1,#this.model.serv_Equipment do
			if this.model.serv_Equipment[i].id == user_equip.id then
				local equip = this.model.serv_Equipment[i]
				equip.eid = user_equip.eid
				equip.lv = user_equip.lv
				equip.rarity = user_equip.rarity
				equip.fst_attr = user_equip.fst_attr
				equip.sndAttr = { remake = {} }
				equip.isLock = user_equip.isLock
				equip.isBad = user_equip.isBad
				for k, v in ipairs(user_equip.sndAttr) do
		           	table.insert(equip.sndAttr,
		           	{
		           		id = v.id,
						val = v.val,
						isRemake = v.isRemake,
			        })
		            for kk, vv in ipairs(v.remake) do
		                table.insert(equip.sndAttr.remake,
		                {
							id = vv.id,
							val = vv.val,
		                })
		            end
		        end
		        return
			end
		end
	end
	if user_items then
		if user_items.num == 0 then
			this:removeItemByItemID(user_items.id)
		else
			this:updateItemData(user_items.id,user_items.num)
		end
	end
end

function wnd_cangku_controller:insertServData(user_equip)
	if user_equip then
		local equip = this.model:getLocalEquipmentDetailByEquipID(user_equip.eid)
		equip.id = user_equip.id
		equip.eid = user_equip.eid
		equip.lv = user_equip.lv
		equip.rarity = user_equip.rarity
		equip.fst_attr = user_equip.fst_attr
		equip.sndAttr = { remake = {} }
		equip.isLock = user_equip.isLock
		equip.isBad = user_equip.isBad
		for k, v in ipairs(user_equip.sndAttr) do
           	table.insert(equip.sndAttr,
           	{
           		id = v.id,
				val = v.val,
				isRemake = v.isRemake,
	        })
            for kk, vv in ipairs(v.remake) do
                table.insert(equip.sndAttr.remake,
                {
					id = vv.id,
					val = vv.val,
                })
            end
        end
        table.insert(this.model.serv_Equipment,equip) 
        this.scrollViewController:sortEquipment(this.model.serv_Equipment)
	end
	
	this.model.Processed_Items = {}
	this:mergeServData()
end
----------------------------------------------------------------
--★Util

function wnd_cangku_controller:prepareDecompositionPanel() -- 准备装备分解界面
	local mAtlas = this.view.Button_back:GetComponent("UISprite").atlas

	this.view.Panel_Detail_decomposition.Checkbox.Button_white.transform:
	GetChild(0):GetComponent(typeof(UISprite)).atlas = mAtlas
	this.view.Panel_Detail_decomposition.Checkbox.Button_green.transform:
	GetChild(0):GetComponent(typeof(UISprite)).atlas = mAtlas
	this.view.Panel_Detail_decomposition.Checkbox.Button_blue.transform:
	GetChild(0):GetComponent(typeof(UISprite)).atlas = mAtlas
	this.view.Panel_Detail_decomposition.Checkbox.Button_purple.transform:
	GetChild(0):GetComponent(typeof(UISprite)).atlas = mAtlas
	this.view.Panel_Detail_decomposition.Checkbox.Button_golden.transform:
	GetChild(0):GetComponent(typeof(UISprite)).atlas = mAtlas
	this.view.Panel_Detail_decomposition.Checkbox.Button_red.transform:
	GetChild(0):GetComponent(typeof(UISprite)).atlas = mAtlas

	this.view.Panel_Detail_decomposition.Checkbox.Button_white.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = cstr.SELECTED_CB
	this.view.Panel_Detail_decomposition.Checkbox.Button_green.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = cstr.SELECTED_CB
	this.view.Panel_Detail_decomposition.Checkbox.Button_blue.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = cstr.SELECTED_CB
	this.view.Panel_Detail_decomposition.Checkbox.Button_purple.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = nil
	this.view.Panel_Detail_decomposition.Checkbox.Button_golden.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = nil
	this.view.Panel_Detail_decomposition.Checkbox.Button_red.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = nil
end

function wnd_cangku_controller:updateDecompositionPanel()
	local _Power = this.scrollViewController:calcTotalEquipmentDecomposeReturn()

	local str = sdata_UILiteral.mData.body[0xFE20][sdata_UILiteral.mFieldName2Index["Literal"]]

	this.view.Panel_Detail_decomposition.Label_decomposition_tips:GetComponent("UILabel").text = 
		string.format(str,#this.scrollViewController._selectedItems) 
	this.view.Panel_Detail_decomposition.Label_res:GetComponent("UILabel").text = _Power
	this.view.Panel_Detail_decomposition.Label_decomposition_perfect_cost:GetComponent("UILabel").text = this:calcDecomposePrice(_Power)
	this.view.Panel_Detail_decomposition.Label_decomposition_normal_cost:GetComponent("UILabel").text = this:calcDecomposePrice(_Power) * cint.ExchangeRate
end
-- 保存装备分解界面状态
function wnd_cangku_controller:SaveDecompositionPanelState()
	if this._DecompositionPanelState == nil then
		this._DecompositionPanelState = {}
		for i = 1,6 do
			table.insert(this._DecompositionPanelState,false)
		end
	end
	if this.view.Panel_Detail_decomposition.Checkbox.Button_white.
		transform:GetChild(0):GetComponent(typeof(UISprite)).spriteName == cstr.SELECTED_CB then
		this._DecompositionPanelState[1] = true
	else this._DecompositionPanelState[1] = false end
	if this.view.Panel_Detail_decomposition.Checkbox.Button_green.
		transform:GetChild(0):GetComponent(typeof(UISprite)).spriteName == cstr.SELECTED_CB then
		this._DecompositionPanelState[2] = true
	else this._DecompositionPanelState[2] = false end
	if this.view.Panel_Detail_decomposition.Checkbox.Button_blue.
		transform:GetChild(0):GetComponent(typeof(UISprite)).spriteName == cstr.SELECTED_CB then
		this._DecompositionPanelState[3] = true
	else this._DecompositionPanelState[3] = false end
	if this.view.Panel_Detail_decomposition.Checkbox.Button_purple.
		transform:GetChild(0):GetComponent(typeof(UISprite)).spriteName == cstr.SELECTED_CB then
		this._DecompositionPanelState[4] = true
	else this._DecompositionPanelState[4] = false end
	if this.view.Panel_Detail_decomposition.Checkbox.Button_golden.
		transform:GetChild(0):GetComponent(typeof(UISprite)).spriteName == cstr.SELECTED_CB then
		this._DecompositionPanelState[5] = true
	else this._DecompositionPanelState[5] = false end
	if this.view.Panel_Detail_decomposition.Checkbox.Button_red.
		transform:GetChild(0):GetComponent(typeof(UISprite)).spriteName == cstr.SELECTED_CB then
		this._DecompositionPanelState[6] = true
	else this._DecompositionPanelState[6] = false end
end
-- 加载上次装备分解界面状态
function wnd_cangku_controller:LoadDecompositionPanelState()
	this.scrollViewController._State_InDECOMPOSITION = true -- 改变标记
	if this._DecompositionPanelState == nil then
		this:prepareDecompositionPanel()
		this:updateDecompositionPanel()
		this.scrollViewController:filterBy('Equip','Decomposition')
		this.scrollViewController:addEquipmentShowByQuality(1)
		this.scrollViewController:addEquipmentShowByQuality(2)
		this.scrollViewController:addEquipmentShowByQuality(3)
	else
		this.scrollViewController:filterBy('Equip','Decomposition')
		for i = 1,#this._DecompositionPanelState do
			if this._DecompositionPanelState[i] then
				this.scrollViewController:addEquipmentShowByQuality(i)
			end
		end
	end
end
--@Des 更新Model中指定itemID的物品数据
function wnd_cangku_controller:updateItemData(itemID,num)
	for k,v in ipairs(this.model.serv_Items) do
		if v.id == itemID then
			v.num = num
			break
		end
	end
	this.scrollViewController:refreshList()
end
--@Des 从Model删除指定itemID的物品
function wnd_cangku_controller:removeItemByItemID(itemID)
	for k,v in ipairs(this.model.serv_Items) do
		if v.id == itemID then
			table.remove(this.model.serv_Items,k)
			break
		end
	end
	for k,v in ipairs(this.model.Processed_Items) do
		if v.id == itemID then
			table.remove(this.model.Processed_Items,k)
			break
		end 
	end
	local _UseType = this.model:getUseTypeByItemID(itemID)
	if _UseType == 1 or _UseType == 2 then
		this.scrollViewController.Items_filterByUseType_1_2 = nil
		this.scrollViewController:filterBy('Item','1')
	elseif _UseType == 3 or _UseType == 4 or _UseType == 5 then
		this.scrollViewController.Items_filterByUseType_3_4_5 = nil
		this.scrollViewController:filterBy('Item','3')
	elseif _UseType == 6 or _UseType == 7 then
		this.scrollViewController.Items_filterByUseType_6_7 = nil
		this.scrollViewController:filterBy('Item','2')
	else
		this.scrollViewController.Items_filterByUseType_8 = nil
		this.scrollViewController:filterBy('Item','4')
	end
end
--@params power:能量点
--@return (int,int)Interval
function wnd_cangku_controller:calcInterval(power)
	if power > cint.PowerInterval[#cint.PowerInterval] or power < cint.PowerInterval[1] then
		Debugger.LogWarning("power out of bounds.")
		return
	end
	for i = 1,#cint.PowerInterval do
		if power >= cint.PowerInterval[i] and power <= cint.PowerInterval[i+1] then
			return i,i+1
		end
	end
end
--@params power:能量点
--@return (int)Diamond
function wnd_cangku_controller:calcDecomposePrice(power)
	local j,i = this:calcInterval(power)
	local Diamond = (power - cint.PowerInterval[i-1])/
		(cint.PowerInterval[i] - cint.PowerInterval[i-1])*
		(cint.DiamondInterval[i] - cint.DiamondInterval[i-1]) + cint.DiamondInterval[i-1]
	Diamond = math.ceil(Diamond * 0.2) * 5
	return Diamond
end
--@Des 卸下指定id的装备
--@params equip:本地装备数据
function wnd_cangku_controller:unloadEquipmentByID(id)
	for i = 1,#this.scrollViewController.currentItems do
		if this.scrollViewController.currentItems[i].id == id then
			print("卸下 "..this.scrollViewController.currentItems[i]["EquipName"])
			this.scrollViewController.currentItems[i].equipped = false
		end
	end
	-- 刷新列表显示
	this.scrollViewController:refreshList()
end
--@Des 卸下指定id的装备
--@params equipList:装备唯一id列表
function wnd_cangku_controller:removeEquipmentByIDList(equipList)
	for i = 1,#equipList do
		table.remove(this.model.serv_Equipment,this.model:getIndexByID(equipList[i]))
	end
	this.model.Processed_Items = {}
	this:mergeServData()
	this.scrollViewController:refreshList()
end
--@Des 解析时装碎片字符串
--@params str:时装碎片字符串
function wnd_cangku_controller:analysisFashionFragmentStr(str)
	local Male = string.sub(str,0,string.find(str,';')-1)
	local Female = string.sub(str,string.find(str,';')+1,-1)

	Male = string.gsub(Male,"Male%$",'')
	Female = string.gsub(Female,"Female%$",'')

	return Male,Female
end
return wnd_cangku_controller