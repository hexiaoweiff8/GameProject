local class = require("common/middleclass")
local ui_fight = class("ui_fight", wnd_base)
local whiteColor = Color(1, 1, 1, 1)
local grayColor = Color(169 / 255, 169 / 255, 169 / 255, 1)
function Onfs()
    ui_manager:ShowWB(WNDTYPE.ui_fight)
end

--local isPress = false
local selectedCardItem = nil
function ui_fight:OnShowDone()
    math.newrandomseed()

    --DP_Battlefield.Single:LoadBase()
    local time_txt = self.transform:Find("time_bg/txt"):GetComponent("UILabel")
    --战斗计时器
    self.TimeTickerTb[1] = startTimer(5 * 60,
        function(timer)
            local tempInt = math.ceil(timer.OverTime)
            time_txt.text = string.format("%02d", math.modf(tempInt / 60)) .. ":" .. string.format("%02d", tempInt % 60)
        end,
        function(timer)--完成回调
            time_txt.text = "00:00"
        end)
    local myBloodBar = self.transform:Find("defence_widget1/bg/hp_fg"):GetComponent("UISprite")
    --    myBloodBar.fillAmount = 0.5
    local localEnemypaiStr = "101001,101002,101003,101004,101005,101006,101007,101008,101009,101001,101002,101003,101004,101005,101006,101007,101008,101009"
    --剩余敌人牌库
    self.enemyPaiKutb = string.splitToInt(localEnemypaiStr, ",")
    --打乱敌人牌库
    table.upset(self.enemyPaiKutb)
    local localpaiStr = "101001,101002,101003,101004,101005,101006,101007,101008,101009,101001,101002,101003,101004,101005,101006,101007,101008,101009"
    -- -- localpaiStr = "1,2,3,4,5,6"
    --剩余牌库
    self.paiKutb = string.splitToInt(localpaiStr, ",")  
    --打乱牌库
    table.upset(self.paiKutb)
    --当前手牌库
    self.nowHandpaiKutb = {}
    --取前4张为手牌库
    for i = 1, 4 do
        self.nowHandpaiKutb[i] = self.paiKutb[1]
        table.remove(self.paiKutb, 1)
    end
    --牌库UI
    self.paiKuBg = self.transform:Find("paiKuBg")
    --牌库显示
    UIEventListener.Get(self.transform:Find("shengyu_bg").gameObject).onPress = function(go, args)
        if args then -- 开启协程
            --设置牌库信息
            self:getPaiKuPerCardNum();
            self.paiKuBg.gameObject:SetActive(true)
        else -- 停止协程
            self.paiKuBg.gameObject:SetActive(false)
        end
    end
    self.transform:Find("shengyu_bg/curBingLi"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10031)
    
    --剩余兵力值
    self.sumLastBingLi = 0
    for i = 2, #self.paiKutb do
        --print("test" .. self.paiKutb[i])
        self.sumLastBingLi = self.sumLastBingLi + sdata_armycardbase_data:GetFieldV("TrainCost", self.paiKutb[i])
    end
    --剩余兵力Label
    self.allBingLiLabel = self.transform:Find("shengyu_bg/allBingLi"):GetComponent(typeof(UILabel))
    self.allBingLiLabel.text = self.sumLastBingLi
    -- UI卡牌框数
    self.uiCardNum = 4
    -- UI技能框数
    self.uiSkillNum = 3
    -- PTZCamera相机
    self.PTZCameraTf = GameObject.Find("/PTZCamera").transform
    -- 相机移动BoxScrollObject
    self.BoxScrollObject = self.PTZCameraTf:GetComponent(typeof(BoxScrollObject))
    -- 当前3d相机
    self.nowWorldCamera = self.PTZCameraTf:Find("SceneryCamera"):GetComponent(typeof(UnityEngine.Camera))
    -- 当前UI相机
    self.nowUICamera = GameObject.Find("/UIRoot/Camera_UI"):GetComponent(typeof(UnityEngine.Camera))
    -- DragDropRoot
    self.DragDropRoot = GameObject.Find("/UIRoot/DragDropRoot").transform
    -- 装载ui卡牌的panel
    self.currentCards_bg = self.transform:Find("currentCards_bg")
    -- 下一张卡牌的UISprite
    self.transform:Find("nextCard_bg"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10032)
    self.nextCardSpr = self.transform:Find("nextCard_bg/nextCard/cardSprite"):GetComponent(typeof(UISprite))
    self.nextCardSpr.spriteName = sdata_armycardbase_data:GetFieldV("IconID", self.paiKutb[1])
    -- 下一张卡牌的UILabel
    self.nextCardLabel = self.transform:Find("nextCard_bg/nextCard/feiBg/costLabel"):GetComponent(typeof(UILabel))
    self.nextCardLabel.text = sdata_armycardbase_data:GetFieldV("TrainCost", self.paiKutb[1])
    self.feiBarSpr = self.currentCards_bg:Find("feiBg/feiBar"):GetComponent(typeof(UISprite))
    self.feiBar2Spr = self.currentCards_bg:Find("feiBg/feiBar2"):GetComponent(typeof(UISprite))
    self.feiBar3Spr = self.currentCards_bg:Find("feiBg/feiBar3"):GetComponent(typeof(UISprite))
    self.feiBar4Spr = self.currentCards_bg:Find("feiBg/feiBar4"):GetComponent(typeof(UISprite))
    self.feiBg2 = self.currentCards_bg:Find("feiBg/feiBg2")
    self.feiBg4 = self.currentCards_bg:Find("feiBg/feiBg4")
    --总费Label
    self.allFeiLabel = self.feiBg2:Find("allFeiLabel"):GetComponent(typeof(UILabel))
    --当前费Label
    self.nowFeiLabel = self.feiBg2:Find("nowFeiLabel"):GetComponent(typeof(UILabel))
    --总费
    self.allFei = 1000; self.allFeiLabel.text = self.allFei .. ""
    --当前费
    self.nowFei = 500; self.nowFeiLabel.text = self.nowFei .. ""
    --敌人总费
    self.enemyAllFei = 1000
    --敌人当前费
    self.enemyNowFei = 900
    -- 拖动中的卡牌table
    self.onPressMyCardtb = {}
    -- 下方卡牌缩放间距
    self.onPressMyCardSpantb = {}
    -- 拖动中的卡牌模型table
    self.onPressArmytb = {}
    -- UI卡牌table
    self.nowMyCardtb = {}
    -- UI卡牌CDtable
    self.nowMyCardCDtbUISpritetb = {}
    -- UI技能table
    self.uiSkilltb = {}
    -- UI卡牌原始位置
    self.myCardConstPostb = {}
    -- 下方下牌边框
    self.downCardY = -190
    -- 上方下牌边框
    self.upCardY = 190
    -- 卡牌缩放间距
    self.cardScaleSpan = 67
    -- UI卡牌原始位置
    self.myCardConstPostb = {}
    -- 卡牌信息tf
    self.cardInfoBg = self.transform:Find("cardInfoBg")
    -- 敌方出的卡牌Grid
    self.enemyUsedCardsGridTf = self.transform:Find("enemyUsedCardsGrid")
    -- 敌方出的卡牌Grid组件
    self.enemyUsedCardsGrid = self.transform:Find("enemyUsedCardsGrid"):GetComponent(typeof(UIGrid))
    -- 敌方出的卡牌
    self.enemyUsedCard = self.enemyUsedCardsGridTf:Find("enemyUsedCard")
    -- 相机跟随UIFollow
    self.UIFollow = self.PTZCameraTf:GetComponent(typeof(UIFollow))
    -- 敌方下次出的卡牌ID
    self.nextEnemyCardID = nil
    -- 敌方下次出的卡牌费
    self.nextEnemyCardFei = nil
    -- 是否暂停
    self.ispause = false
    -- 暂停按钮
    self.btn_pause = self.transform:Find("btn_pause")
    -- 暂停倒计时
    self.daojishi = self.transform:Find("daojishi")
    -- 卡牌大碰撞框
    self.bigCardBoxCollider = {}
    -- 卡牌选中状态
    self.isCardSelected = {false, false, false, false}
    --myTouchCount
    self.myTouchCount = 0
    --HUDText
    self.hudtext = self.transform:Find("HUDText"):GetComponent(typeof(HUDText))
    --兵阵型右边最宽距离
    self.maxSpan = {}
    --组ID
    --self.groupIndex = 0
    --费Bounds
    --费barUISprite
    self.feiBg = self.transform:Find("currentCards_bg/feiBg/feiBg")
    local feiUIWidget = self.feiBg:GetComponent(typeof(UIWidget))
    self.feiBg.parent = self.DragDropRoot
    self.feiBounds = Bounds(Vector3(self.feiBg.localPosition.x, self.feiBg.localPosition.y, 0), Vector3(feiUIWidget.width, feiUIWidget.height, 0))
    self.feiBg.parent = self.currentCards_bg
    -- UIRoot的locationScale
    self.urlc = GameObject.Find("/UIRoot").transform.localScale.x
    --不可下兵区域
    self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function()--开场还没加载到所以用协程
        while self.canotRect == nil do
            coroutine.wait(0.1)
            self.canotRect = GameObject.Find("/SceneRoot/canotRectGo")
            if self.canotRect then
                self.maxPointX = self.canotRect.transform.position.x
                --不可下兵区域tf
                self.canotRect = self.canotRect.transform:Find("canotRect")
                --AstarFight
                self.AstarFight = GameObject.Find("/AstarFight"):GetComponent(typeof(AstarFight))
                --可下兵最大X
                self.AstarFight:setMaxX(self.maxPointX)
                --障碍宽度
                self.UnitWidth = self.AstarFight.UnitWidth
                
                
                
                --TODODO 临时卡牌等级表
                self.paiKuLeveltb = {}
                for i = 1, #self.paiKutb do
                    self.paiKuLeveltb[#self.paiKuLeveltb + 1] = i
                end
                --TODODO 临时卡牌等级表
                self.enemyPaiKuLeveltb = {}
                for i = 1, #self.enemyPaiKutb do
                    self.paiKuLeveltb[#self.paiKuLeveltb + 1] = i
                end
                
                for i = 1, #self.enemyPaiKutb do
                    self.paiKutb[#self.paiKutb + 1] = self.enemyPaiKutb[i]
                end
                self.allrenderZhenxingList = self.AstarFight:setAllZhenxingList(self.paiKutb, self.paiKuLeveltb)
            end
        end
        self.AstarFight:InitMap()
    end)
    local cardBoxCollider = self.transform:Find("currentCards_bg/currentCard" .. 1):GetComponent(typeof(UnityEngine.BoxCollider)).size
    -----------------------------------卡牌UI获取
    for var = 1, self.uiCardNum do
        local tf = self.transform:Find("currentCards_bg/currentCard" .. var)
        self.nowMyCardtb[var] = tf
        self.myCardConstPostb[var] = tf.position
        --添加单击屏幕出牌的卡牌大碰撞框
        local sizeY = self.upCardY - self.downCardY
        self.bigCardBoxCollider[var] = tf.gameObject:AddComponent(typeof(UnityEngine.BoxCollider))
        self.bigCardBoxCollider[var].center = Vector3(0, sizeY / 2 + cardBoxCollider.y / 2 + self.cardScaleSpan - 25, 0)
        self.bigCardBoxCollider[var].size = Vector3(3000, sizeY, 1)
        self.bigCardBoxCollider[var].enabled = false
        --添加拖拽脚本
        tf.gameObject:AddComponent(typeof(UIDragObjectEX))
        local go = tf.gameObject
        self.nowMyCardCDtbUISpritetb[var] = tf:Find("CDBar"):GetComponent("UISprite")
        tf:Find("cardSprite"):GetComponent(typeof(UISprite)).spriteName = sdata_armycardbase_data:GetFieldV("IconID", self.nowHandpaiKutb[var])
        tf:Find("feiBg/costLabel"):GetComponent(typeof(UILabel)).text = sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[var])
        local shengyu_bgDelay1Ct
        local isDragedCard
        UIEventListener.Get(tf.gameObject).onDragStart = function(go)
                --拖动事件
                coroutine.stop(self.coroutineTb[shengyu_bgDelay1Ct])
                self.canotRect.gameObject:SetActive(true)
                self.cardInfoBg.gameObject:SetActive(false)
                isDragedCard = true
        end
        UIEventListener.Get(tf.gameObject).onPress = function(go, args)
            if args then
                lgyPrint("点击事件")
                -- 点击事件
                -- 把其他前置状态的牌归位
                isDragedCard = false
                for var2 = 1, self.uiCardNum do
                    -- 如果处于前置状态
                    if self.isCardSelected[var2] then
                        -- 如果卡牌没有点击中
                        if table.indexof(self.onPressMyCardtb, self.nowMyCardtb[var2]) == false then
                            -- 如果不是自己
                            if var ~= var2 then
                                self.isCardSelected[var2] = false
                                TweenPosition.Begin(self.nowMyCardtb[var2].gameObject, Vector3.Distance(self.nowMyCardtb[var2].position, self.myCardConstPostb[var2]) / 2, self.myCardConstPostb[var2], true)
                                self.bigCardBoxCollider[var2].enabled = false
                            end
                        end
                    end
                end
                if self.feiBg2.gameObject.activeSelf == false then
                    self.feiBg2.gameObject:SetActive(true)
                    self.feiBg4.gameObject:SetActive(false)
                end
                self.feiBar2Spr.gameObject:SetActive(true)
                self.nowFeiLabel.color = grayColor
                --触摸数增加
                self.myTouchCount = self.myTouchCount + 1
                self.bigCardBoxCollider[var].enabled = false
                self.arrayIndex = #self.onPressMyCardtb + 1
                --计算下方卡牌缩放间距
                if tf.localPosition.y < 20 then
                    self.onPressMyCardSpantb[self.arrayIndex] = self.cardScaleSpan
                else
                    self.onPressMyCardSpantb[self.arrayIndex] = self.cardScaleSpan - 25
                end
                self.onPressMyCardtb[self.arrayIndex] = tf
                tf.parent = self.DragDropRoot
                self.DragDropRoot.gameObject:SetActive(false)
                self.DragDropRoot.gameObject:SetActive(true)
                if self:isTouchedCard(tf) then
                    --长按显示卡牌信息
                    shengyu_bgDelay1Ct = #self.coroutineTb + 1
                    self.coroutineTb[shengyu_bgDelay1Ct] = coroutine.start(function()
                        coroutine.wait(0.5)
                        self.cardInfoBg.gameObject:SetActive(true)
                        self.cardInfoBg.localPosition = tf.localPosition + Vector3(0, 100, 0)
                        shengyu_bgDelay1Ct = nil
                    end)
                else
                    tf.localPosition = self.danjiPosition
                end
                --生成模型
                local ct = self:getModel(self.nowHandpaiKutb[var])
                -- ct.localScale = Vector3.zero
                -- ct.gameObject:SetActive(true)
                self.onPressArmytb[self.arrayIndex] = ct
            else --松开卡牌
                if shengyu_bgDelay1Ct then
                    coroutine.stop(self.coroutineTb[shengyu_bgDelay1Ct])
                else
                    self.cardInfoBg.gameObject:SetActive(false)
                end
                --判断是否点击到卡牌本身（因为有两个碰撞框）
                local ist = self:isTouchedCard(tf)
                if self.isCardSelected[var] == false then --如果不是选中状态
                    ist = false
                end
                local tempY = self.nowUICamera:ScreenToWorldPoint(self:getTouchPoint(self.myTouchCount - 1)).y / self.urlc
                --费是否足够
                local isFeiEnough = self.nowFei >= sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[var])
                --是否在下兵区域中（上下UI区域）
                local isenterRect = (tempY > self.downCardY) and (tempY < self.upCardY)
                
                -- TODO 操作
                if isFeiEnough and isenterRect then --拖到屏幕中
                    --print("333")
                    self:doEvent(tf, var, 3)
                else
                    if isFeiEnough == false and isenterRect then
                        self.hudtext:Add("费用不足", Color.cyan, 2)
                    end
                    local cardBounds = Bounds(tf.localPosition, Vector3(self.nowMyCardSizetb.x, self.nowMyCardSizetb.y, 0) * tf.localScale.x)
                    if self.feiBounds:Intersects(cardBounds) then --回收卡
                        --print("444")
                        self:doEvent(tf, var, 1)
                    else --拖回下方
                        --print("555")
                        self:doEvent(tf, var, 0)
                    end
                end
                --如果没有拖动过卡牌并且点中卡牌本身并且是选中状态
                if isDragedCard == false and ist and shengyu_bgDelay1Ct then
                    TweenPosition.Begin(tf.gameObject, Vector3.Distance(tf.position, self.myCardConstPostb[var]) / 2, self.myCardConstPostb[var], true)
                    self.bigCardBoxCollider[var].enabled = false
                    self.isCardSelected[var] = false
                end
                
                --如果没有选中的卡牌就把不可下兵区域隐藏
                local tempInt = 0
                for var = 1, 4 do
                    if self.isCardSelected[var] then
                        tempInt = tempInt + 1
                        break
                    end
                end
                if tempInt == 0 then
                    self.canotRect.gameObject:SetActive(false)
                end
                
                self.feiBar2Spr.gameObject:SetActive(false)
                self.feiBar3Spr.gameObject:SetActive(false)
                self.feiBar4Spr.gameObject:SetActive(false)
                self.nowFeiLabel.color = whiteColor
                --触摸数减少
                self.myTouchCount = self.myTouchCount - 1
                
                if self.nowFei >= self.allFei then
                    self.feiBg2.gameObject:SetActive(false)
                    self.feiBg4.gameObject:SetActive(true)
                end
            end
        end
    end
    UIEventListener.Get(self.btn_pause.gameObject).onPress = function(go, args)
        if args then
            self.ispause = true
            Time.timeScale = 0
            ui_manager:ShowWB(WNDTYPE.ui_pause)
        end
    end
    -- UI卡牌Size
    self.nowMyCardSizetb = Vector2(cardBoxCollider.x, cardBoxCollider.y) / 8
    -----------------------------------技能UI获取
    for var = 1, self.uiSkillNum do
        local tf = self.transform:Find("currentCards_bg/skill" .. var)
        self.uiSkilltb[var] = tf
        local go = tf.gameObject
        UIEventListener.Get(tf.gameObject).onPress = function(go, args)
            if args then
                end
        end
    end
    -----------------------------------长按头像显示用户信息
    local delay1Ct = {}
    local userInfoBg = self.transform:Find("userInfoBg")
    for var = 1, 2 do
        UIEventListener.Get(self.transform:Find("defence_widget" .. var .. "/bg").gameObject).onPress = function(go, args)
            if args then -- 开启协程
                delay1Ct[var] = #self.coroutineTb + 1
                self.coroutineTb[delay1Ct[var]] = coroutine.start(function()
                    coroutine.wait(0.5)
                    userInfoBg.localPosition = Vector3(-107 + (2 - var) * 240.8, 300, 0)
                    userInfoBg.gameObject:SetActive(true)
                end)
            else -- 停止协程
                userInfoBg.gameObject:SetActive(false)
                coroutine.stop(self.coroutineTb[delay1Ct[var]])
            end
        end
    end
    ui_manager:DestroyWB(WNDTYPE.Prefight)
