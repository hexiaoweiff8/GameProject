--  U3d 抽奖
--  时间:2016.05.04
local wnd_ChouJiangClass = class(wnd_base)
    wnd_ChouJiang = nil
STRINGCUTLINE = "=========================================="
local ChouJiangClick = {

    ClickNone = 0,      --无
    ClickCopper = 1,    --点击第一界面中的铜币
    ClickGold = 2,      --点击第一界面中的金币
}


local PerviewStar = {
    Copper = {},
    Gold = {}
}

local PerviewItem = {
    Copper = {},
    Gold = {}
}
--PerviewInfoCopper
local PerviewInfo = {
    Copper = {
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Copper String"},
        },
    Gold = {
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
        {BookName = 5, ID = 1023,   Num = 1,Comment = "This is Gold String"},
    }
}
local ChouJiangBtn = {

    Copper1 = 1,        --铜币一次
    Copper10 = 3,       --铜币10次
    Gold1 = 2,          --金币一次
    Gold10 = 4,         --金币10次

}
local AwardItemInfo = {}

local ChouJiangMixed = {
    CurrBtn = {},
    CurrentPage = 0,
    
    AwardCursor = 1,            --奖励游标
    AwardItemActive = 1,        --奖励显示游标
    ChouJiangType = -1,         --1、铜币1次,2、金币1次 3、铜币10次,4、金币10次,5、魂匣... 
    
    TodayCopperFreeCount,       --今日铜币免费次数 
    TodayCopperFreeMax,         --每日铜币1免费最大次数
    Copper1IsFree,              --当前铜币是否处于免费 1倒计时中，2免费
    Copper1Cost,                --铜币单抽消耗铜币的数量 
    Copper10Cost,               --铜币10抽消耗铜币的数量 
    Copper1Original,            --铜币单抽原价 
    Copper10Original,           --铜币10抽原价 
    CopperProduceOut,           --距离铜币必出碎片还有多少次 
    Copper1FreeTimeCount,       --铜币单抽免费倒计时 
    CopperDiscount,             --铜币限时折扣时间 

    TodayGoldFreeCount,         --今日金币免费次数 
    Gold1Cost,                  --金币单抽消耗金币的数量 
    Gold10Cost,                 --金币10抽消耗金币的数量 
    Gold1Original,              --金币单抽原价 
    Gold10Original,             --金币10抽原价     
    GoldProduceOut,             --距离金币必出武将还有多少次 
    Gold1FreeTimeCount,         --金币单抽免费倒计时 
    Gold1Discount,              --金币1限时折扣时间 
    Gold1DiscountText,          --金币单抽倒计时文本
    Gold10Discount,             --金币10限时折扣时间 
    Gold10DiscountText,         --金币10抽倒计时文本
}

local ChouJiangAwardItem = {}
local BanShen = nil

function wnd_ChouJiangClass:Start()
    print("wnd_ChouJiangClass:Start")
	wnd_ChouJiang = self
	self:Init(WND.ChouJiang)
end

function wnd_ChouJiangClass:OnNewInstance()
    --第一级界面中的铜币和金币
    self:BindUIEvent("btn_type1",UIEventType.Click,"OnClickFirstPageBtn",ChouJiangClick.ClickCopper)
    self:BindUIEvent("btn_type2",UIEventType.Click,"OnClickFirstPageBtn",ChouJiangClick.ClickGold)
    --抽奖按钮
    self:BindUIEvent("btn_buy1",UIEventType.Click,"OnChouJiang",ChouJiangBtn.Copper1)
    self:BindUIEvent("btn_buy2",UIEventType.Click,"OnChouJiang",ChouJiangBtn.Copper10)
    self:BindUIEvent("btn_buy3",UIEventType.Click,"OnChouJiang",ChouJiangBtn.Gold1)
    self:BindUIEvent("btn_buy4",UIEventType.Click,"OnChouJiang",ChouJiangBtn.Gold10)
    --预览按钮
    self:BindUIEvent("btn_yulan1",UIEventType.Click,"OpenPreview",ChouJiangClick.ClickCopper)
    self:BindUIEvent("btn_yulan2",UIEventType.Click,"OpenPreview",ChouJiangClick.ClickGold)
    --再抽
    self:BindUIEvent("btn_replay",UIEventType.Click,"OnAgain")
    --预览底板
    self:BindUIEvent("diban_btshow1",UIEventType.Click,"OpenPreview",ChouJiangClick.ClickNone)
    self:BindUIEvent("diban_btshow2",UIEventType.Click,"OpenPreview",ChouJiangClick.ClickNone)
    --3级界面确定
    self:BindUIEvent("btn_ok",UIEventType.Click,"CloseAward")
    --关闭按钮
    self.ChouJiangCloseBtn = self.instance:FindWidget("btn_back")
    --再抽
    self.btn_replay = self.instance:FindWidget("content3/btn_replay")
    self.btn_ok = self.instance:FindWidget("content3/btn_ok")

    self:BindUIEvent("btn_back",UIEventType.Click,"OnClose")
    --兑换金币
    self:BindUIEvent("title/diban_title3/btn_title3",UIEventType.Click,"OnGold")
    --点击5级界面
    self:BindUIEvent("content5/bg",UIEventType.Click,"OnClickLevel_5")
    ----点击4级界面
    --self:BindUIEvent("content4/dh_show",UIEventType.Click,"OnClickLevel_4")
    --绑定倒计时相关内容
    self:BindTimeCount()
    --创建奖励项
    self:CreateAwardItem()
    --创建预览项
    --self:CreatePerviewItem()

    self.BanShen = self.instance:FindWidget( "content5/heroget/img" )
    self.diban_freetime3 = self.instance:FindWidget( "diban_cost3/diban_freetime3" )
    self.UIchoujiangx = self.instance:FindWidget("UIchoujiangx")

    self.Position2 = self.instance:FindWidget("diban_cost3/tarpos02"):GetLocalPosition()
    self.Position1 = self.instance:FindWidget("diban_cost3/tarpos01"):GetLocalPosition()
    self.GoldFreeTxt = self.instance:FindWidget("diban_freetime3")
end
function wnd_ChouJiangClass:InitData()

    ChouJiangMixed.Gold1Original = sdata_keyvalue:GetV(sdata_keyvalue.I_GoldPrice,1)
    ChouJiangMixed.Gold10Original = sdata_keyvalue:GetV(sdata_keyvalue.I_Gold10LianPrice,1)
    ChouJiangMixed.TodayCopperFreeMax = sdata_keyvalue:GetV(sdata_keyvalue.I_CopperFreeTimes,1)
    ChouJiangMixed.Copper1Original = sdata_keyvalue:GetV(sdata_keyvalue.I_CopperPrice,1)
    ChouJiangMixed.Copper10Original = sdata_keyvalue:GetV(sdata_keyvalue.I_Copper10LianPrice,1)
    ChouJiangMixed.Copper1FreeTimeCount = -1     
    ChouJiangMixed.CopperDiscount       = -1   
    ChouJiangMixed.Gold1FreeTimeCount   = -1     
    ChouJiangMixed.Gold1Discount        = -1    
    ChouJiangMixed.Gold10Discount       = -1      

    local is = self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2")
    is:SetActive(false)
