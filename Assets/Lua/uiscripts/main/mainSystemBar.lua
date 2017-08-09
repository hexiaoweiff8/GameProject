ui_mainSystemBar = {
	cPARENT = "UIRoot/FlyRoot",
	local_MainSystemBarData = {},
	MainSystemBarItems = {},
	-- 行间距,相对于分辨率
	cSpacing = 21,
	-- 1136x640分辨率相对坐标
	cLocalPosition = Vector3(-549,-271,0),
	-- Item相对起始坐标
	cItemLocalPosition = Vector3(58,-16,0),
	cOutPosition = Vector3(-58,-16,0),
	-- 系统栏状态枚举
	eBarState = {
		OPEN = 1,
		CLOSE = 2,
	},
	bIsInitialed = false,
	currentState = nil,
}

local m = ui_mainSystemBar
----------------------------------------------------------------
--★Init
function ui_mainSystemBar.initView()
	m.root = GameObjectExtension.InstantiateFromPacket("ui_resident", "Widget_MainSystemBar", UnityEngine.GameObject.Find(m.cPARENT)).gameObject
	m.root.transform.localPosition = m.cLocalPosition
	m.root.name = "Widget_MainSystemBar"
	m.switch = m.root
	m.pItem = m.root.transform:Find("pSprite").gameObject

	local colliders = {}

	table.insert(colliders,m.switch)
	table.insert(colliders,m.pItem)

	local collider = nil
	for index,button in pairs(colliders) do
		collider = button:AddComponent(typeof(UnityEngine.BoxCollider))
		collider.isTrigger = true
		collider.center = Vector3.zero
		if collider.gameObject == m.pItem then
			collider.size = Vector3(78,78,0)
		else
			collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0) 
		end
	end

	UIEventListener.Get(m.switch).onClick = function()
			m.toggleBar()
		end
end
function ui_mainSystemBar.initData()
	for k,v in pairs(sdata_maininterface_data.mData.body) do
		if v[sdata_maininterface_data.mFieldName2Index['Type']] == 1 then
			local Item = {}
			Item["ID"] = v[sdata_maininterface_data.mFieldName2Index['ID']]
			Item["Name"] = v[sdata_maininterface_data.mFieldName2Index['Name']]
			Item["Type"] = v[sdata_maininterface_data.mFieldName2Index['Type']]
			Item["UnlockLevel"] = v[sdata_maininterface_data.mFieldName2Index['UnlockLevel']]
			Item["UnlockEvent"] = v[sdata_maininterface_data.mFieldName2Index['UnlockEvent']]
			Item["Icon"] = v[sdata_maininterface_data.mFieldName2Index['Icon']]
			table.insert(m.local_MainSystemBarData,Item)
		end
	end
	table.sort(m.local_MainSystemBarData,function(a,b)
		return a["ID"] < b["ID"]
	end)
end
function ui_mainSystemBar.initItem()
	for i = 1,#m.local_MainSystemBarData do
		if i == 1 then
			m.pItem.name = m.local_MainSystemBarData[i]["ID"]
			m.pItem.transform:Find("Icon").gameObject:GetComponent(typeof(UISprite)).spriteName
				= m.local_MainSystemBarData[i]["Icon"]
			m.pItem.transform:Find("Name").gameObject:GetComponent(typeof(UILabel)).text
				= m.local_MainSystemBarData[i]["Name"]
			m.attachListener(m.local_MainSystemBarData[i]["ID"],m.pItem)

			table.insert(m.MainSystemBarItems,m.pItem)
		else
			local pItem = GameObject.Instantiate(m.pItem,m.pItem.transform.parent)
			pItem.name = m.local_MainSystemBarData[i]["ID"]
			pItem.transform.localScale = Vector3.one
			-- pItem.transform.localPosition = 
			-- 	Vector3(m.pItem.transform.localPosition.x + (i-1) * (m.cSpacing + m.pItem:GetComponent(typeof(UIWidget)).localSize.x),
			-- 		m.pItem.transform.localPosition.y,
			-- 		m.pItem.transform.localPosition.z)
			pItem.transform:Find("Icon").gameObject:GetComponent(typeof(UISprite)).spriteName
				= m.local_MainSystemBarData[i]["Icon"]
			pItem.transform:Find("Name").gameObject:GetComponent(typeof(UILabel)).text
				= m.local_MainSystemBarData[i]["Name"]

			m.attachListener(m.local_MainSystemBarData[i]["ID"],pItem)

			table.insert(m.MainSystemBarItems,pItem)
		end
	end
	m.bIsInitialed = true
