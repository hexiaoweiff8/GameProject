require 'uiscripts/login/ui_login_const'
--[[
	ui_login_controller:
		variable:
			sub_panel 子面板临时内存表
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			OnDestroyDone() extend wnd_base:OnDestroyDone()
]]
ui_login_controller = require("common/middleclass")("ui_login_controller",wnd_base)

local this = ui_login_controller
local CacheKey = "UserLoginCache"
local json = require 'uiscripts/login/ThirdParty/json'
local instance = nil

function ui_login_controller:OnShowDone()
	instance = self

	this.sub_panel = {}

	this:readLoginCache()
	-- printw(Application.persistentDataPath)
end
--[[
	loginCache = {
		{ username = string, password = string }
		{ username = string, password = string }
		{ ... }
	}
]]
function ui_login_controller:readLoginCache()
	function string.IsNullOrEmpty(str)
		if str == '' or str == nil then
			return true
		end
		return false
	end

	local cache = UnityEngine.PlayerPrefs.GetString(CacheKey)

	if string.IsNullOrEmpty(cache) then
		-- TODO: 弹出选择登录方式界面
		this:show_LOGIN_SELECT()
	else
		-- TODO: 弹出提示绑定/自动登录
	end
end
function ui_login_controller:writeLoginCache()
	-- TODO: 写入登录缓存
	UnityEngine.PlayerPrefs.SetString(CacheKey)
end
----------------------------------------------------------------
--★Show Sub Panel
--登录选择界面
function ui_login_controller:show_LOGIN_SELECT()
	local TAG = login_sub_panel.LOGIN_SELECT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_quickPlay = m_root:Find("btn_quickPlay").gameObject
		this.sub_panel[TAG].btn_phoneAccount = m_root:Find("btn_phoneAccount").gameObject
		this.sub_panel[TAG].btn_normalAccount = m_root:Find("btn_normalAccount").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_quickPlay)
		this.attachCollider(this.sub_panel[TAG].btn_phoneAccount)
		this.attachCollider(this.sub_panel[TAG].btn_normalAccount)

		UIEventListener.Get(this.sub_panel[TAG].btn_quickPlay).onClick = function()
			-- TODO: 快速游戏
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_phoneAccount).onClick = function()
			-- TODO: 登录手机账号
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_normalAccount).onClick = function()
			-- TODO: 登录QK账号
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--使用手机登录界面
function ui_login_controller:show_LOGIN_BY_PHONE()
	local TAG = login_sub_panel.LOGIN_BY_PHONE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_reg = m_root:Find("btn_reg").gameObject
		this.sub_panel[TAG].btn_login = m_root:Find("btn_login").gameObject
		this.sub_panel[TAG].btn_forgetPassword = m_root:Find("btn_forgetPassword").gameObject
		this.sub_panel[TAG].InputField_phoneNumber = m_root:Find("InputField_phoneNumber").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_reg)
		this.attachCollider(this.sub_panel[TAG].btn_login)
		this.attachCollider(this.sub_panel[TAG].btn_forgetPassword)
		this.attachCollider(this.sub_panel[TAG].InputField_phoneNumber)
		this.attachCollider(this.sub_panel[TAG].InputField_password)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg).onClick = function()
			-- TODO: 新用户注册
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- TODO: 登录
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_forgetPassword).onClick = function()
			-- TODO: 忘记密码界面
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--本地账号登录界面
function ui_login_controller:show_LOGIN_LOCAL()
	local TAG = login_sub_panel.LOGIN_LOCAL

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].AccountInfoSelect = m_root:Find("AccountInfoSelect").gameObject
		this.sub_panel[TAG].btn_login = m_root:Find("btn_login").gameObject
		this.sub_panel[TAG].btn_other = m_root:Find("btn_other").gameObject

		this.attachCollider(this.sub_panel[TAG].AccountInfoSelect)
		this.attachCollider(this.sub_panel[TAG].btn_login)
		this.attachCollider(this.sub_panel[TAG].btn_other)

		UIEventListener.Get(this.sub_panel[TAG].AccountInfoSelect).onClick = function()
			-- TODO: 账户选择
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- TODO: 登录
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_other).onClick = function()
			-- TODO: 其他方式登录
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--选择绑定界面
function ui_login_controller:show_LOGIN_SELECTBIND()
	local TAG = login_sub_panel.LOGIN_SELECTBIND

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_phoneAccount = m_root:Find("btn_phoneAccount").gameObject
		this.sub_panel[TAG].btn_normalAccount = m_root:Find("btn_normalAccount").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_login)
		this.attachCollider(this.sub_panel[TAG].btn_other)

		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- TODO: 绑定手机账户
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_other).onClick = function()
			-- TODO: 绑定普通账户
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--注册普通账号界面
function ui_login_controller:show_REG_NORMALACCOUNT()
	local TAG = login_sub_panel.REG_NORMALACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_reg_by_phone = m_root:Find("btn_reg_by_phone").gameObject
		this.sub_panel[TAG].btn_serviceAgreement = m_root:Find("btn_serviceAgreement").gameObject
		this.sub_panel[TAG].InputField_phoneNumber = m_root:Find("InputField_phoneNumber").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].btn_reg = m_root:Find("btn_reg").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_reg_by_phone)
		this.attachCollider(this.sub_panel[TAG].btn_serviceAgreement)
		this.attachCollider(this.sub_panel[TAG].InputField_phoneNumber)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].btn_reg)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg_by_phone).onClick = function()
			-- TODO: 跳转通过手机注册界面
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- TODO: 奇快网络服务协议
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg).onClick = function()
			-- TODO: 注册按钮
		end

	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--注册手机账号界面
