--wnd_buzheng.lua
--Date

local wnd_buzhengClass = class(wnd_base)

wnd_buzheng = nil--单例

local CardHeroItem = {}--英雄卡片，队列中有且仅有阵上武将

------------------------------
--拖拽控制
local DragDropCtrl = class(DragDropCtrlBase)

function DragDropCtrl:Init() 
    --CMDragDropSurface
    local Surface = self.Surface
    Surface:AddDragDropMoveingEvent(self,self.OnDragDropMoveing)--绑定拖拽移动事件
    Surface:AddDragDropStartEvent(self,self.OnDragDropStartEvent)--绑定开始拖拽事件
    Surface:SetDockCheckFunc(self,self.DockCheck)--设置拖拽停靠检查函数，处理一些特殊的停靠限制
    Surface:AddDragDropJoinItemEvent(self,self.OnDragDropJoinItemEvent)--绑定拖拽物加入事件 

    Surface:AddDragDropCancelEvent(self,self.OnDragDropCancel)--绑定拖拽取消事件
end

function DragDropCtrl:OnDragDropStartEvent(dragDropItem) 
	if wnd_buzheng.bIsbianzhen then
		wnd_buzheng:bIsBZZWhero(1)
	else
		self:SetDragDropingCard(dragDropItem)--设置当前拖拽的卡片
	end
   
	

end

function DragDropCtrl:OnDragDropCancel(dragDropItem)
    print("buzheng DragDropCtrl:OnDragDropCancel#1")
	if not wnd_buzheng.bIsbianzhen then
		--移除这张卡
		if not wnd_buzheng.bIsbianzhen then
			local heroCard = self:GetDragDropingCard() --取得当前拖拽物
			local heroID = heroCard.info.sinfo:ID()
			self.CardHeroItem[heroID] = nil

			--卡片放入牌组
			exui_CardCollection:JoinCard(heroID)
			wnd_buzheng:ChangeAHero(heroID,3)
			self:OnDragDropZDL(heroID) 
		end
	else
		wnd_buzheng:bIsBZZWhero(2)
	end
  
end

function DragDropCtrl:OnDragDropMoveing(dragDropItem) 
	if not wnd_buzheng.bIsbianzhen then
		--CMDragDropItem
		local heroCard = self:GetDragDropingCard() --取得当前拖拽物
		local surface = exui_CardCollection.CMDragDropSurface --牌组拖拽表面

		--根据指针所在范围切换卡牌形状
		print("DragDropCtrl:OnDragDropMoveing===============",surface:IsHovered(),HeroCardType.Paizu,heroCard.info.OriginalType)
		local newType = ifv(surface:IsHovered(),HeroCardType.Paizu,heroCard.info.OriginalType)
		if heroCard.info.CurrType~=newType then
			heroCard.info.CurrType = newType
			heroCard:SwapType()
		end 
	end
end

--停靠检查
function DragDropCtrl:DockCheck(dragDropItem)
	if wnd_buzheng.bIsbianzhen then
		local SurfaceObj = self.Surface.gameObject--本拖拽控制器停靠表面游戏物体
		local dragDropItemSurface = dragDropItem:GetOwnerSurface()--当前拖拽物原所属的拖拽表面游戏物体
		local re = true--是否允许停靠
		if SurfaceObj:ChildCount()>1 then--阵位上已经停靠了卡片
			local toPos = dragDropItemSurface:GetPosition()--目标世界位置
				local flyObj = SurfaceObj:GetChild(2)
				local onFlyComplate = function(this,_)
				flyObj:SetParent(dragDropItemSurface)--改变父子关系
				local dragDropItem = flyObj:GetComponent(CMDragDropItem.Name) 
				dragDropItem:SetOwnerSurface(dragDropItemSurface)--变更拖拽物的所属表面
			end
			--重排卡片
			local cmItemSlot = dragDropItemSurface:GetComponent(CMQKItemSlot.Name)
			cmItemSlot:Reposition()
			flyObj:FlyTo(toPos,15,self,onFlyComplate)
		end
		--卡片是从本表面拖出的，无条件允许停回来
		
		return re
	else
		local SurfaceObj = self.Surface.gameObject--本拖拽控制器停靠表面游戏物体
		local dragDropItemSurface = dragDropItem:GetOwnerSurface()--当前拖拽物原所属的拖拽表面游戏物体
		--卡片是从本表面拖出的，无条件允许停回来
		if  GameObject.Equal(dragDropItemSurface,SurfaceObj)  then return true  end 

		local fromPaizu = GameObject.Equal(dragDropItemSurface,exui_CardCollection.DragDropSurface)--卡牌是否是从牌组拖过来的
    
		local heroID = self:GetHeroID(dragDropItem)--取出英雄ID
		local re = true--是否允许停靠
    
		if 
			fromPaizu and --从牌组拖过来的物体
			self:HasHeroID(heroID)--英雄ID已经存在于阵上
		then
			re = false--禁止停靠
		end
    
 
		if re then --允许停靠        
			if SurfaceObj:ChildCount()>0 then--阵位上已经停靠了卡片
				if fromPaizu then--卡片是从牌组拖过来的
					--销毁阵位上多余卡片
					local cobj = SurfaceObj:GetChild(1)
					local cmItem = cobj:GetComponent(CMDragDropItem.Name) 
					local card = self:GetHeroCard(cmItem)--取得卡片对象
					self.CardHeroItem[card.info.sinfo:ID()] = nil --从队列中删除
                    wnd_tuiguan:ChangeAHeroState(card.info.sinfo:ID(),3)
					--卡片飞回牌组
					StartCoroutine(self,self.coFlyToCollection,{card})

					--card:Destroy()--销毁卡片游戏物体

					--检查阵位上是否已经存在该卡片

				else --如果卡片是从别的阵位拖过来的
					--卡片飞到拖动过来的阵位上，实现交换
					local toPos = dragDropItemSurface:GetPosition()--目标世界位置
					local flyObj = SurfaceObj:GetChild(1)
					local onFlyComplate = function(this,_)
						flyObj:SetParent(dragDropItemSurface)--改变父子关系
						local dragDropItem = flyObj:GetComponent(CMDragDropItem.Name) 
						dragDropItem:SetOwnerSurface(dragDropItemSurface)--变更拖拽物的所属表面

						--重排卡片
						local cmItemSlot = dragDropItemSurface:GetComponent(CMQKItemSlot.Name)
						cmItemSlot:Reposition()
					end--end onFlyComplate

					flyObj:FlyTo(toPos,15,self,onFlyComplate)
				end--if fromPaizu
			end--if SurfaceObj:ChildCount()>0
		else--如果不允许停靠，卡片会飞回，此时改变卡牌外形为拖出前的样子
			local heroCard = self:GetDragDropingCard()

			if heroCard.info.CurrType ~= heroCard.info.OriginalType then 
				heroCard.info.CurrType = heroCard.info.OriginalType
				heroCard:SwapType()
			end
		end

		return re
	end
