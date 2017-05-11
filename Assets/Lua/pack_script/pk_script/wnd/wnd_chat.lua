--wnd_chat.lua 聊天界面
--Date：2015.9
--GYT

local wnd_chatClass = class(wnd_base)

 wnd_chat = nil--单例

local ChannelID = {
    sj = 1,
    gz = 2,
    sl = 3,
}
 
function wnd_chatClass:Start() 
	 wnd_chat = self
	self:Init(WND.Chat,true)
	self.showWhat = 0
end
function wnd_chatClass:CrossInit() 
	--绑定登陆成功事件
    EventHandles.OnLoginSuccess:AddListener(self,self.OnLoginSuccess) 
end
function wnd_chatClass:OnLoginSuccess() 
	local jsonDoc = JsonParse.SendNM("EnterChatRoom")
    local loader = Loader.new(jsonDoc:ToString(),0,"ReEnterChatRoom")
    LoaderEX.SendAndRecall(loader,self,self.NM_ReEnterChatRoom,nil)
end
function wnd_chatClass:NM_ReEnterChatRoom(reDoc)
	self.bIsGZ = reDoc:GetValue("i")
end 
--窗体被实例化时被调用
--初始化实例
function wnd_chatClass:OnNewInstance()
	self.whichChanne = -1
	self.m_Item = self.instance:FindWidget("Grid/single_says")
    self.m_Item:SetLocalPosition(Vector3.new(0,100,0))
	self.m_Item:SetActive(false)

	self:BindUIEvent("chat_back",UIEventType.Click,"OnChatClick")--点击返回
	--选项卡按钮绑定
	self:BindUIEvent("tab_sj",UIEventType.Click,"OnClickChannel",ChannelID.sj)
	self:BindUIEvent("tab_gz",UIEventType.Click,"OnClickChannel",ChannelID.gz)
	self:BindUIEvent("tab_sl",UIEventType.Click,"OnClickChannel",ChannelID.sl)
end
--聊天返回按钮回调
function wnd_chatClass:OnChatClick(gameObj)
	self:Hide()
end
--执行发送聊天命令按钮被点击
function wnd_chatClass:OnDoSendClick(gameObj,channel)
		local cmdeditObj = self.instance:FindWidget("input_frame")--取出编辑框游戏对象
		local cmInput = cmdeditObj:GetComponent(CMUIInput.Name)--取出编辑组件
		local words = cmInput:GetValue()
		cmInput:SetValue("")
		local jsonDoc = JsonParse.SendNM("Speak")
		jsonDoc:Add("t",channel)
		jsonDoc:Add("nr",words)
		if  channel == ChannelID.sl and self.onSone ~= nil  then
			jsonDoc:Add("oname",self.onSone)
		end
		local loader = Loader.new(jsonDoc:ToString(),6,"ReSpeak")
		LoaderEX.SendAndRecall(loader,self,self.NM_ReSpeak,nil)
		self.onSone = nil
end
--发送聊天返回函数
function wnd_chatClass:NM_ReSpeak(reDoc)
	local result = tonumber(reDoc:GetValue("result"))
	if result == 0 then
		print("发言成功") 
	elseif result == 1 then
		print("发言过于频繁")
	elseif result == 2 then
		print("无发言权限")
	elseif result == 3 then
		print("被禁言")
	else
		print("未知错误")
	end
end 
--用类型区分显示聊天内容
function wnd_chatClass:OnClickChannel(gameObj,channel) 
	if( channel == ChannelID.sj ) then
		if self.whichChanne == ChannelID.sj then
			return
		else
			self.whichChanne = ChannelID.sj
			self:ShowChatByType(self.sjSpeak) 
		end
    elseif( channel == ChannelID.gz ) then
		if self.whichChanne == ChannelID.gz then
			return
		else
			self.whichChanne = ChannelID.gz
			self:ShowChatByType(self.gzSpeak) 
			
		end
    else -- 私聊频道
		if self.whichChanne == ChannelID.sl then
			return
		else
			self.whichChanne = ChannelID.sl
			self:ShowChatByType(self.slSpeak) 	
		end
    end
	self:BindUIEvent("btn_send",UIEventType.Click,"OnDoSendClick",channel)
