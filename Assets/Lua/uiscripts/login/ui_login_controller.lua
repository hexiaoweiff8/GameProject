require 'uiscripts/login/ui_login_const'
require 'uiscripts/login/SDK_Util'
--[[
	ui_login_controller:
		variable:
			sub_panel 子面板临时内存表
			loginCache 用户登录缓存表
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			OnDestroyDone() extend wnd_base:OnDestroyDone()
			readLoginCache() 读取本地登录缓存文件
			writeLoginCache() 写入用户登录内存到本地文件中
			initLoginCache() 初始化用户登录内存数据
			GetTokenAndUserinfo() 使用上次登录账号获取token
			clearAllInput(root) 清空子界面UIInput的内容

			HandleOnLoginButtonClick() 当登录按钮按下时
			RegisterOnLoginSuccessfulCallback() 向此界面注册当登录成功时的回调函数
]]
ui_login_controller = require("common/middleclass")("ui_login_controller",wnd_base)

local this = ui_login_controller
local CacheKey = "UserLoginCache"
local json = require 'uiscripts/login/ThirdParty/json'
local SDK = nil
local instance = nil
local OnLoginSuccessfulCallback = nil

function ui_login_controller:OnShowDone()
	instance = self

	SDK = SDK_Util.new()

	this.sub_panel = {}

	this:readLoginCache()
	-- printw(Application.persistentDataPath)
end
function ui_login_controller:OnDestroyDone()
	--释放登录界面字符串表,工具类表
	Memory.free('uiscripts/login/ui_login_const')
	Memory.free('uiscripts/login/SDK_Util')
	Memory.free('uiscripts/login/ThirdParty/json')
	Memory.free('uiscripts/login/ui_login_controller')
	this.sub_panel = nil
	this.loginCache = nil
	instance = nil
	json = nil
	SDk = nil
	--清理登录界面使用的临时全局方法
	getDeviceUniqueIdentifier = nil
	ui_login_controller = nil
end
----------------------------------------------------------------
--★外部接口
function ui_login_controller:HandleOnLoginButtonClick()
	-- DONE: 如果是临时账号则弹出提示绑定/自动登录
	-- DONE: 弹出选择登录方式界面
	if this.loginCache.isTemp then
		this:show_LOGIN_SELECT()
	else
		local token,userinfo = this:GetTokenAndUserinfo()
		if not string.IsNullOrEmpty(token) then
			this.saveUserinfo2CurrentUser(userinfo)
		    UIToast.Show(
		    	"欢迎回来 "..this.loginCache.UserList[this.loginCache.CurrentUserIndex].username)
		    this:OnLoginSuccessful()
		else
			error("token is nil.")
		end
	end
end
function ui_login_controller:RegisterOnLoginSuccessfulCallback(callback)
	if callback ~= nil and type(callback) == 'function' then
		OnLoginSuccessfulCallback = callback
	end