end
function wnd_ChouJiangClass:OnLostInstance()
    
end

function wnd_ChouJiangClass:OnShowDone()
   
    self:InitData()
    self:RequestContent()
    self:PAGETO(1)
    self:UpdateResource()
    self:SetChouJiang4BtnEnable(nil,true)

    self.UIchoujiangx:SetActive(false)
    --self.BanShen:SetActive(true)
    --self.BanShen:SetActive(false)
end

function wnd_ChouJiangClass:UpdateUI()
    --print("wnd_ChouJiangClass:UpdateUI itemIcon ",itemIcon)
    local CopperIcon = self.instance:FindWidget("btn_replay/diban_recost/copper")
    local GoldIcon = self.instance:FindWidget("btn_replay/diban_recost/gold")
    CopperIcon:SetActive( ChouJiangMixed.ChouJiangType == 1 or ChouJiangMixed.ChouJiangType == 3)
    GoldIcon:SetActive( ChouJiangMixed.ChouJiangType == 2 or ChouJiangMixed.ChouJiangType == 4)
     --再抽
    local str
    if ChouJiangMixed.ChouJiangType == 1 or ChouJiangMixed.ChouJiangType == 2 then
        str = SData_Id2String.Get(5029)
    else
        str = SData_Id2String.Get(5030)
    end
    print("wnd_ChouJiangClass:UpdateUI",ChouJiangMixed.ChouJiangType,str)
    CodingEasyer:SetLabel(self.instance:FindWidget("content3/btn_replay/txt_replay"),str)
   
end
--解析奖励
function wnd_ChouJiangClass:UpdateResource()
    CodingEasyer:printf("wnd_ChouJiangClass:UpdateResource")
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_title2/txt_title2"),Player:GetNumberAttr(PlayerAttrNames.Copper))
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_title3/txt_title3"),Player:GetNumberAttr(PlayerAttrNames.Gold))
end

--解析奖励
function wnd_ChouJiangClass:SetAwardItem(xxx)
    print("wnd_ChouJiangClass:SetAwardItem")
end


--解析数据
function wnd_ChouJiangClass:SetChouJiangData(xxx)
    print("wnd_ChouJiangClass:SetChouJiangData")
end

--第一级界面中的按钮点击事件
function wnd_ChouJiangClass:OnClickFirstPageBtn(gameObj,id)
    print("wnd_ChouJiangClass:OnClickFirstPageBtn")

    --开启二级界面
    self:PAGETO(2)
    --开启铜币界面
    self:SetWidgetActive("content2/copper",ifv(id == ChouJiangClick.ClickCopper,true,false))
    --开启金币界面
    self:SetWidgetActive("content2/gold",ifv(id == ChouJiangClick.ClickGold,true,false))
end

--function wnd_paihangbangClass:FillData(reDoc)
--	local n = 1
--	self.rankList = {}
--
--	local rank = reDoc:GetValue("ranklist")
--	local rankFunc = function(id,mailInfos)
--        local rank = {}
--        rank.pm = tonumber( mailInfos:GetValue("pm") )
--        rank.lv = tonumber( mailInfos:GetValue("lv") )
--        rank.name = tostring( mailInfos:GetValue("name") )
--		rank.face = tostring( mailInfos:GetValue("faceIdx") )
--		self.rankList[n] = rank   
--		n = n + 1 
--    end
--    rank:Foreach(rankFunc)
--end
function wnd_ChouJiangClass:CloseDyWidget()
    self:SetWidgetActive("btn_type2/txt_discount2",false)
    self:SetWidgetActive("btn_type1/txt_discount1",false)
    self:SetWidgetActive("btn_type1/txt_discount1",false)
    self:SetWidgetActive("btn_type1/txt_discount1",false)
end
--填充信息
function wnd_ChouJiangClass:FillContent(reDoc)
    print("wnd_ChouJiangClass:FillContent")
    self:GetContent(reDoc)
    self:StartTimeCount()
    self:CloseDyWidget()
    self:UpdateStaticText()
end
function wnd_ChouJiangClass:GetContent(reDoc)
    ChouJiangMixed.Copper1Cost = tonumber(reDoc:GetValue("ctb"))            --铜币1
    ChouJiangMixed.Gold1Cost = tonumber(reDoc:GetValue("cjb"))              --金币1
    ChouJiangMixed.Copper10Cost = tonumber(reDoc:GetValue("stb"))           --铜币10
    ChouJiangMixed.Gold10Cost = tonumber(reDoc:GetValue("sjb"))             --金币10
    ChouJiangMixed.CopperDiscount = tonumber(reDoc:GetValue("stbdzt"))      --铜币10打折
    ChouJiangMixed.Gold1Discount = tonumber(reDoc:GetValue("cjbdzt"))       --金币1打折
    ChouJiangMixed.Gold10Discount = tonumber(reDoc:GetValue("sjbdzt"))      --金币10打折
    ChouJiangMixed.Copper1FreeTimeCount = tonumber(reDoc:GetValue("tbmft")) --铜币1免费
    ChouJiangMixed.Gold1FreeTimeCount = tonumber(reDoc:GetValue("jbmft"))   --金币1免费
    ChouJiangMixed.TodayCopperFreeCount = tonumber(reDoc:GetValue("tbcs"))  --今日铜币免费次数
    ChouJiangMixed.Copper1IsFree = tonumber(reDoc:GetValue("tbmfst"))       --铜币1抽状态1倒计时2免费
    ChouJiangMixed.GoldProduceOut = tonumber(reDoc:GetValue("jbccs"))       --距离出武将还差多少次
end
function wnd_ChouJiangClass:PPPPPPPP()
    print("wnd_ChouJiangClass:PPPPPPPP")
    print("ChouJiangMixed.Copper1Cost:",ChouJiangMixed.Copper1Cost)
    print("ChouJiangMixed.Gold1Cost:",ChouJiangMixed.Gold1Cost)
    print("ChouJiangMixed.Copper10Cost:",ChouJiangMixed.Copper10Cost)
    print("ChouJiangMixed.Gold10Cost:",ChouJiangMixed.Gold10Cost)
    print("ChouJiangMixed.CopperDiscount:",ChouJiangMixed.CopperDiscount)
    print("ChouJiangMixed.Gold1Discount:",ChouJiangMixed.Gold1Discount)
    print("ChouJiangMixed.Gold10Discount:",ChouJiangMixed.Gold10Discount)
    print("ChouJiangMixed.Copper1FreeTimeCount:",ChouJiangMixed.Copper1FreeTimeCount)
    print("ChouJiangMixed.Gold1FreeTimeCount:",ChouJiangMixed.Gold1FreeTimeCount)
    print("ChouJiangMixed.TodayCopperFreeCount:",ChouJiangMixed.TodayCopperFreeCount)
    print("ChouJiangMixed.GoldProduceOut:",ChouJiangMixed.GoldProduceOut)
