---
--- Created by Administrator.
--- DateTime: 2017/7/14 18:15
---


local class = require("common/middleclass")
local SuitProps = class("SuitProps")


---构造函数
function SuitProps:initialize(parent,pivot)
    self.parent = parent
    self.pivot = pivot
    self.suitID = nil
    self.suitAttr_lab = {}
    self.suitAttr_actNum = {}
    self.height = 0
end

---添加控件
function SuitProps:addSuitAttrObj(index)
    if index > #self.suitAttr_lab then
        if self.pivot == Const.SUIT_PROP_PIVOT.TOP_CENTER then
            self.suitAttr_lab[index] = GameObjectExtension.InstantiateFromPacket("commonU", "suitAttr_TopCenter", self.parent).gameObject
        elseif self.pivot == Const.SUIT_PROP_PIVOT.TOP_LEFT then
            self.suitAttr_lab[index] = GameObjectExtension.InstantiateFromPacket("commonU", "suitAttr_TopLeft", self.parent).gameObject
        end

        self.suitAttr_actNum[index] =  self.suitAttr_lab[index].transform:Find("actNum").gameObject
    end
end

---初始化套装属性
function SuitProps:initSuitAttrs(suitID)
    self.SuitEffectStr = {}
    self.SuitEffectActNUm = {}
    self.suitAttrList = EquipUtil:getSuitAttrbuteList(suitID)
    for i = 1, #self.suitAttrList do
        self.SuitEffectStr[i] = self.suitAttrList[i].str
        self.SuitEffectActNUm[i] = self.suitAttrList[i].actNum
    end
end

---刷新显示
function SuitProps:Refresh(suitID)
    self.suitID= suitID
    self:initSuitAttrs(self.suitID)
    local position_Y = 0
    ---隐藏所有套装属性
    for i = 1,#self.suitAttr_lab do
        self.suitAttr_lab[i]:SetActive(false)
    end
    ---根据套装属性的数量初始化属性显示
    for i = 1, #self.SuitEffectStr do
        ---设置属性文字的显示和位置
        self:addSuitAttrObj(i)
        self.suitAttr_lab[i]:GetComponent("UILabel").text = self.SuitEffectStr[i]
        self.suitAttr_lab[i].transform.localPosition = Vector3(0, -position_Y, 0)
        local labHeight = self.suitAttr_lab[i]:GetComponent("UIWidget").height
        self.height = position_Y + labHeight
        position_Y = position_Y + labHeight + 10
        self.suitAttr_lab[i]:SetActive(true)

        ---设置重复激活的标记的显示和位置
        if self.SuitEffectActNUm[i] > 1 then
            self.suitAttr_actNum[i]:GetComponent("UILabel").text = "X"..self.SuitEffectActNUm[i]
            self.suitAttr_actNum[i].transform.localPosition =
            Vector3(
            self.suitAttr_actNum[i].transform.localPosition.x,
            -labHeight/2,
            self.suitAttr_actNum[i].transform.localPosition.z
            )
            self.suitAttr_actNum[i]:SetActive(true)
        else
            self.suitAttr_actNum[i]:SetActive(false)
        end
    end
end


function SuitProps:getHeight()
    return self.height
end
return SuitProps