end
function wnd_chatClass:OnShowDone()
	if self.whichChanne ~= -1 then
		return
	end
	self:SetLabel("tab_sj/name",_TXT(9147))
	self:SetLabel("tab_gz/name",_TXT(9148))
	self:SetLabel("tab_sl/name",_TXT(9152))
	self.showWhat = 0
	self.upate = false
	self.clear = false
	self.onSone = nil
	self.whichChanne = ChannelID.sj
	local heroPanel = self.m_Item:GetParent()--获得放邮件的容器
	for k = 1 ,#self.sjSpeak do
		local count = #self.sjSpeak+k
		local itemObj = GameObject.InstantiateFromPreobj(self.m_Item,heroPanel)
		itemObj:SetLocalPosition(Vector3.new(-(#self.sjSpeak-k),0,0))--位置出生位置
		itemObj:SetName("speak"..count)
		itemObj:SetActive(true)--激活对象
		hand1 = GameObject.Find("speak"..count.."/name")
		local label_aitem1 = hand1:GetComponent( CMUILabel.Name )--获得label组件
		label_aitem1:SetValue(self.sjSpeak[k].name)
		hand2 = GameObject.Find("speak"..count.."/says")
		local label_aitem2 = hand2:GetComponent( CMUILabel.Name )--获得label组件
		label_aitem2:SetValue(self.sjSpeak[k].nr)
		hand3 = GameObject.Find("speak"..count.."/time")
		local label_aitem3 = hand3:GetComponent( CMUILabel.Name )--获得label组件
		local times = self.sjSpeak[k].h..":"..self.sjSpeak[k].m..":"..self.sjSpeak[k].s
		label_aitem3:SetValue(times)
		self:BindUIEvent("speak"..count,UIEventType.Click,"chickOnSome",self.sjSpeak[k])
		if self.sjSpeak[k].on ~= nil then
			local onSome1 = GameObject.Find("speak"..count.."/head_bg/head")
			onSome1:SetActive(false)--激活对象
			local onSome = GameObject.Find("speak"..count.."/head_bg/head_txt")
			onSome:SetActive(true)--激活对象
		end
	end
	self:SetLabel("btn_send/txt",_TXT(9823))
	self:BindUIEvent("btn_send",UIEventType.Click,"OnDoSendClick",ChannelID.sj)
	local gridObj = self.instance:FindWidget("Grid")
	local cmgrid = gridObj:GetComponent(CMUIGrid.Name)
	cmgrid:Reposition()
	self.showWhat = #self.sjSpeak
end 
function wnd_chatClass:takeToSome(gameObj,name)
	if self.whichChanne == ChannelID.sl then	
		self:backTochat()
		return
	end	
	self.onSone = name
	local sdf = self.instance:FindWidget("tab_sl")
	local XXK = sdf:GetComponent(CMUIToggle.Name)
	XXK:SetValue(true)

	self:backTochat()
	self:OnClickChannel(gameObj,ChannelID.sl)
	local toSomeOne = GameObject.Find("input_personal/name_lable")--取出编辑框游戏对象
	local label_aitem2 = toSomeOne:GetComponent( CMUILabel.Name )--获得label组件
	label_aitem2:SetValue(name)
end
--点击某个玩家查看详细资料
function wnd_chatClass:chickOnSome(gameObj,k)	
	local name = k.name
	local zhenying = k.f	
	if zhenying == 1 then
		XSzhenying = "蜀"
	elseif zhenying == 2 then 
		XSzhenying = "魏"
	elseif zhenying == 3 then 
		XSzhenying = "吴"
	else
		XSzhenying = "未加入势力"
	end
	local Item1 = self.instance:FindWidget("sel_person")
	Item1:SetActive(true)
	hand1 = GameObject.Find("sel_person/info_close/person_info/name")
	local label_aitem1 = hand1:GetComponent( CMUILabel.Name )--获得label组件
	label_aitem1:SetValue(name)
	hand2 = GameObject.Find("sel_person/info_close/person_info/country")
	local label_aitem2 = hand2:GetComponent( CMUILabel.Name )--获得label组件
	label_aitem2:SetValue(XSzhenying)
	self:BindUIEvent("btn_starttalk",UIEventType.Click,"takeToSome",k.name)
	self:BindUIEvent("info_close",UIEventType.Click,"backTochat")
end 
function wnd_chatClass:backTochat()
	local Item1 = self.instance:FindWidget("sel_person")
	Item1:SetActive(false)
end
--服务器下发有人发言
function wnd_chatClass:NM_SomeOneSpeak(table1,table2,table3)
	self.sjSpeak = table1
	self.gzSpeak = table2
	self.slSpeak = table3
	if wnd_chat.isVisible then
		if self.upate then
			self.upate = false
		else
			self.upate = true
		end
		if self.whichChanne == ChannelID.sj then	
			self:ShowChatByType(self.sjSpeak)		
		elseif self.whichChanne == ChannelID.gz then
			self:ShowChatByType(self.gzSpeak)
		else
			self:ShowChatByType(self.slSpeak)
		end
	end
end
function wnd_chatClass:ShowChatByType(table)
	local Item1 = self.instance:FindWidget("input_normal")
	local Item2 = self.instance:FindWidget("input_personal")
	if self.whichChanne == ChannelID.sl then
		Item1:SetActive(false)
		Item2:SetActive(true)
	else	
		Item1:SetActive(true)
		Item2:SetActive(false)
	end
	if self.clear then
		for i = 1 ,self.showWhat do
			local Item = self.instance:FindWidget("speak"..900+i)
			Item:Destroy()
		end
	else
		for i = 1 ,self.showWhat do
			local Item = self.instance:FindWidget("speak"..self.showWhat+i)
			Item:Destroy()
		end
	end
	local heroPanel = self.m_Item:GetParent()--获得放邮件的容器
	local count = 0
	for k = 1 ,#table do
		if self.upate then
			count = 900 + k
			self.clear = true
		else
			count = #table+k
			self.clear = false
		end
		local itemObj = GameObject.InstantiateFromPreobj(self.m_Item,heroPanel)
		itemObj:SetLocalPosition(Vector3.new(-(#table-k),0,0))--位置出生位置
		itemObj:SetName("speak"..count)
		itemObj:SetActive(true)--激活对象
		hand1 = GameObject.Find("speak"..count.."/name")
		local label_aitem1 = hand1:GetComponent( CMUILabel.Name )--获得label组件
		label_aitem1:SetValue(table[k].name)
		hand2 = GameObject.Find("speak"..count.."/says")
		local label_aitem2 = hand2:GetComponent( CMUILabel.Name )--获得label组件
		label_aitem2:SetValue(table[k].nr)
		hand3 = GameObject.Find("speak"..count.."/time")
		local label_aitem3 = hand3:GetComponent( CMUILabel.Name )--获得label组件
		local times = table[k].h..":"..table[k].m..":"..table[k].s
		label_aitem3:SetValue(times)
		self:BindUIEvent("speak"..count,UIEventType.Click,"chickOnSome",table[k])
		if table[k].on ~= nil then
			local onSome1 = GameObject.Find("speak"..count.."/head_bg/head")
			onSome1:SetActive(false)--激活对象
			local onSome = GameObject.Find("speak"..count.."/head_bg/head_txt")
			onSome:SetActive(true)--激活对象
		end
	end
	local gridObj = self.instance:FindWidget("Grid")
	local cmgrid = gridObj:GetComponent(CMUIGrid.Name)
	cmgrid:Reposition()
	self.showWhat = #table
end
--实例即将被丢失
function wnd_chatClass:OnLostInstance()
end 

return wnd_chatClass.new
 