---
--- Created by Administrator.
--- DateTime: 2017/6/30 17:57
---

local detailPage_controller = {}
local view
local data
local rightPanelDetail---装备信息显示界面

function detailPage_controller:init(equipController)
    view = require("uiscripts/myEquip/detailPage/detailPage_view")
    data = require("uiscripts/myEquip/detailPage/detailPage_model")
    view:init_view(equipController)
    view.rightDetail:SetActive(false)
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
        rightPanelDetail:showEquip(equip, parent, 16)
        rightPanelDetail:setShowRemakePanelFunc(equip_controller.showRemakePanel)
        rightPanelDetail:setListener()
    end
end

---
---刷新右侧信息界面
---
function detailPage_controller:refresh(equip)
    if equip then
        if rightPanelDetail then
            rightPanelDetail:refresh(equip)
            rightPanelDetail:setListener()
        end
        return
    end
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


---
---界面销毁回调
---
function detailPage_controller:OnDestroyDone()

    Memory.free("uiscripts/myEquip/detailPage/detailPage_view")
    Memory.free("uiscripts/myEquip/detailPage/detailPage_model")
    view = nil
    data = nil
    if rightPanelDetail then
        rightPanelDetail:Destroy()
    end
    rightPanelDetail = nil
    detailPage_controller = nil
end
return detailPage_controller