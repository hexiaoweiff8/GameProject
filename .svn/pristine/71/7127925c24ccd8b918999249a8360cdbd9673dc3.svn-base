-- 游戏初始化组件
local gameinit = class()

-- 单例
GameInit = nil

-- 登录窗体组件名列表
local lgwnds = {
    { name = WND.Login, cm = "wnd.wnd_login" },
    { name = WND.Healthadvice, cm = "wnd.wnd_healthadvice" }
}


-- 非登录窗体组件名列表
-- 窗体枚举 --对应的类名
local wndlist = {
--    { name = WND.Debug, cm = "wnd.wnd_debug" },
    { name = WND.Background, cm = "wnd.wnd_background" },
    { name = WND.Tuiguan, cm = "wnd.wnd_tuiguan" },
    { name = WND.Readyfight, cm = "wnd.wnd_readyfight" },
    { name = WND.Gainmethod, cm = "wnd.wnd_gainmethod" },
    { name = WND.AlphaTip, cm = "wnd.exui_AlphaTip" },
    { name = WND.BuZheng, cm = "wnd.wnd_buzheng" },
    { name = WND.Xilian, cm = "wnd.wnd_xilian" },

}

function gameinit:InitWnd(cmName)
    -- local wndNode = GameObject.new(cmName)
    -- wndNode:AddComponent(cmName)
    -- wndNode:DontDestroyOnLoad()--切换场景不自动销毁
    local newWndFunc = require(cmName);
    local wndcm = newWndFunc()
    wndcm:Start()
end
 


--- <summary>
--- 初始化窗体
--- </summary>
function gameinit:InitWnds(initPogressManage, wnds)

    local wndcount = #wnds
    local currIndex = 1
    print("gameinit:InitWnds#1");
    local eachfunc = function(_, wndInfo)
        local cmName = wndInfo.cm
        print("gameinit:InitWnds# ", cmName);
        initPogressManage:SetMissionPogress(currIndex / wndcount)
        -- 设置装载进度
        self:InitWnd(cmName)
        -- 初始化窗体
        currIndex = currIndex + 1
        print("gameinit:InitWnds2# ", cmName);
    end
    table.foreach(wnds, eachfunc)
    -- 遍历初始化所有窗体
    print("gameinit:InitWnds#99");
end


--- <summary>
--- 交叉逻辑初始化
--- </summary>
function gameinit:CrossInit(initPogressManage, wnds)

    print("gameinit:CrossInit#1");

    local wndcount = #wnds
    local currIndex = 1
    print("gameinit:CrossInit#2");

    local eachfunc = function(_, wndInfo)

        print("gameinit:CrossInit#4");

        local wndName = wndInfo.name
        initPogressManage:SetMissionPogress(currIndex / wndcount)
        -- 设置装载进度
        local wnd = Wnd.Get(wndName)
        print("gameinit:CrossInit#5.5");
        if (wnd.CrossInit ~= nil) then

            print("gameinit:CrossInit#5.6");
            wnd:CrossInit()
            print("gameinit:CrossInit#5.7");
        end

        print("gameinit:CrossInit#5.8");

        currIndex = currIndex + 1
    end

    print("gameinit:CrossInit#3");
    table.foreach(wnds, eachfunc)
    -- 遍历等待所有窗体组件准备就绪
end

-- 注册ui组建
function gameinit:RegUI()
    print("gameinit:RegUI#1")
    local sdata_uidefine = require "sdata.sdata_uidefine"
    local i_name = sdata_uidefine:Name2I("Name")
    local i_dependPacks = sdata_uidefine:Name2I("DependPacks")
    local i_sort = sdata_uidefine:Name2I("Sort")
    local i_cacheTime = sdata_uidefine:Name2I("CacheTime")
    local i_fadeMode = sdata_uidefine:Name2I("FadeMode")
    local i_animationMode = sdata_uidefine:Name2I("AnimationMode")

    local eachfunc = function(key, value)
        local name = value[i_name]
        local dependPacks = value[i_dependPacks]
        local sort = value[i_sort]
        local cacheTime = value[i_cacheTime]
        local fadeMode = value[i_fadeMode]
        local animationMode = value[i_animationMode]

        print("gameinit:RegUI#3", name)
        WndManage.RegWnd(name, dependPacks, sort, cacheTime, fadeMode, animationMode)
        -- 注册界面
    end
    sdata_uidefine:Foreach(eachfunc)
    print("gameinit:RegUI#2")
end


function gameinit:InitCSharpLogic(initPogressManage)
    LogicInit.Go()
    local progress = 0
    while (progress < 1) do
        progress = LogicInit.GetInitProgress()
        initPogressManage:SetMissionPogress(progress)
        Yield()
    end
end

function gameinit:FadeTitlesVideo(initPogressManage)
    Yield(0.2)
    initPogressManage:SetMissionPogress(0.2)
    Yield(0.2)
    initPogressManage:SetMissionPogress(0.4)
    Yield(0.2)
    initPogressManage:SetMissionPogress(0.6)
    Yield(0.2)
    initPogressManage:SetMissionPogress(0.8)
    Yield(0.2)
end


