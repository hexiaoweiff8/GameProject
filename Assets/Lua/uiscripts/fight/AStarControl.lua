---
--- Created by Administrator.
--- DateTime: 2017/7/22 11:50
---
AStarControl = {}

function AStarControl:Init(maxPointX)
    --AstarFight
    self.AstarFight = GameObject.Find("/AstarFight"):GetComponent(typeof(AstarFight))
    --可下兵最大X
    self.AstarFight:setMaxX(maxPointX)
end


---
---根据世界坐标获取格子坐标
---
function AStarControl:getAStarPosition(position)
    if self.AstarFight then
        return self.AstarFight:getNum(position)
    end
    Debugger.LogWarning("获取格子坐标出错，可能是未初始化AStarFight！！！")
end


---
---获取所有阵型表
---
function AStarControl:getAllZhengXingList(paiKutb, paiKuLeveltb)
    if self.AstarFight then
        return self.AstarFight:setAllZhenxingList(paiKutb, paiKuLeveltb)
    end
    Debugger.LogWarning("获取所有阵型表出错，可能是未初始化AStarFight！！！")
end

---
---获取障碍宽度
---
function AStarControl:getUnitWidth()
    if self.AstarFight then
        return self.AstarFight.UnitWidth
    end
    Debugger.LogWarning("获取障碍宽度出错，可能是未初始化AStarFight！！！")
end
---
---获取障碍宽度
---
function AStarControl:getMapWidth()
    if self.AstarFight then
        return self.AstarFight.MapWidth
    end
    Debugger.LogWarning("获取地图宽度，可能是未初始化AStarFight！！！")
end

---
---设置模型阵型信息
---
function AStarControl:setZhenxingInfo(go, id, index)

    if self.AstarFight then
        self.AstarFight:setZhenxingInfo(go, id, index - 1)
        return
    end
    Debugger.LogWarning("设置阵型信息出错，可能是未初始化AStarFight！！！")
end

function AStarControl:setZhangAi(position, index)
    if self.AstarFight then
        self.AstarFight:isZhangAi(position, index - 1)
        return
    end
    Debugger.LogWarning("设置阵型信息出错，可能是未初始化AStarFight！！！")

end
return AStarControl