local class = require("common/middleclass")
local equipDetail = class("equipDetail")
require('uiscripts/shop/timeUtil/TimeUtil')
local view = require("uiscripts/commonGameObj/equipDetail/equipDetail_view")
local data = require("uiscripts/commonGameObj/equipDetail/equipDetail_model")
local SuitProps = require("uiscripts/commonGameObj/suitProps")
---
---构造函数
---model为界面的显示方式
---model = 0    已穿戴装备的信息
---model = 1    未穿戴装备的信息，但不显示分享，指挥官按钮
---model 为空    显示全部
---
equipDetail.MODEL = {
    EQUIP_RIGHT_PANEL = 2,
    EQUIP_ONLIST_RIGHT = 1,
    EQUIP_ONLIST_LEFT = 0

}


function equipDetail:initialize(model)

    self._view = view()
    self._data = data()
    self._view:init()
    if model == self.MODEL.EQUIP_ONLIST_LEFT then
        self._view.btn_decomposition:SetActive(false)
        self._view.btn_commander:SetActive(false)
        self._view.btn_share:SetActive(false)
        self._view.btn_loadOrNot:SetActive(false)
        self._view.btn_plus:SetActive(false)
        self._view.btn_lock:SetActive(false)
        self._view.costSp:SetActive(false)
        self._view.bg:GetComponent("UIWidget").height = 417
        self._view.bg:AddComponent(typeof(UnityEngine.BoxCollider))
        self._view.bg:GetComponent("BoxCollider").size =Vector3(374, 417, 0)
        self._view.bg.transform.localPosition = Vector3(0, 50, 0)
    elseif model == self.MODEL.EQUIP_ONLIST_RIGHT then
        self._view.btn_decomposition:SetActive(false)
        self._view.btn_commander:SetActive(false)
        self._view.btn_share:SetActive(false)
        self._view.bg:AddComponent(typeof(UnityEngine.BoxCollider))
        self._view.bg:GetComponent("BoxCollider").size =Vector3(374, 581, 0)
    end

    ---
    ---装备信息界面的model
    ---根据model可判断当前显示的在哪一个界面
    ---model存在      装备界面
    ---model不存在     仓库界面
    ---
    self._data.model = model
    self._data.equipToShow = nil
    self._view.equipDetail:SetActive(false)
end


function equipDetail:addListener()
    local timer
    UIEventListener.Get(self._view.btn_plus).onPress = function (btn_plus, isPress)
        if isPress then
            if self._data.equipToShow.isBad == 1 then
                return
            end
            if self._data.equipToShow.lv ~= EquipUtil:getEquipmentPlusMAXLevel(self._data.equipToShow.rarity) then
                timer = TimeUtil:CreateTimer(0.5, function ()
                    self._view.spr_nextLevel:SetActive(true)
                end)
            end
        else
            self._view.spr_nextLevel:SetActive(false)
            if timer then
                timer:Kill()
            end
        end
    end
end


---
---显示装备信息，设置父物体
---equip    要显示的装备
---parent   父物体
---depth    设置显示层级
---
function equipDetail:showEquip(equip, parent, depth)
    if not equip or not parent then
        return
    end
    self._data.equipToShow = equip
    ---
    ---设置设置父对象,初始化位置和显示层级
    ---
    if not self._view.equipDetail.transform.parent or self._view.equipDetail.transform.parent.name ~= parent.name then
        self._view.equipDetail.transform:SetParent(parent.transform)
        self._view.equipDetail.transform.localPosition = Vector3(0, 0, 0)
        self._view.equipDetail.transform.localScale = Vector3(1, 1, 1)
        self._view.equipDetail:GetComponent("UIPanel").depth = depth
    end
    ---
    ---刷新要显示的数据
    ---
    self:refresh()
    self:addListener()
    ---
    ---显示装备信息界面
    ---
    self._view.equipDetail:SetActive(true)
end


