--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
wnd_CreateRole = nil

local wnd_CreateRoleClass = class(wnd_base)

function wnd_CreateRoleClass:Start()
    wnd_CreateRole = self
    self:Init(WND.CreateRole)

end
--有对象互访逻辑的初始化
function wnd_CreateRoleClass:CrossInit() 

end

function wnd_CreateRoleClass:Show(duration)
    self:_Show(duration)
end

function wnd_CreateRoleClass:OnNewInstance()
    self.input =self:GetInput("bg_widget/name_bg")
    local tips=self:GetLabel("bg/bg_widget/tips")
    tips:SetValue(SData_Id2String.Get(3260))
    local Input_txt = self:GetLabel("name_bg/txt")
    Input_txt:SetValue(SData_Id2String.Get(21))

    self:BindUIEvent("bg_widget/continue_btn", UIEventType.Click, "OnContinueClick")
    self:BindUIEvent("bg_widget/dice", UIEventType.Click, "OnRandomNameClick")
    
end

function wnd_CreateRoleClass:OnShowDone()
    require("sdata.sdata_username_xingming")
    
end

function wnd_CreateRoleClass:OnContinueClick()
    local userInput = self.input:GetValue()
    --如果输入框无内容
     if userInput == "" then
        Poptip.PopMsg(SData_Id2String.Get(3261), Color.red)
        return nil  
    end
    local strLen = self:NameStandard(userInput)
    if strLen > 12 then
        Poptip.PopMsg(SData_Id2String.Get(21), Color.red)
        return nil
    else
        StartCoroutine(self,self.IsContainUserName)
    end
    
end

function wnd_CreateRoleClass:NameStandard(str)
   local stringLen = 0
   local strLen = str:len()
   for i=1,strLen do
        local single = string.sub(str,i,i)
        local num = string.byte(single)
        if num > 127 then
           stringLen = stringLen+2
        else
           if string.char(num) ~= single then
             stringLen = stringLen + 2
           else
              stringLen = stringLen+1
           end
        end
   end
   return stringLen
end


--- <summary>
--- 功能 : 在Minghao表中获取随机姓、名
--- </summary>
function wnd_CreateRoleClass:OnRandomNameClick()
    self.getXing= GetXing()
    if math.random() <= 0.5 then
       self.getMing= GetManMing()
    else
       self.getMing= GetWomanMing()
    end
    self.UserName = self.getXing .. self.getMing
    self.input:SetValue(self.UserName)
end


--- <summary>
--- 功能 :  创建新用户姓名
--- </summary>
function wnd_CreateRoleClass:IsContainUserName()
    local jsonNM = QKJsonDoc.NewMap()
    jsonNM:Add("n","newPlayer")
    jsonNM:Add("name",self.input:GetValue())
    local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_NewName)
end


function wnd_CreateRoleClass:NM_NewName(jsonDoc)	
	local num = tonumber(jsonDoc:GetValue("r"))
    if num ==0 then
	    Poptip.PopMsg("新建角色成功",Color.green)
        QY2LessonManager.SetCreateCharFinish();
        --展示下一个界面
        self:Hide()
    elseif num == 1 then
        Poptip.PopMsg("角色名为空",Color.green)
    elseif num == 2 then
        Poptip.PopMsg("角色名过短",Color.green)
    elseif num == 3 then
        Poptip.PopMsg("存在非法词汇",Color.green)
    elseif num == 4 then
        Poptip.PopMsg("用户名已存在，请更换其他名称",Color.green)
	end
end


return wnd_CreateRoleClass.new

--endregion