end
function HUIFUZANTING()
    ui_fight.daojishi.gameObject:SetActive(true)
    local djsLable = ui_fight.daojishi:GetComponent(typeof(UILabel))
    djsLable.text = "3"
    local sq = DG.Tweening.DOTween.Sequence()
    sq:SetDelay(1)
    sq:AppendCallback(function()
        local tempInt = tonumber(djsLable.text) - 1
        if tempInt == 0 then
            ui_fight.daojishi.gameObject:SetActive(false)
            ui_fight.ispause = false
            Time.timeScale = 1
        else
            djsLable.text = tempInt .. ""
        end
    end)
    sq:SetLoops(3)
    sq:SetUpdate(true)
end
function ui_fight:OnAddHandler()
    ui_fight = self
    --注册玩家下兵事件
    --Event.AddListener(GameEventType.WANJIAXIABING, WANJIAXIABING)
    Event.AddListener(GameEventType.HUIFUZANTING, HUIFUZANTING)
end
function ui_fight:OnRemoveHandler()
    --Event.RemoveListener(GameEventType.WANJIAXIABING, WANJIAXIABING)
    Event.RemoveListener(GameEventType.HUIFUZANTING, HUIFUZANTING)
end
--判断是否点击到卡牌本身（因为有两个碰撞框）
function ui_fight:isTouchedCard(tf)
    local cardBounds = Bounds(tf.localPosition, Vector3(self.nowMyCardSizetb.x * 8, self.nowMyCardSizetb.y * 8, 0) * tf.localScale.x)
    --单击屏幕的点位置
    self.danjiPosition = self.nowUICamera:ScreenToWorldPoint(self:getTouchPoint(self.myTouchCount - 1)) / self.urlc
    self.danjiPosition.z = 0
    return cardBounds:Contains(self.danjiPosition)
