require('uiscripts/cangku/wnd_cangku_utils')
wnd_cangku_controller = {

	view,
	model,
	scrollViewController,

	-- variable
	_selectedYekaButton,--记录已选择的页卡按钮
	_currentPanel_right,--记录当前显示在右边的panel

	-- function
	initTabButton,--初始化页卡按钮
	initListener,--添加按钮事件

	SelectYekaButton,--切换页卡

	show,--显示，隐藏panel
	hide,
	showPanelByItemData,--通过Item数据决定显示何面板
	showEquipmentDetailsPanel,--显示装备详细面板

	reqData, --向服务器请求数据
	recData, -- 接收数据存到Model中

	processServData, -- 处理服务器数据
	sortServData, -- 对服务器数据列表排序
	mergeServData, -- 合并 装备/道具数据
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
	this.scrollViewController = require("uiscripts/cangku/wnd_cangku_ScrollView_controller")

	this.view:initView(self)
	this.model:initModel()
	this.scrollViewController:init(self)

	this:initTabButton()

	this.view:initCollider()
	this:initListener()

	this.view.Button_decomposition:SetActive(false)
	this:hide(this.view.Panel_Detail_decomposition)
	this:hide(this.view.Panel_Detail_item)
	this:hide(this.view.Panel_Detail_equipment)
	this.view.MessageBox.mBox.panel:SetActive(false)
	this.view.MessageBox.mBox_decomposition_tips.panel:SetActive(false)
	this.view.MessageBox.mBox_decomposition_detail_tips.panel:SetActive(false)
	this.view.MessageBox.mBox_chestBox.panel:SetActive(false)
	this.view.MessageBox.panel:SetActive(true)
	-- local tween = this.view.MessageBox.mBox.panel.transform:DOPunchScale(Vector3(1.5, 1.5, 0), 1, 1, 1)
	
	test()

	print('load cangku Completed')

	-- test()

end
----------------------------------------------------------------
--★Init
function wnd_cangku_controller:initListener()

	UIEventListener.Get(this.view.Button_back).onClick = function()
			print('返回上一界面')
		end
	-- 页卡
	for i = 1,this.model.DepositoryTab_Count do
		UIEventListener.Get(this.view.Panel_Tab.TabButtons[i]).onClick = function (go)
			this:SelectYekaButton(go)
		end 
	end
	-- TODO 装备分解界面
	local before_panel
	UIEventListener.Get(this.view.Button_decomposition).onClick = function()
			before_panel = this._currentPanel_right
			this:show(this.view.Panel_Detail_decomposition)
			this.scrollViewController._State_InDECOMPOSITION = true -- 改变标记
			this:prepareDecompositionPanel()
			this.scrollViewController:filterBy('Equip','Decomposition')
			-- 默认选中品质1，2，3
			this.scrollViewController:selectEquipmentByQuality(1)
			this.scrollViewController:selectEquipmentByQuality(2)
			this.scrollViewController:selectEquipmentByQuality(3)
		end
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

			if checkbox.spriteName == this.scrollViewController.cstr_SELECTED_CB then -- 如果已选中
				checkbox.spriteName = 'nil'
				-- TODO 取消选中所有白色品质装备
				this.scrollViewController:disselectEquipmentByQuality(_Quality)
			else
				checkbox.spriteName = this.scrollViewController.cstr_SELECTED_CB
				-- TODO 选中所有白色品质装备
				this.scrollViewController:selectEquipmentByQuality(_Quality)
			end
		end
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_white).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_green).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_blue).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_purple).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_golden).onClick = Checkbox_OnCheck
	UIEventListener.Get(this.view.Panel_Detail_decomposition.Checkbox.Button_red).onClick = Checkbox_OnCheck
end

