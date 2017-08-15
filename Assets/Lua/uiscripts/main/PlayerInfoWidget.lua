ui_playerInfo = {
	cPARENT = "UIRoot/FlyRoot",
	-- 1136x640分辨率相对坐标
	cLocalPosition = Vector3(-408,271,0),
	-- 是否已经初始化
	bIsInitialed = false,
}

local m = ui_playerInfo
----------------------------------------------------------------
--★Init
function ui_playerInfo.initView()
	m.root = GameObjectExtension.InstantiateFromPacket("ui_resident", "Widget_PlayerInfo", UnityEngine.GameObject.Find(m.cPARENT)).gameObject
	m.root.transform.localPosition = m.cLocalPosition
	m.root.name = "Widget_PlayerInfo"
	m.playerName = m.root.transform:Find("PlayerName").gameObject:GetComponent(typeof(UILabel))
	m.vipLevel = m.root.transform:Find("VIPLevel").gameObject:GetComponent(typeof(UILabel))
	m.playerLevel = m.root.transform:Find("PlayerLevel").gameObject:GetComponent(typeof(UILabel))
	m.playerLevelProcess = m.root.transform:Find("PlayerLevelProcess").gameObject:GetComponent(typeof(UIProgressBar))

	m.bIsInitialed = true
end
----------------------------------------------------------------
--★refreshView
function ui_playerInfo.updatePlayerInfo()
	local userTbl = userModel:getUserRoleTbl()
	-- m.vipLevel.text = "VIP "..userTbl.vipLv
	m.playerLevel.text = "LV "..userTbl.lv
	m.playerLevelProcess.value = userModel:getNextLevelExpProcess()
end
----------------------------------------------------------------
--★Show/Hide Control
function ui_playerInfo.show()
	if m.bIsInitialed then
		m.root:SetActive(true)
	else
		m.initView()
		m.playerName.text = userModel:getUserRoleTbl().userName
		m.updatePlayerInfo()
		m.root:SetActive(true)
	end
end
function ui_playerInfo.hide()
	m.root:SetActive(false)
end
function ui_playerInfo.destroy()
	UnityEngine.GameObject.Destroy(m.root)
	ui_playerInfo = nil
end

return ui_playerInfo