end

function wnd_ChouJiangClass:ChouJiangEvent()
    print("wnd_ChouJiangClass:ChouJiangEvent")
        AwardItemInfo = {}
        local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","ChouJiang")  
        jsonNM:Add("t",ChouJiangMixed.ChouJiangType) 
		local loader = GameConn:CreateLoader(jsonNM,0) 
		HttpLoaderEX.WaitRecall(loader,self,self.DoEndChouJiang)
end
function wnd_ChouJiangClass:RequestContent()
    print("wnd_ChouJiangClass:RequestContent")
        local jsonNM = QKJsonDoc.NewMap()	
	    jsonNM:Add("n","ChouJiangInfo")  
	    local loader = GameConn:CreateLoader(jsonNM,0) 
	    HttpLoaderEX.WaitRecall(loader,self,self.FillContent)
end

--绑定倒计时
function wnd_ChouJiangClass:BindTimeCount()
    print("wnd_ChouJiangClass:BindTimeCount")
    --铜币打折倒计时相关#############################################################################
	self.Copper1_Free_TimeCountCm = self.ChouJiangCloseBtn:AddComponent("component/CMUICountDown")
	self.Copper1_Free_TimeCountCm:SetTextFillFunc(self,self.CopperFreeTimeCountUpdate)
	self.Copper1_Free_TimeCountCm:SetCountDownEndFunc(self,self.CopperFreeTimeCountRecall) 
    --铜币打折倒计时相关#############################################################################
	self.Copper10_Discount_TimeCountCm = self.ChouJiangCloseBtn:AddComponent("component/CMUICountDown")
	self.Copper10_Discount_TimeCountCm:SetTextFillFunc(self,self.Copper10DiscountTimeCountUpdate)
	self.Copper10_Discount_TimeCountCm:SetCountDownEndFunc(self,self.Copper10DiscountTimeCountRecall) 
    --金1抽免费倒计时相关#############################################################################
	self.Gold1_Free_TimeCountCm = self.ChouJiangCloseBtn:AddComponent("component/CMUICountDown")
	self.Gold1_Free_TimeCountCm:SetTextFillFunc(self,self.Gold1FreeTimeCountUpdate)
	self.Gold1_Free_TimeCountCm:SetCountDownEndFunc(self,self.Gold1FreeTimeCountRecall) 
    --金1抽打折倒计时相关#############################################################################
	self.Gold1_Discount_TimeCountCm = self.ChouJiangCloseBtn:AddComponent("component/CMUICountDown")
	self.Gold1_Discount_TimeCountCm:SetTextFillFunc(self,self.Gold1DiscountTimeCountUpdate)
	self.Gold1_Discount_TimeCountCm:SetCountDownEndFunc(self,self.Gold1DiscountTimeCountRecall) 
    --金10抽打折倒计时相关#############################################################################
	self.Gold10_Discount_TimeCountCm = self.ChouJiangCloseBtn:AddComponent("component/CMUICountDown")
	self.Gold10_Discount_TimeCountCm:SetTextFillFunc(self,self.Gold10DiscountTimeCountUpdate)
	self.Gold10_Discount_TimeCountCm:SetCountDownEndFunc(self,self.Gold10DiscountTimeCountRecall) 
end

--金币10打折倒计时刷新函数
function wnd_ChouJiangClass:Gold10DiscountTimeCountUpdate(time_num,time_str)
    --print("wnd_ChouJiangClass:Gold10DiscountTimeCountUpdate："..time_num)
    ChouJiangMixed.Gold10Discount = tonumber ( time_num )
    --二级界面金币10免费倒计时文本
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost4/g10discount/diban_freetime4/txt_freetime4"),string.sformat(SData_Id2String.Get(5022),time_str))
    --二级界面金币10原价
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost4/txt_cost4"),ChouJiangMixed.Gold10Original)
    --二级界面金币10折后价
    CodingEasyer:SetLabel(self.instance:FindWidget("g10discount/diban_nowcost4/txt_nowcost4"),ChouJiangMixed.Gold10Cost)
    --二级界面金币10打折相关
    self:SetWidgetActive("gold/diban_cost4/g10discount",time_num>0)
end
--金币10打折倒计时回调函数
function wnd_ChouJiangClass:Gold10DiscountTimeCountRecall()
    --print("wnd_ChouJiangClass:Gold10DiscountTimeCountRecall")
    --二级界面金币1打折相关
    self:SetWidgetActive("gold/diban_cost4/g10discount",false)
    CodingEasyer:SetLabel(self.instance:FindWidget("txt_buynum4"),"抽十次")
end

function wnd_ChouJiangClass:SetFreeTxtPosition(_isUp)
    print("===============================wnd_ChouJiangClass:SetFreeTxtPosition===============================",_isUp)
    
    local v = Vector3.new()
    if _isUp then   
        v.x = self.Position2.x
        v.y = self.Position2.y
        v.z = self.Position2.z
    else
        v.x = self.Position1.x
        v.y = self.Position1.y
        v.z = self.Position1.z
    end
    print(v)
    self.GoldFreeTxt:SetLocalPosition(v)
end

--金币1打折倒计时刷新函数
function wnd_ChouJiangClass:Gold1DiscountTimeCountUpdate(time_num,time_str)
    --print("wnd_ChouJiangClass:Gold1DiscountTimeCountUpdate：",time_num,time_str)
    ChouJiangMixed.Gold1Discount = tonumber ( time_num )
    ChouJiangMixed.Gold1DiscountText = time_str
    --二级界面金币1免费倒计时文本
    CodingEasyer:SetLabel(self.instance:FindWidget("g1discount/diban_distime3/txt_distime3"),string.sformat(SData_Id2String.Get(5022),time_str))
    --二级界面金币1原价
    CodingEasyer:SetLabel(self.instance:FindWidget("gold/diban_cost3/txt_cost3"),ChouJiangMixed.Gold1Original)
    --二级界面金币1折后价
    CodingEasyer:SetLabel(self.instance:FindWidget("g1discount/diban_nowcost3/txt_nowcost3"),ChouJiangMixed.Gold1Cost)
    --一级界面金币1打折倒计时
    CodingEasyer:SetLabel(self.instance:FindWidget("content1/btn_type2/txt_discount2"),string.sformat(SData_Id2String.Get(5022),time_str))
    --一级界面金币1打折
    self:SetWidgetActive("btn_type2/txt_discount2",time_num > 0)
    --二级界面金币1打折相关
    self:SetWidgetActive("gold/diban_cost3/g1discount",time_num>0)
    self:SetFreeTxtPosition(time_num>0)
end

--金币1打折倒计时回调函数
function wnd_ChouJiangClass:Gold1DiscountTimeCountRecall()
    --print("wnd_ChouJiangClass:Gold1DiscountTimeCountRecall")
    --二级界面金币1打折相关
    self:SetWidgetActive("gold/diban_cost3/g1discount",false)
    self:SetFreeTxtPosition(false)
    CodingEasyer:SetLabel(self.instance:FindWidget("txt_buynum3"),"抽一次ss")
