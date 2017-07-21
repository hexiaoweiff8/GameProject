---
--- Created by Administrator.
--- DateTime: 2017/7/10 11:34
---
local class = require("common/middleclass")
local Remake = class("Remake")
local _view = require("uiscripts/commonGameObj/remake/remake_view")
local _data = require("uiscripts/commonGameObj/remake/remake_model")
local confirmP = require("uiscripts/tips/ui_tips_confirm")
local _isInit = false
function Remake:initialize()

end

---
---添加监听
---
function Remake:addListenner()
    UIEventListener.Get(_view.btn_back).onClick = function()
        _view.RemakePanel:SetActive(false)
    end
    UIEventListener.Get(_view.maskPanel).onClick = function()
        _view.RemakePanel:SetActive(false)
    end

    for i = 1, Const.EQUIP_NORMALPROP_NUM do
        UIEventListener.Get(_view.normalProps_prop[i]).onClick = function()
            if _data.selectIndex and _data.selectIndex ~= i then
                _data.selectIndex = i
                self:refreshRemakePanel()
            end
            _view.normalProps_selected.transform.localPosition = _view.normalProps[_data.selectIndex].transform.localPosition
        end
    end

    for i = 1, 3 do
        UIEventListener.Get(_view.chooseProps_props[i]).onClick = function()
            _data.chooseIndex = i
            local position =
                Vector3(_view.chooseSp.transform.localPosition.x,
                    _view.chooseProps_props[i].transform.localPosition.y,
                    _view.chooseSp.transform.localPosition.z)
            _view.chooseSp.transform.localPosition = position
        end
    end
end


---
---根据装备显示重铸界面
---
function Remake:show(equip, parent, depth)
    if equip.rarity < 4  then
        UIToast.Show(stringUtil:getString(30104), nil, UIToast.ShowType.Upwards)
        return
    end
    if #equip.sndAttr == 0 then
        UIToast.Show("sndAttr error!!", nil, UIToast.ShowType.Upwards)
        return
    end

    if not _isInit then
        ---
        ---初始化重铸界面控件
        ---
        _view:init(parent)
        ---添加监听
        self:addListenner()

        ---设置层级
        if depth then
            _view.RemakePanel:GetComponent("UIPanel").depth = depth
        end
        _isInit = true
    end

    ---设置要显示的装备
    _data.equipToShow = equip
    ---获取该装备各个属性的状态
    _data:getProptyRemakeStatus()

    ---刷新装备头像显示
    self:refreshItem()
    ---刷新属性信息
    self:refreshProps()

    ---根据重铸属性的数量，初始化选择框的位置，刷新界面显示
    if _data.remakedNum >= 2 then
        ---计算当前已重铸属性的数量
        for i = 1, Const.EQUIP_NORMALPROP_NUM do
            if _data.remakedFlagList[i] >= _data.RemakedFlag.REMAKE_AND_CHANGE then
                _data.selectIndex = i
                break
            end
        end
    else
        _data.selectIndex = 1
    end

    ---刷新显示
    self:refreshRemakePanel()
    ---设置选择框的位置
    _view.normalProps_selected.transform.localPosition = _view.normalProps[_data.selectIndex].transform.localPosition

    _view.RemakePanel:SetActive(true)
end

---
---刷新装备头像显示
---
function Remake:refreshItem()
    if not _data.equipToShow then
        return
    end
    _view.equipItem_Icon:GetComponent("UISprite").spriteName = ""
    _view.equipItem_RarityIcon:GetComponent("UISprite").spriteName = spriteNameUtil["EQUIPRARITY_".._data.equipToShow.rarity]
    _view.equipItem_Level:GetComponent("UILabel").text = _data.equipToShow.lv
    _view.equipItem_Name:GetComponent("UILabel").text = _data.equipToShow.EquipName
end

