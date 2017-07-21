-- 游戏初始化组件
require "framework/classWC"
require "framework/luacsv"
require 'events'
require "common/protocal"
require "manager/Config_Manager"
require("uiscripts/equipP")
require("uiscripts/kejiP")
require("uiscripts/Const")
require("uiscripts/commonModel/card_Model")
require("uiscripts/commonModel/user_Model")
require("uiscripts/commonModel/item_Model")
require("uiscripts/commonModel/currency_Model")
require("uiscripts/commonModel/equip_Model")

--引用工具类
require("uiscripts/Util/stringUtil")
require("uiscripts/Util/cardUtil")
require("uiscripts/Util/colorUtil")
require("uiscripts/Util/spriteNameUtil")
require("uiscripts/Util/attributeUtil")
require("uiscripts/Util/equipSuitUtil")
require("uiscripts/Util/synergyUtil")
require("uiscripts/Util/skillUtil")
require("uiscripts/Util/starUtil")
require("uiscripts/Util/itemUtil")
require("uiscripts/Util/qualityUtil")
require("uiscripts/Util/equipUtil")
require("uiscripts/Util/dotweenUtil")
require("uiscripts/Util/borderUtil")




gameinit = classWC()
-- 单例
GameInit = nil


WNDTYPE = {
    None = "None",
    Login = "ui_login",
    Healthadvice = "ui_healthadvice",
    Prefight = "ui_prefight",
    ui_fight = "ui_fightU",
    ui_pause = "ui_pauseU",
    ui_quitGame = "ui_quitGame",
    quiteEnsure_ui = "ui_quiteensure",
    ui_equip = "ui_equip",
    ui_equip2 = "ui_equip2",
    ui_chongzhu = "ui_chongzhu",
    ui_keji_jiasu = "ui_keji_jiasu",
    ui_kejitree = "ui_kejitree",
    Cardyc = "ui_cardyc",
    Cangku = "ui_cangku",
    QianDao = "ui_qiandao",
}
UiDefine = luacsv.new(require("pk_tabs/UiDefine"))
-- 登录窗体组件名列表 
local lgwnds = {
    {name = WNDTYPE.Healthadvice, cm = "uiscripts/wnd_healthadvice"}
}
-- 窗体枚举 --对应文件名
gameinit.wndlist = {
    {name = WNDTYPE.Login, cm = "uiscripts/wndtz_login"},
    {name = WNDTYPE.ui_fight, cm = "uiscripts/ui_fight"},
    {name = WNDTYPE.ui_pause, cm = "uiscripts/ui_pause"},
    {name = WNDTYPE.ui_quitGame, cm = "uiscripts/ui_quitGame"},
    {name = WNDTYPE.quiteEnsure_ui, cm = "uiscripts/ui_pause"},
    {name = WNDTYPE.Prefight, cm = "uiscripts/wnd_prefight"},
    {name = WNDTYPE.ui_equip2, cm = "uiscripts/myEquip/equip_controller"},
    {name = WNDTYPE.ui_equip, cm = "uiscripts/ui_equip"},
    {name = WNDTYPE.ui_chongzhu, cm = "uiscripts/ui_chongzhu"},
    {name = WNDTYPE.ui_keji_jiasu, cm = "uiscripts/ui_keji_jiasu"},
    {name = WNDTYPE.ui_kejitree, cm = "uiscripts/ui_kejitree"},
    {name = WNDTYPE.Cardyc, cm = "uiscripts/cardyc/wnd_cardyc_controller"},
    {name = WNDTYPE.Cangku, cm = "uiscripts/cangku/wnd_cangku_controller"},
    {name = WNDTYPE.QianDao, cm = "uiscripts/qiandao/wnd_qiandao_controller"},
}
_all_Reg_Wnd_list = {}
--- <summary>
--- 初始化窗体
--- </summary>
function gameinit:InitWnds(initPogressManage, wnds)
    local wndcount = #wnds
    local currIndex = 1
    local eachfunc = function(_, wndInfo)
            -- 设置装载进度
            require(wndInfo.cm)(wndInfo.name)
            -- 初始化窗体
            currIndex = currIndex + 1
    end
    table.foreach(wnds, eachfunc)
end
-- 注册ui组建
function gameinit:RegUI()
    print("gameinit:RegUI#1")
    local i_name = UiDefine:Name2I("Name")
    local i_dependPacks = UiDefine:Name2I("DependPacks")
    local i_cacheTime = UiDefine:Name2I("CacheTime")
    local i_fadeMode = UiDefine:Name2I("FadeMode")
    local i_animationMode = UiDefine:Name2I("AnimationMode")
    local eachfunc = function(key, value)
        local name = value[i_name]
        local dependPacks = value[i_dependPacks]
        local cacheTime = value[i_cacheTime]
        local fadeMode = value[i_fadeMode]
        local animationMode = value[i_animationMode]
        WndManage.Single:RegWnd1(name, dependPacks, cacheTime, fadeMode, animationMode)
    -- 注册界面
    end
    UiDefine:Foreach(eachfunc)
end
function gameinit:InitCSharpLogic(initPogressManage)
    WndManage.Single:LogicInit_Go()
    StartCoroutine(ok)
end
function ok()
    local progress = WndManage.Single:LogicInit_GetInitProgress()
    if (progress < 1) then
        WaitForSeconds(1)
        StartCoroutine(ok)
        return
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
local PreloadPackets = nil -- 预装的界面资源包
function gameinit:PreloadLoadPacks(initPogressManage)
    -- 预装资源
    local packetLoader = PacketLoader.new()
    -- 创建一个包加载器
    PreloadPackets = WndManage.GetDependPackets(WNDTYPE.Main, WNDTYPE.Login, WNDTYPE.PlayerCreate)
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
    -- GameInit = self
    -- 注册ui界面
    self:RegUI()
    self:InitWnds(initPogressManage, lgwnds)
    require "uiscripts/ui_manager"
    ui_manager = ui_manager()
    ui_manager:ShowWB(WNDTYPE.Healthadvice)
    self:coLoading();

end
-- 后台装资源
function gameinit:coLoading(parm)
    self:InitCSharpLogic(initPogressManage)
    self:InitWnds(initPogressManage, self.wndlist)
end
function gameinit:OnPacketDone(isDone)
    self.mPacketLoadDone = true
end
function gameinit:GameStart()
    GameObject.Find("GameManager"):AddComponent(typeof(LuaBehaviour)):Init(self)
    self.mPacketLoadDone = false
    self:coStartGame()
    -- 启动一个协程 加载数据
    Config_Manager:LoadConfig()
end
-- --贯穿整个游戏生命周期
-- function gameinit:Update()
--     if Input.GetKeyDown(UnityEngine.KeyCode.Escape) then
--         lgyPrint("EscapeEscapeEscapeEscapeEscape")
--     end
-- end
GameInit = gameinit.new()
GameInit:GameStart()
return gameinit.new
