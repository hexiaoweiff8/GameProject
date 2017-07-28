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
    self:initLeftCards()
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

    -- 下方卡牌缩放间距
    self.onPressMyCardSpantb = {}
    -- 拖动中的卡牌模型table
    self.onPressArmytb = {}
    -- UI卡牌table
    self.nowMyCardtb = {}
    -- UI卡牌CDtable
    self.nowMyCardCDtbUISpritetb = {}
    -- UI技能table
    self.uiSkilltb = {}
    -- UI卡牌原始位置
    self.myCardConstPostb = {}
    -- 卡牌缩放间距
    self.cardScaleSpan = 67
    -- UI卡牌原始位置
    self.myCardConstPostb = {}
    -- 敌方下次出的卡牌ID
    self.nextEnemyCardID = nil
    -- 敌方下次出的卡牌费
    self.nextEnemyCardFei = nil

    -- 拖动中的卡牌table
    self.onPressMyCardtb = {}

    -- 卡牌大碰撞框
    self.bigCardBoxCollider = {}
    -- 卡牌选中状态
    self.isCardSelected = {false, false, false, false}
    --myTouchCount
    self.myTouchCount = 0


    --兵阵型右边最宽距离
    self.maxSpan = {}
    --组ID
    self.groupIndex = 0


    --self.feiBounds = Bounds(Vector3(self.feiBg.localPosition.x, self.feiBg.localPosition.y, 0), Vector3(feiUIWidget.width, feiUIWidget.height, 0))


end



---初始化剩余卡牌信息
function fight_model:initLeftCards()

    for i = 1, 9 do
        local card = {
            id = 0,
            num = 0,
            TrainCost = 0
        }
        card.id = 101000 + i
        card.num = i
        card.TrainCost = cardUtil:getTrainCost(card.id)
        table.insert(self.enemyPaiKutb, card)
        table.insert(self.paiKutb, card)
    end
    --打乱敌人牌库
    table.upset(self.enemyPaiKutb)
    --打乱自身牌库
    table.upset(self.paiKutb)

    --取前4张为手牌库
    for i = 1, 4 do
        self.nowHandpaiKutb[i] = self.paiKutb[1]
        table.remove(self.paiKutb, 1)
    end

    --获取下一张牌
    self.nextCard = self.paiKutb[1]
    table.remove(self.paiKutb, 1)

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