end


function DragDropCtrl:coFlyToCollection(param) 
    local card = param[1]--卡牌对象 
    local heroID = card.info.sinfo:ID()
    --先在牌组中创建好卡牌，并排序
    local newCard = exui_CardCollection:JoinCard(heroID,true)--新创建好的卡牌
    
    local NewCardGameObj = newCard.info.gameObject--牌组中新创建的卡牌游戏物体对象
    
    local widget = NewCardGameObj:GetComponent(CMUIWidget.Name)
    
    widget:SetAlpha(0)--让这个卡看不见，但是仍然会占位置
     

    local toPos = NewCardGameObj:GetPosition()--目标世界位置
    local flyObj = card.info.gameObject--阵位上原来的卡片游戏物体
    local onFlyComplate = function(this,_) 
        card:Destroy()--销毁飞行游戏物体
        widget:SetAlpha(1)--牌组中的卡片显示出来 
    end--end onFlyComplate 
     
    --切换外形为牌组外观
    card.info.CurrType = HeroCardType.Paizu
    card:SwapType()

    --执行飞行任务
    flyObj:FlyTo(toPos,15,self,onFlyComplate) 
end


function DragDropCtrl:OnDragDropJoinItemEvent(dragDropItem) 
	if wnd_buzheng.bIsbianzhen then
		wnd_buzheng:bIsBZZWhero(2)
	else
		--CMDragDropItem
		local heroCard = self:GetDragDropingCard()
		local heroID = heroCard.info.sinfo:ID()

		if heroCard.info.OriginalType ~= HeroCardType.Buzhen then--这是一个从排组拖过来的卡
			--对卡片的属性进行设置
			heroCard.info.OriginalType = HeroCardType.Buzhen--既然被拖近布阵界面了，原始类型变更
			self.CardHeroItem[heroID] = heroCard--卡片加入到队列
        
			exui_CardCollection:RemoveCard(heroID)--从牌组中移除这张牌
            wnd_buzheng:ChangeAHero(heroID,5)
		end
		self:OnDragDropZDL(heroID) 
	end
end
function  DragDropCtrl:OnDragDropZDL(id) 
	local GetZDL = 0
	local heroList = Player:GetHeros()
	for k,v in pairs (self.CardHeroItem) do
		for i,n in pairs (heroList) do
			if tonumber (heroList[i]:GetAttr(HeroAttrNames.DataID) ) == tonumber(k) then
				GetZDL = GetZDL + heroList[i]:GetAttr(HeroAttrNames.ZDL)
			end
		end
	end
	if GetZDL ~= 0 then
		exui_CardCollection:SetWidgetActive("btn_conferm/txt/light",true)
	else
		exui_CardCollection:SetWidgetActive("btn_conferm/txt/light",false)
	end
    wnd_buzheng:SetZDL(GetZDL)
end

function wnd_buzhengClass:SetZDL(_ZDL) 
	wnd_buzheng:SetLabel("pic_bz4/txt_bz4",string.sformat(SData_Id2String.Get(5169),math.ceil( _ZDL/100)))
	wnd_readyfight:SetZDL(math.ceil( _ZDL/100))
end

------------------------------
function wnd_buzhengClass:Start() 
	wnd_buzheng = self
	self:Init(WND.BuZheng)
	self.t = false--随机事件
	--绑定卡牌被点击事件
    EventHandles.OnHeroCardClick:AddListener(self,self.OnHeroCardClick)  

end
--初始化实例
function wnd_buzhengClass:OnNewInstance() 
	self.bIsShowCards = true --剩余手牌显示隐藏标记
	self.bid  = false
	
	self:SetWidgetActive("mask_lu",false)
	self:BindUIEvent("btn_back",UIEventType.Click,"OnBackClick")
	self:BindUIEvent("btn_bz1",UIEventType.Click,"OnBianZhenClick",1)
	self:BindUIEvent("btn_bz2",UIEventType.Click,"OnBianZhenClick",2)
    self:BindUIEvent("btn_help",UIEventType.Click,"OnHelpChick")

	self.bIszhenfa = false
    self.bzitem = self:FindWidget("bzitem")--布阵拖拽物外观模板
    self.bzitem:SetActive(false)

    self.zw = {}--阵位游戏物体列表
    local zhenweidi = self:FindWidget("zhenxing1")
    for i=1,5 do 
        local zwName = "pic_zw"..i
        table.insert(self.zw, zhenweidi:FindChild(zwName))
    end   

    --未每个拖拽表面创建拖拽控制器，一个阵位就是一个独立的拖拽表面
    for _,zwGameObj in pairs(self.zw) do  
        local Surface = zwGameObj:GetComponent(CMDragDropSurface.Name)
        local dragDropCtrl = DragDropCtrl.new(CardHeroItem, Surface)
        dragDropCtrl:Init()
    end

	self.zdllable = self.instance:FindWidget("pic_bz4/txt_bz4")

end
function wnd_buzhengClass:setType(bIs)
	self.t = bIs