end


--金币1免费倒计时刷新函数
function wnd_ChouJiangClass:Gold1FreeTimeCountUpdate(time_num,time_str)
    --print("wnd_ChouJiangClass:Gold1FreeTimeCountUpdate:"..time_num,time_str)
    ChouJiangMixed.Gold1FreeTimeCount = tonumber ( time_num )
    local is = self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2")
    is:SetActive(true)
    --二级界面金币1免费倒计时文本
	CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost3/diban_freetime3/txt_freetime3"),string.sformat(SData_Id2String.Get(5018),time_str)) --界面2

    if ChouJiangMixed.Gold1FreeTimeCount > 0 then 
        CodingEasyer:SetLabel(self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2"),string.sformat(SData_Id2String.Get(5018),time_str)) --界面1
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2"),SData_Id2String.Get(5023))--界面1
    end
    self:SetWidgetActive("diban_cost3/diban_freetime3",time_num >0 )
end

--金币1免费倒计时回调函数
function wnd_ChouJiangClass:Gold1FreeTimeCountRecall()
    --print("wnd_ChouJiangClass:Gold1FreeTimeCountRecall")
    local is = self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2")
    is:SetActive(true)
    --二级界面金币花费
    CodingEasyer:SetLabel(self.instance:FindWidget("gold/diban_cost3/txt_cost3"),SData_Id2String.Get(5025))
    --二级界面金币1按钮文本
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost3/btn_buy3/txt_buynum3"),SData_Id2String.Get(5025))
    --二级界面金币1按钮红点
    self:SetWidgetActive("pic_freetip3",true)
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2"),SData_Id2String.Get(5023)) --免费
end

--铜币免费倒计时刷新函数
function wnd_ChouJiangClass:CopperFreeTimeCountUpdate(time_num,time_str)
    --print("wnd_ChouJiangClass:CopperFreeTimeCountUpdate",time_num,time_str)
    ChouJiangMixed.Copper1FreeTimeCount = tonumber ( time_num )
    --一级界面铜币免费倒计时刷新
    --二级界面铜币免费次数刷新
    if ChouJiangMixed.TodayCopperFreeCount <= 0 then 
        CodingEasyer:SetLabel(self.instance:FindWidget("c1free/diban_freetimes1/txt_freetimes1"),"铜币1今日次数用完")
        CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/diban_freenum1/txt_freenum1"),SData_Id2String.Get(5020))
    else
	    CodingEasyer:SetLabel(self.instance:FindWidget("c1free/diban_freetimes1/txt_freetimes1"),string.sformat(SData_Id2String.Get(5018),time_str)) 
        CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/diban_freenum1/txt_freenum1"),string.sformat(SData_Id2String.Get(5018),time_str))
        if ChouJiangMixed.Copper1FreeTimeCount <= 0 then
            CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost1/diban_note1/txt_note1"),string.sformat(SData_Id2String.Get(5019),ChouJiangMixed.TodayCopperFreeCount,ChouJiangMixed.TodayCopperFreeMax)) 
        end
    end
    local tep = self.instance:FindWidget("btn_type1/diban_freenum1")
    tep:SetActive(true)
end

--铜币免费倒计时回调函数
function wnd_ChouJiangClass:CopperFreeTimeCountRecall()
     --CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/diban_freenum1/txt_freenum1"),"免费")
     CodingEasyer:SetLabel(self.instance:FindWidget("c1free/diban_freetimes1/txt_freetimes1"),"铜币1免费次数:"..ChouJiangMixed.TodayCopperFreeCount.."/"..ChouJiangMixed.TodayCopperFreeMax) 
     if ChouJiangMixed.TodayCopperFreeCount <= 0 then 
        CodingEasyer:SetLabel(self.instance:FindWidget("c1free/diban_freetimes1/txt_freetimes1"),"铜币1今日次数用完")
     end
     
end

--铜币打折倒计时刷新函数
function wnd_ChouJiangClass:Copper10DiscountTimeCountUpdate(time_num,time_str)
    --print("wnd_ChouJiangClass:Copper10DiscountTimeCountUpdate")
    ChouJiangMixed.CopperDiscount = tonumber ( time_num )
    --local text =  string.sformat(_TXT(325),time_str)
    --一级界面铜币打折倒计时刷新
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/txt_discount1"),string.sformat(SData_Id2String.Get(5022),time_str))
    self:SetWidgetActive("btn_type1/txt_discount1",true)
    --二级界面铜币打折倒计时刷新
	CodingEasyer:SetLabel(self.instance:FindWidget("c10discount/diban_freetime2/txt_freetime2"),string.sformat(SData_Id2String.Get(5022),time_str))
    self:SetWidgetActive("copper/diban_cost2/c10discount",time_num >0 )
end

--铜币打折倒计时回调函数
function wnd_ChouJiangClass:Copper10DiscountTimeCountRecall()
    --print("wnd_ChouJiangClass:Copper10DiscountTimeCountRecall")
    --一级界面铜币打折倒计时回调
    --CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/txt_discount1"),"在这显示回调结果")
    self:SetWidgetActive("btn_type1/txt_discount1",false)
    --二级界面铜币打折倒计时回调
    self:SetWidgetActive("copper/diban_cost2/c10discount",false)
end

--开启倒计时
function wnd_ChouJiangClass:StartTimeCount()
    print("wnd_ChouJiangClass:StartTimeCount",
    ChouJiangMixed.Copper1FreeTimeCount,
    ChouJiangMixed.CopperDiscount,
    ChouJiangMixed.Gold1FreeTimeCount,
    ChouJiangMixed.Gold1Discount,
    ChouJiangMixed.Gold10Discount
    )
    if ChouJiangMixed.Copper1FreeTimeCount > 0 then --铜币免费倒计时
		self.Copper1_Free_TimeCountCm:StartCountDown(ChouJiangMixed.Copper1FreeTimeCount)--启动倒计时 
	end
    
    if ChouJiangMixed.CopperDiscount > 0 then --铜币打折倒计时
		self.Copper10_Discount_TimeCountCm:StartCountDown(ChouJiangMixed.CopperDiscount)--启动倒计时 
	end
    
     if ChouJiangMixed.Gold1FreeTimeCount > 0 then --金币免费倒计时
		self.Gold1_Free_TimeCountCm:StartCountDown(ChouJiangMixed.Gold1FreeTimeCount)--启动倒计时 
	end
    
    if ChouJiangMixed.Gold1Discount > 0 then --金币1打折倒计时
		self.Gold1_Discount_TimeCountCm:StartCountDown(ChouJiangMixed.Gold1Discount)--启动倒计时 
	end
    
    if ChouJiangMixed.Gold10Discount > 0 then --金币10打折倒计时
		self.Gold10_Discount_TimeCountCm:StartCountDown(ChouJiangMixed.Gold10Discount)--启动倒计时 
	end


    --self.Copper1_Free_TimeCountCm:StartCountDown(ChouJiangMixed.Copper1FreeTimeCount)--启动倒计时 
    --self.Copper10_Discount_TimeCountCm:StartCountDown(ChouJiangMixed.CopperDiscount)--启动倒计时 
    --self.Gold1_Free_TimeCountCm:StartCountDown(ChouJiangMixed.Gold1FreeTimeCount)--启动倒计时 
    --self.Gold1_Discount_TimeCountCm:StartCountDown(ChouJiangMixed.Gold1Discount)--启动倒计时 
    --self.Gold10_Discount_TimeCountCm:StartCountDown(ChouJiangMixed.Gold10Discount)--启动倒计时 

end

--兑换金币
function wnd_ChouJiangClass:OnGold()
    print("wnd_ChouJiangClass:OnGold")
    WndJumpManage:Jump(WND.ChouJiang,WND.Chongzhi)
end
--关闭界面
function wnd_ChouJiangClass:OnClose()
    print("wnd_ChouJiangClass:OnClose")
    self:PAGETO(ChouJiangMixed.CurrentPage -1)
end


--刷新稳定Text
function wnd_ChouJiangClass:UpdateStaticText()
    print("wnd_ChouJiangClass:UpdateStaticText:",ChouJiangMixed.Copper1Cost)
    
    --今日铜币免费次数
    if ChouJiangMixed.Copper1FreeTimeCount < 0 then 
        CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/diban_freenum1/txt_freenum1"),string.sformat(SData_Id2String.Get(5019),ChouJiangMixed.TodayCopperFreeCount,ChouJiangMixed.TodayCopperFreeMax)) --界面1
        CodingEasyer:SetLabel(self.instance:FindWidget("c1free/diban_freetimes1/txt_freetimes1"),"铜币1免费次数:"..ChouJiangMixed.TodayCopperFreeCount.."/"..ChouJiangMixed.TodayCopperFreeMax) -- 界面2
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost1/diban_note1/txt_note1"),SData_Id2String.Get(5020))
    end
    if ChouJiangMixed.TodayCopperFreeCount == 0 then 
        CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/diban_freenum1/txt_freenum1"),SData_Id2String.Get(5020))
        CodingEasyer:SetLabel(self.instance:FindWidget("c1free/diban_freetimes1/txt_freetimes1"),"铜币1今日次数用完")
    end
    CodingEasyer:SetLabel(self.instance:FindWidget("content5/txt"),SData_Id2String.Get(5032)) --"点击任意区域退出"
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_ok/txt_ok"),SData_Id2String.Get(5031)) --"确定"
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_title1/txt"),SData_Id2String.Get(5001)) --"占卜"
    --一级界面金币最下层
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_type2/diban_freenum2/txt_freenum2"),SData_Id2String.Get(5023)) --免费
    --距离必出碎片还差多少次
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_type1/txt_10times1"),SData_Id2String.Get(5021)) --"10次必出武将碎片"
    --距离必出武将还差多少次
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_type2/txt_10times2"),SData_Id2String.Get(5028))--"金币十连抽必出武将"
    --二级界面铜币1抽花费
    if ChouJiangMixed.Copper1IsFree == 2 then
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost1/txt_cost1"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost1/txt_cost1"),ChouJiangMixed.Copper1Cost)
    end
    --二级界面铜币10连抽原价
    if ChouJiangMixed.Copper10Cost == 0 then
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost2/txt_cost2"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost2/txt_cost2"),ChouJiangMixed.Copper10Original)
    end 
    --二级界面铜币1抽文本
    if ChouJiangMixed.Copper1IsFree == 2 then
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost1/btn_buy1/txt_buynum1"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost1/btn_buy1/txt_buynum1"),SData_Id2String.Get(5026))
    end
    
    --二级界面铜币10抽文本
    if ChouJiangMixed.Copper10Cost == 0 then
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost2/btn_buy2/txt_buynum2"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost2/btn_buy2/txt_buynum2"),SData_Id2String.Get(5027))
    end
    
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost2/diban_note2/txt_note2"),SData_Id2String.Get(5021) )
    --二级界面铜币10连抽当前价格
    CodingEasyer:SetLabel(self.instance:FindWidget("c10discount/diban_nowcost2/txt_nowcost2"),tostring( ChouJiangMixed.Copper10Cost ) )
    --二级界面金币1抽原价
    if ChouJiangMixed.Gold1Cost == 0 then
        CodingEasyer:SetLabel(self.instance:FindWidget("gold/diban_cost3/txt_cost3"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("gold/diban_cost3/txt_cost3"),ChouJiangMixed.Gold1Original)
    end
    --二级界面金币1抽文本
    if ChouJiangMixed.Gold1Cost == 0 then
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost3/btn_buy3/txt_buynum3"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost3/btn_buy3/txt_buynum3"),SData_Id2String.Get(5026))
    end
    --二级界面金币10抽原价
    if ChouJiangMixed.Gold10Cost == 0 then
        CodingEasyer:SetLabel(self.instance:FindWidget("gold/diban_cost4/txt_cost4"),SData_Id2String.Get(5025))
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost4/btn_buy4/txt_buynum4"),SData_Id2String.Get(5025))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("gold/diban_cost4/txt_cost4"),ChouJiangMixed.Gold10Original)
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost4/btn_buy4/txt_buynum4"),SData_Id2String.Get(5027))
    end
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost4/diban_note4/txt_note4"),SData_Id2String.Get(5028))
    --再抽界面花费
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_replay/diban_recost/txt_recost"),self:GetAgainCost())
    --二级界面铜币10打折
    self:SetWidgetActive("copper/diban_cost2/c10discount",ChouJiangMixed.CopperDiscount >0 )
    --二级界面铜币1抽小红点
    self:SetWidgetActive("c1free/pic_freetip1",ChouJiangMixed.Copper1IsFree == 2 )
    --二级界面铜币10抽小红点
    self:SetWidgetActive("c10free/pic_freetip2",ChouJiangMixed.Copper10Cost == 0 )
    --二级界面金币1免费红点
    self:SetWidgetActive("g1free/pic_freetip3",ChouJiangMixed.Gold1Cost == 0)
    --二级界面金币10免费红点
    self:SetWidgetActive("g10free/pic_freetip4",ChouJiangMixed.Gold10Cost == 0)
    --二级界面金币1免费倒计时
    self:SetWidgetActive("diban_cost3/diban_freetime3",ChouJiangMixed.Gold1FreeTimeCount >0 )
    --二级界面金币1打折相关
    self:SetWidgetActive("gold/diban_cost3/g1discount",ChouJiangMixed.Gold1Discount>0)
    self:SetFreeTxtPosition(ChouJiangMixed.Gold1Discount>0)
    --二级界面金币10打折相关
    self:SetWidgetActive("gold/diban_cost4/g10discount",ChouJiangMixed.Gold10Discount>0)
    --二级界面金币1必出武将
    local buChu = "还差"..ChouJiangMixed.GoldProduceOut.."次就出武将了"
    local biChu = "本次必出武将"
    if ChouJiangMixed.GoldProduceOut == 0 then
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost3/diban_note3/txt_note3"),SData_Id2String.Get(5115))
    else
        CodingEasyer:SetLabel(self.instance:FindWidget("diban_cost3/diban_note3/txt_note3"),string.sformat(SData_Id2String.Get(5024),ChouJiangMixed.GoldProduceOut))
    end
    