end
----------------------------------------------------------------
--★Show Sub Panel 
--登录选择界面
function ui_login_controller:show_LOGIN_SELECT(PreviousPanelShowCallback)
	local TAG = login_sub_panel.LOGIN_SELECT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_quickPlay = m_root:Find("btn_quickPlay").gameObject
		this.sub_panel[TAG].btn_phoneAccount = m_root:Find("btn_phoneAccount").gameObject
		this.sub_panel[TAG].btn_normalAccount = m_root:Find("btn_normalAccount").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_quickPlay)
		this.attachCollider(this.sub_panel[TAG].btn_phoneAccount)
		this.attachCollider(this.sub_panel[TAG].btn_normalAccount)

		UIEventListener.Get(this.sub_panel[TAG].btn_quickPlay).onClick = function()
			-- DONE: 快速游戏
			this.sub_panel[TAG].root:SetActive(false)

			if this.loginCache.isTemp and this.loginCache.LastLoginTime ~= nil then
				this:show_QUICKGAME_TIPS()
			else
				local tempUserName = this.genTempUsername()

				local retCode = SDK.send_USERNAME_REGISTER(tempUserName,getDeviceUniqueIdentifier(),getDeviceUniqueIdentifier())

				if retCode == "SUCCESS" or retCode == "USER_HAVE_REG" then
					local retCode,token = SDK.send_GET_TOKEN(tempUserName,getDeviceUniqueIdentifier())
					if not string.IsNullOrEmpty(token) then
						this.loginCache.isTemp = true
						this.loginCache.LastLoginTime = os.time()
						this:OnLoginSuccessful()
						UIToast.Show("登录成功")
					else
						error("token is nil.")
					end
				else
					UIToast.Show("注册失败:"..this.retCode[retCode])
				end
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_phoneAccount).onClick = function()
			-- DONE: 登录手机账号
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_BY_PHONE()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_normalAccount).onClick = function()
			-- DONE: 登录QK账号
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_BY_QK()
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			if PreviousPanelShowCallback ~= nil and type(PreviousPanelShowCallback) == 'function' then
				this.sub_panel[TAG].root:SetActive(false)
				PreviousPanelShowCallback()
			end
		end
	if PreviousPanelShowCallback ~= nil then
		this.sub_panel[TAG].btn_back:SetActive(true)
	else
		this.sub_panel[TAG].btn_back:SetActive(false)
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
			-- DONE: 返回
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_SELECT()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg).onClick = function()
			-- DONE: 新用户注册
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REG_SENDPHONEVCODE()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- DONE: 登录
			local username = this.sub_panel[TAG].InputField_phoneNumber:GetComponent(typeof(UIInput)).value
			local password = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).value
			if not SDK.check_phoneNumber(username) then
				UIToast.Show("手机号格式错误")
				return
			end
			if not SDK.check_password(password) then
				UIToast.Show(this.passwordTips)
				return
			end
			local retCode,token,userinfo = SDK.send_GET_TOKEN(username,password)
			if retCode == "SUCCESS" then
				if not string.IsNullOrEmpty(token) then
					this.loginCache.isTemp = false
					this.loginCache.LastLoginTime = os.time()
					local user = {username = username,password = password}
					table.insert(this.loginCache.UserList,user)
					this.loginCache.CurrentUserIndex = table.IndexOf(this.loginCache.UserList,user)
					this.saveUserinfo2CurrentUser(userinfo)
				    UIToast.Show(
				    	"欢迎回来 "..this.loginCache.UserList[this.loginCache.CurrentUserIndex].username)
				    this:OnLoginSuccessful()
				else
					error("token is nil.")
				end
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_forgetPassword).onClick = function()
			-- DONE: 忘记密码界面
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_PATH(ui_login_controller.show_LOGIN_BY_PHONE)
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--使用奇快账号登录界面
function ui_login_controller:show_LOGIN_BY_QK()
	local TAG = login_sub_panel.LOGIN_BY_QK

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_reg = m_root:Find("btn_reg").gameObject
		this.sub_panel[TAG].btn_login = m_root:Find("btn_login").gameObject
		this.sub_panel[TAG].btn_forgetPassword = m_root:Find("btn_forgetPassword").gameObject
		this.sub_panel[TAG].InputField_username = m_root:Find("InputField_username").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_reg)
		this.attachCollider(this.sub_panel[TAG].btn_login)
		this.attachCollider(this.sub_panel[TAG].btn_forgetPassword)
		this.attachCollider(this.sub_panel[TAG].InputField_username)
		this.attachCollider(this.sub_panel[TAG].InputField_password)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_SELECT()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg).onClick = function()
			-- DONE: 新用户注册
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REG_NORMALACCOUNT()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- DONE: 登录
			local username = this.sub_panel[TAG].InputField_username:GetComponent(typeof(UIInput)).value
			local password = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).value
			if not SDK.check_username(username) then
				UIToast.Show("用户名格式不正确")
				return
			end
			if not SDK.check_password(password) then
				UIToast.Show(this.passwordTips)
				return
			end
			local retCode,token,userinfo = SDK.send_GET_TOKEN(username,password)
			if retCode == "SUCCESS" then
				if not string.IsNullOrEmpty(token) then
					this.loginCache.isTemp = false
					this.loginCache.LastLoginTime = os.time()
					local user = {username = username,password = password}
					table.insert(this.loginCache.UserList,user)
					this.loginCache.CurrentUserIndex = table.IndexOf(this.loginCache.UserList,user)
					this.saveUserinfo2CurrentUser(userinfo)
				    UIToast.Show(
				    	"欢迎回来 "..this.loginCache.UserList[this.loginCache.CurrentUserIndex].username)
				    this:OnLoginSuccessful()
				else
					error("token is nil.")
				end
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_forgetPassword).onClick = function()
			-- DONE: 忘记密码界面
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_PATH(ui_login_controller.show_LOGIN_BY_QK)
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--已存在本地账号,登录界面
function ui_login_controller:show_LOGIN_LOCAL()
	local TAG = login_sub_panel.LOGIN_LOCAL

	local function getUserIndexByUsername(username)
		for i = 1,#this.loginCache.UserList do
			if this.loginCache.UserList[i].username == username then
				return i
			end
		end
	end
	local function getUserByUsername(username)
		for i = 1,#this.loginCache.UserList do
			if this.loginCache.UserList[i].username == username then
				return this.loginCache.UserList[i]
			end
		end
	end
	local function getUserSpriteName(username)
		local phoneSpriteName = "tongyong_tubiao_shouji2"
		local QKSpriteName = "bendizhanghaodengli_tubiao_touxiang"
		local user = getUserByUsername(username)
		if user.phone == nil then
			return QKSpriteName
		elseif user.username == user.phone then
			return phoneSpriteName
		else
			return "shimingrenzheng_tubiao_touxiang"
		end
	end
	local function HandleOnDeleteItem(username)
		--删除本地指定用户缓存
		table.remove(this.loginCache.UserList,getUserIndexByUsername(username))
		if #this.loginCache.UserList ~= 0 then
			this.loginCache.CurrentUserIndex = 1
		else
			this.loginCache.CurrentUserIndex = 0
		end
	end
	local function HandleOnLoadIcon(username,sprite)
		sprite.spriteName = getUserSpriteName(username)
	end
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

		local poplistHelper = this.sub_panel[TAG].AccountInfoSelect:AddComponent(typeof(UIPopupListExtended))
		poplistHelper.HandleOnDeleteItem = function(username) HandleOnDeleteItem(username) end
		poplistHelper.HandleOnLoadIcon = function(username,sprite) HandleOnLoadIcon(username,sprite) end

		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- DONE: 登录
			if this.loginCache.isTemp and (this.loginCache.UserList == nil or #this.loginCache.UserList == 0) then
				return
			end
			local username = this.sub_panel[TAG].AccountInfoSelect:GetComponentInChildren(typeof(UILabel)).text
			local password = nil
			local userIndex = 0
			for i = 1,#this.loginCache.UserList do
				if this.loginCache.UserList[i].username == username then
					password = this.loginCache.UserList[i].password
					userIndex = i
					break
				end
			end
			local retCode,token = SDK.send_GET_TOKEN(username,password)
			if retCode == "SUCCESS" then
				this.loginCache.isTemp = false
				this.loginCache.CurrentUserIndex = userIndex
				UIToast.Show("登录成功")
				this:OnLoginSuccessful()
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_other).onClick = function()
			--DONE: 其他方式登录
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_SELECT(ui_login_controller.show_LOGIN_LOCAL)
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end

	local poplist = this.sub_panel[TAG].AccountInfoSelect:GetComponent(typeof(UIPopupList))
	poplist.items:Clear()
	for i = 1,#this.loginCache.UserList do
		poplist.items:Add(this.loginCache.UserList[i].username)
	end
	if not this.loginCache.isTemp then
		poplist.value = this.loginCache.UserList[#this.loginCache.UserList].username
	else
		if this.loginCache.UserList ~= nil and #this.loginCache.UserList~= 0 then
			poplist.value = this.loginCache.UserList[#this.loginCache.UserList].username
		else
			poplist.value = ""
		end
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
		this.sub_panel[TAG].InputField_username = m_root:Find("InputField_username").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].btn_view = m_root:Find("InputField_password/btn_view").gameObject
		this.sub_panel[TAG].btn_reg = m_root:Find("btn_reg").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_reg_by_phone)
		this.attachCollider(this.sub_panel[TAG].btn_serviceAgreement)
		this.attachCollider(this.sub_panel[TAG].InputField_username)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].btn_view)
		this.attachCollider(this.sub_panel[TAG].btn_reg)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_BY_QK()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_view).onClick = function()
			-- DONE: 显示密码按钮
			local currentType = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).inputType
			this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).inputType = 
				(currentType == UIInput.InputType.Password and UIInput.InputType.Standard or UIInput.InputType.Password)
			this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)):UpdateLabel()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg_by_phone).onClick = function()
			-- DONE: 跳转通过手机注册界面
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REG_SENDPHONEVCODE()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- DONE: 奇快网络服务协议
			this.sub_panel[TAG].root:SetActive(false)
			this:show_SERVICE_AGREEMENT(ui_login_controller.show_REG_NORMALACCOUNT)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg).onClick = function()
			-- DONE: 注册按钮
			local username = this.sub_panel[TAG].InputField_username:GetComponent(typeof(UIInput)).value
			local password = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).value
			if not SDK.check_username(username) then
				UIToast.Show("用户名格式不正确")
				return
			end
			if not SDK.check_password(password) then
				UIToast.Show(this.passwordTips)
				return
			end
			local retCode = SDK.send_USERNAME_REGISTER(username,password)
			if retCode == "SUCCESS" then
				UIToast.Show("注册成功")
				this.clearAllInput(this.sub_panel[TAG].root)
				local user = {username = username,password = password}
				this.addUserAndLogin(user,false)
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--手机注册:输入手机号界面
function ui_login_controller:show_REG_SENDPHONEVCODE()
	local TAG = login_sub_panel.REG_SENDPHONEVCODE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_regQK = m_root:Find("btn_regQK").gameObject
		this.sub_panel[TAG].InputField_phoneNumber = m_root:Find("InputField_phoneNumber").gameObject
		this.sub_panel[TAG].btn_nextStep = m_root:Find("btn_nextStep").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_regQK)
		this.attachCollider(this.sub_panel[TAG].InputField_phoneNumber)
		this.attachCollider(this.sub_panel[TAG].btn_nextStep)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_BY_PHONE()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_regQK).onClick = function()
			-- DONE: 注册QK按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REG_NORMALACCOUNT()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_nextStep).onClick = function()
			-- DONE: 下一步按钮
			local phoneNumber = this.sub_panel[TAG].InputField_phoneNumber:GetComponent(typeof(UIInput)).value
			if not SDK.check_phoneNumber(phoneNumber) then
				UIToast.Show("手机号格式错误")
				return
			end
			local retCode = SDK.send_GET_BIND_PHONE_CODE(phoneNumber)
			if retCode == "SUCCESS" then
				this.sub_panel[TAG].root:SetActive(false)
				this:show_REG_PHONEACCOUNT(phoneNumber)
				this.clearAllInput(this.sub_panel[TAG].root)
			else
				UIToast.Show(this.retCode[retCode])
			end
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
function ui_login_controller:show_REG_PHONEACCOUNT(phoneNumber)
	local TAG = login_sub_panel.REG_PHONEACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].Title = m_root:Find("Title").gameObject:GetComponent(typeof(UILabel))
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
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REG_SENDPHONEVCODE()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg_normalAccount).onClick = function()
			-- DONE: 跳转普通账户注册界面
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REG_NORMALACCOUNT()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- DONE: 奇快网络服务协议
			this.sub_panel[TAG].root:SetActive(false)
			this:show_SERVICE_AGREEMENT(ui_login_controller.show_REG_PHONEACCOUNT)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- DONE: 重新发送短信验证码
			if this.ResendButtonCanClick(this.sub_panel[TAG].btn_resend) then
				local retCode = SDK.send_GET_BIND_PHONE_CODE(phoneNumber)
				if retCode ~= "SUCCESS" then
					UIToast.Show(this.retCode[retCode])
				else
					UIToast.Show("验证码已发送,请留意手机短信")
					this.registerResendButtonTimer(this.sub_panel[TAG].btn_resend)
				end
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_reg_login).onClick = function()
			-- DONE: 注册并登录按钮
			local vcode = this.sub_panel[TAG].InputField_SMS_vcode:GetComponent(typeof(UIInput)).value
			local pwd = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).value
			if not SDK.check_password(pwd) then
				UIToast.Show(this.passwordTips)
				return
			end
			local retCode = SDK.send_PHONE_REGISTER(
				phoneNumber,vcode,pwd,"",
				getDeviceUniqueIdentifier()
			)
			if retCode == "SUCCESS" then
				-- 删除临时账号
				this.clearAllInput(this.sub_panel[TAG].root)
				local user = {username = phoneNumber,password = pwd}
				this.addUserAndLogin(user,false)
			else
				UIToast.Show("绑定失败:"..this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	if phoneNumber then
		this.sub_panel[TAG].Title.text = "您的手机号:"..phoneNumber
	end
	this.registerResendButtonTimer(this.sub_panel[TAG].btn_resend)
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
		this.sub_panel[TAG].softClipPanel = m_root:Find("softClip").gameObject:GetComponent(typeof(UIPanel))

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REALNAME_AUTHENTICATION()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- DONE: 关闭按钮
			this:hideAllSubPanel()
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	local rootDepth = instance.transform.parent.gameObject:GetComponent(typeof(UIPanel)).depth
	this.sub_panel[TAG].softClipPanel.depth = rootDepth + 1
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
		this.sub_panel[TAG].InputField_passport = m_root:Find("InputField_passport").gameObject
		this.sub_panel[TAG].InputField_name = m_root:Find("InputField_name").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].btn_description)
		this.attachCollider(this.sub_panel[TAG].InputField_passport)
		this.attachCollider(this.sub_panel[TAG].InputField_name)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_USERCENTER()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- DONE: 关闭按钮
			this:hideAllSubPanel()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_description).onClick = function()
			-- DONE: 实名认证系统说明按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REALNAME_DESCRIPTION()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- DONE: 确认按钮
			local username = this.loginCache.UserList[this.loginCache.CurrentUserIndex].username
			local password = this.loginCache.UserList[this.loginCache.CurrentUserIndex].password
			local sfz = this.sub_panel[TAG].InputField_passport:GetComponent(typeof(UIInput)).value
			local name = this.sub_panel[TAG].InputField_name:GetComponent(typeof(UIInput)).value
			if not SDK.check_sfz(sfz) then
				UIToast.Show("身份证格式错误")
				return
			end
			local retCode = SDK.send_IDEN_VERIFY(username,password,sfz,name)
			if retCode == "SUCCESS" then
				UIToast.Show("认证成功")
				this.clearAllInput(this.sub_panel[TAG].root)
				this.sub_panel[TAG].root:SetActive(false)
				this:show_USERCENTER()
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
end
--用户中心->已绑定/已认证界面
function ui_login_controller:show_BIND_INFO(title,content)
	local TAG = login_sub_panel.BIND_INFO

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].Title = m_root:Find("Title").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].Content = m_root:Find("Content").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回用户中心
			this.sub_panel[TAG].root:SetActive(false)
			this:show_USERCENTER()
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	this.sub_panel[TAG].Title.text = title
	this.sub_panel[TAG].Content.text = content
	this.sub_panel[TAG].Content:MakePixelPerfect()
