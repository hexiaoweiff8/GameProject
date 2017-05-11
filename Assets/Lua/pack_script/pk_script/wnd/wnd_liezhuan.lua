
local wnd_liezhuanClass = class(wnd_base)

wnd_liezhuan = nil--单例
local zhenying = {
	AllHero = 0,
	Wei = 1,
	Shu = 2,
	Wu = 3,
	Qunxiong = 4,
}
function wnd_liezhuanClass:Start() 
	wnd_liezhuan = self
	self:Init(WND.Liezhuang)

end
function wnd_liezhuanClass:SetHeroId(id) 
	self.chooseID = id 
	self.AllHero = {}
	self.Wei = {}
	self.Shu = {}
	self.Wu = {}
	self.Qunxiong = {}

	local eatchfunch = function (key,value)
		self.AllHero[#self.AllHero+1] = {ID = key, V=value }
		if value:HeroZhenying() == 1 then
			self.Wei[#self.Wei+1] ={ID = key, V=value }
		elseif value:HeroZhenying() == 2 then
			self.Shu[#self.Shu+1] = {ID = key, V=value }
		elseif value:HeroZhenying() == 3 then
			self.Wu[#self.Wu+1] = {ID = key, V=value }
		elseif value:HeroZhenying() == 4 then
			self.Qunxiong[#self.Qunxiong+1] = {ID = key, V=value }
		end
	end

    SData_Hero.Foreach(eatchfunch)
end
--窗体被实例化时被调用
--初始化实例
function wnd_liezhuanClass:OnNewInstance()
	self.bIszhu = false--是否创建过item
	self:BindUIEvent("close_btn",UIEventType.Click,"OnBackClick")
	local lizhuanScrollView = self.instance:FindWidget("gushi_panel")
	self.ScrollView = lizhuanScrollView:GetComponent(CMUIScrollView.Name)
	 --绑定选项卡事件
    self:BindUIEvent("allhero_inactive",UIEventType.Click,"HeroAll",zhenying.AllHero)--全部武将
    self:BindUIEvent("wei_inactive",UIEventType.Click,"HeroAll",zhenying.Wei)--魏国
    self:BindUIEvent("shu_inactive",UIEventType.Click,"HeroAll",zhenying.Shu)--蜀国
	self:BindUIEvent("wu_inactive",UIEventType.Click,"HeroAll",zhenying.Wu)--吴国
	self:BindUIEvent("qunxiong_inactive",UIEventType.Click,"HeroAll",zhenying.Qunxiong)--群雄
	--翻页
	self:BindUIEvent("back_btn",UIEventType.Click,"changepage",true)
	self:BindUIEvent("forward_btn",UIEventType.Click,"changepage",false)

end
function wnd_liezhuanClass:OnShowDone()
	self:showLiezhuan(obj,self.chooseID)
	self:BindUIEvent("name_bg/back_btn",UIEventType.Click,"OnBackChoose")

end 
function wnd_liezhuanClass:showLiezhuan(obj,id)
	self.chooseID = id
	local Banshen = self.instance:FindWidget( "hero_img_bg/hero_img" )
	local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
	HeroBanshen:SetIcon(self.chooseID,false)
	local scene_packet = PacketManage.GetPacket("liezhuan")--取得列传资源包
	if scene_packet:GetText("lz_"..self.chooseID) ~= nil then
		local cfgtext = scene_packet:GetText("lz_"..self.chooseID)--取得列传
		self:SetLabel("gushi_panel/story_txt",cfgtext)
	end
	local HeroName = SData_Hero.GetHero(self.chooseID):Name()
	self:SetLabel("name_bg/txt",HeroName)	
end 
function wnd_liezhuanClass:OnBackChoose()
	self.ScrollView:ResetPosition()--初始化滑动条位置
	local rewardItem1 = self.instance:FindWidget("liezhuan_inactive")
	local cmUIAttributePage =  rewardItem1:GetComponent(CMUIAttributePage.Name)
	cmUIAttributePage:SetActivity() 
	local rewardItem2 = self.instance:FindWidget("allhero_inactive")
	local cmUIAttributePage1 =  rewardItem2:GetComponent(CMUIAttributePage.Name)
	cmUIAttributePage1:SetActivity() 
	if not self.bIszhu then
		self.bIszhu = true
		local m_Item = self.instance:FindWidget("grid_hero/hero_card")
		for k, v in pairs(self.AllHero)do
			local newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("grid_hero"))
			newItem:SetName(v.ID)
			local Banshen = self.instance:FindWidget( "grid_hero/"..v.ID.."/hero_img" )
			local a =Banshen:GetComponent(CMUITexture.Name)
			self:BindUIEvent(v.ID,UIEventType.Click,"showLiezhuan",v.ID)
			self:SetLabel(v.ID.."/name_txt",v.V:Name())
			self:SetLabel(v.ID.."/info_bg/txt",v.V:Hanhua())
			self:HeroBDAll(v.ID)
		end
		self:HeroAll(obj,0)
	end
end 
function wnd_liezhuanClass:HeroBDAll(id)
	local Banshen = self.instance:FindWidget( "grid_hero/"..id.."/hero_img" )
	local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
	HeroBanshen:SetIcon(id,false)
end
function wnd_liezhuanClass:HeroAll(obj,Type)
	for k, v in pairs(self.AllHero)do
		self:SetWidgetActive("grid_hero/"..v.ID,false)
	end
	local table = self.AllHero
	if Type == 0 then
		table = self.AllHero
	elseif Type == 1 then
		table = self.Wei
	elseif Type == 2 then
		table = self.Shu
	elseif Type == 3 then
		table = self.Wu
	elseif Type == 4 then
		table = self.Qunxiong
	end
	for k, v in pairs(table)do
		for n, m in pairs(self.AllHero)do
			if tonumber(m.ID) == tonumber(v.ID) then
				self:SetWidgetActive("grid_hero/"..v.ID,true)		
			end
		end
	end
	local container = self.instance:FindWidget("grid_hero")
	local cmTable = container:GetComponent(CMUIGrid.Name)
	cmTable:Reposition()
end 
function wnd_liezhuanClass:changepage(obj,bIs)

end
function wnd_liezhuanClass:OnBackClick()
	self:Hide()
end 
--实例即将被丢失
function wnd_liezhuanClass:OnLostInstance()
end 
 
return wnd_liezhuanClass.new
 