end
function wnd_ChouJiangClass:GetAgainCost()
    if ChouJiangMixed.ChouJiangType == 1 then 
        return ChouJiangMixed.Copper1Cost
    elseif ChouJiangMixed.ChouJiangType ==2 then
        return ChouJiangMixed.Gold1Cost
    elseif ChouJiangMixed.ChouJiangType ==3 then
        return ChouJiangMixed.Copper10Cost
    else
        return ChouJiangMixed.Gold10Cost
    end
end 
--强制显示层级
function wnd_ChouJiangClass:PAGETO(PageID)
    print("wnd_ChouJiangClass:PAGETO:"..PageID)
    if PageID == 0 then 
        --self:Hide()
        wnd_tuiguan:ShowOrHidePaikuTips() --推关界面，牌库上的红点提示
        EventHandles.OnWndExit:Call(WND.ChouJiang)
        return 
    end

    local oldPage = ChouJiangMixed.CurrentPage
    --设置当前界面
    ChouJiangMixed.CurrentPage = PageID

    if oldPage == 1 and PageID == 2 then
        return 
    elseif oldPage == 2 and PageID == 1 then
        return
    end
    ----开启一级界面
    --self:SetWidgetActive("content1",ifv(PageID == 1,true,false))
    ----开启二级界面
    --self:SetWidgetActive("content2",ifv(PageID == 2,true,false))
    --开启三级界面
    self:SetWidgetActive("content3",ifv(PageID == 3,true,false))

    if PageID == 2 then 
        self:ChouJiangInterrupt()
    end 
