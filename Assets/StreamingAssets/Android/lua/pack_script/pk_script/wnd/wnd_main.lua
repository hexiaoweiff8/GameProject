
local wnd_mainClass = class(wnd_base)

wnd_main = nil--单例

function wnd_mainClass:Start() 
	wnd_main = self
	self:Init(WND.Main)

	CMAnimationEventsTrigger.OnCallEvent:AddCallback(self,self.OnAnimationEventReCall)--绑定动画回调事件
end

--动画事件回调
function wnd_mainClass:OnAnimationEventReCall(param)	
	if param.evtName=="main_box_open" then --箱子打开完毕
		if self.cmAnima~=nil then
			self.cmAnima:SetEnable(false)--禁用动画
		end
	end
end

--窗体被实例化时被调用
--初始化实例
function wnd_mainClass:OnNewInstance()

	self:BindUIEvent("moxing/Bone06/Object21",UIEventType.Click,"OnTestClick")--点击3D按钮
	

	--定时打开盒子
	local mxObj = self.instance:FindWidget("moxing");
	local cmTimer =  mxObj:AddComponent(CMTimer.Name);

	--倒计时回调函数
	local CompleteRC = function(this)
		self.cmAnima = mxObj:GetComponent(CMAnimator.Name);
		self.cmAnima:SetEnable(true)--激活动画组件
		self.cmAnima:PlayInFixedTime("open",0,0)--从固定帧开始播放
	end
	
	--启动定时器
	cmTimer:OnComplete(self,CompleteRC):Reset(0.5);

     
--	self:BindUIEvent ("Object21", UIEventType.Click, "OntuiguanClick")
--	self:BindUIEvent ("Touxiang", UIEventType.Click, "OnInformationClick")
end


function wnd_mainClass:OnTestClick(gameObj)
	print("OnTestClick#1")
end

--征战按钮被点击
function wnd_mainClass:OnZhengZhanClick(gameObj)
	wnd_guanka:Show()
end

function wnd_mainClass:OntuiguanClick(gameObj)
	wnd_tuiguan:Show() 
	self:Hide() 
end
--------------------------------主角资料卡相关--------------------------------
function wnd_mainClass:OnInformationClick(gameObj)
	--wnd_playerinfo:Show()
		wnd_main:Hide()
        wnd_tuiguan:Hide()
        wnd_playerinfo:Show() 
end

--------------------------------排行相关--------------------------------
function wnd_mainClass:OnpaihangClick(gameObj)	
	wnd_background:Show() 
	wnd_paihangbang:Show()
	self:Hide() 
	wnd_paihangbang:FillData(reDoc)
	wnd_background:ShowListOnbackground(wnd_paihangbang) 
end 

--------------------------------成就相关--------------------------------
function wnd_mainClass:OnAchievementsClick(gameObj)
	wnd_background:Show() 
	wnd_achievements:Show()
	self:Hide() 
	wnd_background:ShowListOnbackground(wnd_achievements)
end
--------------------------------充值相关--------------------------------
function wnd_mainClass:OnchongzhiClick(gameObj)
	wnd_background:Show() 
	wnd_chongzhi:Show()
	wnd_background:ShowListOnbackground(wnd_chongzhi)
end
--------------------------------邮件相关--------------------------------
--邮箱按钮被点击
function wnd_mainClass:OnMailClick(gameObj)
    local jsonDoc = JsonParse.SendNM("GetMailList")
    jsonDoc:Add("page","1")
    local loader = Loader.new(jsonDoc:ToString(),0,"ReGetMailList")
    LoaderEX.SendAndRecall(loader,self,self.NM_ReGetMailList)
end
--邮箱协议返回
function wnd_mainClass:NM_ReGetMailList(reDoc) 
    wnd_mailframe:FillData(reDoc)
	wnd_background:Show() 
    wnd_mailframe:Show()  
	wnd_background:ShowListOnbackground(wnd_mailframe)
end 

--------------------------------聊天相关--------------------------------
function wnd_mainClass:OnChatClick(gameObj)
    wnd_chat:Show()
end

--------------------------------竞技相关--------------------------------
function wnd_mainClass:OnJingJiClick(gameObj)
    local jsonDoc = JsonParse.SendNM("EnterArena")
    local loader = Loader.new(jsonDoc:ToString(),1,"ArenaInfo")
    LoaderEX.SendAndRecall(loader,self,self.NM_ArenaInfo,nil)
end
function wnd_mainClass:NM_ArenaInfo(reDoc)
	wnd_jingjichang:FillData(reDoc)
	wnd_background:Show() 
	wnd_jingjichang:Show()
	wnd_background:ShowListOnbackground(wnd_jingjichang)
end

--------------------------------钱庄相关--------------------------------
function wnd_mainClass:OnQianZhuangClick ()
	-- Show Window
	wnd_qianzhuang:Show ()
end

--------------------------------玩家信息--------------------------------
--[[
PlayerData.data.dbg  --是否调试模式
PlayerData.data.GuideStep  --指引进度
PlayerData.data.GuideVersion  --指引版本号
PlayerData.data.JYCID  --精英关章
PlayerData.data.JYMID --精英关节
PlayerData.data.CurrChapterID --普通关章
PlayerData.data.CurrMissionID --普通关节

PlayerData.data.sex --性别
PlayerData.data.curexp --当前经验
PlayerData.data.hid --主英雄动态ID
PlayerData.data.glv --官爵等级
PlayerData.data.junlcs --军令购买次数
PlayerData.data.junljs --军令倒计时 
PlayerData.data.gslv --指引步数 等级
PlayerData.data.gsjy --指引步数 精英关 
PlayerData.data.ST --用字符串形式保存，最终用一个c#类来处理
--]]

-- 獲取玩家信息以顯示
function wnd_mainClass:FetchPlayerDataDisplay ()
--[[
	-- 军令，未加入军令最大值
	self:GetLabel ("main_moneylab/junling_bg/num"):SetValue (PlayerData.data.junl)
	-- 玩家等级
	self:GetLabel ("main_heroinfo/info_bg/lv"):SetValue (PlayerData.data.hlv)
	-- 玩家名称
	self:GetLabel ("main_heroinfo/info_bg/name"):SetValue (PlayerData.data.name)


	-- Fetch Gold and Money's Info :
	local money = ToWan (PlayerData.data.tb)
	local gold  = ToWan (PlayerData.data.jb)
	self:GetLabel ("tb_bg/num"):SetValue (money)
	self:GetLabel ("gold_bg/num"):SetValue (gold)
	-- self:GetLabel ("tb_bg/num"):SetValue (PlayerData.data.tb)
	-- self:GetLabel ("gold_bg/num"):SetValue (PlayerData.data.jb)
	--]]
end

-- 刷新玩家信息：金币 铜板 军令 等级
-- 引用需追加判斷 : if (wnd_main.instance ~= nil) then
function wnd_mainClass:ReLoadPlayerDataDisplay ()
	-- Reload Gold and Money's Info to display :
	local money = ToWan (PlayerData.data.tb)
	local gold  = ToWan (PlayerData.data.jb)
	self:GetLabel ("tb_bg/num"):SetValue (money)
	self:GetLabel ("gold_bg/num"):SetValue (gold)

	-- 軍令
	self:GetLabel ("main_moneylab/junling_bg/num"):SetValue (PlayerData.data.junl)
	-- 等级
	self:GetLabel ("main_heroinfo/info_bg/lv"):SetValue (PlayerData.data.hlv)
end



--实例即将被丢失
function wnd_mainClass:OnLostInstance()
	self.cmAnima = nil
end 
 
return wnd_mainClass.new
 