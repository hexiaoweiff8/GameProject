local class = require("common/middleclass")
local ui_kejitree = class("ui_kejitree", wnd_base)

local sdataTB
local maxKejiNum = 6 --最大的科技图标数
local perKejiNum = {6, 6, 6, 6}--每页最大科技图标数
local maxShengJiNum = 1 --最大升级序列数
function ui_kejitree:OnShowDone()
    self.temp = 0
    ui_kejitree = self
    self.ui_keji_jiasu = nil
    sdataTB = {sdata_kejitree_jingji_data, sdata_kejitree_gongji_data, sdata_kejitree_fangyu_data, sdata_kejitree_shengming_data}
    local bg = self.transform:Find("bg")
    local bg2 = self.transform:Find("bg2")
    self.page1_jingji = self.transform:Find("page1_jingji")--经济标签
    self.page2_gongji = self.transform:Find("page2_gongji")--攻击标签
    self.page3_fangyu = self.transform:Find("page3_fangyu")--防御标签
    self.page4_shengming = self.transform:Find("page4_shengming")--生命标签
    self.back1 = self.transform:Find("back1")--返回按钮
    UIEventListener.Get(self.back1.gameObject).onClick = function(go)--返回按钮回调
        ui_manager:ShowWB(WNDTYPE.Login)
    end
    self.bg3 = bg2:Find("bg3")
    self.kejiState = {}--当前科技状态（可升级/升级中/未激活）
    self.shengji = self.bg3:Find("shengji")--激活=0/升级=1/加速=2
    UIEventListener.Get(self.shengji.gameObject).onClick = function(go)--升级按钮回调
        if self.kejiState[nowInfoIndex] == 2 then --加速
            ui_manager:ShowWB(WNDTYPE.ui_keji_jiasu)
        else --激活/升级
            -- --TODODO
            ui_manager:ShowWB(WNDTYPE.ui_keji_jiasu)
        -- System.GC.Collect()
        -- collectgarbage("collect")
        end
    end
    
    nowPageIndex = 1 --当前页面Index
    nowInfoIndex = 0 --当前信息Index
    self.tickFunc = {}
    
    self.xuanzhongSprite = {}
    self.pageBtn = {"bg/page1_jingji", "bg/page2_gongji", "bg/page3_fangyu", "bg/page4_shengming"}--标签按钮tb
    for i = 1, 4 do
        self.pageBtn[i] = bg:Find(self.pageBtn[i])
        self.xuanzhongSprite[i] = self.pageBtn[i]:Find("Sprite").gameObject
        self.pageBtn[i]:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10007 + i - 1)
        UIEventListener.Get(self.pageBtn[i].gameObject).onClick = function(go)--标签按钮回调
            if nowPageIndex ~= index then
                self:changePage(i)--切换页面
            end
        end
    end
    
    
    self.kejiBtn = {}--科技按钮tb
    self.kejiBtnUISprite = {}--科技按钮US
    self.kejiLevel = {}--科技等级UL
    self.kejiName = {}--科技名称UL
    for i = 1, maxKejiNum do
        self.kejiBtn[i] = bg:Find("kejiIcon" .. i)--单个科技按钮
        self.kejiBtnUISprite[i] = self.kejiBtn[i]:Find("eqSpr"):GetComponent(typeof(UISprite))
        self.kejiLevel[i] = self.kejiBtn[i]:Find("level"):GetComponent(typeof(UILabel))
        self.kejiName[i] = self.kejiBtn[i]:Find("kejiName"):GetComponent(typeof(UILabel))
        UIEventListener.Get(self.kejiBtn[i].gameObject).onClick = function(go)--科技按钮回调
            if nowInfoIndex ~= i then
                self:changeInfo(i)
            end
        end
    end
    
    
    self.kejiBgUS = bg2:Find("infoBG11/kejiBg"):GetComponent(typeof(UISprite))
    self.kejiNameUL = bg2:Find("title"):GetComponent(typeof(UILabel))
    self.kejiInfoUL = bg2:Find("infoBG11/info2"):GetComponent(typeof(UILabel))
    self.keji1Bg = bg2:Find("bg/infoBG21")
    self.keji2Bg = bg2:Find("bg/infoBG22")
    self.costBg = self.bg3:Find("infoBG31")
    self.timeBg = self.bg3:Find("infoBG32")
    self.keji1LevelUL = bg2:Find("bg/infoBG21/info1"):GetComponent(typeof(UILabel))
    self.keji1InfoUL = self.keji1LevelUL.transform:Find("info2"):GetComponent(typeof(UILabel))
    self.keji1NumUL = self.keji1InfoUL.transform:Find("info3"):GetComponent(typeof(UILabel))
    self.keji2LevelUL = bg2:Find("bg/infoBG22/info1"):GetComponent(typeof(UILabel))
    self.keji2InfoUL = self.keji2LevelUL.transform:Find("info2"):GetComponent(typeof(UILabel))
    self.keji2NumUL = self.keji2InfoUL.transform:Find("info3"):GetComponent(typeof(UILabel))
    self.costNumUL = self.costBg:Find("info1"):GetComponent(typeof(UILabel))
    self.timeUL = self.timeBg:Find("info1"):GetComponent(typeof(UILabel))
    self.xian2 = self.bg3:Find("xian2")
    self.keji1BgLastP = self.keji1Bg.localPosition
    self.kuangSpr = bg:Find("kuangSpr")--科技选择框
    
    
    --切换页面
    self:changePage(nowPageIndex)
    
    --找出正在升级的科技
    local tempInt = 0
    for i = 1, #kejiP do
        for j = 1, #kejiP[i] do
            if kejiP[i][j].isShengji == 1 and kejiP[i][j].lastTime > 0 then --如果升级剩余时间不为零
                tempInt = tempInt + 1
                local timer = allTimeTickerTb["ui_kejitree_shengji" .. i .. j]
                if nowPageIndex == i and nowInfoIndex == j then
                    self.timeUL.text = GetRemainTime(timer.OverTime)
                end
                self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function(co)
                    while true do
                        coroutine.wait(1)
                        if nowPageIndex == i and nowInfoIndex == j then
                            local OverTime = timer.OverTime
                            if OverTime <= 0 then
                                OverTime = 0
                                break
                            end
                            OverTime = GetRemainTime(OverTime)
                            self.timeUL.text = OverTime
                            
                            if self.ui_keji_jiasu ~= nil then
                                self.ui_keji_jiasu.timeUL.text = OverTime
                            end
                        end
                    end
                end)
                
                if tempInt == maxShengJiNum then --如果达到了最大升级序列则无需再寻找
                    break
                end
            end
        end
        if tempInt == maxShengJiNum then --如果达到了最大升级序列则无需再寻找
            break
        end
    end
