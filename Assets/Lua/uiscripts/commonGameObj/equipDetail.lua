local class = require("common/middleclass")
local equipDetail = class("equipDetail")


---
---构造函数
---model为界面的显示方式
---model = 0    已穿戴装备的信息
---model = 1    未穿戴装备的信息，但不显示分享，指挥官按钮
---model 为空    显示全部
---
function equipDetail:initialize(model)

    self.equipDetail = GameObjectExtension.InstantiateFromPacket("ui_cangku", "Panel_Detail_equipment", self.gameObject).gameObject
    self.bg = self.equipDetail.transform:Find("Detail_bg").gameObject
    self.btn_decomposition = self.equipDetail.transform:Find("Widget_DetailContainer/Button_decomposition").gameObject
    self.btn_share = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_share").gameObject
    self.btn_commander = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_commander").gameObject
    self.btn_lock = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_lock").gameObject
    self.equipIcon = self.equipDetail.transform:Find("Widget_DetailContainer/Item_icon").gameObject
    self.equipFrame = self.equipDetail.transform:Find("Widget_DetailContainer/Item_icon/Item_Frame").gameObject
    self.equipNameLab = self.equipDetail.transform:Find("Widget_DetailContainer/Item_name/Label_name").gameObject
    self.equipLV = self.equipDetail.transform:Find("Widget_DetailContainer/Item_icon/Item_Level/Label_Level").gameObject
    self.btn_share = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_share").gameObject
    self.btn_loadOrNot = self.equipDetail.transform:Find("Widget_DetailContainer/Button_load-unload").gameObject
    self.lab_loadOrNot = self.btn_loadOrNot.transform:Find("Label_unload").gameObject
    self.sprite_equipped = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_equipped").gameObject

    self.lab_mainAttribute = self.equipDetail.transform:Find("Widget_DetailContainer/Label_MainAttribute").gameObject
    self.lab_subAttribute = self.equipDetail.transform:Find("Widget_DetailContainer/Label_ViceAttribute").gameObject
    self.lab_suitEffect = self.equipDetail.transform:Find("Widget_DetailContainer/Label_SuitEffect").gameObject

    self.lab_nextLevel = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_nextLevel/Label_nextLevel").gameObject
    self.costSp = self.equipDetail.transform:Find("Widget_DetailContainer/Sprite_plus_cost").gameObject
    self.costLab = self.costSp.transform:Find("Label_plus_cost").gameObject
    self.btn_plus = self.equipDetail.transform:Find("Widget_DetailContainer/Button_plus").gameObject
    self.lab_plus = self.btn_plus.transform:Find("Label_plus").gameObject

    if model == 0 then
        self.btn_decomposition:SetActive(false)
        self.btn_commander:SetActive(false)
        self.btn_share:SetActive(false)
        self.btn_loadOrNot:SetActive(false)
        self.btn_plus:SetActive(false)
        self.btn_lock:SetActive(false)
        self.costSp:SetActive(false)
        self.bg:GetComponent("UIWidget").height = 417
        self.bg:AddComponent(typeof(UnityEngine.BoxCollider))
        self.bg:GetComponent("BoxCollider").size =Vector3(374, 417, 0)
        self.bg.transform.localPosition = Vector3(0, 50, 0)
    elseif model == 1 then
        self.btn_decomposition:SetActive(false)
        self.btn_commander:SetActive(false)
        self.btn_share:SetActive(false)
        self.bg:AddComponent(typeof(UnityEngine.BoxCollider))
        self.bg:GetComponent("BoxCollider").size =Vector3(374, 581, 0)
    end



    ---
    ---装备信息界面的model
    ---根据model可判断当前显示的在哪一个界面
    ---model存在      装备界面
    ---model不存在     仓库界面
    ---
    self.model = model
    self.equipToShow = nil
    self.equipDetail:SetActive(false)
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
    self.equipToShow = equip
    ---
    ---设置设置父对象,初始化位置和显示层级
    ---
    if not self.equipDetail.transform.parent or self.equipDetail.transform.parent.name ~= parent.name then
        self.equipDetail.transform:SetParent(parent.transform)
        self.equipDetail.transform.localPosition = Vector3(0, 0, 0)
        self.equipDetail.transform.localScale = Vector3(1, 1, 1)
        self.equipDetail:GetComponent("UIPanel").depth = depth
    end

    ---
    ---刷新要显示的数据
    ---
    self:refresh()

    ---
    ---显示装备信息界面
    ---
    self.equipDetail:SetActive(true)
