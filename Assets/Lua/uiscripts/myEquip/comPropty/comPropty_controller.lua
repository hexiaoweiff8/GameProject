---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:32
---

local comPropty_controller = {}

local _view = require("uiscripts/myEquip/comPropty/comPropty_view")
local _comProptyP = nil
function comPropty_controller:init(args)
    _view:init_view(args)
    self:addListener()
end



function comPropty_controller:addListener()
    ---
    ---左侧全部装备信息按钮
    ---
    UIEventListener.Get(_view.btn_comPropL).onClick = function ()
        if _view.comProp_L.activeSelf then
            _view.comProp_L:SetActive(false)
        else
            self:show(_view.comProp_L)
            _view.comProp_L:SetActive(true)
        end
    end

    ---
    ---左侧全部装备信息界面的背景蒙版，用于关闭该界面
    ---
    UIEventListener.Get(_view.comProp_L).onClick = function ()
        _view.comProp_L:SetActive(false)
    end

    ---
    ---右侧全部装备信息按钮
    ---
    UIEventListener.Get(_view.btn_comPropR).onClick = function ()
        if _view.comProp_R.activeSelf then
            _view.otherEquip:SetActive(true)
            _view.comProp_R:SetActive(false)
        else
            self:show(_view.comProp_R)
            _view.otherEquip:SetActive(false)
            _view.comProp_R:SetActive(true)
        end
    end

    ---
    ---右侧全部装备信息界面的背景蒙版，用于关闭该界面
    ---
    UIEventListener.Get(_view.comProp_R).onClick = function ()
        _view.otherEquip:SetActive(true)
        _view.comProp_R:SetActive(false)
    end
end
---
---显示全部装属性界面
---parent   父物体（设置位置）
---
function comPropty_controller:show(parent)
    if not parent then
        return
    end
    if not _comProptyP then
        _view:getView(parent)
        _comProptyP = _view.comPropty
    end
    _comProptyP.transform:SetParent(parent.transform)
    _comProptyP.transform.localPosition = Vector3(0,0,0)
    _comProptyP:SetActive(true)
end

---
---刷新显示信息
---
function comPropty_controller:refresh()

end

return comPropty_controller

