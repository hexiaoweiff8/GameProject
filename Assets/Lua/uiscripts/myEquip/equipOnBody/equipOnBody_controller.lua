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
local selectEquipIndex = 1

function equipOnBody_controller:init(equipController)
    view:init_view(equipController)
    self:addListener()
end

---
---显示穿戴的装备
---
function equipOnBody_controller:showEquipsOnBody()
    for i = 1, 8 do
        self:refresh(i)
    end
end

---
---为装备界面的各个对象添加监听
---
function equipOnBody_controller:addListener()
    ---为穿在身上的装备按钮添加监听
    for i = 1, 8 do
        UIEventListener.Get(view.equipItems[i]).onClick = function()
            equip_controller:showRightPanel(i)
            view.selectBox.transform:SetParent(view.equipItems[i].transform)
            view.selectBox.transform.localPosition = Vector3(0, 0, 0)
            selectEquipIndex = i
        end
    end
end

---
---刷新某个穿戴的装备
---
function equipOnBody_controller:refresh(index)
    if not index then
        index = selectEquipIndex
    end
    if data.equipOnBodyList[index] ~= -1 then
        view.equipIcon[index]:SetActive(true)
        view.equipLevel[index]:SetActive(true)
        view.addSpr[index]:SetActive(false)
        view.background[index]:SetActive(false)
        view.equipItems[index].transform:GetComponent("UISprite").color = COLOR["EQUIPRARITY_"..data:getEquipByOnlyID(data.equipOnBodyList[index]).rarity]
        view.equipIcon[index].transform:GetComponent("UISprite").spriteName = "iconName"
        view.equipLevel[index].transform:GetComponent("UILabel").text = "+"..data:getEquipByOnlyID(data.equipOnBodyList[index]).lv
    else
        view.equipIcon[index]:SetActive(false)
        view.equipLevel[index]:SetActive(false)
        view.addSpr[index]:SetActive(true)
        view.background[index]:SetActive(true)
        view.equipItems[index].transform:GetComponent("UISprite").color = COLOR.White
    end
end
---
---刷新全部装备
---
function equipOnBody_controller:refreshAll()
    equipOnBody_controller:showEquipsOnBody()
end
---
---外部获取当前选择的装备类型
---
function equipOnBody_controller:getCurrentSelectEquipType()
    return selectEquipIndex
end

return equipOnBody_controller