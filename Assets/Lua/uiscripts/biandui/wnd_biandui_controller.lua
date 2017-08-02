wnd_biandui_controller ={}
--[[
    wnd_biandui_controller:
        variable:
            ---卡牌相关---
            CardItemList ={},        --卡组区域卡牌数据列表
            DayingItemList = {},     --大营区域卡牌数据列表
            QianfengItemList = {},   --前锋区域卡牌数据列表
            carditem_pic_list = {},  --卡组区域卡牌图片资源列表
            dayingitem_pic_list = {},--大营区域卡牌图片资源列表

            ---兵力相关---
            dayinglimit,             --大营兵力上限
            dayingbingli_now,        --大营当前兵力
            qianfenglimit,           --前锋兵力上限
            qianfengbingli_now,      --前锋当前兵力
            zongbinglilimit,         --总兵力上限
            zongbingli_now,          --当前总兵力
            pjbingli,                --平均兵力

            ---拖动相关---
            isDrag,                  --是否处在拖动状态
            islfDrag,                --是否左右拖动
            isudDrag,                --是否上下拖动
            Cloneobj,                --拖动时克隆的卡牌
            isClone,                 --拖动的卡牌是否克隆完成
            DayingCanbeAdd,          --拖动的卡牌在松手时是否应被加入到大营
            isLongorDragPress,       --当前是否在长按或者拖动
        
            ---点击及长按相关---
            startlongadd,            --是否允许进行长按添加
            lastclickobj,            --上一次点击的物体

        function:
            --初始化相关---
            OnShowDone() extend wnd_base:OnShowDone()
            initListener,            --添加监听
            InitData，               --初始化数据   
            MakeCardItem             --新建卡牌区域卡牌数据
            MakeDayingItem,          --新建大营区域卡牌数据
            InitPicItem，            --初始化卡牌图片  
            SetLimit,                --设置兵力上限 

            ---卡牌增删相关---
            AddCardToDaying,         --卡牌加入到大营
            DeleteDayingItem,        --大营卡牌删除


            ---兵力相关---
            SetBlingli,              --设置当前兵力

            ---卡牌控制相关---
            CardOnClick,             --卡牌单击响应
            CardPressCtr,            --卡牌点击控制
            DeletePressCtr           --删除按钮单击控制
            DragCtr，                --卡牌拖动状态判定
            AddCloneCardToDaying,    --卡牌上下拖动处理
            DragEndCtr,              --拖动结束控制
            SetStar,                 --设置卡牌星星 
]]

local class = require("common/middleclass")
wnd_biandui_controller = class("wnd_biandui_controller", wnd_base)
local this = wnd_biandui_controller

---初始化相关-----------------------------------
function wnd_biandui_controller:OnShowDone()
    this:InitData()

    this.view = require("uiscripts/biandui/wnd_biandui_view")
    this.view:initview(self)

    this.model = require("uiscripts/biandui/wnd_biandui_model")
    this.model:initModel()

    ---测试用代码---
    this:MakeCardItem(1, 2, 1, 101001, 1)
    this:MakeCardItem(1, 6, 1, 101002, 1)
    this:MakeCardItem(1, 3, 15, 101003, 3)
    this:MakeDayingItem(101001,2)
    this:MakeDayingItem(101002,1)


    this:InitPicItem()
    this:SetLimit(5000, 2000)

    this:SetBlingli()
    this:initListener()
    print("wnd_biandui +++++++ OnShowDone")
end

--@Des 初始化数据，各项标志位，图标以及图标数据的表
function wnd_biandui_controller:InitData()
    this.isDrag = false
    this.islfDrag = false
    this.isudDrag = false
    this.isClone = false
    this.isLongorDragPress = false
    this.lastclickobj = nil
    this.CardItemList = {}
    this.DayingItemList = {}
    this.QianfengItemList = {}
    this.carditem_pic_list = {}
    this.dayingitem_pic_list ={}
    this.qianfenglimit = 0
    this.dayinglimit = 0
    this.dayingbingli_now = 0
    this.zongbingli_now = 0
    this.pjbingli = 0
    this.qianfengbingli_now =0
    this.DayingCanbeAdd = false
    this.Cloneobj = nil
    this.startlongadd = false
end

