local class = require("common/middleclass")
--装备M
kejiM = class("kejiM")
-- kejiID = 1 --科技ID
-- kejiLevel = 0 --科技等级
-- isShengji = 0 --是否在升级中 0为没有在升级中 1为升级中
-- lastTime = 0 --升级剩余时间
function kejiM:initialize(kejiID, kejiLevel, isShengji, lastTime)
    self.kejiID = kejiID
    self.kejiLevel = kejiLevel
    self.isShengji = isShengji
    self.lastTime = lastTime
end

--科技tb
kejiP = {
    {
        kejiM(101, 1, 1, 9999),
        kejiM(102, 20, 0, 0),
        kejiM(103, 80, 0, 0),
        kejiM(104, 0, 0, 0),
        kejiM(105, 0, 0, 0),
        kejiM(106, 0, 0, 0),
    },
    {
        kejiM(201, 1, 0, 0),
        kejiM(202, 1, 0, 0),
        kejiM(203, 1, 0, 0),
        kejiM(204, 1, 0, 0),
        kejiM(205, 1, 0, 0),
        kejiM(206, 1, 0, 0),
    },
    {
        kejiM(301, 1, 0, 0),
        kejiM(302, 1, 0, 0),
        kejiM(303, 1, 0, 0),
        kejiM(304, 1, 0, 0),
        kejiM(305, 1, 0, 0),
        kejiM(306, 1, 0, 0),
    },
    {
        kejiM(401, 1, 0, 0),
        kejiM(402, 1, 0, 0),
        kejiM(403, 1, 0, 0),
        kejiM(404, 1, 0, 0),
        kejiM(405, 1, 0, 0),
        kejiM(406, 1, 0, 0),
    },
}


--找出正在升级的科技
local tempInt = 0
for i = 1, #kejiP do
    for j = 1, #kejiP[i] do
        if kejiP[i][j].isShengji == 1 and kejiP[i][j].lastTime > 0 then
            tempInt = tempInt + 1
            startTimer(kejiP[i][j].lastTime,
                nil,
                function(timer)--完成回调
                end, "ui_kejitree_shengji" .. i .. j)
            if tempInt == maxShengJiNum then --如果达到了最大升级序列则无需再寻找
                break
            end
        end
    end
    if tempInt == maxShengJiNum then --如果达到了最大升级序列则无需再寻找
        break
    end
end
