---
--- Created by Administrator.
--- DateTime: 2017/6/30 11:25
---

local class = require("common/middleclass")
local Currency = class("Currency")
--金币, 钻石, 技能点, 经验池, 兵牌, 体力
function Currency:initialize(gold,diamond,skillpt,expPool,coin,tili,power)
    self.gold = gold
    self.diamond = diamond
    self.skillpt = skillpt
    self.expPool = expPool
    self.coin = coin
    self.tili = tili
    self.power = power
end

---
---对UserRole表进行操作的方法
---
currencyModel = {}
local currencyTbl={}

function currencyModel:setCurrencyTbl(currency)

    local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的)
    for i,v in ipairs(currency.diamond) do
        diamondNum = diamondNum+v
    end
    print( string.format(
        "currency==> gold:%d, diamond:%d, skillPt:%d, expPool:%d, coin:%d, tili:%d, power:%d",
        currency.gold,
        diamondNum,
        currency.skillPt,
        currency.expPool,
        currency.coin,
        currency.tili,
        currency.power) )
    --金币 -钻石 -技能点 -经验池 -兵牌 -体力
    currencyTbl = Currency(currency.gold, diamondNum, currency.skillPt, currency.expPool, currency.coin, currency.tili, currency.power)
end

function currencyModel:setGold(currency)
    currencyTbl.gold = currency.gold
end
function currencyModel:setDiamond(currency)
    local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的和)
    for i,v in ipairs(currency.diamond) do
        diamondNum = diamondNum+v
    end
    currencyTbl.diamond = currency.gold
end
function currencyModel:setSkillPt(currency)
    currencyTbl.skillpt = currency.skillPt
end
function currencyModel:setExpPool(currency)
    currencyTbl.expPool = currency.expPool
end
function currencyModel:setCoin(currency)
    currencyTbl.coin = currency.coin
end
function currencyModel:setTili(currency)
    currencyTbl.tili = currency.tili
end
function currencyModel:setPower(currency)
    currencyTbl.power = currency.power
end
function currencyModel:getCurrentTbl()
    return currencyTbl
end