end

local tempInt3 = 0
--敌人下兵逻辑
function WANJIAXIABING(self)
    -- TODODO
    -- if 1 then
    --     return
    -- end
    ------------------------------
    if #self.enemyPaiKutb == 0 then
        return
    end
    local tempID
    --因费不够该出的卡牌id
    if self.nextEnemyCardFei then
        tempID = self.nextEnemyCardID
    else
        tempID = self.enemyPaiKutb[1]
        table.remove(self.enemyPaiKutb, 1)
    end
    --如果敌人费够
    if self.enemyNowFei >= sdata_armycardbase_data:GetFieldV("TrainCost", tempID) then
        print("WANJIAXIABING")
        local ct = self:getModel(tempID, 5)
        --增加敌人出牌UI
        local euc = GameObject.Instantiate(self.enemyUsedCard)
        --点击敌人出的卡牌相机跟随该敌兵
        UIEventListener.Get(euc.gameObject).onPress = function(go, args)
            if args then
                self.UIFollow.target = ct
            end
        end
        euc.gameObject:SetActive(true)
        euc.parent = self.enemyUsedCardsGridTf
        euc.localScale = self.enemyUsedCard.localScale
        euc:Find("Sprite"):GetComponent(typeof(UISprite)).spriteName = sdata_armycardbase_data:GetFieldV("IconID", tempID)
        --敌人出牌UI几秒后消失
        self.enemyUsedCardsGrid:Reposition()
        self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function()
            coroutine.wait(10)
            Object.Destroy(euc.gameObject)
        end)
        self.enemyNowFei = self.enemyNowFei - sdata_armycardbase_data:GetFieldV("TrainCost", tempID)
    else --敌人费不够记录下次该出的牌和费
        self.nextEnemyCardID = tempID
        self.nextEnemyCardFei = sdata_armycardbase_data:GetFieldV("TrainCost", tempID)
    end
