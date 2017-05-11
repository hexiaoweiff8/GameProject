--region *.lua
--Date 20160628
--牌库

--武将武器类型
HeroWeaponType = {

    All = 1,            --全武将
    Strength = 2,       --猛将
    Assassin = 3,       --勇将
    Archer = 4          --弓将
}
HeroNationality = {
    ALL = 0,
    WEI = 1,
    SHU = 2,
    WU = 3,
    QUNXIONG = 4
}
local TestUI = class(wnd_base)

local wnd_CardHouseClass = class(wnd_base)
    wnd_CardHouse = nil
local inCZHero = 0  --是否已经在出战军团列表中了
local CZCardInfo = {}   --用于保存ID，XJ信息
local WeizhiHero = {} --保存未知武将信息
local WillGetHero = {} --碎片够兑换英雄
local heroStaticID = {} --用于保存英雄静态ID 
local isPlayerHero = 0  --用于判断是不是玩家已经拥有的英雄
local CardHeroInfo = {} --读取英雄表中所有的数据
local NationalHero = {} --用于保存不同阵营的英雄
local ShowFinalHero = {}  --用于保存所有排序好的英雄
local DropCardItemList = {}
local PlayerHeroIndexByHeroID = {}--按照英雄ID索引的玩家已获得英雄队列
local CreatedCard = false

--ID为索引形式保存
local CardHeroItem = {} --全部英雄
local Wei_CardHeroItem = {} --魏国英雄
local Shu_CardHeroItem = {} --蜀国英雄
local Wu_CardHeroItem = {} --吴国英雄
local Qiong_CardHeroItem = {} --群雄英雄

--顺序保存
local All_CardHeroInfo = {} --全部英雄
local Wei_CardHeroInfo = {} --魏国英雄
local Shu_CardHeroInfo = {} --蜀国英雄
local Wu_CardHeroInfo = {} --吴国英雄
local Qiong_CardHeroInfo = {} --群雄英雄

local LastCreatedHeroCard = {} --最新创建的表


--卡牌状态枚举
local CardState = {
    Normal = 1,--常态
    Lockd = 2,--被锁定的
    Unknown = 3--尚未获取的
}


local CardHouseMixed  = {
    HeroType = 0,               --当前选择的武将类型
    CurrPage = 1,               --当前选择的页数
    CurrWeaponType = 1,         --当前选择的武将类型
    CurrHeroNationality = 0,    --当前选择的国籍

    OnePageMaxCard = 8,         --每页卡牌最大值
 }
 
------------------------------
--拖拽控制
local DragDropCtrl = class(DragDropCtrlBase)

function DragDropCtrl:Init() 
    local Surface = self.Surface
    Surface:AddDragDropMoveingEvent(self,self.OnDragDropMoveing)--绑定拖拽移动事件
    Surface:AddDragDropStartEvent(self,self.OnDragDropStartEvent)--绑定开始拖拽事件
    Surface:AddDragDropCancelEvent(self,self.OnDragDropCancelEvent)--绑定拖拽取消事件
end

function DragDropCtrl:OnDragDropStartEvent(dragDropItem) 
    self:SetDragDropingCard(dragDropItem)--设置当前拖拽的卡片
    self.surface = exui_CardCollection.CMDragDropSurface --牌组拖拽表面
    local heroCard = self:GetDragDropingCard() --取得当前拖拽物
    -- 等待加入拖拽特效
    local gameObj = heroCard.info.gameObject
    local HeroName = gameObj:FindChild("select_frame")
    HeroName:SetActive(true)
    wnd_CardHouse.CardDragStart  = true
end

function DragDropCtrl:OnDragDropMoveing(dragDropItem) 
    local heroCard = self:GetDragDropingCard() --取得当前拖拽物

    --根据指针所在范围切换卡牌形状
    local newType = ifv(self.surface:IsHovered(),HeroCardType.Paizu,heroCard.info.OriginalType)
    if heroCard.info.CurrType~=newType then
        heroCard.info.CurrType = newType
        heroCard:SwapType()
    end 
end

function DragDropCtrl:OnDragDropCancelEvent(dragDropItem) 
--    exui_CardCollection:SetPaiZuLockFrame(1) --设置操作提示框
end



------------------------------
--牌库界面

function wnd_CardHouseClass:Start() 
	wnd_CardHouse = self
	self:Init(WND.CardHouse)

    --绑定卡牌被点击事件
    EventHandles.OnHeroCardClick:AddListener(self,self.OnHeroCardClick)   --绑定点击事件
    EventHandles.OnHeroCardDragStart:AddListener(self,self.OnHeroCardDragStart)  --绑定拖拽开始事件
    EventHandles.OnHeroCardDrag:AddListener(self,self.OnHeroCardDrag)  --绑定拖拽事件
    EventHandles.OnHeroCardPress:AddListener(self,self.OnHeroCardPress)  --绑定按压事件
--    EventHandles.OnHeroCardLongPress:AddListener(self,self.OnHeroCardLongPress)  --绑定长按事件
end

function wnd_CardHouseClass:OnHeroCardPress(heroCard,isPress)
    if heroCard.info.CurrType == HeroCardType.Paizu then    --卡牌当前类型是牌组   
        if isPress and not exui_CardCollection.CardDragStart  then
            exui_CardCollection:OnLongPressEvent(heroCard.info.sinfo:ID())
        else
            exui_CardCollection.CardDragStart = false
            exui_CardCollection:OnPressEvent() 
            exui_CardCollection.CMScrollView:UpdatePosition() --更新滚动视图 设置滚动条
        end
    else
        exui_CardCollection:OnPressEvent()
    end
end

--- <summary> 
--- 功能 : 卡牌被拖动回调
--- heroCard : HeroCard 卡牌对象
--- </summary>
function wnd_CardHouseClass:OnHeroCardDragStart(heroCard) 
   if heroCard.info.CurrType == HeroCardType.Paizu  then    --卡牌当前类型是牌组
        local dragDropItem = heroCard.info.gameObject:GetComponent(CMDragDropItem.Name)
        if not dragDropItem:GetEnable() then
            self.LockedHasTiped = false
            self.MouseMoveStartPos = Input.mousePosition() --获取鼠标坐标
        end
    elseif heroCard.info.CurrType == HeroCardType.Paiku  then    --卡牌当前类型是牌组
        local dragDropItem = heroCard.info.gameObject:GetComponent(CMDragDropItem.Name)
        if not dragDropItem:GetEnable() and heroCard.info.HouseState == CardState.Lockd then
            Poptip.PopMsg(SData_Id2String.Get(3244),Color.red)
        end
   end
end

function wnd_CardHouseClass:OnHeroCardDrag(heroCard) 
	if exui_CardCollection:GetLeftSystemType() == HeroCardType.Paiku   then   
        if heroCard.info.CurrType == HeroCardType.Paizu  then    --卡牌当前类型是牌组   
            local MouseMovingPos = Input.mousePosition() --获取鼠标移动时候坐标
            if not self.LockedHasTiped and (self.MouseMoveStartPos.x - MouseMovingPos.x) > 30 then
                if  not self.AllowToDrag   then 
                    exui_CardCollection:PlayLockTipTween(SData_Id2String.Get(5352))--播放锁定提示动画
                end
                self.LockedHasTiped = true
            end
        end
    end
end

--- <summary> 
--- 功能 : 卡牌被点击回调
--- heroCard : HeroCard 卡牌对象
--- </summary>
function wnd_CardHouseClass:OnHeroCardClick(heroCard)
     exui_CardCollection.AddHeroBeenClicked  = true
    if heroCard.info.CurrType == HeroCardType.Paiku then --卡牌当前类型是牌库
        local heroID = heroCard.info.sinfo:ID() 
        print("**牌库卡牌被点击** 英雄ID:", heroID) 
        local gameObj = heroCard.info.gameObject
        local pkCard = gameObj:FindChild("pkitem")
        local ClickAudio = pkCard:GetComponent(CMUIAudioFx.Name)
        ClickAudio:SetEnable(true)
        ClickAudio:ReStart()


        local isNewCard = heroCard.info.isNew
        if self.AvoidQuickClick then
            if isNewCard then
                self.AvoidQuickClick = false

                self:OnNewHeroBeenClicked(heroCard,heroID)
            else
                if PlayerHeroIndexByHeroID[heroID]~=nil then 
                    if self:KaikuListChanged() then
                        self:SendChangesNetWork() --进行牌组中英雄的保存
                    end
                    wnd_heroinfo:PlayerHeroData(heroID,self:returncurrheroID(),1)
                    WndJumpManage:Jump(WND.CardHouse,WND.Heroinfo)
                else
                    if heroCard.info.sinfo:IsWeizhi() == 0  then 
                        wnd_HeroPerview:SetHero(heroID)
                        wnd_HeroPerview:Show()
                    else