function ui_login_controller:show_REG_PHONEACCOUNT()
	local TAG = login_sub_panel.REG_PHONEACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].Title = m_root:Find("Title").gameObject
		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_reg_normalAccount = m_root:Find("btn_reg_normalAccount").gameObject
		this.sub_panel[TAG].btn_serviceAgreement = m_root:Find("btn_serviceAgreement").gameObject
		this.sub_panel[TAG].InputField_SMS_vcode = m_root:Find("InputField_SMS_vcode").gameObject
		this.sub_panel[TAG].btn_resend = m_root:Find("InputField_SMS_vcode/btn_resend").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].btn_reg_login = m_root:Find("btn_reg_login").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_reg_normalAccount)
		this.attachCollider(this.sub_panel[TAG].btn_serviceAgreement)
		this.attachCollider(this.sub_panel[TAG].InputField_SMS_vcode)
		this.attachCollider(this.sub_panel[TAG].btn_resend)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].btn_reg_login)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg_normalAccount).onClick = function()
			-- TODO: 跳转普通账户注册界面
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- TODO: 奇快网络服务协议
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- TODO: 重新发送短信验证码
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg_login).onClick = function()
			-- TODO: 注册并登录按钮
		end

	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--实名认证系统说明界面
function ui_login_controller:show_REALNAME_DESCRIPTION()
	local TAG = login_sub_panel.REALNAME_DESCRIPTION

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--实名认证界面
function ui_login_controller:show_REALNAME_AUTHENTICATION()
	local TAG = login_sub_panel.REALNAME_AUTHENTICATION

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].btn_description = m_root:Find("btn_description").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].InputField_name = m_root:Find("InputField_name").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].btn_description)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].InputField_name)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_description).onClick = function()
			-- TODO: 实名认证系统说明按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--绑定邮箱界面
function ui_login_controller:show_BIND_MAILBOX()
	local TAG = login_sub_panel.BIND_MAILBOX

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].InputField_MailInfo = m_root:Find("InputField_MailInfo").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_MailInfo)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
		end

	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--绑定手机界面
function ui_login_controller:show_BIND_PHONE()
	local TAG = login_sub_panel.BIND_PHONE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].InputField_PhoneNumber = m_root:Find("InputField_PhoneNumber").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_PhoneNumber)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
		end

	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--绑定手机界面