end

--==============================--
--desc:获取模型
--time:2017-05-03 08:20:10
--@id:卡牌ID
--@index:为5时为敌人下兵
--[[我方基地1
敌方基地2
我方普通士兵3
敌方普通士兵4
我方机甲单位5
敌方机甲单位6
我方障碍物 如 我放电网7
敌方障碍物8
-中立障碍物 可能有血条 但没有阵营9]]
--
--return
--==============================--
function ui_fight:getModel(id, index)
    if index == 5 then
        --self.groupIndex = self.groupIndex + 1
    else
        index = self.arrayIndex
    end
    local renderZhenxing = self.allrenderZhenxingList[id]
    local ArmyID = sdata_armycardbase_data:GetFieldV("ArmyID", id)
    local go = GameObject.New().transform
    local tempMod
    
    for i = 0, renderZhenxing.Length - 1, 2 do
        local paramTab = CreateActorParam(sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_CmType, ArmyID),
            sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_ColorMat, ArmyID) == 1,
            sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_FlagColorIdx, ArmyID),
            sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_MeshPackName, ArmyID),
            sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_TexturePackName, ArmyID),
            sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_IsHero, ArmyID) == 1, tonumber(ArmyID .. "001"), id)
        selectedCardItem = FightUnitFactory.CreateUnit(index == 5 and 4 or 3, paramTab)
        --print(selectedCardItem.ClusterData.MemberData.ObjID)
        tempMod = selectedCardItem.GameObj.transform
        tempMod.gameObject:SetActive(true)
        tempMod.parent = go
        if index == 5 then --如果是敌方则阵型水平翻转
            tempMod.position = Vector3(-renderZhenxing[i], 0, renderZhenxing[i + 1]) * self.UnitWidth
            tempMod.eulerAngles = Vector3(0, -90, 0)
            local mt = tempMod.gameObject:GetComponent(typeof(RanderControl))
            mt.isEnemy = true
            mt:Begin()
            --mt:StartRanderControl()
            --mt.groupIndex = self.groupIndex
        else
            tempMod.eulerAngles = Vector3(0, 90, 0)
            tempMod.position = Vector3(renderZhenxing[i], 0, renderZhenxing[i + 1]) * self.UnitWidth
        end
        
        tempMod:GetComponent(typeof(MFAModelRender)).speedScale = 0
        tempMod:GetComponent(typeof(UnityEngine.MeshRenderer)).material.shader = PacketManage.Single:GetPacket("rom_share"):Load("Transparent_Colored_Gray.shader", FileSystem.RES_LOCATION.auto)
    end
    
    self.AstarFight:setZhenxingInfo(go, id, index - 1)
    if index == 5 then
        self.ctPosition.x = self.AstarFight.MapWidth - self.ctPosition.x
        self.AstarFight:isZhangAi(self.ctPosition, index - 1)--前4个对应自己的4张卡牌，5为敌人序号
        for i = 1, go.childCount do
            go:GetChild(0).parent = nil
        end
        Object.Destroy(go.gameObject)
        --TODODO 正式版去掉 目的：点击敌人出兵卡牌相机跟随
        return tempMod
    end
    return go