end
--选择绑定界面
function ui_login_controller:show_BIND_SELECT(PreviousPanelShowCallback)
	local TAG = login_sub_panel.BIND_SELECT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_phoneAccount = m_root:Find("btn_phoneAccount").gameObject
		this.sub_panel[TAG].btn_normalAccount = m_root:Find("btn_normalAccount").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_phoneAccount)
		this.attachCollider(this.sub_panel[TAG].btn_normalAccount)

		UIEventListener.Get(this.sub_panel[TAG].btn_phoneAccount).onClick = function()
			-- DONE: 绑定手机账户
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_PHONE()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_normalAccount).onClick = function()
			-- DONE: 绑定普通账户
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_QKACCOUNT()
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			if PreviousPanelShowCallback ~= nil then
				PreviousPanelShowCallback()
			else
				this:show_QUICKGAME_TIPS()
			end
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
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_USERCENTER()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- DONE: 关闭按钮
			this:hideAllSubPanel()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- DONE: 确认按钮
			local username = this.loginCache.UserList[this.loginCache.CurrentUserIndex].username
			local mailbox = this.sub_panel[TAG].InputField_MailInfo:GetComponent(typeof(UIInput)).value
			if not SDK.check_mail(mailbox) then
				UIToast.Show("邮箱格式错误")
				return
			end
			local retCode = SDK.send_MAILBOX_BIND(username,mailbox)
			if retCode == "SUCCESS" then
				UIToast.Show("绑定邮件发送成功,请查收")
				this.clearAllInput(this.sub_panel[TAG].root)
				this.sub_panel[TAG].root:SetActive(false)
				this:show_USERCENTER()
			else
				UIToast.Show(this.retCode[retCode])
			end
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
function ui_login_controller:show_BIND_PHONE(PreviousPanelShowCallback)
	local TAG = login_sub_panel.BIND_PHONE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].InputField_PhoneNumber = m_root:Find("InputField_PhoneNumber").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].InputField_PhoneNumber)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- DONE: 确认按钮
			local phoneNumber = 
				this.sub_panel[TAG].InputField_PhoneNumber:GetComponent(typeof(UIInput)).value

			if not SDK.check_phoneNumber(phoneNumber) then
				UIToast.Show("手机号格式错误")
				return
			end

			local retCode = SDK.send_GET_BIND_PHONE_CODE(phoneNumber)

			if retCode == "SUCCESS" then
				this.sub_panel[TAG].root:SetActive(false)
				this:show_BIND_PHONEACCOUNT(phoneNumber)
			else
				UIToast.Show(this.retCode[retCode])
			end
		end

	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			if PreviousPanelShowCallback ~= nil and type(PreviousPanelShowCallback) == 'function' then
				PreviousPanelShowCallback()
			else
				this:show_BIND_SELECT()
			end
			this.clearAllInput(this.sub_panel[TAG].root)
		end
