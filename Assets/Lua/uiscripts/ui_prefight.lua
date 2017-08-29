local class = require("common/middleclass")
local ui_prefight = class("ui_prefight", wnd_base)

--窗体显示完成
function ui_prefight:OnShowDone()
	ui_prefight = self

	self.OnLineButton = self.transform:Find("onlineButton").gameObject	    -- 在线战斗
	self.OffLineButton = self.transform:Find("offlineButton").gameObject	-- 离线战斗
	self.tip = self.transform:Find("tip").gameObject
	self.tip:SetActive(false)
	local loadCoroutine
	UIEventListener.Get(self.OnLineButton).onClick = function(gObj)
		if loadCoroutine then
			return
		end

		loadCoroutine = coroutine.start(function()
			self.tip:SetActive(true)
			self.tip:GetComponent("UILabel").text = "正在加载请稍后"
			local isLoadDone = false
			-- 等待数据
			WndManage.Single:LogicInitPackage()
			SceneChanger.LoadFight(function()
				self.startFightWithOnlineAction()
				isLoadDone = true
			end)
			local tick = 0
			while not isLoadDone do
				coroutine.wait(0.1)
				tick = tick + 1
				local str = ""
				for i = 0, tick % 4 do
					if i == 0 then
						str = ""
					else
						str = str.."."
					end
				end
				self.tip:GetComponent("UILabel").text = "正在加载请稍后"..str
			end
			self.tip:GetComponent("UILabel").text = "加载完成"
			coroutine.wait(0.1)
			loadCoroutine = nil
			ui_manager:DestroyWB(self)
			ui_manager:ShowWB(WNDTYPE.ui_fight)


		end)

	end

	UIEventListener.Get(self.OffLineButton).onClick = function(gObj)
		if loadCoroutine then
			return
		end
		loadCoroutine = coroutine.start(function()
			self.tip:SetActive(true)
			self.tip:GetComponent("UILabel").text = "正在加载请稍后"
			local isLoadDone = false
			-- 设置数据直接开始
			WndManage.Single:LogicInitPackage()
			SceneChanger.LoadFight(function()
				self.startFightWithOfflineAction()
				isLoadDone = true
			end)
			local tick = 0
			while not isLoadDone do
				coroutine.wait(0.1)
				tick = tick + 1
				local str = ""
				for i = 0, tick % 4 do
					if i == 0 then
						str = ""
					else
						str = str.."."
					end
				end
				self.tip:GetComponent("UILabel").text = "正在加载请稍后"..str
			end
			self.tip:GetComponent("UILabel").text = "加载完成"
			coroutine.wait(0.1)
			loadCoroutine = nil
			ui_manager:DestroyWB(self)
			ui_manager:ShowWB(WNDTYPE.ui_fight)

		end)

	end

end

function ui_prefight:startFightWithOfflineAction()
	-- TODO 构建测试地图数据
	local mapDataPach = MapManager.MapDataParamsPacker.New()
	mapDataPach.MapId = 1
	mapDataPach.BaseLevel = 1
	mapDataPach.TurretLevel = 1
	mapDataPach.Race = 0
	mapDataPach.EnemyBaseLevel = 1
	mapDataPach.EnemyTurretLevel = 1
	mapDataPach.EnemyRace = 0

	FightManager.Single:StartFight(1, mapDataPach, false)
end


function ui_prefight:startFightWithOnlineAction()
	-- TODO 构建测试地图数据
	local mapDataPach = MapManager.MapDataParamsPacker.New()
	mapDataPach.MapId = 1
	mapDataPach.BaseLevel = 1
	mapDataPach.TurretLevel = 1
	mapDataPach.Race = 0
	mapDataPach.EnemyBaseLevel = 1
	mapDataPach.EnemyTurretLevel = 1
	mapDataPach.EnemyRace = 0

	FightManager.Single:StartFight(1, mapDataPach, true)
end
return ui_prefight