--@Des 新建卡组区域卡牌数据
--@params Quality(number):卡牌质量(从服务器获取)
--		  Star(number):卡牌的星级(从服务器获取)
--		  Level(number):卡牌等级(从服务器获取)
--        ArmyCardID(number):卡牌ID(从服务器获取)
--        UseLimitLevel(number):卡牌使用上限等级(从服务器获取)
function wnd_biandui_controller:MakeCardItem(Quality,Star,Level,ArmyCardID,UseLimitLevel)
    local Item = {}
    Item["Quality"] = Quality
    Item["Star"] = Star
    Item["Level"] = Level
    Item["ArmyCardID"] = ArmyCardID
    Item["ArmyType"] = this.model:FindArmyTypeByArmyID(ArmyCardID) --卡牌类型（人，妖，械）
    Item["useLimit"] = this.model:FindUseLimitByIDandLevel(ArmyCardID,UseLimitLevel) --卡牌使用上限
    Item["TrainCost"] = this.model:FindTrainCostbYArmyCardID(ArmyCardID) --卡牌训练费用（兵力）
    Item["Num"] = Item["useLimit"]
    table.insert(this.CardItemList,Item)
end

--@Des 新建大营区域卡牌数据
--@params ArmyCardID(number):卡牌ID(从服务器获取)
--        Num(number):卡牌数量(从服务器获取)
function wnd_biandui_controller:MakeDayingItem(ArmyCardID,Num)
    -----初始化大营数据元素列表----
    for k,v in pairs(this.CardItemList) do
        if(v["ArmyCardID"] == ArmyCardID) then
            v["Num"] = v["useLimit"] - Num --卡组区域中卡牌的数量 = 使用上限-目前大营中对应卡牌的数量
            local Item = {}
            Item["Quality"] = v["Quality"]
            Item["Star"] = v["Star"]
            Item["Level"] = v["Level"]
            Item["ArmyCardID"] = v["ArmyCardID"]
            Item["ArmyType"] = v["ArmyType"]
            Item["useLimit"] = v["useLimit"]
            Item["TrainCost"] = v["TrainCost"]
            Item["Num"] = Num
            table.insert(this.DayingItemList,Item)
            return
        end
    end
end