end
function wnd_ChouJiangClass:ChouJiangInterrupt()
    ChouJiangMixed.AwardCursor = 1
    ChouJiangMixed.AwardItemActive = 1
    self:SetAgainBtnEnable(true)      
    if  self.sequencem ~= nil then 
        self.sequencem:Kill(false) 
    end
end

function wnd_ChouJiangClass:SetChouJiang4BtnEnable(gameobj,isEnable)
    --ChouJiangMixed.CurrBtn = gameobj
    --if ChouJiangMixed.CurrBtn == nil then return end
    --local cm = gameobj:GetComponent(CMUIButton.Name)
    --print("wnd_ChouJiangClass:SetChouJiang4BtnEnable",gameobj:GetName(),cm,isEnable)
    --cm:SetEnable(isEnable)
end

--点击抽奖
function wnd_ChouJiangClass:OnChouJiang(gameobj,ID)
    print("wnd_ChouJiangClass:OnChouJiang:"..ID)

    local obj = {}
    if ID == ChouJiangBtn.Copper1 then 
        ChouJiangMixed.ChouJiangType = 1
        obj = self.instance:FindWidget("btn_buy1")
    elseif ID == ChouJiangBtn.Copper10 then 
        ChouJiangMixed.ChouJiangType = 3
        obj = self.instance:FindWidget("btn_buy2")
    elseif ID == ChouJiangBtn.Gold1 then 
        ChouJiangMixed.ChouJiangType = 2
        obj = self.instance:FindWidget("btn_buy3")
    elseif ID == ChouJiangBtn.Gold10 then 
        ChouJiangMixed.ChouJiangType = 4
        obj = self.instance:FindWidget("btn_buy4")
    else 
        ChouJiangMixed.ChouJiangType = -1
    end
    self:SetChouJiang4BtnEnable(obj,false)

    self:ChouJiangEvent()
    self.UIchoujiangx:SetActive(false)
end
function wnd_ChouJiangClass:IsResourceEnough()
    --ChouJiangType = -1,         --1、铜币1次,2、金币1次 3、铜币10次,4、金币10次,5、魂匣... 
    local Hold = 0
    local Cost = 999999
    if ChouJiangMixed.ChouJiangType == 1  then
        Hold = tonumber( Player:GetNumberAttr(PlayerAttrNames.Copper) )
        Cost = tonumber( ChouJiangMixed.Copper1Cost )
    elseif ChouJiangMixed.ChouJiangType == 2 then
        Hold = tonumber( Player:GetNumberAttr(PlayerAttrNames.Gold) )
        Cost = tonumber( ChouJiangMixed.Gold1Cost )
    elseif ChouJiangMixed.ChouJiangType == 3 then
        Hold = tonumber( Player:GetNumberAttr(PlayerAttrNames.Copper) )
        Cost = tonumber( ChouJiangMixed.Copper10Cost )
    elseif ChouJiangMixed.ChouJiangType == 4 then
        Hold = tonumber( Player:GetNumberAttr(PlayerAttrNames.Gold) )
        Cost = tonumber( ChouJiangMixed.Gold10Cost )
    end

    return Hold >= Cost
    
end
function wnd_ChouJiangClass:OnAgain()
    --self:PAGETO(2)
    --Poptip.PopMsg("抽奖类型"..ChouJiangMixed.ChouJiangType,Color.red)
    if self:IsResourceEnough() == false then
        Poptip.PopMsg("资源不足",Color.red)
        return
    end

    self:SetAgainBtnEnable(false)
    self:OnChouJiang(nil,ChouJiangMixed.ChouJiangType)
end

--查看预览
function wnd_ChouJiangClass:OpenPreview(gameobj,id)
    print("wnd_ChouJiangClass:OpenPreview:"..id)

    self:SetWidgetActive("diban_btshow1",id == ChouJiangClick.ClickCopper)
    self:SetWidgetActive("diban_btshow2",id == ChouJiangClick.ClickGold)
end

--关闭预览
function wnd_ChouJiangClass:ClosePerview()
    print("wnd_ChouJiangClass:ClosePerview")

end

--关闭三级按钮
function wnd_ChouJiangClass:CloseAward()
    print("wnd_ChouJiangClass:CloseAward")

    self:PAGETO(2)
end

--创建奖励项
function wnd_ChouJiangClass:CreateAwardItem()
    print("wnd_ChouJiangClass:CreateAwardItem")
    for i = 1 ,11 do
        local itemObj = self.instance:FindWidget("content3/10itemfly/item"..i)
		itemObj:SetActive(false)
        ChouJiangAwardItem[i] = itemObj
        --print("wnd_ChouJiangClass:CreateAwardItem  ChouJiangAwardItem[i]", ChouJiangAwardItem[i])
    end
end