end
--绑定手机输入验证码界面(暂时无用)
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
		this.sub_panel[TAG].btn_resend = m_root:Find("InputField_SMS_verificationCode/btn_resend").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_SMS_verificationCode)
		this.attachCollider(this.sub_panel[TAG].btn_resend)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_PHONE()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- TODO: 关闭按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- TODO: 重新发送按钮
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- TODO: 确认按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_PHONEACCOUNT()
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
function ui_login_controller:show_BIND_QKACCOUNT(PreviousPanelShowCallback)
	local TAG = login_sub_panel.BIND_QKACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_bind_phone = m_root:Find("btn_bind_phone").gameObject
		this.sub_panel[TAG].btn_serviceAgreement = m_root:Find("btn_serviceAgreement").gameObject
		this.sub_panel[TAG].InputField_QKAccount = m_root:Find("InputField_QKAccount").gameObject
		this.sub_panel[TAG].InputField_password = m_root:Find("InputField_password").gameObject
		this.sub_panel[TAG].btn_bind = m_root:Find("btn_bind").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_bind_phone)
		this.attachCollider(this.sub_panel[TAG].btn_serviceAgreement)
		this.attachCollider(this.sub_panel[TAG].InputField_QKAccount)
		this.attachCollider(this.sub_panel[TAG].InputField_password)
		this.attachCollider(this.sub_panel[TAG].btn_bind)

		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- DONE: 查看服务协议按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_SERVICE_AGREEMENT(ui_login_controller.show_BIND_QKACCOUNT)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind).onClick = function()
			-- DONE: 确认绑定按钮
			local tempUsername = this.genTempUsername()
			local tempPassword = getDeviceUniqueIdentifier()
			local QKUsername = this.sub_panel[TAG].InputField_QKAccount:GetComponent(typeof(UIInput)).value
			local QKPassword = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).value
			if not SDK.check_username(QKUsername) then
				UIToast.Show("用户名格式不正确")
				return
			end
			if not SDK.check_password(QKPassword) then
				UIToast.Show(this.passwordTips)
				return
			end
			local retCode = SDK.send_USERNAME_BIND(tempUsername,QKUsername,tempPassword,QKPassword)
			if retCode == "SUCCESS" then
				this.clearAllInput(this.sub_panel[TAG].root)
				local user = {username = QKUsername,password = QKPassword}
				if this.loginCache.isTemp then
					this.addUserAndLogin(user,false)
				else
					this.saveUserinfo2CurrentUser(userinfo)
					this:OnLoginSuccessful()
				end
				UIToast.Show("登录成功")
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			if PreviousPanelShowCallback ~= nil and type(PreviousPanelShowCallback) == 'function' then
				PreviousPanelShowCallback()
			else
				this:show_BIND_SELECT()
			end
			this.clearAllInput(this.sub_panel[TAG].root)
		end
	UIEventListener.Get(this.sub_panel[TAG].btn_bind_phone).onClick = function()
		-- DONE: 跳转绑定手机界面按钮
		this.sub_panel[TAG].root:SetActive(false)
		this:show_BIND_PHONE(PreviousPanelShowCallback)
	end
