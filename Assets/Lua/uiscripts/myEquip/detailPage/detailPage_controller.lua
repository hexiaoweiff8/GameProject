---
--- Created by Administrator.
--- DateTime: 2017/6/30 17:57
---

local detailPage_controller = {}
local view = require("uiscripts/myEquip/detailPage/detailPage_view")
local data = require("uiscripts/myEquip/detailPage/detailPage_model")
local EquipDetail = require("uiscripts/commonGameObj/equipDetail")

---
---装备信息显示界面
---
local rightPanelDetail

function detailPage_controller:init(equipController)
    view:init_view(equipController)
end
---
--- 显示装备主界面右侧的装备信息界面
--- Index 所选择的装备选项的index
---
function detailPage_controller:show(equip, parent)
    if equip then
        if not rightPanelDetail then
            rightPanelDetail = EquipDetail()
        end
        rightPanelDetail:showEquip(equip, parent, 14)
        rightPanelDetail:setListener()
    end
end

---
---刷新右侧信息界面
---
function detailPage_controller:refresh()
    if rightPanelDetail then
        rightPanelDetail:refresh()
    end
end

---
---为右侧信息界面的更换装备按钮添加监听
---
function detailPage_controller:setListenerToBtnChange(func)
    if rightPanelDetail then
        rightPanelDetail:setListenerToBtnChange(func)
    end
end

return detailPage_controller