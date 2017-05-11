--region *.lua
--Date20160628
--牌组

local exui_CardCollectionClass = class(wnd_base)
exui_CardCollection = nil

local ZYHeroList = {}
local CardHeroItem = {}  --用于创建对象 
local heroStaticID = {}  --用于保存ID信息 

local   CurrCardNum = 0       --卡组武将数量
local   CardCollectMax = 0  --卡组武将最大值
local CreatedCard = false
local CardState = {
    Normal = 1,--常态
    Lockd = 2,--被锁定的
} 

local SurfaceCfg = {}--左系统英雄牌组系统相关属性定义
SurfaceCfg[HeroCardType.Paiku]= {  flyOnCancel = false } 
SurfaceCfg[HeroCardType.Buzhen]= { flyOnCancel = true}

 



------------------------------
--拖拽控制
local DragDropCtrl = class(DragDropCtrlBase)

function DragDropCtrl:Init()
    local Surface = self.Surface;
    --CMDragDropSurface
    Surface:AddDragDropMoveingEvent(self,self.OnDragDropMoveing)
    Surface:AddDragDropStartEvent(self,self.OnDragDropStartEvent)--绑定开始拖拽事件 
    Surface:AddDragDropJoinItemEvent(self,self.OnDragDropJoinItemEvent)--绑定拖拽物加入事件 
    Surface:AddDragDropLeaveEvent(self,self.OnDragDropLeaveEvent)--绑定拖拽物离开事件 
    Surface:SetDockCheckFunc(self,self.DockCheck)--设置拖拽停靠检查函数，处理一些特殊的停靠限制
    Surface:AddDragDropCancellingEvent(self,self.OnDragDropCancelling)--绑定拖拽取消事件
end


--停靠检查
function DragDropCtrl:DockCheck(dragDropItem)
    --卡片是从本界面拖出的，无条件允许停回来
    
    if  GameObject.Equal(dragDropItem:GetOwnerSurface(),exui_CardCollection.DragDropSurface)  then
        return true
    end

    local heroID = self:GetHeroID(dragDropItem)--取出英雄ID
    local re = not self:HasHeroID(heroID)--不允许加入重复的英雄
    local heroCard = self:GetDragDropingCard()

    local leftWnd = exui_CardCollection:GetLeftSystemWnd()--获取左系统窗体
    if leftWnd~=nil and leftWnd.DockCheckCollection~=nil then--左系统实现了牌库停靠检查
        if not leftWnd:DockCheckCollection(heroCard ) then --回调接口
            re = false
        end
    end 

    if re then
        --不允许布阵界面的图标停靠
        if heroCard.info.OriginalType == HeroCardType.Buzhen then re = false end
    end 
    
    --如果不允许停靠，卡片会飞回，此时改变卡牌外形为拖出前的样子
    if not re then
        heroCard.info.CurrType = heroCard.info.OriginalType
        heroCard:SwapType()
    end
    return re
end


function DragDropCtrl:OnDragDropCancelling(dragDropItem)
    local tmpCfg = SurfaceCfg[exui_CardCollection:GetLeftSystemType()]--牌库中的卡牌退拽失败是否飞回
    local heroCard = self:GetDragDropingCard()
    if tmpCfg == nil then  
        return nil 
    end 
    if tmpCfg ~= nil and tmpCfg.flyOnCancel then--需要飞回
         --卡片变为原外形
        local heroCard = self:GetDragDropingCard()
        if heroCard ~= nil then
            heroCard.info.CurrType = heroCard.info.OriginalType
            heroCard:SwapType()
        end
    end
end

function DragDropCtrl:OnDragDropJoinItemEvent(dragDropItem) 
    local heroCard = self:GetDragDropingCard()
    local gameObj = heroCard.info.gameObject
    exui_CardCollection.TheLastDraddingCard = heroCard
    if heroCard.info.CurrType == HeroCardType.Paiku then
        if self.PaiZuLastHeroID ~= heroCard.info.sinfo:ID() then
            gameObj:SetActive(false)
            StartCoroutine(self,wnd_CardHouse.coFlyToCollection,{heroCard}) --启用协程重新创建卡牌,0表示不是最后一张牌
        end

    end

    local heroID = heroCard.info.sinfo:ID()
	self.CardHeroItem[heroID] = heroCard--卡片加入到队列
    if self.PaiZuLastHeroID ~=heroID then
        exui_CardCollection.PaiZuHeroNum = exui_CardCollection.PaiZuHeroNum + 1
    end
    local LightBG = gameObj:FindChild("pic_tx")
    LightBG:SetActive(false)

    local leftWnd = exui_CardCollection:GetLeftSystemWnd()--获取左系统窗体
    if leftWnd~=nil and leftWnd.OnCardJoinCollection~=nil then--左系统实现了卡牌进入牌组的回调接口
        leftWnd:OnCardJoinCollection(heroID, heroCard) --回调接口
    end

    --对卡片的属性进行设置
    heroCard.info.OriginalType = HeroCardType.Paizu--既然被拖近排组了，原始类型变更为牌组
    --排序
    local cardList = {}
    cardList[heroID] = heroCard
    exui_CardCollection.CardDragStart = false
    exui_CardCollection:Reposition(false,cardList)
    self.PaiZuLastHeroID = 0
end

function DragDropCtrl:OnDragDropLeaveEvent(dragDropItem) 

    local heroCard = self:GetDragDropingCard()
    local heroID = self:GetHeroID(dragDropItem)

    exui_CardCollection.PaiZuHeroNum = exui_CardCollection.PaiZuHeroNum - 1
    local leftWnd = exui_CardCollection:GetLeftSystemWnd()--获取左系统窗体
    if leftWnd~=nil and leftWnd.OnCardLeaveCollection~=nil then--左系统实现了卡牌离开牌组的回调接口
        leftWnd:OnCardLeaveCollection(heroID, heroCard) --回调接口
    end
    self.CardHeroItem[heroID] = nil  
    --设置使得最后一张牌能够飞回去
    self.num = 0
    self.PaiZuLastHeroID = 0
    for k,v in pairs(self.CardHeroItem) do
        self.num = self.num + 1
    end
    if self.num == 0 then
        self.PaiZuLastHeroID = heroID
        StartCoroutine(self,wnd_CardHouse.coFlyToCollection,{heroCard})
        exui_CardCollection.PaiZuHeroNum = 1
    end
    exui_CardCollection.CardDragStart = false

end



function DragDropCtrl:OnDragDropStartEvent(dragDropItem) 
    self.Surface = exui_CardCollection.CMDragDropSurface
    self:SetDragDropingCard(dragDropItem)--设置当前拖拽的卡片 
    self.DragCard = self:GetDragDropingCard()--找到拖动的卡片 

    if self.DragCard == nil then return nil end
    exui_CardCollection:SetPaiZuLockFrame(0)    
    local itemGameObj = self.DragCard.info.gameObject
    local LightBG = itemGameObj:FindChild("pic_tx")
    LightBG:SetActive(true)
    self.DragFirstTime = true --用于控制牌组闪烁问题
    self.LeftSysType = exui_CardCollection:GetLeftSystemType() --获取左系统
    if self.LeftSysType == HeroCardType.Paiku then
        exui_CardCollection.CardDragStart = true
        exui_CardCollection:SetAddHeroBtnHidePos() --设置“+”位置
        wnd_CardHouse.StartDragPaizu = true
    end
    exui_CardCollection.SimpleInfo:SetActive(false)
