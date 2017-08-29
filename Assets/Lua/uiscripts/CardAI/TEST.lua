---
--- Created by Administrator.
--- DateTime: 2017/8/24 12:49
---
AITEST = {}
local _DATA = require("uiscripts/CardAI/DATA/DATA")

---测试用数据
AITEST.IS_TEST = false
AITEST.VIEW = nil

AITEST.consoleStr = ""
function AITEST:printrToConsole(str)
    if not AITEST.IS_TEST then
        return
    end
    AITEST.consoleStr = AITEST.consoleStr .. "[ff0000]" ..str .. "[-]\n"
end
function AITEST:printgToConsole(str)
    if not AITEST.IS_TEST then
        return
    end
    AITEST.consoleStr = AITEST.consoleStr .. "[00ff00]" ..str .. "[-]\n"
end
function AITEST:printyToConsole(str)
    if not AITEST.IS_TEST then
        return
    end
    AITEST.consoleStr = AITEST.consoleStr .. "[ff00ff]" ..str .. "[-]\n"
end

AITEST.resultStr = ""
function AITEST:printToResult(str)
    if not AITEST.IS_TEST then
        return
    end
    AITEST.resultStr = AITEST.resultStr ..str .. "\n"
end




local TacticTypeName  = {
    [10101]="地面",
    [10102]="空中",
    [10201]="对地",
    [10301]="对空",
    [10401]="人地面",
    [10402]="人空中",
    [10403]="妖地面",
    [10404]="妖空中",
    [10405]="械地面",
    [10406]="械空中",
    [10501]="人对地",
    [10502]="妖对地",
    [10503]="械对地",
    [10601]="人对空",
    [10602]="妖对空",
    [10603]="械对空",
    [10701]="隐空",
    [10702]="隐地",
    [10801]="对地返隐",
    [10901]="对空返隐",
    [11001]="空群",
    [11002]="地群",
    [11101]="对地克群",
    [11201]="对空克群",

}
function AITEST:Update()

    if not AITEST.IS_TEST then
        return
    end
    ---测试数据---
    if Input.GetKeyDown(UnityEngine.KeyCode.F1) then
        AITEST.VIEW.AITEST:SetActive(not AITEST.VIEW.AITEST.activeSelf)
    end
    if AITEST.VIEW.AITEST.activeSelf then

        local str = string.format("AI剩余卡数：%d\nAI费用槽：%d\nAI场上总费用：%d\nAI等待卡：%d\n需费用：%d\n",
        _DATA.LEFT_CARD_NUM,
        _DATA.POOL_COST,
        _DATA.AI_ALL_POWER,
        _DATA.NEXT_CARD,
        _DATA.NEED_POWER)

        local AI_POWER_SORT = {}
        for k,v in pairs(_DATA.AI_POWER) do
            table.insert(AI_POWER_SORT, k)
        end
        table.sort(AI_POWER_SORT, function(a,b)
            return _DATA.AI_POWER[a] > _DATA.AI_POWER[b]
        end)
        for _,v in pairs(AI_POWER_SORT) do
            str = str.."\n"..v..TacticTypeName[v]..":".._DATA.AI_POWER[v]
        end
        AITEST.VIEW.AIINFO:GetComponent("UILabel").text = str


        local str2 = string.format("场上总费用：%d\n", _DATA.ENEMY_ALL_POWER)
        local ENEMY_POWER_SORT = {}
        for k,_ in pairs(_DATA.ENEMY_POWER) do
            table.insert(ENEMY_POWER_SORT, k)
        end
        table.sort(ENEMY_POWER_SORT, function(a,b)
            return _DATA.ENEMY_POWER[a] > _DATA.ENEMY_POWER[b]
        end)
        for _,v in pairs(ENEMY_POWER_SORT) do
            str2 = str2.."\n"..v..TacticTypeName[v]..":".._DATA.ENEMY_POWER[v]
        end
        AITEST.VIEW.PLAYERINFO:GetComponent("UILabel").text = str2


        AITEST.VIEW.console:GetComponent("UILabel").text = AITEST.consoleStr
        AITEST.VIEW.result:GetComponent("UILabel").text = AITEST.resultStr
    end
end
return AITEST