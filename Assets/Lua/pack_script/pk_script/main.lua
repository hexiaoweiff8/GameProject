require "init._requirefiles"

--包含系统必备的lua
FileRequire.RequireBase()

local function InitEngine()
	local luacore = GameObject.new("luacore")--创建一个游戏物体
	
	luacore:AddComponent("lib.cm_coroutine")--挂载协程组件
	--luacore:AddComponent("network.cm_serverlink")--挂载serverlink组件
	
	luacore:DontDestroyOnLoad()--这个游戏物体切换场景不自动销毁
end

local function Start()
	print("********-----xxxxxxxxxxxxx------********first step")
	InitEngine()
	
	local gameinit = GameObject.new("gameinit")--创建一个游戏物体
	gameinit:AddComponent("init.cm_gameinit")--挂载游戏初始化组件
end

Start()