--                        wnd_gainmethod:ShowData(3) --未知英雄弹出获取界面
--	                    wnd_gainmethod:Show()
                    end
                end 
            end
        end
    elseif heroCard.info.CurrType == HeroCardType.Paizu  then    --卡牌当前类型是牌组
        local heroID = heroCard.info.sinfo:ID()
        if exui_CardCollection:GetLeftSystemType() == HeroCardType.Paiku then
            if self:KaikuListChanged() then
                self:SendChangesNetWork() --进行牌组中英雄的保存
            end
            local dragDropItem = heroCard.info.gameObject:GetComponent(CMDragDropItem.Name)
            dragDropItem:SetEnable(false) --在点击的过程当中不予许拖拽
            wnd_heroinfo:PlayerHeroData(heroID,self:returncurrheroID(),1)
            WndJumpManage:Jump(WND.CardHouse,WND.Heroinfo)

        elseif exui_CardCollection:GetLeftSystemType() == HeroCardType.Buzhen then
            wnd_buzheng:zidongZWhero(heroID)
        end
    end
end

function wnd_CardHouseClass:IsPlayerHaveHero(heroID) 
    return PlayerHeroIndexByHeroID[heroID]~=nil
end

function wnd_CardHouseClass:OnNewInstance()
    self.ZhanBu = self:FindWidget("btn_huaqian")
    self:BindUIEvent("btn_mask",UIEventType.Click,"OnMask")
    self:BindUIEvent("btn_back",UIEventType.Click,"OnClose")
    self:BindUIEvent("btn_huaqian",UIEventType.Click,"OnChouJiang")
    self:BindUIEvent("btn_help",UIEventType.Click,"OnHelpChick")

    self.DragDropSurface = self:FindWidget("herocardlab")
    self.HeroGrid = self.DragDropSurface:FindChild("Grid")
    self.pkitem = self.HeroGrid:FindChild("pkitem");
    self.pkitem:SetActive(false)
    
    self.CMHeroGrid = self.HeroGrid:GetComponent(CMUIGrid.Name)
    self.CMDragDropSurface = self.DragDropSurface:GetComponent(CMDragDropSurface.Name)

     --创建拖拽控制器
    self.DragDropCtrl = DragDropCtrl.new(CardHeroItem, self.CMDragDropSurface)
    self.DragDropCtrl:Init()

    --绑定前后翻页事件
    self.BtnLastpage = self.instance:FindWidget("btn_lastpage")
    self.BtnNextpage = self.instance:FindWidget("btn_nextpage")
    self:BindUIEvent("btn_lastpage",UIEventType.Click,"OnPage","btn_lastpage")
    self:BindUIEvent("btn_nextpage",UIEventType.Click,"OnPage","btn_nextpage")
    --国家阵营选择
    self:BindUIEvent("hero_class_menu",UIEventType.Click,"OnSelectClick")
    self:BindUIEvent("hero_class_menu",UIEventType.SelectionChange,"OnSelectionChange")

    self:SetLabel("btn_huaqian/txt",SData_Id2String.Get(5001))
    self:SetLabel("title_bg/txt",SData_Id2String.Get(5002))
    self:SetLabel("cih_txt_widget/txt_bg1/txt",SData_Id2String.Get(5007))

    --下拉列表框绑定事件
    self.PUobj = self.instance:FindWidget("hero_class_menu")
    self.HeroMenuText = self.PUobj:FindChild("txt"):GetComponent(CMUILabel.Name)
    self.PopUpList = self.PUobj:GetComponent(CMUIPopupList.Name)
    self.SelectLight = self.PUobj:FindChild("light")
    self.alpha = self.SelectLight:GetComponent(CMUITweener.Name)
    self.CloseAudio = self.instance:FindWidget("btn_back"):GetComponent(CMUIAudioFx.Name)


    --牌库没有被创建或者销毁之后重新创建的时候默认创建全部
    wnd_tuiguan.FirstShowPaikuZhengying = HeroNationality.ALL
    wnd_tuiguan.FirstShowPaikuPage = 1
    self.PaikuHadCreated = false --牌库中的牌是否创建过
    self.IsAnythingChanged = false --牌库中的任何属性值改变都需要重新创建卡牌
end 


function wnd_CardHouseClass:OnShowDone() 

    CardHouseMixed.CurrHeroNationality = wnd_tuiguan.FirstShowPaikuZhengying  --当前阵营
    CardHouseMixed.CurrPage = wnd_tuiguan.FirstShowPaikuPage  --当前显示页

    self.DuiHuanHeroSucceed = false
    self.StartDragPaizu = false

    self.LoadCardBanshenHeroBun = 0 --创建的时候只需要加载第一页的英雄半身像
    self.ItemNow = {}  --当前显示页
    self.ItemTemp  = {} --创建页 
    self.LastKaiKuList = {}  --上一次牌库中的英雄信息
    self.AvaHeroIndexByID = {} --按照英雄ID索引牌组英雄队列
    self.WeiZhiHeroIndexByID = {}--按照英雄ID索未知英雄队列
    self.Tiped = false --用于标识是否已经提示过了
    self.hasTiped = false  --牌库中的锁定牌提示信息
    self.AllowDrag = true
    self.AvoidQuickClick = true --避免快速点击
    self.CardDragStart = false --开始拖拽卡牌标识
    self.PlayerHeroCount = 0 --玩家拥有的英雄数量
    self.LockedHasTiped = true
    self.MouseMoveStartPos = nil
    self.DragZengyuanToPaizu = 0 --已经增援的人数
    self.needFillRightItems = true --需要填充右侧卡牌标记
    self.SelectLight:SetActive(false)
    self.CardHouseHasCreated = false
    self.PaiZuCardHasBeenSaved = false  --用于标识牌组中的牌是否已经保存了
    self.PaiZuFinishHasBeenClicked = false --牌组完成按钮是否点击
    self.hasGetAllowPaiZuDrag = false 
--    self.DuiHuanHeroID = 0 --保存利用碎片兑换的英雄的ID

    self.ZhanBu:GetComponent(CMUIButton.Name):SetIsEnabled(false) --设置占卜为不可用
    StartCoroutine(self,self.BindZhanBuClickEvent,{})

    if wnd_tuiguan.FirstShowPaikuZhengying ==  HeroNationality.ALL then
        self.HeroMenuText:SetValue(SData_Id2String.Get(5003))
        self.ItemTemp = All_CardHeroInfo
    elseif wnd_tuiguan.FirstShowPaikuZhengying ==  HeroNationality.WEI then
        self.HeroMenuText:SetValue(SData_Id2String.Get(5249))
        self.ItemTemp = Wei_CardHeroInfo
    elseif wnd_tuiguan.FirstShowPaikuZhengying ==  HeroNationality.SHU then
        self.HeroMenuText:SetValue(SData_Id2String.Get(5250))
        self.ItemTemp = Shu_CardHeroInfo
    elseif wnd_tuiguan.FirstShowPaikuZhengying ==  HeroNationality.WU  then
        self.HeroMenuText:SetValue(SData_Id2String.Get(5251))
        self.ItemTemp = Wu_CardHeroInfo
    elseif wnd_tuiguan.FirstShowPaikuZhengying ==  HeroNationality.QUNXIONG  then
        self.HeroMenuText:SetValue(SData_Id2String.Get(5252))
        self.ItemTemp = Qiong_CardHeroInfo
    end 

    self:FillContent() 
    self:SetPaiZuHero() --获取牌组中的英雄到记录中，便于记录出/入到牌组中

    if self.PaikuHadCreated and not self.IsAnythingChanged then
        self:ShowCardByCurrentPage() --创建完成之后就显示第一页的内容
    end
    self:CreateCardHeroUI() --创建卡牌对象
end


function  wnd_CardHouseClass:BindZhanBuClickEvent()
    Yield(1)
    self.ZhanBu:GetComponent(CMUIButton.Name):SetIsEnabled(true) --设置占卜为可用
end

