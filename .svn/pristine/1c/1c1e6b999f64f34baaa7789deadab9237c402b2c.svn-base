-- wnd_jingjichang.lua 竞技场界面
--Date：2015.10
--GYT

local wnd_jingjichangClass = class(wnd_base)

wnd_jingjichang = nil--单例

function wnd_jingjichangClass:Start() 
	wnd_jingjichang = self
	self:Init(WND.Jjc)
end

function wnd_jingjichangClass:ctor()
	self.UIFormation = exui_Formation.new()--创建阵位控件
end
function wnd_jingjichangClass:FillData(reDoc)
	self.gx = tonumber(reDoc:GetValue("gx"))--功勋
	self.tzcs = tonumber (reDoc:GetValue("tzcs"))--剩余挑战次数
	self.tzjs = tonumber (reDoc:GetValue("tzjs"))--挑战倒计时，单位秒
	self.gmcs = tonumber(reDoc:GetValue("gmcs"))--今日购买次数 int
	local aNode = reDoc:GetValue("me")
	self.pm = tonumber(aNode:GetValue("pm"))--排名
	local id = tonumber(aNode:GetValue("id"))--用户在竞技场中的唯一标识
	local lv = tonumber(aNode:GetValue("lv"))--等级
	local name = tostring( aNode:GetValue("name"))--用户昵称
	local z = tonumber(aNode:GetValue("z"))--战斗力
	local sex =tonumber( aNode:GetValue("sex"))
--u:{
--<id>:{lv:<等级>,name:<用户昵称>,z:<战斗力>,sex:<用户性别>,pm:<排名>},
--...
--}
	local uNode = reDoc:GetValue("u")
	local k = 1
    self.UserInfos = {}
    local usersFunc = function(id,userInfos)
        local id = tonumber( userInfos:GetValue("id")) 
        local users = {}
        users.id = id
        users.lv = tonumber( userInfos:GetValue("lv") )
        users.sex = tonumber( userInfos:GetValue("sex") )
        users.z = tonumber( userInfos:GetValue("z") )
        users.name = tostring( userInfos:GetValue("name") )
		users.pm = tostring( userInfos:GetValue("pm") )
        self.UserInfos[k] = users   
		k = k + 1  
    end
    uNode:Foreach(usersFunc)
--当前排名可获得的奖励
	local mejlNode = reDoc:GetValue("mejl")
	self.tb = tonumber( mejlNode:GetValue("tb"))--铜币
	self.gx = tonumber(mejlNode:GetValue("gx"))--功勋
	local item = mejlNode:GetValue("item")
	self.mejlList = {}
	local i = 0
	local JLitemFunc = function(_,jlitemInfos)
        local users = {}
        users.b = tonumber( jlitemInfos:GetValue("b") )--bookname
        users.i = tonumber( jlitemInfos:GetValue("i") )--道具id
        users.n = tonumber( jlitemInfos:GetValue("n") )--道具数量
        self.mejlList[i] = users   
		i = i + 1  
    end
    item:Foreach(JLitemFunc)
--#阵型
--F:{
--  First:[-1,heroID,-1],
--  Second:[heroID,-1,heroID],
--  Third:[heroID,-1,heroID]
--}
    local zhengNode = reDoc:GetValue("F")--取得阵形节点
    self.formation = FormationCtor.FromJsonNode(zhengNode)--解析出阵型信息

--英雄属性
	local hattrNode = reDoc:GetValue("hattr")
	self.heroList = {}
	local heroFunc = function(dyID,heroInfos)
		dyID = tonumber(dyID)
		local heroAtrrs = {}
        heroAtrrs.dyID = dyID
        heroAtrrs.level = tonumber( heroInfos:GetValue("lv") )--等级
		heroAtrrs.sid = tonumber( heroInfos:GetValue("i") )--数据id
        heroAtrrs.xj = tonumber( heroInfos:GetValue("xj") )--星级
		heroAtrrs.zs = tonumber( heroInfos:GetValue("zs") )--是否已转生
        self.heroList[dyID] = heroAtrrs   
    end
    hattrNode:Foreach(heroFunc)
	
	local hbt = tonumber( reDoc:GetValue("hbt"))--是否存在对战记录
	local zdl = tonumber(reDoc:GetValue("zdl"))--战斗力
	self.mpm = tonumber(reDoc:GetValue("mpm"))--历史最高排名
	print("self.mpm",self.mpm)