end
--绑定手机账号界面
function ui_login_controller:show_BIND_PHONEACCOUNT(phoneNumber)
	local TAG = login_sub_panel.BIND_PHONEACCOUNT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].Title = m_root:Find("Title").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_bind_QK = m_root:Find("btn_bind_QK").gameObject
		this.sub_panel[TAG].btn_serviceAgreement = m_root:Find("btn_serviceAgreement").gameObject
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
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_SELECT()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_QK).onClick = function()
			-- DONE: 跳转绑定奇快界面按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_QKACCOUNT()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_serviceAgreement).onClick = function()
			-- DONE: 查看服务协议按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_SERVICE_AGREEMENT(ui_login_controller.show_BIND_PHONEACCOUNT)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- DONE: 重新发送短信验证码按钮
			if this.ResendButtonCanClick(this.sub_panel[TAG].btn_resend) then
				local retCode = SDK.send_GET_BIND_PHONE_CODE(phoneNumber)
				if retCode == "SUCCESS" then
					UIToast.Show("验证码已发送,请留意手机短信")
					this.registerResendButtonTimer(this.sub_panel[TAG].btn_resend)
				else
					UIToast.Show(this.retCode[retCode])
				end
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_login).onClick = function()
			-- DONE: 绑定并登录按钮
			local vcode = this.sub_panel[TAG].InputField_SMS_vcode:GetComponent(typeof(UIInput)).value
			local pwd = this.sub_panel[TAG].InputField_password:GetComponent(typeof(UIInput)).value
			if not SDK.check_password(pwd) then
				UIToast.Show(this.passwordTips)
				return
			end
			local retCode = SDK.send_PHONE_REGISTER(
				phoneNumber,vcode,pwd,
				this.loginCache.UserList[this.loginCache.CurrentUserIndex].username,
				getDeviceUniqueIdentifier()
			)
			if retCode == "SUCCESS" then
				this.clearAllInput(this.sub_panel[TAG].root)
				if this.loginCache.isTemp then
					local user = {username = phoneNumber,password = pwd}
					this.addUserAndLogin(user,false)
				else
					local token,userinfo = this:GetTokenAndUserinfo()
					if token ~= nil then
						this.saveUserinfo2CurrentUser(userinfo)
						this:OnLoginSuccessful()
					else
						UIToast.Show("token error.")
					end
				end
			else
				UIToast.Show("绑定失败:"..this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	this.sub_panel[TAG].Title.text = "您的手机号:"..(phoneNumber == nil and "nil" or phoneNumber)
	this.registerResendButtonTimer(this.sub_panel[TAG].btn_resend)
end
--找回密码途径界面
function ui_login_controller:show_PWDGETBACK_PATH(PreviousPanelShowCallback)
	local TAG = login_sub_panel.PWDGETBACK_PATH

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_phoneAccount = m_root:Find("btn_phoneAccount").gameObject
		this.sub_panel[TAG].btn_mailAccount = m_root:Find("btn_mailAccount").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_phoneAccount)
		this.attachCollider(this.sub_panel[TAG].btn_mailAccount)

		UIEventListener.Get(this.sub_panel[TAG].btn_phoneAccount).onClick = function()
			-- DONE: 使用手机找回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_BY_PHONE()
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			PreviousPanelShowCallback()
		end
	UIEventListener.Get(this.sub_panel[TAG].btn_mailAccount).onClick = function()
			-- DONE: 使用邮箱找回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_BY_MAIL(PreviousPanelShowCallback)
		end
end
--通过邮箱找回,输入邮箱地址界面
function ui_login_controller:show_PWDGETBACK_BY_MAIL(PreviousPanelShowCallback)
	local TAG = login_sub_panel.PWDGETBACK_BY_MAIL

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].InputField_account = m_root:Find("InputField_account").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_account)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_PATH()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- DONE: 关闭按钮
			this.hideAllSubPanel()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- DONE: 提交按钮
			this.sub_panel[TAG].root:SetActive(false)
			local username = this.sub_panel[TAG].InputField_account:GetComponent(typeof(UIInput)).value
			local retCode,mail = SDK.send_REKEY_VERIFY_LINK(username)
			if retCode == "SUCCESS" then
				UIToast.Show("密码找回邮件已发送,请查收")
				this.clearAllInput(this.sub_panel[TAG].root)
				this.sub_panel[TAG].root:SetActive(false)
				if PreviousPanelShowCallback ~= nil then
					PreviousPanelShowCallback()
				else
					this:show_PWDGETBACK_PATH()
				end
			else
				UIToast.Show(this.retCode[retCode])
			end
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
		this.sub_panel[TAG].btn_login = m_root:Find("btn_login").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].InputField_phoneNumber)
		this.attachCollider(this.sub_panel[TAG].btn_login)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_PATH()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_login).onClick = function()
			-- DONE: 使用手机找回按钮
			this.sub_panel[TAG].root:SetActive(false)
			local phoneNumber = this.sub_panel[TAG].InputField_phoneNumber:GetComponent(typeof(UIInput)).value
			if not SDK.check_phoneNumber(phoneNumber) then
				UIToast.Show("手机格式不正确")
				return
			end
			local retCode,phone = SDK.send_REKEY_PHONE_CODE(phoneNumber)
			if retCode == "SUCCESS" then
				this:show_PWDGETBACK_BY_PHONE_VCODE(phone)
			else
				UIToast.Show(this.retCode[retCode])
			end
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
function ui_login_controller:show_PWDGETBACK_BY_PHONE_VCODE(phoneNumber)
	local TAG = login_sub_panel.PWDGETBACK_BY_PHONE_VCODE

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].btn_close = m_root:Find("btn_close").gameObject
		this.sub_panel[TAG].AccountPhoneNumber = m_root:Find("AccountPhoneNumber").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_SMS_verificationCode = m_root:Find("InputField_SMS_verificationCode").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject
		this.sub_panel[TAG].btn_resend = m_root:Find("InputField_SMS_verificationCode/btn_resend").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_SMS_verificationCode)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)
		this.attachCollider(this.sub_panel[TAG].btn_resend)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_PWDGETBACK_BY_PHONE()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- DONE: 关闭按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_LOGIN_BY_PHONE()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_resend).onClick = function()
			-- DONE: 重发按钮
			if this.ResendButtonCanClick(this.sub_panel[TAG].btn_resend) then
				local retCode = SDK.send_REKEY_PHONE_CODE(phoneNumber)
				if retCode == "SUCCESS" then
					UIToast.Show("验证码已发送,请留意手机短信")
					this.registerResendButtonTimer(this.sub_panel[TAG].btn_resend)
				else
					UIToast.Show(this.retCode[retCode])
				end
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- DONE: 确认按钮
			local vcode = this.sub_panel[TAG].InputField_SMS_verificationCode:GetComponent(typeof(UIInput)).value
			local retCode,key = SDK.send_REKEY_BY_PHONE(phoneNumber,vcode)

			if retCode == "SUCCESS" then
				UIToast.Show("请牢记密码,返回登录请按X")
				this.sub_panel[TAG].AccountPhoneNumber.text = "您的密码是 "..(key == nil and "nil" or key)
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	this.sub_panel[TAG].AccountPhoneNumber.text = "您的手机号:"..(phoneNumber == nil and "nil" or phoneNumber)
	this.registerResendButtonTimer(this.sub_panel[TAG].btn_resend)
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
		this.sub_panel[TAG].AccountName = m_root:Find("AccountName").gameObject:GetComponent(typeof(UILabel))
		this.sub_panel[TAG].InputField_oldPassword = m_root:Find("InputField_oldPassword").gameObject
		this.sub_panel[TAG].InputField_newPassword = m_root:Find("InputField_newPassword").gameObject
		this.sub_panel[TAG].btn_view = m_root:Find("InputField_newPassword/btn_view").gameObject
		this.sub_panel[TAG].btn_confirm = m_root:Find("btn_confirm").gameObject

		this.attachCollider(this.sub_panel[TAG].btn_back)
		this.attachCollider(this.sub_panel[TAG].btn_close)
		this.attachCollider(this.sub_panel[TAG].InputField_oldPassword)
		this.attachCollider(this.sub_panel[TAG].InputField_newPassword)
		this.attachCollider(this.sub_panel[TAG].btn_view)
		this.attachCollider(this.sub_panel[TAG].btn_confirm)

		UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_USERCENTER()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_close).onClick = function()
			-- DONE: 关闭按钮
			this:hideAllSubPanel()
			this.clearAllInput(this.sub_panel[TAG].root)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_view).onClick = function()
			-- DONE: 显示密码按钮
			local currentType = this.sub_panel[TAG].InputField_newPassword:GetComponent(typeof(UIInput)).inputType
			this.sub_panel[TAG].InputField_newPassword:GetComponent(typeof(UIInput)).inputType = 
				(currentType == UIInput.InputType.Password and UIInput.InputType.Standard or UIInput.InputType.Password)
			this.sub_panel[TAG].InputField_newPassword:GetComponent(typeof(UIInput)):UpdateLabel()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_confirm).onClick = function()
			-- DONE: 确认按钮
			local username = this.loginCache.UserList[this.loginCache.CurrentUserIndex].username
			local oldpassword = this.sub_panel[TAG].InputField_oldPassword:GetComponent(typeof(UIInput)).value
			local newpassword = this.sub_panel[TAG].InputField_newPassword:GetComponent(typeof(UIInput)).value
			if oldpassword == newpassword then
				UIToast.Show("旧密码与新密码相同")
				return
			end
			if not SDK.check_password(newpassword) then
				UIToast.Show("密码请输入6-18个字符")
				return
			end
			local retCode = SDK.send_MODIFY_PASSWORD(username,oldpassword,newpassword)
			if retCode == "SUCCESS" then
				this.clearAllInput(this.sub_panel[TAG].root)
				this.loginCache.UserList[this.loginCache.CurrentUserIndex].password = newpassword
				UIToast.Show("密码修改成功")
				this.sub_panel[TAG].root:SetActive(false)
				this:show_USERCENTER()
			else
				UIToast.Show(this.retCode[retCode])
			end
		end
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	if this.loginCache.CurrentUserIndex ~= 0 then
		this.sub_panel[TAG].AccountName.text = "用户名:"..this.loginCache.UserList[this.loginCache.CurrentUserIndex].username
	end
