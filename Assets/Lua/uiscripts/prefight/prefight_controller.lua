local class = require("common/middleclass")
local ui_prefight = class("ui_prefight", wnd_base)
local _data
local _view
local loadCoroutine
local UICoroutine

--窗体显示完成
function ui_prefight:OnShowDone()
	ui_prefight = self
	require("uiscripts/fight/AStarControl")
	require("uiscripts/fight/CanNotArea")
	_view = require("uiscripts/prefight/prefight_view")
	_data = require("uiscripts/prefight/prefight_model")
	_view:InitView(self)
	_data:InitData()
	UIEventListener.Get(_view.OnLineButton).onClick = function(gObj)
		if loadCoroutine then
			return
		end

		loadCoroutine = coroutine.start(function()
			_view.tip:SetActive(true)
			_view.tip:GetComponent("UILabel").text = "正在加载请稍后"
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
				_view.tip:GetComponent("UILabel").text = "正在加载请稍后"..str
			end
			_view.tip:GetComponent("UILabel").text = "加载完成"
			coroutine.wait(0.1)
			loadCoroutine = nil
			ui_manager:DestroyWB(self)
			ui_manager:ShowWB(WNDTYPE.ui_fight)

		end)

	end

	UIEventListener.Get(_view.OffLineButton).onClick = function(gObj)
		if UICoroutine then
			return
		end
		if loadCoroutine then
			return
		end
		local isLoadDataDone = false
		local isLoadSceneDone = false
		local isInitModelDone = false
		UICoroutine = coroutine.start(function()
			_view.tip:SetActive(true)
			_view.tip:GetComponent("UILabel").text = "正在加载请稍后"
			local tick = 0
			while not isLoadDataDone or not isLoadSceneDone or not isInitModelDone do
				local eventStr
				if isLoadDataDone then
					if isLoadSceneDone then
						if not isInitModelDone then
							eventStr = "正在应用数据"
						end
					else
						eventStr = "正在加载场景"
					end
				else
					eventStr = "正在加载数据"
				end
				tick = tick + 1
				local dotStr = ""
				for i = 0, tick % 4 do
					if i == 0 then
						dotStr = ""
					else
						dotStr = dotStr.."."
					end
				end
				_view.tip:GetComponent("UILabel").text = eventStr..dotStr
				coroutine.wait(0.1)
			end
			_view.tip:GetComponent("UILabel").text = "加载完成"
			coroutine.wait(0.1)
			ui_manager:DestroyWB(self)
			ui_manager:ShowWB(WNDTYPE.ui_fight)
		end)


		loadCoroutine = coroutine.start(function()
			---等待数据加载完成
			_data:LoadFightData(function()
				isLoadDataDone = true
			end)
			-- 设置数据直接开始
			WndManage.Single:LogicInitPackage()
			SceneChanger.LoadFight(function()
				self.startFightWithOfflineAction()
				isLoadSceneDone = true
			end)
			while not isLoadSceneDone do
				coroutine.wait(0.1)
			end

			_data:InitModelData(function()
				isInitModelDone = true
			end)
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

function ui_prefight:OnDestroyDone()
	Memory.free("uiscripts/prefight/prefight_view")
	Memory.free("uiscripts/prefight/prefight_model")
	_data = nil
	_view = nil
	loadCoroutine = nil
	UICoroutine = nil
end
return ui_prefight