end
function wnd_jingjichangClass:OnShowDone()	
	self:SetLabel("jjc_rules/txt",_TXT(17028))
	self:SetLabel("jjc_rank/txt",_TXT(9153))
	self:SetLabel("jjc_replay/txt",_TXT(9154))
	self:SetLabel("jjc_shop/txt",_TXT(9103))
	self:SetLabel("change_team/txt",_TXT(9160))
	self:SetLabel("myrank_txt",_TXT(9161))
	
	self.upate = false
	self.clear  = false
	self:SetLabel("jjc_moneylab/gx_bg/num",ToWan(self.gx))
	self:SetLabel("jjc_moneylab/gold_bg/num",ToWan(PlayerData.data.jb))
	local str = string.sformat(_TXT(423),self.tzcs,5)
	self:SetLabel("time_txt",str)
	local heroPanel = self.m_Item:GetParent()
	if self.bIsShow then
		return
	else
		for k = 1,#self.UserInfos do
			local itemObj = GameObject.InstantiateFromPreobj(self.m_Item,heroPanel)
			itemObj:SetLocalPosition(Vector3.new(0,-(k-1)*88,0))
			itemObj:SetName("user"..k)
			itemObj:SetActive(true)--激活对象
			self:SetLabel("user"..k.."/rank",self.UserInfos[k].pm)
			self:SetLabel("user"..k.."/name_bg/Label",self.UserInfos[k].name)
			self:SetLabel("user"..k.."/strenght_point",self.UserInfos[k].z)
			self:BindUIEvent("user"..k.."/btn_fight",UIEventType.Click,"FightToSone",self.UserInfos[k].id)	
			self:BindUIEvent("user"..k,UIEventType.Click,"watchToSone",self.UserInfos[k].id)	
		end
	self.bIsShow = true
	end
	local Btn = GameObject.Find("def_team/change_enemy")
	if self.tzcs > 0 and self.tzjs < 0  then 
		self:SetLabel("def_team/change_enemy/txt",_TXT(9124))
		self:BindUIEvent("change_enemy",UIEventType.Click,"changeplayer")
	elseif self.tzcs == 0 then 
		self:SetLabel("def_team/change_enemy/txt",_TXT(9125))
		self.waring = "是否购买竞技挑战次数"
		self:BindUIEvent("change_enemy",UIEventType.Click,"buycs")
	else
		Btn:SetActive(false)
		local Btn1 = GameObject.Find("jjc_frame/def_team/reset_frame")
		Btn1:SetActive(true)

		self.waring = "是否消除冷却时间"
		self:BindUIEvent("reset_time",UIEventType.Click,"buysj")
	end
	local table1 = {}
	local str = tostring(self.pm)
	for k = 1 ,#str do
		table1[k] = string.sub(str,k,k)
	end
	for i = 1 ,#table1 do
		local a = 0
		if #table1 == 2 then
			a = 20
		elseif #table1 == 3 then
			a = 40
		elseif #table1 == 4 then
			a = 60
		elseif #table1 == 5 then
			a = 80
		end
		local MSzi = GameObject.Find("rank_num/Grid/num"..i)
		MSzi:SetLocalPosition(Vector3.new((i-1)*40-a,0,0))
		local ziSprite = MSzi:GetComponent( CMUISprite.Name )--获得Sprite组件
		ziSprite:SetSpriteName("jjc_num"..table1[i])
		MSzi:SetActive(true)
	end
 	self.UIFormation:SetFormation(self.formation,self.heroList) 
	self:BindUIEvent("change_team",UIEventType.Click,"buzhen")
	self:BindUIEvent("jjc_replay",UIEventType.Click,"OnChickfightNotes")
--	self:updateTime()
end
--function wnd_jingjichangClass:updateTime()
--	local sec = self.tzjs%60
--	local min = math.ceil(self.tzjs/60)
--	local timeLable = "0:"..min..":"..sec.."后可再次挑战"
--	local upm = GameObject.Find("reset_frame/change_cd")
--	local u_num = upm:GetComponent( CMUILabel.Name )--获得label组件
--	u_num:SetValue(timeLable)
--end
--点击对战记录
function wnd_jingjichangClass:OnChickfightNotes(gameObj)
	local jsonDoc = JsonParse.SendNM("ArenaZB")
	local loader = Loader.new(jsonDoc:ToString(),0,"ReArenaZB")
	LoaderEX.SendAndRecall(loader,self,self.NM_ReArenaZB,nil)
end
function wnd_jingjichangClass:NM_ReArenaZB(reDoc)
	wnd_replay:FillData(reDoc)
	wnd_replay:Show()