end
--临时账号提示界面
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
			-- DONE: 跳转绑定方式界面按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_SELECT()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_ignore).onClick = function()
			-- DONE: 忽略按钮
			local tempUserName = this.genTempUsername()
			local retCode,token = SDK.send_GET_TOKEN(tempUserName,getDeviceUniqueIdentifier())
			if not string.IsNullOrEmpty(token) then
				printw("token = "..token)
				this:OnLoginSuccessful()
				UIToast.Show("登录成功")
			else
				UIToast.Show(this.retCode[retCode])
			end
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
-- DONE: 用户中心界面打开时需要判断部分按钮是否显示
function ui_login_controller:show_USERCENTER()
	local TAG = login_sub_panel.USERCENTER

	local userinfo = this.getCurrentUserInfo()
	local hasPhone,isPhoneUser,hasSfz,hasMail
	if userinfo ~= nil then
		hasPhone = (userinfo.phone == nil and {false} or {true})[1]
		isPhoneUser = ((hasPhone and userinfo.username == userinfo.phone) and {true} or {false})[1]
		hasSfz = (userinfo.sfz == nil and {false} or {true})[1]
		hasMail = (userinfo.mail == nil and {false} or {true})[1]
	end
	local function showTouristsCenter()
		this.sub_panel[TAG].btn_modifyPwd:SetActive(false)
		this.sub_panel[TAG].btn_realName:SetActive(false)
		this.sub_panel[TAG].btn_bind_Phone:SetActive(false)
		this.sub_panel[TAG].btn_bind_MailBox:SetActive(false)
		this.sub_panel[TAG].btn_bind_Account:SetActive(true)
		this.sub_panel[TAG].AccountName.text = "游客"
	end
	local function showUserCenter()
		-- 动态对用户中心图标进行排序
		local function sortIcon()
			local Icons = {}
			table.insert(Icons,this.sub_panel[TAG].btn_modifyPwd)
			table.insert(Icons,this.sub_panel[TAG].btn_realName)
			table.insert(Icons,this.sub_panel[TAG].btn_bind_Phone)
			table.insert(Icons,this.sub_panel[TAG].btn_bind_MailBox)
			local startPosition = Vector3(-212,27,0)
			local spacing_x = 212
			local spacing_y = 87

			local index_x = 0
			local index_y = 0
			for _,v in ipairs(Icons) do
				if v == this.sub_panel[TAG].btn_bind_Phone and isPhoneUser then
					v:SetActive(false)
				else
					v.transform.localPosition = Vector3(-212 + spacing_x * (index_x % 3),27 - spacing_y * index_y,0)
					index_x = index_x + 1
					if index_x > 2 then
						index_y = index_y + 1
						index_x = 0
					end
				end
			end
		end
		this.sub_panel[TAG].btn_modifyPwd:SetActive(true)
		this.sub_panel[TAG].btn_realName:SetActive(true)
		this.sub_panel[TAG].btn_bind_Phone:SetActive(true)
		this.sub_panel[TAG].btn_bind_MailBox:SetActive(true)
		this.sub_panel[TAG].btn_bind_Account:SetActive(false)
		-- this.sub_panel[TAG].AccountName.text = this.loginCache.UserList[this.loginCache.CurrentUserIndex].username
		this.sub_panel[TAG].AccountName.text = userinfo.username
		this.sub_panel[TAG].AccountName:MakePixelPerfect()
		sortIcon()
	end
	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].AccountIdentity = m_root:Find("AccountIdentity").gameObject
		this.sub_panel[TAG].AccountName = m_root:Find("AccountName").gameObject:GetComponent(typeof(UILabel))
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
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_switch).onClick = function()
			-- DONE: 切换账户按钮
			this.sub_panel[TAG].root:SetActive(false)
			if this.loginCache.isTemp and this.loginCache.UserList ~= nil and #this.loginCache.UserList == 0 then
				this:show_LOGIN_SELECT(ui_login_controller.show_USERCENTER)
			else
				this:show_LOGIN_LOCAL()
			end
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_Account).onClick = function()
			-- DONE: 绑定账户按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_SELECT(ui_login_controller.show_USERCENTER)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_Phone).onClick = function()
			-- DONE: 绑定手机按钮
			hasPhone = (this.getCurrentUserInfo().phone == nil and {false} or {true})[1]
			isPhoneUser = ((hasPhone and this.getCurrentUserInfo().username == this.getCurrentUserInfo().phone) and {true} or {false})[1]
			if hasPhone then
				this.sub_panel[TAG].root:SetActive(false)
				local title = "绑定手机"
				local content = "您当前已绑定手机:"..this.getCurrentUserInfo().phone..
							"\n\n如需修改请联系官方客服"
				this:show_BIND_INFO(title,content)
				return
			end
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_PHONE(ui_login_controller.show_USERCENTER)
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_bind_MailBox).onClick = function()
			-- DONE: 绑定邮箱按钮
			hasMail = (this.getCurrentUserInfo().mail == nil and {false} or {true})[1]
			if hasMail then
				this.sub_panel[TAG].root:SetActive(false)
				local title = "绑定邮箱"
				local content = "您当前已绑定邮箱:"..this.getCurrentUserInfo().mail..
							"\n\n如需修改请联系官方客服"
				this:show_BIND_INFO(title,content)
				return
			end
			this.sub_panel[TAG].root:SetActive(false)
			this:show_BIND_MAILBOX()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_realName).onClick = function()
			-- DONE: 实名认证按钮
			hasSfz = (this.getCurrentUserInfo().sfz == nil and {false} or {true})[1]
			if hasSfz then
				this.sub_panel[TAG].root:SetActive(false)
				local title = "实名认证"
				local content = "您已完成实名认证"
				this:show_BIND_INFO(title,content)
				return
			end
			this.sub_panel[TAG].root:SetActive(false)
			this:show_REALNAME_AUTHENTICATION()
		end
		UIEventListener.Get(this.sub_panel[TAG].btn_modifyPwd).onClick = function()
			-- DONE: 修改密码按钮
			this.sub_panel[TAG].root:SetActive(false)
			this:show_MODIFY_PASSWORD()
		end
	end
	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	if this.loginCache.isTemp then
		showTouristsCenter()
	else
		showUserCenter()
	end
	--红点逻辑
	local m_root = this.sub_panel[TAG].root.transform
	if hasPhone then
		m_root:Find("btn_bind_Phone/RedDot").gameObject:SetActive(false)
	else
		m_root:Find("btn_bind_Phone/RedDot").gameObject:SetActive(true)
	end
	if hasSfz then
		m_root:Find("btn_realName/RedDot").gameObject:SetActive(false)
	else
		m_root:Find("btn_realName/RedDot").gameObject:SetActive(true)
	end
	if hasMail then
		m_root:Find("btn_bind_MailBox/RedDot").gameObject:SetActive(false)
	else
		m_root:Find("btn_bind_MailBox/RedDot").gameObject:SetActive(true)
	end
	-- printw(inspect(this.loginCache.UserList[this.loginCache.CurrentUserIndex]))
