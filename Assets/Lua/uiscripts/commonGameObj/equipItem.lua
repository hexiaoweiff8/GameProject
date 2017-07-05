---
--- Created by Administrator.
--- DateTime: 2017/6/23 11:38
---
local class = require("common/middleclass")
EquipItem = class("EquipItem")


---
---构造函数
---parent       父节点
---position     相对于父节点的位置
---
function EquipItem:initialize(parent, equip, position)


    ---
    ---获取控件
    ---
    if not parent then
        return
    end
    self.equipitem = GameObjectExtension.InstantiateFromPacket("ui_equip", "eqBg", parent).gameObject
    self.icon = self.equipitem.transform:Find("eqSpr").gameObject
    self.levelLab = self.equipitem.transform:Find("level").gameObject

    ---
    ---用于保存装备对象的变量（默认装备）
    ---
    if equip then
        self.equipToShow = equip
    end

    ---
    ---设置显示位置
    ---
    if position then
        sql.equipitem.transform.localPosition = position
    end
end


---
---刷新装备item的显示状态
---equip    要显示的装备对象（为空时显示默认的装备）
---
function EquipItem:refresh()
    ---
    ---设置要显示的装备
    ---
    if not self.equipToShow then
        return
    end
    ---
    ---根据要显示的装备设置信息
    ---
    if self.equipToShow then
        self.levelLab.transform:GetComponent("UILabel").text ="lv"..self.equipToShow.lv
        self.equipitem:GetComponent("UISprite").color = COLOR["EQUIPRARITY_"..self.equipToShow.rarity]
        if self.equipToShow.equipped then
            self.icon:GetComponent("UISprite").color = COLOR.Red
        else
            self.icon:GetComponent("UISprite").color = COLOR.Black
        end
    end

end

---
---为装备item添加监听
---callback     点击item后的回调方法
---
function EquipItem:SetListener(callback)
    if callback and self.equipToShow then
        UIEventListener.Get(self.equipitem).onClick = function()
            callback(self.equipToShow,self)
        end
    end
end
---
---获取当前显示的装备
---
function EquipItem:getEquipToShow()
    if self.equipToShow then
        return self.equipToShow
    end
    return nil
end
