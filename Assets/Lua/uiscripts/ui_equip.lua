local class = require("common/middleclass")
local ui_equip = class("ui_equip", wnd_base)

local pingzhiName = {"zhuangbei_zhuangbeikuang_baisepinzhi", "zhuangbei_zhuangbeikuang_chengsepinzhi", "zhuangbei_zhuangbeikuang_hongsepinzhi", "zhuangbei_zhuangbeikuang_hongsesunhuai", "zhuangbei_zhuangbeikuang_lansepinzhi", "zhuangbei_zhuangbeikuang_lvsepinzhi", "zhuangbei_zhuangbeikuang_zisepinzhi", "zhuangbei_zhuangbeikuang_weizhuangbei", }
eqNameColor = {Color(54 / 255, 214 / 255, 255 / 255), Color(255 / 255, 139 / 255, 62 / 255), Color(210 / 255, 110 / 255, 110 / 255), Color(120 / 255, 220 / 255, 120 / 255), Color(130 / 255, 130 / 255, 230 / 255), Color(140 / 255, 140 / 255, 140 / 255)}
--左侧装备栏显示操作 0-99为删除 100-199为添加 200-299为修改
local function ZUOCEZHUANGBEI(type, i, v)
    local self = ui_equip
    if type ~= 1 then --type==1 为初始化操作
        self:setSuitData()
    end
    
    if type < 100 then --删除
        self.eqBg[i]:GetComponent(typeof(UISprite)).spriteName = pingzhiName[8]
        self.eqBg[i]:Find("level").gameObject:SetActive(false)
        self.eqBg[i]:Find("eqSpr").gameObject:SetActive(false)
        self.eqBg[i]:Find("diSpr").gameObject:SetActive(true)
        --如果有可穿戴装备则显示加号
        if equipP.allEqList[i] ~= 0 then
            local noBadNum = 0 --没有损坏的装备数目
            for j, v in ipairs(equipP.allEqList[i]) do
                if v.IsBad == 0 then
                    noBadNum = noBadNum + 1
                    break
                end
            end
            if noBadNum == 0 then
                self.eqBg[i]:Find("addSpr").gameObject:SetActive(false)
            else
                self.eqBg[i]:Find("addSpr").gameObject:SetActive(true)
            end
        end
    elseif type < 200 then --添加
        self.eqBg[i]:Find("eqSpr").gameObject:SetActive(true)
        self.eqBg[i]:Find("level").gameObject:SetActive(true)
        self.eqBg[i]:Find("diSpr").gameObject:SetActive(false)
        self.eqBg[i]:Find("addSpr").gameObject:SetActive(false)
        self.xiexia.gameObject:SetActive(true)
        setEqIconView(self.eqBg[i], v)
    else --修改
        setEqIconView(self.eqBg[i], v)
    end
    if self.bg5.gameObject.activeSelf then --如果详情界面显示则刷新该界面内容
        self:setAllInfo()
    end
end

--右侧装备列表显示操作 0-99为删除 100-199为添加 200-299为修改
local function YOUCEZHUANGBEI(type, i, v, i2)
    local self = ui_equip
    if type < 100 then --删除
        sortEqList(i)
        Object.Destroy(table.remove(self.ceqTB, v).gameObject)
        --如果卸下按钮隐藏startX = 1
        local startX = self.xiexia.gameObject.activeSelf and 0 or 1
        for j = 1, #self.ceqTB do
            self.ceqTB[j].localPosition = Vector3((j - startX) % self.eqUIGridWHL.maxPerLine * self.eqUIGridWHL.cellWidth, -math.modf((j - startX) / self.eqUIGridWHL.maxPerLine) * self.eqUIGridWHL.cellHeight, 0)
        end
    elseif type < 200 then --添加/卸下左侧后添加
        local go = GameObjectExtension.InstantiateFromPacket("ui_equip", "eqBg", self.eqGrid.gameObject)
        setEqIconView(go.transform, v)
        --装备添加触摸
        UIEventListener.Get(go).onClick = function(go)
            eqChangeIndex = table.indexof(equipP.allEqList[i], v)
            if equipP.nowEqList[i] == 0 then --如果对应的装备栏为空
                self.simple_state_machine:do_event("change11", v)
            else
                self.simple_state_machine:do_event("change6", i, v)
            end
        end
        
        sortEqList(i)
        local index2 = table.indexof(equipP.allEqList[i], v)
        table.insert(self.ceqTB, index2, go.transform)
        --如果卸下按钮隐藏startX = 1
        local startX = self.xiexia.gameObject.activeSelf and 0 or 1
        local tempJ = 1
        if type == 100 then --添加（加入元素的后边元素向后移动），卸下为加入元素的前边元素向前移动
            tempJ = index2
            index2 = #self.ceqTB
        end
        for j = tempJ, index2 do
            self.ceqTB[j].localPosition = Vector3((j - startX) % self.eqUIGridWHL.maxPerLine * self.eqUIGridWHL.cellWidth, -math.modf((j - startX) / self.eqUIGridWHL.maxPerLine) * self.eqUIGridWHL.cellHeight, 0)
        end
    else --修改
        setEqIconView(self.ceqTB[i2], v)
        sortEqList(i)
        local index2 = table.indexof(equipP.allEqList[i], v)
        if index2 ~= i2 then -- 如果修改了装备后排序有变化
            table.insert(self.ceqTB, index2, table.remove(self.ceqTB, i2))
            --如果卸下按钮隐藏startX = 1
            local startX = self.xiexia.gameObject.activeSelf and 0 or 1
            local tempJ = math.min(i2, index2)
            local len = #self.ceqTB
            for j = tempJ, len do
                self.ceqTB[j].localPosition = Vector3((j - startX) % self.eqUIGridWHL.maxPerLine * self.eqUIGridWHL.cellWidth, -math.modf((j - startX) / self.eqUIGridWHL.maxPerLine) * self.eqUIGridWHL.cellHeight, 0)
            end
        end
    end
    --所有Scroll View拉动超长后显示黑框
    self.local_eqUseSV:InvalidateBounds()
    if self.local_eqUseUP.clipOffset.y - self.local_eqUseSV.bounds.min.y - 5 > self.local_finalClipRegionW2 then
        self.local_eqShuXingDiSpr:SetActive(true)
    else
        self.local_eqShuXingDiSpr:SetActive(false)
    end
end


