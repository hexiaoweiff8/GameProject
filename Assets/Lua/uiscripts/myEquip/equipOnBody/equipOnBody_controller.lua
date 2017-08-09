---
--- Created by Administrator.
--- DateTime: 2017/6/30 17:37
---
local equipOnBody_controller = {}
local view = require("uiscripts/myEquip/equipOnBody/equipOnBody_view")
local data = require("uiscripts/myEquip/equipOnBody/equipOnBody_model")

---
---正选中的已穿戴装备的index，默认为第一个装备 1
---
local _selectEquipType = 1
local _equipsToShow = {}
function equipOnBody_controller:init(equipController)
    view:init_view(equipController)

    ---
    ---设置一键装备和一键修理按钮的显示文字
    ---
    view.btn_equipOnce.transform:Find("lab1"):GetComponent(typeof(UILabel)).text = stringUtil:getString(10013)
    view.btn_equipOnce.transform:Find("lab2"):GetComponent(typeof(UILabel)).text = stringUtil:getString(10014)
    view.btn_fixOnce.transform:Find("lab1"):GetComponent(typeof(UILabel)).text = stringUtil:getString(10013)
    view.btn_fixOnce.transform:Find("lab2"):GetComponent(typeof(UILabel)).text = stringUtil:getString(10015)

    self:addListener()
end

---
---显示穿戴的装备
---
function equipOnBody_controller:showEquipsOnBody()
    for i = 1, Const.EQUIP_TYPE_NUM do
        ---
        ---保存装备的ID到本地
        ---
        _equipsToShow[i] = data.equipOnBodyList[i]
        ---
        ---刷新显示
        ---
        self:refreshEquipItemByType(i)
    end
    self:refreshOnceFixNeedPower()
end

---
---为装备界面的各个对象添加监听
---
function equipOnBody_controller:addListener()
    UIEventListener.Get(view.btn_equipOnce).onClick = function()
        local bestEquips = data:getBestEquipIDList()
        if not data:isCanEquipOnce() then
            UIToast.Show(stringUtil:getString(30101))
            return
        end
        Message_Manager:SendPB_loadBest(bestEquips)
    end

    UIEventListener.Get(view.btn_fixOnce).onClick = function()
        local fixEquips = data:getBadEquipList()

        if #fixEquips == 0 then
            ---无可修理的装备
            UIToast.Show(stringUtil:getString(30102))
            return
        end

        if not data:isCanFixOnce(fixEquips) then
            ---能量点不足
            UIToast.Show(stringUtil:getString(30108))
            return
        end

        Message_Manager:SendPB_EquipFixAll(fixEquips)

    end
    ---为穿在身上的装备按钮添加监听
    for i = 1, Const.EQUIP_TYPE_NUM do
        UIEventListener.Get(view.equipItems[i]).onClick = function()
            equip_controller:showRightPanel(i)
            view.selectBox.transform:SetParent(view.equipItems[i].transform)
            view.selectBox.transform.localPosition = Vector3(0, 0, 0)
            _selectEquipType = i
        end
    end
end


---
---当穿戴的装备发生变化时刷新
---
function equipOnBody_controller:equipChangeRefresh()
    for equipType = 1, Const.EQUIP_TYPE_NUM do
        if  _equipsToShow[equipType] ~= data.equipOnBodyList[equipType] then
            _equipsToShow[equipType] = data.equipOnBodyList[equipType]
            self:refreshEquipItemByType(equipType)
        end
    end
    self:refreshOnceFixNeedPower()

end
---
---穿戴装备无变化，装备信息发生变化时刷新
---刷新某一个
---
function equipOnBody_controller:refresh(equipType)
    if not equipType then
        Debugger.LogWarning("equipOnBody refresh error!!!")
    end
    self:refreshEquipItemByType(equipType)
    self:refreshOnceFixNeedPower()
end
---
---刷新全部
---
function equipOnBody_controller:refreshAll()
    self:showEquipsOnBody()
end
---
---刷新某个穿戴的装备
---
function equipOnBody_controller:refreshEquipItemByType(equipType)
    if not equipType then
        return
    end
    ---
    ---获取装备信息，更新显示
    ---
    local equip = data:getEquipByOnlyID(data.equipOnBodyList[equipType])
    if data.equipOnBodyList[equipType] ~= -1 then
        view.equipIcon[equipType]:SetActive(true)
        view.equipLevel[equipType]:SetActive(true)
        view.addSpr[equipType]:SetActive(false)
        ---判断是否锁定，设置显示信息
        if equip.isLock == 1 then
            view.lockSpr[equipType]:SetActive(true)
        else
            view.lockSpr[equipType]:SetActive(false)
        end
        view.background[equipType]:SetActive(false)
        view.equipItems[equipType].transform:GetComponent("UISprite").spriteName = spriteNameUtil["_EQUIPRARITY_"..equip.rarity]
        view.equipIcon[equipType].transform:GetComponent("UISprite").spriteName = spriteNameUtil._ICON
        view.equipLevel[equipType].transform:GetComponent("UILabel").text = "+"..equip.lv
        if equip.isBad == 1 then
            view.equipIcon[equipType].transform:GetComponent("UISprite").spriteName = spriteNameUtil._RED
        end
    else
        view.equipIcon[equipType]:SetActive(false)
        view.equipLevel[equipType]:SetActive(false)
        if #data.equipListByType[equipType] == 0 then
            view.addSpr[equipType]:SetActive(false)
        else
            view.addSpr[equipType]:SetActive(true)
        end
        view.lockSpr[equipType]:SetActive(false)
        view.background[equipType]:SetActive(true)
        view.equipItems[equipType].transform:GetComponent("UISprite").spriteName = spriteNameUtil["_EQUIPRARITY_"..1]
    end
end

---
---刷新一键修理所需的能量点的显示
---
function equipOnBody_controller:refreshOnceFixNeedPower()
    local badEquipList = data:getBadEquipList()
    if #badEquipList == 0 then
        view.onceFixCost_lab:SetActive(false)
        return
    end
    view.onceFixCost_lab:SetActive(true)
    local needPower = data:getFixOnceNeedPower(badEquipList)
    view.onceFixCost_lab:GetComponent("UILabel").text = needPower
    view.onceFixCost_lab:GetComponent("UILabel").color = COLOR.POWER_COST
    if needPower > data.myPower then
        view.onceFixCost_lab:GetComponent("UILabel").color = COLOR.Red
    end
end


---
---外部获取当前选择的装备类型
---
function equipOnBody_controller:getCurrentSelectEquipType()
    return _selectEquipType
end

return equipOnBody_controller