end
--==============================--
--desc:切换页面 1.经济 2.攻击 3.防御 4.生命
--time:2017-04-25 10:22:09
--@index:页面序号
--return
--==============================--
function ui_kejitree:changePage(index)
    self.xuanzhongSprite[nowPageIndex]:SetActive(false)
    nowPageIndex = index
    self.xuanzhongSprite[nowPageIndex]:SetActive(true)
    local kejiNum = perKejiNum[index]
    local kejiID
    for i = 1, kejiNum do --左侧科技图标信息展示
        self.kejiBtn[i].gameObject:SetActive(true)
        local kejiLevel = kejiP[index][i].kejiLevel
        local kejiLevelAdd = kejiLevel + 1
        if kejiLevel == 0 then --未激活
            kejiID = tonumber(kejiP[index][i].kejiID .. string.format("%03d", 1))--0级时显示1级的信息
            self.kejiLevel[i].text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10011)
            self.kejiBtnUISprite[i].spriteName = sdataTB[index]:GetFieldV("TechIcon", kejiID)
            self.kejiName[i].text = sdataTB[index]:GetFieldV("TechName", kejiID)
        else --已激活
            kejiID = tonumber(kejiP[index][i].kejiID .. string.format("%03d", kejiLevel))
            if kejiLevelAdd >= 80 then --满级
                self.kejiLevel[i].text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10013)
            else
                self.kejiLevel[i].text = sdataTB[index]:GetFieldV("Level", kejiID) .. sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10012)
            end
            self.kejiBtnUISprite[i].spriteName = sdataTB[index]:GetFieldV("TechIcon", kejiID)
            self.kejiName[i].text = sdataTB[index]:GetFieldV("TechName", kejiID)
        end
    end
    --根据当前页面科技图标数隐藏多余图标
    for i = kejiNum + 1, maxKejiNum do
        self.kejiBtn[i].gameObject:SetActive(false)
    end
    --切换信息
    self:changeInfo(1)
