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
local ON_RIGHT = 1
local ON_LEFT = 0

function equipDetail:initialize(model)

    self.view = view()
    self.data = data()
    self.view:init()
    if model == ON_LEFT then
        self.view.btn_decomposition:SetActive(false)
        self.view.btn_commander:SetActive(false)
        self.view.btn_share:SetActive(false)
        self.view.btn_loadOrNot:SetActive(false)
        self.view.btn_plus:SetActive(false)
        self.view.btn_lock:SetActive(false)
        self.view.costSp:SetActive(false)
        self.view.bg:GetComponent("UIWidget").height = 417
        self.view.bg:AddComponent(typeof(UnityEngine.BoxCollider))
        self.view.bg:GetComponent("BoxCollider").size =Vector3(374, 417, 0)
        self.view.bg.transform.localPosition = Vector3(0, 50, 0)
    elseif model == ON_RIGHT then
        self.view.btn_decomposition:SetActive(false)
        self.view.btn_commander:SetActive(false)
        self.view.btn_share:SetActive(false)
        self.view.bg:AddComponent(typeof(UnityEngine.BoxCollider))
        self.view.bg:GetComponent("BoxCollider").size =Vector3(374, 581, 0)
    end

    ---
    ---装备信息界面的model
    ---根据model可判断当前显示的在哪一个界面
    ---model存在      装备界面
    ---model不存在     仓库界面
    ---
    self.data.model = model
    self.view.equipDetail:SetActive(false)
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
    ---
    ---设置设置父对象,初始化位置和显示层级
    ---
    if not self.view.equipDetail.transform.parent or self.view.equipDetail.transform.parent.name ~= parent.name then
        self.view.equipDetail.transform:SetParent(parent.transform)
        self.view.equipDetail.transform.localPosition = Vector3(0, 0, 0)
        self.view.equipDetail.transform.localScale = Vector3(1, 1, 1)
        self.view.equipDetail:GetComponent("UIPanel").depth = depth
    end
    ---
    ---刷新要显示的数据
    ---
    self:refresh(equip)
    self:addListener()
    ---
    ---显示装备信息界面
    ---
    self.view.equipDetail:SetActive(true)
end


---
---刷新
---
function equipDetail:refresh(equipToShow)
    local _data = self.data
    local _EquipToShow = self.data.equipToShow
    if equipToShow then
        _EquipToShow = equipToShow
    end
    if not _EquipToShow then
        return
    end
    self.data:initDatas(_EquipToShow)
    ---初始化显示
    self.view.equipNameLab.transform:GetComponent("UILabel").text = _EquipToShow.EquipName
    self.view.equipIcon:GetComponent(typeof(UISprite)).spriteName = _EquipToShow.EquipIcon
    self.view.equipFrame:GetComponent(typeof(UISprite)).spriteName = EquipUtil:getQualitySpriteStr(_EquipToShow.rarity)
    self.view.equipLV:GetComponent("UILabel").text = _EquipToShow.lv
    self.view.lab_mainAttribute:GetComponent("UILabel").text = _data.MainAttributeStr
    self.view.lab_subAttribute:GetComponent("UILabel").text = _data.SubAttributeStr
    self.view.lab_nextLevel:GetComponent("UILabel").text = _data.LevelUpOffset

    ---设置套装属性和分割线的位置。
    local subAttrHeight = self.view.lab_subAttribute:GetComponent("UILabel").height
    self.view.lab_AttrLine.transform.localPosition = self.view.lab_subAttribute.transform.localPosition - Vector3(0, subAttrHeight, 0)
    self.view.lab_suitEffect.transform.localPosition = self.view.lab_subAttribute.transform.localPosition - Vector3(0, subAttrHeight + 10, 0)
    ----刷新套装属性
    if not self._suitProp then
        self._suitProp = SuitProps(self.view.lab_suitEffect, SuitProps.SUIT_PROP_PIVOT.TOP_CENTER)
    end
    self._suitProp:Refresh(_EquipToShow.SuitID)

    ---
    ---如果不是显示已穿戴装备的信息，则初始化按钮功能
    ---
    if _data.model == ON_LEFT then
        self.view.sprite_equipped:SetActive(true)
    else
        ---
        ---根据装备是否穿戴设置，已装备提示的可见性。
        ---
        self.view.sprite_equipped:SetActive(false)
        if _data.model and _data.EquipisEquipped then
            self.view.sprite_equipped:SetActive(true)
        end
        ---
        ---初始化穿卸按钮
        ---
        self.view.lab_loadOrNot:GetComponent("UILabel").text = (_data.EquipisEquipped and {_data.str_unload} or {_data.str_load})[1]

        ---
        ---初始化强化，重铸，修理按钮
        ---
        --装备损坏则为修理功能
        if _EquipToShow.isBad == 1 then
            self.view.costSp:SetActive(true)
            self.view.costLab:SetActive(true)
            local myPower = _data.HavePower
            local fixNeedPower = _data.EquipFixCost
            self.view.costLab:GetComponent("UILabel").color = COLOR.POWER_COST
            if myPower < fixNeedPower then
                self.view.costLab:GetComponent("UILabel").color = COLOR.Red
            end
            self.view.costLab:GetComponent("UILabel").text = fixNeedPower
            self.view.lab_plus:GetComponent("UILabel").text = _data.str_repair
        else
            --等级为最高等级，重铸
            if _EquipToShow.lv == EquipUtil:getEquipmentPlusMAXLevel(_EquipToShow.rarity) then
                self.view.costSp:SetActive(false)
                self.view.costLab:SetActive(false)
                self.view.lab_plus:GetComponent("UILabel").text = _data.str_remake
                --否则为强化功能
            else
                self.view.costSp:SetActive(true)
                self.view.costLab:SetActive(true)
                --计算能量点是否足够
                local myPower = _data.HavePower
                local plusNeedPower = _data.EquipPlusCost
                self.view.costLab:GetComponent("UILabel").color = COLOR.POWER_COST
                if myPower < plusNeedPower then
                    self.view.costLab:GetComponent("UILabel").color = COLOR.Red
                end
                self.view.costLab:GetComponent("UILabel").text = plusNeedPower
                self.view.lab_plus:GetComponent("UILabel").text = _data.str_plus
            end
        end


        ---
        ---初始化装备锁定按钮
        ---
        if _EquipToShow.isLock == 0 then
            self.view.btn_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_UNLOCKED
        else
            self.view.btn_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_LOCKED
        end
    end

