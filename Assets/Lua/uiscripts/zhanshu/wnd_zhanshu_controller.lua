

wnd_zhanshu_controller = {


}


local class = require("common/middleclass")
wnd_zhanshu_controller = class("wnd_zhanshu_controller", wnd_base)
local this = wnd_zhanshu_controller
local instance = nil

function wnd_zhanshu_controller:OnShowDone()
    instance = self
    --TODO:激活和初始化函数逻辑要分开
    print("caocaocao")
    this.model = require("uiscripts/zhanshu/wnd_zhanshu_model")
    this.model:initModel()
    this.view = require("uiscripts/zhanshu/wnd_zhanshu_view")
    this.view:initview(self)
    this:InitLabel()

    this:InitData()
    this:InitCardItemList()
    this:InitListener()
    print("wnd_zhanshu_controller +++++++ OnShowDone")
    --printw(inspect(this))
    --printw(inspect(instance))
    --instance:Hide(0)
    --instance:Destroy(0)
end

function wnd_zhanshu_controller:OnReOpenDone()
    this.model:initModel()

    for k,v in pairs(this.model.CardDataList) do
        for a,b in pairs(this.CardItemList) do
            if( v["ArmyCardID"] == b["Data"]["ArmyCardID"]) then
                if(v["Level"] ~= b["Data"]["Level"]) then
                    b["Data"]["Level"] = v["Level"]
                    b["Pic"].transform:Find("lv_frame/lv_bg/lv_label").gameObject:GetComponent("UILabel").text = "LV."..tostring(v["Level"])
                elseif(v["Star"] ~= b["Data"]["Star"]) then
                    b["Data"]["Star"] = v["Star"]
                    this:SetStar(b["Pic"], v["Star"], 1)
                elseif(v["CardNum"] ~= b["Data"]["CardNum"]) then
                    b["Data"]["CardNum"] = v["CardNum"]
                elseif(v["StarCost"] ~= b["Data"]["StarCost"]) then
                    b["Data"]["StarCost"] = v["StarCost"]
                elseif(v["UseLimitCost"] ~= b["Data"]["UseLimitCost"]) then
                    b["Data"]["UseLimitCost"] = v["UseLimitCost"]
                end
                if(b["Pic"].transform:Find("card_jindu_frame/card_ns_widget/card_ns_icon"):GetComponent("UISprite").spriteName =="duihuanshangdian_tubiao_keshengkapai") then
                    b["Pic"].transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(b["Data"]["CardNum"]).."/"..tostring(b["Data"]["UseLimitCost"])
                    this:SetCardJindu(b["Data"]["CardNum"], b["Data"]["UseLimitCost"], b["Pic"].transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
                else
                    b["Pic"].transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(b["Data"]["CardNum"]).."/"..tostring(b["Data"]["StarCost"])
                    this:SetCardJindu(b["Data"]["CardNum"], b["Data"]["StarCost"], b["Pic"].transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
                end
            end
        end
    end


    for _,v in pairs(this.model.CardDataList) do
        local ishave = false
        for _,k in pairs(this.CardItemList) do
            if(v["ArmyCardID"] == k["Data"]["ArmyCardID"]) then
                ishave = true
            end
        end
        if(not ishave) then
            local CardData = {}
            CardData = v
            local go = nil
            go =  GameObjectExtension.InstantiateFromPreobj(this.view.carditem,this.view.cardGrid)
            this:SetCardPic(go, CardData,false)
            go:SetActive(true)
            local CardItem = {}
            CardItem["Data"] = CardData
            CardItem["Pic"] = go
            table.insert(this.CardItemList,CardItem)
            this.view.cardGrid:GetComponent("UIGrid"):Reposition()
            --绑定动画
            --TODO:测试一下动画绑定事件
            this:KillAllToggleAnime()
            this:BindingAll()
            this:StartAllToggleAnime()
        end
    end
end

------初始化部分-----------------------------
function wnd_zhanshu_controller:InitLabel()
    this.view.btn_change_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50001)
    this.view.tag_all_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50003)
    this.view.tag_human_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50004)
    this.view.tag_beast_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50005)
    this.view.tag_machine_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50006)
    this.view.weijihuolabel:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50007)
    this.view.tuiyi_intro_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50008)
    this.view.tuiyi_award_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50009)
    this.view.btn_tuiyi_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",500010)
end

function wnd_zhanshu_controller:InitData()
    this.selectedtag = "tag_all"
    this.view.tags[this.selectedtag]:GetComponent(typeof(UISprite)).spriteName = "kapai_sibianxing_xuanzhong"

    this.CardItemList = {}
    this.OnDrag = false
    this.tuiyiCanbeAdd = false

    this.RetireItemList = {}
    this.tuiyi_award = 0
    this.view.tuiyi_award_num:GetComponent("UILabel").text = tostring(this.tuiyi_award)

    this.PanelState = "soldier_info"
    this.DragState = ""
    this.isclone = false
    this.tweeningList = {}
    this.tuiyiCanbeBack = false
    this.ShowItemData = nil
end