end
--点击购买次数的事件
function wnd_jingjichangClass:buycs(gameObj)
	StartCoroutine(self,self.coWaringKuang,{})
end
function wnd_jingjichangClass:buysj(gameObj)
	StartCoroutine(self,self.coWaringKuang,{})
end
--点击换一批向服务器发送协议
function wnd_jingjichangClass:changeplayer(gameObj)
	local jsonDoc = JsonParse.SendNM("EnterArena")
	local loader = Loader.new(jsonDoc:ToString(),1,"ArenaInfo")
	LoaderEX.SendAndRecall(loader,self,self.NM_ArenaInfo,nil)
end
function wnd_jingjichangClass:buzhen(gameObj)
	wnd_buzheng:Show()
end
--点击换一批的返回协议解析
function wnd_jingjichangClass:NM_ArenaInfo(reDoc)
	if self.upate then
		self.upate = false
	else
		self.upate = true
	end
	local uNode = reDoc:GetValue("u")
	local k = 1
    self.UserInfos = {}
    local usersFunc = function(id,userInfos)
        local id = tonumber( userInfos:GetValue("id")) 
        local users = {}
        users.id = id
        users.lv = tonumber( userInfos:GetValue("lv") )
        users.sex = tonumber( userInfos:GetValue("sex") )
        users.z = tonumber( userInfos:GetValue("z") )
        users.name = tostring( userInfos:GetValue("name") )
		users.pm = tostring( userInfos:GetValue("pm") )
        self.UserInfos[k] = users   
		k = k + 1  
    end
    uNode:Foreach(usersFunc)
	self:UpdateUserInof()
end
--点击换一批的点击事件
function wnd_jingjichangClass:UpdateUserInof()
	if self.clear then
		for i = 1 ,5 do
			local Item = self.instance:FindWidget("user"..900+i)
			Item:Destroy()
		end
	else
		for i = 1 ,5 do
			local Item = self.instance:FindWidget("user"..i)
			Item:Destroy()
		end
	end
	local heroPanel = self.m_Item:GetParent()
    for k = 1,#self.UserInfos do
		if self.upate then
			count = 900 + k
			self.clear = true
		else
			count = k
			self.clear = false
		end
		local itemObj = GameObject.InstantiateFromPreobj(self.m_Item,heroPanel)
		itemObj:SetLocalPosition(Vector3.new(0,-(k-1)*88,0))
		itemObj:SetName("user"..count)
		itemObj:SetActive(true)--激活对象
		local upm = GameObject.Find("user"..count.."/rank")
		local u_num = upm:GetComponent( CMUILabel.Name )--获得label组件
		u_num:SetValue(self.UserInfos[k].pm)
		local uname = GameObject.Find("user"..count.."/name_bg/Label")
		local u_name = uname:GetComponent( CMUILabel.Name )--获得label组件
		u_name:SetValue(self.UserInfos[k].name)
		local ufight = GameObject.Find("user"..count.."/strenght_point")
		local u_fight = ufight:GetComponent( CMUILabel.Name )--获得label组件
		u_fight:SetValue(self.UserInfos[k].z)
		self:BindUIEvent("user"..count.."/btn_fight",UIEventType.Click,"FightToSone",self.UserInfos[k].id)	
		self:BindUIEvent("user"..count,UIEventType.Click,"watchToSone",self.UserInfos[k].id)	
	end
end
--点击其他用户的item的点击事件
function wnd_jingjichangClass:watchToSone(gameObj,id)
	local jsonDoc = JsonParse.SendNM("VArenaPly")
	jsonDoc:Add("id",id)
	jsonDoc:Add("m",1)
	local loader = Loader.new(jsonDoc:ToString(),1,"ReVArenaPly")
	LoaderEX.SendAndRecall(loader,self,self.NM_ReVArenaPly,nil)
end  
--点击挑战按钮的事件
function wnd_jingjichangClass:FightToSone(gameObj,id)
	--得到还有几次
	if self.tzcs ~= 0 and  self.tzjs < 0 then--挑战成功   发送请求备战协议
		local jsonDoc = JsonParse.SendNM("ArenaBZ")
		jsonDoc:Add("id",id)
		jsonDoc:Add("m",1)
		local loader = Loader.new(jsonDoc:ToString(),1,"ReArenaBZ")
		LoaderEX.SendAndRecall(loader,self,self.NM_ReArenaBZ,nil)
	else
		if self.tzcs == 0 and self.tzjs < 0 then
			--挑战次数为0   冷却时间为0 
			self.waring = "是否购买竞技挑战次数"
		elseif self.tzcs == 0 and self.tzjs > 0 then --挑战次数为0   冷却时间不为0
			self.waring = "是否购买竞技挑战次数"
		else--挑战次数不为0  冷却时间也大于0
			self.waring = "是否刷新竞技延迟"			
		end
		--开启协程
		StartCoroutine(self,self.coWaringKuang,{})--启动一个协程
	end