end

function DragDropCtrl:OnDragDropMoveing(dragDropItem) 
    --根据指针所在范围切换卡牌形状

    local move = self.Surface:IsHovered()
    if self.DragFirstTime then --由于在牌组中牌拿起来的一瞬间 move 值会有一真一假两个值
        move = true
        self.DragCard.info.OriginalType = HeroCardType.Paizu
    end
    local newType = ifv(move,self.DragCard.info.OriginalType,self.LeftSysType)
    if self.DragCard.info.CurrType~=newType  then
        self.DragCard.info.CurrType = newType
        self.DragCard:SwapType() 
    end 
    self.DragFirstTime = false
end
 


------------------------------
--牌组界面

function exui_CardCollectionClass:Start()
	exui_CardCollection = self 
	self:Init(WND.CardCollection) 
end

function exui_CardCollectionClass:RemoveCard(heroID)
    if CardHeroItem[heroID]==nil then return end --卡牌不存在

    CardHeroItem[heroID]:Destroy()--销毁卡牌游戏物体
    CardHeroItem[heroID] = nil--从队列移除
    self:Reposition()--重排
end


--创建一张卡片并加入
function exui_CardCollectionClass:JoinCard(heroID,inCo)
    local info = {
            sinfo = SData_Hero.GetHero(heroID),--静态英雄数据
            OriginalType = HeroCardType.Paizu, --原始卡片类型 
    }

    local parent = self.TemplateWidget:GetParent()
    local newCard = self:CreateHeroCard(info,parent ,self.DragDropSurface,self.CMScrollView)
    CardHeroItem[info.sinfo:ID()] = newCard

    local cardList = {}
    cardList[newCard.info.sinfo:ID()] = newCard
    self:Reposition(true,cardList,inCo)--重排
    return newCard
end

--用于设置牌组中用于标记操作状态
function exui_CardCollectionClass:SetPaiZuLockFrame(tags)
    if tags == 0 then
        self.Frame:SetActive(false)
    elseif tags == 1 and self.AllowDragPaiZu then
        self.Frame:SetActive(true)
    end
end

function exui_CardCollectionClass:OnNewInstance()

    self.PaizuHadCreated = false
    self.HadEnteredBuzhen = false --进入过布阵界面
    self.CancelSavePaizu = false

    self.PaiZuHeroNum = 0 --牌组中的英雄数量
    self.BtnConferm = self:FindWidget("btn_conferm")
    self:BindUIEvent("btn_conferm",UIEventType.Click,"OnFinish")
    self:BindUIEvent("btn_help",UIEventType.Click,"OnHelpChick")
	self:BindUIEvent("helpclose",UIEventType.Click,"OnHelpBackChick")
    self:BindUIEvent("btn_conferm/lock",UIEventType.Click,"OnUnLockPZ")
    self:BindUIEvent("addhero_btn",UIEventType.Click,"OnAddheroBtnChick")
    self:BindUIEvent("cardlabscrollview/scrollrange",UIEventType.Press,"OnScrollrangePress")

    local scrollView = self:FindWidget("cardlabscrollview") 
    self.cardlabscrollview = self:FindWidget("cardlabscrollview") 
    self.CMScrollView = scrollView:GetComponent(CMUIScrollView.Name)--滚动视组件
    self.Table = scrollView:FindChild("Table")
    self.TableTweener = self.Table:GetComponents(CMUITweener.Name)
    self.TableGrid = self.Table :GetComponent( CMUITable.Name)
--    self.Table:SetActive(true)
    self.Tail = self.Table:FindChild("tail")
    self.Tail2 = self:FindWidget("tail2") --用于播放拖尾回弹动画
--    self.Tail:SetActive(true)

    self.Grid = scrollView:FindChild("Grid")--取出格子
    self.GridTweener = self.Grid:GetComponents(CMUITweener.Name)
    self.TemplateWidget = self.Grid:FindChild("hero_item")--取出英雄卡片模板

    self.TemplateWidget:SetActive(false)--隐藏模板
    self.DragDropSurface = self:FindWidget("DragDropSurface")--拖拽表面
    self.CMGrid = self.Grid:GetComponent(CMUIGrid.Name)--取出格子组件
    self.CMDragDropSurface = self.DragDropSurface:GetComponent(CMDragDropSurface.Name)

--    self.scrollContainer = self.CMDragDropSurface:AddComponent( CMScrollContainer.Name )
--    print("---------------------回弹速度",self.scrollContainer:GetSpringSpeed())

    --创建拖拽控制器
    local dragDropCtrl = DragDropCtrl.new(CardHeroItem,self.CMDragDropSurface)
    dragDropCtrl:Init()

    self.ScrollBar = self:FindWidget("scrollbar") --牌组右侧滚动条
    self.Frame = self:FindWidget("frame_panel/frame") --牌组可编辑提示框
    self.LockPaiZuFrame = self:FindWidget("frame_panel/lockframe") --牌组锁定状态框
    self.LockBtnFinish = self:FindWidget("frame_panel/btn_conferm/lock") --完成按钮锁定
    self.playTipsTxt  = self:FindWidget("frame_panel/movecard_tips")

--    self:SetLabel("btn_conferm/lock/txt",SData_Id2String.Get(5317)) --缺少ID2
	self:SetLabel("card_lab_top/card_lab_txt1_bg/txt1",SData_Id2String.Get(5008)) 
    self.LockPaiZuTipsTxt = self.playTipsTxt:GetComponent(CMUILabel.Name)

    self.BtnConfermLight = self.instance:FindWidget("btn_conferm/txt/light")
    self.NextHero = self.instance:FindWidget("card_lab_top/next_hero")
    self.card_lab_txt1_bg = self.instance:FindWidget("card_lab_top/card_lab_txt1_bg")
    self.heloClose = self.instance:FindWidget("helpclose")
    self.tips_bg = self.instance:FindWidget("frame_panel/tips_bg")
    self.hero_small_bg = self.NextHero:FindChild("hero_small_bg")
    self.empty = self.NextHero:FindChild("empty")

    self.txt_helptitle = self.instance:FindWidget("helpclose/pic_helpdi/txt_helptitle"):GetComponent(CMUILabel.Name)
    self.txt_helpnote = self.instance:FindWidget("helpclose/pic_helpdi/txt_helpnote"):GetComponent(CMUILabel.Name)
    self.tips_bg_txt = self.instance:FindWidget("frame_panel/tips_bg/txt"):GetComponent(CMUILabel.Name)
    self.btn_conferm_txt = self.instance:FindWidget("frame_panel/btn_conferm/txt"):GetComponent(CMUILabel.Name)

    --长按牌组中的英雄显示英雄简短信息
	self.bIsShowStar = false --用于标记是否创建星星(根据英雄信息)
    self.SimpleInfo = self:FindWidget("info_bg") 
    self.AddHeroBtn = self:FindWidget("addhero_btn") --"+"号按钮
    self.addHBTweener = self.AddHeroBtn:GetComponents(CMUITweener.Name)
    self.BasicInfo = self.SimpleInfo:FindChild("basic_info_widget")  --基本信息
    self.SkillInfo = self.SimpleInfo:FindChild("skill_info_widget")  --技能信息
    self.SoldierInfo = self.SimpleInfo:FindChild("soldier_info_widget")  --士兵信息
    self.SimpleInfoTip = self.SimpleInfo:GetComponent(CMUITweener.Name)
    self.BasicInfo:FindChild("zhandouli"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5013))
    self.SkillInfo:FindChild("title"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5014))
    self.SoldierInfo:FindChild("title"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5015))