end
--布阵信息同步数据
function wnd_buzhengClass:NM_ReBuZhenInfo() 
    
    local  a = ""
    local Fr = Player:GetObjectF("ply/Frms")

    local Func = function( Doc )
        local name = Doc:GetName()
        local path = Doc:GetPath()
        --print("wnd_buzhengClass:NM_ReBuZhenInfo ==== ",Doc,name,path)
        if tonumber( name ) == 1 then 
            a = Doc:GetValue(FrmsNames.ZhenPos)
            self.ZF = Doc:GetValue(FrmsNames.ZhenID)
        end
    end
    Fr:Foreach(Func)

    --for k,v in pairs( Fr ) do
    --    print("wnd_buzhengClass:NM_ReBuZhenInfo  ======  ",k,v,v:GetName())
    --    --if k == 1 then 
    --    --    self.ZF = v:GetAttr(FrmsNames.ZhenID)
    --    --    a = v:GetAttr(FrmsNames.ZhenPos)
    --    --end
    --end

	--local  a = ""
	--self.ZF = Node:GetValue(FrmsNames.ZhenID) 
    --a = Node:GetValue(FrmsNames.ZhenPos)
	self.heroZaiZhen = self:returnJLitem(a)

end
--解析同步信息中的布阵信息
function wnd_buzhengClass:returnJLitem(str)
	local item1 = {}
	local item2 = {}
	if str == "" then
		return item2
	else
		for k = 1 ,#str do
			item1[k] = string.sub(str,k,k)
		end
		local lab = ""
		for k = 1 ,#item1 do	
			lab = lab ..item1[k]	
		end
		
		local table1 = string.split(lab ,",")
		for k,v in pairs(table1)do
			table2 = string.split(v ,":")
				local rank = {}
				rank.id = table2[1]
				rank.hid = table2[2]
			item2[k]= rank
		end
		return item2
	end
end
--外形改变为布阵样式完成时被调用  
function wnd_buzhengClass:OnSwapType(heroCard,gameObj)
	local heroID = heroCard.info.sinfo:ID()
	local MaHeroInfoList = SData_Hero.GetHero(heroID)
	local cmHead = gameObj:GetComponent(CMUISprite.Name)
	MaHeroInfoList:SetHeroIcon(cmHead)

	
	--武将所属阵营图标
	local typeicon = gameObj:FindChild("pic_type1")
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..MaHeroInfoList:TypeIcon())

	local heroList = Player:GetHeros()
	for i,v in pairs (heroList) do
		if tonumber (heroList[i]:GetAttr(HeroAttrNames.DataID) )== tonumber(heroID) then
			local HeroXJ = heroList[i]:GetAttr(HeroAttrNames.XJ)
			local heronameObj = gameObj:FindChild("pic_star1/txt_num1")
			local cmLabel = heronameObj:GetComponent(CMUILabel.Name) 
			cmLabel:SetValue(HeroXJ) 
		end
	end
	--血条显示
	local pro = gameObj:FindChild( "SmallItem" )
	local pro_pro = pro:GetComponent(CMUIProgressBar.Name)
	pro_pro:SetValue(self:returnHp(heroID))
end
--获取外观模板，牌组左系统必须实现该接口
function wnd_buzhengClass:GetShapeTemplate()
    return self.bzitem
end
--第一次进布阵计算我方战斗力
function wnd_buzhengClass:GetZDL()
    local ZDLList = Player:GetAttr(PlayerAttrNames.ZDL)
    local ZDLPairs = string.split(ZDLList,',')--1:xxx,2:xxx
    local ZDLNode = string.split(ZDLPairs[1],':')--1:xxx 
    local ZDLTemp = ZDLNode[2]--xxx
    local SelfZDL = tonumber( ZDLTemp )
	if SelfZDL == nil then 
        SelfZDL = 0
    end
	return  SelfZDL
end

function wnd_buzhengClass:MaskLu(_Visible)
    self:SetWidgetActive("mask_lu",_Visible)
end

function wnd_buzhengClass:OnShowDone()
	self:SetWidgetActive("mask_lu",false)
	self:SetLabel("diban_title/txt_title",SData_Id2String.Get(5166))
	--self:BindUIEvent("formation/btn_bz3",UIEventType.Click,"bIsShowCard")--跳转控制剩余手牌界面
	self.show = false--标记是不是返回按钮发送布阵信息

	self:SetLabel("btn_bz1/txt_bz1",SData_Id2String.Get(5167))
	self:SetLabel("btn_bz2/txt_bz2",SData_Id2String.Get(5168))
	self:SetLabel("case/txt",SData_Id2String.Get(5170))



    if not self.t then
		self:NM_ReBuZhenInfo() 
		self:SetLabel("diban_name/txt_name",wnd_readyfight:GetReadyWNDMissionStr())
		self:SetZDL(self:GetZDL())
		--print("wnd_buzhengClass:OnShowDone ======================== ",self.ZF)
		self:SetLabel("pic_bz3/txt_bz3",SData_Zhenfa.Get(self.ZF):ZhenName())
		local container = self.instance:FindWidget("formation/zhenxing1")
		ZhenFaView = container:GetComponent(CMUIZhenFaView.Name)
		ZhenFaView:ResetZhenFa(self.ZF)
	else
		self:SetLabel("diban_name/txt_name","随机事件")
		self:SetZDL(0)
		self.ZF = 1
		self:SetLabel("pic_bz3/txt_bz3",SData_Zhenfa.Get(self.ZF):ZhenName())
		local container = self.instance:FindWidget("formation/zhenxing1")
		ZhenFaView = container:GetComponent(CMUIZhenFaView.Name)
		ZhenFaView:ResetZhenFa(self.ZF)
	end
	self:demoCreateCard()
    exui_CardCollection.HadEnteredBuzhen = true --用于标识进入过布阵界面

    
end
function wnd_buzhengClass:demoCreateCard()
    StartCoroutine(self,self.coDemoCreateCard,{})--启动协程
end
function wnd_buzhengClass:ZFshow()
	self:refashZDL()
	self:SetLabel("pic_bz3/txt_bz3",SData_Zhenfa.Get(self.ZF):ZhenName())

--	CardHeroItem
	local container = self.instance:FindWidget("formation/zhenxing1")
	ZhenFaView = container:GetComponent(CMUIZhenFaView.Name)
	ZhenFaView:ResetZhenFa(self.ZF)
end
function wnd_buzhengClass:refashZDL()
	local ZDL = 0
	local heroList = Player:GetHeros()
	for k,v in pairs (self:GetHeroOnZW()) do
		for i,n in pairs (heroList) do
			if tonumber (heroList[i]:GetAttr(HeroAttrNames.DataID) ) == tonumber(v.hid) then
				ZDL = ZDL + heroList[i]:GetAttr(HeroAttrNames.ZDL)
			end
		end
	end
	if ZDL ~= 0 then
		exui_CardCollection:SetWidgetActive("btn_conferm/txt/light",true)
	end
    self:SetZDL(ZDL)
