---
--- Created by Administrator.
--- DateTime: 2017/7/21 18:06
---
-----卡牌拖拽触控点----
TouchControl = {}
local touchTbl = {}

function TouchControl:addTouch(Index)
    touchTbl[Index] =  Input.touchCount - 1
end
-- 编辑器平台和手机平台不同的触摸
function TouchControl:getTouchPoint(Index)

    if touchTbl[Index] == -1 then
        return Input.mousePosition
    elseif touchTbl[Index] > 0 then
        return Input.GetTouch(touchTbl[Index]).position
    else
        return nil
    end
end
function TouchControl:removeTouch(Index)
    if touchTbl[Index] then
        touchTbl[Index] = 0
    end
end
function TouchControl:getTouchTbl()
    return touchTbl
end

return TouchControl