end
function ui_mainSystemBar.attachListener(ID,pItem)
	if ID == 101 then -- 显示equip2界面
		UIEventListener.Get(pItem).onClick = function()
			ui_manager:ShowWB(WNDTYPE.ui_equip2)
		end
	elseif ID == 102 then -- 显示编队界面
		UIEventListener.Get(pItem).onClick = function()
			ui_manager:ShowWB(WNDTYPE.BianDui)
		end
	elseif ID == 104 then -- 显示仓库界面
		UIEventListener.Get(pItem).onClick = function()
			ui_manager:ShowWB(WNDTYPE.Cangku)
		end
	elseif ID == 106 then
		UIEventListener.Get(pItem).onClick = function()
			ui_manager:ShowWB(WNDTYPE.Shop)
		end
	elseif ID == 107 then
		UIEventListener.Get(pItem).onClick = function()
			if ui_manager._shown_wnd_bases[WNDTYPE.CardShop] == nil then
				ui_manager:ShowWB(WNDTYPE.CardShop)
			else
				ui_manager._shown_wnd_bases[WNDTYPE.CardShop]:Show()
			end
		end
	end
end
----------------------------------------------------------------
--★Open/Close Control
--@Des 切换系统栏显示状态
function ui_mainSystemBar.toggleBar()
	if m.currentState == m.eBarState.OPEN then
		m.playCloseAnime()
		m.currentState = m.eBarState.CLOSE
		m.switch:GetComponent(typeof(UISprite)).spriteName = "tongyong_jiantou_zuo"
	else
		m.playOpenAnime()
		m.currentState = m.eBarState.OPEN
		m.switch:GetComponent(typeof(UISprite)).spriteName = "tongyong_jiantou_you"
	end
end
function ui_mainSystemBar.playOpenAnime()
	local skipCount = 0
	-- local currentLV = userModel:getUserRoleTbl().lv
	local currentLV = 5

	for i = 1,#m.MainSystemBarItems do
		local ID = tonumber(m.MainSystemBarItems[i].name)

		if currentLV < sdata_maininterface_data:GetFieldV("UnlockLevel",ID) then
			skipCount = skipCount + 1
		else
			m.MainSystemBarItems[i]:GetComponent(typeof(UnityEngine.BoxCollider)).enabled = true
			m.MainSystemBarItems[i].transform:DOLocalMove(
			Vector3(
				m.cItemLocalPosition.x + (i - skipCount - 1) * (m.cSpacing + m.pItem:GetComponent(typeof(UIWidget)).localSize.x),
				m.cItemLocalPosition.y,
				m.cItemLocalPosition.z
			)
			,0.5,true)
		end
	end
end
function ui_mainSystemBar.playCloseAnime()
	for i = 1,#m.MainSystemBarItems do
		if m.MainSystemBarItems[i].transform.localPosition ~= m.cOutPosition then
			-- 播放收起动画时不响应事件
			m.MainSystemBarItems[i]:GetComponent(typeof(UnityEngine.BoxCollider)).enabled = false
			m.MainSystemBarItems[i].transform:DOLocalMove(m.cOutPosition,0.5,true)
		end
	end
end
----------------------------------------------------------------
--★Show/Hide Control
function ui_mainSystemBar.show()
	if bIsInitialed then
		m.root:SetActive(true)
	else
		m.initView()
		m.initData()
		m.initItem()
		m.root:SetActive(true)
		m.toggleBar()
	end
end
function ui_mainSystemBar.hide()
	m.root:SetActive(false)
end
--@Des 清理UI,释放内存
function ui_mainSystemBar.destroy()
	UnityEngine.GameObject.Destroy(m.root)
	ui_mainSystemBar = nil
end

return ui_mainSystemBar