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
---
---初始化物品表
---
function itemModel:initItemTbl(items)
    for k, v in ipairs(items) do
        print( string.format("Item==> id:%d, num:%d",v.id, v.num) )
        itemTbl[k] = Item(v.id, v.num)
    end
end


---
---添加物品
---
function itemModel:addItem(items)
    local itemNum = #itemTbl    ---当前卡牌数量
    local newCardNum = 0        ---新卡牌的数量
    for _, v in ipairs(items) do
        local isHave = false    ---判断新添加的卡牌是否存在
        for _, j in ipairs(itemTbl) do
            if j.id == v.id then
                j.num = j.num + v.num
                isHave = true
                break
            end
        end
        ---不存在则创建新卡牌
        if not isHave then
            newCardNum = newCardNum + 1
            itemTbl[itemNum + newCardNum] = Item(v.id, v.num)
        end
    end
end

---
---改变某物品的属性
---
function itemModel:setItem(item)
    for _, v in ipairs(itemTbl) do
        if v.id == item.id then
            v.num = item.num
        end
    end
end

---
---获取某一件物品的数量
---
function itemModel:getItemNum(itemId)
    for _, v in ipairs(itemTbl) do
        if v.id == itemId then
            return v.num
        end
    end
    return nil
end

---
---获取本地物品数据
---
function itemModel:getItemTbl()
    return itemTbl
end