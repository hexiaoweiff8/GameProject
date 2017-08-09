--[[
    ui_skill_controller:
        variable:
        bIsShowing            --技能面板是否被显示
        isInit                --技能面板是否被初始化
        lastskill             --上一次点击选择的技能
        skill1                --编队系统面板的技能槽位一
        selectbtn             --当前选择的技能槽位
        skillnum              --当前技能槽位数据
        self.view.skillselect --技能选中面板

        function:
        Show()                --显示面板
        addListener           --各个技能以及外部框加响应
        TriggerCtr            --外部碰撞框响应
        SelectSkill           --选择技能
        ChangeSkill           --更换技能
        SetSkill              --刷新编队系统技能图标
        Hide                  --隐藏面板
]]
 ui_skill_controller = {
    bIsShowing = false,
    isInit = false
}

--@Des 显示面板
--@params s1/s2/s3(gameObject):编队系统技能槽位一/二/三
--        go(gameObject):当前选中的技能槽位
--        v3(Vector3):技能面偏移位置
function ui_skill_controller:Show(s1,s2,s3,go,v3)
    if not self.isInit then
        self.view = require("uiscripts/skill/ui_skill_view")
        self.view:initView()

        self.isInit = true
        self.lastskill = nil

        self.skill1 = s1
        self.skill2 = s2
        self.skill3 = s3

    end

    self.selectbtn = go
    self.skillnum = tonumber(string.sub(go.name,7,7))

    if(not self.view.root.activeSelf) then
        self.view.root:SetActive(true)
        self.view.root.transform.localPosition = v3
        self.bIsShowing = true
        self:SetSkill()
        self:addListener()
    end
end

--@Des 技能/外部框添加响应
function ui_skill_controller:addListener()
    print("addListener")
    for k,v in pairs(self.view.skilllist) do
        UIEventListener.Get(v["pic"]).onPress = function (go,isPressed)
            self:SelectSkill(go,isPressed)
        end
    end

    UIEventListener.Get(self.view.ui_skill_panel_col).onPress = function (go,isPressed)
        self:TriggerCtr(go,isPressed)
    end
end

--@Des 外部碰撞框触发响应
function ui_skill_controller:TriggerCtr(go,isPressed)
    if(not isPressed) then
        return
    end
    ---关闭开着的技能选中面板---
    if(self.view.skillselect.activeSelf) then
        self.view.skillselect:SetActive(false)
    end
end

--@Des 选择技能
--@params go(gameObject):选中的技能
--        isPressed(bool):手按下抬起状态
function ui_skill_controller:SelectSkill(go,isPressed)

    if(not isPressed) then
        return
    end
    --for k,v in pairs(self.view.skilllist) do
    --    print("技能名字   "..v["pic"].name)
    --    print("技能挂载   "..tostring(v["data"]["selectstate"]))
    --end
    ---查找选中技能的数据---
    local thisskill = {}
    for k,v in pairs(self.view.skilllist) do
        if(v["pic"].name == go.name) then
            thisskill = v
            if(v["data"]["canbeselect"] == false) then
                return
            end
        end
    end

    ---更改边框为金色---
    if(self.lastskill == nil) then
        self.lastskill = go
    else
        self.lastskill:GetComponent(typeof(UISprite)).spriteName = "jinengxuanze_anniu_jinengkuang"
        self.lastskill = go
    end
    go:GetComponent(typeof(UISprite)).spriteName = "jinengxuanze_anniu_jinengkuang_xuanzhong"

    ---显示选中面板，设置位置---
    self.view.skillselect.transform.parent = go.transform
    self.view.skillselect.transform.localPosition = Vector3(0,-49,0)
    self.view.skillselect:SetActive(true)

    ---为选中面板的更换按钮添加监听---
    UIEventListener.Get(self.view.skillselect.transform:Find("skill_change").gameObject).onClick = function ()
        self:ChangeSkill(thisskill)
    end
end

--@Des 更换技能
--@params thisskill(table):当前更换的技能数据
function ui_skill_controller:ChangeSkill(thisskill)

    for k,v in pairs(self.view.skilllist) do
        if(v["data"]["selectstate"] == self.skillnum) then
            local temp = thisskill["data"]["selectstate"]
            thisskill["data"]["selectstate"] = v["data"]["selectstate"]
            v["data"]["selectstate"] = temp
        end
    end
    self:SetSkill()
end

--@Des 刷新编队系统技能图标
function ui_skill_controller:SetSkill()
    local go = nil

    local change = false
    local havepic = false


    for k,v in pairs(self.view.skilllist) do
        if(v["pic"].transform:Find("skill_icon").gameObject.transform.childCount == 1) then
            havepic = true
            --GameObject.Destroy(v["pic"].transform:Find("skill_icon/beselect").gameObject)
        else
            havepic = false
        end

        if(v["data"]["selectstate"] == 1) then
            self.skill1.transform:Find("skill_icon").gameObject:GetComponent(typeof(UISprite)).spriteName =
            v["pic"].transform:Find("skill_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
            change = true
        elseif (v["data"]["selectstate"] == 2) then
            self.skill2.transform:Find("skill_icon").gameObject:GetComponent(typeof(UISprite)).spriteName =
            v["pic"].transform:Find("skill_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
            change = true
        elseif (v["data"]["selectstate"] == 3) then
            self.skill3.transform:Find("skill_icon").gameObject:GetComponent(typeof(UISprite)).spriteName =
            v["pic"].transform:Find("skill_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
            change = true
        else
            change = false

        end

        if(change) then
            if(havepic) then
                v["pic"].transform:Find("skill_icon/beselect").gameObject:SetActive(true)
            else
                go =  GameObjectExtension.InstantiateFromPreobj(self.view.beselect,v["pic"].transform:Find("skill_icon").gameObject)
                go.name = "beselect"
                go.transform.localPosition = Vector3(0,0,0)
                go:SetActive(true)
            end
        else
            if(havepic) then
                v["pic"].transform:Find("skill_icon/beselect").gameObject:SetActive(false)
            end
        end
    end
end

--@Des 隐藏面板
function ui_skill_controller:Hide()
    if self.view.root.activeInHierarchy then
        if(self.view.skillselect.activeSelf) then
            self.view.skillselect:SetActive(false)
        end
        self.selectbtn:GetComponent(typeof(UISprite)).spriteName = "jinengxuanze_anniu_jinengkuang_weizhaungbei"
        self.view.root:SetActive(false)
        self.bIsShowing = false
    end
end

return ui_skill_controller