end 
function wnd_jingjichangClass:NM_ReArenaBZ(reDoc)
	wnd_fight_info:FillData(reDoc)
	wnd_fight_info:Show()
end  
function wnd_jingjichangClass:NM_ReVArenaPly(reDoc)
	wnd_enemy_info:FillData(reDoc)
	wnd_enemy_info:Show()
end 
function wnd_jingjichangClass:coWaringKuang(gameObj)	
	local resultwait = MsgboxResultWait.new()
	MsgBox.Show(self.waring,"否","是",resultwait,resultwait.OnMsgBoxClose)
	local result = resultwait:GetResult()--读取对话框返回结果
	if(result == 2) then--用户选择删除邮件
		if self.waring == "是否购买竞技挑战次数" then
			print("是否购买竞技挑战次数")
			self:buyTZCS()
		else
			print("是否刷新冷却")
			self:buyTZSJ()
		end
	end	
end
--确定购买挑战次数
function wnd_jingjichangClass:buyTZCS()
	local jsonDoc = JsonParse.SendNM("BuyFCS")
	jsonDoc:Add("t",1)
	local loader = Loader.new(jsonDoc:ToString(),0,"ReBuyFCS")
	LoaderEX.SendAndRecall(loader,self,self.NM_ReBuyFCS,nil)
end  
--确定刷新冷却时间
function wnd_jingjichangClass:buyTZSJ()
	local jsonDoc = JsonParse.SendNM("SFDelay")
	jsonDoc:Add("t",1)
	local loader = Loader.new(jsonDoc:ToString(),0,"ReSFDelay")
	LoaderEX.SendAndRecall(loader,self,self.NM_ReSFDelay,nil)
end  
--购买次数协议返回函数
function wnd_jingjichangClass:NM_ReBuyFCS(reDoc)
	local tNode = reDoc:GetValue("t")
	local result = tonumber(reDoc:GetValue("result"))
	if result == 0 then --0成功 1当前次数不为0 2金币不足 3购买次数超过当日上限  99未知错误
		self.tzcs = 5
		local hand3 = GameObject.Find("def_team/time_frame/time_left")
		local label_aitem3 = hand3:GetComponent( CMUILabel.Name )--获得label组件
		label_aitem3:SetValue(self.tzcs)
		local Btn = GameObject.Find("def_team/change_enemy")
		local BtnTxt = GameObject.Find("def_team/change_enemy/txt")
		local label_Btn = BtnTxt:GetComponent( CMUILabel.Name )
		label_Btn:SetValue("换一批")
		self:BindUIEvent("change_enemy",UIEventType.Click,"changeplayer")
	elseif  result == 1 then 
		print("当前次数不为0")
	elseif  result == 2 then 
		print("金币不足")
	elseif  result == 3 then 
		print("购买次数超过当日上限")
	else
		print("未知错误")
	end
end  
--刷新延迟协议返回
function wnd_jingjichangClass:NM_ReSFDelay(reDoc)
	--0成功 1剩余挑战次数为零无需刷新 2金币不足 99未知错误
	local tNode = reDoc:GetValue("t")
	local result = tonumber(reDoc:GetValue("result"))
	if result == 0 then --0成功 1当前次数不为0 2金币不足 3购买次数超过当日上限  99未知错误
		self.tzcs = self.tzcs-1
		local Btn1 = GameObject.Find("jjc_frame/def_team/reset_frame")
		Btn1:SetActive(false)
		local hand3 = GameObject.Find("def_team/time_frame/time_left")
		local label_aitem3 = hand3:GetComponent( CMUILabel.Name )--获得label组件
		label_aitem3:SetValue(self.tzcs)
		local Btn = GameObject.Find("jjc_frame/def_team/change_enemy")
		Btn:SetActive(true)
		local BtnTxt = GameObject.Find("jjc_frame/def_team/change_enemy/txt")
		local label_Btn = BtnTxt:GetComponent( CMUILabel.Name )
		label_Btn:SetValue("换一批")
		self:BindUIEvent("change_enemy",UIEventType.Click,"changeplayer")
	elseif  result == 1 then 
		print("当前次数不为0")
	elseif  result == 2 then 
		print("金币不足")
	elseif  result == 3 then 
		print("购买次数超过当日上限")
	else
		print("未知错误")
	end
