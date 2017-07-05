wnd_cangku_ScrollView_controller = {

	_scrollView,
	_scrollViewItem,

	Items = {}, -- 所有道具及装备
	currentItems = {}, -- 回调方法OnItemLoaded被调用时索引列表
	Items_filterByUseType_1_2 = nil, -- 记录排好序的表，在当前界面仅初始化一次
	Items_filterByUseType_3_4_5 = nil,
	Items_filterByUseType_6_7 = nil,
	Items_filterByUseType_8 = nil,

	_selectedIndex,
	_selectedItem, -- 记录当前处于选择状态的Item

	_State_InDECOMPOSITION = false,-- 标记当前是否处于装备分解界面

	-- function
	init,
	initScrollViewItem,
	setQualityMark,-- 设置物品品质框
	filterBy, -- 筛选显示，页卡切换时调用，以刷新ScrollView，并显示对应分类
	sortItems, -- 根据规则对Items表排序
	sortEquipment, -- 根据规则对装备表排序

	-- CallBack
	HandleOnItemLoadedHandler, -- 回调，加载列表项时被执行
	HandleOnItemClickedHandler, -- 列表项回调，点击列表项时被执行
	HandleOnItemSelectedHandler, -- 用于实现点击页卡后，选中列表第一项
	
}

local this = wnd_cangku_ScrollView_controller
local ctrl,model,view
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_cangku_ScrollView_controller:init(Ctrl)
	ctrl = Ctrl
	model = Ctrl.model
	view = Ctrl.view

	_scrollView = view.Panel_depository.ListView:GetComponent(typeof(UIScrollViewAdapter))	
	_scrollViewItem = this:initScrollViewItem()

	this.Items = model.Processed_Items -- 所有物品，已排序

	_scrollView.onItemLoaded = function(go)
		this:HandleOnItemLoadedHandler(go)
	end
	_scrollView.onItemSelected = function(go)
		this:HandleOnItemSelectedHandler(go)
	end
	_scrollView:Create(0,_scrollViewItem)

	view.Panel_depository.panel:AddComponent(typeof(UIDragScrollView)).scrollView = _scrollView.gameObject:GetComponent(typeof(UIScrollView))
	collider = view.Panel_depository.panel:AddComponent(typeof(UnityEngine.BoxCollider))
		collider.isTrigger = true
		collider.center = Vector3.zero
		collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIPanel)):GetViewSize().x,collider.gameObject:GetComponent(typeof(UIPanel)):GetViewSize().y,0) 

	_scrollViewItem.gameObject:SetActive(false)

	view.pItem_empty:SetActive(false)
	view.cItem:SetActive(false)
	view.cEquipment:SetActive(false)
end

function wnd_cangku_ScrollView_controller:initScrollViewItem()
	local Item = view.pItem:AddComponent(typeof(UI_Cangku_Item))

	Item._widgetTransform = view.pItem:GetComponent(typeof(UIWidget))

	Item.gameObject:AddComponent(typeof(UIDragScrollView))
	Item.transform.localPosition = Vector3(0,0,0)

	local collider = Item.gameObject:AddComponent(typeof(UnityEngine.BoxCollider))

	collider.isTrigger = true
	collider.center = Vector3.zero
	collider.size = Vector3(Item._widgetTransform.localSize.x,Item._widgetTransform.localSize.y,0)

	view.cItem.transform:SetParent(Item.gameObject.transform)
	view.cItem.transform.localPosition = Vector3.zero
	view.cEquipment.transform:SetParent(Item.gameObject.transform)
	view.cEquipment.transform.localPosition = Vector3.zero

	Item.cItem = Item.transform:GetChild(3).gameObject
	Item.cEquipment = Item.transform:GetChild(4).gameObject

	return Item 
end

function wnd_cangku_ScrollView_controller:getItemType(ItemID)
	local str = string.sub(tostring(ItemID),1,1)
	if str == '4' then
		return model.ItemType[tonumber(string.sub(tostring(ItemID),2,2))]
	else return '装备碎片'
	end
end

