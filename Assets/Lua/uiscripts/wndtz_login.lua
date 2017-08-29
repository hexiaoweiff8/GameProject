require("manager/Message_Manager")
Message_Manager = Message_Manager()
--region *.lua
--Date 20150804
--登陆界面
--作者 wenchuan
local class_wnd_login = require("common/middleclass")("class_wnd_login", wnd_base)

local instance = nil
-- 外部登录SDK实例
local login_sdk_instance = nil
local hasLogged = false

function class_wnd_login:OnShowDone()
    instance = self
    -- 初始化外部登录sdk
    self:initLoginSDK()
    -- self:initServerPanel()
end
function class_wnd_login:OnDestroyDone()

end
-- 登录成功后使用的入口点
function class_wnd_login.LoginEntryPoint()
    ui_manager:ShowWB(WNDTYPE.Prefight)
    -- ui_manager:ShowWB(WNDTYPE.Main)
end
-- 当外部登录渠道登录成功时执行的回调
function class_wnd_login:HandleOnLoginSuccessful()
    Message_Manager:SendPB_10001()
    hasLogged = true
    instance.btn_userCenter:SetActive(true)
end
function class_wnd_login:OnAddHandler()
    Message_Manager:OnAddHandler()
end
function class_wnd_login:initLoginSDK()
    self.background = instance.transform:Find("background").gameObject
    self.btn_userCenter = instance.transform:Find("btn_userCenter").gameObject
    self.btn_selectServer = instance.transform:Find("btn_selectServer").gameObject
    self.server_label = instance.transform:Find("btn_selectServer/Server").gameObject:GetComponent(typeof(UILabel))

    local function initLoginSDK()
        ui_manager:ShowWB(WNDTYPE.Login_Reg)
        login_sdk_instance = ui_login_controller
        -- 向外部登录工具注册登录成功时的回调
        login_sdk_instance:RegisterOnLoginSuccessfulCallback(self.HandleOnLoginSuccessful)
    end
    local function loginSDK()
        -- 连接外部登录渠道
        login_sdk_instance:HandleOnLoginButtonClick()
    end

    UIEventListener.Get(self.btn_userCenter).onClick = function()
        login_sdk_instance:show_USERCENTER()
    end
    UIEventListener.Get(self.background).onClick = function()
        if not hasLogged then
            loginSDK()
            return
        end
        self.LoginEntryPoint()
    end
    -- 未登录时隐藏用户中心图标
    self.btn_userCenter:SetActive(false)
    initLoginSDK()
end
-- 初始化选择服务器界面
function class_wnd_login:initServerPanel()
    self.server_panel = {
        btn_close = instance.transform:Find("panel_server/btn_close").gameObject,
        serveRecommend = instance.transform:Find("panel_server/sp_recommend/p_serveRecommend").gameObject,
        serveRecently = instance.transform:Find("panel_server/sp_recommend/p_serveRecently").gameObject,
        areaList = instance.transform:Find("panel_server/sp_areaList/Panel_areaList").gameObject,
        serverList = instance.transform:Find("panel_server/Panel_serverList").gameObject,
        prefab_areaBtn = instance.transform:Find("panel_server/prefabs/btn_area").gameObject,
        prefab_serveBtn = serveRecommend,
    }
    self.server_panel.panel = instance.transform:Find("panel_server").gameObject

    self.attachCollider(self.server_panel.btn_close)

    -- UIEventListener.Get(self.btn_selectServer).onClick = function()
    --     self.server_panel.panel:SetActive(true)
    -- end
    -- UIEventListener.Get(self.server_panel.btn_close).onClick = function()
    --     self.server_panel.panel:SetActive(false)
    -- end
end
function class_wnd_login.attachCollider(gobj)
    local widget = gobj:GetComponent(typeof(UIWidget))
    gobj:AddComponent(typeof(UnityEngine.BoxCollider))
    widget:ResizeCollider()
end

return class_wnd_login