---
---刷新
---
function equipDetail:refresh(equipToShow)
    if equipToShow then
        self._data.equipToShow = equipToShow
    end
    if not self._data.equipToShow then
        return
    end
    local equip = self._data.equipToShow

    ---获取要显示的数据
    self._data:getDatas(equip)
    ---初始化显示
    self._view.equipNameLab.transform:GetComponent("UILabel").text = self._data.EquipName
    self._view.equipIcon:GetComponent(typeof(UISprite)).spriteName = self._data.EquipIcon
    self._view.equipFrame:GetComponent(typeof(UISprite)).spriteName = self._data.EquipFrame
    self._view.equipLV:GetComponent("UILabel").text = self._data.EquipLV
    self._view.lab_mainAttribute:GetComponent("UILabel").text = self._data.MainAttributeStr
    self._view.lab_subAttribute:GetComponent("UILabel").text = self._data.SubAttributeStr
    self._view.lab_nextLevel:GetComponent("UILabel").text = self._data.LevelUpOffset

    if not self._suitProp then
        self._suitProp = SuitProps(self._view.lab_suitEffect, SuitProps.SUIT_PROP_PIVOT.TOP_CENTER)
    end
    self._suitProp:Refresh(equip["SuitID"])

    ---
    ---如果不是显示已穿戴装备的信息，则初始化按钮功能
    ---
    if self._data.model == self.MODEL.EQUIP_ONLIST_LEFT then
        self._view.sprite_equipped:SetActive(true)
    else
        ---
        ---根据装备是否穿戴设置，已装备提示的可见性。
        ---
        self._view.sprite_equipped:SetActive(false)
        if self._data.model and equip.equipped then
            self._view.sprite_equipped:SetActive(true)
        end
        ---
        ---初始化穿卸按钮
        ---
        self._view.lab_loadOrNot:GetComponent("UILabel").text = (equip.equipped and {self._data.str_unload} or {self._data.str_load})[1]

        ---
        ---初始化强化，重铸，修理按钮
        ---
        --装备损坏则为修理功能
        if equip.isBad == 1 then
            self._view.costSp:SetActive(true)
            self._view.costLab:SetActive(true)
            local myPower = self._data.HavePower
            local fixNeedPower = self._data.EquipFixCost
            self._view.costLab:GetComponent("UILabel").color = COLOR.POWER_COST
            if myPower < fixNeedPower then
                self._view.costLab:GetComponent("UILabel").color = COLOR.Red
            end
            self._view.costLab:GetComponent("UILabel").text = fixNeedPower
            self._view.lab_plus:GetComponent("UILabel").text = self._data.str_repair
        else
            --等级为最高等级，重铸
            if equip.lv == EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) then
                self._view.costSp:SetActive(false)
                self._view.costLab:SetActive(false)
                self._view.lab_plus:GetComponent("UILabel").text = self._data.str_remake
                --否则为强化功能
            else
                self._view.costSp:SetActive(true)
                self._view.costLab:SetActive(true)
                --计算能量点是否足够
                local myPower = self._data.HavePower
                local plusNeedPower = self._data.EquipPlusCost
                self._view.costLab:GetComponent("UILabel").color = COLOR.POWER_COST
                if myPower < plusNeedPower then
                    self._view.costLab:GetComponent("UILabel").color = COLOR.Red
                end
                self._view.costLab:GetComponent("UILabel").text = plusNeedPower
                self._view.lab_plus:GetComponent("UILabel").text = self._data.str_plus
            end
        end


        ---
        ---初始化装备锁定按钮
        ---
        local Lock ---装备是否锁定
    if equip.isLock == 0 then
        Lock = 1
        self._view.btn_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_UNLOCKED
    else
        Lock = 0
        self._view.btn_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_LOCKED
    end


    end

end
---
---获取数据
---
function equipDetail:get_Data()
    return self._data
end

---
---获取控件
---
function equipDetail:get_View()
    return self._view
end