end

--==============================--
--desc:切换信息
--time:2017-04-25 10:22:58
--@index:科技序号
--return
--==============================--
function ui_kejitree:changeInfo(index)
    nowInfoIndex = index
    local kejiID
    local kejiIDAdd
    local kejiLevel = kejiP[nowPageIndex][index].kejiLevel
    local kejiLevelAdd = kejiLevel + 1
    --左侧升级信息归位，右侧升级信息显示,下方信息显示
    self.bg3.gameObject:SetActive(true)
    self.keji2Bg.gameObject:SetActive(true)
    self.keji1Bg.localPosition = self.keji1BgLastP
    
    if kejiLevel == 0 then --未激活
        kejiLevel = kejiLevel + 1
        kejiID = tonumber(kejiP[nowPageIndex][index].kejiID .. string.format("%03d", kejiLevel))--0级时显示1级的信息
        --左侧升级信息居中，右侧升级信息隐藏
        self.keji2Bg.gameObject:SetActive(false)
        self.keji1Bg.localPosition = Vector3(0, self.keji1Bg.localPosition.y, self.keji1Bg.localPosition.z)
        --左侧升级信息展示
        self.keji1LevelUL.text = kejiLevel .. sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10012)
        self.keji1InfoUL.text = sdataTB[nowPageIndex]:GetFieldV("FunctionDes", kejiID)
        self.keji1NumUL.text = "+" .. sdataTB[nowPageIndex]:GetFieldV("Point", kejiID)
        self.costNumUL.text = sdataTB[nowPageIndex]:GetFieldV("RequireGold", kejiID)--消耗信息展示
        self.timeUL.text = sdataTB[nowPageIndex]:GetFieldV("RequireTime", kejiID)--耗时信息展示
    else --已激活
        kejiID = tonumber(kejiP[nowPageIndex][index].kejiID .. string.format("%03d", kejiLevel))
        --左侧升级信息展示
        self.keji1LevelUL.text = kejiLevel .. sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10012)
        self.keji1InfoUL.text = sdataTB[nowPageIndex]:GetFieldV("FunctionDes", kejiID)
        self.keji1NumUL.text = "+" .. sdataTB[nowPageIndex]:GetFieldV("Point", kejiID)
        if kejiLevelAdd >= 80 then --满级
            --左侧升级信息居中，右侧升级信息隐藏
            self.keji2Bg.gameObject:SetActive(false)
            self.keji1Bg.localPosition = Vector3(0, self.keji1Bg.localPosition.y, self.keji1Bg.localPosition.z)
            --下方信息隐藏
            self.bg3.gameObject:SetActive(false)
        else
            
            
            kejiIDAdd = kejiID + 1
            --右侧升级信息展示
            self.keji2LevelUL.text = kejiLevelAdd .. sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10012)
            self.keji2InfoUL.text = sdataTB[nowPageIndex]:GetFieldV("FunctionDes", kejiIDAdd)
            self.keji2NumUL.text = "+" .. sdataTB[nowPageIndex]:GetFieldV("Point", kejiIDAdd)
            self.costNumUL.text = sdataTB[nowPageIndex]:GetFieldV("RequireGold", kejiID)--消耗信息展示
            if kejiP[nowPageIndex][nowInfoIndex].isShengji == 1 then
                self.timeUL.text = GetRemainTime(allTimeTickerTb["ui_kejitree_shengji" .. nowPageIndex .. nowInfoIndex].OverTime)
            else
                self.timeUL.text = sdataTB[nowPageIndex]:GetFieldV("RequireTime", kejiID)--耗时信息展示
            end
        
        end
    end
    
    --上方信息展示
    self.kejiBgUS.spriteName = sdataTB[nowPageIndex]:GetFieldV("TechIcon", kejiID)
    self.kejiNameUL.text = sdataTB[nowPageIndex]:GetFieldV("TechName", kejiID)
    self.kejiInfoUL.text = sdataTB[nowPageIndex]:GetFieldV("TechDes", kejiID)
    
    self.kuangSpr.localPosition = self.kejiBtn[index].localPosition
end


return ui_kejitree
