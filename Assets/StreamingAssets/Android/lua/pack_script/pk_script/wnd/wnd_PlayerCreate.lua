--region *.lua
--Date 20150807
--角色创建界面
--作者 wenchuan

wnd_PlayerCreate = nil--单例

local class_wnd_PlayerCreate = class(wnd_base)

local SEX = {
    man = 1,
    woman = 2
}

function class_wnd_PlayerCreate:Start()
    self:Init(WND.PlayerCreate )
    wnd_PlayerCreate = self
end
 

function class_wnd_PlayerCreate:OnNewInstance()
    --界面实例被重建的时候，同时复位选中的性别
    self.seldSex = SEX.man
     
    --绑定随机姓名按钮
    self:BindUIEvent("randname",UIEventType.Click,"OnRandNameClick")

    --绑定男性角色按钮事件
    self:BindUIEvent("man",UIEventType.Click,"OnSexBtnClick")

    --绑定女性角色按钮事件
    self:BindUIEvent("woman",UIEventType.Click,"OnSexBtnClick")

    --绑定创建角色按钮
    self:BindUIEvent("btn_go",UIEventType.Click,"OnGoClick")

    --立即随机一次名字
    self:RandName()
end

function class_wnd_PlayerCreate:OnGoClick(gameObject,_) 
    StartCoroutine(self,self.coCreatePlayer,nil)
end

function class_wnd_PlayerCreate:coCreatePlayer(_) 
    
    local ipt = self:GetInput("playerName")
     
    local plyName = ipt:GetValue()
     
    local jsonNM = JsonParse.SendNM("createPlayer")
    jsonNM:Add("name",plyName)
     
    jsonNM:Add("sex",self.seldSex)
     
    local loader = Loader.new(jsonNM:ToString(),0,"reCreatePlayer")
    local json_result = LoaderEX.SendJsonAndWait(loader)
    if(json_result==nil) then  return  end --发送超时，或失败
     
    if(tonumber(json_result:GetValue("isok"))~=1) then
        --创建角色失败
        Application.PopTip("创建角色失败",Color.red)
    else
        --创建角色成功
        Application.PopTip("创建角色成功",Color.green)

        --隐藏界面
        self:Hide()
    end
end

function class_wnd_PlayerCreate:OnRandNameClick(gameObject,_)
    self:RandName()
end

function class_wnd_PlayerCreate:OnSexBtnClick(gameObject,_)
    local clickSex = ifv(gameObject:GetName()=="man",SEX.man,SEX.woman)

    if(self.seldSex ~= clickSex) then
        self.seldSex = clickSex   
        self:RandName()
    end
end

function class_wnd_PlayerCreate:RandName()
    local sdata_username_xing = require "sdata.sdata_username_xing"
    local sdata_username_boy = require "sdata.sdata_username_boy"
    local sdata_username_girl = require "sdata.sdata_username_girl"

    local xing = sdata_username_xing:RandItem()
    local ming = ifv(
                    self.seldSex==SEX.man,
                    sdata_username_boy:RandItem(),
                    sdata_username_girl:RandItem()
                  )
    local label = self:GetInput("playerName")
    label:SetValue(xing..ming)
end


return class_wnd_PlayerCreate.new
 

--endregion