function ui_login_controller:show_BIND_PHONE_1()
	local TAG = login_sub_panel.BIND_PHONE_1

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].InputField_phoneNumber = m_root:Find("InputField_phoneNumber").gameObject
		this.sub_panel[TAG].btn_nextStep = m_root:Find("btn_nextStep").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_phoneNumber)
		this.attachCollider(this.sub_panel[TAG].btn_nextStep)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_nextStep).onClick = function()
			-- TODO: 下一步按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--绑定手机输入验证码界面
function ui_login_controller:show_BIND_PHONE_VCODE()
	local TAG = login_sub_panel.BIND_PHONE_VCODE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].AccountPhoneNumber = m_root:Find("AccountPhoneNumber").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_SMS_verificationCode = m_root:Find("InputField_SMS_verificationCode").gameObject
		this.sub_panel[TAG].btn_resend = m_root:Find("btn_resend").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_SMS_verificationCode)
		this.attachCollider(this.sub_panel[TAG].btn_resend)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- TODO: 重新发送按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--绑定QK账号界面
function ui_login_controller:show_BIND_QKACCOUNT()
	local TAG = login_sub_panel.BIND_QKACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_bind_phone = m_root:Find("btn_bind_phone").gameObject
		this.sub_panel[TAG].btn_serviceAgreement = m_root:Find("btn_serviceAgreement").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_QKAccount = m_root:Find("InputField_QKAccount").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].btn_bind = m_root:Find("btn_bind").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_bind_phone)
		this.attachCollider(this.sub_panel[TAG].btn_serviceAgreement)
		this.attachCollider(this.sub_panel[TAG].InputField_QKAccount)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].btn_bind)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_phone).onClick = function()
			-- TODO: 跳转绑定手机界面按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- TODO: 查看服务协议按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind).onClick = function()
			-- TODO: 确认绑定按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--绑定手机账号界面
function ui_login_controller:show_BIND_PHONEACCOUNT()
	local TAG = login_sub_panel.BIND_PHONEACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].Title = m_root:Find("Title").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_bind_QK = m_root:Find("btn_bind_QK").gameObject
		this.sub_panel[TAG].btn_serviceAgreement = m_root:Find("btn_serviceAgreement").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_SMS_vcode = m_root:Find("InputField_SMS_vcode").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].btn_resend = m_root:Find("InputField_SMS_vcode/btn_resend").gameObject
		this.sub_panel[TAG].btn_bind_login = m_root:Find("btn_bind_login").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_bind_QK)
		this.attachCollider(this.sub_panel[TAG].btn_serviceAgreement)
		this.attachCollider(this.sub_panel[TAG].InputField_SMS_vcode)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].btn_resend)
		this.attachCollider(this.sub_panel[TAG].btn_bind_login)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_QK).onClick = function()
			-- TODO: 跳转绑定奇快界面按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- TODO: 查看服务协议按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- TODO: 重新发送短信验证码按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_login).onClick = function()
			-- TODO: 绑定并登录按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--找回密码途径界面
function ui_login_controller:show_PWDGETBACK_PATH()
	local TAG = login_sub_panel.PWDGETBACK_PATH

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_phoneAccount = m_root:Find("btn_phoneAccount").gameObject
		this.sub_panel[TAG].btn_normalAccount = m_root:Find("btn_normalAccount").gameObject:GetComponent(typeof(UILabel))

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_phoneAccount)
		this.attachCollider(this.sub_panel[TAG].btn_normalAccount)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_phoneAccount).onClick = function()
			-- TODO: 使用手机找回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_normalAccount).onClick = function()
			-- TODO: 使用QK找回按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--通过手机找回,输入手机号界面