--交换左右侧装备
local function EXCHANGEZHUANGBEI(i, i2, v1, v2)
    local self = ui_equip
    self:setSuitData()
    setEqIconView(self.eqBg[i], v2)
    sortEqList(i)
    local index = table.indexof(equipP.allEqList[i], v1)
    
    table.insert(self.ceqTB, index, table.remove(self.ceqTB, i2))
    --装备添加触摸
    UIEventListener.Get(self.ceqTB[index].gameObject).onClick = function(go)
        if equipP.nowEqList[i] == 0 then --如果对应的装备栏为空
            self.simple_state_machine:do_event("change11", v1)
        else
            self.simple_state_machine:do_event("change6", i, v1)
        end
    end
    setEqIconView(self.ceqTB[index], v1)
    local startX = 0
    for j = 1, #self.ceqTB do
        self.ceqTB[j].localPosition = Vector3((j - startX) % self.eqUIGridWHL.maxPerLine * self.eqUIGridWHL.cellWidth, -math.modf((j - startX) / self.eqUIGridWHL.maxPerLine) * self.eqUIGridWHL.cellHeight, 0)
    end
    
    if self.bg5.gameObject.activeSelf then --如果详情界面显示则刷新该界面内容
        self:setAllInfo()
    end
end
local badColor = Color(197 / 255, 56 / 255, 56 / 255, 255 / 255)
local suitColor = Color(19 / 255, 231 / 255, 211 / 255)
local suitColorGray = Color(140 / 255, 142 / 255, 142 / 255)
function ui_equip:OnShowDone()
    ui_equip = self
    
    --添加RenderTexture 实现UI上添加3d模型
    local playerModelTexture = self.transform:Find("bg1/playerModelTexture")
    local Camera3D = self.transform:Find("Camera3D")
    self.myTexture = UnityEngine.RenderTexture(1024, 1024, 24)
    self.myTexture:Create()
    Camera3D:GetComponent(typeof(UnityEngine.Camera)).targetTexture = self.myTexture
    playerModelTexture:GetComponent(typeof(UITexture)).mainTexture = self.myTexture
    --添加玩家3d模型
    tempMod = DP_FightPrefabManage.InstantiateAvatar(CreateActorParam(AvatarCM.Infantry_R, false, 0, "gongjianbing", "gongjianbing", true, 0, 0)).transform
    tempMod.parent = Camera3D
    tempMod.localScale = Vector3(1, 1, 1);
    tempMod.localRotation = Quaternion(0, 180, 0, 1);
    tempMod.localPosition = Vector3(0, -7, 500);
    tempMod.gameObject:SetActive(true)
    tempMod.gameObject.layer = UnityEngine.LayerMask.NameToLayer("3DUI")
    
    playerModelTexture:GetComponent(typeof(SpinWithMouse)).target = tempMod
    
    --未穿戴的装备排序（TODODO：放到获取数据的地方）
    for i = 1, #equipP.allEqList do
        if equipP.allEqList[i] ~= nil then
            sortEqList(i)
        end
    end
    self:setSuitData()
    
    self.bg3 = self.transform:Find("bg3")--装备详情单独界面
    self.bg4 = self.transform:Find("bg4")--未装备详情单独界面
    self.bg3eqShuXingDi = self.bg3:Find("eqShuXingDi")--装备详情单独界面
    self.bg4eqShuXingDi = self.bg4:Find("eqShuXingDi")--未装备详情单独界面
    self.bg5 = self.transform:Find("bg5")--人物属性详情单独界面
    self.bg51Grid = self.bg5:Find("bg51/Scroll View/Grid")--人物属性详情单独界面UIScrollView
    self.bg5SV2 = self.bg5:Find("Container/Scroll View")--人物属性详情单独界面UIScrollView
    self.back1 = self.transform:Find("back1")--返回主界面按钮
    self.info = self.transform:Find("bg1/info")--详细属性按钮
    self.shizhuang = self.transform:Find("bg1/shizhuang")--时装按钮
    self.yjzb = self.transform:Find("bg1/yjzb")--一键装备按钮
    self.yjxl = self.transform:Find("bg1/yjxl")--一键装备按钮
    self.eqUse = self.transform:Find("bg2/eqUse")--更换装备界面
    self.eqGrid = self.eqUse:Find("Scroll View/eqGrid")--eq UIGrid
    self.eqShuXingBg = self.transform:Find("bg2/eqShuXingBg")--装备详情界面
    self.fenxiang = self.eqShuXingBg:Find("fenxiang")--分享按钮
    self.genghuan = self.eqShuXingBg:Find("genghuan")--更换装备按钮
    self.bg4genghuan = self.bg4eqShuXingDi:Find("genghuan")--弹出的二级框上的更换或穿戴装备按钮
    self.suoding = self.eqShuXingBg:Find("suoding")--锁定装备按钮
    self.qianghua = self.eqShuXingBg:Find("qianghua")--强化/重铸/修理按钮
    self.bg4Qianghua = self.bg4eqShuXingDi:Find("qianghua")--未装备详情单独界面强化/重铸/修理按钮
    self.qianghuaJiaGeUL = self.qianghua:Find("jiage"):GetComponent(typeof(UILabel))--强化/重铸/修理价格
    self.bg4QianghuaJiaGeUL = self.bg4Qianghua:Find("jiage"):GetComponent(typeof(UILabel))--未装备详情单独界面强化/重铸/修理价格
    self.eqShuXingXieXia = self.eqShuXingBg:Find("xiexia")--装备详情页卸下按钮
    self.xiexia = self.eqGrid:Find("xiexia")--更换整备界面卸下按钮
    self.nowEqBg = self.eqShuXingBg:Find("eqShuXing/eqBg")--装备详情页装备图标Bg
    self.nowEqBgEqSpr = self.nowEqBg:Find("eqSpr")
    self.nowEqBgLevel = self.nowEqBg:Find("level")
    self.selectKuang = self.transform:Find("bg1/selectKuang")
    self.battleWidget = self.transform.parent:Find("ui_equip_baffle"):GetComponent(typeof(UIWidget))
    self.bg34P = {self.bg3eqShuXingDi.localPosition, self.bg4eqShuXingDi.localPosition}
    self.lastInfoP = self.info.localPosition
    self.lastbg5P = self.bg5.localPosition
    self.infoJianTouSpr = self.info:Find("Sprite"):GetComponent(typeof(UISprite))
    local bg51UIGrid = self.bg51Grid:GetComponent(typeof(UIGrid))
    self.bg51GridWHL = {cellWidth = bg51UIGrid.cellWidth, cellHeight = bg51UIGrid.cellHeight, maxPerLine = 1}
    
    self.eqShuXingXieXia:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10016)
    self.xiexia:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10016)
    self.bg4genghuan:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10017)
    self.info:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10018)
    
    self.suitSV = {}--详情界面套装属性Scroll View
    for i = 1, 4 do
        self.suitSV[i] = self.bg5SV2:Find("bgs" .. i .. "/Scroll View")
    end
    self.yjzb:Find("zi1"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10013)
    self.yjzb:Find("zi2"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10014)
    self.yjxl:Find("zi1"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10013)
    self.yjxl:Find("zi2"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10015)
    -- self.ui_CommonAtlas = self.back1:GetComponent(typeof(UISprite)).atlas --公共图集
    -- self.equip_altas = self.bg3:GetComponent(typeof(UISprite)).atlas --装备界面图集
    eqChangeType = 0 --更换整备界面为哪种类型装备
    eqChangeIndex = 0 --更换整备界面为哪件装备Index
    eqInfoType = 0 --装备详情界面为哪种类型装备
    self.eqBg = {}--装备栏按钮Table
    self.ceqTB = {}--右侧装备Table
    
    --所有Scroll View拉动超长后显示黑框
    self.local_eqUseUP = self.eqUse:Find("Scroll View"):GetComponent(typeof(UIPanelEX))
    self.local_eqUseSV = self.eqUse:Find("Scroll View"):GetComponent(typeof(UIScrollView))
    self.local_eqShuXingDiSpr = self.transform:Find("bg2/eqShuXingDi/Sprite").gameObject
    self.local_finalClipRegionW2 = self.local_eqUseUP.finalClipRegion.w * 0.5
    self.local_eqUseSV.onDragStarted = function()
        self.local_eqUseSVisOnStoppedMoving = false
        self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function()
            while self.local_eqUseSVisOnStoppedMoving == false do
                if self.local_eqUseUP.clipOffset.y - self.local_eqUseSV.bounds.min.y - 5 > self.local_finalClipRegionW2 then
                    self.local_eqShuXingDiSpr:SetActive(true)
                else
                    self.local_eqShuXingDiSpr:SetActive(false)
                end
                coroutine.step()
            end
        end)
    end
    self.local_eqUseSV.onStoppedMoving = function()
        self.local_eqUseSVisOnStoppedMoving = true
    end
    
    
    --所有Scroll View拉动超长后显示黑框
    self.local_bg5UP = self.bg5SV2:GetComponent(typeof(UIPanel))
    self.local_bg5SV2 = self.bg5SV2:GetComponent(typeof(UIScrollView))
    self.local_bg5xqtiaoSpr = self.transform:Find("bg1/xqtiao").gameObject
    self.local_bg5finalClipRegionW2 = self.local_bg5UP.finalClipRegion.w * 0.5
    self.local_bg5SV2.onDragStarted = function()
        self.local_bg5SVisOnStoppedMoving = false
        local isL = (self.bg5.localPosition.x < -800)
        self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function()
            while self.local_bg5SVisOnStoppedMoving == false do
                if self.local_bg5UP.clipOffset.y - self.local_bg5SV2.bounds.min.y - 5 > self.local_bg5finalClipRegionW2 then
                    if isL then
                        self.local_bg5xqtiaoSpr:SetActive(true)
                    else
                        self.local_eqShuXingDiSpr:SetActive(true)
                    end
                
                else
                    if isL then
                        self.local_bg5xqtiaoSpr:SetActive(false)
                    else
                        self.local_eqShuXingDiSpr:SetActive(false)
                    end
                end
                coroutine.step()
            end
        end)
    end
    self.local_bg5SV2.onStoppedMoving = function()
        self.local_bg5SVisOnStoppedMoving = true
    end
    
    
    
    --获取3个界面的装备属性各个组件
    self.bgShuXing = {{}, {}, {}}
    local nameT1 = {"bg2/eqShuXingBg/eqShuXing/", "bg3/eqShuXingDi/eqShuXing/", "bg4/eqShuXingDi/eqShuXing/"}
    local ScrollView
    local ScrollViewP
    self.local_ScrollViewSV = {}
    self.local_UP = {}
    self.local_youdi = {}
    self.local_isOnStoppedMoving = {}
    for i = 1, 3 do
        ScrollView = self.transform:Find(nameT1[i] .. "Scroll View")
        --所有Scroll View拉动超长后显示黑框
        self.local_ScrollViewSV[i] = ScrollView:GetComponent(typeof(UIScrollView))
        self.local_UP[i] = ScrollView:GetComponent(typeof(UIPanel))
        self.local_youdi[i] = self.transform:Find(nameT1[i] .. "eqBg/youdi").gameObject
        self.local_ScrollViewSV[i].onDragStarted = function()
            self.local_isOnStoppedMoving[i] = false
            self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function(co)
                while self.local_isOnStoppedMoving[i] == false do
                    if self.local_UP[i].clipOffset.y < -5 then
                        self.local_youdi[i]:SetActive(true)
                    else
                        self.local_youdi[i]:SetActive(false)
                    end
                    coroutine.step()
                end
            end)
        end
        self.local_ScrollViewSV[i].onStoppedMoving = function()
            self.local_isOnStoppedMoving[i] = true
        end
        
        
        ScrollViewP = ScrollView.parent
        self.bgShuXing[i].EqBgSprSprite = ScrollViewP:Find("eqBg"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].EqSprSprite = ScrollViewP:Find("eqBg/eqSpr"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].EQLevelLabel = ScrollViewP:Find("eqBg/level"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].eqName = ScrollViewP:Find("eqBg/nameBg/eqName"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingMain = ScrollView:Find("shuxingMain"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingFuJia1 = ScrollView:Find("shuxingFuJia1"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingFuJia2 = ScrollView:Find("shuxingFuJia2"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingFuJia3 = ScrollView:Find("shuxingFuJia3"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingFuJia4 = ScrollView:Find("shuxingFuJia4"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingFuJia5 = ScrollView:Find("shuxingFuJia5"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingFuJia1SuoSpr = ScrollView:Find("shuxingFuJia1/suoSpr"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].shuxingFuJia2SuoSpr = ScrollView:Find("shuxingFuJia2/suoSpr"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].shuxingFuJia3SuoSpr = ScrollView:Find("shuxingFuJia3/suoSpr"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].shuxingFuJia4SuoSpr = ScrollView:Find("shuxingFuJia4/suoSpr"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].shuxingFuJia5SuoSpr = ScrollView:Find("shuxingFuJia5/suoSpr"):GetComponent(typeof(UISprite))
        self.bgShuXing[i].shuxingSuit1 = ScrollView:Find("shuxingSuit1"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingSuit2 = ScrollView:Find("shuxingSuit2"):GetComponent(typeof(UILabel))
        self.bgShuXing[i].shuxingSuit3 = ScrollView:Find("shuxingSuit3"):GetComponent(typeof(UILabel))
    end
    
    
    local eqUIGrid = self.eqGrid:GetComponent(typeof(UIGrid))
    self.eqUIGridWHL = {cellWidth = eqUIGrid.cellWidth, cellHeight = eqUIGrid.cellHeight, maxPerLine = eqUIGrid.maxPerLine}
    
    --state1  右侧为装备详情界面
    --state2  右侧为更换装备界面
    --state4  左侧为单独装备详情界面，右侧为更换装备界面
    --state6  左左侧为单独装备详情界面，左右侧为待更换的装备详情界面，右侧为更换装备界面
    --state11 左右侧为待更换的装备详情界面，右侧为更换装备界面
    -- --state12 无任何界面弹出，
    -- --state13 无任何界面弹出，
    --状态机
    simple_state_machine = require("common/simple_state_machine")
    self.simple_state_machine = simple_state_machine()
    self.simple_state_machine:setup_state({
        initial = "state1",
        events = {
            {name = "change1", from = "state1", to = "state1"},
            {name = "change1", from = "state2", to = "state1"},
            {name = "change1", from = "state4", to = "state1"},
            {name = "change1", from = "state11", to = "state1"},
            {name = "change2", from = "state1", to = "state2"},
            {name = "change2", from = "state2", to = "state2"},
            {name = "change2", from = "state4", to = "state2"},
            {name = "change2", from = "state6", to = "state2"},
            {name = "change2", from = "state11", to = "state2"},
            {name = "change4", from = "state2", to = "state4"},
            {name = "change6", from = "state2", to = "state6"},
            {name = "change6", from = "state4", to = "state6"},
            {name = "change6", from = "state6", to = "state6"},
            {name = "change6", from = "state11", to = "state6"},
            {name = "change11", from = "state2", to = "state11"},
            {name = "change11", from = "state11", to = "state11"},
        -- {name = "change", from = "state", to = "state"},
        -- {name = "change", from = "state", to = "state"},
        },
        callbacks = {
            onbeforechange1 = function(event)
                if event.from == "state2" then
                    self:seteqUseDiSpr(false)
                    self.eqShuXingBg.gameObject:SetActive(true)
                elseif event.from == "state4" then
                    self.bg3.gameObject:SetActive(false)
                    self:seteqUseDiSpr(false)
                    self.eqShuXingBg.gameObject:SetActive(true)
                elseif event.from == "state11" then
                    self.bg4.gameObject:SetActive(false)
                    self:seteqUseDiSpr(false)
                    self.eqShuXingBg.gameObject:SetActive(true)
                end
                self.info.localPosition = self.lastInfoP
                
                self:setbg5DiSpr(false)
                local i = event.args[1]
                if i then
                    eqInfoType = i
                    self.nowEqBgEqSpr.gameObject:SetActive(true)
                    self.nowEqBgLevel.gameObject:SetActive(true)
                    
                    self:setEqView(1, equipP.nowEqList[i])
                end
            end,
            onbeforechange2 = function(event)
                if self.bg5.localPosition.x < -800 or event.from == "state2" then
                    self:seteqUseDiSpr(true)
                    self:setbg5DiSpr(false)
                end
                local i = event.args[1]
                if i then
                    eqChangeType = i
                    if equipP.nowEqList[i] == 0 then --如果点的是空的装备栏
                        self.xiexia.gameObject:SetActive(false)
                    else
                        self.xiexia.gameObject:SetActive(true)
                    end
                    self:setEQUse(i)
                end
                
                --顺序很重要，一定要在设置完uiscrollview内容后在SetActive(true)
                if event.from == "state1" then
                    self:seteqUseDiSpr(true)
                    self.eqShuXingBg.gameObject:SetActive(false)
                    self.info.localPosition = Vector3(1128, -1056.5, 0)
                elseif event.from == "state4" then
                    self.bg3.gameObject:SetActive(false)
                elseif event.from == "state6" then
                    self.bg3.gameObject:SetActive(false)
                    self.bg4.gameObject:SetActive(false)
                elseif event.from == "state11" then
                    self.bg4.gameObject:SetActive(false)
                end
            
            end,
            onbeforechange4 = function(event)
                local i = event.args[1]
                if i ~= eqChangeType then
                    self:setbg5DiSpr(false)
                end
                
                if i then
                    if self.eqBg[i].localPosition.x < 400 then
                        self.bg3eqShuXingDi.localPosition = self.bg34P[2]
                    else
                        self.bg3eqShuXingDi.localPosition = self.bg34P[1]
                    end
                    self:setEqView(2, equipP.nowEqList[i])
                end
                
                if event.from == "state2" then
                    self.bg3.gameObject:SetActive(true)
                end
            end,
            onbeforechange6 = function(event)
                self.bg3.gameObject:SetActive(true)
                self.bg4.gameObject:SetActive(true)
                
                self:setbg5DiSpr(false)
                self.bg3eqShuXingDi.localPosition = self.bg34P[1]
                self.bg4eqShuXingDi.localPosition = self.bg34P[2]
                
                local i = event.args[1]
                local v = event.args[2]
                if i then
                    self:setEqView(2, equipP.nowEqList[i])
                    self:setEqView(3, v)
                end
            end,
            onbeforechange11 = function(event)
                self.bg4.gameObject:SetActive(true)
                self.bg4eqShuXingDi.localPosition = self.bg34P[2]
                self:setbg5DiSpr(false)
                local v = event.args[1]
                if v then
                    self:setEqView(3, v)
                end
            end,
        }
    })
    
    
    
    local tempCount = 0 ----如果一件穿戴着的装备都没有的处理(跳转到更换装备界面)
    for i = 1, 8 do
        self.eqBg[i] = self.transform:Find("bg1/eqBg" .. i)--装备栏bg
        if equipP.nowEqList[i] == 0 then --当装备栏未穿戴任何装备
            ZUOCEZHUANGBEI(1, i)
        else --当装备栏穿戴了装备
            if tempCount == 0 then --只要穿了一件装备，右侧装备详情信息不为空，且为第一个不为空的装备信息
                tempCount = tempCount + 1
                eqInfoType = i
                self:setEqView(1, equipP.nowEqList[i])
            end
            setEqIconView(self.eqBg[i], equipP.nowEqList[i])
        end
        UIEventListener.Get(self.eqBg[i].gameObject).onClick = function(go)
            if (self.eqShuXingBg.gameObject.activeSelf and i == eqInfoType) or (self.eqUse.gameObject.activeSelf and i == eqChangeType and equipP.nowEqList[i] == 0) then
                return
            end
            
            self.selectKuang.localPosition = self.eqBg[i].localPosition
            local _current = self.simple_state_machine._current
            if _current == "state1" then
                if equipP.nowEqList[i] == 0 then --如果点的是空的装备栏
                    self.simple_state_machine:do_event("change2", i)
                else
                    self.simple_state_machine:do_event("change1", i)
                end
            elseif _current == "state2" then
                if equipP.nowEqList[i] == 0 then --如果点的是空的装备栏
                    self.simple_state_machine:do_event("change2", i)
                elseif eqChangeType == i then
                    self.simple_state_machine:do_event("change4", i)
                else
                    self.simple_state_machine:do_event("change1", i)
                end
            elseif _current == "state4" then
                if equipP.nowEqList[i] == 0 then --如果点的是空的装备栏
                    self.simple_state_machine:do_event("change2", i)
                elseif eqChangeType ~= i then
                    self.simple_state_machine:do_event("change1", i)
                end
            elseif _current == "state11" then
                if equipP.nowEqList[i] == 0 then --如果点的是空的装备栏
                    self.simple_state_machine:do_event("change2", i)
                else
                    self.simple_state_machine:do_event("change1", i)
                end
            end
        end
    end
    
    if tempCount == 0 then ----如果一件穿戴着的装备都没有的处理(跳转到更换装备界面)
        self.simple_state_machine:do_event("change2", 1)
    end
    
    
    if tempCount == 0 then --如果一件穿戴着的装备都没有的处理(右侧装备详情信息为空)
        self.nowEqBgEqSpr.gameObject:SetActive(false)
        self.nowEqBgLevel.gameObject:SetActive(false)
    end
    
    
    UIEventListener.Get(self.back1.gameObject).onClick = function(go)
        ui_manager:ShowWB(WNDTYPE.Login)
    end
    UIEventListener.Get(self.info.gameObject).onClick = function(go)--详情按钮
            --TODODO
            -- local value = equipP.allEqList[1][4]
            -- value.IsBad = 0
            -- equipP.change_allEqList(1, 4, value)
            --TODODO
            -- local t = os.clock()
            -- local a = {100, 200, 300, 400}
            -- for i = 1, 10000000 do
            --     -- local a, b, c, d = a[1],a[2],a[3],a[4]
            --     local a, b, c, d = unpack(a)
            -- end
            -- lgyPrint((os.clock() - t) .. "")
            -- TODODO
            -- local value = equipP.nowEqList[1]
            -- value.QiangHuaLevel = value.QiangHuaLevel + 1
            -- equipP.change_nowEqList(1, value)
            --------------------------------------------
            if self.eqShuXingBg.gameObject.activeSelf then --如果详情按钮在左边
                if self.bg5.gameObject.activeSelf then --如果详情界面已经打开
                    self:setbg5DiSpr(false)
                else --如果详情界面没有打开
                    self.bg5.localPosition = self.lastbg5P
                    self:setAllInfo()
                    self:setbg5DiSpr(true)
                end
            
            else --如果详情按钮在右边
                if self.eqUse.gameObject.activeSelf then --如果正在显示更换装备界面
                    self:seteqUseDiSpr(false)
                    self:setAllInfo()
                    self.bg5.localPosition = Vector3(-565, -330, 0)
                    self:setbg5DiSpr(true)
                else --如果正在显示详情界面
                    self:setbg5DiSpr(false)
                    self:seteqUseDiSpr(true)
                end
            end
    end
    UIEventListener.Get(self.shizhuang.gameObject).onClick = function(go)
        end
    UIEventListener.Get(self.yjzb.gameObject).onClick = function(go)
        end
    UIEventListener.Get(self.yjxl.gameObject).onClick = function(go)
            --TODODO
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
            equipP.add_allEqList(1, equipM(1, 10001, 1, 6, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}))
    end
    UIEventListener.Get(self.fenxiang.gameObject).onClick = function(go)
        end
    UIEventListener.Get(self.genghuan.gameObject).onClick = function(go)
        if self.simple_state_machine._current == "state1" then
            self.simple_state_machine:do_event("change2", eqInfoType)
        end
    end
    UIEventListener.Get(self.suoding.gameObject).onClick = function(go)
        end
    UIEventListener.Get(self.eqShuXingXieXia.gameObject).onClick = function(go)
        equipP.add_allEqListOfXieXia(eqInfoType, equipP.nowEqList[eqInfoType])
        equipP.remove_nowEqList(eqInfoType)
        self.simple_state_machine:do_event("change2", eqInfoType)--跳转到更换装备界面
    end
    UIEventListener.Get(self.xiexia.gameObject).onClick = function(go)
        self.simple_state_machine:do_event("change2", eqInfoType)--跳转到更换装备界面
        self.xiexia.gameObject:SetActive(false)
        equipP.add_allEqListOfXieXia(eqChangeType, equipP.nowEqList[eqChangeType])
        equipP.remove_nowEqList(eqChangeType)
    end
    UIEventListener.Get(self.bg4genghuan.gameObject).onClick = function(go)
        local v = equipP.allEqList[eqChangeType][eqChangeIndex]
        if equipP.nowEqList[eqChangeType] == 0 then --如果装备栏上没有装备
            equipP.add_nowEqList(eqChangeType, v)
            equipP.remove_allEqList(eqChangeType, v)
        else
            equipP.exchange_EqList(eqChangeType, equipP.nowEqList[eqChangeType], v)
        end
        
        self.simple_state_machine:do_event("change2")
    end
    UIEventListener.Get(self.battleWidget.gameObject).onPress = function(go, args)--点击空白区域回调
        if args then
            if self.battleWidget.depth == -99 then
                self:dianjikongbai()
            end
        end
    end
    
    UIEventListener.Get(self.qianghua.gameObject).onClick = function(go)
        iseqShuXingBg = true
        ui_manager:ShowWB(WNDTYPE.ui_chongzhu)
    --TODODO 直接重铸
    -- local v = equipP.nowEqList[eqInfoType]
    -- local maxLevel = (v.EquipQuality - 1) * 3
    -- if v.IsBad == 1 then --修理
    --     elseif maxLevel == v.QiangHuaLevel then --重铸
    --     else --强化
    --         end
    end
    
    UIEventListener.Get(self.bg4Qianghua.gameObject).onClick = function(go)
        iseqShuXingBg = false
        ui_manager:ShowWB(WNDTYPE.ui_chongzhu)
    --TODODO 直接重铸
    -- local v = equipP.allEqList[eqChangeType][eqChangeIndex]
    -- local maxLevel = (v.EquipQuality - 1) * 3
    -- if v.IsBad == 1 then --修理
    --     elseif maxLevel == v.QiangHuaLevel then --重铸
    --     else --强化
    --         end
    end
    
    UIEventListener.Get(self.eqUse.gameObject).onPress = function(go, args)
        if args then
            self.simple_state_machine:do_event("change2")--跳转到更换装备界面
        end
    end
    
    UIEventListener.Get(playerModelTexture.gameObject).onPress = function(go, args)
        if args then
            self:dianjikongbai()
        end
    end
end

function ui_equip:dianjikongbai()
    local _current = self.simple_state_machine._current
    if _current == "state4" or _current == "state6" or _current == "state11" then
        self.simple_state_machine:do_event("change2")
    end
    if self.bg5.localPosition.x < -800 then
        self:setbg5DiSpr(false)
    end
end

--==============================--
--desc:设置详情界面下方黑条显隐
--time:2017-05-03 07:09:47
--@b:
--return
--==============================--
function ui_equip:setbg5DiSpr(b)
    self.bg5.gameObject:SetActive(b)
    if b then
        self.infoJianTouSpr.spriteName = "zhuangbei_jiantou_xiangxishuxing_shouqi"
        if self.local_bg5UP.clipOffset.y - self.local_bg5SV2.bounds.min.y - 5 > self.local_bg5finalClipRegionW2 then
            if self.bg5.localPosition.x < -800 then --左
                self.local_bg5xqtiaoSpr:SetActive(true)
            else --右
                self.local_eqShuXingDiSpr:SetActive(true)
            end
        else
            if self.bg5.localPosition.x < -800 then --左
                self.local_bg5xqtiaoSpr:SetActive(false)
            else --右
                self.local_eqShuXingDiSpr:SetActive(false)
            end
        end
    else
        self.local_bg5SVisOnStoppedMoving = true
        self.infoJianTouSpr.spriteName = "zhuangbei_jiantou_xiangxishuxing_zhankai"
        if self.bg5.localPosition.x < -800 then --左
            self.local_bg5xqtiaoSpr:SetActive(false)
        else --右
            self.local_eqShuXingDiSpr:SetActive(false)
        end
    end


end

--==============================--
--desc:设置装备界面下方黑条显隐
--time:2017-05-03 07:09:05
--@b:
--return
--==============================--
function ui_equip:seteqUseDiSpr(b)
    self.eqUse.gameObject:SetActive(b)
    if b then
        if self.local_eqUseUP.clipOffset.y - self.local_eqUseSV.bounds.min.y - 5 > self.local_finalClipRegionW2 then
            self.local_eqShuXingDiSpr:SetActive(true)
        else
            self.local_eqShuXingDiSpr:SetActive(false)
        end
    else
        self.local_eqUseSVisOnStoppedMoving = true
        self.local_eqShuXingDiSpr:SetActive(false)
    end
end

--设置更换装备界面显示，i为装备类型
function ui_equip:setEQUse(i)
    --删掉之前的obj
    for i = 1, #self.ceqTB do
        Object.Destroy(self.ceqTB[i].gameObject)
    end
    
    self.ceqTB = {}
    --如果卸下按钮隐藏startX = 1
    local startX = self.xiexia.gameObject.activeSelf and 0 or 1
    if #equipP.allEqList[i] ~= 0 then
        for j, v in ipairs(equipP.allEqList[i]) do
            local go = GameObjectExtension.InstantiateFromPacket("ui_equip", "eqBg", self.eqGrid.gameObject)
            setEqIconView(go.transform, v)
            self.ceqTB[#self.ceqTB + 1] = go.transform
            --装备排列
            go.transform.localPosition = Vector3((j - startX) % self.eqUIGridWHL.maxPerLine * self.eqUIGridWHL.cellWidth, -math.modf((j - startX) / self.eqUIGridWHL.maxPerLine) * self.eqUIGridWHL.cellHeight, 0)
            --装备添加触摸
            UIEventListener.Get(go).onClick = function(go)
                eqChangeIndex = table.indexof(equipP.allEqList[i], v)
                if equipP.nowEqList[i] == 0 then --如果对应的装备栏为空
                    self.simple_state_machine:do_event("change11", v)
                else
                    self.simple_state_machine:do_event("change6", i, v)
                end
            end
        end
    end
    self.local_eqUseUP:reset()
end

--==============================--
--desc:设置详情界面显示内容
--time:2017-05-03 08:54:52
--return
--==============================--
function ui_equip:setAllInfo()
    for i = 0, self.bg51Grid.childCount - 1 do
        local child = self.bg51Grid:GetChild(i)
        Object.Destroy(child.gameObject)
    end
    
    local v
    local tf
    local ul
    local tempInt = 0
    for i = 1, #equipP.nowEqList do
        v = equipP.nowEqList[i]
        if v ~= 0 then
            --显示主属性
            tf = GameObjectExtension.InstantiateFromPacket("ui_equip", "shuxing", self.bg51Grid.gameObject).transform
            ul = tf:GetComponent(typeof(UILabel))
            ul.text = sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, v.MainEffectID) .. "+" .. sdata_EquipPlan_data[sdata_equip_data:GetV(sdata_equip_data.I_MainAttribute, v.EquipID)][v.MainEffectID].up .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, v.MainEffectID)
            tf.localPosition = Vector3(tempInt % self.bg51GridWHL.maxPerLine * self.bg51GridWHL.cellWidth, -math.modf(tempInt / self.bg51GridWHL.maxPerLine) * self.bg51GridWHL.cellHeight, 0)
            tempInt = tempInt + 1
            
            --显示附加属性
            for j, v in ipairs(v.ViceEffect) do
                tf = GameObjectExtension.InstantiateFromPacket("ui_equip", "shuxing", self.bg51Grid.gameObject).transform
                ul = tf:GetComponent(typeof(UILabel))
                ul.text = sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, v.ShuXingID) .. "+" .. v.ShuXingNum .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, v.ShuXingID)
                tf.localPosition = Vector3(tempInt % self.bg51GridWHL.maxPerLine * self.bg51GridWHL.cellWidth, -math.modf(tempInt / self.bg51GridWHL.maxPerLine) * self.bg51GridWHL.cellHeight, 0)
                tempInt = tempInt + 1
            end
        end
    end
    
    
    
    tempInt = 0
    local str = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10002)
    local effectID
    for k, v in pairs(self.suitData) do
        if v > 1 then
            tempInt = tempInt + 1
            local lp = Vector3(-162, 62, 0)
            local height = -6
            
            for i = 0, self.suitSV[tempInt].childCount - 1 do
                local child = self.suitSV[tempInt]:GetChild(i)
                Object.Destroy(child.gameObject)
            end
            self.suitSV[tempInt].parent.gameObject:SetActive(true)
            if v > 1 then --2件套属性
                effectID = sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_SuitEffect2, k)
                tf = GameObjectExtension.InstantiateFromPacket("ui_equip", "suitshuxing", self.suitSV[tempInt].gameObject).transform
                ul = tf:GetComponent(typeof(UILabel))
                ul.text = string.gsub(str, "#N", 2) .. sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, effectID) .. "+" .. sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_Effect2Point, k) .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, effectID)
                tf.localPosition = Vector3(lp.x, lp.y - height - 6, lp.z)
                height = ul.height
                lp = tf.localPosition
            end
            if v > 2 then --3件套属性
                effectID = sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_SuitEffect3, k)
                tf = GameObjectExtension.InstantiateFromPacket("ui_equip", "suitshuxing", self.suitSV[tempInt].gameObject).transform
                ul = tf:GetComponent(typeof(UILabel))
                ul.text = string.gsub(str, "#N", 3) .. sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, effectID) .. "+" .. sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_Effect3Point, k) .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, effectID)
                tf.localPosition = Vector3(lp.x, lp.y - height - 6, lp.z)
                height = ul.height
                lp = tf.localPosition
            end
            if v > 4 then --5件套属性
                effectID = sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_SuitEffect5, k)
                tf = GameObjectExtension.InstantiateFromPacket("ui_equip", "suitshuxing", self.suitSV[tempInt].gameObject).transform
                ul = tf:GetComponent(typeof(UILabel))
                ul.text = string.gsub(str, "#N", 5) .. sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, effectID) .. "+" .. sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_Effect5Point, k) .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, effectID)
                tf.localPosition = Vector3(lp.x, lp.y - height - 6, lp.z)
                height = ul.height
                lp = tf.localPosition
            end
        end
    end
    
    for i = tempInt + 1, 4 do
        self.suitSV[i].parent.gameObject:SetActive(false)
    end