end
function wnd_buzhengClass:TestChangHao1()
	local container = self.instance:FindWidget("formation/zhenxing1")
	ZhenFaView = container:GetComponent(CMUIZhenFaView.Name)
    ZhenFaView:ResetZhenFaByView()
	--ZhenFaView:ResetZhenFa(1)
end
--演示在阵位上创建几个英雄卡
function wnd_buzhengClass:coDemoCreateCard(_)

    --等待牌组界面初始化好    
    while(not exui_CardCollection:CanCreateHeroCard()) do  Yield()  end

    
    --创建牌组界面中的卡牌
    local heroStaticID = {}
    local heros = Player:GetAHeroinfos()
	if self.t then
		local eachFunc = function (syncObj)
			table.insert(heroStaticID,#heroStaticID+1,syncObj:GetValue(AHeroinfos.id))
		end
		heros:ForeachAHeroinfos(eachFunc)	
	else
		local eachFunc = function (syncObj)
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 3 then
				table.insert(heroStaticID,#heroStaticID+1,syncObj:GetValue(AHeroinfos.id))
			end
		end
		heros:ForeachAHeroinfos(eachFunc)
		local eachFunc = function (syncObj)
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 1 then
				table.insert(heroStaticID,#heroStaticID+1,syncObj:GetValue(AHeroinfos.id))
			end
		end
		heros:ForeachAHeroinfos(eachFunc)
	end
    exui_CardCollection:CreateCardCollectionItems( heroStaticID )

    for _,card in pairs(CardHeroItem) do  card:Destroy() end--销毁卡片游戏物体
    table.clear(CardHeroItem)--清空列表，这里不能用 ={} 需要保持表句柄不变化
	
	if not self.t then
   		local idx = 1
		--每个阵位上创建一个卡片
		for i = 1, 5 do 
		   local zwGameObj = self.instance:FindWidget("zhenxing1/pic_zw"..i)
		   for k , v in pairs(self.heroZaiZhen)do
				if idx == tonumber(v.id) then

					local info = {
						sinfo = SData_Hero.GetHero(v.hid),--静态英雄数据
						OriginalType = HeroCardType.Buzhen, --原始卡片类型 
					}
					--父和拖拽表面都是阵位游戏物体
					local parent = zwGameObj
					local DragDropSurface = zwGameObj						
					local newCard = exui_CardCollection:CreateHeroCard(info,parent ,DragDropSurface,nil)
					self:setHeroInfo(idx,info.sinfo:ID())
					CardHeroItem[info.sinfo:ID()] = newCard
				end		
			end
			idx = idx+1

		end
		self:bIsZWhero()   
	end
end
--设置阵位上武将状态
function wnd_buzhengClass:setHeroInfo(k,id) 
	local MaHeroInfoList = SData_Hero.GetHero(id)
	local m_H = self.instance:FindWidget("zhenxing1/pic_zw"..k.."/Hero_"..id.."/bzitem")
	local cmHead = m_H:GetComponent(CMUISprite.Name)
	MaHeroInfoList:SetHeroIcon(cmHead)

	--武将所属阵营图标
	local typeicon =  self.instance:FindWidget( "zhenxing1/pic_zw"..k.."/Hero_"..id.."/bzitem/pic_type1" )
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..MaHeroInfoList:TypeIcon())

	local heroList = Player:GetHeros()
	for i,v in pairs (heroList) do
		if tonumber (heroList[i]:GetAttr(HeroAttrNames.DataID) )== tonumber(id) then
			local HeroXJ = heroList[i]:GetAttr(HeroAttrNames.XJ)
			self:SetLabel("zhenxing1/pic_zw"..k.."/Hero_"..id.."/bzitem/pic_star1/txt_num1", HeroXJ)
		end
	end
	--血条显示
	local pro = self.instance:FindWidget( "zhenxing1/pic_zw"..k.."/Hero_"..id.."/bzitem/SmallItem" )
	local pro_pro = pro:GetComponent(CMUIProgressBar.Name)
	pro_pro:SetValue(self:returnHp(id))

end

function wnd_buzhengClass:OnBackClick() 
    exui_CardCollection:PlayCloseTwnner() --播放关闭动画
	StartCoroutine(self,self.DoClose,{})
end

function wnd_buzhengClass:DoClose() 
    self.show = true
    self.CloseType = "Close"


    Yield(0.4)
	if not self.t then
		local zdlui = self.zdllable:GetComponent(CMUILabel.Name)
		local zdl = zdlui:GetValue()
		local c = string.match(zdl, "%d+")
		wnd_readyfight:SetZDL(c)	
		self:SetBuZhenInfo()
	end
    exui_CardCollection:ReleasePaizuHero()

	EventHandles.OnWndExit:Call(WND.BuZheng)
end


--得到阵位上的武将
function wnd_buzhengClass:GetHeroOnZW()
	local table = {}
	local k = 1 
    for i=1,5 do 
        local zwName = self:FindWidget("formation/zhenxing1/pic_zw"..i)
		if zwName:ChildCount() > 0 then
			local w = zwName:GetChild(1)
			local str = tostring(w:GetName())
			local c = string.match(str, "%d+")
			local rank = {}
			rank.id = i
			rank.hid = c
			table[k] = rank
			k = k+1
		end
    end   
	return table
end

function wnd_buzhengClass:C_SetBuZhenInfoBreak_Sync()

    local zfPos = QKJsonDoc.NewArray()
	for k,v in pairs(self:GetHeroOnZW()) do
        self:ChangeAHeroIFOnFormation(v.hid)
		zfPos:Add(v.id,v.hid)
	end	
    local Str = zfPos:ToString()

    local temp = Player:GetObjectF("ply/Frms/1")
    if temp ~= nil then
        temp:SetValue("ZhenPos",Str)
    end

end

function wnd_buzhengClass:ChangeAHeroIFOnFormation(_ID)
    
    local temp = Player:GetObjectF("ply/AHeroInfos/".._ID)
    local NowState = temp:GetValue("State")
    if tonumber( NowState ) == 3 then
        temp:SetValue("State",tostring( 5 ))
    end
    
end

function wnd_buzhengClass:ChangeAHero(_ID,_State)
    --print("wnd_buzhengClass:ChangeAHero =========================== ",_ID,_State)
    local temp = Player:GetObjectF("ply/AHeroInfos/".._ID)
    temp:SetValue("State",tostring( _State ))
end

--发送阵位信息
function wnd_buzhengClass:SetBuZhenInfo()
	self:SetWidgetActive("mask_lu",false)
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","SetBuZhenInfo") 
	jsonNM:Add("t",1)
	local Formation = QKJsonDoc.NewMap()
	Formation:Add("zf",self.ZF)
	local zfPos = QKJsonDoc.NewArray()
	for k,v in pairs(self:GetHeroOnZW()) do
		zfPos:Add(v.id,v.hid)
	end	
	Formation:Add("zfPos",zfPos)
	jsonNM:Add("f",Formation)
	--local loader = GameConn:CreateLoader(jsonNM,0) 
	--HttpLoaderEX.WaitRecall(loader,self,self.NM_ReSetBuZhenInfo)
    self:C_SetBuZhenInfoBreak_Sync()
    YQ2GameConn:SendRequest(jsonNM,0,true,self,self.NM_ReSetBuZhenInfo)
end
--阵位信息回调
function wnd_buzhengClass:NM_ReSetBuZhenInfo(_Result)
    if _Result:IsFirstFinished() ~= true then return end
    local jsonDoc = CodingEasyer:GetResult(_Result)
    --print("wnd_buzhengClass:NM_ReSetBuZhenInfo1",jsonDoc,self.CloseType)
    if self.CloseType == "Close" then self.CloseType = "" return end
    if jsonDoc == nil  then 
        wnd_tuiguan:TestEnterFight()
        return
    end 

	local num = jsonDoc:GetValue("r")
	if  tonumber(num) == 0 then
		if self.show then
		else
			self:SetWidgetActive("mask_lu",true)
			self:NM_ReBuZhenInfo() 
			wnd_tuiguan:TestEnterFight()
		end

	else
		Poptip.PopMsg("保存阵位信息失败",Color.red)
	end
end
--变阵阵位
function wnd_buzhengClass:bIsBZZWhero(num)
	if num == 1 then
		for i=1,5 do 
			local zwName = self:FindWidget("zhenxing2/pic_zw"..i)
			if zwName:ChildCount() < 2 then
				local uiTween = zwName:FindChild("bg/light")
				local pageObj = uiTween:GetComponent(CMUITweener.Name)
				pageObj:ResetToBeginning()
				pageObj:PlayForward()
			end
		end
	else
		for i=1,5 do 
			local zwName = self:FindWidget("zhenxing2/pic_zw"..i)
			local uiTween = zwName:FindChild("bg/light")
			local pageObj = uiTween:GetComponent(CMUITweener.Name)
			pageObj:ResetToBeginning()
			pageObj:PlayReverse()
		end  
	end  
end
--阵位满没满
function wnd_buzhengClass:bIsZWhero()
	local bis = false
    for i=1,5 do 
        local zwName = self:FindWidget("formation/zhenxing1/pic_zw"..i)
        if zwName:ChildCount() < 2 then
			bis = true
			break
		end
    end   
	return bis
end
--自动上阵
function wnd_buzhengClass:zidongZWhero(hid)
	local tag = true
    --每个阵位上创建一个卡片
    for i = 1, 5 do 
       local zwGameObj = self.instance:FindWidget("zhenxing1/pic_zw"..i)
       if zwGameObj:ChildCount() < 1 then
			tag = false
			local info = {
				sinfo = SData_Hero.GetHero(hid),--静态英雄数据
				OriginalType = HeroCardType.Buzhen, --原始卡片类型 
			}
			--父和拖拽表面都是阵位游戏物体
			local parent = zwGameObj
			local DragDropSurface = zwGameObj						
			local newCard = exui_CardCollection:CreateHeroCard(info,parent ,DragDropSurface,nil)
			self:setHeroInfo(i,info.sinfo:ID())
			CardHeroItem[info.sinfo:ID()] = newCard
			newCard.info.OriginalType = HeroCardType.Buzhen--既然被拖近布阵界面了，原始类型变更
			exui_CardCollection:RemoveCard(hid)--从牌组中移除这张牌
			break
		end	
    end	
	if tag then
		for k,v in pairs(self:GetHeroOnZW()) do
			local zwGameObj = nil

			if self.instance:FindWidget("zhenxing1/pic_zw"..k.."/Hero_"..v.hid) ~= nil then
				zwGameObj = self.instance:FindWidget("zhenxing1/pic_zw"..k.."/Hero_"..v.hid)
			else
				zwGameObj = self.instance:FindWidget("zhenxing1/pic_zw"..k.."/Hero_"..v.hid.."(Clone)")
			end
			local zwGameObjui = zwGameObj:FindChild("bzitem/light")
			
			local pageObj = zwGameObjui:GetComponent(CMUITweener.Name)
			pageObj:ResetToBeginning()
			pageObj:PlayForward()
		end
	end
	self:ZFshow()  
end
function wnd_buzhengClass:bIsShowCard() 
	self:SetWidgetActive("herocardlab",true)
	local m_Item = self.instance:FindWidget("herocardlab")
    local pageObj = m_Item:GetComponents(CMUITweener.Name)
	if self.bIsShowCards then
		self.bIsShowCards = false
		pageObj[1]:ResetToBeginning()
		pageObj[1]:PlayForward()
		self:ShowHhero() 
	else
		self.bIsShowCards = true
		self:refashZDL()
		pageObj[2]:ResetToBeginning()
		pageObj[2]:PlayForward()
	end
end

------------------------------------------------显示剩余手牌----------------------------
function wnd_buzhengClass:ShowHhero() 
	for i = 1 ,8 do
		self:SetLabel("card_"..i.."/dead_frame/txt",SData_Id2String.Get(5016))
		self:SetLabel("card_"..i.."/yichuzhen_frame/txt",SData_Id2String.Get(5171))
	end
	self.heroStaticID = {}
	local shoupainum = 0
	local t1 ,t2,t3 =  Player:GetHeroAheroinfo()
	if t1 ~= nil then
		for k,v in pairs(t1) do 
			table.insert(self.heroStaticID,#self.heroStaticID+1,{T = 1, ID =v.ID})
		end
	end
	if t2 ~= nil then
		for k,v in pairs(t2) do 
			table.insert(self.heroStaticID,#self.heroStaticID+1,{T = 2, ID =v.ID})
			shoupainum = shoupainum + 1
		end
	end
	if t3 ~= nil then
		for k,v in pairs(t3) do 
			table.insert(self.heroStaticID,#self.heroStaticID+1,{T = 3, ID =v.ID})
		end
	end
	self:SetLabel("cih_txt_widget/txt",string.sformat(SData_Id2String.Get(5172),shoupainum))
	self.MaxPage = math.ceil(#self.heroStaticID/8)
	if  self.MaxPage > 1 then
		self:SetWidgetActive("herocardlab/btn_nextpage",true)	
	end
	self.pageNum = 1
	self:SetLabel("cih_txt_widget/page/txt",string.sformat(SData_Id2String.Get(5005),self.pageNum,self.MaxPage))
	if #self.heroStaticID >0 then
		self:settingPage()
		self:BindUIEvent("btn_nextpage",UIEventType.Click,"OnpageChick","btn_nextpage")
		self:BindUIEvent("btn_lastpage",UIEventType.Click,"OnpageChick","btn_lastpage")
	end
end


--手牌翻页
function wnd_buzhengClass:OnpageChick(gameObj,page)
	 if page == "btn_lastpage" then 
		self.pageNum = self.pageNum -1
		self:SetWidgetActive("btn_nextpage",true)
		if self.pageNum == 1 then
			self:SetWidgetActive("btn_lastpage",false)
		end
        print("当前页数",self.pageNum)

    elseif page == "btn_nextpage" then 
		self.pageNum = self.pageNum +1
		self:SetWidgetActive("btn_lastpage",true)
		if self.pageNum == self.MaxPage then
			self:SetWidgetActive("btn_nextpage",false)
		end
        print("当前页数:",self.pageNum)
    end 
	self:SetLabel("cih_txt_widget/page/txt",string.sformat(SData_Id2String.Get(5005),self.pageNum,self.MaxPage))
--	StartCoroutine(self,self.settingPage,{})
	self:settingPage()
end
function wnd_buzhengClass:settingPage()
	for k = 1, 8 do
		local pagenum = (self.pageNum-1)*8+k
		if self.heroStaticID[pagenum] ~= nil then
			self:SetWidgetActive("card_"..k,true)
			local id = self.heroStaticID[pagenum].ID
			local MaHeroInfoList = SData_Hero.GetHero(id)	
			self:SetLabel("card_"..k.."/hero_name", MaHeroInfoList:Name())

			--武将所属阵营图标
			local typeicon =  self.instance:FindWidget( "card_"..k.."/hero_type" )
			local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
			typeiconUI:SetSpriteName("t"..MaHeroInfoList:TypeIcon())

			local heroList = Player:GetHeros()
			for i,v in pairs (heroList) do
				if tonumber (heroList[i]:GetAttr(HeroAttrNames.DataID) )== tonumber(id) then
					local HeroXJ = heroList[i]:GetAttr(HeroAttrNames.XJ)
					self:SetLabel("card_"..k.."/stage_bg/stage_txt", HeroXJ)
					self:SetWidgetActive("card_"..k.."/dead_frame",false)
					self:SetWidgetActive("card_"..k.."/yichuzhen_frame",false)
					local heros = Player:GetAHeroinfos()
					local eachFunc = function (syncObj)
						if tonumber(syncObj:GetValue(AHeroinfos.id)) == tonumber(id) then
							if tonumber(syncObj:GetValue(AHeroinfos.State)) == 5 or tonumber(syncObj:GetValue(AHeroinfos.State)) == 3 then
								self:SetWidgetActive("card_"..k.."/yichuzhen_frame",true)
							elseif tonumber(syncObj:GetValue(AHeroinfos.State)) == 1 then
								self:SetWidgetActive("card_"..k.."/dead_frame",true)
							end
						end
					end
					heros:ForeachAHeroinfos(eachFunc)
					--半身像
					local Banshen = self.instance:FindWidget( "card_"..k.."/hero_img" )
					local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
					HeroBanshen:SetIcon(id,false)	
				end
			end
			local pro = self.instance:FindWidget( "card_"..k.."/collect_pro_bg" )
			local pro_pro = pro:GetComponent(CMUIProgressBar.Name)
			if self.heroStaticID[pagenum] .T == 1 then
				pro_pro:SetValue(self:returnHp(id))
			elseif self.heroStaticID[pagenum] .T == 2 then
				pro_pro:SetValue(1)
			else
				pro_pro:SetValue(0)
			end
			self:BindUIEvent("card_"..k,UIEventType.Click,"OnCard",  self.heroStaticID[pagenum].ID)			
		else
			self:SetWidgetActive("card_"..k,false)
		end
	end
end
--点击英雄卡
function wnd_buzhengClass:OnCard(obj,id)
	local tab = {}
	for k,v in pairs (self.heroStaticID)do
		tab[#tab+1] = v.ID	
	end
	wnd_heroinfo:PlayerHeroData(id,tab,2)
	wnd_heroinfo:Show()
	--WndJumpManage:Jump(WND.BuZheng,WND.Heroinfo)
end
function wnd_buzhengClass:OnHeroCardClick(heroCard)
    if heroCard.info.CurrType~=HeroCardType.Buzhen  then return end --卡牌当前类型不是布阵，忽略

    print("**布阵卡牌被点击** 英雄ID:", heroCard.info.sinfo:ID() )
end
function wnd_buzhengClass:GetAllHP(id)
	local baseHP = 0
	local SkillsLevel = {}
	local heroList = Player:GetHeros()
	for k,v in pairs (heroList) do
		if tonumber (heroList[k]:GetAttr(HeroAttrNames.DataID) ) == id then
			baseHP = heroList[k]:GetHP()--气血
			SkillsLevel = heroList[k]:GetSkillLevels()
		end
	end	
	local  bhp = nil--基础技能被动属性
	local  qhp= nil--装备属性
	if self:GetHeroAttr(id)~= nil then
		qhp = SData_Hero.CalculationEquips(self:GetHeroAttr(id))
	end
	bhp = SData_Hero.CalculateHeroBeidongSkillAttr(SData_Hero.GetHero(id),SkillsLevel) 
	local hp = 0
	if qhp ~= nil and  qhp:GetAddV() ~= 0 then
		hp = baseHP + bhp:GetAddV()+ qhp:GetAddV()
	else
		hp = baseHP + bhp:GetAddV()
	end
	return hp
end
--得到武将属性
function wnd_buzhengClass:GetHeroAttr(id) 
	local EquipList = {}
	local wujuID = 0
	local fangjuID = 0
	local wujuhave = false
	local fangjuhave = false
	local heroList = Player:GetHeros()
	for i = 1,#heroList do
		if tonumber(heroList[i]:GetAttr(HeroAttrNames.DataID)) == id then
			wujuID = heroList[i]:GetAttr(HeroAttrNames.WuID)
			fangjuID = heroList[i]:GetAttr(HeroAttrNames.FangID)
		end
	end
	local wuqi = Equip.new()--创建武器实例
	local fangju = Equip.new()--创建防具实例

	local a = Player:GetEquips()
	local eachFunc = function (syncObj)
		if syncObj:GetValue(EquipAttrNames.ID) == wujuID then
			wujuhave = true
			local num = syncObj:GetValue(EquipAttrNames.CurrSkill)
			wuqi:SetStaticID(syncObj:GetValue(EquipAttrNames.DataID))--设置装备数据
			wuqi:SetXilianST(num)--(self:returntable(num))--设置装备洗练状态	
		end
		if syncObj:GetValue(EquipAttrNames.ID) == fangjuID then
			fangjuhave = true
			local num = syncObj:GetValue(EquipAttrNames.CurrSkill)
			fangju:SetStaticID(syncObj:GetValue(EquipAttrNames.DataID))--设置装备数据ID
			fangju:SetXilianST(num)--(self:returntable(num))--设置装备洗练状态
		end
	end
	a:ForeachEquips(eachFunc)
	if fangjuhave  and wujuhave then
		return wuqi,fangju
	elseif not fangjuhave  and wujuhave then
		return wuqi
	elseif not wujuhave  and fangjuhave then
		return fangju
	end
end 
--血条数值
function wnd_buzhengClass:returnHp(heroID) 
	local Hp = self:GetAllHP(heroID) 
	local hp = 0
	local b = Player:GetAHeroinfos()
	local eachFunc = function (syncObj)
		if tonumber (syncObj:GetValue(AHeroinfos.id))== tonumber(heroID) then
				hp = tonumber(syncObj:GetValue(AHeroinfos.hp))
                --print("wnd_buzhengClass:returnHp 2222================= ",syncObj:GetPath())
		end
	end
	b:ForeachAHeroinfos(eachFunc)

    --print("wnd_buzhengClass:returnHp ================= ",heroID,hp,Hp)

	if hp == -1 then
		return  1
	else
		return(hp/Hp)
	end
		
end
----------------------------------------------变阵界面----------------------------------------------
--阵法显示
function wnd_buzhengClass:OnBianZhenClick(gameObj,t) 
	if t == 1 then 
		self:SetWidgetActive("zhenfa",true)
		self:SetLabel("pic_zftitle/Label",SData_Id2String.Get(5173))
		self.bIsbianzhen = false--记录变阵是否需要重新创建英雄
		self:Creatzhenfa()

		self:BindUIEvent("diban_zf1",UIEventType.Click,"OnBackToBuZhenClick")
	elseif t == 2 then
		if not self.t then
			wnd_readyfight:BtnVisibleBool(false) 
			wnd_readyfight:Show() 
		else
			wnd_readyfight:BtnVisibleBool(false)
			wnd_readyfight:SetCity(ReadyFightType.Random,tonumber(wnd_tuiguan.sjid))			
			wnd_readyfight:Show()
			

		end    
	end

end
function wnd_buzhengClass:TestChangHao2()
	local container = self.instance:FindWidget("diban_zf2/zhenxing2")
	local zhenxing = container:GetComponent(CMUIZhenFaView.Name)
    zhenxing:ResetZhenFaByView()
end
--创建阵法选项图标
function wnd_buzhengClass:Creatzhenfa()
	if not self.bIszhenfa then
		self.bIszhenfa = true
		self:SetLabel("pic_off1/txt_off1",SData_Id2String.Get(5113))
		local m_Item = self.instance:FindWidget("zhenfagrid/pic_zhenfa1")
		local eatchfunch = function (key,value)
			local newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("zhenfagrid"))
			newItem:SetName("head"..key)
			self:SetLabel("head"..key.."/diban_name1/txt_name1",SData_Zhenfa.Get(key):ZhenName())
			newItem:SetActive(true)
			local spriteICON = newItem:GetComponent(CMUISprite.Name)
			spriteICON:SetSpriteName(SData_Zhenfa.Get(key):Icon())
			self.bid = false
			local bIs = false
			if Player:GetNumberAttr(PlayerAttrNames.Level) >= tonumber(SData_Zhenfa.Get(key):StartLv()) then
				bIs = false
			else
				self:SetLabel("head"..key.."/pic_off1/txt_off1",string.sformat(SData_Id2String.Get(5375),SData_Zhenfa.Get(key):StartLv()))
				bIs = true
			end
			self:SetWidgetActive("head"..key.."/pic_off1",bIs)
			self:BindUIEvent("head"..key,UIEventType.Click,"OnchooseZFClick",key)		
		end
		SData_Zhenfa.Foreach(eatchfunch)  

		local gridObj = self.instance:FindWidget("zhenfagrid")
		local cmgrid = gridObj:GetComponent(CMUIGrid.Name)
		cmgrid:Reposition()	
	else
		local eatchfunch = function (key,value)
			self.bid = false
			local bIs = false
			if Player:GetNumberAttr(PlayerAttrNames.Level) >= tonumber(SData_Zhenfa.Get(key):StartLv()) then
				bIs = false
			else
				self:SetLabel("head"..key.."/pic_off1/txt_off1",string.sformat(SData_Id2String.Get(5375),SData_Zhenfa.Get(key):StartLv()))
				bIs = true
			end
			self:SetWidgetActive("head"..key.."/pic_off1",bIs)
			self:BindUIEvent("head"..key,UIEventType.Click,"OnchooseZFClick",key)		
		end
		SData_Zhenfa.Foreach(eatchfunch)  
	end
	self:OnchooseZFClick(obj,self.ZF)
end
--阵法选中状态
function wnd_buzhengClass:showxuanzhong()
	local ItemPosition = self.instance:FindWidget("head"..self.ZF):GetPosition()
	local txtable = self.instance:FindWidget("zhenfatuozhuai/tx_zfsel")
	txtable:SetPosition(ItemPosition)
	self:SetWidgetActive("zhenfatuozhuai/tx_zfsel",true)
end
function wnd_buzhengClass:GetZF()
	return self.ZF
end
--选择阵法
function wnd_buzhengClass:OnchooseZFClick(obj,id)
	if self.ZF == id and self.bIsbianzhen then
		return
	else
		self.ZF = id
	end
	self:showxuanzhong()
	local container = self.instance:FindWidget("diban_zf2/zhenxing2")
	local zhenxing = container:GetComponent(CMUIZhenFaView.Name)
	zhenxing:ResetZhenFa(self.ZF)

	if not self.bIsbianzhen then
		--self.bIsbianzhen = false
		local tAb = self:GetHeroOnZW()
		local m_card = self.instance:FindWidget("zhenxing2/pic_hero")
		self.bzzw = {}--阵位游戏物体列表
		local zhenweidi = self:FindWidget("zhenxing2")
		for i=1,5 do 
			local zwName = "pic_zw"..i
			table.insert(self.bzzw, zhenweidi:FindChild(zwName))
		end  
		--未每个拖拽表面创建拖拽控制器，一个阵位就是一个独立的拖拽表面
		for _,zwGameObj in pairs(self.bzzw) do  
			local Surface = zwGameObj:GetComponent(CMDragDropSurface.Name)
			local dragDropCtrl = DragDropCtrl.new(CardHeroItem, Surface)
			dragDropCtrl:Init()
		end
		local idx = 1
		--每个阵位上创建一个卡片
		for i = 1, #self.bzzw do 
			self.bIsbianzhen = true
			self.bid = true
			local zwGameObj = self.instance:FindWidget("zhenxing2/pic_zw"..i)
			for k , v in pairs(tAb)do
				if idx == tonumber(v.id) then
					local newItem = GameObject.InstantiateFromPreobj(m_card,zwGameObj)
					local dragDropItem = newItem:GetComponent(CMDragDropItem.Name)
					dragDropItem:SetOwnerSurface(zwGameObj)
					newItem:SetName("card"..v.hid)
					self:showheroHeadonZW(idx,v.hid)
					newItem:SetActive(true)
				end		
			end
			idx = idx+1
		end		
	end
end
function wnd_buzhengClass:showheroHeadonZW(k,id)
	local MaHeroInfoList = SData_Hero.GetHero(id)
	local m_H = self.instance:FindWidget("zhenxing2/pic_zw"..k.."/card"..id.."/pic_frame")
	local cmHead = m_H:GetComponent(CMUISprite.Name)
	MaHeroInfoList:SetHeroIcon(cmHead)
	--武将所属阵营图标
	local typeicon =  self.instance:FindWidget( "zhenxing2/pic_zw"..k.."/card"..id.."/pic_type1" )
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..MaHeroInfoList:TypeIcon())

	local heroList = Player:GetHeros()
	for i,v in pairs (heroList) do
		if tonumber (heroList[i]:GetAttr(HeroAttrNames.DataID) )== tonumber(id) then
			local HeroXJ = heroList[i]:GetAttr(HeroAttrNames.XJ)
			self:SetLabel("zhenxing2/pic_zw"..k.."/card"..id.."/pic_star1/txt_num1", HeroXJ)
		end
	end

end
function wnd_buzhengClass:GetHweoZWaTbianzhen() 
	self.bIanZhentab = {}
	local k = 1 
    for i=1,5 do 
        local zwName = self:FindWidget("diban_zf2/zhenxing2/pic_zw"..i)
		if zwName:ChildCount() > 1 then
			local w = zwName:GetChild(2)
			local str = tostring(w:GetName())
			local c = string.match(str, "%d+")
			local rank = {}
			rank.id = i
			rank.hid = c
			self.bIanZhentab[k] = rank
			k = k+1
		end
    end 
end
function wnd_buzhengClass:OnBackToBuZhenClick() 
	self:GetHweoZWaTbianzhen() 
	for _,card in pairs(CardHeroItem) do  card:Destroy() end--销毁卡片游戏物体
    table.clear(CardHeroItem)--清空列表，这里不能用 ={} 需要保持表句柄不变化

   	local idx = 1
    --每个阵位上创建一个卡片
	for i = 1, 5 do 

       local zwGameObj = self.instance:FindWidget("zhenxing1/pic_zw"..i)
	   for k , v in pairs(self.bIanZhentab)do
			if idx == tonumber(v.id) then
				local info = {
					sinfo = SData_Hero.GetHero(v.hid),--静态英雄数据
					OriginalType = HeroCardType.Buzhen, --原始卡片类型 
				}

				--父和拖拽表面都是阵位游戏物体
				local parent = zwGameObj
				local DragDropSurface = zwGameObj

				local newCard = exui_CardCollection:CreateHeroCard(info,parent ,DragDropSurface,nil)

				self:setHeroInfo(idx,info.sinfo:ID())

				CardHeroItem[info.sinfo:ID()] = newCard

			end		
		end
		idx = idx+1

	end
	if self.bIsbianzhen then
		for i = 1,5 do
			local Temp = self.instance:FindWidget("zhenxing2/pic_zw"..i)
			if Temp:ChildCount() > 1 then
				local w = Temp:GetChild(2)
				w:Destroy()
			end
		end
	end
	self.bIsbianzhen = false
	self:ZFshow()
	self:SetWidgetActive("zhenfa",false)

end
--实例即将被丢失
function wnd_buzhengClass:OnLostInstance() 
    self.bzitem = nil
    table.clear(CardHeroItem)--界面资源被回收，清空卡牌
end

--帮助按钮的调用函数
function wnd_buzhengClass:OnHelpChick()
    exui_CardCollection:OnHelpChick()
end

return wnd_buzhengClass.new
 