end
--奇快网络服务协议界面
function ui_login_controller:show_SERVICE_AGREEMENT(PreviousPanelShowCallback)
	local TAG = login_sub_panel.SERVICE_AGREEMENT

	local function init()
		this.sub_panel[TAG].root = GameObjectExtension.InstantiateFromPacket("ui_login_reg", TAG, instance.gameObject)
		this.sub_panel[TAG].root:SetActive(true)
		local m_root = this.sub_panel[TAG].root.transform

		this.sub_panel[TAG].btn_back = m_root:Find("btn_back").gameObject
		this.sub_panel[TAG].softClipPanel = m_root:Find("softClip").gameObject:GetComponent(typeof(UIPanel))

		this.attachCollider(this.sub_panel[TAG].btn_back)
	end

	if this.sub_panel[TAG] == nil then
		this.sub_panel[TAG] = {}
		init()
	else
		this.sub_panel[TAG].root:SetActive(true)
	end
	UIEventListener.Get(this.sub_panel[TAG].btn_back).onClick = function()
			-- DONE: 返回按钮
			this.sub_panel[TAG].root:SetActive(false)
			PreviousPanelShowCallback()
		end
	local rootDepth = instance.transform.parent.gameObject:GetComponent(typeof(UIPanel)).depth
	this.sub_panel[TAG].softClipPanel.depth = rootDepth + 1
end
----------------------------------------------------------------
--★Util
function ui_login_controller.attachCollider(gobj)
	local widget = gobj:GetComponent(typeof(UIWidget))
	gobj:AddComponent(typeof(UnityEngine.BoxCollider))
	widget:ResizeCollider()
end

function table.IndexOf(tbl,value)
	for i = 1,#tbl do
		if tbl[i] == value then
			return i
		end
	end
end
function string.IsNullOrEmpty(str)
	if str == '' or str == nil then
		return true
	end
	return false
end
--@Des 获取设备唯一标识符
function getDeviceUniqueIdentifier()
	return UnityEngine.SystemInfo.deviceUniqueIdentifier
end
--[[
	loginCache = {
		isTemp = false, -- 是否是临时账号
		CurrentUserIndex = 0, -- 上次登录用户在用户表中的索引
		LastLoginTime = os.time(), -- 上次登录时间戳
		UserList = { -- 用户表
			{ username = string, password = string }
			{ username = string, password = string }
			{ ... }
		}
	}
]]
function ui_login_controller:readLoginCache()
	local cache = UnityEngine.PlayerPrefs.GetString(CacheKey)

	if string.IsNullOrEmpty(cache) then
		this:initLoginCache()
	else
		this.loginCache = json.decode(cache)
	end