local PreloadPackets = nil-- 预装的界面资源包
function gameinit:PreloadLoadPacks(initPogressManage)
    -- 预装资源
    local packetLoader = PacketLoader.new()
    -- 创建一个包加载器

    PreloadPackets = WndManage.GetDependPackets(WND.Main, WND.Login, WND.PlayerCreate)

    packetLoader:Start(PreloadPackets)

    while (not packetLoader:IsDone()) do
        if (packetLoader:HasError()) then
            debug.LogError("预装资源包遇到错误");
            Application.Quit();
            while (true) do Yield() end
        end

        -- 设置装载进度
        local progress = packetLoader:GetProgress()
        initPogressManage:SetMissionPogress(progress)
        Yield()
    end

    -- 绑定登陆成功事件
    EventHandles.OnLoginSuccess:AddListener(self, self.OnLoginSuccess)
end

function gameinit:OnLoginSuccess(_)
    -- 卸载未被引用的预装包
    for _, packetName in pairs(PreloadPackets) do
        PacketManage.UnLoadUnusedPack(packetName)
    end
end


function gameinit:LoadSharedGameData(initPogressManage)
    local gamePlatform = GameObject.Find("/GamePlatform")

    local sdk = gamePlatform:GetComponent(CMGSCloudSDK.Name)
    local cmSharedGameDataLoad = SharedGameDataLoader.Load(sdk, "yq2", SystemInfo.deviceUniqueIdentifier())
    --


    while (cmSharedGameDataLoad:ResultKeyValues() == nil) do
        Yield()
        if (cmSharedGameDataLoad:ResultIsError()) then
            -- 发生了错误
            -- 弹出对话框
            local resultwait = MsgboxResultWait.new()
            -- 创建一个结果等待器
            MsgBox.Show("从网络获取用户数据遇到错误，是否重试?", "否", "是", resultwait, resultwait.OnMsgBoxClose)
            -- 显示对话框
            local result = resultwait:GetResult()
            -- 读取对话框返回结果
            if (result == 2) then
                -- 用户选择重新尝试
                cmSharedGameDataLoad = SharedGameDataLoader.Load(sdk, "yq2", SystemInfo.deviceUniqueIdentifier())
            else
                Application.Quit()
                -- 退出游戏
                while (true) do Yield() end
                -- 编辑器模式无法执行退出逻辑，因此用这行阻挡后面的逻辑
            end
        end
    end
end

function gameinit:coStartGame(parm)
    GameInit = self

    self.LogicPogressManage = ProgressStatistical.new()
    -- 逻辑数据后台加载进度统计实例
    -- 研发模式显示出fps
    Application.ShowFPS(debug.IsDev())

    -- 设置随机种子数
    math.randomseed(math.floor(os.clock()))

    self:RegUI()
    -- 注册ui界面
    wnd_event_listener:BindCoreEvt()
    -- 绑定窗体内核事件

    local luacore = GameObject.Find("/luacore")
    -- luacore:AddComponent("sound.cm_BackgroundMusic")--挂载背景音乐播放组件

    local initPogressManage = ProgressStatistical.new()
    -- 进度统计实例
    initPogressManage:SetRecall(self, self.OnGameInitPogressChanged)
    -- 设置进度变更回调

    -- 加载登录所需脚本代码
    initPogressManage:NewMission(0.2)
    FileRequire.RequireLoginCode(initPogressManage)

    print("gameinit:coStartGame#3");

    -- 初始化ui
    initPogressManage:NewMission(0.5)
    self:InitWnds(initPogressManage, lgwnds)
    print("gameinit:coStartGame#4");

    -- 交叉逻辑初始化
    initPogressManage:NewMission(0.8)
    self:CrossInit(initPogressManage, lgwnds)

    print("gameinit:coStartGame#5");
    -- 显示健康忠告界面
    wnd_healthadvice:Show()
    print("gameinit:coStartGame#6");

    -- 启动另外一个协程，后台装各种资源
    StartCoroutine(self, self.coLoading, { })

    while (wnd_healthadvice.isVisible) do Yield() end
    -- 等待健康忠告隐藏

--    -- 显示登陆界面
    wnd_login:Show()

    -- 显示登陆界面
--    wnd_xilian:Show()

    -- sc_main:JumpTo()--跳转到主城场景--]]
end


-- 后台装资源
function gameinit:coLoading(parm)
    local initPogressManage = self.LogicPogressManage

    print("gameinit:coLoading#0");

    -- 初始化c#逻辑
    initPogressManage:NewMission(0.4)
    self:InitCSharpLogic(initPogressManage)

    print("gameinit:coLoading#0.1");
    -- 初始化逻辑代码
    initPogressManage:NewMission(0.45)
    FileRequire.RequireLogicCode(initPogressManage)

    print("gameinit:coLoading#0.2");
    -- 初始化静态数据
    initPogressManage:NewMission(0.6)
    FileRequire.RequireSData(initPogressManage)

    print("gameinit:coLoading#1");
    -- 初始化ui
    initPogressManage:NewMission(0.65)
    self:InitWnds(initPogressManage, wndlist)
    print("gameinit:coLoading#1.1");

    -- 交叉逻辑初始化
    initPogressManage:NewMission(0.8)
    self:CrossInit(initPogressManage, wndlist)

    print("gameinit:coLoading#2");

    -- 初始化界面跳转管理器
    WndJumpManage:init()


    -- 卸载脚本资源包
    PacketManage.UnloadScriptPacks()

    -- 装载完成
    initPogressManage:NewMission(1)
    initPogressManage:SetMissionPogress(1)

    print("gameinit:coLoading#10");
end

function gameinit:OnPacketDone(isDone)
    self.mPacketLoadDone = true
end

function gameinit:Start()
    self.mPacketLoadDone = false
    StartCoroutine(self, self.coStartGame, { })
    -- 启动一个协程
end

return gameinit.new