function wnd_cangku_controller:initTabButton()

	local Tabs = this.model.local_Tabs

	local _spacing = this.view.pButton_yeka.transform.localPosition.y - this.view.pSprite_yekafengexian.transform.localPosition.y

	local yeka,yekafengexian

	for i = 1,this.model.DepositoryTab_Count do
		if i ~= 1 then
			yeka = GameObject.Instantiate(this.view.pButton_yeka)
			yeka.name = Tabs[i]["Goods"]..'_'..Tabs[i]["Maintype"]
			yeka.transform:SetParent(this.view.pButton_yeka.transform.parent)
			yeka.transform.localScale = Vector3.one
			yeka.transform.localPosition = Vector3(this.view.pButton_yeka.transform.localPosition.x,this.view.pButton_yeka.transform.localPosition.y - 2 * (i-1) * _spacing,this.view.pButton_yeka.transform.localPosition.z)
			yeka:GetComponentInChildren(typeof(UILabel)).text = Tabs[i]["Goods"]..'_'..Tabs[i]["Maintype"]

			yekafengexian = GameObject.Instantiate(this.view.pSprite_yekafengexian)
			yekafengexian.transform:SetParent(this.view.pSprite_yekafengexian.transform.parent)
			yekafengexian.transform.localScale = Vector3.one
			yekafengexian.transform.localPosition = Vector3(this.view.pSprite_yekafengexian.transform.localPosition.x,this.view.pSprite_yekafengexian.transform.localPosition.y - 2 * (i-1) * _spacing,this.view.pSprite_yekafengexian.transform.localPosition.z)
			
			table.insert(this.view.Panel_Tab.TabButtons,yeka)
		else 
			this.view.pButton_yeka.name = Tabs[1]["Goods"]..'_'..Tabs[1]["Maintype"]
			this.view.pButton_yeka:GetComponentInChildren(typeof(UILabel)).text = Tabs[1]["Goods"]..'_'..Tabs[1]["Maintype"]

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
	selectedButton:GetComponent(typeof(UISprite)).spriteName = "tongyong_anniu_xuanzhong_rotate"

	local start, e = string.find(selectedButton.name, '_')
	local Goods = string.sub(selectedButton.name,1,start-1)
	local Maintype = string.sub(selectedButton.name,e+1,string.len(selectedButton.name))

	print("Goods = "..Goods)
	print("Maintype = "..Maintype)

	if Goods == 'Equip' then -- 显示装备分解按钮
		this.view.Button_decomposition:SetActive(true)
	else
		this.view.Button_decomposition:SetActive(false)
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
		end
	end
end

function wnd_cangku_controller:showPanelByItemData(ItemData)
	local _UseType = ItemData["UseType"]
	local _Name = ItemData["Name"]
	local _Des = ItemData["Des"]
	local _FunctionDes = ItemData["FunctionDes"]
	local _Icon = ItemData["Icon"]
	local _Quality = ItemData["Quality"]
	local _SaleGold = ItemData["SaleGold"]

	if _UseType == 1 or _UseType == 2 then -- 显示碎片详细面板
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_path:SetActive(true)
		this.view.Panel_Detail_item.Button_use:SetActive(false)
		this.view.Panel_Detail_item.Button_sale:SetActive(false)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = nil -- TODO 
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes

		UIEventListener.Get(this.view.Panel_Detail_item.Button_path).onClick = function()
				-- TODO 添加途径按钮的实现
			end
	end
	if _UseType == 3 then -- 显示消耗品详细面板
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(true)
		this.view.Panel_Detail_item.Button_sale:SetActive(false)
				
		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = nil -- TODO 
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes
		
		UIEventListener.Get(this.view.Panel_Detail_item.Button_use).onClick = function()
				-- TODO 添加使用按钮的实现
			end	
	end
	if _UseType == 4 then -- 显示随机宝箱
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(true)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = nil -- TODO 
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes

		UIEventListener.Get(this.view.Panel_Detail_item.Button_use).onClick = function()
				-- TODO 添加使用按钮的实现
			end
	end
	if _UseType == 5 then -- 显示手选宝箱
		if this._currentPanel_right ~= nil then
			this:hide(this._currentPanel_right)
		end
		this:show(this.view.MessageBox.mBox_chestBox)
		
		-- TODO 添加宝箱图标
		this.view.MessageBox.mBox_chestBox.Items.item_1:GetComponent(typeof(UISprite)).spriteName = nil
		this.view.MessageBox.mBox_chestBox.Items.item_2:GetComponent(typeof(UISprite)).spriteName = nil
		this.view.MessageBox.mBox_chestBox.Items.item_3:GetComponent(typeof(UISprite)).spriteName = nil
		this.view.MessageBox.mBox_chestBox.Items.item_4:GetComponent(typeof(UISprite)).spriteName = nil
		this.view.MessageBox.mBox_chestBox.Items.item_5:GetComponent(typeof(UISprite)).spriteName = nil

		UIEventListener.Get(this.view.MessageBox.mBox_chestBox.Button_back).onClick = function()
				this:hide(this.view.MessageBox.mBox_chestBox)
			end
		UIEventListener.Get(this.view.MessageBox.mBox_chestBox.Button_confirm).onClick = function()
				-- TODO 添加确认按钮的实现
			end
		-- TODO 添加宝箱按钮实现
	end
	if _UseType == 6 or _UseType == 7 then -- TODO 显示升阶材料面板
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(false)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(true)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = nil -- TODO 
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes
	end
	if _UseType == 8 then -- TODO 显示收藏品
		this:show(this.view.Panel_Detail_item)

		this.view.Panel_Detail_item.Button_sale:SetActive(true)
		this.view.Panel_Detail_item.Button_path:SetActive(false)
		this.view.Panel_Detail_item.Button_use:SetActive(false)

		this.view.Panel_Detail_item.Label_name:GetComponent(typeof(UILabel)).text = _Name
		this.view.Panel_Detail_item.Item_count:GetComponent(typeof(UILabel)).text = ItemData.num
		this.view.Panel_Detail_item.Item_icon:GetComponent(typeof(UISprite)).spriteName = nil -- TODO 
		this.view.Panel_Detail_item.Label_tips:GetComponent(typeof(UILabel)).text = _Des
		this.view.Panel_Detail_item.Label_description:GetComponent(typeof(UILabel)).text = _FunctionDes

		UIEventListener.Get(this.view.Panel_Detail_item.Button_sale).onClick = function()
				-- TODO 添加出售按钮的实现
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