end
 


--- <summary> 
--- 功能 : 判定当前是否能创建英雄卡片
--- ret : bool
--- </summary>
--- <returns type="bool"></returns>
function exui_CardCollectionClass:CanCreateHeroCard()
    return self.TemplateWidget~=nil
end

--- <summary> 
--- 功能 : 创建一张英雄卡片，其它界面创建卡片也调用本接口
--- info : table 英雄属性，所有面板的属性列表应该具有一致性
--- parent : GameObject 父物体
--- DragDropSurface : GameObject 具有拖拽表面组件的游戏物体 
--- scrollView : CMUIScrollView 
--- ret : HeroCard
--- </summary>
--- <returns type="HeroCard"></returns>
function exui_CardCollectionClass:CreateHeroCard(info,parent,DragDropSurface,scrollView)
    if self.TemplateWidget==nil then
        debug.LogError("试图在牌组界面尚未初始化时创建卡片")
        return
    end
	 
    --创建游戏物体
    info.gameObject = GameObject.InstantiateFromPreobj(self.TemplateWidget,parent)
    info.gameObject:SetName("Hero_"..info.sinfo:ID())
    if info.OriginalType == HeroCardType.Paizu then
        info.gameObject:SetActive(false) 
    else
        info.gameObject:SetActive(true) 
    end
    --克隆出左系统拖拽物
    local leftWnd = self:GetLeftSystemWnd()
    if leftWnd.GetShapeTemplate==nil then debug.LogError("排组左系统必须实现 GetShapeTemplate") end
	 

    if leftWnd~=nil and info.OriginalType==HeroCardType.Paizu and leftWnd.AttachedInfoCollection~=nil then--左系统实现了卡牌附加信息接口
        leftWnd:AttachedInfoCollection(info) --回调接口
    end
        
    local shapeTemplate = leftWnd:GetShapeTemplate()--取得外观模板
    info.shape = GameObject.InstantiateFromPreobj(shapeTemplate,info.gameObject)--克隆出左系统卡片外观
    info.shape:SetName(shapeTemplate:GetName()) 
    --将第三方系统的外观预置加入到拖拽物
    info.shape:SetParent(info.gameObject)
    info.shape:SetLocalPosition(Vector3.Zero())
    info.CurrType = info.OriginalType
    local card = HeroCard.new(info)--构造出英雄卡
    card:Init()--初始化
    card:SwapType()--立即切换到当前类型 
    card:SetDragDropSurface(DragDropSurface)--设定拖拽表面
    card:SetScrollView(scrollView)--设定滚动视 
	 
    return card
end




--创建牌组中的卡牌
function exui_CardCollectionClass:CreateCardCollectionItems(heroIDList)
    local LeftSysType = self:GetLeftSystemType()
    self.CanCreatePaizu = true

    if  LeftSysType == HeroCardType.Buzhen then  --只要是布阵界面就重新创建
        self.CanCreatePaizu = true
    else
        if self.HadEnteredBuzhen then  --进入过布阵界面回到牌库需要重新重建
            self.CanCreatePaizu = true
        else
            --没有进入过牌库，牌库没有被创建或者"+"号添加英雄,退出的时候取消保存牌组操作 的时候需要重新创建
            self.CanCreatePaizu = not self.PaizuHadCreated or self.HadAddTheHeroToPaiZu or self.CancelSavePaizu 
        end
    end

    if self.CanCreatePaizu  then 
        local tmpCfg = SurfaceCfg[LeftSysType]--牌库中的卡牌退拽失败是否飞回
        self.CMDragDropSurface:SetFlyOnCancel(tmpCfg.flyOnCancel)
        for k,v in pairs(CardHeroItem) do   v:Destroy() end
        table.clear(CardHeroItem)   
     
        local parent = self.TemplateWidget:GetParent()
        for i = 1, #heroIDList do 
            local heroID = heroIDList[i]
            local info = {
                sinfo = SData_Hero.GetHero(heroID),--静态英雄数据
                OriginalType = HeroCardType.Paizu, --原始卡片类型 
                PaiZCardState = CardState.Normal --仅牌库系统需要用到的卡片状态信息
            }
            CreatedCard = true
            local newCard = self:CreateHeroCard(info,parent ,self.DragDropSurface,self.CMScrollView)
            CardHeroItem[info.sinfo:ID()] = newCard

            --用于牌组界面重新创建的时候刷新牌库中的状态使得牌库中对应得卡牌为锁定状态
            wnd_CardHouse:setDropCardItemList(info.sinfo:ID(),newCard)
        end 
        if  LeftSysType == HeroCardType.Paiku then  --只有当左系统为牌库时候标识创建过
            self.CancelSavePaizu = false
            self.PaizuHadCreated = true
            self.FirstCreatePaizuHeroCard = true
        end
        self:Reposition(true)
    end
    --重排

    if LeftSysType == HeroCardType.Paiku then 
        if self.PaizuHadCreated then
            for k,v in pairs(CardHeroItem) do   v.info.gameObject:SetActive(true) end
        end
        self.gridChildNum = self.Grid:ChildCount()-1
        if not self.CanCreatePaizu  then --只要在不创建牌组中牌的时候播放动画
            self.AddHeroBtn:SetActive(false)
            self.GridTweener[1]:ResetToBeginning()
            self.addHBTweener[1]:ResetToBeginning()
            self.GridTweener[1]:PosFromToY(90*self.gridChildNum + 208,208)

--            self.addHBTweener[1]:PosFromToY(301,self.currAddHeroBtnPosY)

            StartCoroutine(self,self.ResetScrollView,{})

            self.SimpleInfoTip:PosFromToY(0,100)
        end
	    self:ShowCZHeroInfo(2) --直接获取服务器上的牌组中的英雄
        wnd_CardHouse:SetLockFrame()
        self.PaiZuHeroNum = #heroIDList
    else
--        local gridChild = self.Grid:ChildCount()-1
--        self.GridTweener[1]:ResetToBeginning()
--        self.GridTweener[1]:PosFromToY(90*gridChild + 208,208)

--        StartCoroutine(self,self.ResetScrollView,{})
    end
end

function exui_CardCollectionClass:ResetScrollView()
    Yield(0.4)
    if self:GetLeftSystemType()== HeroCardType.Paiku then 
        self.GridTweener[1]:PosFromToY(208,208) --0-208有很小的回弹效果(208-208没有)
        self.CMScrollView:ResetPosition()
       self:SetAddHeroBtnHidePos() --用于设置自动添加英雄按钮的显隐性
    else
        self.GridTweener[1]:PosFromToY(208,208)
        self.CMScrollView:ResetPosition()
    end
