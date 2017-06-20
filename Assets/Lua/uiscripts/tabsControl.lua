local class = require("common/middleclass")
tabsControl = class("tabsControl")

local tabButtonTable = {}
local tabPanelTabel = {}
local currentTabIndex = 0


--[[
    初始化
    若需要切换显示，tabButtons与tabPanels需数量相等，一一对应
    若不需要切换显示，tabPanels传入nil即可
]]
function tabsControl:initialize( tabButtons, tabPanels, func )
    -- 按钮不存在，结束运行
    if #tabButtons == 0 then 
        return 
    end
    --保存按钮数据
    tabButtonTable = tabButtons

    --需要切换显示，且数量与按钮相等时，保存显示的窗口数据
    if tabPanels and #tabButtons == #tabPanels then 
        tabPanelTabel = tabPanels
    end

    --初始化，显示排在第一个位置的tab
    self:changeTabTo(1)

    --执行回调方法，传入当前显示的index
    if func then 
        func(_, currentTabIndex)
    end

    --为按钮添加监听
    for i = 1, #tabButtonTable do 
        UIEventListener.Get(tabButtonTable[i]).onClick = function()
            if currentTabIndex == i then 
                return
            end
            self:changeTabTo(i)
            if func then 
                func(_, i)
            end
        end
    end

end

--切换到相应的界面，
function tabsControl:changeTabTo(tableIndex)

    if tableIndex == currentTabIndex then 
        return 
    end 
    --判断显示的界面是否存在，并切换显示
    if tabPanelTabel[tableIndex] then 
        tabPanelTabel[tableIndex]:SetActive(true)
    end
    if tabPanelTabel[currentTabIndex] then 
        tabPanelTabel[currentTabIndex]:SetActive(false)
    end



    --判断按钮的光标是否存在，切换显示
    if tabButtonTable[tableIndex].transform:Find("lightSp") then
        tabButtonTable[tableIndex].transform:Find("lightSp").gameObject:SetActive(true)
    end
    if tabButtonTable[currentTabIndex] and tabButtonTable[currentTabIndex].transform:Find("lightSp") then 
        tabButtonTable[currentTabIndex].transform:Find("lightSp").gameObject:SetActive(false)
    end


    --切换当前显示的Index
    currentTabIndex = tableIndex
end


--外部获取当前显示的Index
function tabsControl:getCurrentPanelIndex()
    -- body
    return currentTabIndex
end

return tabsControl