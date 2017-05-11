--region *.lua
--Date 20160706
--作者 wenchuan
--英雄卡片

HeroCard = classWC()

--卡片类型
HeroCardType = {
    Paiku = 1,--牌库中的英雄卡
    Paizu = 2,--牌组中的英雄卡
    Buzhen = 3,--布阵中的英雄卡
}

PaiZuDragStart = false

 --卡片配置
 --sp 背景精灵名
 --cloneOnDrag 拖出时是否克隆
 --restriction 拖出限定类型
local HeroCardCfg = {}
HeroCardCfg[HeroCardType.Paiku]= {  cloneOnDrag = true ,restriction = DragDropRestriction.None} 
HeroCardCfg[HeroCardType.Buzhen]= {  cloneOnDrag = false ,restriction = DragDropRestriction.None}



--牌组的配置，因左系统面板不同而不同
--第二维表示左系统面板类型
HeroCardCfg[HeroCardType.Paizu]= { 
    [HeroCardType.Paiku]= { cloneOnDrag = false ,restriction = DragDropRestriction.Horizontal },
    [HeroCardType.Buzhen]= { cloneOnDrag = true ,restriction = DragDropRestriction.Horizontal },
}
 

function HeroCard:Clone(gameObject)
    local info = table.shallowCopy(self.info)--浅复制表
    info.gameObject = gameObject --更换游戏物体
    local newHeroCard = HeroCard.new(info)
    newHeroCard:SwapType()
    return newHeroCard
end

--- <summary> 
--- 功能 : 英雄卡片构造
--- info : table 英雄信息，包含界面游戏物体，英雄静态属性，英雄动态属性等
--- info.gameObject:GameObject 拖拽物游戏物体
--- info.shape:GameObject 第三方系统游戏物体(外观)
--- info.sinfo:HeroInfo 从sdata中取得的静态数据信息
--- info.OriginalType:HeroCardType 原始卡片类型
--- info.CurrType:HeroCardType 当前卡片类型
--- </summary>
function HeroCard:ctor(info)
    self.info = info
    local gameObject = self.info.gameObject 

    
    self.dragDropItem = self.info.gameObject:GetComponent(CMDragDropItem.Name)
    if info.sinfo ~= "ZYHero" then
        self.dragDropItem:SetUserData(info.sinfo:ID())--设置唯一标识符 
        --各种外观定义
        self.shapes = {
            [HeroCardType.Paiku] = gameObject:FindChild("pkitem"),
            [HeroCardType.Paizu] = gameObject:FindChild("pzitem"),
            [HeroCardType.Buzhen] = gameObject:FindChild("bzitem")
        } 
    end
end

function HeroCard:Init() 
    --绑定点击事件 
    self:BindEvents()
end

function HeroCard:BindEvents()
     local gameObject = self.info.gameObject  
    CMUIEvent.Go(gameObject,UIEventType.Click):Listener(gameObject,UIEventType.Click,self,"OnClick") 
    CMUIEvent.Go(gameObject,UIEventType.DragStart):Listener(gameObject,UIEventType.DragStart,self,"OnDragStart")  
    CMUIEvent.Go(gameObject,UIEventType.Drag):Listener(gameObject,UIEventType.Drag,self,"OnDrag")  --拖拽事件
    CMUIEvent.Go(gameObject,UIEventType.Press):Listener(gameObject,UIEventType.Press,self,"OnPress")  --按压事件
--    CMUIEvent.Go(gameObject,UIEventType.LongPress):Listener(gameObject,UIEventType.Drag,self,"OnLongPress")  --长按事件
end

--点击事件
function HeroCard:OnClick(gameObject,_) 
    EventHandles.OnHeroCardClick:Call(self)--抛出点击事件
end

--拖动事件
function HeroCard:OnDragStart(gameObject,_)
    EventHandles.OnHeroCardDragStart:Call(self)--抛出拖拽开始事件
end

--拖动事件
function HeroCard:OnDrag(gameObject,_)
    EventHandles.OnHeroCardDrag:Call(self)--抛出拖拽事件
end

--长按事件事件
--function HeroCard:OnLongPress(gameObject,_)
--    EventHandles.OnHeroCardLongPress:Call(self)--抛出长按事件
--end

--按压事件
function HeroCard:OnPress(gameObject,isPress,_)
    EventHandles.OnHeroCardPress:Call(self,isPress)--抛出按压事件
end


---切换卡片类型
function HeroCard:SwapType()

    local currType = self.info.CurrType--当前类型

    --显隐卡片内容
    for tp,shape in pairs(self.shapes) do  
        local active = (currType==tp)
        shape:SetActive(active)

        --设置拖拽物的深度和当前显示的外观一致
        if active then
            local itemWidget = self.info.gameObject:GetComponent(CMUIWidget.Name)
            local shapeWidget = shape:GetComponent(CMUIWidget.Name)
            itemWidget:SetDepth( shapeWidget:GetDepth() )
        end

    end    
     
    --取得当前卡片类型相关设置
    local cfg 
    if currType==HeroCardType.Paizu then --牌组的配置随左面板变化而变化
        local leftSystemType = exui_CardCollection:GetLeftSystemType()--左系统类型

        cfg = HeroCardCfg[currType][leftSystemType]
    else--其它类型直接获取
        cfg = HeroCardCfg[currType]
    end

    --根据配置设定拖拽属性
    local dragDropItem = self.info.gameObject:GetComponent(CMDragDropItem.Name)
    dragDropItem:SetCloneOnDrag(cfg.cloneOnDrag)
    dragDropItem:SetRestriction(cfg.restriction)
      
    --设置卡片尺寸
    local shape = self.shapes[currType]--当前显示的外观
    local widget = shape:GetComponent(CMUIWidget.Name) 
    local size = widget:GetSize()--获取当前显示外观的尺寸
    local cl = self.info.gameObject:GetComponent(CMUIWidget.Name)--碰检控件
    cl:SetSize(size)--将当前显示外观的尺寸应用到碰检上
    cl:ResizeCollider()


    --根据左系统类型确定回调函数
    local wnd = ifv(currType==HeroCardType.Paizu,exui_CardCollection, exui_CardCollection:GetLeftSystemWnd())
    if wnd.OnSwapType==nil then 
        debug.LogError("左系统必须实现接口 OnSwapType")
    else
        wnd:OnSwapType(self,self.shapes[currType])
        PaiZuDragStart = false
    end
end

---设置拖拽表面
function HeroCard:SetDragDropSurface(Surface)
    local dragDropItem = self.info.gameObject:GetComponent(CMDragDropItem.Name) 
    dragDropItem:SetOwnerSurface(Surface)
end

---设置滚动视图
function HeroCard:SetScrollView(scrollView)
    if scrollView==nil then return end
    local dragScrollView = self.info.gameObject:GetComponent(CMUIDragScrollView.Name)
    dragScrollView:SetScrollView(scrollView)
end


function HeroCard:Destroy()
    if self.info.gameObject~=nil then
        self.info.gameObject:Destroy()
        self.info.gameObject = nil
    end
end
--endregion