function wnd_cangku_controller:showEquipmentDetailsPanel(equip)

	this:show(this.view.Panel_Detail_equipment)

	-- TODO 装备数据传递
	local _EquipName = equip["EquipName"]
	local _EquipIcon = equip["EquipIcon"]

	this.view.Panel_Detail_equipment.Label_name:GetComponent(typeof(UILabel)).text = _EquipName
	-- this.view.Panel_Detail_equipment.Item_icon.spriteName = _EquipIcon

end

function wnd_cangku_controller:showMessageBox()

end

function wnd_cangku_controller:prepareDecompositionPanel() -- 准备装备分解界面
	this.view.Panel_Detail_decomposition.Checkbox.Button_white.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = this.scrollViewController.cstr_SELECTED_CB
	this.view.Panel_Detail_decomposition.Checkbox.Button_green.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = this.scrollViewController.cstr_SELECTED_CB
	this.view.Panel_Detail_decomposition.Checkbox.Button_blue.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = this.scrollViewController.cstr_SELECTED_CB
	this.view.Panel_Detail_decomposition.Checkbox.Button_purple.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = nil
	this.view.Panel_Detail_decomposition.Checkbox.Button_golden.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = nil
	this.view.Panel_Detail_decomposition.Checkbox.Button_red.transform:
	GetChild(0):GetComponent(typeof(UISprite)).spriteName = nil
end


----------------------------------------------------------------
--★Interact with the server
function test()
	print("向服务器req")
	-- 登陆服务器
	local c2gw = c2gw_pb.LoginGame()
    c2gw.token = "token"
    c2gw.hostId = 101
    local msg1 = c2gw:SerializeToString()
    this:reqData(10001, msg1)

    Event.AddListener("10001",this.recData)

end

function wnd_cangku_controller:reqData(msgId,body)
	local header = header_pb.Header()
    header.ID = 1
    header.msgId = msgId
    header.userId = 8002--8001
    header.version = '1.0.0'
    header.errno = 0
    header.ext = 0
    if body then
        header.body = body
    end
    local msg2 = header:SerializeToString()
    local buffer = ByteBuffer()
    buffer:WriteBuffer(msg2)
    networkMgr:SendMessage(buffer)
end

