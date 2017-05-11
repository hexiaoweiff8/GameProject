--region *.lua
--Date 20160707
--作者 wenchuan
--拖拽控制基类

DragDropCtrlBase = class()

local DragDropingCard = nil --当前拖拽的卡片

--- <summary> 
--- 功能 : 拖拽基类构造
--- CardHeroItem : table 卡片队列
--- </summary>
function DragDropCtrlBase:ctor(CardHeroItem,DragDropSurface)
    self.CardHeroItem = CardHeroItem
    self.Surface = DragDropSurface
end

--- <summary> 
--- 功能 : 从拖拽物中获取英雄ID
--- dragDropItem : CMDragDropItem 拖拽物
--- ret int 
--- </summary>
--- <returns type="int"></returns>
function DragDropCtrlBase:GetHeroID(dragDropItem)
    local surfaceObj = dragDropItem:GetOwnerSurface()
    local surface = surfaceObj:GetComponent(CMDragDropSurface.Name) 
    return tonumber( dragDropItem:GetUserData())
end


--- <summary> 
--- 功能 : 检查某英雄ID是否存在
--- heroID : int 英雄ID
--- ret bool
--- </summary>
--- <returns type="bool"></returns>
function DragDropCtrlBase:HasHeroID(heroID)
    for id,_ in pairs(self.CardHeroItem ) do 
        if id==heroID then return true end
    end  
    return false
end


--- <summary> 
--- 功能 : 从拖拽物中获取英雄卡片 
--- 注意 : 卡片必须在本拖拽表面内，或从本拖拽表面拖出的，否则获取会失败
--- dragDropItem : CMDragDropItem 拖拽物
--- ret HeroCard 
--- </summary>
--- <returns type="HeroCard"></returns> 
 function DragDropCtrlBase:GetHeroCard(dragDropItem)
    local heroID = self:GetHeroID(dragDropItem)
     --print("DragDropCtrlBase:GetHeroCard",heroID)
     --table.dump("GetHeroCard# ",self.CardHeroItem)
    return self.CardHeroItem[heroID]
 end

 --- <summary> 
--- 功能 : 设置当前拖拽的卡片
--- 注意 : 卡片必须在本拖拽表面内，或从本拖拽表面拖出的，否则获取会失败
--- dragDropItem : CMDragDropItem 拖拽物
--- ret HeroCard 
--- </summary>
 function DragDropCtrlBase:SetDragDropingCard(dragDropItem)
    local heroCard = self:GetHeroCard(dragDropItem) --找到拖动的卡片 
    if heroCard == nil then return nil end
     if dragDropItem:GetCloneOnDrag() then --拖拽时克隆
        DragDropingCard = heroCard:Clone(dragDropItem.gameObject)--克隆出拖拽中的卡信息
    else--直接用列表中的物体
        --print("SetDragDropingCard",heroCard)
        DragDropingCard =  heroCard
    end
 end

 function DragDropCtrlBase:GetDragDropingCard()
    if DragDropingCard ~= nil then 
        return DragDropingCard
    end
 end
 
--endregion