function wnd_zhanshu_controller:InitCardItemList()
    this.view.cardGrid:GetComponent("UIGrid").enabled = true

    if(#this.model.CardDataList == 0) then
        return
    end
    this.view.info_retire_bg:SetActive(true)

    local go = nil
    for index=1,#this.model.CardDataList do
        local CardData = {}
        CardData = this.model.CardDataList[index]
        if(index == 1) then
            go = this.view.carditem
        else
            go =  GameObjectExtension.InstantiateFromPreobj(this.view.carditem,this.view.cardGrid)
        end
        this:SetCardPic(go, CardData,false)
        go:SetActive(true)
        local CardItem = {}
        CardItem["Data"] = CardData
        CardItem["Pic"] = go
        table.insert(this.CardItemList,CardItem)
    end

    this:ReSetCardList()

    for i=1,#this.CardItemList do
        if(this.CardItemList[i]["Data"]["Active"] == true) then
            this:ShowCardInfo(this.CardItemList[i]["Pic"].transform:Find("card_bg/card_icon").gameObject)
            this.ShowItemData = this.CardItemList[i]["Data"]
            break
        end
    end

    --this:BindingToggleAnime(this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget").gameObject:GetComponent(typeof(UIWidget)))
    this:BindingAll()
    this:StartAllToggleAnime()
end

function wnd_zhanshu_controller:InitListener()
    for k,v in pairs(this.view.tags) do
        UIEventListener.Get(v).onPress = function(go,isPressed)
            this:ChangeCard(go,isPressed)
        end
    end

    for i=1,#this.view.skills do
        UIEventListener.Get(this.view.skills[i]).onPress = function(go,isPressed)
            this:ShowTips(go,isPressed)
        end
    end

    UIEventListener.Get(this.view.btn_change).onClick = function()
        this:ChangePanel()
    end

    UIEventListener.Get(this.view.btn_soldierctr).onClick = function()
        this:ChangeRetireorInfo()
    end

    for k,v in pairs(this.CardItemList) do
        UIEventListener.Get(v["Pic"].transform:Find("card_bg/card_icon").gameObject).onPress = function(go,isPressed)
            this:Judgestate(go,isPressed)
        end

        UIEventListener.Get(v["Pic"].transform:Find("card_bg/card_icon").gameObject).onDragStart = function(go)
            this.OnDrag = true
        end

        UIEventListener.Get(v["Pic"].transform:Find("card_bg/card_icon").gameObject).onDrag = function(go,TouchPosition)
            --TODO:未激活的不给加
            this.OnDrag = true
            this:DragStateCtr(go,TouchPosition)
        end
        UIEventListener.Get(v["Pic"].transform:Find("card_bg/card_icon").gameObject).onDragEnd = function(go)
            this:DragEndCtr(go)
        end
    end

    UIEventListener.Get(this.view.btn_tuiyi).onClick = function()
        this:TuiyiCtr()
    end

    UIEventListener.Get(this.view.btn_back).onClick = function()
        this:ClosePanel()
        instance:Hide(0)
    end

    UIEventListener.Get(this.view.btn_biandui).onClick = function()
        this:GotoBiandui()
    end

    UIEventListener.Get(this.view.xiangqing_bg).onClick = function()
        this:GOtoCardYc(this.ShowItemData["ArmyCardID"])
    end
end
---------------------------------------------

----------显示卡牌信息---------------
--@Des 根据选择的类型筛选显示卡牌
function wnd_zhanshu_controller:ChangeCard(go,isPressed)
    if(not isPressed) then
        return
    end
    if(this.selectedtag~=nil and this.selectedtag ~= go.name) then
        this.view.tags[this.selectedtag]:GetComponent(typeof(UISprite)).spriteName = "kapai_sibianxing_weixuanzhong"
    end

    this.view.tags[go.name]:GetComponent(typeof(UISprite)).spriteName = "kapai_sibianxing_xuanzhong"
    this.selectedtag = go.name

    local ctype = 0
    if (go.name == "tag_human") then
        ctype = 1
    elseif (go.name == "tag_machine") then
        ctype = 3
    elseif(go.name == "tag_beast") then
        ctype = 2
    end

    if(ctype == 0) then
        for i=1,#this.CardItemList do
            this.CardItemList[i]["Pic"]:SetActive(true)
        end
        this:ReSetCardList()
    else
        for i=1,#this.CardItemList do
            if( this.CardItemList[i]["Data"]["ArmyType"] == ctype) then
                this.CardItemList[i]["Pic"]:SetActive(true)
                if(this.CardItemList[i]["Data"]["Active"] == false) then
                    this.CardItemList[i]["Pic"].transform:SetAsLastSibling()
                end
            end
        end

        for i=1,#this.CardItemList do
            if(this.CardItemList[i]["Data"]["ArmyType"] ~= ctype) then
                this.CardItemList[i]["Pic"]:SetActive(false)
                this.CardItemList[i]["Pic"].transform:SetAsLastSibling()
            end
        end
        this.view.cardGrid:GetComponent("UIGrid"):Reposition()
    end
    this.view.cardpanel:GetComponent(typeof(UIScrollView)):ResetPosition()
end

--@Des 为每一个技能显示Tips
function wnd_zhanshu_controller:ShowTips(go,isPressed)
    if(not isPressed) then
        this.view.skill_tips_bg:SetActive(false)
        return
    end
    local skillnum = tonumber(string.sub(go.name,11,11))
    this.view.skill_tips_bg.transform:Find("cardskill/card_skill_label"):GetComponent("UILabel").text = this.ShowItemData["AllSkill"][skillnum]["SkillName"]
    this.view.skill_tips_bg.transform:Find("cardskill/cardskill_icon"):GetComponent("UISprite").spriteName = this.ShowItemData["AllSkill"][skillnum]["Icon"]
    this.view.skill_tips_bg.transform:Find("cardskill/cardskill_intro_label"):GetComponent("UILabel").text = this.ShowItemData["AllSkill"][skillnum]["Des"]
    this.view.skill_tips_bg:SetActive(true)
end

--@Des 显示卡牌信息
function wnd_zhanshu_controller:ShowCardInfo(go)
    if(this.OnDrag) then
        this.OnDrag = false
        return
    end
    local CardData = {}
    for k,v in pairs(this.CardItemList) do
        if(v["Pic"].name == go.transform.parent.parent.gameObject.name) then
            CardData = v["Data"]
        end
    end

    if(CardData["Active"] == false) then
        this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget").gameObject.transform.localPosition = Vector3(9999,9999,0)
        this.view.xiangqing_bg:SetActive(false)
        this.view.weijihuo_bg:SetActive(true)
    else
        this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget").gameObject.transform.localPosition = Vector3(0,0,0)
        this.view.xiangqing_bg:SetActive(true)
        this.view.weijihuo_bg:SetActive(false)
    end


    this:SetCardPic(this.view.cardinfo_item, CardData,true)
    this.view.cardinfo_item:SetActive(true)
    this.view.cardinfo_characteristic:GetComponent(typeof(UILabel)).text = CardData["Des"]

    this.view.intro_label1:GetComponent("UILabel").text = CardData["GeneralType"].."单位"
    this.view.intro_label2:GetComponent("UILabel").text = CardData["RangeType"]
    this.view.intro_label3:GetComponent("UILabel").text = CardData["AimGeneralType"].."打击"


    for i=1,5 do
        if(CardData["AllSkill"][i]["SkillLv"] == 0 )then
            this.view.skills[i].transform:Find("card_skill_weijihuo").gameObject:SetActive(true)
        else
            this.view.skills[i].transform:Find("card_skill_weijihuo").gameObject:SetActive(false)
        end
        this.view.skills[i].transform:Find("cardskill_icon"):GetComponent("UISprite").spriteName = CardData["AllSkill"][i]["Icon"]
        this.view.skills[i].transform:Find("card_skill_label"):GetComponent("UILabel").text = CardData["AllSkill"][i]["SkillName"]
    end

    local spritestr = ""
    if(CardData["ArmyType"] ==1) then
        spritestr = "kapai_tubiao_renzu_da"
    elseif (CardData["ArmyType"] ==2)then
        spritestr = "kapai_tubiao_shouzu"
    elseif (CardData["ArmyType"] ==3)then
        spritestr = "kapai_tubiao_zhixie"
    end
    this.view.cardinfo_type:GetComponent("UISprite").spriteName = spritestr

    this.ShowItemData = CardData
    print("单击 单击 单击！")
end

-------------------------------------------------------


------------卡牌拖动部分--------------
--@Des 卡牌拖动处理
function wnd_zhanshu_controller:DragStateCtr(go,TouchPosition)
    if(this.PanelState == "soldier_info") then
        return
    end

    local DragsumX = 0
    local DragsumY = 0
    if(this.DragState == "up_down") then
        --如果是上下拖则返回
        return
    elseif(this.DragState == "left_right") then
        --如果是左右拖则进行克隆卡牌拖动处理
        this:AddCloneCardToTuiyi(go,TouchPosition)
    else
        --如果还没有拖动状态则进行拖动判定
        DragsumX = TouchPosition.x
        DragsumY = TouchPosition.y
        if(TouchPosition.y<0) then
            DragsumY = -DragsumY
        end
        if(TouchPosition.x<0) then
            DragsumX = -DragsumX
        end

        if(DragsumY/DragsumX >0.36) then
            this.DragState = "up_down"
        elseif(DragsumY/DragsumX <0.36) then
            this.DragState = "left_right"
        end
        if (this.DragState == "left_right") then
            this.view.clone_card_panel.transform.localPosition = this.view.info_retire_bg.transform.localPosition
            go:GetComponent("UIDragScrollView").enabled = false
            this:AddCloneCardToTuiyi(go,TouchPosition)
        end
    end
end

--@Des 拖动克隆卡牌进入退役区域
function wnd_zhanshu_controller:AddCloneCardToTuiyi(go,TouchPosition)
    if(not this.isclone) then
        local CardData = {}
        for k,v in pairs(this.CardItemList) do
            if(v["Pic"].name == go.transform.parent.parent.gameObject.name) then
                CardData = v["Data"]
                if(CardData["CardNum"] == 0 ) then
                    --如果没有卡牌就返回
                    print("返回喽！")
                    return
                end
            end
        end
        this.view.card_clone.transform.position = go.transform.position
        this.view.card_clone:GetComponent("UISprite").spriteName = CardData["IconID"]
        this.view.clone_card_panel:SetActive(true)
        this.isclone = true
    else
        local v =  Vector3(this.view.card_clone.transform.localPosition.x+TouchPosition.x,this.view.card_clone.transform.localPosition.y+TouchPosition.y,this.view.card_clone.transform.localPosition.z)
        this.view.card_clone.transform.localPosition = v
    end

    local c_p = this.view.card_clone.transform.localPosition
    local p_s = this.view.info_retire_bg:GetComponent("UIWidget").localSize
    if(c_p.x > -p_s.x/2 and c_p.x<p_s.x/2 and c_p.y > -p_s.y/2 and c_p.y<p_s.y/2) then
        this.tuiyiCanbeAdd = true
    else
        this.tuiyiCanbeAdd = false
    end
end

function wnd_zhanshu_controller:DragEndCtr(go)
    this.DragState = ""
    this.isclone = false
    this.view.card_clone.transform.localPosition = Vector3(0,0,0)
    this.view.clone_card_panel:SetActive(false)
    if(not go:GetComponent("UIDragScrollView").enabled) then
        go:GetComponent("UIDragScrollView").enabled = true
    end
    if(this.tuiyiCanbeAdd) then
        this:AddCardToRetire(go,false)
    end
end
------------------------------------

---------工具部分-------------------------
function wnd_zhanshu_controller:ReSetCardList()

    for i=1,#this.CardItemList do
        if(this.CardItemList[i]["Data"]["Active"] == true) then
            this.CardItemList[i]["Pic"].transform:SetAsLastSibling()
        end
    end

    for i=1,#this.CardItemList do
        if(this.CardItemList[i]["Data"]["Active"] == false) then
            this.CardItemList[i]["Pic"].transform:SetAsLastSibling()
        end
    end

    this.view.cardGrid:GetComponent("UIGrid"):Reposition()

end




--@Des 设置卡牌图片
function wnd_zhanshu_controller:SetCardPic(go,CardData,isShowInfo)
    if(CardData["Active"] == true) then
        if(not isShowInfo) then
            if(go.transform:Find("card_weijihuo").gameObject.activeSelf) then
                go.transform:Find("card_weijihuo").gameObject:SetActive(false)
            end
        end
        go.transform.name = tostring(CardData["ArmyCardID"])
        go.transform:Find("card_bg/card_icon"):GetComponent(typeof(UISprite)).spriteName = CardData["IconID"]
        go.transform:Find("card_name/card_name_label"):GetComponent(typeof(UILabel)).text = CardData["Name"]
        go.transform:Find("card_bg/lv_frame/lv_bg/lv_label"):GetComponent(typeof(UILabel)).text = "LV."..tostring(CardData["Level"])
        if(go.transform:Find("card_jindu_frame/card_ns_widget").gameObject.activeSelf == false) then
            go.transform:Find("card_jindu_frame/card_ns_widget").gameObject:SetActive(true)
        end
        if(go.transform:Find("card_jindu_frame/card_ns_widget/card_ns_icon"):GetComponent("UISprite").spriteName =="duihuanshangdian_tubiao_keshengkapai") then
            go.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(CardData["CardNum"]).."/"..tostring(CardData["UseLimitCost"])
            this:SetCardJindu(CardData["CardNum"], CardData["UseLimitCost"], go.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
        else
            go.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(CardData["CardNum"]).."/"..tostring(CardData["StarCost"])
            this:SetCardJindu(CardData["CardNum"], CardData["StarCost"], go.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
        end
        this:SetStar(go,CardData["Star"],1)
    else
        if(not isShowInfo) then
            go.transform:Find("card_weijihuo").gameObject:SetActive(true)
        end
        go.transform.name = tostring(CardData["ArmyCardID"])
        go.transform:Find("card_bg/card_icon"):GetComponent(typeof(UISprite)).spriteName = CardData["IconID"]
        go.transform:Find("card_name/card_name_label"):GetComponent(typeof(UILabel)).text = CardData["Name"]
        go.transform:Find("card_bg/lv_frame/lv_bg/lv_label"):GetComponent(typeof(UILabel)).text = "LV."..tostring(CardData["Level"])
        go.transform:Find("card_jindu_frame/card_ns_widget").gameObject:SetActive(false)
        this:SetStar(go,CardData["Star"],1)
    end
end

--@Des 在单击卡牌时判断面板状态
function wnd_zhanshu_controller:Judgestate(go,isPressed)
    if(this.PanelState == "soldier_info") then
        if(isPressed) then
            return
        end
        ---如果是士兵信息板则显示信息---
        this:ShowCardInfo(go)
    elseif(this.PanelState == "soldier_retire") then
        ---如果是退役面板则添加到退役格中---
        this:AddCardToRetire(go,isPressed)
    end
end

--@Des 设置卡牌进度条缩放
function wnd_zhanshu_controller:SetCardJindu(CardNum,Cardlimit,pic)
    if(Cardlimit == 0) then
        pic.transform.localScale = Vector3(1,1,1)
        return
    end
    -----按百分比显示------
    local num = CardNum/Cardlimit
    if(num < 1) then
        pic.transform.localScale = Vector3(num,1,1)
    else
        pic.transform.localScale = Vector3(1,1,1)
    end
    return
end

--@Des 设置卡牌上的星星
--@Params item(gameObject) 卡牌
--        num(number) 星星的数量
--        interval(interval) 星星之间的间距
function wnd_zhanshu_controller:SetStar(item,num,interval)
    --TODO：考虑num为0的情况----
    local star  = item.transform:Find("card_bg/star_bg/star1").gameObject
    local star_bg = item.transform:Find("card_bg/star_bg").gameObject
    local childCount = star_bg.transform.childCount

    local cpx = 0
    local starlst = {}

    for i=1,childCount do
        starlst[i] = star_bg.transform:Find("star"..tostring(i)).gameObject
        if(not starlst[i].activeSelf) then
            starlst[i]:SetActive(true)
        end
    end

    if(num>childCount) then
        for i=childCount+1,num do
            starlst[i] = GameObjectExtension.InstantiateFromPreobj(star,item.transform:Find("card_bg/star_bg").gameObject)
            starlst[i].name = "star"..tostring(i)
            starlst[i]:SetActive(true)
        end
    elseif(num<childCount) then
        for i=num+1,childCount do
            starlst[i]:SetActive(false)
        end
    end

    if(num%2 ~= 0) then
        ---奇数情况---
        starlst[1].transform.localPosition = Vector3(0,0,0)
        for k =3,num,2 do
            cpx = cpx+1
            local moveposx = cpx*star:GetComponent(typeof(UIWidget)).localSize.x
            starlst[k].transform.localPosition = Vector3(moveposx+interval,0,0)
            starlst[k-1].transform.localPosition = Vector3(-moveposx-interval,0,0)
        end
    elseif(num%2 == 0) then
        ---偶数情况---
        starlst[1].transform.localPosition = Vector3(-4.5,0,0)
        starlst[2].transform.localPosition = Vector3(4.5,0,0)
        for k =4,num,2 do
            cpx = cpx+1
            local moveposx = cpx*star:GetComponent(typeof(UIWidget)).localSize.x
            interval = interval/2 + star:GetComponent(typeof(UIWidget)).localSize.x/2
            starlst[k].transform.localPosition = Vector3(moveposx+interval,0,0)
            starlst[k-1].transform.localPosition = Vector3(-moveposx-interval,0,0)
        end
    else
        print("输入数据有误")
    end
end

--@Des 更换显示士兵/技能面板
function wnd_zhanshu_controller:ChangePanel()
    local str = ""
    this:ChangeState(this.view.soldierpanel, this.view.skillpanel)
    if(this.view.soldierpanel.activeSelf) then
        str = sdata_UILiteral:GetFieldV("Literal",50001)
    else
        str = sdata_UILiteral:GetFieldV("Literal",50002)
    end
    this.view.btn_change_label:GetComponent(typeof(UILabel)).text = str
end

--@Des 更换显示退役/信息面板
function wnd_zhanshu_controller:ChangeRetireorInfo()
    local str = ""
    this:ChangeState(this.view.info_panel, this.view.retire_panel)
    if(this.view.info_panel.activeSelf) then
        str = "kapai_anniu_tuiyi"
        this.PanelState = "soldier_info"
        this:TuiyiCtr()
    else
        str = "tuiyi_anniu_xinxi"
        this.PanelState = "soldier_retire"
    end
    this.view.btn_soldierctr:GetComponent(typeof(UISprite)).spriteName = str
end

--@Des  切换两个面板的显示状态
--@Params panelA(gameObject):面板一
--        panelB(gameObject):面板二
function wnd_zhanshu_controller:ChangeState(panelA,panelB)
    if(panelA.activeSelf) then
        panelA:SetActive(false)
        panelB:SetActive(true)
    else
        panelA:SetActive(true)
        panelB:SetActive(false)
    end
end

--@Des 关闭此面板
function wnd_zhanshu_controller:ClosePanel()
    --  this:KillAllToggleAnime()
    if(this.view.skillpanel.activeSelf) then
        this.view.skillpanel:SetActive(false)
        this.view.soldierpanel:SetActive(true)
        this.view.btn_change_label:GetComponent("UILabel").text = sdata_UILiteral:GetFieldV("Literal",50001)
    end

    if(this.view.retire_panel.activeSelf) then
        this.view.retire_panel:SetActive(false)
        this.view.info_panel:SetActive(true)
        this.view.btn_soldierctr:GetComponent("UISprite").spriteName = "kapai_anniu_tuiyi"
    end
    this:ChangeCard(this.view.tags["tag_all"], true)
    for i=1,#this.CardItemList do
        if(this.CardItemList[i]["Data"]["Active"] == true) then
            this:ShowCardInfo(this.CardItemList[i]["Pic"].transform:Find("card_bg/card_icon").gameObject)
            this.ShowItemData = this.CardItemList[i]["Data"]
            break
        end
    end
   -- this:ShowCardInfo(this.CardItemList[1]["Pic"].transform:Find("card_bg/card_icon").gameObject)

    this:TuiyiCtr()
    --instance:Hide(0)
end

--@Des 转换到编队界面
function wnd_zhanshu_controller:GotoBiandui()
    this:ClosePanel()
    instance:Hide(0)
    local function callback()
        ui_manager:ShowWB("ui_zhanshu")
    end
    ui_manager:ShowWB("ui_biandui",instance.wnd_base_id,callback)
end

--@Des 转换到卡牌信息界面
function wnd_zhanshu_controller:GOtoCardYc(cardId)
    wnd_cardyc_controller:ShowCard(cardId)
    instance:Hide(0)
    local function callback()
        ui_manager:ShowWB("ui_zhanshu")
    end
    ui_manager:ShowWB("ui_cardyc",instance.wnd_base_id,callback)
end
------------------------------------------

---------退役部分--------------------------
--@Des 点击退役按钮
function wnd_zhanshu_controller:TuiyiCtr()
    local CardToCoinItemLst = {}
    local lnum = 0

    if(#this.RetireItemList == 0) then
        return
    end

    for i=1,#this.RetireItemList do
        GameObject.Destroy(this.view.tuiyipic_list[i].transform:Find("retire_card").gameObject)
        for k,v in pairs(CardToCoinItemLst) do
            if(v["cardId"] == this.RetireItemList[i]) then
                v["num"] = v["num"]+1
            else
                lnum = lnum +1
            end
        end

        if(lnum == #CardToCoinItemLst) then
            local CardToCoinItem = {}
            CardToCoinItem["cardId"] = this.RetireItemList[i]
            CardToCoinItem["num"] = 1
            table.insert(CardToCoinItemLst,CardToCoinItem)
        end
        lnum = 0
    end

    for k,v in pairs(CardToCoinItemLst) do
        print("Id是"..tostring(v["cardId"]))
        print("num是"..tostring(v["num"]))
    end

    local on_10040_rec = function (body)
        print("on_10040_rec_ call")
        Event.RemoveListener("10040", on_10040_rec)
        local gw2c = gw2c_pb:CardToCoin()
        gw2c:ParseFromString(body)

        for k=1,#gw2c.lst do
            for i=1,#CardToCoinItemLst do
                if(gw2c.lst[k]["id"] == CardToCoinItemLst[i]["cardId"]) then
                    cardModel:setCardInfo(gw2c.lst[k])
                end
            end
        end

        currencyModel:setCoin(gw2c.currency)
        print("收到回调啦！")
    end
    Message_Manager:SendPB_10040(CardToCoinItemLst, on_10040_rec)
    this.RetireItemList = {}
    this.view.tuiyi_award_num:GetComponent("UILabel").text = "0"
    this.tuiyi_award = 0
    --TODO:增加退役兵牌，数量减1
    print("增加退役兵牌，数量减1")
end

--@Des 退役卡牌
function wnd_zhanshu_controller:AddCardToRetire(go,isPressed)
    if(isPressed) then
        return
    end
    print("Drag状态是"..tostring(this.OnDrag))
    print("Tuiyi状态是"..tostring(this.tuiyiCanbeAdd))
    if(this.OnDrag and (not this.tuiyiCanbeAdd)) then
        this.OnDrag = false
        return
    end

    local CardData = {}
    local Card = go.transform.parent.parent.gameObject
    for k,v in pairs(this.CardItemList) do
        if(v["Pic"].name == Card.name) then
            CardData = v["Data"]
        end
    end

    if(#this.RetireItemList <12 and CardData["CardNum"] >0) then
        this.RetireItemList[#this.RetireItemList+1] = CardData["ArmyCardID"]

        local cardItem = nil
        cardItem = GameObjectExtension.InstantiateFromPreobj(this.view.card_clone,this.view.tuiyipic_list[#this.RetireItemList])
        cardItem.transform.localPosition = Vector3(0,0,0)

        cardItem.name = "retire_card"
        cardItem:SetActive(true)
        cardItem:GetComponent(typeof(UISprite)).spriteName = CardData["IconID"]

        this.tuiyi_award = this.tuiyi_award + CardData["ExchangeCoin"]
        this.view.tuiyi_award_num:GetComponent("UILabel").text = tostring(this.tuiyi_award)
        CardData["CardNum"] = CardData["CardNum"] - 1
        if(Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_icon"):GetComponent("UISprite").spriteName =="duihuanshangdian_tubiao_keshengkapai") then
            Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(CardData["CardNum"]).."/"..tostring(CardData["UseLimitCost"])
            this:SetCardJindu(CardData["CardNum"], CardData["UseLimitCost"], Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
        else
            Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(CardData["CardNum"]).."/"..tostring(CardData["StarCost"])
            this:SetCardJindu(CardData["CardNum"], CardData["StarCost"], Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
        end
        this:AddlistenerForTuiyiCard()
    end
    if(this.tuiyiCanbeAdd) then
        this.tuiyiCanbeAdd = false
    end
end
-------------------------------------------


----------淡入淡出动画部分-------------
--@Des 设置动画渐变转换事件
function wnd_zhanshu_controller:ToggleIndicator()
    for i = 1,#this.CardItemList,1 do
        if(this.CardItemList[i]["Data"]["Active"] == true) then
            local cardItem = this.CardItemList[i]["Pic"]
            local cardData = this.CardItemList[i]["Data"]
            local card_ns_icon = cardItem.transform:Find("card_jindu_frame/card_ns_widget/card_ns_icon").gameObject
            local card_ns_pic = cardItem.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject
            local card_ns_label = cardItem.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject
            if(card_ns_icon:GetComponent("UISprite").spriteName =="duihuanshangdian_tubiao_keshengkapai") then
                card_ns_icon:GetComponent("UISprite").spriteName = "duihuanshangdian_tubiao_keshengxing"
                card_ns_pic:GetComponent("UISprite").spriteName = "duihuanshangdian_juxing_shuzhi_shengxing"
                card_ns_label:GetComponent("UILabel").text = tostring(cardData["CardNum"]).."/"..tostring(cardData["StarCost"])
                this:SetCardJindu(cardData["CardNum"], cardData["StarCost"], cardItem.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
            else
                card_ns_icon:GetComponent("UISprite").spriteName = "duihuanshangdian_tubiao_keshengkapai"
                card_ns_pic:GetComponent("UISprite").spriteName = "duihuanshangdian_juxing_shuzhi_shengkapai"
                card_ns_label:GetComponent("UILabel").text = tostring(cardData["CardNum"]).."/"..tostring(cardData["UseLimitCost"])
                this:SetCardJindu(cardData["CardNum"], cardData["UseLimitCost"], cardItem.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
            end
        end
    end


    local cardData = {}
    for k,v in pairs(this.CardItemList) do
        if(v["Pic"].name == this.view.cardinfo_item.name) then
            cardData = v["Data"]
        end
    end

    local card_ns_icon = this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget/card_ns_icon").gameObject
    local card_ns_pic = this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject
    local card_ns_label = this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject
    if(card_ns_icon:GetComponent("UISprite").spriteName =="duihuanshangdian_tubiao_keshengkapai") then
        card_ns_icon:GetComponent("UISprite").spriteName = "duihuanshangdian_tubiao_keshengxing"
        card_ns_pic:GetComponent("UISprite").spriteName = "duihuanshangdian_juxing_shuzhi_shengxing"
        card_ns_label:GetComponent("UILabel").text = tostring(cardData["CardNum"]).."/"..tostring(cardData["StarCost"])
        this:SetCardJindu(cardData["CardNum"], cardData["StarCost"], this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
    else
        card_ns_icon:GetComponent("UISprite").spriteName = "duihuanshangdian_tubiao_keshengkapai"
        card_ns_pic:GetComponent("UISprite").spriteName = "duihuanshangdian_juxing_shuzhi_shengkapai"
        card_ns_label:GetComponent("UILabel").text = tostring(cardData["CardNum"]).."/"..tostring(cardData["UseLimitCost"])
        this:SetCardJindu(cardData["CardNum"], cardData["UseLimitCost"], this.view.cardinfo_item.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
    end
end



--@Des 绑定所有淡入淡出动画
function wnd_zhanshu_controller:BindingAll()
    for i = 1,#this.CardItemList,1 do
        if(this.CardItemList[i]["Data"]["Active"]) then
            local picwidget = this.CardItemList[i]["Pic"].transform:Find("card_jindu_frame/card_ns_widget").gameObject:GetComponent(typeof(UIWidget))
            this:BindingToggleAnime(picwidget)
        end
    end
end

--@Des 绑定淡入淡出动画
--@params widget(widget)
function wnd_zhanshu_controller:BindingToggleAnime(widget)
    widget.alpha = 0
    local sq = DG.Tweening.DOTween.Sequence()
    local splashTweener = DG.Tweening.DOTween.ToAlpha(
    function() return widget.color end,
    function(color) widget.color = color end,
    1, 0.5)
    local fadeTweener = DG.Tweening.DOTween.ToAlpha(
    function() return widget.color end,
    function(color) widget.color = color end,
    0, 0.5)

    sq:Append(splashTweener)
    sq:AppendInterval(3)
    sq:Append(fadeTweener)

    if #this.tweeningList == 0 then
        sq:OnComplete(function() this:ToggleIndicator() sq:Restart(true) end)
    else
        sq:OnComplete(function() sq:Restart(true) end)
    end
    sq:Pause()
    table.insert(this.tweeningList,sq)
end

--@Des 开始所有动画
function wnd_zhanshu_controller:StartAllToggleAnime()
    for _,v in ipairs(this.tweeningList) do
        v:Play()
    end
end

--@Des 停止所有动画
function wnd_zhanshu_controller:KillAllToggleAnime()
    for _,v in ipairs(this.tweeningList) do
        v:Kill(false)
    end
end
------------------------------------------

------------退役卡牌控制部分-------------
--@Des 给退役的卡牌添加响应
function wnd_zhanshu_controller:AddlistenerForTuiyiCard()
    local num = #this.RetireItemList
    UIEventListener.Get(this.view.tuiyipic_list[num].transform:Find("retire_card").gameObject).onPress = function(go,isPressed)
        if(isPressed) then
            return
        end
        this:TuiyiCardBack(go)
    end

    UIEventListener.Get(this.view.tuiyipic_list[num].transform:Find("retire_card").gameObject).onDragStart = function(go)
        this.OnDrag = true
        this.view.clone_card_panel.transform.localPosition = this.view.card_bg.transform.localPosition
        this.view.clone_card_panel:SetActive(true)
        this.view.card_clone:GetComponent("UISprite").spriteName = go:GetComponent("UISprite").spriteName
        this.view.card_clone.transform.position = go.transform.position
        go.transform.localPosition = Vector3(-99999,99999,0)
    end

    UIEventListener.Get(this.view.tuiyipic_list[num].transform:Find("retire_card").gameObject).onDrag = function(go,TouchPosition)
        this:TuiyiDragCtr(go,TouchPosition)
    end

    UIEventListener.Get(this.view.tuiyipic_list[num].transform:Find("retire_card").gameObject).onDragEnd = function(go)
        print("tuiyiCanbeBack")
        if(this.tuiyiCanbeBack) then
            this:TuiyiCardBack(go)
        else
            go.transform.localPosition = Vector3(0,0,0)
        end
        this.view.card_clone.transform.localPosition = Vector3(0,0,0)
        this.view.clone_card_panel:SetActive(false)
    end
end

--@Des 退役卡牌返回卡组
function wnd_zhanshu_controller:TuiyiCardBack(go)
    if(this.OnDrag) then
        this.OnDrag = false
        return
    end
    local CardData = nil
    local Card = nil
    for k,v in pairs(this.CardItemList) do
        if(v["Data"]["IconID"] == go:GetComponent("UISprite").spriteName) then
            CardData = v["Data"]
            Card = v["Pic"]
        end
    end

    if(CardData==nil or Card == nil) then
        return
    end
    CardData["CardNum"] = CardData["CardNum"]+1
    if(Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_icon"):GetComponent("UISprite").spriteName =="duihuanshangdian_tubiao_keshengkapai") then
        Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(CardData["CardNum"]).."/"..tostring(CardData["UseLimitCost"])
        this:SetCardJindu(CardData["CardNum"], CardData["UseLimitCost"], Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
    else
        Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_label").gameObject:GetComponent("UILabel").text = tostring(CardData["CardNum"]).."/"..tostring(CardData["StarCost"])
        this:SetCardJindu(CardData["CardNum"], CardData["StarCost"], Card.transform:Find("card_jindu_frame/card_ns_widget/card_ns_frame/card_ns_pic").gameObject)
    end

    this.tuiyi_award = this.tuiyi_award - CardData["ExchangeCoin"]
    this.view.tuiyi_award_num:GetComponent("UILabel").text = tostring(this.tuiyi_award)
    for i=1,12 do
        if(go.transform.parent.name == this.view.tuiyipic_list[i].name) then
            GameObject.Destroy(go)
            this:ResetTuiyiCard(i)
            break
        end
    end
end

--@Des 重置退役卡牌（位置前移）
function wnd_zhanshu_controller:ResetTuiyiCard(num)
    local item = nil
    for i=num+1,#this.RetireItemList do
        this.RetireItemList[i-1] = this.RetireItemList[i]
        if(this.view.tuiyipic_list[i].transform.childCount >0) then
            item = this.view.tuiyipic_list[i].transform:Find("retire_card").gameObject
            item.transform.parent = this.view.tuiyipic_list[i-1].transform
            item.transform.localPosition = Vector3(0,0,0)
        end
    end
    this.RetireItemList[#this.RetireItemList] = nil
end

--@Des 退役拖动处理
function wnd_zhanshu_controller:TuiyiDragCtr(go,TouchPosition)
    local v =  Vector3(this.view.card_clone.transform.localPosition.x+TouchPosition.x,this.view.card_clone.transform.localPosition.y+TouchPosition.y,this.view.card_clone.transform.localPosition.z)
    this.view.card_clone.transform.localPosition = v
    local c_p = this.view.card_clone.transform.localPosition
    local p_s = this.view.card_bg:GetComponent("UIWidget").localSize
    if(c_p.x > -p_s.x/2 and c_p.x<p_s.x/2 and c_p.y > -p_s.y/2 and c_p.y<p_s.y/2) then
        this.tuiyiCanbeBack = true
    else
        this.tuiyiCanbeBack = false
    end
end
---------------------------------------


return wnd_zhanshu_controller