--wnd_qianzhuang.lua 錢莊窗口
--FirstDate：2015/10/21 15:52; 2015/10/22 15:09;
--RefixDate：2015/10/23 16:18; 2015/10/26 15:29
--Note：Later VipSystem Completing..
--RandyL-LJX


local wnd_qianzhuangClass = class(wnd_base)

wnd_qianzhuang = nil


-- 兑换信息
local exchangeInfo = {
	count		= 0,
-- 	vipLevel	= 1,
	exCountMax	= 0,
-- 	alreadyMax	= false,
-- 	exGold		= "DuihuanGold",
	needGold	= 0,
-- 	exMoney		= "DuihuanMoney",
	getMoney	= 0,
	exText		= "今日已兑换00/00次",
-- 	isReset		= false,

-- 	--年月日为上次时间
-- 	--时分秒毫秒为每天固定刷新时间
-- 	--暂定每日凌晨
-- 	reloadTime	= {
-- 		Year = 2015, Month	= 10, Day	 = 21,
-- 		Hour =   00, Minute	= 00, Second = 00, Millisecond = 00,
-- 	},
}


function wnd_qianzhuangClass:Start ()
	wnd_qianzhuang = self
	self:Init (WND.QianZhuang, false)


	-- --Fetch Vip_Daily_Limit
	-- --exchangeInfo.vipLevel	= VipSomthing
	-- exchangeInfo.exCountMax =
	-- 	20 + (exchangeInfo.vipLevel - 1) * 5

	-- --First Load exchangeInfo :
	-- self:FirstGetExInfo ()
end


function wnd_qianzhuangClass:CrossInit ()
	EventHandles.OnLoginSuccess:AddListener (self, self.OnLoginSuccess)
end


function wnd_qianzhuangClass:OnLoginSuccess()
	-- First Load exchangeInfo :
	self:FirstGetExInfo ()
end


function wnd_qianzhuangClass:OnNewInstance ()
	self:BindUIEvent ("back", UIEventType.Click, "OnBackClick")
	self:BindUIEvent ("confirm", UIEventType.Click, "OnExchangeClick")
end


function wnd_qianzhuangClass:OnBackClick ()
	self:Hide ()
end


-- 点击兑换
function wnd_qianzhuangClass:OnExchangeClick ()
	-- --if : Beyond the limit
	-- if exchangeInfo.alreadyMax then
	-- 	return nil
	-- end

	-- --Do Something, Exchanging..
	-- exchangeInfo.count = exchangeInfo.count + 1

	-- --Check if Exchanged-Success
	-- local _, final = self:FetchExInfo()
	-- if not _ then
	-- 	--false : Beyond the limit :
	-- 	exchangeInfo.alreadyMax = true
	-- 	exchangeInfo.count = exchangeInfo.count - 1
	-- 	return nil
	-- elseif final then
	-- 	--It's Finally Success :
	-- 	self:ChangeExInfoDisplay ()
	-- else
	-- 	--Successed : Change enchangInfo :
	-- 	self:ChangeExInfoDisplay ()
	-- end

	-- if already beyond limit count :
	if exchangeInfo.count == exchangeInfo.exCountMax then
		self.NM_ReQZExchange (nil)
		return nil
	end


	local jsonDoc = JsonParse.SendNM ("QZExchange")

	local loader = Loader.new (jsonDoc:ToString(), 0, "ReQZExchange")
	LoaderEX.SendAndRecall (loader, self, self.NM_ReQZExchange, nil)
end