function ui_login_controller:show_PWDGETBACK_BY_PHONE()
	local TAG = login_sub_panel.PWDGETBACK_BY_PHONE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].InputField_phoneNumber = m_root:Find("InputField_phoneNumber").gameObject
		this.sub_panel[TAG].btn_login = m_root:Find("btn_login").gameObject:GetComponent(typeof(UILabel))

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].InputField_phoneNumber)
		this.attachCollider(this.sub_panel[TAG].btn_login)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- TODO: 使用手机找回按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--通过手机找回,输入手机验证码界面
function ui_login_controller:show_PWDGETBACK_BY_PHONE_VCODE()
	local TAG = login_sub_panel.PWDGETBACK_BY_PHONE_VCODE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].AccountPhoneNumber = m_root:Find("AccountPhoneNumber").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_SMS_verificationCode = m_root:Find("InputField_SMS_verificationCode").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject:GetComponent(typeof(UILabel))

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_SMS_verificationCode)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--修改密码界面
function ui_login_controller:show_MODIFY_PASSWORD()
	local TAG = login_sub_panel.MODIFY_PASSWORD

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].InputField_oldPassword = m_root:Find("InputField_oldPassword").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_newPassword = m_root:Find("InputField_newPassword").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject:GetComponent(typeof(UILabel))

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_oldPassword)
		this.attachCollider(this.sub_panel[TAG].InputField_newPassword)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--修改密码界面
function ui_login_controller:show_QUICKGAME_TIPS()
	local TAG = login_sub_panel.QUICKGAME_TIPS

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_bind = m_root:Find("btn_bind").gameObject
		this.sub_panel[TAG].btn_ignore = m_root:Find("btn_ignore").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_bind)
		this.attachCollider(this.sub_panel[TAG].btn_ignore)

		UIEventListener.Get(this.sub_panel[TAG].btn_bind).onClick = function()
			-- TODO: 跳转绑定方式界面按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_ignore).onClick = function()
			-- TODO: 忽略按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--用户中心界面
-- TODO: 用户中心界面打开时需要判断部分按钮是否显示
function ui_login_controller:show_USERCENTER()
	local TAG = login_sub_panel.USERCENTER

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].AccountIdentity = m_root:Find("AccountIdentity").gameObject
		this.sub_panel[TAG].AccountName = m_root:Find("AccountName").gameObject
		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_switch = m_root:Find("btn_switch").gameObject
		this.sub_panel[TAG].btn_bind_Account = m_root:Find("btn_bind_Account").gameObject
		this.sub_panel[TAG].btn_bind_Phone = m_root:Find("btn_bind_Phone").gameObject
		this.sub_panel[TAG].btn_bind_MailBox = m_root:Find("btn_bind_MailBox").gameObject
		this.sub_panel[TAG].btn_realName = m_root:Find("btn_realName").gameObject
		this.sub_panel[TAG].btn_modifyPwd = m_root:Find("btn_modifyPwd").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_switch)
		this.attachCollider(this.sub_panel[TAG].btn_bind_Account)
		this.attachCollider(this.sub_panel[TAG].btn_bind_Phone)
		this.attachCollider(this.sub_panel[TAG].btn_bind_MailBox)
		this.attachCollider(this.sub_panel[TAG].btn_realName)
		this.attachCollider(this.sub_panel[TAG].btn_modifyPwd)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- TODO: 返回按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_switch).onClick = function()
			-- TODO: 切换账户按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_Account).onClick = function()
			-- TODO: 绑定账户按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_Phone).onClick = function()
			-- TODO: 绑定手机按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_MailBox).onClick = function()
			-- TODO: 绑定邮箱按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_realName).onClick = function()
			-- TODO: 实名认证按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_modifyPwd).onClick = function()
			-- TODO: 修改密码按钮
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
----------------------------------------------------------------
--★Util
function ui_login_controller.attachCollider(gobj)
	local widget = gobj:GetComponent(typeof(UIWidget))
	gobj:AddComponent(typeof(UnityEngine.BoxCollider))
	widget:ResizeCollider()
end

return ui_login_controller