ui_mobileInfo = {
	cPARENT = "UIRoot/BackGroundRoot/ui_main_panel/ui_main",
	-- 1136x640分辨率相对坐标
	cLocalPosition = Vector3(520,293,0),
	-- 是否已经初始化
	bIsInitialed = false,
	-- 信号状态区间值枚举
	SignalState = {
		BAD = 1000,
		NORMAL = 300,
		GOOD = 100,
	},
}

local m = ui_mobileInfo
----------------------------------------------------------------
--★Init
function ui_mobileInfo.initView()
	m.root = GameObjectExtension.InstantiateFromPacket("ui_resident", "Widget_MobileInfo", UnityEngine.GameObject.Find(m.cPARENT)).gameObject
	m.root.transform.localPosition = m.cLocalPosition
	m.root.name = "Widget_MobileInfo"
	m.battery = m.root.transform:Find("battery").gameObject:GetComponent(typeof(UIProgressBar))
	m.signal = m.root.transform:Find("signal").gameObject:GetComponent(typeof(UISprite))

	NetworkDelay_Manager:addObserver(m.updateSignalInfo)

	m.bIsInitialed = true
end
----------------------------------------------------------------
--★refreshView
function ui_mobileInfo.updateBatteryInfo()
	if Application.platform == RuntimePlatform.Android then
		local capacity = io.open("/sys/class/power_supply/battery/capacity", "r")
		m.battery.value = tonumber(capacity:read()) / 100
	elseif Application.platform == RuntimePlatform.IPhonePlayer then
		-- TODO: ios电量
	end
end
function ui_mobileInfo.updateSignalInfo(networkDelay)
	print("刷新网络信号图标 "..networkDelay)
	if networkDelay < m.SignalState.GOOD then -- 0~150
		m.signal.spriteName = "zhujiemian_tubiao_xinhao_hao"
	elseif  networkDelay > m.SignalState.NORMAL and networkDelay < m.SignalState.BAD then -- 300~1000
		m.signal.spriteName = "zhujiemian_tubiao_xinhao_lianghao"
	else -- >1000ms
		m.signal.spriteName = "zhujiemian_tubiao_xinhao_cha"
	end
end
----------------------------------------------------------------
--★Show/Hide Control
function ui_mobileInfo.show()
	if m.bIsInitialed then
		m.root:SetActive(true)
	else
		m.initView()
		m.updateBatteryInfo()
		-- m.updateSignalInfo()
		m.root:SetActive(true)
	end
end
function ui_mobileInfo.hide()
	m.root:SetActive(false)
end
function ui_mobileInfo.destroy()
	UnityEngine.GameObject.Destroy(m.root)
	ui_mobileInfo = nil
end

return ui_mobileInfo