end
function ui_login_controller:writeLoginCache()
	-- DONE: 写入登录缓存
	-- local file = io.open("C:\\Users\\cc\\Desktop\\DUMP_LoginCache.json","w")
	-- file:write(json.encode((this.loginCache == nil and "" or this.loginCache)))
	-- file:close()

	UnityEngine.PlayerPrefs.SetString(CacheKey,json.encode((this.loginCache == nil and "" or this.loginCache)))
end
function ui_login_controller:initLoginCache()
	this.loginCache = {
		isTemp = true,
		CurrentUserIndex = 0,
		LastLoginTime = nil,
		UserList = {},
	}
end
function ui_login_controller:GetTokenAndUserinfo()
	local userIndex = this.loginCache.CurrentUserIndex
	local username = this.loginCache.UserList[userIndex].username
	local password = this.loginCache.UserList[userIndex].password
	local retCode,token,userinfo = SDK.send_GET_TOKEN(username,password)
	if retCode == 'SUCCESS' then
		printw("token = "..token)
		return token,userinfo
	else
		UIToast.Show(this.retCode[retCode])
	end
end
--成功登录后的逻辑
function ui_login_controller:OnLoginSuccessful()
	-- DONE: 登录游戏,清理其他子界面
	-- 写入登录缓存
	this:writeLoginCache()
	this:hideAllSubPanel()
	-- 执行登录成功回调
	if OnLoginSuccessfulCallback then
		OnLoginSuccessfulCallback()
	end
end
--@Des 添加用户并自动登录
--@Params user 用户table {username = ..,password = ..}
--		  isTemp 是否是临时账号
function ui_login_controller.addUserAndLogin(user,isTemp)
	table.insert(this.loginCache.UserList,user)
	this.loginCache.CurrentUserIndex = table.IndexOf(this.loginCache.UserList,user)
	this.loginCache.isTemp = isTemp
	this.loginCache.LastLoginTime = os.time()

	local token,userinfo = this:GetTokenAndUserinfo()
	if not string.IsNullOrEmpty(token) then
		this.saveUserinfo2CurrentUser(userinfo)
		this:OnLoginSuccessful()
	else
		error("token is nil.")
	end
end
--@Des 保存用户绑定信息到当前用户上
--@Params userinfo = {
--			phone,sfz,mail,ext_info
--		  }
function ui_login_controller.saveUserinfo2CurrentUser(userinfo)
	local currentUser = this.loginCache.UserList[this.loginCache.CurrentUserIndex]
		currentUser.phone = userinfo.phone
		currentUser.sfz = userinfo.sfz
		currentUser.mail = userinfo.mail
		currentUser.ext_info = userinfo.ext_info
end
--生成快速游戏用户名
function ui_login_controller.genTempUsername()
	return "0-QK"..getDeviceUniqueIdentifier().."@qksf.net"
end
--获取当前用户信息
function ui_login_controller.getCurrentUserInfo()
	if this.loginCache.CurrentUserIndex ~= 0 then
		return this.loginCache.UserList[this.loginCache.CurrentUserIndex]
	end
end
--隐藏所有界面
function ui_login_controller.hideAllSubPanel()
	for _,v in pairs(this.sub_panel) do
		if v.root.activeInHierarchy then
			v.root:SetActive(false)
		end
	end
end
--清除当前界面中所有InputFiled的值
function ui_login_controller.clearAllInput(root_gameObject)
	local array = root_gameObject:GetComponentsInChildren(typeof(UIInput))
	for i = 0,array.Length - 1 do
		array[i].value = ""
	end
end
----------------------------------------------------------------
--★重发按钮计时器管理
local timerList = {}
local duration = 60
-- 向带有label控件的按钮注册一个计时器
function ui_login_controller.registerResendButtonTimer(btn_resend)
	local label = btn_resend:GetComponentInChildren(typeof(UILabel))
	local OnTick = function()
		local change = os.time() - timerList[btn_resend:GetHashCode()].timeStamp
		if change < duration then
			label.text = duration - change
		else
			timerList[btn_resend:GetHashCode()].timer:Kill()
		end
	end
	local OnKill = function()
		label.text = "重发"
		timerList[btn_resend:GetHashCode()] = nil
	end
	if not this.hasResendButtonTimer(btn_resend) then
		timerList[btn_resend:GetHashCode()] = {}
		timerList[btn_resend:GetHashCode()].timer = SDK.CreateLoopTimer(1,OnTick,OnKill)
		timerList[btn_resend:GetHashCode()].timeStamp = os.time()
	end
end
-- 是否此按钮带有计时器
function ui_login_controller.hasResendButtonTimer(btn_resend)
	if timerList[btn_resend:GetHashCode()] and timerList[btn_resend:GetHashCode()].timer ~= nil then
		return true
	end
	return false
end
-- 重发按钮是否可以点击
function ui_login_controller.ResendButtonCanClick(btn_resend)
	if timerList[btn_resend:GetHashCode()] == nil or timerList[btn_resend:GetHashCode()].timer.IsStop then
		return true
	end
	return false
end
----------------------------------------------------------------
--★服务器错误码定义
ui_login_controller.retCode = {
	['SUCCESS'] = "正确",
	['ERR_PARAM_ERR'] = "参数不全",
	['PACKAGE_ERR'] = "包头格式错误",
	['INVALID_MSGID'] = "无效的消息类型",
	['CODE_EXCEPTION'] = "服务器异常",
	['NO_ACCOUNT'] = "帐号不存在",
	['PHONE_HAVE_BIND'] = "该手机已被绑定",
	['REQ_CODE_LIMIT'] = "请求验证码次数已达每日上限",
	['REQ_CODE_TOO_OFTEN'] = "请求验证码太频繁",
	['REQ_CODE_UKNOWN_ERR'] = "请求验证码未知错误",
	['HAVENOT_SEND_CODE'] = "未发送验证码",
	['CODE_NOT_CORRECT'] = "验证码错误",
	['OLD_PASSWORD_ERR'] = "原密码错误",
	['NO_BIND_MAILBOX'] = "未绑定邮箱",
	['NO_BIND_PHONE'] = "未绑定手机",
	['PARAM_ERR'] = "参数错误",
	['USER_HAVE_REG'] = "帐号已存在",
	['PHONE_FORMAT_ERR'] = "手机号格式错误",
	['MAILBOX_FORMAT_ERR'] = "邮箱格式错误",
	['SIGNATURE_ERR'] = "数据签名错误",
	['IDEN_VERIFY_FAIL'] = "身份验证失败",
}
ui_login_controller.passwordTips = "密码请输入6-18个字符"

return ui_login_controller