end



--设置装备图标显示 tf为transform v为详情table
function setEqIconView(tf, v)
    tf:GetComponent(typeof(UISprite)).spriteName = pingzhiName[v.EquipQuality]
    local sprite = tf:Find("eqSpr"):GetComponent(typeof(UISprite))
    tf:Find("eqSpr"):GetComponent(typeof(UISprite)).spriteName = sdata_equip_data:GetV(sdata_equip_data.I_EquipIcon, v.EquipID)
    if v.IsBad == 1 then
        sprite.color = badColor
    else
        sprite.color = Color(1, 1, 1, 1)
    end
    tf:Find("level"):GetComponent(typeof(UILabel)).text = "lv" .. v.QiangHuaLevel
end

--设置装备详情显示 v为详情table
function ui_equip:setEqView(i, v)
    self.bgShuXing[i].EqSprSprite.spriteName = sdata_equip_data:GetV(sdata_equip_data.I_EquipIcon, v.EquipID)
    if v.IsBad == 1 then
        self.bgShuXing[i].EqSprSprite.color = badColor
    else
        self.bgShuXing[i].EqSprSprite.color = Color(1, 1, 1, 1)
    end
    self.bgShuXing[i].EqBgSprSprite.spriteName = pingzhiName[v.EquipQuality]
    self.bgShuXing[i].EQLevelLabel.text = "lv" .. v.QiangHuaLevel
    self.bgShuXing[i].eqName.text = sdata_equip_data:GetV(sdata_equip_data.I_EquipName, v.EquipID)
    self.bgShuXing[i].eqName.color = eqNameColor[v.EquipQuality]
    
    --设置主属性
    self.bgShuXing[i].shuxingMain.text = sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, v.MainEffectID) .. "+" .. sdata_EquipPlan_data[sdata_equip_data:GetV(sdata_equip_data.I_MainAttribute, v.EquipID)][v.MainEffectID].up .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, v.MainEffectID)
    
    
    --设置附加属性
    for j, v in ipairs(v.ViceEffect) do
        self.bgShuXing[i]["shuxingFuJia" .. j].enabled = true
        self.bgShuXing[i]["shuxingFuJia" .. j .. "SuoSpr"].gameObject:SetActive(false)
        self.bgShuXing[i]["shuxingFuJia" .. j].text = sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, v.ShuXingID) .. "+" .. v.ShuXingNum .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, v.ShuXingID)
    end
    local str = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10001)
    for j = #v.ViceEffect + 1, v.EquipQuality - 1 do
        self.bgShuXing[i]["shuxingFuJia" .. j].enabled = true
        self.bgShuXing[i]["shuxingFuJia" .. j .. "SuoSpr"].gameObject:SetActive(true)
        self.bgShuXing[i]["shuxingFuJia" .. j].text = string.gsub(str, "#N", tostring(j * 3))
    end
    for j = v.EquipQuality, 5 do
        self.bgShuXing[i]["shuxingFuJia" .. j].enabled = false
        self.bgShuXing[i]["shuxingFuJia" .. j .. "SuoSpr"].gameObject:SetActive(true)
    end
    
    --设置套装属性
    local suitID = sdata_equip_data:GetV(sdata_equip_data.I_SuitID, v.EquipID)
    local effectID2 = sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_SuitEffect2, suitID)
    local effectID3 = sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_SuitEffect3, suitID)
    local effectID5 = sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_SuitEffect5, suitID)
    
    str = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10002)
    self.bgShuXing[i]["shuxingSuit" .. 1].text = string.gsub(str, "#N", 2) .. sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, effectID2) .. "+" .. sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_Effect2Point, suitID) .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, effectID2) .. "32432222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222"
    self.bgShuXing[i]["shuxingSuit" .. 2].text = string.gsub(str, "#N", 3) .. sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, effectID3) .. "+" .. sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_Effect3Point, suitID) .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, effectID3)
    self.bgShuXing[i]["shuxingSuit" .. 3].text = string.gsub(str, "#N", 5) .. sdata_attribute_data:GetV(sdata_attribute_data.I_AttributeName, effectID5) .. "+" .. sdata_equipsuit_data:GetV(sdata_equipsuit_data.I_Effect5Point, suitID) .. sdata_attribute_data:GetV(sdata_attribute_data.I_Symbol, effectID5)
    
    local lp = self.bgShuXing[i]["shuxingSuit" .. 1].transform.localPosition
    self.bgShuXing[i]["shuxingSuit" .. 2].transform.localPosition = Vector3(lp.x, self.bgShuXing[i]["shuxingSuit" .. 1].transform.localPosition.y - self.bgShuXing[i]["shuxingSuit" .. 1].height - 6, lp.z)
    self.bgShuXing[i]["shuxingSuit" .. 3].transform.localPosition = Vector3(lp.x, self.bgShuXing[i]["shuxingSuit" .. 2].transform.localPosition.y - self.bgShuXing[i]["shuxingSuit" .. 2].height - 6, lp.z)
    
    if self.suitData[suitID] == nil then
        self.suitData[suitID] = 0
    end
    local tempInt = self.suitData[suitID]--已穿戴套装件数
    if i == 3 then --如果是背包中的装备
        local isAdd = true
        if equipP.nowEqList[eqChangeType] ~= 0 then --如果该装备位有装备
            local suitID2 = sdata_equip_data:GetV(sdata_equip_data.I_SuitID, equipP.nowEqList[eqChangeType].EquipID)
            if suitID == suitID2 then --如果待替换的两件装备属于同一套装
                isAdd = false
            end
        end
        if isAdd then --如果待替换的两件装备不属于同一套装则显示装备后多出的套装属性
            tempInt = tempInt + 1
        end
    end
    if tempInt > 1 then --2件套属性
        self.bgShuXing[i]["shuxingSuit" .. 1].color = suitColor
    else
        self.bgShuXing[i]["shuxingSuit" .. 1].color = suitColorGray
    end
    if tempInt > 2 then --3件套属性
        self.bgShuXing[i]["shuxingSuit" .. 2].color = suitColor
    else
        self.bgShuXing[i]["shuxingSuit" .. 2].color = suitColorGray
    end
    if tempInt > 4 then --5件套属性
        self.bgShuXing[i]["shuxingSuit" .. 3].color = suitColor
    else
        self.bgShuXing[i]["shuxingSuit" .. 3].color = suitColorGray
    end
    
    --设置强化按钮
    local qianghua
    local jiageUL
    local maxLevel = (v.EquipQuality - 1) * 3
    if maxLevel == 0 then
        maxLevel = -1
    end
    if i ~= 2 then
        if i == 1 then
            qianghua = self.qianghua
            jiageUL = self.qianghuaJiaGeUL
        else
            qianghua = self.bg4Qianghua
            jiageUL = self.bg4QianghuaJiaGeUL
        end
        
        if v.IsBad == 1 then --修理
            qianghua:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10005)
        elseif maxLevel == v.QiangHuaLevel then --重铸
            qianghua:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10004)
        else --强化
            qianghua:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10003)
            if v.EquipQuality == 1 then --品质1不可强化
                jiageUL.text = "0"
            else
                jiageUL.text = v.QiangHuaLevel * 100
            end
        end
    end
