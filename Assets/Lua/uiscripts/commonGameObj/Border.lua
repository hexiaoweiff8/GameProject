---
--- Created by Administrator.
--- DateTime: 2017/7/17 17:09
---

local class = require("common/middleclass")
local Border = class("Border")

function Border:initialize(scrollV)

    self.ScrollV_UIPanel = scrollV:GetComponent(typeof(UIPanelEX))
    self.ScrollV_UIScrollV = scrollV:GetComponent(typeof(UIScrollView))

    local offset = self.ScrollV_UIPanel.clipOffset
    local center = Vector2(self.ScrollV_UIPanel.baseClipRegion.x, self.ScrollV_UIPanel.baseClipRegion.y)
    local size = Vector2(self.ScrollV_UIPanel.baseClipRegion.z, self.ScrollV_UIPanel.baseClipRegion.w)
    self.border_Up_y = size.y / 2 + offset.y
    self.border_Down_y = - size.y / 2 + offset.y

    self.isMoving = false

    self.Prop_border = GameObjectExtension.InstantiateFromPacket("commonU", "border", scrollV.transform.parent.gameObject).gameObject
    self.Prop_border:GetComponent("UIPanel").depth = self.ScrollV_UIPanel.depth + 1
    self.Prop_border_up = self.Prop_border.transform:Find("up").gameObject
    self.Prop_border_down = self.Prop_border.transform:Find("down").gameObject



    ---设置显示位置
    self.Prop_border_up.transform.localPosition = Vector3(0, self.ScrollV_UIPanel.height / 2, 0)
    self.Prop_border_down.transform.localPosition = Vector3(0, - (self.ScrollV_UIPanel.height / 2), 0)

    self.Prop_border_down:GetComponent("UISprite").depth = self.ScrollV_UIPanel.depth + 1
    self.Prop_border_up:SetActive(false)
    self.Prop_border_down:SetActive(false)






    --self:ShowBorder()

    self.ScrollV_UIScrollV.onDragStarted = function()
        self.isMoving = false
        coroutine.start(function()
            while self.isMoving == false do
                self:ShowBorder()
                coroutine.step()
            end
        end)
    end
    self.ScrollV_UIScrollV.onStoppedMoving = function()
        self.isMoving = true
    end

end



---
---控制边界的显示
---
function Border:ShowBorder()
    local offset = self.ScrollV_UIPanel.clipOffset
    local size = Vector2(self.ScrollV_UIPanel.baseClipRegion.z, self.ScrollV_UIPanel.baseClipRegion.w)
    --local scrollV_size = self.ScrollV_UIScrollV.bounds.size
    local scrollV_min = self.ScrollV_UIScrollV.bounds.min

    local up_Y = 2 * self.border_Up_y - (size.y / 2 + offset.y)
    local down_y = up_Y + scrollV_min.y

    if up_Y + 10 < self.border_Up_y then
        self.Prop_border_up:SetActive(true)
        self.Prop_border_up:GetComponent("UISprite").height = self.border_Up_y - up_Y
    else
        self.Prop_border_up:SetActive(false)
    end
    
    if - scrollV_min.y < size.y then
        self.Prop_border_down:SetActive(false)
        return
    end
    if down_y - 15 > self.border_Down_y then
        self.Prop_border_down:SetActive(true)
        self.Prop_border_down:GetComponent("UISprite").height = down_y - self.border_Down_y
    else
        self.Prop_border_down:SetActive(false)
    end
end


return Border 