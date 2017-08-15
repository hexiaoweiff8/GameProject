---
--- Created by Administrator.
--- DateTime: 2017/7/19 17:49
---
local class = require("common/middleclass")
local restCard_model = class("restCard_model",fight_model)


---计算剩余兵力值
function restCard_model:getRestTrainCost()
    --剩余兵力值
    local sumLastBingLi = 0
    for i = 1, #self.paiKutb do
        sumLastBingLi = sumLastBingLi + self.paiKutb[i].TrainCost * self.paiKutb[i].num
    end
    return sumLastBingLi
end

---牌库排序 => 剩余卡牌数量（由多至少）→卡牌费数（由多至少）→卡牌ID（由低至高）
function restCard_model:sortLeftCard(cardList)
    local sortList = {}
    table.merge(sortList, cardList)
    table.sort(sortList, function(ta, tb)
        if ta.num == tb.num then
            if ta.TrainCost == tb.TrainCost then
                return ta.id < tb.id
            else
                return ta.TrainCost > tb.TrainCost
            end
        else
            return ta.num > tb.num
        end
    end)
    return sortList
end


return restCard_model
