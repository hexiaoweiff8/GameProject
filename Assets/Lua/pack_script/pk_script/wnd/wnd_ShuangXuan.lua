--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local wnd_ShuangXuanClass = class(wnd_base)
    wnd_ShuangXuan = nil

local CurrFrame = {
    Others = 0,      --在其他界面弹出
    PaiZuFinish = 1, --在牌组界面点击完成按钮
    PaiZuClose = 2,  --在牌组界面点击关闭按钮
    ChuanDai = 3,  --洗练强制穿戴
    UnLockPaiZu = 4,--解锁牌组
    DragChuanDai = 5,--拖拽穿戴
    ClickChuanDai = 6,--点击穿戴
} 


function wnd_ShuangXuanClass:Start()
	wnd_ShuangXuan = self
	self:Init(WND.ShuangXuan)
end

function wnd_ShuangXuanClass:OnNewInstance()
    self.Tongyong_Shuangxuan = self.instance:FindWidget("ui_tongyong_shuangxuan_panel")
    self.BackBtn = self.instance:FindWidget("ui_tongyong_shuangxuan/back_btn")
    self.WidgetAlpha = self.BackBtn:GetComponent(CMUITweener.Name)

    self.BG = self.instance:FindWidget("ui_tongyong_shuangxuan/back_btn/BG")
    self.ShuangXuan = self.BG:GetComponents(CMUITweener.Name)

    local Tittle = self.BG:FindChild("title_bg/txt")    --提示框标题
    self.TittleLabel = Tittle:GetComponent(CMUILabel.Name) 

    local mainInfo = self.BG:FindChild("Text")   --主要显示的信息
    self.MainLabel = mainInfo:GetComponent(CMUILabel.Name)

    self.BG:FindChild("queren_Button/txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5089))
    self.BG:FindChild("quxiao_Button/txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5058))

    self:BindUIEvent("back_btn/BG/queren_Button",UIEventType.Click,"OnQueRen")
    self:BindUIEvent("back_btn/BG/quxiao_Button",UIEventType.Click,"OnCancel")
    self.ComeFromeCloseSaveHero = false --用于确定是不是点击关闭点击保存英雄弹出的补充英雄

end

function wnd_ShuangXuanClass:OnQueRen()

    if self.BGFrame == CurrFrame.PaiZuFinish then --点击“+”号提示补充英雄 --确定补充
        exui_CardCollection:AddTheLostCard()
    elseif self.BGFrame == CurrFrame.PaiZuClose then
        exui_CardCollection.CancelSavePaizu = false
        exui_CardCollection:PlayCloseTwnner() --播放动画
       StartCoroutine(self,self.DoClosePaiku,{})
    elseif self.BGFrame == CurrFrame.ChuanDai then
        wnd_xilian:OnFinish(self.Para)
    elseif self.BGFrame == CurrFrame.UnLockPaiZu then --解锁牌组       
        print("解锁牌组 确定")
        wnd_tuiguan:SendGiveUpNetWork(TuiGuanGiveUpType.TuiGuan) --放弃正在攻打的城池
        wnd_CardHouse:LockPaiZuHero(0) --解锁牌组中的牌
    elseif self.BGFrame == CurrFrame.DragChuanDai then
        print("拖拽穿戴")
        wnd_heroinfo:OnDefineChuandai(self.Para)
    elseif self.BGFrame == CurrFrame.ClickChuanDai then
        print("点击穿戴")
        wnd_heroinfo:OnQZChuanDai(self.Para)
    else
        print("当前是未知界面")
    end
    self.ShuangXuan[2]:ResetToBeginning()
    self.ShuangXuan[2]:PlayForward()
    self:Hide()
end

function wnd_ShuangXuanClass:DoClosePaiku() 
    Yield(0.5)
    wnd_CardHouse:SendChangesNetWork()
    wnd_CardHouse:ReleaseShowHero() --销毁当前页面卡牌
    exui_CardCollection:ReleasePaizuHero() --销毁牌组中卡牌
    EventHandles.OnWndExit:Call(WND.CardHouse)
end


function wnd_ShuangXuanClass:OnCancel()
    if self.BGFrame == CurrFrame.PaiZuClose then
        exui_CardCollection.CancelSavePaizu = true
        exui_CardCollection:PlayCloseTwnner() --播放动画
       StartCoroutine(self,self.DoCancel,{})

    elseif self.BGFrame == CurrFrame.ChuanDai then
        wnd_xilian:OnCancel(self.Para)
    elseif self.BGFrame == CurrFrame.DragChuanDai then
        wnd_heroinfo:OnCancelChuandai(self.Para)
    end

    self.ShuangXuan[2]:ResetToBeginning()
    self.ShuangXuan[2]:PlayForward()
    self:Hide()
end


function wnd_ShuangXuanClass:DoCancel() 
    Yield(0.5)
    wnd_CardHouse:ReleaseShowHero() --销毁当前页面卡牌
    exui_CardCollection:ReleasePaizuHero() --销毁牌组中卡牌
    EventHandles.OnWndExit:Call(WND.CardHouse)
end

function wnd_ShuangXuanClass:SetLabelInfo(TittleInfo, MainShowInfo, para)
    self.TittleInfo = TittleInfo --用于接收传进来的标题信息
    self.MainShowInfo = MainShowInfo --用于接收传进来的主要的提示信息
    self.Para = para --参数 
end

function wnd_ShuangXuanClass:SetCurrFrame(Type)
    if Type == 1 then 
        self.BGFrame = CurrFrame.PaiZuFinish
    elseif Type == 2 then
        self.BGFrame = CurrFrame.PaiZuClose
    elseif Type == 3 then
        self.BGFrame = CurrFrame.ChuanDai 
    elseif Type == 4 then
        self.BGFrame = CurrFrame.UnLockPaiZu
    elseif Type == 5 then
        self.BGFrame = CurrFrame.DragChuanDai
    elseif Type == 6 then
        self.BGFrame = CurrFrame.ClickChuanDai
    else
        self.BGFrame = CurrFrame.Others
    end
end

function wnd_ShuangXuanClass:OnLostInstance()
    
end

function wnd_ShuangXuanClass:OnShowDone()
    self.BackBtn:SetActive(true)
    self.WidgetAlpha:ResetToBeginning() 
    self.WidgetAlpha:PlayForward()

    self.ShuangXuan[1]:ResetToBeginning()
    self.ShuangXuan[1]:PlayForward()  

    self.TittleLabel:SetValue(self.TittleInfo)
    self.MainLabel:SetValue(self.MainShowInfo)
      
end

return wnd_ShuangXuanClass.new


--endregion