end
-- 编辑器平台和手机平台不同的触摸
function ui_fight:getTouchPoint(var)
    if Input.touchCount == 0 then
        return Input.mousePosition
    else
        return Input.GetTouch(var).position
    end
end
--算出每个元素各有几个并排序
function ui_fight:getPaiKuPerCardNum()
    local lastPaiID = {}
    local lastPaiNum = {}
    local tempPaiKutb = {}
    table.merge(tempPaiKutb, self.paiKutb)
    table.remove(tempPaiKutb, 1)
    local tempInt1 = 1
    local tempInt2 = 1
    --算出每个ID和对应的牌数
    while #tempPaiKutb > 0 do
        local i = 2
        while i <= #tempPaiKutb do
            if tempPaiKutb[i] == tempPaiKutb[1] then
                tempInt2 = tempInt2 + 1
                table.remove(tempPaiKutb, i)
                i = i - 1
            end
            i = i + 1
        end
        lastPaiID[tempInt1] = tempPaiKutb[1]
        lastPaiNum[tempInt1] = tempInt2
        table.remove(tempPaiKutb, 1)
        tempInt2 = 1
        tempInt1 = tempInt1 + 1
    end
    --显示和隐藏9个卡牌UI
    local tempInt = #lastPaiID
    local pai
    if tempInt > 9 then
        tempInt = 8
        pai = self.paiKuBg.transform:Find("paikuCard" .. 9)
        pai:GetComponent(typeof(UISprite)).spriteName = "zhandou_shenyubingli_gengduo"
        pai:Find("paikuSpr").gameObject:SetActive(false)
        pai:Find("feiBg").gameObject:SetActive(false)
        local tempInt2 = 0
        for i = 9, #lastPaiID do
            tempInt2 = tempInt2 + lastPaiNum[i]
        end
        pai:Find("quan/remainNumLabel"):GetComponent(typeof(UILabel)).text = tempInt2
        pai.gameObject:SetActive(true)
    elseif tempInt == 9 then
        pai = self.paiKuBg.transform:Find("paikuCard" .. 9)
        pai:Find("feiBg").gameObject:SetActive(true)
        pai:Find("paikuSpr").gameObject:SetActive(true)
    else
        for i = tempInt + 1, 9 do
            self.paiKuBg.transform:Find("paikuCard" .. i).gameObject:SetActive(false)
        end
    end
    --牌库排序 => 剩余卡牌数量（由多至少）→卡牌费数（由多至少）→卡牌ID（由低至高）
    local tempTable = {}
    for i = 1, tempInt do
        tempTable[i] = {lastPaiID[i], lastPaiNum[i], sdata_armycardbase_data:GetFieldV("TrainCost", lastPaiID[i])}
    end
    table.sort(tempTable, function(ta, tb)
        if ta[2] == tb[2] then
            if ta[3] == tb[3] then
                return ta[1] < tb[1]
            else
                return ta[3] > tb[3]
            end
        else
            return ta[2] > tb[2]
        end
    end)
    --设置每个卡牌UI显示内容
    for i = 1, tempInt do
        pai = self.paiKuBg:Find("paikuCard" .. i)
        pai:Find("paikuSpr"):GetComponent(typeof(UISprite)).spriteName = sdata_armycardbase_data:GetFieldV("IconID", tempTable[i][1])
        pai:Find("feiBg/costLabel"):GetComponent(typeof(UILabel)).text = tempTable[i][3]
        pai:Find("quan/remainNumLabel"):GetComponent(typeof(UILabel)).text = tempTable[i][2]
        pai.gameObject:SetActive(true)
    end
