local class = require("common/middleclass")
local ui_prefight = class("ui_prefight", wnd_base)





--窗体显示完成
function ui_prefight:OnShowDone()
	ui_prefight = self

	-- 开始离线游戏
	local startFightWithOfflineAction = function()

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

	-- 开始在线游戏
	local startFightWithOnlineAction = function()

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


	SceneChanger.LoadChooseFight(function()
		self.OnLineButton = self.transform:Find("onlineButton").gameObject	    -- 在线战斗
		self.OffLineButton = self.transform:Find("offlineButton").gameObject	-- 离线战斗

		UIEventListener.Get(self.OnLineButton).onClick = 
		function(gObj)
			-- 等待数据
	    	SceneChanger.LoadFight(startFightWithOnlineAction)
		end
		UIEventListener.Get(self.OffLineButton).onClick = 
		function(gObj)
			-- 设置数据直接开始
	    	SceneChanger.LoadFight(startFightWithOfflineAction)
		end
	end)


end

return ui_prefight