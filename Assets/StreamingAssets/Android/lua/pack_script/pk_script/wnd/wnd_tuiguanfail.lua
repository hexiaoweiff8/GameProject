--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local wnd_tuiguanfailClass = class(wnd_base)
    wnd_tuiguanfail = nil
local FailMixed = {

    --ShengXing,
    JiNeng,
    XiLian,
    --ZhanBu,
}

local FailEnum = {

    ShengXing = 1,
    JiNeng = 2 ,
    XiLian = 3,
    --ZhanBu = 4,
}

function wnd_tuiguanfailClass:Start()
	wnd_tuiguanfail = self
	self:Init(WND.tuiguanfail)
end

function wnd_tuiguanfailClass:OnNewInstance()
    self.Items = {}

    --table.insert(self.Items,self.instance:FindWidget("guide_grid/shengxing"))
    table.insert(self.Items,self.instance:FindWidget("guide_grid/jineng"))
    table.insert(self.Items,self.instance:FindWidget("guide_grid/xilian"))
    table.insert(self.Items,self.instance:FindWidget("guide_grid/zhanbu"))

    self.Grid = self.instance:FindWidget("guide_grid")

    self:BindUIEvent ("guide_grid/shengxing", UIEventType.Click, "OnClick",FailEnum.ShengXing)--升星
    self:BindUIEvent ("guide_grid/jineng", UIEventType.Click, "OnClick",FailEnum.JiNeng)--技能
    self:BindUIEvent ("guide_grid/xilian", UIEventType.Click, "OnClick",FailEnum.XiLian)--洗练
    self:BindUIEvent ("guide_grid/zhanbu", UIEventType.Click, "OnClick",FailEnum.ZhanBu)--抽奖

    self:BindUIEvent ("back_btn", UIEventType.Click, "OnClose")--关闭
end

function wnd_tuiguanfailClass:OnClick(gameObj,_type)
    print("wnd_tuiguanfailClass:OnClick == ",_type)
    if _type == FailEnum.ShengXing then   
        wnd_tuiguan:OnInformationClick(nil,ZhuCheng.PaiKu)
    elseif _type == FailEnum.JiNeng then
       wnd_tuiguan:OnInformationClick(nil,ZhuCheng.PaiKu)
    elseif _type == FailEnum.XiLian then
        wnd_xilian:ShowXilianUIByEquip()
    else 
        --wnd_ChouJiang:Show()
    end
    self:OnClose()

end

function wnd_tuiguanfailClass:OnClose()
    self:Hide()
end

function wnd_tuiguanfailClass:OnLostInstance()
    
end

function wnd_tuiguanfailClass:Routine()
    self:Random(2)

    local Func = function(k,v)
        v:SetActive(false)
    end
    table.foreach(self.Items,Func)

    local FuncR = function(k,v)
        self.Items[v]:SetActive(true)
    end
    table.foreach(self.Result,FuncR)

    CodingEasyer:Reposition(self.Grid)
end

function wnd_tuiguanfailClass:OnShowDone()
    self:Routine()
end

function wnd_tuiguanfailClass:RandomEnum()
    local nIndex =  math.random( 0,#self.Temp ) 
    print("wnd_tuiguanfailClass:RandomEnum == ",nIndex)
    table.insert(self.Result,self.Temp[nIndex + 1])
    table.remove(self.Temp,nIndex + 1 )
end


function wnd_tuiguanfailClass:Random( _BtnCount )
    self.Temp = {}
    for i = 1, 2 do
        table.insert(self.Temp,i)
    end
    self.Result = {}
    for i = 1 , _BtnCount do 
        self:RandomEnum()
    end

    local Func = function(k,v)
        print(k,v)
    end
    table.foreach(self.Result,Func)
end

return wnd_tuiguanfailClass.new

--endregion