function wnd_cangku_ScrollView_controller:setQualityMark(cangkuItem,Quality)
	if Quality == 1 then
		cangkuItem:setIconFrame(cstr.QUALITY_WHITE)
	elseif Quality == 2 then
		cangkuItem:setIconFrame(cstr.QUALITY_GREEN)
	elseif Quality == 3 then
		cangkuItem:setIconFrame(cstr.QUALITY_BLUE)
	elseif Quality == 4 then
		cangkuItem:setIconFrame(cstr.QUALITY_PURPLE)
	elseif Quality == 5 then
		cangkuItem:setIconFrame(cstr.QUALITY_ORANGE)
	else cangkuItem:setIconFrame(cstr.QUALITY_RED) end
end
----------------------------------------------------------------
--★Callback
function wnd_cangku_ScrollView_controller:HandleOnItemLoadedHandler(item)

	local cangkuItem = item.gameObject:GetComponent(typeof(UI_Cangku_Item))

	if cangkuItem.cItem == nil then
		cangkuItem.cItem = cangkuItem.transform:GetChild(3).gameObject
	end
	if cangkuItem.cEquipment == nil then
		cangkuItem.cEquipment = cangkuItem.transform:GetChild(4).gameObject
	end	

	if cangkuItem.Index + 1 <= #this.currentItems then -- 索引不在范围内，则显示空物品
		
		if this.currentItems[cangkuItem.Index+1]["EquipID"] ~= nil then -- 如果是装备
			cangkuItem.cItem:SetActive(false)
			cangkuItem.cEquipment:SetActive(true)

			cangkuItem._EquipID = this.currentItems[cangkuItem.Index+1]["EquipID"]
			-- cangkuItem._ItemID = nil

			local _lv = this.currentItems[cangkuItem.Index+1].lv
			local _rarity = this.currentItems[cangkuItem.Index+1].rarity
			local _equipped = this.currentItems[cangkuItem.Index+1].equipped
			local _isLock
			if this.currentItems[cangkuItem.Index+1].isLock == 0 then
				_isLock = false
			else _isLock = true end
			
			this:setQualityMark(cangkuItem,_rarity)
			cangkuItem:setIcon(this.currentItems[cangkuItem.Index+1]['EquipIcon'])
			cangkuItem:setEquipmentLevel(_lv)
			cangkuItem:setEquipmentLock(_isLock)
			cangkuItem:setEquipped(_equipped)
			
			if this._State_InDECOMPOSITION then -- 如果处于装备分解界面，则显示选中/未选中状态
				cangkuItem:setItemSelect(this.currentItems[cangkuItem.Index+1].selected)
			else
				cangkuItem:setItemSelect(false)
			end
		else -- 如果是道具
			cangkuItem.cItem:SetActive(true)
			cangkuItem.cEquipment:SetActive(false)

			cangkuItem._ItemID = this.currentItems[cangkuItem.Index+1]["ItemID"]
			-- cangkuItem._EquipID = nil

			local _Quality = this.currentItems[cangkuItem.Index+1]["Quality"]
			local _OverlapLimit = this.currentItems[cangkuItem.Index+1]["OverlapLimit"]
			local _UseType = this.currentItems[cangkuItem.Index+1]["UseType"]
			local _ComposeNum = this.currentItems[cangkuItem.Index+1]["ComposeNum"]

			cangkuItem:setIcon(this.currentItems[cangkuItem.Index+1]['Icon'])
			this:setQualityMark(cangkuItem,_Quality)
			
			if _OverlapLimit == 1 then
				-- 隐藏叠加数量
				cangkuItem:setItemCountHide(true)
			else
				cangkuItem:setItemCount(this.currentItems[cangkuItem.Index+1].num)
			end

			if _UseType == 1 then 
				if _ComposeNum ~= -1 then -- 可以合成的碎片显示此标记
					cangkuItem:setCompositeMark(true,true)
				else cangkuItem:setCompositeMark(true,false) end
			else cangkuItem:setCompositeMark(false,false) end

			cangkuItem:setItemSelect(false)
		end
		
		UIEventListener.Get(cangkuItem.gameObject).onClick = function(go)
			this:HandleOnItemClickedHandler(go:GetComponent(typeof(UI_Cangku_Item)))
		end

	else
		-- if cangkuItem.Index + 1 <= 6 * 5 then
		cangkuItem:setIcon('nil')
		cangkuItem:setIconFrame(view.pItem_empty:GetComponent(typeof(UISprite)).spriteName)
		cangkuItem.cItem:SetActive(false)
		cangkuItem.cEquipment:SetActive(false)
		-- cangkuItem:setIcon('nil')
		-- cangkuItem:setIconFrame('nil')
		-- cangkuItem.cItem:SetActive(false)
		-- cangkuItem.cEquipment:SetActive(false)
	end
	
