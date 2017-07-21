---
--- Created by Administrator.
--- DateTime: 2017/6/30 11:25
---

local class = require("common/middleclass")
local Currency = class("Currency")
--金币, 钻石, 技能点, 经验池, 兵牌, 体力
function Currency:initialize(gold,diamond,skillPt,expPool,coin,tili,power,PkPt)
    self.gold = gold
    self.diamond = diamond
    self.skillPt = skillPt
    self.expPool = expPool
    self.coin = coin
    self.tili = tili
    self.power = power
    self.PkPt = PkPt
end

---
---对UserRole表进行操作的方法
---
currencyModel = {}
local currencyTbl={}

function currencyModel:initCurrencyTbl(currency)

    local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的)
    for i,v in ipairs(currency.diamond) do
        diamondNum = diamondNum+v
    end
    print( string.format(
        "currency==> gold:%d, diamond:%d, skillPt:%d, expPool:%d, coin:%d, tili:%d, power:%d, PkPt:%d",
        currency.gold,
        diamondNum,
        currency.skillPt,
        currency.expPool,
        currency.coin,
        currency.tili,
        currency.power,
        currency.PkPt) )
    --金币 -钻石 -技能点 -经验池 -兵牌 -体力
    currencyTbl = Currency(currency.gold, diamondNum, currency.skillPt, currency.expPool, currency.coin, currency.tili, currency.power, currency.PkPt)
end

---设置金币数量
function currencyModel:setGold(currency)
    if currency.gold then
        currencyTbl.gold = currency.gold
    end
end
---增加金币数量
function currencyModel:addGold(currency)
    if currency.gold then
        currencyTbl.gold = currencyTbl.gold + currency.gold
    end
end


---设置钻石数量
function currencyModel:setDiamond(currency)
    local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的和)
    for i,v in ipairs(currency.diamond) do
        diamondNum = diamondNum+v
    end
    currencyTbl.diamond = diamondNum
end
---增加钻石数量
function currencyModel:addDiamond(currency)
    if currency.diamond then
        local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的和)
        for i,v in ipairs(currency.diamond) do
            diamondNum = diamondNum+v
        end
        currencyTbl.diamond = currencyTbl.diamond + diamondNum
    end
end

---设置技能点数
function currencyModel:setSkillPt(currency)
    if currency.skillPt then
        currencyTbl.skillPt = currency.skillPt
    end
end
---增加技能点数
function currencyModel:addSkillPt(currency)
    if currency.gold then
        currencyTbl.skillPt = currencyTbl.skillPt + currency.skillPt
    end
end


---设置经验值
function currencyModel:setExpPool(currency)
    if currency.expPool then
        currencyTbl.expPool = currency.expPool
    end
end
---增加经验值
function currencyModel:addExpPool(currency)
    if currency.expPool then
        currencyTbl.expPool = currencyTbl.expPool + currency.expPool
    end
end

---设置兵牌数量
function currencyModel:setCoin(currency)
    if currency.coin then
        currencyTbl.coin = currency.coin
    end
end
---增加兵牌数量
function currencyModel:addCoin(currency)
    if currency.coin then
        currencyTbl.coin = currencyTbl.coin + currency.coin
    end
end

---设置体力数值
function currencyModel:setTili(currency)
    if currency.tili then
        currencyTbl.tili = currency.tili
    end
end
---增加体力值
function currencyModel:addTili(currency)
    if currency.tili then
        currencyTbl.tili = currencyTbl.tili + currency.tili
    end
end

---设置能量点数
function currencyModel:setPower(currency)
    if currency.power then
        currencyTbl.power = currency.power
    end
end
---增加体力值
function currencyModel:addPower(currency)
    if currency.power then
        currencyTbl.power = currencyTbl.power + currency.power
    end
end

---设置竞技点数
function currencyModel:setPkpt(currency)
    if currency.Pkpt then
        currencyTbl.PkPt = currency.PkPt
    end
end
---增加竞技点数
function currencyModel:addPkpt(currency)
    if currency.Pkpt then
        currencyTbl.PkPt = currencyTbl.PkPt + currency.PkPt
    end
end

---获取获取经济信息表
function currencyModel:getCurrentTbl()
    return currencyTbl
end