--抽奖完成
function wnd_ChouJiangClass:DoEndChouJiang(reDoc)
    print("wnd_ChouJiangClass:DoEndChouJiang")
    local result = reDoc:GetValue("r")
    self:SetChouJiang4BtnEnable(ChouJiangMixed.CurrBtn,true)
    if result ~= "0" then 
        if result == "1" then Poptip.PopMsg("资源不足",Color.red) end 
        Poptip.PopMsg("DoEndChouJiangResult:"..result, Color.red)
        return 
    end
    wnd_tuiguan:SyncJL()
    wnd_tuiguan:UpdateResource()
    self.UIchoujiangx:SetActive(true)
    print("wnd_ChouJiangClass:DoEndChouJiang2")
    self:PAGETO(3)
    local ItemList =  reDoc:GetValue("jl")
    --print(STRINGCUTLINE,reDoc:GetValue("g"))
    --	local rank = reDoc:GetValue("ranklist")
	print("wnd_ChouJiangClass:DoEndChouJiang3")
    local i = 1
    AwardItemInfo = {}
	local rankFunc = function(_,JLNode)
        --print(JLNode)
        local JL = {}
        JL.BookName = tonumber(JLNode:GetValue("b"))
        JL.SubType = tonumber(JLNode:GetValue("i"))
        JL.Num = tonumber(JLNode:GetValue("n"))
        if ChouJiangMixed.ChouJiangType == 1 or ChouJiangMixed.ChouJiangType == 2 then
            CodingEasyer:SetJLIcon(ChouJiangAwardItem[11],JL)
        else
            CodingEasyer:SetJLIcon(ChouJiangAwardItem[i],JL)
        end
        AwardItemInfo[i] = JL
        --CodingEasyer:PrintJL(JL)

        
        i = i + 1
    end
    ItemList:Foreach(rankFunc)
	print("wnd_ChouJiangClass:DoEndChouJiang4")
    self:PAGESHOW(nil,5,false)
	print("wnd_ChouJiangClass:DoEndChouJiang5")
    self:PAGESHOW(nil,4,false)
	print("wnd_ChouJiangClass:DoEndChouJiang6")
    for i = 1, #ChouJiangAwardItem do 
        ChouJiangAwardItem[i]:SetActive(false)
    end
	print("wnd_ChouJiangClass:DoEndChouJiang7")
    ChouJiangMixed.AwardCursor = 1
    ChouJiangMixed.AwardItemActive = 1

    self:PlayPreAction1()
	print("wnd_ChouJiangClass:DoEndChouJiang8")
end