---
---刷新装备属性显示
---
function Remake:refreshProps()
    ---主属性
    local mainString = EquipUtil:getEquipmentMainAttributeStr(_data.equipToShow.eid, _data.equipToShow.fst_attr,_data.equipToShow.lv)

    _view.mainPropLab:GetComponent("UILabel").text = mainString

    ---获取副属性字符串数组
    local strList = EquipUtil:getEquipmentSubAttributeStrList(_data.equipToShow)
    for i = 1, Const.EQUIP_NORMALPROP_NUM do
        if _data.remakedFlagList[i] ~= _data.RemakedFlag.UNACTIVE then
            _view.normalProps_prop[i]:SetActive(true)
            _view.normalProps_lock[i]:SetActive(false)
            _view.normalProps_lab[i]:GetComponent("UILabel").text = strList[i]

            ---当属性重铸状态在“可替换”以上是表示已经重铸，显示重铸标记
            _view.normalProps_prop[i]:GetComponent("BoxCollider").enabled = true
            if _data.remakedFlagList[i] >= _data.RemakedFlag.REMAKE_AND_CHANGE then
                _view.normalProps_remakeMark[i]:SetActive(true)
            else
                _view.normalProps_remakeMark[i]:SetActive(false)
                ---未重铸如果重铸属性数量大于2关闭点击事件
                if _data.remakedNum >= 2 then
                    _view.normalProps_prop[i]:GetComponent("BoxCollider").enabled = false
                end
            end
            ---判断是否达到最大
            local planId = _data.equipToShow["ViceAttribute"..i]
            local attributeId = _data.equipToShow.sndAttr[i].id
            local attributeValue = _data.equipToShow.sndAttr[i].val
            local maxValue = attributeUtil:getAttributeMaxValue(planId, attributeId)
            if attributeValue == maxValue then
                _view.normalProps_max[i]:SetActive(true)
            else
                _view.normalProps_max[i]:SetActive(false)
            end
        else
            _view.normalProps_lock[i]:SetActive(true)
            _view.normalProps_prop[i]:SetActive(false)
        end
    end

end


---
---刷新重铸材料和重铸属性部分
---
function Remake:refreshRemakePanel()

    ---判断是否有可以替换的属性。
    if _data.remakedFlagList[_data.selectIndex] == _data.RemakedFlag.REMAKE_AND_CHANGE then
        _view.needItem:SetActive(false)
        _view.chooseProps:SetActive(true)
        self:refreshChooseProps()
        ---如果选择了第二条重铸属性，显示解锁第二条所需的物品
    elseif _data.remakedFlagList[_data.selectIndex] == _data.RemakedFlag.NOT_REMAKE then
        _view.needItem:SetActive(true)
        _view.chooseProps:SetActive(false)
        self:refreshNeedItem(_data.remakedNum + 1)
    elseif _data.remakedFlagList[_data.selectIndex] == _data.RemakedFlag.REMAKED then
        _view.needItem:SetActive(true)
        _view.chooseProps:SetActive(false)
        self:refreshNeedItem(_data.equipToShow.sndAttr[_data.selectIndex].isRemake)
    end
end

---
---刷新需要的物品信息显示界面
---
function Remake:refreshNeedItem(itemIndex)
    local itemId = EquipUtil:getEquipRemakeItemID(_data.equipToShow.rarity, itemIndex)
    local itemNeedNum = EquipUtil:getEquipRemakeItemNum(_data.equipToShow.rarity, itemIndex)
    local itemHaveNum = itemModel:getItemNum(itemId)
    _view.needItem_NumLab:GetComponent("UILabel").text = itemHaveNum.."/"..itemNeedNum
    if itemHaveNum >= itemNeedNum then
        _view.needItem_NumLab:GetComponent("UILabel").color = COLOR.White
    else
        _view.needItem_NumLab:GetComponent("UILabel").color = COLOR.Red
    end
    _view.needItem_NameLab:GetComponent("UILabel").text = itemUtil:getItemName(itemId)
    _view.needItem_Icon:GetComponent("UISprite").spriteName = itemUtil:getItemIcon(itemId)
    _view.Lab_RemakeAndExchange:GetComponent("UILabel").text = stringUtil:getString(30105)

    UIEventListener.Get(_view.Btn_RemakeAndExchange).onClick = function()
        if itemHaveNum >= itemNeedNum then
            Message_Manager:SendPB_EquipRemake(_data.equipToShow.id, _data.selectIndex, self)
        else
            UIToast.Show(stringUtil:getString(30107), nil, UIToast.ShowType.Upwards)
        end
    end