end


function ui_equip:setSuitData()
    self.suitData = {}--当前穿戴套装数据
    for i = 1, #equipP.nowEqList do
        if equipP.nowEqList[i] ~= 0 then
            local suitID = sdata_equip_data:GetV(sdata_equip_data.I_SuitID, equipP.nowEqList[i].EquipID)
            if self.suitData[suitID] == nil then
                self.suitData[suitID] = 0
            end
            self.suitData[suitID] = self.suitData[suitID] + 1
        end
    end
end


--装备的排序规则：装备损坏程度>装备品质>装备强化等级>随机排序，按以上层级，由高到低排序
function sortEqList(i)
    table.sort(equipP.allEqList[i], function(ta, tb)
        if ta.IsBad == tb.IsBad then
            if ta.EquipQuality == tb.EquipQuality then
                return ta.QiangHuaLevel > tb.QiangHuaLevel
            else
                return ta.EquipQuality > tb.EquipQuality
            end
        else
            return ta.IsBad < tb.IsBad
        end
    end)
end

function ui_equip:OnDestroyDoneEnd()
    self.myTexture:Release()
end

function ui_equip:OnAddHandler()
    --注册玩家下兵事件
    Event.AddListener(GameEventType.ZUOCEZHUANGBEI, ZUOCEZHUANGBEI)
    Event.AddListener(GameEventType.YOUCEZHUANGBEI, YOUCEZHUANGBEI)
    Event.AddListener(GameEventType.EXCHANGEZHUANGBEI, EXCHANGEZHUANGBEI)
end
function ui_equip:OnRemoveHandler()
    Event.RemoveListener(GameEventType.ZUOCEZHUANGBEI, ZUOCEZHUANGBEI)
    Event.RemoveListener(GameEventType.YOUCEZHUANGBEI, YOUCEZHUANGBEI)
    Event.RemoveListener(GameEventType.EXCHANGEZHUANGBEI, EXCHANGEZHUANGBEI)
end
return ui_equip