end
--事件处理
function ui_fight:doEvent(tf, var, isXiaBing)
    if isXiaBing > 0 then -- 下兵或回收事件
        lgyPrint("下兵或回收事件" .. isXiaBing)
        if isXiaBing > 2 then --拖动下兵
            -- 下兵事件
            -- 将下兵消息发送
            self:backCallback(tf)
            --消耗费
            self.nowFei = self.nowFei - sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[var])
            self.nowFeiLabel.text = self.nowFei .. ""
            --Event.Brocast(GameEventType.WANJIAXIABING, self)
        else -- 回收卡
            lgyPrint("回收卡")
            self.feiBar2Spr.gameObject:SetActive(false)
            self.feiBar3Spr.gameObject:SetActive(false)
            self.feiBar4Spr.gameObject:SetActive(false)
            self.nowFeiLabel.color = whiteColor
            --print("aaa")
            self:backCallback(tf, true)
            if (self.nowFei < self.allFei) == false then --如果满费则什么也不做
                self:cardFront(tf, var)
                self.hudtext:Add("费用已满", Color.cyan, 2)
                return false
            end
            self.nowFei = self.nowFei + sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[var]) / 2
        end
        self.isCardSelected[var] = false
        tf.localPosition = Vector3(-566, 2.9, 0)
        tf.localScale = Vector3(0, 0, 1)
        
        -- 延迟1秒从下一张卡牌位置飞到原位置
        local t = TimeTicker()
        t:Start(1)
        t.OnEnd = function(go)
            if #self.paiKutb > 0 then --牌库有牌
                TweenPosition.Begin(self.nowMyCardtb[var].gameObject, 0.2, self.myCardConstPostb[var], true)
                TweenScale.Begin(self.nowMyCardtb[var].gameObject, 0.2, Vector3.one)
                --设置补充手牌为下一张手牌信息
                tf:Find("cardSprite"):GetComponent(typeof(UISprite)).spriteName = self.nextCardSpr.spriteName
                tf:Find("feiBg/costLabel"):GetComponent(typeof(UILabel)).text = self.nextCardLabel.text
                --牌库第一张补充到手牌中并移除
                self.nowHandpaiKutb[var] = self.paiKutb[1]
                table.remove(self.paiKutb, 1)
                if #self.paiKutb > 0 then --牌库有牌
                    --设置下一张手牌为牌库第一张
                    local costFei = sdata_armycardbase_data:GetFieldV("TrainCost", self.paiKutb[1])
                    self.nextCardSpr.spriteName = sdata_armycardbase_data:GetFieldV("IconID", self.paiKutb[1])
                    self.nextCardLabel.text = costFei
                    --剩余兵力减少
                    self.sumLastBingLi = self.sumLastBingLi - costFei
                    self.allBingLiLabel.text = self.sumLastBingLi
                else --牌库没有牌了
                    self.transform:Find("currentCards_bg/nextCard").gameObject:SetActive(false)
                end
            end
        end
    else -- 返回事件
        lgyPrint("返回事件")
        --print("bbb")
        self:backCallback(tf, true)
        self:cardFront(tf, var)
    end
    --isPress = false
    return true