function wnd_cangku_controller:recData() 
    -- 监听数据
	this:reqData(10002,nil)
	Event.AddListener("10002", 
		function(body)
			local gw2c = gw2c_pb.SelectRole()
		    gw2c:ParseFromString(body)
		    local user = gw2c.user

		    print('服务器返回装备数据>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
		    -- for k, v in ipairs(user.equip) do
		        -- print('gw2c.user.equip.id==>' .. v.id);
		    --     print('gw2c.user.equip.eid==>' .. v.eid);
		        -- print('gw2c.user.equip.lv==>' .. v.lv);
		        -- print('gw2c.user.equip.rarity==>' .. v.rarity);
		        -- print('gw2c.user.equip.fst_attr==>' .. v.fst_attr);
		        
		        -- for k, v in ipairs(v.sndAttr) do
		            -- print('gw2c.user.equip.sndAttr.id==>' .. v.id);
		        --     print('gw2c.user.equip.sndAttr.val==>' .. v.val);
		        --     print('gw2c.user.equip.sndAttr.isRemake==>' .. v.isRemake);
		            
		            -- for k, v in ipairs(v.remake) do
		                -- print('gw2c.user.equip.sndAttr.remake.id==>' .. v.id);
		        --         print('gw2c.user.equip.sndAttr.remake.val==>' .. v.val);
		            -- end
		            
		        -- end
		        -- print('gw2c.user.equip.isLock==>' .. v.isLock);
		        -- print('gw2c.user.equip.isBad==>' .. v.isBad);

		    -- end
		    print('结束>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
		    -- print('装备count = '..count)

		    -- print('服务器返回道具数据>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
		    

		    -- print('结束>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
		    
		    this:processServData(user.equip,user.item)
		    	    
		    this:sortServData()

		    this:mergeServData()
		    print('数据已储存')

		    -- 默认选中第一个按钮
			this:SelectYekaButton(this.view.Panel_Tab.TabButtons[1])

		end)
end
----------------------------------------------------------------
--★Process Server Data

function wnd_cangku_controller:processServData(user_equip,user_item) 

	for k, v in ipairs(user_equip) do
		
		local equip = {}
		equip = this.model:getLocalEquipmentDetailByEquipID(v.eid)
		if equip ~= nil then
			-- 添加选中属性
			equip.selected = false
			equip.id = v.id
			equip.eid = v.eid
			equip.lv = v.lv
			equip.rarity = v.rarity
			equip.fst_attr = v.fst_attr
			equip.sndAttr = { remake = {} }
			-- print("v.isLock = "..v.isLock)
			equip.isLock = v.isLock
			equip.isBad = v.isBad
			for k, v in ipairs(v.sndAttr) do
	           	table.insert(equip.sndAttr,
	           	{
	           		id = v.id,
					val = v.val,
					isRemake = v.isRemake,
		        })
	            for k, v in ipairs(v.remake) do
	                table.insert(equip.sndAttr.remake,
	                {
						id = v.id,
						val = v.val,
	                })
	            end
	        end
			table.insert(this.model.serv_Equipment,equip)
		end
    end
    print("装备："..#this.model.serv_Equipment)

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
							item = clone(item)
							item.num = _OverlapLimit
							table.insert(this.model.serv_Items,item)
						else
							item = clone(item)
							-- TODO 未详细测试计算结果，数量可能与预期不同
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
				if a["ItemID"] ~= b["ItemID"] then
					-- print("cp ItemID")
					return a["ItemID"] < b["ItemID"] -- ItemID小的在前
				elseif a["Quality"] ~= b["Quality"] then
					-- print("cp Quality")
					return a["Quality"] > b["Quality"] -- Quality大的在前
				elseif a["UseType"] ~= b["UseType"] then
					-- print("cp UseType")
					return a["UseType"] < b["UseType"] -- UseType小的在前
				else 
					-- print("cp ComposeNum")
					return a["ComposeNum"] > b["ComposeNum"] end -- 可以合成的在前
			end
			return false
		end)
	print("serv_Items排序完成..")
	table.sort(this.model.serv_Equipment,
		function(a,b)
			if a.id ~= b.id then
				-- print("cp id")
				return a.id < b.id -- 装备专有ID小的在前
			elseif a.lv ~= b.lv then
				-- print("cp lv")
				return a.lv > b.lv -- lv大的在前
			elseif a.rarity	 ~= b.rarity then
				-- print("cp rarity")
				return a.rarity > b.rarity -- rarity大的在前
			elseif a.isBad ~= 0 then
				return false -- 损坏度
			end
			return false	
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
	print("合并后："..#this.model.Processed_Items)

	-- 克隆装备表到临时表，用于分解界面使用
	this.model.decomposition_Equipment = clone(this.model.serv_Equipment)
	print(this.model.decomposition_Equipment)
	print(this.model.serv_Equipment)
end

return wnd_cangku_controller