-- -- Read ReQZExchange Loader : Recall func
function wnd_qianzhuangClass:NM_ReQZExchange (reDoc)
	-- 0成功 1兑换次数超过本日上限 2资源不足  99未知错误
	-- ReQZExchange result state :
	local state = nil

	if reDoc == nil then
		-- Show beyond limit window : Show MsgBox :
		-- 因访问权限,第四五参数不能使用self
		MsgBox.Show ("今日兑换次数已满 !", "返回", "前往充值", wnd_qianzhuang, wnd_qianzhuang.CB_CloseEvt)
		return nil
	else
		state = tonumber (reDoc:GetValue ("result"))
	end

	if state == 0 then
		-- Show a display successed exchange : PopTip :
		-- Application.PopTip ("兑换成功 !", Color.white)

		-- Successed : Change exchangInfo :
		self:FetchExInfo ()

		-- Change wnd_main 's Gold-Money-display :
		if (wnd_main.instance ~= nil) then
			wnd_main:ReLoadPlayerDataDisplay ()
		end

	elseif state == 1 then
		-- Show beyond limit window :
		MsgBox.Show ("今日兑换次数已满 !", "返回", "确定", wnd_qianzhuang, wnd_qianzhuang.CB_CloseEvt)
	-- elseif state == 2 then
		-- Show no resource poptip :
		-- Application.PopTip ("金币不足 !", Color.red)
	-- elseif state == 99 then
		-- print ("exchang GoldToMoney error.")
		-- Or show error window/poptip :
		-- Application.PopTip ("未知错误 !", Color.red)
	else
		print ("It's a true code error !!!")
	end
end


function wnd_qianzhuangClass:CB_CloseEvt (result)
	if result == 1 then
		return nil
	elseif result == 2 then
		self:Hide ()

		-- Should display charge window :
		wnd_background:Show ()
		wnd_chongzhi:Show ()
		wnd_background:ShowListOnbackground (wnd_chongzhi)
	else
		print ("Press button msg error!")
	end
end


-- After ShowDone displayed exchangeInfo
function wnd_qianzhuangClass:OnShowDone ()
	-- if self.instance:IsNewInstance () then
	-- 	self:ChangeExInfoDisplay ()
	-- end
	self:FetchExInfo ()


	-- --Open QianZhuang_Window's Time :
	-- --After QianZhuang's Window instantiate
	-- local nowTime	= DateTime.Now()
	-- local now		= {}
	-- now.Millisecond	= nowTime:Millisecond ()
	-- now.Year, now.Month, now.Day	 = nowTime:YearMonthDay ()
	-- now.Hour, now.Minute, now.Second = nowTime:HourMinuteSecond ()

	-- --Whether reset limited buy_count :
	-- --Daily reset :
	-- wnd_qianzhuang:WhetherReload (now.Year, now.Month, now.Day, 
	-- 	now.Hour, now.Minute, now.Second, now.Millisecond)
end


-- First Get exchangeInfo :
function wnd_qianzhuangClass:FirstGetExInfo ()
	self:FetchExInfo ()
end


-- Reload exchangeInfo :
function wnd_qianzhuangClass:FetchExInfo ()
	-- --获取：调用 KeyValueMath 构造的 luacsv 对象
	-- local sdata_KeyValueMath = require "sdata.sdata_KeyValueMath"

	-- --获取：现兑换信息：金币 铜板 提示文本
	-- --if 超过Vip每日限制
	-- if exchangeInfo.count < exchangeInfo.exCountMax then
	-- 	--Get Gold :
	-- 	local gold = sdata_KeyValueMath:GetFieldV
	-- 		(exchangeInfo.exGold, exchangeInfo.count + 1)
	-- 	exchangeInfo.needGold = gold

	-- 	--Get Money :
	-- 	local money = sdata_KeyValueMath:GetFieldV
	-- 		(exchangeInfo.exMoney, exchangeInfo.count + 1)
	-- 	exchangeInfo.getMoney = money

	-- 	--Get Text :
	-- 	exchangeInfo.exText =
	-- 		"今日已兑换" .. exchangeInfo.count ..
	-- 		"/" .. exchangeInfo.exCountMax .. "次"

	-- 	--Reload Success
	-- 	return true, nil

	-- elseif exchangeInfo.count == exchangeInfo.exCountMax then
	-- 	--Finally exchang : Just get text :

	-- 	--Get Text :
	-- 	exchangeInfo.exText =
	-- 		"今日已兑换" .. exchangeInfo.count ..
	-- 		"/" .. exchangeInfo.exCountMax .. "次"

	-- 	return true, true
	-- else
	-- 	--Beyond Limit : do nothing :
	-- 	return false, nil
	-- end


	local jsonDoc = JsonParse.SendNM ("QZInfo")

	local loader = Loader.new (jsonDoc:ToString(), 0, "ReQZInfo")
	LoaderEX.SendAndRecall (loader, self, self.NM_ReQZInfo, nil)
