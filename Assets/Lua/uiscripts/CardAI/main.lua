---
--- Created by Administrator.
--- DateTime: 2017/8/1 11:06
---
local AIMain = {}
local _DATA = require("uiscripts/CardAI/DATA/INIT_DATA")

function AIMain:EnemyDropCard(card)

end
function AIMain:EnemyDead(card)

end

function AIMain:MyDropCard(card)

end
function AIMain:MyDead(card)

end


function AIMain:Update()

end


function AIMain:Init(cardTbl,cardNumTbl)
    printf(inspect(cardTbl))
    printf(inspect(cardNumTbl))
    _DATA:Init_DATA(cardTbl,cardNumTbl)
end

return AIMain