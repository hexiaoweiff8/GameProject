---
--- Created by Administrator.
--- DateTime: 2017/7/17 17:09
---

local class = require("common/middleclass")
local Border = class("Border")

function Border:initialize(scrollV)


    ---获取组件
    self.ScrollV_UIPanel = scrollV:GetComponent(typeof(UIPanel))
    self.ScrollV_UIScrollV = scrollV:GetComponent(typeof(UIScrollView))

    ---计算上边界和下边界的位置
    local offset = self.ScrollV_UIPanel.clipOffset
    local size = Vector2(self.ScrollV_UIPanel.baseClipRegion.z, self.ScrollV_UIPanel.baseClipRegion.w)
    self.border_Up_y = size.y / 2 + offset.y
    self.border_down_Y = - size.y / 2 + offset.y

    ---判断是否拖动的标志位
    self.isMoving = false

    ---初始化上下边界的显示
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


    ---添加拖动监听
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



    ---计算scrollView对应的Panel组件的信息
    local offset = self.ScrollV_UIPanel.clipOffset
    local size = Vector2(self.ScrollV_UIPanel.baseClipRegion.z, self.ScrollV_UIPanel.baseClipRegion.w)
    ---计算scrollView组件的上下边界的位置
    local scroll_size_y = self.ScrollV_UIScrollV.bounds.size.y
    local scrollV_min_y = self.ScrollV_UIScrollV.bounds.min.y
    if not self.scrollv_max_y then
        self.scrollv_max_y = self.ScrollV_UIScrollV.bounds.max.y
    end

    ---计算scrollview上边界位置
    local up_Y = 2 * self.border_Up_y - (size.y / 2 + offset.y)
    ---计算scrollview下边界位置
    local down_Y = up_Y + scrollV_min_y - self.scrollv_max_y


    if up_Y + 10 < self.border_Up_y then
        self.Prop_border_up:SetActive(true)
        self.Prop_border_up:GetComponent("UISprite").height = self.border_Up_y - up_Y
    else
        self.Prop_border_up:SetActive(false)
    end

    if scroll_size_y < size.y then
        self.Prop_border_down:SetActive(false)
        return
    end
    if down_Y - 15 > self.border_down_Y then
        self.Prop_border_down:SetActive(true)
        self.Prop_border_down:GetComponent("UISprite").height = down_Y - self.border_down_Y
    else
        self.Prop_border_down:SetActive(false)
    end
end


return Border 