end


-- Read ReQZInfo Loader : Recall func
function wnd_qianzhuangClass:NM_ReQZInfo (reDoc)
	-- Get Money :
	exchangeInfo.getMoney	= tonumber (reDoc:GetValue ("utb"))
	-- Get Gold :
	exchangeInfo.needGold	= tonumber (reDoc:GetValue ("ujb"))
	exchangeInfo.count		= tonumber (reDoc:GetValue ("cs"))
	exchangeInfo.exCountMax	= tonumber (reDoc:GetValue ("mcs"))

	-- Get Text :
	exchangeInfo.exText	  =
		"今日已兑换" .. exchangeInfo.count ..
		"/" .. exchangeInfo.exCountMax .. "次"


	if self:GetLabel ("txt2") == nil then
		return nil
	end
	-- 回调函数执行是另开一个协程
	-- ChangeExInfoDisplay只能嵌套在NM_ReQZInfo中以保证运行顺序
	self:ChangeExInfoDisplay ()
end


-- Change exchangeInfo display
function wnd_qianzhuangClass:ChangeExInfoDisplay ()
	self:GetLabel ("txt2"):SetValue (exchangeInfo.exText)
	self:GetLabel ("gold/txt"):SetValue (exchangeInfo.needGold)
	self:GetLabel ("tb/txt"):SetValue (exchangeInfo.getMoney)
end


--[[
--Reload whether or not ：
function wnd_qianzhuangClass:WhetherReload (year, month, day, hour, minute, second, millisecond)
	--reloadTime = Server's Reload Time

	--Fetch/New reload_time :
	local reloadTime = exchangeInfo.reloadTime

	--Judge whether a reload :
	--A new day :
	if reloadTime.Day ~= day or reloadTime.Month ~= month or 
		reloadTime.Year ~= year then
		do
			exchangeInfo.isReset		  = false
			exchangeInfo.reloadTime.Year  = year
			exchangeInfo.reloadTime.Month = month
			exchangeInfo.reloadTime.Day	  = day
		end
		--Whether beyond update time :
		do
			if reloadTime.Hour > hour then
				return nil
			elseif reloadTime.Hour == hour then
				do
					if reloadTime.Minute > minute then
						return nil
					elseif reloadTime.Minute == minute then
						do
							if reloadTime.Second > second then
								return nil
							elseif reloadTime.Second == second then
								if reloadTime.Millisecond > millisecond then
									return nil
								end
							end
						end
					end
				end
			end
			--Reset Limit_Count :
			self:DailyReload (year, month, day)
		end
	--If no reset today :
	elseif not exchangeInfo.isReset then
		--Whether beyond update time :
		do
			if reloadTime.Hour > hour then
				return nil
			elseif reloadTime.Hour == hour then
				do
					if reloadTime.Minute > minute then
						return nil
					elseif reloadTime.Minute == minute then
						do
							if reloadTime.Second > second then
								return nil
							elseif reloadTime.Second == second then
								if reloadTime.Millisecond > millisecond then
									return nil
								end
							end
						end
					end
				end
			end
			--Reset Limit_Count :
			self:DailyReload (year, month, day)
		end
	end
end


--Daily reload Limit_Count :
function wnd_qianzhuangClass:DailyReload (year, month, day)
	--Daily reset limit :
	exchangeInfo.count			  = 0
	exchangeInfo.isReset 		  = true
	exchangeInfo.alreadyMax		  = false

	--Rest exchangeInfo and display :
	self:FetchExInfo ()
	self:ChangeExInfoDisplay ()
end
--]]



-- function wnd_qianzhuangClass:OnLostInstance ()
-- end



return wnd_qianzhuangClass.new