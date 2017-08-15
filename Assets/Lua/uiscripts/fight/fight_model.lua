---
--- Created by Administrator.
--- DateTime: 2017/7/19 14:25
---

local class = require("common/middleclass")

fight_model = class("fight_model")
local bianduiModel = require("uiscripts/biandui/wnd_biandui_model")


function fight_model:getDatas()


    ----临时变量---
    self.MyZhuJiDi_HP = 100

    self.enemyCardNum = 0
    ---临时我的主基地的位置
    self.myMainPosition = Vector3(0,0,0)
    ---临时排头兵的位置
    self.firstPosition = Vector3(0,0,0)


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
    self.enemyNextCard = nil
    --所有卡牌id表
    self.AllCardIDtb = {}
    --所有卡牌等级表
    self.AllCardLeveltb = {}
    --我的大营中的卡牌表
    self.DaYingCard = bianduiModel:GetDayingData()
    --我的前锋卡牌表
    self.QianFengCard = bianduiModel:GetQianfengData()
    --我的前锋牌库
    self.QianFengPaiKutb = {}

    self:initAllCardsTbl()
    self:initHandCards()



---自定义能量值---
    --总费
    self.allFei = 1000
    --当前费
    self.nowFei = 500
    --敌人总费
    self.enemyAllFei = 1000
    --敌人当前费
    self.enemyNowFei = 900





end
---获取游戏中要用到的所有卡牌信息
function fight_model:initAllCardsTbl()
    local cardTbl = cardModel:getCardTbl()
    --sdata_cardplanmine_data:Foreach(
    --function (key, value)
    --    local card = {
    --        id = 0,
    --        num = 0,
    --        lv = 0,
    --        starLv = 0,
    --        rarity = 0,
    --        TrainCost = 0
    --    }
    --
    --    if cardTbl[value[1]] and value[2] > 0 then
    --        card.id = value[1]
    --        card.num = value[2]
    --        card.lv = cardTbl[value[1]].lv
    --        card.starLv = cardTbl[value[1]].star
    --        card.rarity = cardTbl[value[1]].rlv
    --        card.TrainCost = cardUtil:getTrainCost(card.id)
    --        table.insert(self.paiKutb, card)
    --    else
    --        Debugger.LogWarning(value[1].." 卡牌不存在！！！")
    --    end
    --
    --end)

    for i = 1, #self.DaYingCard do
        local card = {
            id = 0,
            num = 0,
            lv = 0,
            starLv = 0,
            rarity = 0,
            TrainCost = 0
        }
        local cardId = self.DaYingCard[i].cardId
        local num = self.DaYingCard[i].num
        if cardTbl[cardId] and num > 0 then
            card.id = cardId
            card.num = num
            card.lv = cardTbl[cardId].lv
            card.starLv = cardTbl[cardId].star
            card.rarity = cardTbl[cardId].rlv
            card.TrainCost = cardUtil:getTrainCost(card.id)
            table.insert(self.paiKutb, card)
        else
            Debugger.LogWarning(cardId.." 卡牌不存在！！！")
        end
    end
    for i = 1, #self.QianFengCard do
        local card = {
            id = 0,
            num = 0,
            lv = 0,
            starLv = 0,
            rarity = 0,
            TrainCost = 0
        }
        local cardId = self.QianFengCard[i]
        if cardId ~= 0 and cardTbl[cardId]  then
            card.id = cardId
            card.num = 1
            card.lv = cardTbl[cardId].lv
            card.starLv = cardTbl[cardId].star
            card.rarity = cardTbl[cardId].rlv
            card.TrainCost = cardUtil:getTrainCost(card.id)
            table.insert(self.QianFengPaiKutb, card)
        else
            Debugger.LogWarning(cardId.." 卡牌不存在！！！")
        end
    end

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
        if cardTbl[value[1]] and value[2] > 0 then

            card.id = value[1]
            card.num = value[2]
            card.lv = cardTbl[value[1]].lv
            card.starLv = cardTbl[value[1]].star
            card.rarity = cardTbl[value[1]].rlv
            card.TrainCost = cardUtil:getTrainCost(card.id)
            table.insert(self.enemyPaiKutb, card)

            ---测试数据---
            self.enemyCardNum = self.enemyCardNum + value[2]
        else
            Debugger.LogWarning(value[1].." 卡牌不存在！！！")
        end

    end)

    ---获取全部卡牌ID和等级表
    for i = 1, #self.paiKutb do
        self.AllCardLeveltb[#self.AllCardLeveltb + 1] = self.paiKutb[i].lv
        self.AllCardIDtb[#self.AllCardIDtb + 1] = self.paiKutb[i].id
    end
    for i = 1, #self.enemyPaiKutb do
        self.AllCardLeveltb[#self.AllCardLeveltb + 1] = self.enemyPaiKutb[i].lv
        self.AllCardIDtb[#self.AllCardIDtb + 1] = self.enemyPaiKutb[i].id
    end
    for i = 1,#self.QianFengPaiKutb do
        self.AllCardLeveltb[#self.AllCardLeveltb + 1] = self.QianFengPaiKutb[i].lv
        self.AllCardIDtb[#self.AllCardIDtb + 1] = self.QianFengPaiKutb[i].id
    end
end


---初始化剩余卡牌信息
function fight_model:initHandCards()

    --取前4张为手牌库
    for i = 1, 4 do
        self.nowHandpaiKutb[i] = self:getNextCard()
    end

    --获取下一张牌
    self.nextCard = self:getNextCard()
    self.enemyNextCard = self:getEnemyNextCard()
end

---
---刷新我的手牌数据
---
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
---
---获取我的下一张牌
---
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

---
---刷新敌人下一张牌
---
function fight_model:refreshEnemyCard(cardIndex)
    --获取下一张牌
    self.enemyNextCard = self:getEnemyNextCard()
end
---
---获取敌人下一张牌下一张
---
function fight_model:getEnemyNextCard()
    --打乱敌人牌库

    table.upset(self.enemyPaiKutb)
    local nextCard
    --判断盘库是否有牌
    if #self.enemyPaiKutb >= 1 and self.enemyPaiKutb[1].num > 0 then
        nextCard = self.enemyPaiKutb[1]
        self.enemyPaiKutb[1].num = self.enemyPaiKutb[1].num - 1
        if self.enemyPaiKutb[1].num == 0 then
            table.remove(self.enemyPaiKutb, 1)
        end
        self.enemyCardNum = self.enemyCardNum - 1
        return nextCard
    else
        return nil
    end
end



---从3D场景的世界坐标获取ui界面的世界坐标
function fight_model:UIWorldPosition_From_3DWorldPosition(_3DWorldCamera, _3DWorldPosition)
    local screenPoint = _3DWorldCamera:WorldToScreenPoint(_3DWorldPosition)
    local worldPoint = UICamera.currentCamera:ScreenToWorldPoint(screenPoint)
    return worldPoint
end

return fight_model