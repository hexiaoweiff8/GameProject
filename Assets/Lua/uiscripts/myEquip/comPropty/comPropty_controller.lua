---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:32
---

local comPropty_controller = {}

local _view = require("uiscripts/myEquip/comPropty/comPropty_view")
local _data = require("uiscripts/myEquip/comPropty/comPropty_model")
local _comProptyP = nil
function comPropty_controller:init(args)
    _view:init_view(args)
    _view.btn_comPropL:SetActive(false)
    _view.btn_comPropR:SetActive(false)
    _view.comProp_L:SetActive(false)
    _view.comProp_R:SetActive(false)
    self:addListener()
end

---
---为全部装备信息功能的按钮和关闭蒙版添加监听
---
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
    self:refresh()
    _comProptyP.transform:SetParent(parent.transform)
    _comProptyP.transform.localPosition = Vector3(0,0,0)
    _comProptyP:SetActive(true)
end

---
---刷新显示信息
---

function comPropty_controller:refresh()

    ---刷新装备基础信息
    self:refreshBasicProps()
    ---刷新装备套装信息
    self:refreshSuitProps()
end


---
---刷新基本属性信息
---
local _basicPropsLab = {}   ---基本属性对象
function comPropty_controller:refreshBasicProps()
    ---获取保存所有基础信息的表
    local basicProps = _data:getBasicPropsList()
    ---隐藏所有基础信息对象
    if _basicPropsLab and #_basicPropsLab > 0 then
        for i = 1,#_basicPropsLab do
            _basicPropsLab[i]:SetActive(false)
        end
    end

    ---遍历基础信息表
    local i = 1
    for attributeID, attributeValue in pairs(basicProps) do
        ---判断用于显示的对象是否存在，不存在则创建
        if not _basicPropsLab[i] then
            _basicPropsLab[i] = _view:createBasicProp(_view.basicProp_Grid)
        end
        ---设置要显示的信息
        _basicPropsLab[i]:GetComponent("UILabel").text =
            attributeUtil:getAttributeName(attributeID).."+"..attributeValue..attributeUtil:getAttributeSymbol(attributeID)
        ---显示该对象
        _basicPropsLab[i]:SetActive(true)
        i = i + 1
    end
    _view.basicProp_Grid:GetComponent("UIGrid"):Reposition()
end

---
---刷新显示穿戴装备的所有套装信息
---
local _suitPanel = {}   ---套装界面对象
local _suitProp = {}    ---套装属性对象
function comPropty_controller:refreshSuitProps()
    ---获取保存所有套装ID和穿戴数量的表
    local _suitList = _data:getSuitList()
    ---隐藏所有套装界面
    if _suitPanel and #_suitPanel > 0 then
        for i = 1,#_suitPanel do
            _suitPanel[i]:SetActive(false)
        end
    end

    ---遍历套装表
    local i = 1
    for suitID, equipNum in pairs(_suitList) do
        ---穿戴数量大于1的才有套装属性，才显示
        if equipNum > 1 then
            ---判断套装界面是否存在，不存在则创建
            if not _suitPanel[i] then
                _suitPanel[i] = _view:createSuit(_view.suitProp_StartPoint)
            end
            if i > 1 then
                local lastSuitP_Y = _suitPanel[i-1].transform.localPosition.y
                local lastSuitP_Height = _suitPanel[i-1]:GetComponent("UIWidget").height
                _suitPanel[i].transform.localPosition = Vector3(0, -(lastSuitP_Y + lastSuitP_Height + 30), 0)
            end
            _suitPanel[i].transform:Find("title/name"):GetComponent("UILabel").text = equipSuitUtil:getEquipSuitName(suitID)



            if not _suitProp[i] then
                _suitProp[i] = _view:createSuitProp(_suitPanel[i].transform:Find("prop").gameObject)
            end
            _suitProp[i]:GetComponent("UILabel").text = EquipUtil:getEquipmentSuitEffectStr(suitID)

            local propY = _data:Math_abs(_suitProp[i].transform.parent.localPosition.y)
            local propHeight = _suitProp[i]:GetComponent("UIWidget").height
            local suitHeight = _suitPanel[i]:GetComponent("UIWidget").height
            print(propY, propHeight, suitHeight)
            if propY + propHeight >= suitHeight then
                _suitPanel[i]:GetComponent("UIWidget").height = propY + propHeight +10
            end
            _suitPanel[i]:SetActive(true)
            i = i + 1
        end
    end
end

return comPropty_controller