end

function wnd_cangku_ScrollView_controller:HandleOnItemClickedHandler(cangkuItem)

	if this._State_InDECOMPOSITION then -- 如果处于装备分解界面，则交给对应方法处理
		this:HandleOnItemClickedInDecompositionPanel(cangkuItem)
		return
	end

	if cangkuItem.Index + 1 <= #this.currentItems then -- 索引在范围内

		if this._selectedItem == cangkuItem then -- 如果已经被选中
			return
		end

		this:HandleOnItemSelectedHandler(cangkuItem)

		if this.currentItems[cangkuItem.Index+1]["EquipID"] ~= nil then
			-- print("显示装备信息:"..this.currentItems[cangkuItem.Index+1]["EquipID"])
			-- print("唯一id:"..this.currentItems[cangkuItem.Index+1].id)
			-- print("装备等级:"..this.currentItems[cangkuItem.Index+1].lv)
			-- print("装备品质:"..this.currentItems[cangkuItem.Index+1].rarity)
			-- print("")

			ctrl:showEquipmentDetailsPanel(this.currentItems[cangkuItem.Index+1],cangkuItem)
		else
			local useType = this.currentItems[cangkuItem.Index+1]["UseType"]
			print(cangkuItem._ItemID)
			print('显示'..this:getItemType(this.currentItems[cangkuItem.Index+1]["ItemID"])..'面板 by UseType = '..useType)

			ctrl:showPanelByItemData(this.currentItems[cangkuItem.Index+1])
		end
	else
		-- 如果ListView没有物品，则隐藏上一个显示在右边的界面
		if ctrl._currentPanel_right ~= nil then
			ctrl:hide(ctrl._currentPanel_right)
		end
	end

end

