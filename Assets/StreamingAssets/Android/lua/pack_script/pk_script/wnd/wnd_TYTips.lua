--region *.lua
--Date 20160721
--新手指导


wnd_TYTips = nil--单例

local class_wnd_tytips= class(wnd_base)


function class_wnd_tytips:ctor()	

end
function class_wnd_tytips:Start()
    self:Init(WND.TongYongTips  )
    wnd_TYTips = self

    --负责显示tips文本信息
    self.text = nil;
    --指向当前显示的手势
    self.Bg = nil;
    --控制tips窗口位置的空间
    self.SSFixed = nil;

    
end
function class_wnd_tytips:OnShowDone()
    --这里要初始化窗口，哪些进行显示及设置位置，哪些隐藏
    self.curLesson = QY2LessonManager.GetCurLesson();
    if(self.curLesson ~= nil)then
        local TipsType,TipsNote,offx,offy = self.curLesson:GetTipsType(self.curLesson);
        print("TipsType",TipsType,TipsNote,offx,offy);
        if(TipsType ~= nil and self.text_Label ~= nil)then
             self.text_Label:SetValue (TipsNote)
             local op,op2,op3 = self.curLesson:GetOperation()
             if(op ~= nil and  op == 1 )then
                local opWnd = Wnd.Get(op2);
                if(opWnd ~= nil and opWnd.instance ~= nil)then
                    local btn = opWnd:FindWidget(op3);
                    if(btn ~= nil)then
                        self.SSFixed:SetTarget(btn,Vector3.new(offx,offy,0))
                    end
                end
            end
        end
    end
    print("OnShowDone",TipsType,TipsNote,offx,offy);
end



function class_wnd_tytips:OnNewInstance()
   
   self.text = self.instance:FindWidget("BG/Text")
   self.text_Label = self.text:GetComponent(CMUILabel.Name)
   self.Bg = self.instance:FindWidget("BG")
   self.SSFixed = self.Bg:GetComponent(UISysScaleFixed.Name)

  -- self.text_Label :SetValue (TipsNote))
--    --绑定选择服务器事件
--   self:BindUIEvent("servername_btn",UIEventType.Click,"OnOpenZoneListClick")

--   --账户登录按钮
--   self:BindUIEvent("mainpanel/btn_login",UIEventType.Click,"OnUserLoginClick")

--   --注销登录按钮
--   self:BindUIEvent("mainpanel/btn_unlogin",UIEventType.Click,"OnUnLoginClick") 

--   --开始游戏按钮
--   self:BindUIEvent("mainpanel/btn_go",UIEventType.Click,"OnGoClick")
end

function class_wnd_tytips:OnLostInstance()

end

function class_wnd_tytips:Show(duration) 
    --挂载服务器列表更新组件
	self:_Show(duration)
end


return class_wnd_tytips.new

--endregion