end


---为升级按钮添加长按监听
---长按升级按钮显示下一等级信息
function equipDetail:addListener()
    local timer
    UIEventListener.Get(self.view.btn_plus).onPress = function (btn_plus, isPress)
        if isPress then
            ---判断要显示的卡牌信息是否存在，存在则装备未损坏
            if not self.data or self.data.equipToShow.isBad == 1 then
                return
            end
            ---装备等级未达最大
            if self.data.equipToShow.lv ~= EquipUtil:getEquipmentPlusMAXLevel(self.data.equipToShow.rarity) then
                timer = TimeUtil:CreateTimer(0.5, function ()
                    self.view.spr_nextLevel:SetActive(true)
                end)
            end
        else
            self.view.spr_nextLevel:SetActive(false)
            if timer then
                timer:Kill()
            end
        end
    end
end
---
---获取数据
---
function equipDetail:get_Data()
    return self.data
end

---
---获取控件
---
function equipDetail:get_View()
    return self.view
end

---
---设置界面背景图片
---bgName   背景图片名称
---
function equipDetail:setBg(bgName)
    self.view.bg:GetComponent("UISprite").spriteName = bgName
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
    if not self.data.equipToShow then
        Debugger.LogWarning("要显示的装备不存在")
        return
    end
    ---判断重铸界面是否存在
    if not _showRemakePanelFunc then
        Debugger.LogWarning("重铸界面不存在")
        return
    end
    ---
    ---为穿卸按钮添加监听
    ---
    if not self.view.btn_loadOrNot:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self.view.btn_loadOrNot:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = Vector3(124, 48, 0)
    end
    UIEventListener.Get(self.view.btn_loadOrNot).onClick = function (go)
        local list
        if self.data.EquipisEquipped then
            list = self.data:getList_equipDrop(self.data.equipToShow)
        else
            if self.data.equipToShow.isBad == 1 then
                UIToast.Show(stringUtil:getString(30103))
                return
            end
            list = self.data:getList_equipLoad(self.data.equipToShow)
        end
        ---向服务器发送指令
        Message_Manager:SendPB_loadOrNot(list)
    end

    ---
    ---为强化，修理，重铸按钮添加监听
    ---
    if not self.view.btn_plus:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self.view.btn_plus:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = Vector3(124, 48, 0)
    end
    UIEventListener.Get(self.view.btn_plus).onClick = function (go)
        --装备损坏则为修理功能
        if self.data.equipToShow.isBad == 1 then
            local myPower = self.data.HavePower
            local fixNeedPower = self.data.EquipFixCost
            if myPower < fixNeedPower then
                --提示能量点不足
                UIToast.Show(stringUtil:getString(30108))
                return
            end
            Message_Manager:SendPB_EquipFix(self.data.equipToShow.id)
            return
        end
        --等级为最高等级，重铸
        if self.data.equipToShow.lv == EquipUtil:getEquipmentPlusMAXLevel(self.data.equipToShow.rarity) then
            _showRemakePanelFunc(_,self.data.equipToShow)
            --否则为强化功能
        else
            --计算能量点是否足够
            local myPower = self.data.HavePower
            local needPower = self.data.EquipPlusCost
            if myPower < needPower then
                --提示能量点不足
                UIToast.Show(stringUtil:getString(30108))
                return
            end
            Message_Manager:sendPB_EquipPlus(self.data.equipToShow.id)
        end
    end

    ---
    ---为锁定按钮添加监听
    ---
    if not self.view.btn_lock:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self.view.btn_lock:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = self.view.btn_lock:GetComponent(typeof(UIWidget)).localSize
    end
    UIEventListener.Get(self.view.btn_lock).onClick = function ()
        if self.data.equipToShow.isLock == 1 then
            Message_Manager:SendPB_lock(self.data.equipToShow.id, 0)
        else
            Message_Manager:SendPB_lock(self.data.equipToShow.id, 1)
        end
    end
end



---
---为装备界面中的更换按钮添加监听
---
function equipDetail:setListenerToBtnChange(func)
    if func then
        if not self.view.btn_commander:GetComponent(typeof(UnityEngine.BoxCollider)) then
            local collider = self.view.btn_commander:AddComponent(typeof(UnityEngine.BoxCollider))
            collider.size = Vector3(56, 52, 0)
        end
        UIEventListener.Get(self.view.btn_commander).onClick = function()
            if self.data.equipToShow then
                func(_, self.data.equipToShow.EquipType)
            end
        end
    end
end


---
---获取当前显示的装备
---
function equipDetail:getEquipToShow()
    if self.data.equipToShow then
        return self.data.equipToShow
    end
    return nil
end

return equipDetail