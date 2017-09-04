---
--- Created by Administrator.
--- DateTime: 2017/8/29 19:24
---
local prefight_model = {}


function prefight_model:InitData()

end

function prefight_model:LoadFightData(callback)
    Message_Manager:SendPB_EnterPvp()
    while not BattleRoleModel:GetisLoadDone() do
        coroutine.wait(0.1)
    end
    --我的大营中的卡牌表
    self.myDaYingCardTbl = wnd_biandui_model:GetDayingData()
    --我的前锋卡牌表
    self.myQianFengCardTbl = wnd_biandui_model:GetQianfengData()
    --
    self.enemyDaYingCardTbl = BattleRoleModel:GetDaYingCardTbl()
    --
    self.enemyQianFengCardTbl = BattleRoleModel:GetQianFengCardTbl()

    callback()
end
function prefight_model:InitModelData(callback)
    CanNotArea:Init()
    local maxDropX = CanNotArea:GetMaxDropX()
    AStarControl:Init(maxDropX)
    local AllCardIDtb = {}
    local tempTbl = {}
    for k,v in ipairs(self.myDaYingCardTbl) do
        if not tempTbl[v.cardId] then
            tempTbl[v.cardId] = 1
            table.insert(AllCardIDtb, v.cardId)
        end
    end
    for k,v in ipairs(self.myQianFengCardTbl) do
        if not tempTbl[v] and v ~=0 then
            tempTbl[v] = 1
            table.insert(AllCardIDtb, v)
        end
    end
    for k,v in ipairs(self.enemyDaYingCardTbl) do
        if not tempTbl[v.cardId] then
            tempTbl[v.cardId] = 1
            table.insert(AllCardIDtb, v.cardId)
        end
    end
    for k,v in ipairs(self.enemyQianFengCardTbl) do
        if not tempTbl[v] and v ~=0 then
            tempTbl[v] = 1
            table.insert(AllCardIDtb, v)
        end
    end
    Model:setZhenXingData(AllCardIDtb)
    callback()
end




return prefight_model