end
-- 卡牌前置
function ui_fight:cardFront(tf, var)
    tf.position = self.myCardConstPostb[var]
    tf.localPosition = tf.localPosition + Vector3(0, 25, 0)
    self.canotRect.gameObject:SetActive(true)
    local sizeY = self.upCardY - self.downCardY
    self.bigCardBoxCollider[var].enabled = true
    self.isCardSelected[var] = true
end


--==============================--
--desc:松开手指回调
--time:2017-05-04 06:56:10
--@tf:拖动中的物体
--@b:是否把卡牌放回原位置
--return
--==============================--
function ui_fight:backCallback(tf, b)
    --父节点还原，临时table清空，模型销毁
    tf.parent = self.currentCards_bg
    self.currentCards_bg.gameObject:SetActive(false)
    self.currentCards_bg.gameObject:SetActive(true)
    local index = table.removebyvalue2(self.onPressMyCardtb, tf)
    table.remove(self.maxSpan, index)
    if b then
        tf.localScale = Vector3.one
        local tmpObj = table.remove(self.onPressArmytb, index).gameObject
        -- 删除父级
        Object.Destroy(tmpObj)
    else
        --self.groupIndex = self.groupIndex + 1
        --从父物体中移除（加入父物体是为了移动的时候只移动父物体）
        for i = 1, self.onPressArmytb[index].childCount do
            local rander = self.onPressArmytb[index]:GetChild(0).gameObject:GetComponent(typeof(RanderControl))--:Begin()--:StartRanderControl()
            self.onPressArmytb[index]:GetChild(0).parent = nil
            rander:Begin()
        end
        --玩家下兵寻路网格位置(敌人下兵平行位置)
        self.ctPosition = self.AstarFight:getNum(self.onPressArmytb[index].position)
        --删除父物体
        Object.Destroy(table.remove(self.onPressArmytb, index).gameObject)
    end