end

---
---刷新属性选择界面
---
function Remake:refreshChooseProps()

    _data.chooseIndex = 1
    for i = 1, 3 do
        local attributeId = _data.equipToShow.sndAttr[_data.selectIndex].remake[i].id
        local attributeName = attributeUtil:getAttributeName(attributeId)
        local attributeVal = _data.equipToShow.sndAttr[_data.selectIndex].remake[i].val
        local attributeSymbol = attributeUtil:getAttributeSymbol(attributeId)
        local planId = _data.equipToShow["ViceAttribute".._data.selectIndex]
        local attributeValMin = attributeUtil:getAttributeMinValue(planId, attributeId)
        local attributeValMax = attributeUtil:getAttributeMaxValue(planId, attributeId)
        _view.chooseProps_PropLabs[i]:GetComponent("UILabel").text =
        string.format("%s[00ff00]+%s%s[-](%d~%d)",attributeName,attributeVal,attributeSymbol,attributeValMin,attributeValMax)
        _view.chooseProps_Max[i]:SetActive(false)
        if attributeVal == attributeValMax then
            _view.chooseProps_Max[i]:SetActive(true)
        end
    end
    local position = Vector3(_view.chooseSp.transform.localPosition.x,
    _view.chooseProps_props[_data.chooseIndex].transform.localPosition.y,
    _view.chooseSp.transform.localPosition.z)

    _view.chooseSp.transform.localPosition = position

    ---初始化替换按钮，添加监听
    _view.Lab_RemakeAndExchange:GetComponent("UILabel").text = stringUtil:getString(30106)

    UIEventListener.Get(_view.Btn_RemakeAndExchange).onClick = function()
        local selectAttributeID = _data.equipToShow.sndAttr[_data.selectIndex].id
        local chooseAttributeID = _data.equipToShow.sndAttr[_data.selectIndex].remake[_data.chooseIndex].id
        local selectAttributeIsMax = _view.normalProps_max[_data.selectIndex].activeSelf
        local chooseAttributeIsMax = _view.chooseProps_Max[_data.chooseIndex].activeSelf
        ---如果当前属性和替换属性相同且为都是最大值，弹出窗口确认替换属性
        if selectAttributeID == chooseAttributeID and selectAttributeIsMax and chooseAttributeIsMax then

            ---《《弹窗提示》》》》》》“当前属性与选择替换属性相同，确认继续替换？”《《《《《《
            confirmP:Show(stringUtil:getString(30109), function()
                Message_Manager:SendPB_RemakeExchange(_data.equipToShow.id, _data.selectIndex, _data.chooseIndex, self)
            end)
            return
        end
        Message_Manager:SendPB_RemakeExchange(_data.equipToShow.id, _data.selectIndex, _data.chooseIndex, self)
    end
end


---==============================外部调用===========================

---
---隐藏重铸界面
---
function Remake:hide()
    _view.RemakePanel:SetActive(false)
end

---
---设置重铸界面的层级
---
function Remake:setDepth(depthNum)

end

---
---设置重铸成功后的刷新方法
---
local _remakeRefreshFunc
function Remake:setRemakeRefreshFunc(func)
    _remakeRefreshFunc = func
end
---
---设置替换成功后的外部刷新方法
---
local _exchangeRefreshFunc
function Remake:setExchangeRefreshFunc(func)
    _exchangeRefreshFunc = func
end

---
---重铸成功后刷新
---
function Remake:remakeRefresh()
    if _remakeRefreshFunc then
        _remakeRefreshFunc()
    end
    _data:getProptyRemakeStatus()
    self:refreshProps()
    self:refreshRemakePanel()

end
---
---替换成功后刷新
---
function Remake:exchangeRefresh()
    if _exchangeRefreshFunc then
        _exchangeRefreshFunc()
    end
    _data:getProptyRemakeStatus()
    self:refreshProps()
    self:refreshRemakePanel()
end

return Remake
