----region *.lua
----Date 20151013
----属性更新协议
----Author Wenchuan

--local function uattr_jb(v)
--	PlayerData.data.jb = v
--end

--local function uattr_tb(v)
--	PlayerData.data.tb = v
--end 

--local function uattr_hlv(v)
--	PlayerData.data.hlv = v
--end 

--local function uattr_curexp(v)
--	PlayerData.data.curexp = v
--end 

--local function uattr_vipLv(v)
--	PlayerData.data.vipLv = v
--end 
--local function uattr_CanMianFeiJinShiLian(v)
--	PlayerData.data.CanMianFeiJinShiLian = v
--end 
--local function uattr_CanMianFeiJinYiChou(v)
--	PlayerData.data.CanMianFeiJinYiChou = v
--end 
--local function uattr_CanMianFeiTongYiChou(v)
--	PlayerData.data.CanMianFeiTongYiChou = v
--end 
--local uattrAction = {
--	[1] = uattr_hlv,
--	[2] = uattr_jb,
--	[3] = uattr_tb,
--	[6] = uattr_curexp,--当前经验
--	[30] = uattr_CanMianFeiJinShiLian,--是否可免费金10连
--	[27] = uattr_CanMianFeiJinYiChou,--是否可免费金一抽
--	[26] = uattr_CanMianFeiTongYiChou,--是否可免费铜一抽
--	[37] = uattr_vipLv,
--}

--local function NM_uattr(qkJsonDoc)
--	--[[
--t:1,#属性类型编号   4-官爵等级 5-战斗力   13-军功 14-强化石 15-兽灵石 18-是否能领取累积充值奖励 19-是否能领取竞技场奖励 20-竞技场是否有未挑战的次数 21-军令上限 22-武将通用碎片 23-功勋 31-Vip等级变更 32-是否需要显示布阵提示 33-是否有进行中的内置活动(位模式) 34-试炼之路是否全部通过 35-群雄割据是否全部通过 36-玉币 37-累冲领取次数
--v:323,#当前值
--	--]]
--	local t = tonumber(qkJsonDoc:GetValue("t"))
--	local v = tonumber(qkJsonDoc:GetValue("v"))
--	local func = uattrAction[t]
--	if(func==nil) then return end
--	func(v)

--	-- Refresh the player data's display :
--	if (wnd_main.instance ~= nil) then
--		wnd_main:ReLoadPlayerDataDisplay ()
--	end
--end

--local function NM_tip(qkJsonDoc)
--	local msg = qkJsonDoc:GetValue("msg")
--	Application.PopTip(msg,Color.white)
--end

--local nmFuncs = {
--  ["uattr"] = NM_uattr, 
--  ["tip"] = NM_tip
--} 

----注册网络处理函数
--NMDispatcher.RegNMFuncs(nmFuncs)

----endregion