end

--在推关界面放弃战斗
function exui_CardCollectionClass:GiveUpAtTuiguan( )
    --推关界面放弃战斗后牌组中的卡牌需要重新创建
    self.PaizuHadCreated = false
end

--解决点击拖动的时候点击滚动视图牌组固定在当期位置不在回弹的问题
function exui_CardCollectionClass:OnScrollrangePress(gameObj,falg)
    if not flag then
	    self.CMScrollView:UpdatePosition()
    end
end

--牌库中卡牌按压后不显示英雄的简单介绍
function exui_CardCollectionClass:OnPressEvent() 
    self.SimpleInfo:SetActive(false) 
end

--长按回调 显示响应英雄的简短信息
function exui_CardCollectionClass:OnLongPressEvent(heroID)  
    local heroData = SData_Hero.GetHero(heroID)
    self.SimpleInfo:SetActive(true)
    self.SimpleInfoTip:ResetToBeginning() 
    self.SimpleInfoTip:PlayForward()
	--武将所属阵营图标
	local typeicon = self.BasicInfo:FindChild("hero_type")
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..heroData:TypeIcon())

    local heroName = self.BasicInfo:FindChild("hero_name")  --英雄名字
    local nameLabel = heroName:GetComponent(CMUILabel.Name) 
    nameLabel:SetValue(heroData:Name())

    local starGrid = self.BasicInfo:FindChild("stargrid")
    local heroStar = self.BasicInfo:FindChild("stargrid/star") --英雄星级
    local starNum = heroData:MorenXing()
    local ZDL = 0

    local PlayerHero = Player:GetHeros()
    for i =1, #PlayerHero do
        id = PlayerHero[i]:GetAttr(HeroAttrNames.DataID)
        if tonumber( heroID ) == tonumber( id ) then
            starNum = PlayerHero[i]:GetAttr(HeroAttrNames.XJ)
            ZDL = math.ceil(PlayerHero[i]:GetAttr(HeroAttrNames.ZDL)/100)
        end
    end

    local heroName = self.BasicInfo:FindChild("zhandouli_txt")  --战斗力
    local nameLabel = heroName:GetComponent(CMUILabel.Name) 
    nameLabel:SetValue(ZDL)

	if self.bIsShowStar == false  then
		for k = 1, 7 do
			local newItem = GameObject.InstantiateFromPreobj(heroStar,starGrid)
			newItem:SetName("star"..k)
		end
	end
	for k = 1 ,7 do
		local obj = "stargrid/star"..k
		self:SetWidgetActive(obj,false)
		if k == tonumber(starNum) or k < tonumber(starNum) then
			self:SetWidgetActive(obj,true)
		end
	end
	local cmTable = starGrid:GetComponent(CMUIGrid.Name)
	cmTable:Reposition()

    --self.SkillInfo   --技能信息
    local sprite = self.SkillInfo:FindChild("skill1/skill_con") --技能图标
    local skillName = self.SkillInfo:FindChild("skillname_bg/txt") --技能名称
    local skillNameLabel = skillName:GetComponent(CMUILabel.Name) 

    self.skillTable = heroData:Skills()
	local Skills = SData_Skill.GetSkill(self.skillTable[1])
	local skillName = Skills:Name()
	local skillIcon = Skills:Icon()
	skillNameLabel:SetValue(skillName)
	local jnTB = sprite:GetComponent(CMUISprite.Name)
	jnTB:SetSpriteName( "skillicon"..skillIcon)

    --self.SoldierInfo --士兵信息
    local SoldierName = self.SoldierInfo:FindChild("soldier_name") --士兵类型名
    local Army = SData_Army.GetRow(heroData:Army())
    local armyName = SoldierName:GetComponent(CMUILabel.Name) 
    armyName:SetValue(Army:Name())

	self.bIsShowStar = true 

end


--用于锁定和解锁牌组中的卡牌 1 - 锁定 0 - 解锁
function exui_CardCollectionClass:SetCardState(DraCardList,Type)
    if Type == 1 then
        for k,v in pairs(DraCardList) do
            v.info.PaiZCardState = CardState.Lockd
            v.info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable(false)
        end
    else
        print("解锁牌组")
        self.readyToUnlockPaizu = true --准备开始解锁牌组
        for k,v in pairs(CardHeroItem) do
            v.info.PaiZCardState = CardState.Normal
            v.info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable(true)
        end
        self.AllowDragPaiZu = true
        self.LockBtnFinish:SetActive(false)
        self.LockPaiZuFrame:SetActive(false)
        if CardCollectMax ~= CurrCardNum and  wnd_CardHouse.PlayerHeroCount ~= self.PaiZuHeroNum then
            self.AddHeroBtn:SetActive(true)
        end
        self:SetScrollbar()
        --解锁牌组的时候需要删除多出来的空板子
        self:DestroyAllZYHero()
        self:Reposition(true)
    end
end


--显示出战军团中英雄信息
function exui_CardCollectionClass:ShowCZHeroInfo(type)  

    local lockPaiZu = wnd_CardHouse:AllowToDragPaizuCard()
    local PlayerLV = Player:GetNumberAttr(PlayerAttrNames.Level) --获取玩家等级
	CardCollectMax = sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_KakuMax,PlayerLV) --获取对应等级玩家最多可以上阵的英雄
    local List = wnd_CardHouse:GetKaiKuList()  --用于获取当前牌组中的英雄
    CurrCardNum = #List
    local AvaHNum = 0

    if type == 1 then  --用于在调整牌组中的卡牌动态展示选择的卡牌数量
		AvaHNum = CurrCardNum

    elseif type == 2 then  --用于防止同步数据显示成功，实际上并没有完成牌组中卡牌的修改的情况
        local AvaHeroList = Player:GetAvaHeros()
        AvaHNum = #AvaHeroList
        if not lockPaiZu  then
            self.HadZengYuanHeroNum = 0
            local CanZengYuanHeroNum = tonumber(sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_Zenyuan ,PlayerLV))
            local gkInfo = Player:GetGKInfo()
            local eachFunc = function (syncObj)
                self.HadZengYuanHeroNum = tonumber(syncObj:GetValue(GKSaveFileAttrNames.ZYNum)) --已经增援的英雄数量
            end
            gkInfo:ForeachSaveFiles(eachFunc)
            local num = CardCollectMax-CurrCardNum
            if num > CanZengYuanHeroNum-self.HadZengYuanHeroNum then
                num = CanZengYuanHeroNum-self.HadZengYuanHeroNum
            end

            self.ZYHeroNum = num
            local CreatedZYHeroNum = 0

            if  self.CanCreatePaizu or num > #ZYHeroList then 
                self:CreateZengYuanHero(num,lockPaiZu) --创建增援的英雄
            else
                for k,v in pairs(ZYHeroList) do v.info.gameObject:SetActive(true) end
            end
        else
            if  not self.CanCreatePaizu  then 
                for k,v in pairs(CardHeroItem) do
                    v.info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable(true)
                end
            end
        end
	end
	self:SetLabel("card_lab_top/card_lab_txt1_bg/txt2",string.sformat(SData_Id2String.Get(5005),AvaHNum,CardCollectMax))
    if not lockPaiZu and not self.readyToUnlockPaizu then
        self:SetFinishButtonState(false)
        self.LockBtnFinish:SetActive(true)
    end
