---
--- Created by Administrator.
--- DateTime: 2017/7/1 13:32
---

local comPropty_controller = {}

local _view = require("uiscripts/myEquip/comPropty/comPropty_view")
local _data = require("uiscripts/myEquip/comPropty/comPropty_model")
local SuitProps = require("uiscripts/commonGameObj/suitProps")
local _comProptyP = nil
local _isShow = false

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
        if _isShow then
            _isShow = false
            dotweenUtil:Move(_comProptyP, Vector3(0, -1.5, 0),
            function ()
                if not _isShow then
                    _view.comProp_L:SetActive(false)
                    _view.btn_comPropL_Spr:GetComponent("UISprite").spriteName = spriteNameUtil.COMPROPS_MOVE_UP
                end
            end)
        else
            self:show(_view.comProp_L)
            _view.comProp_L:SetActive(true)
            _isShow = true
            dotweenUtil:Move(_comProptyP, Vector3(0, 1.5, 0),
            function ()
                if _isShow then
                    _view.btn_comPropL_Spr:GetComponent("UISprite").spriteName = spriteNameUtil.COMPROPS_MOVE_DOWN
                end
            end)
        end
    end

    ---
    ---左侧全部装备信息界面的背景蒙版，用于关闭该界面
    ---
    UIEventListener.Get(_view.comProp_L).onClick = function ()
        _isShow = false
        dotweenUtil:Move(_comProptyP, Vector3(0, -1.5, 0),
        function ()
            if not _isShow then
                _view.comProp_L:SetActive(false)
                _view.btn_comPropL_Spr:GetComponent("UISprite").spriteName = spriteNameUtil.COMPROPS_MOVE_UP

            end
        end)
    end

    ---
    ---右侧全部装备信息按钮
    ---
    UIEventListener.Get(_view.btn_comPropR).onClick = function ()
        if _isShow then
            _view.otherEquip:SetActive(true)
            _isShow = false
            dotweenUtil:Move(_comProptyP, Vector3(0, -1.5, 0),
            function ()
                if not _isShow then
                    _view.comProp_R:SetActive(false)
                    _view.btn_comPropR_Spr:GetComponent("UISprite").spriteName = spriteNameUtil.COMPROPS_MOVE_UP

                end
            end)
        else
            self:show(_view.comProp_R)
            _view.comProp_R:SetActive(true)
            _isShow = true
            dotweenUtil:Move(_comProptyP, Vector3(0, 1.5, 0),
            function ()
                if _isShow then
                    _view.otherEquip:SetActive(false)
                    _view.btn_comPropR_Spr:GetComponent("UISprite").spriteName = spriteNameUtil.COMPROPS_MOVE_DOWN

                end
            end)
        end
    end

    ---
    ---右侧全部装备信息界面的背景蒙版，用于关闭该界面
    ---
    UIEventListener.Get(_view.comProp_R).onClick = function ()
        _view.otherEquip:SetActive(true)
        _isShow = false
        dotweenUtil:Move(_comProptyP, Vector3(0, -1.5, 0),
        function ()
            if not _isShow then
                _view.comProp_R:SetActive(false)
                _view.btn_comPropR_Spr:GetComponent("UISprite").spriteName = spriteNameUtil.COMPROPS_MOVE_UP

            end
        end)
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
        _view.basicProp_ScrollV:GetComponent("UIPanelEX").depth = 21
        _view.suitProp_ScrollV:GetComponent("UIPanelEX").depth = 21
        borderUtil:AddBorder(_view.basicProp_ScrollV)
        borderUtil:AddBorder(_view.suitProp_ScrollV)
    end
    self:refresh()
    _comProptyP.transform:SetParent(parent.transform)
    _comProptyP.transform.localPosition = Vector3(0,0,0)
    _comProptyP.transform.position = _comProptyP.transform.position - Vector3(0, 1.5, 0)
    _comProptyP:SetActive(true)
end

---
---刷新显示信息
---

function comPropty_controller:refresh()

    ---刷新装备基础信息
    self:refreshBasicProps()
    ---刷新装备套装信息
    self:refreshSuit()
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
function comPropty_controller:refreshSuit()
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
        if equipNum >= equipSuitUtil:getMinSuitEquipNum(suitID) then
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
                _suitProp[i] = SuitProps(_suitPanel[i].transform:Find("prop").gameObject, Const.SUIT_PROP_PIVOT.TOP_LEFT)
            end
            _suitProp[i]:Refresh(suitID)

            local propY = _data:Math_abs(_suitPanel[i].transform:Find("prop").transform.localPosition.y)
            local propHeight = _suitProp[i]:getHeight()
            local suitHeight = _suitPanel[i]:GetComponent("UIWidget").height
            if propY + propHeight + 30 >= suitHeight then
                _suitPanel[i]:GetComponent("UIWidget").height = propY + propHeight + 30
            end
            _suitPanel[i]:SetActive(true)
            i = i + 1
        end
    end
end


return comPropty_controller