---
---设置界面背景图片
---bgName   背景图片名称
---
function equipDetail:setBg(bgName)
    self._view.bg:GetComponent("UISprite").spriteName = bgName
end

---========================================================装备界面专用=====================================
---
local _showRemakePanelFunc
function equipDetail:setShowRemakePanelFunc(showRemakePanelFunc)
    _showRemakePanelFunc = showRemakePanelFunc
end
---
---外部调用
---如果当前在装备界面为按钮添加监听
---
function equipDetail:setListener()

    ---判断要显示的装备是否存在
    if not self._data.equipToShow then
        Debugger.LogWarning("要显示的装备不存在")
        return
    end
    ---判断重铸界面是否存在
    if not _showRemakePanelFunc then
        Debugger.LogWarning("重铸界面不存在")
        return
    end
    ---设置要显示的装备
    local equip = self._data.equipToShow

    ---
    ---为穿卸按钮添加监听
    ---
    if not self._view.btn_loadOrNot:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self._view.btn_loadOrNot:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = Vector3(124, 48, 0)
    end
    UIEventListener.Get(self._view.btn_loadOrNot).onClick = function (go)
        local list
        if equip.equipped then
            list = self._data:getList_equipDrop(equip)
        else
            if equip.isBad == 1 then
                UIToast.Show(stringUtil:getString(30103), nil, UIToast.ShowType.Upwards)
                return
            end
            list = self._data:getList_equipLoad(equip)
        end
        ---向服务器发送指令
        Message_Manager:SendPB_loadOrNot(list)
    end

    ---
    ---为强化，修理，重铸按钮添加监听
    ---
    if not self._view.btn_plus:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self._view.btn_plus:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = Vector3(124, 48, 0)
    end
    UIEventListener.Get(self._view.btn_plus).onClick = function (go)
        --装备损坏则为修理功能
        if equip.isBad == 1 then
            local myPower = self._data.HavePower
            local fixNeedPower = self._data.EquipFixCost
            if myPower < fixNeedPower then
                --提示能量点不足
                UIToast.Show(stringUtil:getString(30108), nil, UIToast.ShowType.Upwards)
                return
            end
            Message_Manager:SendPB_EquipFix(equip.id)
            return
        end
        --等级为最高等级，重铸
        if equip.lv == EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) then
            _showRemakePanelFunc(_,equip)
            --否则为强化功能
        else
            --计算能量点是否足够
            local myPower = self._data.HavePower
            local needPower = self._data.EquipPlusCost
            if myPower < needPower then
                --提示能量点不足
                UIToast.Show(stringUtil:getString(30108), nil, UIToast.ShowType.Upwards)
                return
            end
            Message_Manager:sendPB_EquipPlus(equip.id)
        end
    end

    ---
    ---为锁定按钮添加监听
    ---
    if not self._view.btn_lock:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self._view.btn_lock:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = self._view.btn_lock:GetComponent(typeof(UIWidget)).localSize
    end
    UIEventListener.Get(self._view.btn_lock).onClick = function ()
        if equip.isLock == 1 then
            Message_Manager:SendPB_lock(equip.id, 0)
        else
            Message_Manager:SendPB_lock(equip.id, 1)
        end
    end
end



---
---为装备界面中的更换按钮添加监听
---
function equipDetail:setListenerToBtnChange(func)
    if func then
        if not self._view.btn_commander:GetComponent(typeof(UnityEngine.BoxCollider)) then
            local collider = self._view.btn_commander:AddComponent(typeof(UnityEngine.BoxCollider))
            collider.size = Vector3(56, 52, 0)
        end
        UIEventListener.Get(self._view.btn_commander).onClick = function()
            if self._data.equipToShow then
                func(_, self._data.equipToShow.EquipType)
            end
        end
    end
end


---
---获取当前显示的装备
---
function equipDetail:getEquipToShow()
    if self._data.equipToShow then
        return self._data.equipToShow
    end
    return nil
end

return equipDetail