end

function exui_CardCollectionClass:SetPaizuCardLockState()
    for k,v in pairs(CardHeroItem) do
        if v.info.PaiZCardState == CardState.Lockd then
            v.info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable(false)
        else
            v.info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable(true)
        end
    end
end

--- <summary> 
--- 功能 : 获取左面板系统类型 
--- </summary> 
function exui_CardCollectionClass:GetLeftSystemType( )
    if wnd_CardHouse.isVisible then --当前显示的是牌库
        return HeroCardType.Paiku 
    elseif wnd_buzheng.isVisible then --当前显示的是布阵
        return HeroCardType.Buzhen
    end
   return nil
end

function exui_CardCollectionClass:GetLeftSystemWnd( )
    if wnd_CardHouse.isVisible then --当前显示的是牌库
        return wnd_CardHouse
    elseif wnd_buzheng.isVisible then --当前显示的是布阵
        return wnd_buzheng
    end
   return nil
end

function exui_CardCollectionClass:OnSwapType(heroCard,gameObj)--外形改变为牌组样式完成时被调用
    local heroName = heroCard.info.sinfo:Name()
    local heroID = heroCard.info.sinfo:ID()
    local heroData = SData_Hero.GetHero( heroID )
    local heroStar = 0
    local PlayerHero = Player:GetHeros()
    local isPlayerHero = false
    for i =1, #PlayerHero do
        id = PlayerHero[i]:GetAttr(HeroAttrNames.DataID)
        if tonumber( heroID ) == tonumber( id ) then
            heroStar = PlayerHero[i]:GetAttr(HeroAttrNames.XJ)
            isPlayerHero = true
        end
    end
    if not isPlayerHero then
        heroStar = heroData:MorenXing()
    end

    local heronameObj = gameObj:FindChild("hero_name_bg/txt")
    local cmLabel = heronameObj:GetComponent(CMUILabel.Name) 
    cmLabel:SetValue(heroName) 

    local heroLV = gameObj:FindChild("hero_lv_bg/txt")
    local LvLabel = heroLV:GetComponent(CMUILabel.Name) 
    LvLabel:SetValue(heroStar) 	
	--设置英雄图像
	local widget = gameObj:FindChild("hero_icon")
	local pHead = widget:GetComponent(CMUISprite.Name)
	pHead:SetSpriteName(heroData:HtitleHeroTitle())

	--武将所属阵营图标
	local typeicon = gameObj:FindChild("hero_type_icon")
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..heroData:TypeIcon())

    local hp = gameObj:FindChild("hp_bg")
    local LightBG = gameObj:FindChild("pic_tx")
    if CreatedCard then
        LightBG:SetActive(false) 
    else
        LightBG:SetActive(true)
    end
	local dead = gameObj:FindChild("dead_bg")

	if self:GetLeftSystemType()== HeroCardType.Paiku then 
		hp:SetActive(false)
		dead:SetActive(false)

        if wnd_CardHouse.CardDragStart then return nil end --如果是拖拽变形的话后边的代码不需要执行 

        local itemGameObj = heroCard.info.gameObject

        --控制是否可以拖拽
        local st = ifv(heroCard.info.PaiZuCardState == nil, CardState.Normal, heroCard.info.PaiZuCardState)
        local dragDropItem = itemGameObj:GetComponent(CMDragDropItem.Name)
        dragDropItem:SetEnable(   st==CardState.Normal )--只有常态允许被拖拽 

        if heroCard.info.CurrType == HeroCardType.Paizu then
            self.SimpleInfo:SetActive(false)
        end
	elseif self:GetLeftSystemType()== HeroCardType.Buzhen then 
		local Hp = wnd_buzheng:GetAllHP(heroID)
		local heros = Player:GetAHeroinfos()
		local eachFunc = function (syncObj)
			if tonumber(heroID) == tonumber(syncObj:GetValue(AHeroinfos.id)) then
				if tonumber(syncObj:GetValue(AHeroinfos.State)) == 1 then
					dead:SetActive(true)
                    dead:FindChild("txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5016))
					self:BindUIEvent("Hero_"..heroID.."/pzitem/dead_bg",UIEventType.Click,"OndeadClick")
				else
					dead:SetActive(false)
				end
			end
		end
		heros:ForeachAHeroinfos(eachFunc)
        LightBG:SetActive(false) 
		hp:SetActive(true)
        --血条显示
	    local hP = 0
	    local b = Player:GetAHeroinfos()
        local eachFunc = function (syncObj)
		    if tonumber (syncObj:GetValue(AHeroinfos.id))== tonumber(heroID) then
			     hP = syncObj:GetValue(AHeroinfos.hp)
		    end
        end
        b:ForeachAHeroinfos(eachFunc)
	    local pro_pro = hp:GetComponent(CMUIProgressBar.Name)
		if tonumber(hP) == -1 then
			pro_pro:SetValue(1)
		else
			pro_pro:SetValue(hP/Hp)
		end
	end

    CreatedCard = false
end
function exui_CardCollectionClass:OndeadClick()
	Poptip.PopMsg("当前武将已阵亡 ，不能上阵",Color.blue)
end


function exui_CardCollectionClass:OnShowDone()
    self.FirstCreatePaizuHeroCard = false 
    self.BtnConferm:SetActive(true)
    self.LockBtnFinish:SetActive(false)
    self.HadAddTheHeroToPaiZu = false --向牌组中添加英雄标识
	if self:GetLeftSystemType()== HeroCardType.Buzhen then
        self.AddHeroBtn:SetActive(false)
        self.NextHero:SetActive(true)
        self.hero_small_bg:SetActive(true)
        self.card_lab_txt1_bg:SetActive(false)
        self.empty:SetActive(false)
        self.NextHero:FindChild("txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5009))
        self.empty:FindChild("txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5326))
        self.btn_conferm_txt :SetValue(SData_Id2String.Get(5355))
		--设置下一个出场的武将
		local IDNext = 1014
		local bIsNext = false
		local heros = Player:GetAHeroinfos()
		local shoupainum = 0
		local eachFunc = function (syncObj)
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 2 or tonumber(syncObj:GetValue(AHeroinfos.State)) == 4  then
					shoupainum = shoupainum + 1 
			end
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 5 then
                self.BtnConfermLight:SetActive(true)
			end
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 4 then
				if wnd_buzheng.t then
					bIsNext = false
				else
					bIsNext = true
					IDNext = tonumber(syncObj:GetValue(AHeroinfos.id))
					local herolist = SData_Hero.GetHero(IDNext) 
					local pHead = self.hero_small_bg:GetComponent(CMUISprite.Name)
					pHead:SetSpriteName(herolist:HtitleHeroTitle())
					self:SetLabel("hero_small_bg/hero_name_bg/txt",herolist:Name())
					local playheroList = Player:GetHeros()
					for k,v in pairs (playheroList) do
						if tonumber (playheroList[k]:GetAttr(HeroAttrNames.DataID) ) == IDNext then
							self:SetLabel("pic_star/txt_xingji",playheroList[k]:GetAttr(HeroAttrNames.XJ))
							local heroData = SData_Hero.GetHero( IDNext )
			
							--武将所属阵营图标
							local typeicon = self.hero_small_bg:FindChild( "hero_type_icon" )
							local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
							typeiconUI:SetSpriteName("t"..herolist:TypeIcon())
						end
					end
				end
			end
		end
		heros:ForeachAHeroinfos(eachFunc)
		self:SetLabel("hero_small_bg/txt_bing",shoupainum)
		if not bIsNext then
            self.hero_small_bg:SetActive(false)
            self.empty:SetActive(true)
		end
		self:BindUIEvent("card_lab_top/next_hero",UIEventType.Click,"OnToJMPBZ")--跳转控制布阵界面
        self:SetFinishButtonState(false)
        self.LockPaiZuFrame:SetActive(false)

	elseif self:GetLeftSystemType()== HeroCardType.Paiku then
        self.OnFiinishClicked = 1 --使用完之后需要还原下，便于下次使用
        self.HasDragDropCard = {}
        self.TheLastDraddingCard  = {}
        self.BtnConfermLight:SetActive(false)
        self.NextHero:SetActive(false)
        self.card_lab_txt1_bg:SetActive(true)
        self.heloClose:SetActive(false)
        self.tips_bg_txt:SetValue(SData_Id2String.Get(3248))
        self.btn_conferm_txt:SetValue(SData_Id2String.Get(5010))

        self.ZYHeroNum = 0
        self.AddheroBtnIsAvalible = false
        self.CardDragStart = false --用于标记卡牌是否已经拖拽开始
        self.ScrollBar:SetActive(false) --设置滚动条组件的显隐性
        self.currAddHeroBtnPosY = 0
        self:SetFinishButtonState(false)
        self.readyToUnlockPaizu = false --解锁牌组判定
        self.AddHeroBeenClicked = false --是否点击“+”号按钮
        self.PaiZuHeroHasBeenSaved = false
        self.AllowDragPaiZu = wnd_CardHouse:AllowToDragPaizuCard()
        if not self.AllowDragPaiZu then
            self.LockPaiZuFrame:SetActive(true)
            self.LockBtnFinish:SetActive(true)
            self.Frame:SetActive(false)
        else
            self.LockPaiZuFrame:SetActive(false)
            self.LockBtnFinish:SetActive(false)
        end
	end 
    self:SetScrollbar()
end

--帮助按钮的调用函数
function exui_CardCollectionClass:OnHelpChick()
    self.heloClose:SetActive(true)
    if self:GetLeftSystemType()== HeroCardType.Paiku then
        self.txt_helptitle:SetValue(SData_Id2String.Get(5348))
        self.txt_helpnote:SetValue(SData_Id2String.Get(5349))
    else
        self.txt_helptitle:SetValue(SData_Id2String.Get(5011))
        self.txt_helpnote:SetValue(SData_Id2String.Get(5012))
    end
end

function exui_CardCollectionClass:OnHelpBackChick()
    self.heloClose:SetActive(false)
end

--点击卡牌选择完成按钮
function exui_CardCollectionClass:OnFinish()
    self.OnFiinishClicked = 1
    self:SetFinishButtonState(false) --影藏提示
    if self:GetLeftSystemType()== HeroCardType.Buzhen then  
		 if #wnd_buzheng:GetHeroOnZW() == 0 then
			Poptip.PopMsg("阵位上没有武将",Color.red)
		 else
			if wnd_buzheng.t then
				wnd_buzheng:SetWidgetActive("mask_lu",true)
				wnd_randomEvents:setFightData()
			else
				wnd_buzheng.CloseType = "Enter"
				wnd_buzheng:SetBuZhenInfo()
			end
		 end

	elseif self:GetLeftSystemType()== HeroCardType.Paiku then 

        self.Frame:SetActive(true)
        self.AddHeroBeenClicked  = false
        wnd_CardHouse.PaiZuFinishHasBeenClicked = true
        wnd_CardHouse.jumpToHeroInfoFromPaiZu = false
        local  changed = wnd_CardHouse:KaikuListChanged()
        if  changed then
            wnd_CardHouse:SendChangesNetWork() --保存当前牌组中的英雄信息
        end
	end
end

--用于弹出双选框
function exui_CardCollectionClass:PopSuangXuan()
    self.NotCZHeroID = {} --用于保存没有出战卡牌的英雄ID
    local PlayerHeroIF = Player:GetHeros()

    for i = 1, #PlayerHeroIF do
        local ID = tonumber(PlayerHeroIF[i]:GetAttr(HeroAttrNames.DataID))
        if CardHeroItem[ID] == nil then --出战军团中不存在
            table.insert(self.NotCZHeroID,#self.NotCZHeroID,ID)
        end 
    end

    wnd_ShuangXuan:SetCurrFrame(1)
    wnd_ShuangXuan:Show()
    local NeedAddHero = CardCollectMax - CurrCardNum
    if #self.NotCZHeroID < NeedAddHero then
        NeedAddHero = #self.NotCZHeroID
    end
    wnd_ShuangXuan:SetLabelInfo(SData_Id2String.Get(5087),string.sformat(SData_Id2String.Get(5088),NeedAddHero))
end

--点击锁定匡后提示解锁牌组双选框
function exui_CardCollectionClass:OnUnLockPZ()
    wnd_ShuangXuan:SetCurrFrame(4)
    wnd_ShuangXuan:SetLabelInfo("解锁牌组",SData_Id2String.Get(5309))
    wnd_ShuangXuan:Show()
end

--用于设置完成按钮上的提示信息
function exui_CardCollectionClass:SetFinishButtonState(tags)
    self.tips_bg:SetActive(tags)
    if tags then
        --5s之后消失
        local Alpha = self.tips_bg:GetComponent(CMUITweener.Name)
        Alpha:ResetToBeginning()
        Alpha:PlayForward()
    end
end

--由于设置完成按钮的锁定
function exui_CardCollectionClass:SetFinishButtonLockedState(tags)
    self.LockBtnFinish:SetActive(tags)
end

--根据英雄ID获取一种卡牌
function exui_CardCollectionClass:GetCard(heroID)
    return CardHeroItem[heroID]
end

function exui_CardCollectionClass:OnToJMPBZ()
	print("跳转至布阵页面")
    wnd_buzheng:bIsShowCard()
end

--点击“+”号实现英雄的自动补全
function  exui_CardCollectionClass:OnAddheroBtnChick()

    self.HadAddTheHeroToPaiZu = false
    self.AddHeroBeenClicked = true
    wnd_CardHouse.jumpToHeroInfoFromPaiZu = true
    if self.OnFiinishClicked ~= 1 then 
        if wnd_CardHouse.KaikuListChanged then
            wnd_CardHouse:SendChangesNetWork() --保存当前牌组中的英雄信息
        end
    end
    if CurrCardNum < CardCollectMax  then
        self:PopSuangXuan()
    end
end

--自动补全缺少的卡牌，此功能最终由服务器代码实现
function exui_CardCollectionClass:AddTheLostCard()
    --如果现在牌库中玩家已经拥有的英雄数量为0，就不需要执行一次补全函数
    if 0 ~= #self.NotCZHeroID  then
        self:AddHerosNetWork() --调用服务器添加缺少的英雄
    end
end

--服务器补充缺少的英雄协议
function exui_CardCollectionClass:AddHerosNetWork()
    local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","AutoAva")  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.AddHerosChanges)
end
 
function exui_CardCollectionClass:AddHerosChanges(jsonDoc)
    local Result = tonumber (jsonDoc:GetValue("r"))
    print("Result:",Result)
    local avaList = Player:GetAvaHeros()
    wnd_CardHouse:SetPaiZuHero()
    if 0 == Result then
        local avaList = Player:GetAvaHeros()
        local heroStaticID = {}

        for i=1,#avaList do
            local ID = avaList[i]:GetAttr(AvaInfo.HeroID)
            local hadInHeroStaticID = false
            for i = 1, #heroStaticID do        --控制牌组英雄重复
                if heroStaticID[i] == ID then hadInHeroStaticID = true end
            end
            if not hadInHeroStaticID then table.insert(heroStaticID,#heroStaticID+1,ID) end
            wnd_CardHouse:OnCardJoinCollection(ID)
        end

        self.HadAddTheHeroToPaiZu = true --已经向牌组中添加英雄
        self:CreateCardCollectionItems(heroStaticID)
        if #avaList == CardCollectMax then
            self:SetFinishButtonState(true)
        end
    else
        Poptip.PopMsg("各种原因导致自动补全英雄失败！",Color.white)
    end
end

--inCo 如果在协程中调用传true
function exui_CardCollectionClass:Reposition(hideAll,cardList,inCo)
     --排序参数
    local param = {
                hideAll=hideAll,
                cardList=ifv(cardList==nil,CardHeroItem,cardList)
            }
    if inCo then
        self:coReposition(param)
    else
        --启动协程
        StartCoroutine(self,self.coReposition,param)
    end
end
 
--重排格子图标
function exui_CardCollectionClass:coReposition(param)
    --param.hideAll 重排过程中是否需要隐藏掉所有卡
    --param.cardList 需要重排的卡，只有队列中的卡会被调整y位置来控制排序位置

    local cardList = table.shallowCopy(param.cardList)

    if param.hideAll then
        --排序前隐藏牌组中的所有卡牌
        for _,v in pairs(cardList) do   
            local widget = v.info.gameObject:GetComponent(CMUIWidget.Name)
            widget:SetAlpha(0)--用alpha方式来隐藏，否则会影响排序组件工作
        end
    end

    --按照英雄ID索引
    local PlayerHeroInfo = Player:GetHeros() 
    local tmpList = {}
    for _,v in pairs(PlayerHeroInfo) do
        local id = v:GetNumberAttr(HeroAttrNames.DataID)
        local card = CardHeroItem[id]
        if card~=nil then --英雄在出战队列
            --PlayerHeroIndexByID[id] = v 
            table.insert(tmpList,{ID = id, XJ=v:GetAttr(HeroAttrNames.XJ) })
        end
    end

    local function sortfunc(item1, item2) 
        if item1.XJ == item2.XJ then
             return item1.ID < item2.ID
        else
            return item1.XJ > item2.XJ
        end 
    end
    table.sort(tmpList, sortfunc) 

    local lastY = 9999


	if self:GetLeftSystemType()== HeroCardType.Buzhen then
		local table1 = {}
		for k,v in pairs (tmpList)do
			local heros = Player:GetAHeroinfos()
			local eachFunc = function (syncObj)
				if tonumber(v.ID) == tonumber(syncObj:GetValue(AHeroinfos.id)) then
					if tonumber(syncObj:GetValue(AHeroinfos.State)) == 1 then
						table.insert(table1,tmpList[k])
						table.insert(tmpList,k,-1)
						table.remove(tmpList,k+1)
					end
				end
			end
			heros:ForeachAHeroinfos(eachFunc)
		end
		for k,v in pairs (tmpList)do
			if v ~= -1 then
				table.insert(table1,#table1+1,tmpList[k])
			end
		end
		table.clear(tmpList)
		for k,v in pairs (table1)do
			table.insert(tmpList,1,table1[k])		
		end
    else
        --锁定情况下的增援部队
        if not wnd_CardHouse:AllowToDragPaizuCard() and #ZYHeroList > 0  then
--            print("-----------增援英雄数量：",#ZYHeroList)
            for k=1,#ZYHeroList do
                local heroCard = ZYHeroList[k]
                local gameObj = heroCard.info.gameObject
                local v3pos = gameObj:GetLocalPosition()
	            if(heroCard~=nil) then
                    lastY = lastY - 1        
                    v3pos.y = lastY
		            gameObj:SetLocalPosition(v3pos)
	            end
            end
        end


	end

    --调整Y位置,达到排序的作用


    for _,v in pairs(tmpList) do
        local heroID = v.ID
        local heroCard = CardHeroItem[heroID]
        local gameObj = heroCard.info.gameObject
        local v3pos = gameObj:GetLocalPosition()
        if cardList[heroID]~=nil then--允许调整y位置
            lastY = lastY - 1        
            v3pos.y = lastY
            gameObj:SetLocalPosition(v3pos) 
        else--不允许调整y位置
            lastY = v3pos.y 
        end

    end

--    if self.FirstCreatePaizuHeroCard  and not self.AddHeroBeenClicked then
--        local cardNum = self.Grid:ChildCount()-1
--        self.GridTweener[2]:ResetToBeginning()
--        self.GridTweener[2]:PosFromToY(208,208+90*cardNum)
--        Yield(0.5) 
--        self.FirstCreatePaizuHeroCard = false
--    else
        Yield() --间隔一帧
--    end
    if param.hideAll then
        --排序完毕显示所有卡牌
        for _,v in pairs(cardList) do   
            local widget = v.info.gameObject:GetComponent(CMUIWidget.Name)
            v.info.gameObject:SetActive(true)
            widget:SetAlpha(1)--还原alpha
        end
    end

    self.CMGrid:Reposition()--执行排序动作
    self.CMScrollView:ResetPosition()

    if self:GetLeftSystemType() == HeroCardType.Paiku then
        self:SetAddHeroBtnHidePos()
    end
    self:SetScrollbar()  --用于设置滚动条的显隐性
end

--用于设置牌组中滚动条的显示
function  exui_CardCollectionClass:SetScrollbar()
    local num = self.Grid:ChildCount()-1
    if num < 6 then
        self.ScrollBar:SetActive(false)
    else
        self.ScrollBar:SetActive(true)
    end
    self.CMScrollView:UpdatePosition() --刷新滚动视图 设置滚动条
end

--用于设置牌组中卡牌的锁定状态
function  exui_CardCollectionClass:SetPaiZuHeroLockOrUnlock(heroCard,tags)
    local gameObj = heroCard.info.gameObject
    local lock = gameObj:FindChild("lock")
    lock:SetActive(tags)
end

function exui_CardCollectionClass:CreateZengYuanHero(num,allowDrag)
--    print("-=========------增援的人数为：allowDrag",num,allowDrag)
    self:DestroyAllZYHero()
    if not allowDrag and num > 0 then
        for i =1,num do
            local ZYheroID = 9999
            local info = {
                sinfo = "ZYHero",--静态英雄数据
                zyID = i,
                OriginalType = HeroCardType.Paizu, --原始卡片类型 
                PaiZCardState = CardState.Lockd --仅牌库系统需要用到的卡片状态信息
            }

            info.gameObject = GameObject.InstantiateFromPreobj(self.TemplateWidget,self.TemplateWidget:GetParent())
            info.gameObject:SetName("ZY_"..info.zyID)
            info.gameObject:SetActive(true) 
            info.gameObject:FindChild("pic_tx"):SetActive(false)


            local ZYTips =  info.gameObject:FindChild("hero_canadd")
            ZYTips:SetActive(true)
            info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable(false) --设置为不可拖拽
            ZYTips:FindChild("txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5351))

            local card = HeroCard.new(info)--构造出英雄卡
            table.insert(ZYHeroList,card)
        end
    end

end


--用于设置牌组中“+”位置
function exui_CardCollectionClass:SetAddHeroBtnHidePos()
    local posY = 127

    local v3pos = self.AddHeroBtn:GetLocalPosition()
    local cardNum = self.PaiZuHeroNum
    posY = -90 * (cardNum-1) +127
    if self.CardDragStart then
        posY = -90 * (cardNum-1)+217
    end
    v3pos.y = posY
    v3pos.x = 0
    self.currAddHeroBtnPosY = posY
    self.AddHeroBtn:SetLocalPosition(v3pos)

    if wnd_CardHouse.PlayerHeroCount == self.PaiZuHeroNum  or CurrCardNum == CardCollectMax then
        if not self.CardDragStart then 
            self.AddHeroBtn:SetActive(false)
            self.AddheroBtnIsAvalible = false
        else
            self.AddHeroBtn:SetActive(true)
            self.AddheroBtnIsAvalible = true
        end
    else
        if self.AllowDragPaiZu then 
            self.AddHeroBtn:SetActive(true) 
            self.AddheroBtnIsAvalible = true
        else
            self.AddHeroBtn:SetActive(false) 
            self.AddheroBtnIsAvalible = false
        end
    end
--    self.CMScrollView:ResetPosition()
    self.CMScrollView:UpdatePosition()
    self.CardDragStart = false
end

function exui_CardCollectionClass:PlayCloseTwnner()
    local cardNum = self.Grid:ChildCount()-1

    self.GridTweener[2]:ResetToBeginning()
--    self.addHBTweener[2]:ResetToBeginning()
    self.GridTweener[2]:PosFromToY(208,208+90*cardNum)
    self.AddHeroBtn:SetActive(false)

--    self.addHBTweener[2]:PosFromToY(self.currAddHeroBtnPosY,301)
--    self:SetAddHeroBtnHidePos() --用于控制解锁后+动画播放问题
end

--用于获取牌组的位置
function exui_CardCollectionClass:GetPaizuPoition()
    local PaiZuFrame = self:FindWidget("card_lab")
    local v3pos = PaiZuFrame:GetLocalPosition()
    return v3pos.x
end


--用于清空当前牌组界面
function exui_CardCollectionClass:ReleasePaizuHero()
    if  self:GetLeftSystemType() == HeroCardType.Paiku then  --只要是布阵界面就重新创建
        self.HadAddTheHeroToPaiZu = false
        self.HadEnteredBuzhen = false
        self.GridTweener[2]:PosFromToY(208,208)
        self.AddHeroBtn:SetActive(false)
    --    self.addHBTweener[2]:ResetToBeginning()
    --    self.addHBTweener[2]:PosFromToY(self.currAddHeroBtnPosY,self.currAddHeroBtnPosY+90)

        --影藏界面上的所有控件
        for k,v in pairs(ZYHeroList) do v.info.gameObject:SetActive(false)end
        for k,v in pairs(CardHeroItem) do   v.info.gameObject:SetActive(false) end
        self.Frame:SetActive(false)
        self.BtnConferm:SetActive(false)
        self.LockPaiZuFrame:SetActive(false)
        self.playTipsTxt :SetActive(false)
    else
        for k,v in pairs(CardHeroItem) do   v.info.gameObject:SetActive(false) end
        self.BtnConferm:SetActive(false)
        self.GridTweener[2]:PosFromToY(208,208)
    end

end

--销毁固定的空白板
function exui_CardCollectionClass:DestroyAllZYHero()
    for k,v in pairs(ZYHeroList) do v:Destroy() end
    table.clear(ZYHeroList)
end

--销毁固定的空白板
function exui_CardCollectionClass:DestroyZYHero()
    for k=#ZYHeroList,1,-1 do
        if ZYHeroList[k]~=nil then
            ZYHeroList[k]:Destroy()
            ZYHeroList[k] = nil
            return
        end
    end
end

function exui_CardCollectionClass:PlayLockTipTween(id2String)
    self.LockPaiZuTipsTxt:SetValue(id2String)

    self.playTipsTxt :SetActive(true)
    local playTips  = self.playTipsTxt:GetComponent(CMUITweener.Name)
    playTips:ResetToBeginning()
    playTips:PlayForward()

    local playFinishTxt = self.LockBtnFinish:FindChild("txt")
    playFinishTxt:SetActive(true)
    local playFinish = playFinishTxt:GetComponent(CMUITweener.Name)
    playFinish:ResetToBeginning()
    playFinish:PlayForward()

end

function exui_CardCollectionClass:PlayPaizuFullTween(id2String)
    self.LockPaiZuTipsTxt:SetValue(id2String)

    self.playTipsTxt :SetActive(true)
    local playTips  = self.playTipsTxt:GetComponent(CMUITweener.Name)
    playTips:ResetToBeginning()
    playTips:PlayForward()
end

function exui_CardCollectionClass:OnLostInstance()
    table.clear(CardHeroItem)--界面资源被回收，清空卡牌

    self.CancelSavePaizu = false
    self.PaiZuHeroNum = nil
    self.TemplateWidget = nil
    self.cardlabscrollview = nil
    self.CMScrollView = nil
    self.Table = nil
    self.TableTweener = nil
    self.TableGrid = nil
    self.Tail = nil
    self.Tail2 = nil
    self.Grid = nil
    self.GridTweener = nil
    self.TemplateWidget = nil
    self.DragDropSurface  = nil
    self.CMGrid = nil
    self.CMDragDropSurface = nil
    self.ScrollBar = nil
    self.Frame =nil
    self.LockPaiZuFrame = nil
    self.LockBtnFinish = nil
    self.playTipsTxt  = nil
    self.LockPaiZuTipsTxt = nil
    self.BtnConfermLight = nil
    self.NextHero = nil
    self.card_lab_txt1_bg = nil
    self.heloClose = nil
    self.tips_bg = nil
    self.hero_small_bg = nil
    self.empty = nil
    self.txt_helptitle = nil
    self.txt_helpnote = nil
    self.tips_bg_txt = nil
    self.btn_conferm_txt = nil
    self.SimpleInfo = nil
    self.AddHeroBtn = nil
    self.addHBTweener = nil
    self.BasicInfo = nil
    self.SkillInfo = nil
    self.SoldierInfo = nil
    self.SimpleInfoTip = nil
end



return exui_CardCollectionClass.new

--endregion