function wnd_cangku_ScrollView_controller:HandleOnItemClickedInDecompositionPanel(cangkuItem)
	if cangkuItem.Index + 1 <= #this.currentItems then -- 索引在范围内
		if this.currentItems[cangkuItem.Index+1].selected then
			this.currentItems[cangkuItem.Index+1].selected = false
			cangkuItem:setItemSelect(false)
		else
			local canSel = this:canSelect()
			local canDecom = this:canDecompose(this.currentItems[cangkuItem.Index+1])

			if not canSel then
				ctrl:showToast("最多可以同时选择10件装备",1)
				return
			elseif not canDecom then
				ctrl:showToast("装备已锁定，不可以分解",1)
				return
			end
			this.currentItems[cangkuItem.Index+1].selected = true
			cangkuItem:setItemSelect(true)
		end
		
		-- if #this.currentItems < 6 * 5 then
		-- 	_scrollView:Reload(6 * 5)
		-- else
		-- 	_scrollView:Reload(#this.currentItems) end
	end
end

function wnd_cangku_ScrollView_controller:HandleOnItemSelectedHandler(cangkuItem)
	
	if this._selectedItem ~= nil and
		this._selectedItem ~= cangkuItem then
		this._selectedItem:setIconSelectFrame(nil)
	end

	cangkuItem:setIconSelectFrame(cstr.SELECTED) 

	this._selectedItem = cangkuItem	
end
----------------------------------------------------------------
--★ScrollView func
function wnd_cangku_ScrollView_controller:filterBy(Goods,Maintype)
	if Goods == nil or Maintype == nil then
		error('筛选数据异常')
		return
	end

	if Goods == '-1' then -- 显示全部(装备在前，道具在后)
		print("filterBy() 显示全部")
		this.currentItems = this.Items
	end

	if Goods == 'Equip' then --  显示所有装备
		if Maintype ~= 'Decomposition' then
			this.currentItems = model.serv_Equipment
		else
			-- Maintype == Decomposition时为内部调用，显示装备分解临时表
			this.currentItems = model.decomposition_Equipment
			return
		end
	end

	if Goods == 'Item' and Maintype == '1' then -- 显示所有碎片道具(UseType 1,2)
		if this.Items_filterByUseType_1_2 ~= nil then
			this.currentItems = this.Items_filterByUseType_1_2
		else
			this.Items_filterByUseType_1_2 = {}
			for i = 1,#model.serv_Items do
				if model.serv_Items[i]["UseType"] == 1 or model.serv_Items[i]["UseType"] == 2 then
					table.insert(this.Items_filterByUseType_1_2,model.serv_Items[i])
				end
			end
			this:sortItems(this.Items_filterByUseType_1_2)
			this.currentItems = this.Items_filterByUseType_1_2
		end
	end

	if Goods == 'Item' and Maintype == '2' then -- 显示所有材料道具(UseType 6,7)
		if this.Items_filterByUseType_6_7 ~= nil then
			this.currentItems = this.Items_filterByUseType_6_7
		else
			this.Items_filterByUseType_6_7 = {}
			for i = 1,#model.serv_Items do
				if model.serv_Items[i]["UseType"] == 6 or model.serv_Items[i]["UseType"] == 7 then
					table.insert(this.Items_filterByUseType_6_7,model.serv_Items[i])
				end
			end
			this:sortItems(this.Items_filterByUseType_6_7)
			this.currentItems = this.Items_filterByUseType_6_7
		end
	end

	if Goods == 'Item' and Maintype == '3' then -- 显示所有消耗品及宝箱道具(UseType 3,4,5)
		if this.Items_filterByUseType_3_4_5 ~= nil then
			this.currentItems = this.Items_filterByUseType_3_4_5
		else
			this.Items_filterByUseType_3_4_5 = {}
			for i = 1,#model.serv_Items do
				if model.serv_Items[i]["UseType"] == 3 or
					 model.serv_Items[i]["UseType"] == 4 or
					  model.serv_Items[i]["UseType"] == 5 then
					table.insert(this.Items_filterByUseType_3_4_5,model.serv_Items[i])
				end
			end
			this:sortItems(this.Items_filterByUseType_3_4_5)
			this.currentItems = this.Items_filterByUseType_3_4_5
		end
	end

	if Goods == 'Item' and Maintype == '4' then -- 显示所有收藏品道具(UseType 8)
		if this.Items_filterByUseType_8 ~= nil then
			this.currentItems = this.Items_filterByUseType_8
		else
			this.Items_filterByUseType_8 = {}
			for i = 1,#model.serv_Items do
				if model.serv_Items[i]["UseType"] == 8 then
					table.insert(this.Items_filterByUseType_8,model.serv_Items[i])
				end
			end
			this:sortItems(this.Items_filterByUseType_8)
			this.currentItems = this.Items_filterByUseType_8
		end
	end

	if this._selectedItem ~= nil then
		this._selectedItem:setIconSelectFrame(nil)
	end
	this._selectedItem = nil
	-- ListView重新加载方法
	if #this.currentItems <= 6 * 5 then
		_scrollView:Reload(6 * 5)
	else
		_scrollView:Reload(#this.currentItems) end

	-- 默认选择第一个
	if #this.currentItems ~= 0 then

		-- this._selectedItem = nil

		if this.currentItems[1]["EquipID"] ~= nil then
			print("显示装备信息")
			local cangkuItem = _scrollView.gameObject.transform:GetChild(0):GetChild(0).gameObject:GetComponent(typeof(UI_Cangku_Item))
			ctrl:showEquipmentDetailsPanel(this.currentItems[1],cangkuItem)
		else
			local useType = this.currentItems[1]["UseType"]
			-- print(this.currentItems[1])
			print('显示'..this:getItemType(this.currentItems[1]["ItemID"])..'面板 by UseType = '..useType)

			ctrl:showPanelByItemData(this.currentItems[1])
		end
	else
		-- 如果ListView没有物品，则隐藏上一个显示在右边的界面
		if ctrl._currentPanel_right ~= nil then
			ctrl:hide(ctrl._currentPanel_right)
		end
	end

end

function wnd_cangku_ScrollView_controller:selectEquipmentByQuality(rarity)
	for i = 1,#this.currentItems do
		if this.currentItems[i].rarity == rarity then
			this.currentItems[i].selected = true
		end
	end
	if #this.currentItems < 6 * 5 then
		_scrollView:Reload(6 * 5)
	else
		_scrollView:Reload(#this.currentItems) end

	-- 取消仓库默认选中
	if this._selectedItem ~= nil then
		this._selectedItem:setIconSelectFrame(nil)
	end
end

function wnd_cangku_ScrollView_controller:disselectEquipmentByQuality(rarity)
	for i = 1,#this.currentItems do
		if this.currentItems[i].rarity == rarity then
			this.currentItems[i].selected = false
		end
	end
	if #this.currentItems < 6 * 5 then
		_scrollView:Reload(6 * 5)
	else
		_scrollView:Reload(#this.currentItems) end

	-- 取消仓库默认选中
	if this._selectedItem ~= nil then
		this._selectedItem:setIconSelectFrame(nil)
	end
end

function wnd_cangku_ScrollView_controller:addEquipmentShowByQuality(rarity)
	if this.currentItems ~= model.decomposition_Equipment or (this.currentItems == nil and #this.currentItems == 0) then
		return
	end

	for i = 1,#model.serv_Equipment do
		if model.serv_Equipment[i].rarity == rarity then
			table.insert(this.currentItems,model.serv_Equipment[i])
		end
	end
	-- 清除已选择状态
	this:clearSelectedFLAG()

	this:sortEquipment(this.currentItems)

	if #this.currentItems < 6 * 5 then
		_scrollView:Reload(6 * 5)
	else
		_scrollView:Reload(#this.currentItems) end

	-- 取消仓库默认选中
	if this._selectedItem ~= nil then
		this._selectedItem:setIconSelectFrame(nil)
	end
end

function wnd_cangku_ScrollView_controller:removeEquipmentShowByQuality(rarity)
	if this.currentItems ~= model.decomposition_Equipment or (this.currentItems == nil and #this.currentItems == 0) then
		return
	end

	for i = #this.currentItems,1,-1 do
		if this.currentItems[i].rarity == rarity then
			table.remove(this.currentItems,i)
		end
	end
	-- 清除已选择状态
	this:clearSelectedFLAG()

	this:sortEquipment(this.currentItems)

	if #this.currentItems < 6 * 5 then
		_scrollView:Reload(6 * 5)
	else
		_scrollView:Reload(#this.currentItems) end

	-- 取消仓库默认选中
	if this._selectedItem ~= nil then
		this._selectedItem:setIconSelectFrame(nil)
	end
end
----------------------------------------------------------------
--★Sort func
function wnd_cangku_ScrollView_controller:sortItems(Items)
	if #Items == 0 then
		return
	end
	table.sort(Items,
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
		end)
end

function wnd_cangku_ScrollView_controller:sortEquipment(Equipment)
	if #Equipment == 0 then
		return
	end
	table.sort(Equipment,
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
		end)
end
----------------------------------------------------------------
--★EquipmentDecomposition Util func
function wnd_cangku_ScrollView_controller:canSelect()
	local count = 0
	for i = 1,#model.decomposition_Equipment do
		if model.decomposition_Equipment[i].selected then
			count = count + 1
		end
	end
	if count < 10 then
		return true
	else return false end 
end
function wnd_cangku_ScrollView_controller:canDecompose(equip)
	if equip.isLock == 1 then
		return false
	else return true end
end
function wnd_cangku_ScrollView_controller:clearSelectedFLAG()
	for i = 1,#model.decomposition_Equipment do
		if model.decomposition_Equipment[i].selected then
			model.decomposition_Equipment[i].selected = false
		end
	end
end

return this