--动画演示
function wnd_ChouJiangClass:AwardItemAnimation()
    if wnd_ChouJiang.isVisible == false then return end
    print("wnd_ChouJiangClass:AwardItemAnimation")
    local sequencem = Sequence.new()
    self.sequencem = sequencem
    local timelost = 0      --本次需要何时显示英雄
    local ItemCount = 0     --本次显示进行到了第几个奖励项
    local CurrentCount = 1  --当前显示计数例如第二次调用本函数时从item4开始 时间从1开始 而不是从4开始
    local isHaveHero = false    --本次是否抽到英雄
    if ChouJiangMixed.AwardCursor > ifv(#AwardItemInfo ==10 ,10,1) then 
        return
    end
    local HeroNode = {}
    for i = ChouJiangMixed.AwardCursor,ifv(#AwardItemInfo==10 ,10,1) do 
        local itemObj =  ifv(#AwardItemInfo==10 ,ChouJiangAwardItem[i],ChouJiangAwardItem[11])
        local ItemPosition = itemObj:GetPosition()
        local timesmooth = 0.3
        local tweenm = DoTween.DOMove(itemObj,ItemPosition,0.6)
        sequencem:InsertCallback(timesmooth*(CurrentCount-1),self,self.AwardItemActive)
    
        local tempInfo = AwardItemInfo[i]
    
        ItemCount = i
        if tempInfo.BookName == 2 then 
            isHaveHero = true
            print(ItemCount,tempInfo.BookName,tempInfo.SubType,tempInfo.Num)
            HeroNode = tempInfo
            break
        end
    
        timelost = timesmooth*(CurrentCount-1)+0.6
        CurrentCount = CurrentCount + 1
    end
    ChouJiangMixed.AwardCursor = ItemCount+1
    if isHaveHero then
         --sequencem:InsertCallback(timelost,self,self.PopHeroFrame)
        BanShen = HeroNode.SubType
        sequencem:AppendCallback(self,self.PopHeroFrame)
    else
       
    end

    
end


function wnd_ChouJiangClass:PlayPreAction1()
    
    self:SetAgainBtnEnable(false)
    --self:AwardItemAnimation()
    self:UpdateResource()
	print("wnd_ChouJiangClass:PlayPreAction1")
    self:UpdateUI()
    self:RequestContent()

    local UIchoujiangx = self.instance:FindWidget("UIchoujiangquan")
    local UIchoujiangxCM = UIchoujiangx:GetComponent(CMUIParticleSystem.Name)
    UIchoujiangxCM:Play()
    
    local sequencem = Sequence.new()
    sequencem:InsertCallback(2.0,self,self.AwardItemAnimation)
end
function wnd_ChouJiangClass:PlayActionItem()
    local tempitem = self.instance:FindWidget("10itemfly/item"..self.TxIndex)
    local tweener = tempitem:GetComponent(CMUITweener.Name)
    tweener:PlayForward()
end
function wnd_ChouJiangClass:PlayActionComplate()
    local paimian = self.instance:FindWidget("paimian"..self.TxIndex.."/fan")
    paimian:SetActive(false)

    local sequencem = Sequence.new()
    sequencem:InsertCallback(2.0,self,self.PlayActionItem)
end

function wnd_ChouJiangClass:PlayAction3()
    if wnd_ChouJiang.isVisible == false then return end
    local paimian = self.instance:FindWidget("paimian"..self.TxIndex)
    local paimianCM = paimian:GetComponent(CMUIParticleSystem.Name)
    paimianCM:Play()

    local sequencem = Sequence.new()
    sequencem:InsertCallback(0.6,self,self.PlayActionComplate)
end

function wnd_ChouJiangClass:PlayAction2()
    if wnd_ChouJiang.isVisible == false then return end
    local UIchoujiangshengcheng = self.instance:FindWidget("UIchoujiangshengcheng"..self.TxIndex)
    local UIchoujiangshengchengCM = UIchoujiangshengcheng:GetComponent(CMUIParticleSystem.Name)
    UIchoujiangshengchengCM:Play()

    local sequencem = Sequence.new()
    sequencem:InsertCallback(0.4,self,self.PlayAction3)
end
function wnd_ChouJiangClass:PlayAction1()
    if wnd_ChouJiang.isVisible == false then return end
    local UIchoujiangbaofa = self.instance:FindWidget("UIchoujiangbaofa"..self.TxIndex)
    local UIchoujiangbaofaCM = UIchoujiangbaofa:GetComponent(CMUIParticleSystem.Name)
    UIchoujiangbaofaCM:Play()
    local sequencem = Sequence.new()
    sequencem:InsertCallback(0.4,self,self.PlayAction2)
end
--激活奖励项回调
function wnd_ChouJiangClass:AwardItemActive()
    if wnd_ChouJiang.isVisible == false then return end

    self.TxIndex = ChouJiangMixed.AwardItemActive
    self:PlayAction1()
    print("wnd_ChouJiangClass:AwardItemActive:"..ChouJiangMixed.AwardItemActive,"self.TxIndex",self.TxIndex)

    local itemObj =  ifv(#AwardItemInfo==10 ,ChouJiangAwardItem[ ChouJiangMixed.AwardItemActive],ChouJiangAwardItem[11])
    itemObj:SetActive(true)
    if #AwardItemInfo==10 then
        ChouJiangMixed.AwardItemActive = ChouJiangMixed.AwardItemActive + 1
    else
        ChouJiangMixed.AwardItemActive = 11
    end

    if ChouJiangMixed.ChouJiangType == 1 or ChouJiangMixed.ChouJiangType == 2 then 
        self:SetAgainBtnEnable(true)
    else
        if ChouJiangMixed.AwardItemActive == 10 then
            self:SetAgainBtnEnable(true)
        end
    end
    print("wnd_ChouJiangClass:AwardItemActive End")
end

function wnd_ChouJiangClass:SetAgainBtnEnable(isEnable)
    self.btn_replay:SetActive(isEnable)
    self.btn_ok:SetActive(isEnable)
end
--弹出5级界面
function wnd_ChouJiangClass:PopHeroFrame()
    print("wnd_ChouJiangClass:PopHeroFrame")
    self:PAGESHOW(nil,5,true)
    
    print("wnd_ChouJiangClass:PopHeroFrame HeroNode",BanShen)
    local Hero = SData_Hero.GetHero(BanShen)
    
    local BanshenW = self.instance:FindWidget( "content5/heroget/img" )
	local HeroBanshen = BanshenW:GetComponent(CMUIHeroBanshen.Name)
	HeroBanshen:SetIcon(BanShen,false)

    local Name = self.instance:FindWidget("content5/heroget/txt")
    CodingEasyer:SetLabel(Name,Hero:Name())
end
--
function wnd_ChouJiangClass:PAGESHOW(gameobj,pageid,isshow)
    --print("wnd_ChouJiangClass:PAGESHOW:"..gameobj..pageid..isshow)
	--if tonumber( pageid ) == 4 then 
	--	pageid = 3
	--end
    local PageArray = {
        --"content1","content2","content3","content4","content5",
        "","","content3","content4","content5",
    }
    self:SetWidgetActive(PageArray[pageid],isshow)
end

--点击5级界面
function wnd_ChouJiangClass:OnClickLevel_5()
    print("wnd_ChouJiangClass:OnClickLevel_5")
    self:PAGESHOW(nil,5,false)
    --self:PAGESHOW(nil,4,true)
    self:AwardItemAnimation()
end

--点击4级界面
function wnd_ChouJiangClass:OnClickLevel_4()
    print("wnd_ChouJiangClass:OnClickLevel_4")

    self:PAGESHOW(nil,4,false)
    self:AwardItemAnimation()
end


--创建预览界面中的项
function wnd_ChouJiangClass:CreatePerviewItem()
    print("wnd_ChouJiangClass:CreatePerviewItem")

    self.m_PerviewCopper = self.instance:FindWidget("copper/diban_btshow1/diban_show1/headtuozhuai1/headgrid1/pic_head1")
    self.m_PerviewCopper:SetActive(false)

    self.m_PerviewGold = self.instance:FindWidget("gold/diban_btshow2/diban_show2/headtuozhuai2/headgrid2/pic_head2")
    self.m_PerviewGold:SetActive(false)

    self.m_PerviewStarCopper = self.instance:FindWidget("pic_star1")
    self.m_PerviewStarGold = self.instance:FindWidget("pic_star2")

    for k,v in pairs(PerviewItem) do
        for i = 1,#v do 
            PerviewItem[k][i]:Destroy()
        end
    end

    for i = 1,8 do --
        PerviewStar.Copper[i] = GameObject.InstantiateFromPreobj(self.m_PerviewStarCopper,self.m_PerviewStarCopper:GetParent())
        PerviewStar.Gold[i] = GameObject.InstantiateFromPreobj(self.m_PerviewStarGold,self.m_PerviewStarGold:GetParent())
    end


    local Flag = 1
    for k,v in pairs(PerviewInfo) do
        local tempVector = PerviewItem[k]
        local templateItem = ifv(Flag == 1,self.m_PerviewCopper,self.m_PerviewGold)
        for i = 1,#v do 
            local itemObj = GameObject.InstantiateFromPreobj(templateItem,templateItem:GetParent())
            local tempName = ifv(Flag == 1,"Copper_","Gold_").."Perview"..i
            itemObj:SetName(tempName)
            itemObj:SetActive(true)
            self:BindUIEvent(tempName,UIEventType.Click,ifv(Flag == 1,"OnClickPerviewItemCopper","OnClickPerviewItemGold"),v[i])
            PerviewItem[k][i] = itemObj
        end
    
        Flag = Flag + 1
    end
    self.m_PerviewStarCopper:SetActive(false)
    self.m_PerviewStarGold:SetActive(false)
    CodingEasyer:Reposition(self.instance:FindWidget("copper/diban_btshow1/diban_show1/headtuozhuai1/headgrid1"))
    CodingEasyer:Reposition(self.instance:FindWidget("gold/diban_btshow2/diban_show2/headtuozhuai2/headgrid2"))
    CodingEasyer:Reposition(self.instance:FindWidget("stargrid1"))
    CodingEasyer:Reposition(self.instance:FindWidget("stargrid2"))
    --self:Reposition("copper/diban_btshow1/diban_show1/headtuozhuai1/headgrid1")
    --self:Reposition("gold/diban_btshow2/diban_show2/headtuozhuai2/headgrid2")
    --self:Reposition("stargrid1")
    --self:Reposition("stargrid2")
end

function wnd_ChouJiangClass:Debug()
    self:PPPPPPPP()
end

function wnd_ChouJiangClass:Test(gameobj)
    local UIchoujiangx = self.instance:FindWidget("UIchoujiangquan")
    local UIchoujiangxCM = UIchoujiangx:GetComponent(CMUIParticleSystem.Name)
    UIchoujiangxCM:Play()
end

--预览界面中的点击
function wnd_ChouJiangClass:OnClickPerviewItemCopper(gameobj,ItemInfo)
    print("wnd_ChouJiangClass:OnClickPerviewItemCopper")
    print(ItemInfo)
end
--预览界面中的点击
function wnd_ChouJiangClass:OnClickPerviewItemGold(gameobj,ItemInfo)
    print("wnd_ChouJiangClass:OnClickPerviewItemGold")
end

--[[
    
--
function wnd_ChouJiangClass:()
    print("wnd_ChouJiangClass:")
end

]]

return wnd_ChouJiangClass.new