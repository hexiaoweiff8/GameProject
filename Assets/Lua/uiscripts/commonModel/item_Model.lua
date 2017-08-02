---
--- Created by Administrator.
--- DateTime: 2017/7/13 12:24
---

local class = require("common/middleclass")

local Item = class("Item")
--id,经验,星级,兵员等级,军阶等级,卡牌数量,插槽状态表,技能表,协同表，卡牌等级
function Item:initialize(id,num)
    self.id = id
    self.num = num
end


itemModel = {}
local itemTbl = {}
local itemTbl_Length = 0
---
---初始化物品表
---
function itemModel:initItemTbl(items)
    itemTbl_Length = 0
    for _, v in ipairs(items) do
        print( string.format("Item==> id:%d, num:%d",v.id, v.num) )
        itemTbl_Length = itemTbl_Length + 1
        itemTbl[v.id] = Item(v.id, v.num)
    end
end

---
---添加多个物品
---
function cardModel:addItems(items)
    for _, v in ipairs(items) do
        self:addItem(v)
    end
end
---
---添加一个物品
---
function cardModel:addItem(item)
    if itemTbl[item.id] then
        itemTbl[item.id].num = itemTbl[item.id].num + item.num
    else
        itemTbl_Length = itemTbl_Length + 1
        itemTbl[item.id] = Item(item.id, item.num)
    end
end

---
---改变物品的属性
---
function itemModel:setItems(items)
    for _, v in ipairs(items) do
        if itemTbl[v.id] then
            itemTbl[v.id].num = v.num
        else
            Debugger.LogWarning("要修改信息物品不存在！！！！")
        end
    end
end

---
---获取某一件物品的数量
---
function itemModel:getItemNum(itemId)
    if itemTbl[itemId] then
        return itemTbl[itemId].num
    else
        return 0
    end
end

---
---获取本地物品数据
---
function itemModel:getItemTbl()
    return itemTbl
end

---
---获取物品表的长度
---
function itemModel:getItemTblLength()
    return itemTbl_Length
end