end
function ui_fight:Update()
    --判断是否暂停
    if self.ispause then
        return
    end
    --如果拖动卡牌到边界则同时移动相机
    local tempInt = #self.onPressMyCardtb
    if tempInt > 0 then
        local tempX = self.nowUICamera:ScreenToWorldPoint(self:getTouchPoint(0)).x / self.urlc
        if tempX < -550 then
            self.BoxScrollObject:MoveTo(self.PTZCameraTf.position - Vector3(10, 0, 0))
        elseif tempX > 550 then
            self.BoxScrollObject:MoveTo(self.PTZCameraTf.position + Vector3(10, 0, 0))
        end
    end
    --遍历拖动中的卡牌
    local tempY
    local firstTrueVar = nil
    for var = 1, tempInt do
        local trueVar = table.indexof(self.nowMyCardtb, self.onPressMyCardtb[var])
        if var == 1 then
            firstTrueVar = trueVar
        end
        tempY = self.onPressMyCardtb[var].localPosition.y
        if tempY < self.downCardY then --卡牌在下方区域显示并缩放，模型隐藏
            tempY = (self.downCardY - tempY) / self.onPressMyCardSpantb[var]
            if tempY > 1 then
                self.onPressMyCardtb[var].localScale = Vector3.one
            else
                self.onPressMyCardtb[var].localScale = Vector3(tempY, tempY, 1)
            end
            self.onPressArmytb[var].localScale = Vector3.zero
            --卡牌滑动在费上显示回收价格
            local cardBounds = Bounds(self.onPressMyCardtb[var].localPosition, Vector3(self.nowMyCardSizetb.x, self.nowMyCardSizetb.y, 0) * self.onPressMyCardtb[var].localScale.x)
            if self.feiBounds:Intersects(cardBounds) then --回收卡
                local tempCost = sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[trueVar]) * 0.5
                if (self.allFei - self.nowFei) < tempCost then
                    tempCost = self.allFei - self.nowFei
                end
                if self.feiBar3Spr.gameObject.activeSelf == false then
                    self.feiBar3Spr.gameObject:SetActive(true)
                    self.feiBar4Spr.gameObject:SetActive(true)
                    self.feiBar2Spr.gameObject:SetActive(false)
                    self.nowFeiLabel.color = whiteColor
                end
            else
                if self.feiBar3Spr.gameObject.activeSelf == true then
                    self.feiBar3Spr.gameObject:SetActive(false)
                    self.feiBar4Spr.gameObject:SetActive(false)
                    self.feiBar2Spr.gameObject:SetActive(true)
                    self.nowFeiLabel.color = grayColor
                end
            end
        elseif tempY > self.upCardY then --卡牌在上方区域显示并缩放，模型隐藏
            tempY = (tempY - self.upCardY) / self.cardScaleSpan
            if tempY > 1 then
                self.onPressMyCardtb[var].localScale = Vector3.one
            else
                self.onPressMyCardtb[var].localScale = Vector3(tempY, tempY, 1)
            end
            self.onPressArmytb[var].localScale = Vector3.zero
        else --卡牌在中间区域隐藏，模型显示
            if self.feiBar3Spr.gameObject.activeSelf == true then
                self.feiBar3Spr.gameObject:SetActive(false)
                self.feiBar4Spr.gameObject:SetActive(false)
                self.feiBar2Spr.gameObject:SetActive(true)
                self.nowFeiLabel.color = grayColor
            end
            self.onPressMyCardtb[var].localScale = Vector3(0, 0, 1)
            self.onPressArmytb[var].localScale = Vector3.one
        end
        
        if self.onPressArmytb[var].localScale.x ~= 0 then
            -- 模型跟随鼠标位置移动
            local ray = self.nowWorldCamera:ScreenPointToRay(Vector3(self:getTouchPoint(var - 1).x, self:getTouchPoint(var - 1).y, 0))
            local isC, hit = UnityEngine.Physics.Raycast(ray, hit, 1000, 256)--256 == bit.lshift(1, 8) == 1<<8
            -- local isC, hit = UnityEngine.Physics.Raycast(ray, hit)
            if isC then
                self.AstarFight:isZhangAi(hit.point, var - 1)
            end
        end
    
    end
    --卡牌CD
    for var = 1, 4 do
        local tempInt = sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[var])
        if self.nowFei < tempInt then
            self.nowMyCardCDtbUISpritetb[var].fillAmount = 1 - self.nowFei / tempInt
        else
            self.nowMyCardCDtbUISpritetb[var].fillAmount = 0
        end
    end
    local tempFei
    --费每秒增长
    self.nowFei = self.nowFei + 10
    if self.nowFei > self.allFei then
        if firstTrueVar == nil and self.feiBg2.gameObject.activeSelf == true then
            self.feiBg2.gameObject:SetActive(false)
            self.feiBg4.gameObject:SetActive(true)
        end
        self.nowFei = self.allFei
        --设置费条百分比
        if firstTrueVar then
            local TrainCost = sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[firstTrueVar])
            if self.feiBar2Spr.gameObject.activeSelf == true then
                tempFei = self.nowFei - TrainCost
                self.feiBarSpr.fillAmount = tempFei / self.allFei
                self.feiBar2Spr.fillAmount = 1
                self.nowFeiLabel.text = math.round(tempFei < 0 and 0 or tempFei) .. ""
            else
                self.feiBar3Spr.fillAmount = 1
                self.feiBar4Spr.fillAmount = 1
                self.feiBarSpr.fillAmount = 1
                self.nowFeiLabel.text = math.round(self.nowFei) .. ""
            end
        else
            self.feiBarSpr.fillAmount = 1
            self.nowFeiLabel.text = math.round(self.nowFei) .. ""
        end
    else
        if self.feiBg2.gameObject.activeSelf == false then
            self.feiBg2.gameObject:SetActive(true)
            self.feiBg4.gameObject:SetActive(false)
        end
        --设置费条百分比
        if firstTrueVar then
            local TrainCost = sdata_armycardbase_data:GetFieldV("TrainCost", self.nowHandpaiKutb[firstTrueVar])
            if self.feiBar2Spr.gameObject.activeSelf == true then
                tempFei = self.nowFei - TrainCost
                self.feiBarSpr.fillAmount = tempFei / self.allFei
                self.feiBar2Spr.fillAmount = self.nowFei / self.allFei
                self.nowFeiLabel.text = math.round(tempFei < 0 and 0 or tempFei) .. ""
            else
                tempFei = self.nowFei + TrainCost / 2
                self.feiBar3Spr.fillAmount = (self.nowFei + TrainCost) / self.allFei
                self.feiBar4Spr.fillAmount = tempFei / self.allFei
                self.feiBarSpr.fillAmount = self.nowFei / self.allFei
                self.nowFeiLabel.text = math.round(tempFei > self.allFei and self.allFei or tempFei) .. ""
            end
        else
            self.feiBarSpr.fillAmount = self.nowFei / self.allFei
            self.nowFeiLabel.text = math.round(self.nowFei) .. ""
        end
    end
    -- --敌人费每秒增长
    -- self.enemyNowFei = self.enemyNowFei + 5
    -- -- 判断是否满费
    -- if self.enemyNowFei > self.enemyAllFei then
    --     -- 满费出牌
    --     self.enemyNowFei = self.enemyAllFei
    --     self.ctPosition = Vector3(25 + math.random(40), 0, 10 + math.random(40))
    --     WANJIAXIABING(self)
    --     -- 为满费但是能够出上次费用不够的牌则出牌
    -- elseif self.nextEnemyCardFei and self.enemyNowFei > self.nextEnemyCardFei then
    --     self.nextEnemyCardFei = nil
    --     WANJIAXIABING(self)
    -- end
end
function ui_fight:OnDestroyDone()
    self.PTZCameraTf.position = Vector3(0, self.PTZCameraTf.position.y, self.PTZCameraTf.position.z)
    self.PTZCameraTf:GetComponent(typeof(PositionTransform)).Value = self.PTZCameraTf.position
    self.BoxScrollObject.m_MoveRecord.CurrentPos = self.PTZCameraTf.position
end
return ui_fight
