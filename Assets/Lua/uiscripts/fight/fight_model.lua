---
--- Created by Administrator.
--- DateTime: 2017/7/19 14:25
---

local class = require("common/middleclass")
fight_model = class("fight_model")

function fight_model:getDatas()
---游戏暂停控制---
    -- 是否暂停
    self.ispause = false


---卡牌数据部分---
    self.enemyPaiKutb = {}

    self.paiKutb = {}
    --当前手牌库
    self.nowHandpaiKutb = {}
    --下一张牌
    self.nextCard = nil
    --所有卡牌id表
    self.AllCardIDtb = {}
    --所有卡牌等级表
    self.AllCardLeveltb = {}
    self:initMyCards()
    self:initAllCardsTbl()



---自定义能量值---
    --总费
    self.allFei = 1000;
    --当前费
    self.nowFei = 500;
    --敌人总费
    self.enemyAllFei = 1000
    --敌人当前费
    self.enemyNowFei = 900


----临时血量
    self.MyZhuJiDi_HP = 100


    ---临时我的主基地的位置
    self.myMainPosition = Vector3(0,0,0)
    ---临时排头兵的位置
    self.firstPosition = Vector3(0,0,0)


end



---初始化剩余卡牌信息
function fight_model:initMyCards()
    local cardTbl = cardModel:getCardTbl()
    sdata_cardplanmine_data:Foreach(
        function (key, value)
            local card = {
                id = 0,
                num = 0,
                lv = 0,
                starLv = 0,
                rarity = 0,
                TrainCost = 0
            }

            if cardTbl[value[1]] then
                card.id = value[1]
                card.num = value[2]
                card.lv = cardTbl[value[1]].lv
                card.starLv = cardTbl[value[1]].star
                card.rarity = cardTbl[value[1]].rlv
                card.TrainCost = cardUtil:getTrainCost(card.id)
                table.insert(self.paiKutb, card)
            else
                Debugger.LogWarning(value[1].." 卡牌不存在！！！")
            end

        end)
    sdata_cardplanenemy_data:Foreach(
        function (key, value)
            local card = {
                id = 0,
                num = 0,
                lv = 0,
                starLv = 0,
                rarity = 0,
                TrainCost = 0
            }

            if cardTbl[value[1]] then
                card.id = value[1]
                card.num = value[2]
                card.lv = cardTbl[value[1]].lv
                card.starLv = cardTbl[value[1]].star
                card.rarity = cardTbl[value[1]].rlv
                card.TrainCost = cardUtil:getTrainCost(card.id)
                table.insert(self.enemyPaiKutb, card)
            else
                Debugger.LogWarning(value[1].." 卡牌不存在！！！")
            end

        end)





    --打乱敌人牌库
    table.upset(self.enemyPaiKutb)
    --取前4张为手牌库
    for i = 1, 4 do
        self.nowHandpaiKutb[i] = self:getNextCard()
    end

    --获取下一张牌
    self.nextCard = self:getNextCard()
end

function fight_model:refreshMyCards(cardIndex)
    --牌库第一张补充到手牌
    if self.nextCard then
        self.nowHandpaiKutb[cardIndex] = self.nextCard
    else
        self.nowHandpaiKutb[cardIndex] = nil
    end

    --获取下一张牌
    self.nextCard = self:getNextCard()
end


function fight_model:getNextCard()
    --打乱自身牌库
    table.upset(self.paiKutb)
    local nextCard
    --判断盘库是否有牌
    if #self.paiKutb >= 1 and self.paiKutb[1].num > 0 then
        nextCard = self.paiKutb[1]
        self.paiKutb[1].num = self.paiKutb[1].num - 1
        if self.paiKutb[1].num == 0 then
            table.remove(self.paiKutb, 1)
        end
        return nextCard
    else
        return nil
    end
end

---获取游戏中要用到的所有卡牌信息
function fight_model:initAllCardsTbl()
    for i = 1, #self.paiKutb do
        self.AllCardLeveltb[#self.AllCardLeveltb + 1] = i
        self.AllCardIDtb[#self.AllCardIDtb + 1] = self.paiKutb[i].id
    end
    for i = 1, #self.enemyPaiKutb do
        self.AllCardLeveltb[#self.AllCardLeveltb + 1] = i
        self.AllCardIDtb[#self.AllCardIDtb + 1] = self.enemyPaiKutb[i].id
    end
end



return fight_model