end


function equipDetail:refresh()
    if not self.equipToShow then
        return
    end
    local equip = self.equipToShow
    ---
    ---获取要显示的字符串
    ---
    local _EquipName = equip["EquipName"]
    local _EquipIcon = equip["EquipIcon"]
    local _EquipFrame = EquipUtil:getQualitySpriteStr(equip.rarity)
    local _EquipLV = equip.lv
    local _EquipisBad = (equip.isBad == 0 and {false} or {true})[1]
    local _MainAttributeStr = EquipUtil:getEquipmentMainAttributeStr(equip["EquipID"],equip.fst_attr,equip.lv)
    local _SubAttributeStr = EquipUtil:getEquipmentSubAttributeStr(equip)
    local _SuitEffectStr = EquipUtil:getEquipmentSuitEffectStr(equip["SuitID"])
    self._EquipPlusCost = EquipUtil:getEquipmentPlusCost(equip.lv,equip.rarity)
    local _LevelUpOffset = EquipUtil:getEquipmentLevelUpOffsetStr(equip)


    ---
    ---刷新界面显示
    ---

    local _str_load = sdata_UILiteral.mData.body[0xFE11][sdata_UILiteral.mFieldName2Index["Literal"]]
    local _str_unload = sdata_UILiteral.mData.body[0xFE12][sdata_UILiteral.mFieldName2Index["Literal"]]
    local _str_repair = sdata_UILiteral.mData.body[0xFE16][sdata_UILiteral.mFieldName2Index["Literal"]]
    local _str_plus = sdata_UILiteral.mData.body[0xFE17][sdata_UILiteral.mFieldName2Index["Literal"]]
    local _str_remake = sdata_UILiteral.mData.body[0xFE18][sdata_UILiteral.mFieldName2Index["Literal"]]

    self.equipNameLab.transform:GetComponent("UILabel").text = _EquipName
    self.equipIcon:GetComponent(typeof(UISprite)).spriteName = _EquipIcon
    self.equipFrame:GetComponent(typeof(UISprite)).spriteName = _EquipFrame
    self.equipLV:GetComponent("UILabel").text = _EquipLV
    self.lab_mainAttribute:GetComponent("UILabel").text = _MainAttributeStr
    self.lab_subAttribute:GetComponent("UILabel").text = _SubAttributeStr
    self.lab_suitEffect:GetComponent("UILabel").text = _SuitEffectStr
    self.lab_nextLevel:GetComponent("UILabel").text = _LevelUpOffset

    ---
    ---如果不是显示已穿戴装备的信息，则初始化按钮功能
    ---
    if self.model == 0 then
        self.sprite_equipped:SetActive(true)
    else
        ---
        ---根据装备是否穿戴设置，已装备提示的可见性。
        ---
        self.sprite_equipped:SetActive(false)
        if self.model and equip.equipped then
            self.sprite_equipped:SetActive(true)
        end
        ---
        ---初始化穿卸按钮
        ---
        self.lab_loadOrNot:GetComponent("UILabel").text = (equip.equipped and {_str_unload} or {_str_load})[1]

        ---
        ---初始化强化，重铸，修理按钮
        ---
        self.costLab:GetComponent("UILabel").text = self._EquipPlusCost
        self.lab_plus:GetComponent("UILabel").text =
        (_EquipisBad == true and {_str_repair} or {(equip.lv == EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) and {_str_remake} or {_str_plus})[1]})[1]
        if equip.lv == EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) then
            self.costSp:SetActive(false)
            self.costLab:SetActive(false)
        else
            self.costSp:SetActive(true)
            self.costLab:SetActive(true)
        end

        ---
        ---初始化装备锁定按钮
        ---
        local Lock -- 装备是否锁定
        if equip.isLock == 0 then
            Lock = 1
            self.btn_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_UNLOCKED
        else
            Lock = 0
            self.btn_lock:GetComponent(typeof(UISprite)).spriteName = cstr.EQUIPMENT_LOCKED
        end


    end