--读表获取所有英雄信息
function wnd_CardHouseClass:FillContent()
    CardHeroInfo = {}
    local eatchfunch = function (key,value)
        table.insert(CardHeroInfo,#CardHeroInfo+1,value)
    end
    SData_Hero.Foreach(eatchfunch)  
    
    self:GetPlayerHero()   --获取玩家英雄列表
end

function wnd_CardHouseClass:CreateCardHeroUI()
    StartCoroutine(self,self.coCreateCardHeroUI,{})
end

function wnd_CardHouseClass:coCreateCardHeroUI(_)
    --等待牌组界面初始化好    
    while(not exui_CardCollection:CanCreateHeroCard()) do  Yield()  end

    local avaList = Player:GetAvaHeros()
    --创建牌组界面中的卡牌
    if self.needFillRightItems then
        self.needFillRightItems = false
        local heroStaticID = {}
        table.clear(heroStaticID)
         for i=1,#avaList do
            local ID = avaList[i]:GetAttr(AvaInfo.HeroID)
            table.insert(heroStaticID,#heroStaticID+1,ID)
        end 
        exui_CardCollection:CreateCardCollectionItems( heroStaticID )
    end

    --如果牌库的信息没有改变就不需要重新创建
    if not self.PaikuHadCreated or self.IsAnythingChanged then

        for k,v in pairs(CardHeroItem) do  v:Destroy() end

        table.clear(CardHeroItem)
        table.clear(All_CardHeroInfo)
        table.clear(heroStaticID)
        for k,v in pairs(NationalHero) do
            table.insert(heroStaticID,#heroStaticID+1,v:ID())
        end 

        local parent = self.HeroGrid
        local HeroNum = 1
        self.ItemNow = {}
        self.ItemTemp = {}

        local CreateTimes = math.ceil(#NationalHero/CardHouseMixed.OnePageMaxCard)

        for i = 1 ,#NationalHero do 
            local heroID = NationalHero[i]:ID()

            local info = {
                sinfo = SData_Hero.GetHero(heroID),--静态英雄数据
                OriginalType = HeroCardType.Paiku,--原始卡片类型
                HouseState = CardState.Unknown,--仅牌库系统需要用到的卡片状态信息
                isNew = false--是否为一张新卡
            }
        
           if self:IsPlayerHaveHero(heroID) then--玩家拥有的卡 
                info.HouseState=CardState.Normal--常态
           end

           if exui_CardCollection:GetCard(heroID)~=nil then--卡牌在牌组中 
                info.HouseState=CardState.Lockd--锁定
           end

           for k,v in pairs(WillGetHero) do
               if WillGetHero[k]:ID() == heroID then
                   info.isNew = true
                   info.HouseState=CardState.Unknown --尚未获得
               end
           end
           CreatedCard = true

           local newCard = exui_CardCollection:CreateHeroCard(info,parent ,self.DragDropSurface,nil)
           newCard.info.gameObject:SetActive(false)  --创建的牌都隐藏

           CardHeroItem[info.sinfo:ID()] = newCard
           All_CardHeroInfo[HeroNum] = newCard
           HeroNum = HeroNum + 1
        end 
        StartCoroutine(self,self.LoadHeroBanshen,{}) --启用协程加载半身像,在创建卡牌的时候只加载第一页的半身像
--        self.LoadHeroBanshen()

        self.ItemTemp = All_CardHeroInfo

        Yield()--该函数必须在协程环境执行
        self.CMHeroGrid:Reposition()
        self:ShowCardByCurrentPage() --创建完成之后就显示第一页的内容
        self.AvoidQuickClick = true
        self.PaikuHadCreated = true

        self.HeroMenuText:SetValue(SData_Id2String.Get(5003)) 
        wnd_tuiguan.FirstShowPaikuZhengying =  HeroNationality.ALL 

        StartCoroutine(self,self.DistinctCardHeroItem,{}) --开始一个协程用于提取CardHeroItem中不同国家的英雄到不同的列表中
    end
    self.CardHouseHasCreated = true  -- 用于标识牌库卡牌已经成功创建，不会导致找不到控件或者 gameobject destroy 错误
end

function wnd_CardHouseClass:LoadHeroBanshen( )
    StartCoroutine(self,self.LoadRestOfHeroBanshen,{}) --启用协程加载半身像
end


--加载剩余的半身像
function wnd_CardHouseClass:LoadRestOfHeroBanshen( )
    Yield()
    for i=CardHouseMixed.OnePageMaxCard+1, #All_CardHeroInfo do
        if All_CardHeroInfo[i]~= nil then
            local heroID = All_CardHeroInfo[i].info.sinfo:ID()
            local gameObj = All_CardHeroInfo[i].info.gameObject
            local Banshen = gameObj:FindChild( "hero_img" )
	        local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
            HeroBanshen:SetIcon(heroID,false)
        end
    end
end


function wnd_CardHouseClass:ShowCardByCurrentPage()
    local MaxPage = math.modf(#self.ItemTemp/CardHouseMixed.OnePageMaxCard)
        self.BtnLastpage:SetActive(true)
        self.BtnNextpage:SetActive(true)
    if CardHouseMixed.CurrPage <= 1 then
        self.BtnLastpage:SetActive(false)
        self.BtnNextpage:SetActive(true)
    end
    if MaxPage <= 1 then
        self.BtnLastpage:SetActive(false)
        self.BtnNextpage:SetActive(false)
    end
    if CardHouseMixed.CurrPage >= MaxPage then
        self.BtnLastpage:SetActive(true)
        self.BtnNextpage:SetActive(false)
    end

    local num1 = math.ceil(self.PlayerHeroCount /CardHouseMixed.OnePageMaxCard)
    local num2 = math.ceil(#self.ItemTemp/CardHouseMixed.OnePageMaxCard) --当前国家阵营英雄页数
    local AllPage = math.ceil(#All_CardHeroInfo/CardHouseMixed.OnePageMaxCard) ---所有英雄的页数

    --设置当前拥有的英雄数目，当前所在页码/最大页码
    self:SetLabel("cih_txt_widget/txt_bg2/txt",  #Player:GetHeros()) 
    self:SetLabel("cih_txt_widget/txt_bg3/txt",string.sformat(SData_Id2String.Get(5005),CardHouseMixed.CurrPage,num2))

    StartCoroutine(self,self.ShowHeroInfo,{}) --显示页面信息

end

--显示出战军团中英雄信息
function wnd_CardHouseClass:ShowHeroInfo()  
    --设置英雄的详细信息
    local OnePageMax = CardHouseMixed.OnePageMaxCard
    if CardHouseMixed.CurrPage*8 > #self.ItemTemp then
        OnePageMax = #self.ItemTemp-(CardHouseMixed.CurrPage-1)*8
    end

    for k, v in pairs(self.ItemNow) do v.info.gameObject:SetActive(false) end --隐藏前一页的内容
    table.clear(self.ItemNow)

    local num = (CardHouseMixed.CurrPage - 1)*CardHouseMixed.OnePageMaxCard + 1
    for i = 1,OnePageMax do
        local gameObj = self.ItemTemp[num].info.gameObject
        self.ItemNow[i] = self.ItemTemp[num]
        gameObj:SetActive(true)
        num = num + 1      
    end
    self.CMHeroGrid:Reposition()

    for i = 1,#self.ItemNow do
        heroID = tonumber(self.ItemNow[i].info.sinfo:ID())
        local gameObj = self.ItemNow[i].info.gameObject
        gameObj:SetActive(true)

        local HeroXJ = self.ItemNow[i].info.sinfo:MorenXing()
        local XingNum = sdata_keyvalue:GetFieldV(HeroXJ.."xingSuipian",1)
        local PlayerJH = Player:GetJianghunNum(heroID)
        local LvUpCostJH = sdata_keyvalue:GetFieldV((HeroXJ).."xingCost",1)

        local collectJH = gameObj:FindChild("collect_pro_bg")  --将魂收集进度条
        local pro_pro = collectJH:GetComponent(CMUIProgressBar.Name) --进度条组件
        local collectNum = collectJH:FindChild("collect_pro_num")
        local NumLabel = collectNum:GetComponent(CMUILabel.Name) --进度条组件
        local dyHero = PlayerHeroIndexByHeroID[heroID]--取得动态英雄信息
        if dyHero == nil or self.WeiZhiHeroIndexByID[heroID] ~= nil then
            pro_pro:SetValue(PlayerJH/XingNum)  --设置进度条
            NumLabel:SetValue(string.sformat(SData_Id2String.Get(5005),PlayerJH,XingNum))--设置进度条上数量
        else
            HeroXJ = PlayerHeroIndexByHeroID[heroID]:GetAttr(HeroAttrNames.XJ)
            if tonumber(HeroXJ) < 7 then
                LvUpCostJH = sdata_keyvalue:GetFieldV(HeroXJ.."xingCost",1)
            else
                LvUpCostJH = 9999
            end
            --用于设置卡牌上的提示
--            print("-------------------------",self.ItemNow[i].info.sinfo:Name(),HeroXJ,PlayerJH,LvUpCostJH)
            gameObj:FindChild("new_tips"):SetActive(false)
            if self:JudgetToShowHeroTips(heroID) or PlayerJH >= LvUpCostJH  then
                gameObj:FindChild("new_tips"):SetActive(true)
            end

        end 
    end
    self:SetLockFrame()
end

--用于判断是否需要显示牌库中某一卡牌的提示
function wnd_CardHouseClass:JudgetToShowHeroTips(heroID)

    local Player_HeroList = Player:GetHeros()   --获取英雄队列

    ----------士兵是否可升星----------
    local SoldierXJ = 0
	local SoldierJH = 0
	local SoldierLvUpCost = 0
    local SkillCanLvUp = false

    for k=1,#Player_HeroList do
        local ID = Player_HeroList[k]:GetNumberAttr(HeroAttrNames.DataID) 
        if ID == heroID then
            local heroData = SData_Hero.GetHero( ID ) 

    	    SoldierXJ = Player_HeroList[k]:GetAttr(HeroAttrNames.SXJ)
            SoldierJH = Player:GetSoldierPieceNum(heroData:Army())
            SoldierLvUpCost = sdata_keyvalue:GetFieldV((SoldierXJ).."xingArmyCost",1)

--        print("---SoldierXJ,SoldierJH,SoldierLvUpCost",heroData:Name(),SoldierXJ,SoldierJH,SoldierLvUpCost)
            if SoldierJH >= SoldierLvUpCost then
                return true --士兵可以升级
            end
        end

        ----------技能是否可升级----------

    end

    return false
end

--用于是否需要在推关界面显示提示
function wnd_CardHouseClass:NeedToShowTuiGuanTips()
    --添加判断只要有任意一张牌需要显示则返回

    local All_HeroList = {}
    local Player_HeroList = {}
    local Player_HeroListIndexByID = {}

    local Player_HeroList = Player:GetHeros()   --获取英雄队列

    for k,v in pairs(Player_HeroList) do
        local ID = Player_HeroList[k]:GetNumberAttr(HeroAttrNames.DataID) 
        Player_HeroListIndexByID[ID] = v
    end

    local eatchfunch = function (key,value)
        table.insert(All_HeroList,#All_HeroList+1,value)
    end
    SData_Hero.Foreach(eatchfunch)  


    ----------英雄是否可升星,是否可以兑换新英雄----------
    local HeroXJ  = 0
    local heroJH = 0
    local XingUpNum = 0
    local LvUpCostJH = 0

--    print("------------------------查找可以升星的英雄")

    for k=1,#All_HeroList do
        local heroID = All_HeroList[k]:ID()
        if Player_HeroListIndexByID[heroID] ==nil then
            HeroXJ = All_HeroList[k]:MorenXing()
        else
            HeroXJ = Player_HeroListIndexByID[heroID]:GetAttr(HeroAttrNames.XJ)
        end

        heroJH = Player:GetJianghunNum(All_HeroList[k]:ID())
        XingUpNum = sdata_keyvalue:GetFieldV(HeroXJ.."xingSuipian",1)
        if tonumber(HeroXJ) < 7 then 
            LvUpCostJH = sdata_keyvalue:GetFieldV(HeroXJ.."xingCost",1)
        else
            LvUpCostJH = 9999 --如果满星则不需要在消耗
        end
--        print("HeroXJ heroJH XingUpNum  heroJH  LvUpCostJH",All_HeroList[k]:Name(),HeroXJ, heroJH , LvUpCostJH)

        if heroJH >= XingUpNum or heroJH >= LvUpCostJH then
            return true --英雄可以升星
        end

    end

    print("------------------------没有可以升星的英雄，比较士兵")

    ----------士兵是否可升星----------
    local SoldierXJ = 0
	local SoldierJH = 0
	local SoldierLvUpCost = 0
    local SkillCanLvUp = false

    for k=1,#Player_HeroList do
        local ID = Player_HeroList[k]:GetNumberAttr(HeroAttrNames.DataID) 
        local heroData = SData_Hero.GetHero( ID ) 

    	SoldierXJ = Player_HeroList[k]:GetAttr(HeroAttrNames.SXJ)
        SoldierJH = Player:GetSoldierPieceNum(heroData:Army())
        if tonumber(SoldierXJ) < 7 then 
            SoldierLvUpCost = sdata_keyvalue:GetFieldV((SoldierXJ).."xingArmyCost",1)
        else
            SoldierLvUpCost = 9999 --如果满星则不需要在消耗
        end
--        print("--------------------SoldierXJ,SoldierJH,SoldierLvUpCost",heroData:Name(),SoldierXJ,SoldierJH,SoldierLvUpCost)

        if SoldierJH >= SoldierLvUpCost then
            return true --士兵可以升级
        end


        local PlayerLV = Player:GetNumberAttr(PlayerAttrNames.Level) --获取玩家等级

        ----------技能是否可升级----------  技能的接口等待接口

--	    local skillTable = heroData:Skills()
--        for i=1, #skillTable do
--            local level = Player_HeroList[k]:GetSkillLevelByIndex(i)
--            if PlayerLV > level then
--                return true
--            end
--        end

    end

    return false
end


function wnd_CardHouseClass:OnSwapType(heroCard,gameObj)--外形改变为牌库样式完成时被调用  

    local heroName = heroCard.info.sinfo:Name()
    local heroID = heroCard.info.sinfo:ID()
    local WeiZhiHero = heroCard.info.sinfo:IsWeizhi()
    local heroStar = 0
    local heroCollectBG = gameObj:FindChild("collect_pro_bg")
    local heroCollent = gameObj:FindChild("collect_pro_bg/collect_pro_num")
    heroCollectBG:SetActive(false)

    local dyHero = PlayerHeroIndexByHeroID[heroID]
    if dyHero~=nil then 
        heroStar = dyHero:GetAttr(HeroAttrNames.XJ)
    else
        heroCollectBG:SetActive(true)
        heroStar = heroCard.info.sinfo:MorenXing()  
    end

    local hero_name = gameObj:FindChild("hero_name")
    local NameLabel = hero_name:GetComponent(CMUILabel.Name) 
    NameLabel:SetValue(heroName) 

    --设置英雄半身像
	local Banshen = gameObj:FindChild( "hero_img" )
	local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
    local HeroBanshenTex = Banshen:GetComponent(CMUITexture.Name)

    local heroStarBG = gameObj:FindChild("stage_bg")
    local hero_star = heroStarBG:FindChild("stage_txt")
    local StarLabel = hero_star:GetComponent(CMUILabel.Name)  
    StarLabel:SetValue(heroStar)

	local typeicon = gameObj:FindChild("hero_type")
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..heroCard.info.sinfo:TypeIcon())

    local LightBG = gameObj:FindChild("select_frame")
    if CreatedCard then
        LightBG:SetActive(false) 
    else
        LightBG:SetActive(true)
    end
    CreatedCard = false

        --未知英雄设置信息
    if WeiZhiHero == 1 and PlayerHeroIndexByHeroID[heroID] == nil  and not heroCard.info.isNew then 
        heroStarBG:SetActive(false)
        Banshen:SetActive(false) 
        gameObj:FindChild("unknow_img"):SetActive(true)
        NameLabel:SetValue("") 
    else
        --创建的时候只需要加载第一页的英雄半身像
        self.LoadCardBanshenHeroBun = self.LoadCardBanshenHeroBun + 1
        if self.PaikuHadCreated  or self.LoadCardBanshenHeroBun <= CardHouseMixed.OnePageMaxCard then
	        HeroBanshen:SetIcon(heroID,false)
        end
    end
    if self.StartDragPaizu then return nil end --如果是拖拽变形则不需要继续往下执行

    local itemGameObj = heroCard.info.gameObject

    --控制是否可以拖拽
    --如果状态为空，应该是刚从牌组拖出来的，认为是常态卡
    local st = ifv(heroCard.info.HouseState==nil,CardState.Normal,heroCard.info.HouseState)
    local dragDropItem = itemGameObj:GetComponent(CMDragDropItem.Name)
    dragDropItem:SetEnable(   st==CardState.Normal )--只有常态允许被拖拽 
     
    local NewCardState = gameObj:FindChild("new_frame") --新英雄框
    --设置卡牌透明度
    local itemWidget = gameObj:GetComponent(CMUIWidget.Name) 
    local KuangFrame = gameObj:FindChild("kuang"):GetComponent(CMUISprite.Name)
    if st == CardState.Unknown then
        KuangFrame:SetSpriteName("5_gray")
        heroStarBG:GetComponent(CMUISprite.Name):SetSpriteName("star_gray")
	    typeiconUI:SetSpriteName("t_gray")
    end
    if(HeroBanshenTex ~= nil)then
        HeroBanshenTex:SetShader(ifv( st==CardState.Unknown,"QK/Colored Gray","Unlit/TransparentColored" ))
    end
    for i = 1,#WillGetHero do
        if heroID == WillGetHero[i]:ID() then
            heroCollectBG:SetActive(false)
            NewCardState:SetActive(true)
            KuangFrame:SetSpriteName("5")
            HeroBanshenTex:SetShader("Unlit/TransparentColored" )
            NewCardState:FindChild("txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5006))
        end   
    end


    --设置拖拽滚动视
    local dragScrollView = itemGameObj:GetComponent( CMUIDragScrollView.Name) 
    if dragScrollView~=nil then dragScrollView:SetScrollView(nil) end 
end


function wnd_CardHouseClass:SetCardStar(heroID)
    if CardHeroItem[heroID]~=nil then
        local heroStar = 0
        local dyHero = PlayerHeroIndexByHeroID[heroID]
        if dyHero~=nil then 
            heroStar = dyHero:GetAttr(HeroAttrNames.XJ)
        else
            local heroData = SData_Hero.GetHero( heroID ) 
            heroStar = heroData:MorenXing()  
        end
        local gameObj = CardHeroItem[heroID].info.gameObject
        local heroStarBG = gameObj:FindChild("stage_bg")
        local hero_star = heroStarBG:FindChild("stage_txt")
        local StarLabel = hero_star:GetComponent(CMUILabel.Name)  
        StarLabel:SetValue(heroStar)
        print("-------------------------设置star",CardHeroItem[heroID].info.sinfo:Name(),heroStar)
    end
end



function wnd_CardHouseClass:OnPage(obj,Name)

    local MaxPage = math.modf(#self.ItemTemp/CardHouseMixed.OnePageMaxCard)

    if CardHouseMixed.CurrPage <= 1 then
        self.BtnLastpage:SetActive(false)
    end
    if MaxPage <= 1 then
        self.BtnLastpage:SetActive(false)
        self.BtnNextpage:SetActive(false)
    end
    if Name == "btn_lastpage" then 
        self.BtnNextpage:SetActive(true)
        self.SelectLight:SetActive(false)

        CardHouseMixed.CurrPage = CardHouseMixed.CurrPage-1
        if CardHouseMixed.CurrPage <= 1 then
            self.BtnLastpage:SetActive(false)
        end
    end

    if  Name == "btn_nextpage" then
        self.BtnLastpage:SetActive(true)
        self.SelectLight:SetActive(false)
        CardHouseMixed.CurrPage = CardHouseMixed.CurrPage+1
        if CardHouseMixed.CurrPage >= MaxPage then
        self.BtnNextpage:SetActive(false)
        end 
    end 
    wnd_tuiguan.FirstShowPaikuPage = CardHouseMixed.CurrPage
    self:ShowCardByCurrentPage()
end


function wnd_CardHouseClass:OnNewHeroBeenClicked(heroCard,heroID)
    wnd_NewCard:SetHeroID(heroID)
    wnd_NewCard:Show()
    StartCoroutine(self,self.OnNewHeroGet,heroID)
end

function wnd_CardHouseClass:OnNewHeroGet(heroID)
     Yield(1.5)
    self:NewCardJoinNetWork(heroID) --向服务器发送请求兑换英雄
end


--当在牌组中拖拽导致卡牌离开牌组的时候被调用
function wnd_CardHouseClass:OnCardLeaveCollection(heroID,DragCard) 
    local heroCard = CardHeroItem[heroID]--获取到牌库中的英雄卡片 
    exui_CardCollection.AddHeroBtn:SetActive(true)
    self:OnDrag(heroID, 1, DragCard)
    DropCardItemList[heroID] = nil
    if heroCard ~= nil then
        heroCard.info.HouseState=CardState.Normal--状态改变
        local dragDropItem = heroCard.info.gameObject:GetComponent(CMDragDropItem.Name)
        dragDropItem:SetEnable(true) --设置牌组中的英雄为可拖拽

        local gameObj = heroCard.info.gameObject
        local HeroName = gameObj:FindChild("select_frame")
        HeroName:SetActive(false)

        local LockeCard = gameObj:FindChild("lock_frame") --设置锁定外观为不可见
        LockeCard:SetActive(false)
    end
    exui_CardCollection:SetAddHeroBtnHidePos() --用于控制+位置
    exui_CardCollection.OnFiinishClicked = 0
    self.StartDragPaizu = false
end

--当拖拽行为导致牌组中有新物体加入的时候被调用
function wnd_CardHouseClass:OnCardJoinCollection(heroID,DragCard) 
    local heroCard = CardHeroItem[heroID]--获取到牌库中的英雄卡片 
    if heroCard==nil then return end
    self:OnDrag(heroID, 0)
    heroCard.info.HouseState=CardState.Lockd--状态改变
    local dragDropItem = heroCard.info.gameObject:GetComponent(CMDragDropItem.Name)
    dragDropItem:SetEnable() --设置牌组中对应得卡牌为不可拖拽

    DropCardItemList[heroID] = DragCard
    local gameObj = heroCard.info.gameObject
    local LightFrame = gameObj:FindChild("select_frame")
    LightFrame:SetActive(false)

    local LockeCard = gameObj:FindChild("lock_frame")--设置锁定外观
    LockeCard:SetActive(true)
    if exui_CardCollection:GetLeftSystemType()== HeroCardType.Paiku then
        DragCard:BindEvents() --为拖拽进入牌组的英雄绑定点击事件
    end
    if self.PaiZuFinishHasBeenClicked  and not self:KaikuListChanged()  then 
        exui_CardCollection:SetPaiZuLockFrame(1)
    else
        exui_CardCollection:SetPaiZuLockFrame(0)
    end
    exui_CardCollection.OnFiinishClicked = 0
    self.PaiZuCardHasBeenSaved = false --牌组被改变了并没有保存

    --设置牌组中增援的英雄不可拖拽
    if not self.AllowToDrag then
        local ZengyuanCard = exui_CardCollection:GetCard(heroID)
        ZengyuanCard.info.gameObject:GetComponent(CMDragDropItem.Name):SetEnable()

        exui_CardCollection:DestroyZYHero() --加入英雄后销毁空白卡牌
    end
end

function wnd_CardHouseClass:coFlyToCollection(param) 
    local card = param[1]--卡牌对象 
    local heroID = card.info.sinfo:ID() 
    print("重新创建卡牌:  ", card.info.sinfo:Name())
    --先在牌组中创建好卡牌，并排序
    local newCard = exui_CardCollection:JoinCard(heroID,true)
    local NewCardGameObj = newCard.info.gameObject
    NewCardGameObj:GetComponent(CMDragDropItem.Name):SetEnable(true) 
    local widget = NewCardGameObj:GetComponent(CMUIWidget.Name)
    widget:SetAlpha(0)
    if card ~= nil then
        card:Destroy() --显小会可以避免最后一张牌脱出牌组在拖回牌组之前位置的时候“+”跳到第三个位置
        card = nil
    end
    --新创建好的卡牌
    local LightBG = NewCardGameObj:FindChild("pic_tx")
    LightBG:SetActive(false)
    --牌组中的卡片显示出来
    widget:SetAlpha(1)  
    local heroCard = CardHeroItem[heroID] --获取到牌库中的英雄卡片 
    if heroCard==nil then return end
    heroCard.info.HouseState=CardState.Lockd --状态改变
    local dragDropItem = heroCard.info.gameObject:GetComponent(CMDragDropItem.Name)
    dragDropItem:SetEnable() 

    local gameObj = heroCard.info.gameObject
    local LightFrame = gameObj:FindChild("select_frame") --停靠之后设置背景亮色框取消
    LightFrame:SetActive(false)

    local LockeCard = gameObj:FindChild("lock_frame") --设置锁定外观
    LockeCard:SetActive(true)
end


--牌是否能停靠进牌组的检查
function wnd_CardHouseClass:DockCheckCollection(heroCard)
    self.AllowDrag = self:AllowToDragPaizuCard()
    local PlayerLV = Player:GetNumberAttr(PlayerAttrNames.Level)
	local CardCollectMax = sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_KakuMax,PlayerLV)
    local CanZengYuanHeroNum = tonumber(sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_Zenyuan ,PlayerLV))
    local gkInfo = Player:GetGKInfo()
    self.HadZengYuanHeroNum = 0
    local eachFunc = function (syncObj)
        self.HadZengYuanHeroNum = tonumber(syncObj:GetValue(GKSaveFileAttrNames.ZYNum) )--已经增援的英雄数量
    end
    gkInfo:ForeachSaveFiles(eachFunc)

    if DropCardItemList[heroCard.info.sinfo:ID()] ~= nil then return false end --牌组中已经有这个卡
    if #self.KaiKuList >= CardCollectMax  then
        if self.AllowToDrag then 
            exui_CardCollection:PlayPaizuFullTween(SData_Id2String.Get(3241))
        else
            exui_CardCollection:PlayLockTipTween(SData_Id2String.Get(5353))
        end
        return false
    else 
        local num = CanZengYuanHeroNum - self.HadZengYuanHeroNum --还可以增援的人数
        local CanJoinPaiZuHeroNum = CardCollectMax - #self.KaiKuList --牌组中缺少的人数
        if not self.AllowDrag then
            if  num > 0 then --增援英雄
                if num > CanJoinPaiZuHeroNum then
                    num = CanJoinPaiZuHeroNum 
                    if CanJoinPaiZuHeroNum <= 0 or num-self.DragZengyuanToPaizu < 0 then 
                        exui_CardCollection:PlayLockTipTween(SData_Id2String.Get(5352))--播放锁定提示动画
--                        print("---------------------11111111111111111",CanJoinPaiZuHeroNum,num,self.DragZengyuanToPaizu)
                        return false 
                    end
                else
--                    print("---------------------22222222222222222",num,self.DragZengyuanToPaizu)
                    if num-self.DragZengyuanToPaizu <= 0  then 
                        exui_CardCollection:PlayLockTipTween(SData_Id2String.Get(5352))--播放锁定提示动画
                        return false 
                    end 
                    self.DragZengyuanToPaizu = self.DragZengyuanToPaizu + 1
                end
                local addCardNum = CanJoinPaiZuHeroNum-self.DragZengyuanToPaizu
                return true
            else
                exui_CardCollection:PlayLockTipTween(SData_Id2String.Get(5352))--播放锁定提示动画
                return false 
            end
        end
        return true
    end
end

function wnd_CardHouseClass:SaveZengyuanHero()
    Yield()
    self:SendChangesNetWork()
end

--用于设置牌组中的卡牌锁定外观
function wnd_CardHouseClass:SetLockFrame()
--    print("--------------设置锁定外观",#self.KaiKuList)
    if self.PaikuHadCreated then
        self.AvaHeroIndexByID = {}
        local num = 0
        for i=1,#self.KaiKuList do
            local ID = self.KaiKuList[i]:ID() 
            self.AvaHeroIndexByID[ID] = self.KaiKuList[i]
            num = num + 1
        end 
        for k,v in pairs(self.ItemNow) do
            local id = tonumber(v.info.sinfo:ID())
            local avahero = self.AvaHeroIndexByID[id]
            --新添加的英雄在牌库中改变外观为锁定状态
            if avahero ~= nil then 
                v.info.HouseState=CardState.Lockd
                local gameObj = v.info.gameObject
                gameObj:FindChild("lock_frame"):SetActive(true) 
                local dragDropItem = gameObj:GetComponent(CMDragDropItem.Name)
                dragDropItem:SetEnable()
            else
                if v.info.HouseState ~= CardState.Unknown then
                    v.info.HouseState=CardState.Normal
                    local gameObj = v.info.gameObject
                    gameObj:FindChild("lock_frame"):SetActive(false) 
                    local dragDropItem = gameObj:GetComponent(CMDragDropItem.Name)
                    dragDropItem:SetEnable(true)
                end
            end
        end
    end
end

--附加信息到牌组新创建的卡牌上
function wnd_CardHouseClass:AttachedInfoCollection(info)
    if not self.hasGetAllowPaiZuDrag then
        self.AllowDrag = self:AllowToDragPaizuCard()
        self.hasGetAllowPaiZuDrag = true
    end
    if self.AllowDrag then
        info.PaiZuCardState = CardState.Normal    --常态
    else
        info.PaiZuCardState = CardState.Lockd    --锁定
    end
end



--获取当前攻打城池状态（进入城市信息界面并点击继续按钮进入布阵状态）
function wnd_CardHouseClass:AllowToDragPaizuCard()
    local City
    local isDistCard
    local GKState = wnd_tuiguan:GetMixed()
    local CurrAttackGK = GKState.CurrentAttackMission --当前攻打的关卡
    local gkInfo = Player:GetGKInfo()
    local eachFunc = function (syncObj)
        isDistCard = syncObj:GetValue(GKSaveFileAttrNames.isDistCard) 
    end
    gkInfo:ForeachSaveFiles(eachFunc)

    if CurrAttackGK ~= 0 then
        City = sdata_MissionMonster:GetV(sdata_MissionMonster.I_CityID, CurrAttackGK)
        self.CityIDString = sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,tonumber(City))
    end
    self.FirstCityID = string.sub(CurrAttackGK,5,6)
    if 0 == tonumber(CurrAttackGK) then 
        self.AllowToDrag = true
    elseif 0~= tonumber(CurrAttackGK) then
        if(tostring(self.FirstCityID) == "01") and (tonumber(isDistCard) == 0) then
            self.AllowToDrag = true
        else
            self.AllowToDrag = false    
        end
    end
    return self.AllowToDrag
end

 
--根据ID获取玩家拥有的卡牌
function wnd_CardHouseClass:GetPlayerHerofromPlayerHeroIndexByHeroID(heroID)
    if PlayerHeroIndexByHeroID[heroID] ~= nil then
        return PlayerHeroIndexByHeroID[heroID]
    end
end


--获取外观模板，牌组左系统必须实现该接口
function wnd_CardHouseClass:GetShapeTemplate()
    return self.pkitem
end

function wnd_CardHouseClass:OnSelectClick()
    self.SelectLight:SetActive(true)
    self.alpha:ResetToBeginning()
    self.alpha:PlayForward()

    self:SetWidgetActive("btn_mask",true)

end

function wnd_CardHouseClass:OnMask()
    self.SelectLight:SetActive(false)
    self:SetWidgetActive("btn_mask",false)
end

--选择武将不同的阵营
function wnd_CardHouseClass:OnSelectionChange(Obj,selectedItem,_)
    local SelectAudio = self.PUobj:GetComponent(CMUIAudioFx.Name)
    SelectAudio:SetEnable(true)
    SelectAudio:ReStart()

    for k, v in pairs(self.ItemTemp) do v.info.gameObject:SetActive(false) end --先隐藏当前显示的所有牌
    self.ItemTemp = {}

    if selectedItem == SData_Id2String.Get(5003) then
        CardHouseMixed.CurrHeroNationality = HeroNationality.ALL
        self.HeroMenuText:SetValue(SData_Id2String.Get(5003))

        --显示全部英雄
        self.ItemTemp = All_CardHeroInfo

    elseif selectedItem == SData_Id2String.Get(5249) then
        CardHouseMixed.CurrHeroNationality = HeroNationality.WEI
        self.HeroMenuText:SetValue(SData_Id2String.Get(5249))

        --显示魏国英雄
        self.ItemTemp = Wei_CardHeroInfo

    elseif selectedItem == SData_Id2String.Get(5250) then
        CardHouseMixed.CurrHeroNationality = HeroNationality.SHU
        self.HeroMenuText:SetValue(SData_Id2String.Get(5250))

        --显示蜀国英雄
        self.ItemTemp = Shu_CardHeroInfo

    elseif selectedItem == SData_Id2String.Get(5251) then
        CardHouseMixed.CurrHeroNationality = HeroNationality.WU
        self.HeroMenuText:SetValue(SData_Id2String.Get(5251))

        --显示吴国英雄
        self.ItemTemp = Wu_CardHeroInfo

    elseif selectedItem == SData_Id2String.Get(5252) then
        CardHouseMixed.CurrHeroNationality = HeroNationality.QUNXIONG
        self.HeroMenuText:SetValue(SData_Id2String.Get(5252))

        --显示群雄英雄
        self.ItemTemp = Qiong_CardHeroInfo

    end
    self.SelectLight:SetActive(false)
    self:SetWidgetActive("btn_mask",false)

    CardHouseMixed.CurrPage = 1
    wnd_tuiguan.FirstShowPaikuPage = 1
    wnd_tuiguan.FirstShowPaikuZhengying = CardHouseMixed.CurrHeroNationality
    self:GetHeroTable()
    self:ShowCardByCurrentPage() --显示英雄

end

--获取当前英雄国籍的英雄列表
function wnd_CardHouseClass:GetHeroTable()
    local PaikuHeroNum = self.HeroGrid:ChildCount()
    --如果牌库中的牌没有创建过则需要筛选和创建
--    if PaikuHeroNum < 2 then
    if not self.PaikuHadCreated  then
        NationalHero = {}
        local i = 1

        if CardHouseMixed.CurrHeroNationality == HeroNationality.ALL then 
            NationalHero = ShowFinalHero
             return
        end

        for k = 1,#ShowFinalHero do
            if ShowFinalHero[k]:HeroZhenying() == CardHouseMixed.CurrHeroNationality then 
                NationalHero[i] = ShowFinalHero[k]
                i = 1 + i
            end 
        end
    end
end

function wnd_CardHouseClass:DistinctCardHeroItem()
    Yield(1)  --1s之后再执行避开内存开销高峰

    local wei_HeroNum = 0
    local shu_HeroNum = 0
    local wu_HeroNum = 0
    local qiong_HeroNum = 0

    table.clear(Wei_CardHeroItem)
    table.clear(Shu_CardHeroItem)
    table.clear(Wu_CardHeroItem)
    table.clear(Qiong_CardHeroItem)

    table.clear(Wei_CardHeroInfo)
    table.clear(Shu_CardHeroInfo)
    table.clear(Wu_CardHeroInfo)
    table.clear(Qiong_CardHeroInfo)

    for k = 1,#ShowFinalHero do
        local heroID = ShowFinalHero[k]:ID()
        local card = CardHeroItem[heroID]
        if ShowFinalHero[k]:HeroZhenying() == HeroNationality.WEI then 
            Wei_CardHeroItem[heroID] = card
            wei_HeroNum  = wei_HeroNum + 1
            Wei_CardHeroInfo[wei_HeroNum] = card
        elseif ShowFinalHero[k]:HeroZhenying() == HeroNationality.SHU then 
            Shu_CardHeroItem[heroID] = card
            shu_HeroNum = shu_HeroNum + 1
            Shu_CardHeroInfo[shu_HeroNum] = card
        elseif ShowFinalHero[k]:HeroZhenying() == HeroNationality.WU then 
            Wu_CardHeroItem[heroID] = card
            wu_HeroNum = wu_HeroNum+1
            Wu_CardHeroInfo[wu_HeroNum] = card
        elseif ShowFinalHero[k]:HeroZhenying() == HeroNationality.QUNXIONG then 
            Qiong_CardHeroItem[heroID] = card
            qiong_HeroNum = qiong_HeroNum+1
            Qiong_CardHeroInfo[qiong_HeroNum] = card
        end
    end
    local allHeroNum = wei_HeroNum+shu_HeroNum+wu_HeroNum+qiong_HeroNum
--    print("魏蜀吴群雄英雄数量分别为(ID为索引):  ",wei_HeroNum,shu_HeroNum,wu_HeroNum,qiong_HeroNum, allHeroNum)
--    print("魏蜀吴群雄英雄数量分别为(顺序保存):  ",#Wei_CardHeroInfo,#Shu_CardHeroInfo,#Wu_CardHeroInfo,#Qiong_CardHeroInfo)

end


--获取玩家英雄队列
function wnd_CardHouseClass:GetPlayerHero()
    local PlayerHeroInfo = Player:GetHeros()   --获取英雄队列
    if PlayerHeroInfo == nil then return end
    ShowFinalHero = {}
      
    --取得玩家已经获得的英雄数量
    self.PlayerHeroCount  = #PlayerHeroInfo
    PlayerHeroIndexByHeroID = {}
    --用于删除表中玩家已经拥有的英雄的数据，提取玩家没有但是碎片已经达到招募数量的英雄
    for i = #PlayerHeroInfo, 1, -1  do 
        if PlayerHeroInfo[i] ~= nil then
            local ID = PlayerHeroInfo[i]:GetNumberAttr(HeroAttrNames.DataID) 

            --建立根据ID索引的英雄动态数据队列
            PlayerHeroIndexByHeroID[ID] = PlayerHeroInfo[i] 

            local heroData = SData_Hero.GetHero( ID ) 
            for j = #CardHeroInfo, 1, -1  do
                if CardHeroInfo[j] ~= nil then
                    if heroData:ID() == CardHeroInfo[j]:ID() then
                        table.remove(CardHeroInfo, j)
                    end
                end
            end
        end
    end
    --提取碎片数量达到招募水平的英雄  和  未知英雄
    WillGetHero = {}
    WeizhiHero = {}
    self.WeiZhiHeroIndexByID = {} --碎片兑换英雄按ID索引
    for k=#CardHeroInfo,1,-1 do
        local heroJH = Player:GetJianghunNum(CardHeroInfo[k]:ID())
        local XingUpNum = sdata_keyvalue:GetFieldV(CardHeroInfo[k]:MorenXing().."xingSuipian",1)
        if tonumber(heroJH) >= tonumber(XingUpNum) then
            table.insert(WillGetHero, CardHeroInfo[k])
            table.remove(CardHeroInfo,k)
        else
            if CardHeroInfo[k]:IsWeizhi() == 1  then  --未知武将
                self.WeiZhiHeroIndexByID[CardHeroInfo[k]:ID()] = CardHeroInfo[k]
                table.insert(WeizhiHero, CardHeroInfo[k])
                table.remove(CardHeroInfo,k)
            end
        end
    end

    --调用牌库排序功能
    self:PaukuOrder(CardHeroInfo)
    self:PaukuOrder(WillGetHero)
    self:PaukuOrder(WeizhiHero)

    table.clear(CZCardInfo)
    for i=1, #PlayerHeroInfo do
        local CardInfo = {} --单个英雄的信息
        local ID = PlayerHeroInfo[i]:GetAttr(HeroAttrNames.DataID) 
        local PlayerHeroXJ = PlayerHeroInfo[i]:GetAttr(HeroAttrNames.XJ)
        CardInfo = {id = tonumber(ID), XJ = tonumber(PlayerHeroXJ)}
        table.insert(CZCardInfo,CardInfo)
    end 

    --对玩家拥有的英雄进行排序
    local function sortfunc(item1, item2)
        local Judgement
        if  item1.XJ  ==  item2.XJ then
               Judgement = item1.id < item2.id
        else
            Judgement = item1.XJ > item2.XJ
        end
        return Judgement
    end
    table.sort(CZCardInfo, sortfunc)

    for k,v in pairs(WillGetHero) do  --碎片兑换的英雄
        table.insert(ShowFinalHero,#ShowFinalHero+1,v)
    end
    
    for i=1, #CZCardInfo do  --玩家拥有的英雄
        local ID = CZCardInfo[i].id
        local heroData = SData_Hero.GetHero( ID )
        table.insert(ShowFinalHero,#ShowFinalHero+1,heroData)
    end 

    for i, v in pairs(CardHeroInfo) do  --玩家尚未拥有的英雄
        table.insert(ShowFinalHero,#ShowFinalHero+1,v)
    end

    for i, v in pairs(WeizhiHero) do  --未知英雄
        table.insert(ShowFinalHero,#ShowFinalHero+1,v)
    end

    if not self.PaikuHadCreated then
        --保存第一次创建成功的卡牌
        LastCreatedHeroCard = {}
        NationalHero = ShowFinalHero
        LastCreatedHeroCard = ShowFinalHero
        return
    else
        --需要判断最新一次获取的列表跟上一次是否一致，不一致则牌库中的牌需要重新创建
        if self.DuiHuanHeroSucceed then --
            self.IsAnythingChanged = true
            self.DuiHuanHeroSucceed = false
        else
            for i = 1,#ShowFinalHero do
                if LastCreatedHeroCard[i]:ID() ~= ShowFinalHero[i]:ID() then
                    self.IsAnythingChanged = true
                    break
                else
                    self.IsAnythingChanged = false
                end
            end
        end
        if self.IsAnythingChanged then
            LastCreatedHeroCard = {}
            NationalHero = ShowFinalHero
            LastCreatedHeroCard = ShowFinalHero
        end
    end

end

function  wnd_CardHouseClass:SetPaiZuHero()
    local playerAvaHero = Player:GetAvaHeros()
     --用于保存已经在牌组中的英雄详细信息
    self.KaiKuList = {} 
    for i=1,#playerAvaHero do
        local ID = playerAvaHero[i]:GetAttr(AvaInfo.HeroID)
        local heroData = SData_Hero.GetHero( ID )
        table.insert(self.KaiKuList,heroData)
    end
end

--用于对牌库英雄的排序
--英雄的排列顺序为：优先星级，同样星级按照ID顺序
function wnd_CardHouseClass:PaukuOrder(tempInfo)
    local function sortfunc(item1, item2)
        local Judgement
        if tonumber(item1:MorenXing()) == tonumber(item2:MorenXing()) then
            Judgement = tonumber(item1:ID()) < tonumber(item2:ID())
        else
            Judgement = tonumber(item1:MorenXing()) > tonumber(item2:MorenXing())
        end
        return Judgement
    end
    table.sort(tempInfo, sortfunc)
end

function wnd_CardHouseClass:OnChouJiang()
    local SelectAudio =  self.ZhanBu:GetComponent(CMUIAudioFx.Name)
    SelectAudio:SetEnable(true)
    SelectAudio:ReStart()
    WndJumpManage:Jump(WND.CardHouse,WND.ChouJiang)
end

--用于保存操作牌组中的英雄信息（包含拖入/拖出操作）
function wnd_CardHouseClass:OnDrag(heroID, DragType, DragCard)
    --获取当前等级出战军团最多允许上阵数目
    local PlayerLV = Player:GetNumberAttr(PlayerAttrNames.Level)
    local CardCollectMax = sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_KakuMax,PlayerLV)

    local heroData = SData_Hero.GetHero( heroID )
    if 0 == DragType then
        if #self.KaiKuList < CardCollectMax then
            if #self.KaiKuList == 1 then
                if self.KaiKuList[1]:ID() ~= heroID then
                    table.insert(self.KaiKuList, heroData)
                end
            else
                table.insert(self.KaiKuList, heroData)
            end
        end
        if #self.KaiKuList == CardCollectMax  then
            exui_CardCollection:SetFinishButtonState(true) --提示可以出战
            exui_CardCollection.AddHeroBtn:SetActive(false)--设置牌组中“+”为不显示状态
            self.hasTiped = true
        end
        if  #self.KaiKuList == self.PlayerHeroCount  then
            exui_CardCollection.AddHeroBtn:SetActive(false)--设置牌组中“+”为不显示状态
        end
    elseif 1 == DragType then
        if #self.KaiKuList > 1 then
            for i = #self.KaiKuList, 1, -1  do 
                if self.KaiKuList[i] ~= nil then
                    if heroID == self.KaiKuList[i]:ID() then
                        table.remove(self.KaiKuList, i)
                    end
                end
            end
        elseif DragCard.info.CurrType == HeroCardType.Paiku then
            Poptip.PopMsg(SData_Id2String.Get(3242),Color.white)
        end
    end
    if #self.KaiKuList == CardCollectMax then
        exui_CardCollection:SetFinishButtonState(true)
    else
        exui_CardCollection:SetFinishButtonState(false)
    end
    --动态的显示/设置牌组中当前选择的卡牌数量
    exui_CardCollection:ShowCZHeroInfo(1) 
    exui_CardCollection:SetScrollbar()
    local str ="";
    if(#self.KaiKuList > 0)then
        str = self.KaiKuList[1]:ID();
        for i = 2,#self.KaiKuList do
            if self.KaiKuList[i] ~= nil then
                 str = str..","..self.KaiKuList[i]:ID();
            end
        end
    end
    QY2LessonManager.SetLocPaiZu(str);

end


function wnd_CardHouseClass:KaikuListChanged()
    self.LastKaiKuList = {}
    local playerAvaHero = Player:GetAvaHeros()
    for i=1,#playerAvaHero do
        local ID = playerAvaHero[i]:GetAttr(AvaInfo.HeroID)
        local heroData = SData_Hero.GetHero( ID )
        table.insert(self.LastKaiKuList,heroData)
    end
    if #self.KaiKuList ~= #self.LastKaiKuList then
        return true;
    end
    table.sort(self.KaiKuList,function(item1,item2) return item1:ID() < item2:ID() end)
    table.sort(self.LastKaiKuList,function(item1,item2) return item1:ID() < item2:ID() end)
    for i=1,#self.KaiKuList do
        if self.KaiKuList[i]:ID() ~= self.LastKaiKuList[i]:ID() then
            return true
        end
    end
    self.PaiZuCardHasBeenSaved = true;
    return false;
end


function wnd_CardHouseClass:GetKaiKuList()
    return self.KaiKuList
end

--将需要服务器保存的英雄数据的ID提取出来保存为string类型
function wnd_CardHouseClass:GetKaiKuIDString()  
    if #self.KaiKuList ~= 0 then
        self.IDString = tostring(self.KaiKuList[1]:ID())
        for i = 2,#self.KaiKuList do
            self.IDString = self.IDString..","..tostring(self.KaiKuList[i]:ID())
        end
    end
end

--牌库界面操作协议
function wnd_CardHouseClass:SendChangesNetWork()
    self:GetKaiKuIDString()
    if self.IDString == nil then
        return nil
    end
    local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","SetAvaH")  
	jsonNM:Add ("hidlist", self.IDString)--当前出战英雄ID字符串
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.SendHeroChanges)
end

--保存英雄的服务器通讯协议
function wnd_CardHouseClass:SendHeroChanges(jsonDoc)
    local Result = tonumber (jsonDoc:GetValue("r"))
    print("Result:",Result)
    if 0 == Result and #self.KaiKuList then
        self.PaiZuCardHasBeenSaved = true
        exui_CardCollection.PaiZuHeroHasBeenSaved = true --标识点击“+”后牌组中的英雄已经保存
        if not exui_CardCollection.AddHeroBeenClicked and self.PaiZuFinishHasBeenClicked then
            Poptip.PopMsg("保存英雄成功！",Color.white)
        end
    else
        Poptip.PopMsg("保存英雄出错",Color.white)
    end 
end

--英雄碎片够兑换英雄时候兑换协议
function wnd_CardHouseClass:NewCardJoinNetWork(heroID)
    local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","dhHero")  
    jsonNM:Add ("id",tonumber(heroID))   
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.isNewCardJoined)
end

function wnd_CardHouseClass:isNewCardJoined(jsonDoc)
    local Result = tonumber (jsonDoc:GetValue("r"))
    print("Result:",Result)
    if 0 == Result then
        local playerHero = Player:GetHeros()
        --兑换新英雄后需要重新显示玩家已获得英雄
        self.DuiHuanHeroSucceed = true
        self:SetLabel("cih_txt_widget/txt_bg2/txt",#playerHero) 
        self:FillContent() --重新创建牌组中的牌进行重新排序
        self:CreateCardHeroUI() --创建卡牌对象

        exui_CardCollection:SetAddHeroBtnHidePos()
    else
        Poptip.PopMsg("兑换英雄失败!",Color.red)
        print("兑换英雄失败！")
    end 
end

function wnd_CardHouseClass:setDropCardItemList(heroID,heroCard)
    DropCardItemList[heroID] = heroCard
end

--用于锁定牌组中的牌
function wnd_CardHouseClass:LockPaiZuHero(Type)
    if Type == 1 then
        exui_CardCollection:SetCardState(DropCardItemList,1) --不用重新创建卡牌设置牌组中的牌为锁定状态
    elseif Type == 0 then
        self.AllowDrag = true
        exui_CardCollection:SetCardState(DropCardItemList,0) --解锁牌组中的锁定状态
    end
end

--帮助按钮的调用函数
function wnd_CardHouseClass:OnHelpChick()
    exui_CardCollection:OnHelpChick()
end


--销毁当前页面卡牌 避免出现半身像显示在推关界面
function wnd_CardHouseClass:ReleaseShowHero()
    for i = 1,#self.ItemNow do
        self.ItemNow[i].info.gameObject:SetActive(false)
    end
    self.BtnLastpage:SetActive(false)
    self.BtnNextpage:SetActive(false)
    DropCardItemList = {}
end

--点击关闭按钮响应函数
function wnd_CardHouseClass:OnClose()
    self.CloseAudio:SetEnable(true) --播放关闭音效
    self.CloseAudio:ReStart()
    StartCoroutine(self,self.DoClose,{})
 
end

function wnd_CardHouseClass:DoClose()

    if not self:KaikuListChanged() then
        exui_CardCollection:PlayCloseTwnner() --播放动画
        Yield(0.5)
        self:ReleaseShowHero() --销毁当前页面卡牌
        exui_CardCollection:ReleasePaizuHero() --销毁牌组中卡牌
        EventHandles.OnWndExit:Call(WND.CardHouse)
    else
        if self.AllowToDrag then
            wnd_ShuangXuan:SetCurrFrame(2)
            wnd_ShuangXuan:Show() --用于弹出双选框
            wnd_ShuangXuan:SetLabelInfo(SData_Id2String.Get(3245),SData_Id2String.Get(3240))
        else
            exui_CardCollection:PlayCloseTwnner() --播放动画
            Yield(0.5)
            self:SendChangesNetWork() --推关状态下直接保存牌组
            self:ReleaseShowHero() --销毁当前页面卡牌
            exui_CardCollection:ReleasePaizuHero() --销毁牌组中卡牌
            EventHandles.OnWndExit:Call(WND.CardHouse)
        end
    end

    wnd_tuiguan:ShowOrHidePaikuTips() --推关界面，牌库上的红点提示

end




function wnd_CardHouseClass:returncurrheroID()
	local tab = {}
	for k,v in pairs (CZCardInfo)do
		tab[#tab+1] = v.id
	end
	return tab
end


function wnd_CardHouseClass:OnLostInstance()
    table.clear(CardHeroItem)--界面资源被回收，清空卡牌

    self.IsAnythingChanged = false 
    self.PaikuHadCreated = false
    self.pkitem = nil
    self.ZhanBu = nil
    self.DragDropSurface = nil
    self.HeroGrid = nil
    self.pkitem = nil
    self.CMHeroGrid = nil
    self.CMDragDropSurface = nil
    self.DragDropCtrl = nil
    self.BtnLastpage = nil
    self.BtnNextpage = nil
    self.PUobj = nil
    self.HeroMenuText = nil
    self.PopUpList = nil
    self.SelectLight = nil
    self.alpha = nil
    self.CloseAudio = nil
end


return wnd_CardHouseClass.new
--endregion