end  

--窗体被实例化时被调用
--初始化实例
function wnd_jingjichangClass:OnNewInstance()
    self.m_Item = self.instance:FindWidget("Grid/enemy_single")
	self.m_Item:SetActive(false)	
	self:BindUIEvent("jjc_rules",UIEventType.Click,"showRule")
	self.bIsShow = false
	self.m_ItemMB = self.instance:FindWidget( "def_team/zw1/slot/zw1" )
    self.m_ItemMB:SetActive(false)
	--阵位实例初始化
	self.UIFormation:OnNewInstance(self.instance:FindWidget("def_team"),self.m_ItemMB) 

end
function wnd_jingjichangClass:showRule()
	local m_Item = self.instance:FindWidget("userbok_close")
	m_Item:SetActive(true)
	self:SetLabel("userbok_titlebg/txt",_TXT(9162))
	local table1 = {}
	local str = tostring(self.mpm)
	for k = 1 ,#str do
		table1[k] = string.sub(str,k,k)
	end
	local between1 = ""
	local between2 = ""
	if #str > 2 then
		if #str == 3 then
			local a = (self.pm%1000-self.pm%100)/100
			between1 = tostring(a).."01"
			between2 = tostring(a+1).."01"
		elseif #str == 4 then
			local a = (self.pm%10000-self.pm%1000)/1000
			between1 = tostring(a).."001"
			between2 = tostring(a+1).."001"
		elseif #str == 4 then
			local a = (self.pm%100000-self.pm%10000)/10000
			between1 = tostring(a).."0001"
			between2 = tostring(a+1).."0001"
			if a ==9 then
				between1 = tostring(a).."0001"
				between2 = tostring(a+1).."0000"
			end	
		end		
	end
	local str = string.sformat(_TXT(9163),self.pm,between1,between2)
	self:SetLabel("label1",str)
	self:SetLabel("self_award/award1/num",self.tb)
	self:SetLabel("self_award/award2/num",self.gx)
	self:SetLabel("self_rank/txt",_TXT(9201))
	local rule = _TXT(9166).."\n".._TXT(9167)
	self:SetLabel("label2",_TXT(9162)..":")
	self:SetLabel("label3",rule)
	self:SetLabel("label4",_TXT(9168))
	local rule1 = _TXT(9169).."\n".._TXT(9170)
	self:SetLabel("label5",rule1)
	--排名 
	for i = 1 ,#table1 do
		local MSzi = GameObject.Find("self_rank/rank/num"..i)
		local ziSprite = MSzi:GetComponent( CMUISprite.Name )--获得Sprite组件
		ziSprite:SetSpriteName("jjc_num"..table1[i])
		MSzi:SetActive(true)
	end
	for i = 1, 6 do
		local money = sdata_PKAward:GetFieldV("Money",i)
		local tb = GameObject.Find("rank_award"..i.."/award1/num")
		local u_tb = tb:GetComponent( CMUILabel.Name )--获得label组件
		u_tb:SetValue(money)
		local gongxun = sdata_PKAward:GetFieldV("Gongxun",i)
		local gongxunlable = GameObject.Find("rank_award"..i.."/award3/num")
		local gongxun_lable = gongxunlable:GetComponent( CMUILabel.Name )--获得label组件
		gongxun_lable:SetValue(gongxun)
		local BookNum1 = sdata_PKAward:GetFieldV("JJCBookNum1",i)
		local BookNum1lable = GameObject.Find("rank_award"..i.."/award2/num")
		local BookNum1_lable = BookNum1lable:GetComponent( CMUILabel.Name )--获得label组件
		BookNum1_lable:SetValue(BookNum1)
		if i < 4 then
			local BookNum2 = sdata_PKAward:GetFieldV("JJCBookNum2",i)
			local BookNum2lable = GameObject.Find("rank_award"..i.."/award4/num")
			local BookNum2_lable = BookNum2lable:GetComponent( CMUILabel.Name )--获得label组件
			BookNum2_lable:SetValue(BookNum2)
		end
	end
	self:BindUIEvent("userbok_close",UIEventType.Click,"hideRule")

end  
function wnd_jingjichangClass:hideRule()
	local m_Item = self.instance:FindWidget("userbok_close")
	m_Item:SetActive(false)	
end  
--实例即将被丢失
function wnd_jingjichangClass:OnLostInstance()

end  


return wnd_jingjichangClass.new