end


---
---设置界面背景图片
---bgName   背景图片名称
---
function equipDetail:setBg(bgName)
    self.bg:GetComponent("UISprite").spriteName = bgName
end

---========================================================装备界面专用=====================================
---
---外部调用
---如果当前在装备界面为按钮添加监听
---
function equipDetail:setListener()

    if not self.equipToShow then
        return
    end
    local equip = self.equipToShow
    if not self.btn_loadOrNot:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self.btn_loadOrNot:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = Vector3(124, 48, 0)
    end
    UIEventListener.Get(self.btn_loadOrNot).onClick = function (go)
        if equip.equipped then
            for i = #EquipModel.serv_fitEquipmentList,1,-1 do
                if EquipModel.serv_fitEquipmentList[i] == equip.id then
                    table.remove(EquipModel.serv_fitEquipmentList,i)
                    break
                end
            end
            ---向服务器发送指令
            Message_Manager:SendPB_loadOrNot(EquipModel.serv_fitEquipmentList)
        else
            if equip.isBad == 1 then
                UIToast.Show(stringUtil:getString(30103), nil, UIToast.ShowType.Upwards)
                return
            end
            for i = #EquipModel.serv_fitEquipmentList,1,-1 do
                if EquipModel:getLocalEquipmentTypeByServID(EquipModel.serv_fitEquipmentList[i]) == equip.EquipType then
                    EquipModel.serv_fitEquipmentList[i] = equip.id
                    Message_Manager:SendPB_loadOrNot(EquipModel.serv_fitEquipmentList)
                    return
                end
            end
            table.insert(EquipModel.serv_fitEquipmentList,equip.id)
            ---向服务器发送指令
            Message_Manager:SendPB_loadOrNot(EquipModel.serv_fitEquipmentList)
        end

    end

    if not self.btn_plus:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self.btn_plus:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = Vector3(124, 48, 0)
    end
    UIEventListener.Get(self.btn_plus).onClick = function (go)
        if equip.isBad == 1 then
            print("修理")
            -- TODO: 装备界面：当装备损坏时的处理
            --[[                装备修理消耗能量点规则待补充]]
            --[[                local myPower = currencyModel:getCurrentTbl().power
                            local needPower = self._EquipPlusCost
                            print(myPower, needPower)
                            if myPower < needPower then
                                tips:show("能量点不足")
                                return
                            end]]
            Message_Manager:SendPB_EquipFix(equip.id)

        else
            if equip.lv == EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) then
                print("重铸")
                --    Message_Manager:SendPB_loadOrNot(EquipModel.serv_fitEquipmentList)
            else
                print("强化")
                local myPower = currencyModel:getCurrentTbl().power
                local needPower = self._EquipPlusCost
                print(myPower, needPower)
                if myPower < needPower then
                    tips:show("能量点不足")
                    return
                end
                Message_Manager:sendPB_EquipPlus(equip.id)
            end
        end
    end

    if not self.btn_lock:GetComponent(typeof(UnityEngine.BoxCollider)) then
        local collider = self.btn_lock:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.size = self.btn_lock:GetComponent(typeof(UIWidget)).localSize
    end
    UIEventListener.Get(self.btn_lock).onClick = function (go)
        print("lock")
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
        if not self.btn_commander:GetComponent(typeof(UnityEngine.BoxCollider)) then
            local collider = self.btn_commander:AddComponent(typeof(UnityEngine.BoxCollider))
            collider.size = Vector3(56, 52, 0)
        end
        UIEventListener.Get(self.btn_commander).onClick = function()
            if self.equipToShow then
                func(_, self.equipToShow.EquipType)
            end
        end
    end
end


---
---获取当前显示的装备
---
function equipDetail:getEquipToShow()
    if self.equipToShow then
        return self.equipToShow
    end
    return nil
end

return equipDetail