--@Des 初始化所有卡牌图片
function wnd_biandui_controller:InitPicItem()
    ----初始化卡牌区域----
    local go = nil
    for index = 1,#this.CardItemList do
        if(index == 1) then
            go = this.view.cardItem
            go.transform:Find("card_item_frame/card_item_level_bg/btn_dayingitem_delete").gameObject:SetActive(false)
        else
            go =  GameObjectExtension.InstantiateFromPreobj(this.view.card_clone_item,this.view.card_item_grid)
            this.view.card_item_grid:GetComponent("UIGrid"):AddChild(go.transform,false)
        end
        go.transform.name = tostring(this.CardItemList[index]["ArmyCardID"])
        -----star---level---quality----type---num---consume---
        this:SetStar(go,this.CardItemList[index]["Star"])
        go.transform:Find("card_item_frame/card_item_numc_bg/card_item_consume"):GetComponent("UILabel").text = tostring(this.CardItemList[index]["TrainCost"])
        go.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text = "x"..tostring(this.CardItemList[index]["Num"])
        go.transform:Find("card_item_frame/card_item_level_bg/card_item_level_frame/card_item_level_label"):GetComponent("UILabel").text = "LV."..tostring(this.CardItemList[index]["Level"])
        this.carditem_pic_list[index] = go
        go:SetActive(true)
    end

    local dygo = nil
    ----初始化大营区域----
    if(#this.DayingItemList == 0) then
        return
    end
    for index = 1,#this.DayingItemList do
        if(index == 1) then
            dygo = this.view.dayingItem
        else
            dygo =  GameObjectExtension.InstantiateFromPreobj(this.view.card_clone_item,this.view.daying_item_grid)
            this.view.daying_item_grid:GetComponent("UIGrid"):AddChild(dygo.transform,false)
            dygo.transform:Find("card_item_frame/card_item_level_bg/btn_dayingitem_delete").gameObject:SetActive(true)
            dygo.transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject:GetComponent("UIDragScrollView").scrollView = this.view.daying_item_panel:GetComponent("UIScrollView")
        end
        dygo.transform.name = tostring(this.CardItemList[index]["ArmyCardID"])
        -----star---level---quality----type---num---consume---
        this:SetStar(dygo,this.DayingItemList[index]["Star"])
        dygo.transform:Find("card_item_frame/card_item_numc_bg/card_item_consume"):GetComponent("UILabel").text = tostring(this.DayingItemList[index]["TrainCost"])
        dygo.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text ="x"..tostring(this.DayingItemList[index]["Num"])
        dygo.transform:Find("card_item_frame/card_item_level_bg/card_item_level_frame/card_item_level_label"):GetComponent("UILabel").text = "LV."..tostring(this.DayingItemList[index]["Level"])
        this.dayingitem_pic_list[index] = dygo
        dygo:SetActive(true)
    end
    ---将加号图片始终置于大营区域队列的最后方---
    this.view.AddIcon.transform:SetAsLastSibling()
    this.view.daying_item_grid:GetComponent("UIGrid").enabled = true
end
----------------------------------------------------------

---工具方法相关----------------------------------
--@Des 生成每个卡牌的星星
--@params go(GameObject):需要设置星星的卡牌（必须是预制卡牌的克隆体）
--        starnum(number):需要设置的星星数量
function wnd_biandui_controller:SetStar(go,starnum)
    local sgo = nil
    local star = go.transform:Find("card_item_frame/card_item_star_frame/card_item_star_grid/star").gameObject
    local sgrid = go.transform:Find("card_item_frame/card_item_star_frame/card_item_star_grid").gameObject
    for i = 1,starnum do
        if(i == 1) then
            star:SetActive(true)
        else
            sgo = GameObjectExtension.InstantiateFromPreobj(star,sgrid)
            sgrid:GetComponent("UIGrid"):AddChild(sgo.transform,false)
            sgo:SetActive(true)
        end
    end
end

--@Des 设置兵力上限
function wnd_biandui_controller:SetLimit(DayingLimit,QianfengLimit)
    this.dayinglimit = DayingLimit
    this.qianfenglimit = QianfengLimit
    this.zongbinglilimit = DayingLimit+QianfengLimit

    this.view.daying_bingli_limit:GetComponent("UILabel").text = tostring(DayingLimit)
    this.view.qianfeng_bingli_limit:GetComponent("UILabel").text = tostring(QianfengLimit)
    this.view.zongbingli_limit:GetComponent("UILabel").text = tostring(DayingLimit+QianfengLimit)
end

--@Des 刷新当前兵力
function wnd_biandui_controller:SetBlingli()
    ------对当前已部署的大营兵力，前锋兵力，总兵力，进行数据更新-----------
    this.dayingbingli_now = 0
    this.qianfengbingli_now = 0
    this.zongbingli_now = 0

    local cardnum = 0
    ----遍历大营元素，循环递加每个元素的数目，将大营兵力加在一起-----
    for k,v in pairs(this.DayingItemList) do
        for index =1,v["Num"] do
            cardnum = cardnum+1
            this.dayingbingli_now =this.dayingbingli_now + v["TrainCost"]
        end
    end
    this.view.daying_bingli_now:GetComponent("UILabel").text = tostring(this.dayingbingli_now)

    ----由于前锋每种牌只可以放一张，所以并不需要循环递加每个元素的数目，直接遍历前锋列表计算前锋兵力即可---
    for k,v in pairs(this.QianfengItemList) do
        cardnum = cardnum+1
        this.qianfengbingli_now =this.qianfengbingli_now + v["TrainCost"]
    end
    this.view.qianfeng_bingli_now:GetComponent("UILabel").text = tostring(this.qianfengbingli_now)

    ---总兵力 = 大营兵力+前锋兵力-----
    this.zongbingli_now = this.dayingbingli_now+this.qianfengbingli_now
    this.view.zongbingli_now:GetComponent("UILabel").text = tostring(this.zongbingli_now)

    ---平均兵力 = 总兵力除卡牌数量---
    if(cardnum == 0) then
        this.pjbingli = 0
    else
        this.pjbingli = math.ceil(this.zongbingli_now/cardnum)
    end
    this.view.pjbingli:GetComponent("UILabel").text = tostring(this.pjbingli)
end

--@Des 卡组/大营区域卡牌添加响应，TriggerBox/大营触摸碰撞面板/卡牌区域触摸碰撞面板添加响应
function wnd_biandui_controller:initListener()
    for i = 1,#this.carditem_pic_list do
        UIEventListener.Get(this.carditem_pic_list[i].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDragStart = function(go)
            --拖动事件
            print("onDragStart")
            this.isDrag = true
        end
        ----拖动当中的方法，用于判断左右还是上下拖动，从而进行列表移动和克隆物体的处理-----
        UIEventListener.Get(this.carditem_pic_list[i].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDrag = function(go,TouchPosition)
            --拖动事件
            this:DragCtr(go,TouchPosition)
            this.isDrag = true
        end
        -----拖动结束的方法，用于判断卡牌是否拖入了兵营或者前锋，然后做数据的拖动结束处理----
        UIEventListener.Get(this.carditem_pic_list[i].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDragEnd = function(go)
            --拖动事件
            print("onDragStartEND")
            if(this.DayingCanbeAdd) then
                this:AddCardToDaying(go)
            else
                local item = go.transform.parent.parent.parent.gameObject
                local CardData = nil
                for a,b in pairs(this.CardItemList) do
                    if(tostring(b["ArmyCardID"]) == item.name) then
                        CardData = b
                    end
                end
                item.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text ="x"..tostring(CardData["Num"])
                this.view.daying_bingli_now:GetComponent("UILabel").text = this.dayingbingli_now
                this.view.zongbingli_now:GetComponent("UILabel").text = this.zongbingli_now
            end
            this:DragEndCtr()
            if(not go:GetComponent("UIDragScrollView").enabled) then
                go:GetComponent("UIDragScrollView").enabled = true
            end 
        end
        ----加入卡牌区域物体的单击以及长按处理-----
        UIEventListener.Get(this.carditem_pic_list[i].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onPress = function (go,isPressed)
            this:CardPressCtr(go,isPressed,1)
        end
    end

    -----加入大营区域卡牌的单击处理-----
    for index = 1,#this.dayingitem_pic_list do
        UIEventListener.Get(this.dayingitem_pic_list[index].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onPress = function (go,isPressed)
            this:CardPressCtr(go,isPressed,2)
        end

        -----加入大营区域卡牌的拖动开始处理，在开始拖动的时候关闭当前打开的单击面板---
        UIEventListener.Get(this.dayingitem_pic_list[index].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDragStart = function(go)
            --拖动事件
            this.isDrag = true
            this:CloseSelectCardPanel()
        end

        -----加入大营区域卡牌的拖动结束处理，在结束拖动的时候设置标志位，防止弹起时打开单击面板---
        UIEventListener.Get(this.dayingitem_pic_list[index].transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDragEnd = function(go)
            this.isDrag = false
            this.isLongorDragPress = true
        end

        ----加入大营区域卡牌右上角的删除按钮的响应处理------
        UIEventListener.Get(this.dayingitem_pic_list[index].transform:Find("card_item_frame/card_item_level_bg/btn_dayingitem_delete").gameObject).onPress = function(go,isPressed)
            this:DeletePressCtr(go,isPressed)
        end

    end

    ----加入外部TriggerBox,大营触摸碰撞面板，以及卡牌区域触摸碰撞面板的响应----
    UIEventListener.Get(this.view.TriggerBox).onPress = function (go,isPressed)
        this:TriggerCtr(go,isPressed)
    end

    UIEventListener.Get(this.view.daying_item_panel_col).onPress = function (go,isPressed)
        this:TriggerCtr(go,isPressed)
    end

    UIEventListener.Get(this.view.card_item_panel_col).onPress = function (go,isPressed)
        this:TriggerCtr(go,isPressed)
    end
end

--@Des 点击别处关闭单击卡牌面板
--@params go(GameObject)：点击的物体
--        isPressed(bool)：鼠标是否在按下状态
function wnd_biandui_controller:TriggerCtr(go,isPressed)
    ---如果鼠标弹起则返回—-----
    ---鼠标按下则直接关闭单击面板---
    if(not isPressed) then
        return
    end
    ----关闭面板，关闭当前展开的box碰撞器---
    this:CloseSelectCardPanel()
    if(this.view.TriggerBox.activeSelf) then
        this.view.TriggerBox:SetActive(false)
    end
end

--@Des 关闭单击面板
function wnd_biandui_controller:CloseSelectCardPanel()
    if(not this.view.select_card_panel.activeSelf) then
        return
    end
    if(this.lastclickobj~=nil and this.lastclickobj.name~="btn_dayingitem_delete" ) then
        if(this.lastclickobj.name == "card_item_icon") then
            this.view.select_card_panel:SetActive(false)
            this.lastclickobj.transform.parent.parent.parent.localScale = Vector3(1,1,1)
        end
    end
end
---------------------------------------------

---卡牌操作装态判定及响应相关---------------
--@Des 卡牌区域元素单击/长按处理
--@params go(GameObject)：点击的卡牌图标
--        isPressed(bool)：鼠标是否在按下状态
--        index(number)：用来区分点击的是大营区域卡牌还是卡组区域的卡牌
--                       1为卡组区域，2为大营区域  
function wnd_biandui_controller:CardPressCtr(go,isPressed,index)
    ---当长按计时完成后的响应回调函数----
    OnComplete = function()
        this.OnPressTimer:Kill()
        if(this.isDrag or this.lastclickobj~=go) then
            return
        else
            this.startlongadd =true
            if(not this.view.select_card_panel.activeSelf) then
                return
            end
            print("已经完成了计时!!")
            this.isLongorDragPress = true
            ----匀速添加功能
            local fun = function()
                while isPressed == true do
                    if(not this.startlongadd) then
                        return
                    end
                    coroutine.wait(0.1)
                    this:AddCardToDaying(go)
                end
            end
            coroutine.start(fun)
        end
    end
    print("现在我按没按！"..tostring(isPressed))

    if isPressed then
        if this.OnPressTimer then
            this.OnPressTimer:Kill()
        end
        this.OnPressTimer = TimeUtil:CreateTimer(1.5,OnComplete)
    else
        this.startlongadd =false
        this.OnPressTimer:Kill()

        print("为什么抬不起来-------"..tostring(this.isLongorDragPress))

        if(this.isLongorDragPress == true) then
            this.isLongorDragPress = false
        else
            this:CloseSelectCardPanel()
            this:CardOnClick(go,index)
            print("我的手抬起来了！")
        end
    end
end

--@Des 卡牌单击响应
--@params go(GameObject)：点击的卡牌图标
--        index(number)：用来区分点击的是大营区域卡牌还是卡组区域的卡牌
--                       1为卡组区域，2为大营区域
function wnd_biandui_controller:CardOnClick(go,index)
    this.lastclickobj = go ---记录当次点击的物体
    this.view.select_card_panel:SetActive(true)
    go.transform.parent.parent.parent.localScale = Vector3(1.1,1.1,1) ---放大卡牌
    local v3 = Vector3 (go.transform.position.x,go.transform.position.y,go.transform.position.z)
    if(index == 1) then
        v3.y = v3.y+0.3----做单击面板显示在卡牌区域的处理,把选择面板置于上方
    else
        v3.y = v3.y-0.3----做单击面板显示在大营区域的处理，把选择面板置于下方
    end
    this.view.select_card_panel.transform.position = v3
    this.view.select_card_panel:SetActive(true)
    ---为打开的单击面板的添加按钮添加响应，传入当前点击的卡牌-----
    UIEventListener.Get(this.view.select_card_panel.transform:Find("select_card_bg/select_card_add").gameObject).onClick = function ()
        this:AddCardToDaying(go)
    end
    this.view.TriggerBox:SetActive(true)
    print("单击！单击！单击！")
end


--@Des 卡牌拖动状态判定
--@params go(GameObject)：拖动的卡牌的图标
--        TouchPosition(Vector2)：每一帧拖动的位移
function wnd_biandui_controller:DragCtr(go,TouchPosition)
    local DragsumX = 0
    local DragsumY = 0

    ---如果已经处于一个在左右拖动或者上下拖动的状态，左右拖动则返回，上下拖动则进行卡牌的移动-----
    if(not this.isudDrag and this.islfDrag) then
        return
    elseif(this.isudDrag and not this.islfDrag) then
        this:AddCloneCardToDaying(go,TouchPosition)
    else
        -----如果当前没有左右和上下拖动，则进行拖动判定------
        print("onDrag")
        print(TouchPosition.x,TouchPosition.y)
        DragsumX = TouchPosition.x
        DragsumY = TouchPosition.y

        if(TouchPosition.y<0) then
            DragsumY = -DragsumY
        end
        if(TouchPosition.x<0) then
            DragsumX = -DragsumX
        end

        ------根据计算的拖动角度比例，判断当前是左右拖动还是上下拖动------
        print("角度计算是.........."..tostring(DragsumY/DragsumX))
        if(DragsumY/DragsumX >0.36) then
            this.isudDrag = true
            this.islfDrag = false
        elseif(DragsumY/DragsumX <0.36) then
            this.isudDrag = false
            this.islfDrag = true
        end

        -----如果是上下拖动，则关闭当前单击面板，关闭列表拖动空间，开始进行克隆卡牌并往大营拖动的处理---
        if(this.isudDrag and not this.islfDrag) then
            print("上下上下上下")
            this:CloseSelectCardPanel()
            go:GetComponent("UIDragScrollView").enabled = false
            this:AddCloneCardToDaying(go,TouchPosition)

            -----如果是左右拖动则进行单击面板的关闭---
        elseif (not this.isudDrag and this.islfDrag) then
            this:CloseSelectCardPanel()
            print("左右左右左右")
        end
    end
end


--@Des 卡牌拖动结束处理
function wnd_biandui_controller:DragEndCtr()
    this.isDrag = false
    this.isudDrag = false
    this.islfDrag = false
    this.isLongorDragPress = true
    this.DayingCanbeAdd = false
    this.isClone = false
    this.view.card_clone_panel:SetActive(false)
    Object.Destroy(this.Cloneobj)
    this.Cloneobj = nil
    this.view.daying_bingli_now:GetComponent("UILabel").color = Color(17,255,202)
    this.view.zongbingli_now:GetComponent("UILabel").color = Color(255,255,255)
end


--@Des 卡牌上下拖动处理，生成克隆体，判断是否拖入大营，修改兵力
--@params go(GameObject)：拖动的物体
--        TouchPosition(Vector2)：每一帧拖动的位移
function wnd_biandui_controller:AddCloneCardToDaying(go,TouchPosition)
    local tempDayingbl = 0
    local tempZongbl = 0
    --print(go.transform.parent.parent.parent.gameObject)
    local item = go.transform.parent.parent.parent.gameObject
    local CardData = nil
    local CardItem = nil

    for k,v in pairs(this.carditem_pic_list) do
        if(v.name == item.name) then
            CardItem = v
            for a,b in pairs(this.CardItemList) do
                if(tostring(b["ArmyCardID"]) == item.name) then
                    CardData = b
                end
            end
        end
    end
    if(CardData["Num"] == 0) then
        return
    end
    if(not this.isClone) then
        this.isClone = true
        this.view.card_clone_panel:SetActive(true)
        this.Cloneobj = GameObjectExtension.InstantiateFromPreobj(this.view.card_clone_item,this.view.card_clone_panel)
        this.Cloneobj.name = item.name
        this:SetStar(this.Cloneobj,CardData["Star"])
        this.Cloneobj.transform:Find("card_item_frame/card_item_numc_bg/card_item_consume"):GetComponent("UILabel").text = tostring(CardData["TrainCost"])
        this.Cloneobj.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text ="x1"
        this.Cloneobj.transform:Find("card_item_frame/card_item_level_bg/card_item_level_frame/card_item_level_label"):GetComponent("UILabel").text = "LV."..tostring(CardData["Level"])
        item.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text ="x"..tostring(CardData["Num"]-1)
        ---------这里还需要加入很多数据，彻底复制一个拖动的物体---------
        this.Cloneobj.transform.localScale = Vector3(1,1,1)
        this.Cloneobj.transform.position = item.transform.position
        this.view.card_clone_item:SetActive(false)
        this.Cloneobj:SetActive(true)

    elseif(this.isClone and this.Cloneobj~=nil) then
        local v =  Vector3(this.Cloneobj.transform.localPosition.x+TouchPosition.x,this.Cloneobj.transform.localPosition.y+TouchPosition.y,this.Cloneobj.transform.localPosition.z)
        this.Cloneobj.transform.localPosition = v
    end

    local c_p = this.Cloneobj.transform.localPosition
    local p_s = this.view.daying_item_panel_col:GetComponent("UIWidget").localSize

    if(c_p.x > -p_s.x/2 and c_p.x<p_s.x/2 and c_p.y > -p_s.y/2 and c_p.y<p_s.y/2) then
        tempDayingbl = this.dayingbingli_now + CardData["TrainCost"]
        tempZongbl = this.zongbingli_now + CardData["TrainCost"]

        if(tempDayingbl <= this.dayinglimit and tempZongbl <= this.zongbinglilimit) then
            this.DayingCanbeAdd = true
        else
            this.DayingCanbeAdd = false
        end
        print("我拖进去啦！！！！")
    else
        this.DayingCanbeAdd = false
        tempDayingbl = this.dayingbingli_now
        tempZongbl = this.zongbingli_now
    end
    this.view.daying_bingli_now:GetComponent("UILabel").text = tostring(tempDayingbl)
    this.view.zongbingli_now:GetComponent("UILabel").text = tostring(tempZongbl)

    if(tempDayingbl > this.dayinglimit) then
        this.view.daying_bingli_now:GetComponent("UILabel").color = Color(255,0,0)
    else
        this.view.daying_bingli_now:GetComponent("UILabel").color = Color(17,255,202)
    end

    if(tempZongbl > this.zongbinglilimit) then
        this.view.zongbingli_now:GetComponent("UILabel").color = Color(255,0,0)
    else
        this.view.zongbingli_now:GetComponent("UILabel").color = Color(255,255,255)
    end
end
-------------------------------------------------------------------


------卡牌增删相关-------------------------------
--@Des 添加卡牌至大营
--@params go(GameObject)：需要添加到大营的卡牌的图标
function wnd_biandui_controller:AddCardToDaying(go)
    local item = go.transform.parent.parent.parent.gameObject

    local CardData = nil
    local CardItem = nil

    local DayingData = nil
    local DayingItem = nil

    for k,v in pairs(this.carditem_pic_list) do
        if(v.name == item.name) then
            CardItem = v
            for a,b in pairs(this.CardItemList) do
                if(tostring(b["ArmyCardID"]) == item.name) then
                    CardData = b
                end
            end
        end
    end


    if(CardData == nil or CardItem == nil) then
        print("卡牌查找失败---")
        return
    end

    if(CardData["Num"] == 0) then
        print("卡牌数量不够啦！")
        return
    end

    if(this.dayingbingli_now + CardData["TrainCost"] > this.dayinglimit or this.zongbingli_now + CardData["TrainCost"]>this.zongbinglilimit) then
        print("大营兵力超出啦---")
        return
    end

    for k,v in pairs(this.dayingitem_pic_list) do
        if(v.name == item.name) then
            DayingItem = v
            for a,b in pairs(this.DayingItemList) do
                if(tostring(b["ArmyCardID"]) == item.name) then
                    DayingData = b
                end
            end
        end
    end

    -----------------------为新建卡牌添加响应--------------------
    if(DayingData == nil or DayingItem == nil) then

        print("我走这一句啦啦啦啦")

        local dygo =  GameObjectExtension.InstantiateFromPreobj(this.view.card_clone_item,this.view.daying_item_grid)
        this.view.daying_item_grid:GetComponent("UIGrid"):AddChild(dygo.transform,false)

        dygo.transform.name = tostring(CardData["ArmyCardID"])
        -----star---level---quality----type---num---consume---
        this:SetStar(dygo,CardData["Star"])
        dygo.transform:Find("card_item_frame/card_item_numc_bg/card_item_consume"):GetComponent("UILabel").text = tostring(CardData["TrainCost"])
        dygo.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text ="x1"
        dygo.transform:Find("card_item_frame/card_item_level_bg/card_item_level_frame/card_item_level_label"):GetComponent("UILabel").text = "LV."..tostring(CardData["Level"])
        this.dayingitem_pic_list[#this.dayingitem_pic_list+1] = dygo
        dygo:SetActive(true)

        this:MakeDayingItem(CardData["ArmyCardID"],1)

        dygo.transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject:GetComponent("UIDragScrollView").scrollView = this.view.daying_item_panel:GetComponent("UIScrollView")

        UIEventListener.Get(dygo.transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onPress = function (go,isPressed)
            this:CardPressCtr(go,isPressed,2)
        end

        -----加入大营区域卡牌的拖动开始处理，在开始拖动的时候关闭当前打开的单击面板---
        UIEventListener.Get(dygo.transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDragStart = function(go)
            --拖动事件
            this.isDrag = true
            this:CloseSelectCardPanel()
        end

        -----加入大营区域卡牌的拖动结束处理，在结束拖动的时候设置标志位为这是一个长按拖动，防止弹起时打开单击面板---
        UIEventListener.Get(dygo.transform:Find("card_item_frame/card_item_icon_bg/card_item_icon").gameObject).onDragEnd = function(go)
            this.isDrag = false
            this.isLongorDragPress = true
        end

        dygo.transform:Find("card_item_frame/card_item_level_bg/btn_dayingitem_delete").gameObject:SetActive(true)
        ----加入大营区域卡牌右上角的删除按钮的响应处理------
        UIEventListener.Get(dygo.transform:Find("card_item_frame/card_item_level_bg/btn_dayingitem_delete").gameObject).onPress = function(go,isPressed)
            this:DeletePressCtr(go,isPressed)
        end

        this.view.AddIcon.transform:SetAsLastSibling()
        this.view.daying_item_grid:GetComponent("UIGrid"):Reposition()
    else
        DayingData["Num"] = DayingData["Num"]+1
        CardData["Num"] = CardData["Num"]-1
        print(DayingData["Num"])
        DayingItem.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text = "x"..tostring(DayingData["Num"])
    end

    CardItem.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text = "x"..tostring(CardData["Num"])
    this:SetBlingli()

end

--@Des 删除按钮点击响应
--@params go(GameObject)：点击的卡牌图标
--        isPressed(bool)：鼠标是否在按下状态
function wnd_biandui_controller:DeletePressCtr(go,isPressed)
    ---当长按计时完成后的响应回调函数----
    --this.lastclickobj = go
    this:CloseSelectCardPanel()

    OnComplete = function()
        this.OnPressTimer:Kill()
            this.startlongadd =true
            print("已经完成了计时!!")
            ----匀速删除功能
            local fun = function()
                while isPressed == true do
                    if(not this.startlongadd or go == nil) then
                        return
                    end
                    coroutine.wait(0.1)
                    this:DeleteDayingItem(go)
                end
            end
            coroutine.start(fun)
    end
    print("现在我按没按！"..tostring(isPressed))

    if isPressed then
        if this.OnPressTimer then
            this.OnPressTimer:Kill()
        end
        this.OnPressTimer = TimeUtil:CreateTimer(1.5,OnComplete)
    else


        this.OnPressTimer:Kill()

        if(this.startlongadd ==true) then
            this.startlongadd =false
            return
        end
        if go~=nil then
            this:DeleteDayingItem(go)
        end
        

    end
end

--@Des 删除大营区域的相应卡牌
--@params go(GameObject)：点击的卡牌图标
function wnd_biandui_controller:DeleteDayingItem(go)

    local item = go.transform.parent.parent.parent.gameObject
    if(item == nil) then
        return
    end

    local key1
    local key2

    local DayingData = nil
    local DayingItem = nil

    local CardData = nil
    local CardItem = nil

    for k,v in pairs(this.dayingitem_pic_list) do
        if(v.name == item.name) then
            key1 = k
            DayingItem = v
            for a,b in pairs(this.DayingItemList) do
                if(tostring(b["ArmyCardID"]) == item.name) then
                    key2 = a
                    DayingData = b
                end
            end
        end
    end

    for k,v in pairs(this.carditem_pic_list) do
        if(v.name == item.name) then
            CardItem = v
            for a,b in pairs(this.CardItemList) do
                if(tostring(b["ArmyCardID"]) == item.name) then
                    CardData = b
                end
            end
        end
    end

    if(DayingData == nil or DayingItem == nil) then
        return
    end

    CardData["Num"] = CardData["Num"]+1
    CardItem.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text = "x"..tostring(CardData["Num"])

    DayingData["Num"] = DayingData["Num"]-1
    DayingItem.transform:Find("card_item_frame/card_item_numc_bg/card_item_num"):GetComponent("UILabel").text = "x"..tostring(DayingData["Num"])

    if(DayingData["Num"] == 0) then
        this.startlongadd =false
        DayingItem:SetActive(false)
        table.remove(this.dayingitem_pic_list,key1)
        this.view.AddIcon.transform:SetAsLastSibling()
        table.remove(this.DayingItemList,key2)
        if(this.view.select_card_panel.activeSelf) then
            this.view.select_card_panel:SetActive(false)
        end
        GameObject.Destroy(DayingItem)
        this.view.AddIcon.transform:SetAsLastSibling()
        this.view.daying_item_grid:GetComponent("UIGrid").enabled = true
    end
    this:SetBlingli()
end
-----------------------------------------------------------------

return wnd_biandui_controller