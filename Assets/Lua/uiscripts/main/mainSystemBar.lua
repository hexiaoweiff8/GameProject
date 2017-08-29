ui_mainSystemBar = {
	cPARENT = "UIRoot/BackGroundRoot/ui_main_panel/ui_main",
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
		collider.center = Vector3(0,12,0)
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
			Item["Prompt"] = v[sdata_maininterface_data.mFieldName2Index['Prompt']]
			Item["Icon"] = v[sdata_maininterface_data.mFieldName2Index['Icon']]
			Item["UIDefine"] = v[sdata_maininterface_data.mFieldName2Index['UIDefine']]
			Item["RedDotRefreshAPI"] = v[sdata_maininterface_data.mFieldName2Index['RedDotRefreshAPI']]
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
	UIEventListener.Get(pItem).onClick = function()
		local function getEntrance(ID)
			for i = 1,#m.local_MainSystemBarData do
				if m.local_MainSystemBarData[i]["ID"] == ID then
					if m.local_MainSystemBarData[i]["UIDefine"] ~= '' then
						return m.local_MainSystemBarData[i]["UIDefine"]
					else
						error("未定义ui入口")
					end
				end
			end
		end
		showWND(getEntrance(ID))
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
--@Des 刷新所有图标红点
function ui_mainSystemBar.refreshRedDot()
	local function find_Prompt_and_UIDefine_By_ID(ID)
		for _,v in ipairs(m.local_MainSystemBarData) do
			if v["ID"] == ID then
				return v["Prompt"],v["UIDefine"]
			end
		end
	end

	for _,v in ipairs(m.MainSystemBarItems) do
		local _prompt,_uiDefine = find_Prompt_and_UIDefine_By_ID(tonumber(v.name))
		local redDotWidget = v.transform:Find("RedDot").gameObject
		print(_prompt,_uiDefine)
		if _prompt == 1 then -- 显示正常红点
			local refreshFunc = m.Get_RefreshFunction_By_WND_base_id(_uiDefine)
			local returnValue = refreshFunc ~= nil and refreshFunc() or -1
			if returnValue > 0 then
				redDotWidget:SetActive(true)
			else
				redDotWidget:SetActive(false)
			end
		elseif _prompt == 2 then --TODO: 显示数字
			
		else -- 什么都不显示
			if redDotWidget.activeInHierarchy then
				redDotWidget:SetActive(false)
			end
		end
	end
end
--@Des 通过baseId刷新指定图标的红点
--@Params wnd_base_id (UIDefine)
function ui_mainSystemBar.refreshRedDotBy_WND_base_id(wnd_base_id)
	local function getIDByUIDefine()
		for _,v in ipairs(m.local_MainSystemBarData) do
			if v["UIDefine"] == wnd_base_id then
				return v["ID"]
			end
		end
	end

	local ID = getIDByUIDefine(wnd_base_id)
	for _,v in ipairs(m.MainSystemBarItems) do
		if v.name == tostring(ID) then
			local refreshFunc = m.Get_RefreshFunction_By_WND_base_id(wnd_base_id)
			local returnValue = refreshFunc ~= nil and refreshFunc() or -1
			printw("returnValue = "..returnValue)
			if returnValue > 0 then
				v.transform:Find("RedDot").gameObject:SetActive(true)
			else
				v.transform:Find("RedDot").gameObject:SetActive(false)
			end
		end
	end
end
function ui_mainSystemBar.playOpenAnime()
	local skipCount = 0
	-- local currentLV = userModel:getUserRoleTbl().lv
	local currentLV = 5

	-- for i = 1,#m.MainSystemBarItems do
	-- 	local ID = tonumber(m.MainSystemBarItems[i].name)

	-- 	if currentLV < sdata_maininterface_data:GetFieldV("UnlockLevel",ID) then
	-- 		skipCount = skipCount + 1
	-- 	else
	-- 		m.MainSystemBarItems[i]:GetComponent(typeof(UnityEngine.BoxCollider)).enabled = true
	-- 		m.MainSystemBarItems[i].transform:DOLocalMove(
	-- 		Vector3(
	-- 			m.cItemLocalPosition.x + (i - skipCount - 1) * (m.cSpacing + m.pItem:GetComponent(typeof(UIWidget)).localSize.x),
	-- 			m.cItemLocalPosition.y,
	-- 			m.cItemLocalPosition.z
	-- 		)
	-- 		,0.5,true)
	-- 	end
	-- end

	local function DoLocalMove(index)
		local ID = tonumber(m.MainSystemBarItems[index].name)

		if currentLV < sdata_maininterface_data:GetFieldV("UnlockLevel",ID) then
			skipCount = skipCount + 1
		else
			m.MainSystemBarItems[index]:GetComponent(typeof(UnityEngine.BoxCollider)).enabled = true
			m.MainSystemBarItems[index].transform:DOLocalMove(
			Vector3(
				m.cItemLocalPosition.x + (index - skipCount - 1) * (m.cSpacing + m.pItem:GetComponent(typeof(UIWidget)).localSize.x),
				m.cItemLocalPosition.y,
				m.cItemLocalPosition.z
			)
			,0.035,true):OnComplete(
				function()
					if index < #m.MainSystemBarItems then
						DoLocalMove(index + 1)
					end
				end)
		end
	end

	DoLocalMove(1)
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
function ui_mainSystemBar.DOLocalJump(go)
	local basePoint = go.transform.localPosition
	local sq = go.transform:DOLocalJump(
            Vector3(go.transform.localPosition.x,
                go.transform.localPosition.y + 20,
                go.transform.localPosition.z),
            40.0,1,0.8,true);
    sq:Append(go.transform:DOLocalMove(basePoint, 0.1,true));
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
		m.refreshRedDot()
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
----------------------------------------------------------------
--★Util
function ui_mainSystemBar.Get_RefreshFunction_By_WND_base_id(wnd_base_id)

	local function addReturnValue(funcStr)
		local RETURN = 'return'
		return RETURN..' '..funcStr
	end

	for _,v in ipairs(m.local_MainSystemBarData) do
		if v['UIDefine'] == wnd_base_id then
			if v['RedDotRefreshAPI'] ~= '' then
				return loadstring(addReturnValue(v['RedDotRefreshAPI']))
			end
		end
	end
	printw(wnd_base_id..'对应刷新红点API未定义')
	return nil
end

return ui_mainSystemBar