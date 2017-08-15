---
--- Created by Administrator.
--- DateTime: 2017/8/8 15:13
---
local CanNotArea = {}

---初始化不可下兵区域
function CanNotArea:Init()
    self.cannotRect = GameObject.Find("/SceneRoot/canotRectGo")
    self.cannotArea = GameObject.Find("/SceneRoot/canotRectGo/canotRect")
end

---获取不可下兵区域的最大X坐标
function CanNotArea:GetMaxDropX()
    return self.cannotRect.transform.position.x
end
---改变区域的显示大小
function CanNotArea:ChangeArea(maxX)
    self.cannotRect.transform.position = Vector3(maxX, self.cannotRect.transform.position.y, self.cannotRect.transform.position.z)
end
---显示不可下兵区域
function CanNotArea:Show()
    self.cannotArea:SetActive(true)
end
---隐藏不可下兵区域
function CanNotArea:Hide()
    self.cannotArea:SetActive(false)
end

return CanNotArea