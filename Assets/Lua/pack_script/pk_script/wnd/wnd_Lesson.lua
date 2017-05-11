--region *.lua
--Date 20160721
--新手指导


wnd_lesson = nil--单例

local class_wnd_lesson= class(wnd_base)

local isFirstShow = true
function class_wnd_lesson:ctor()	
	self.m_lostTime = 0 
end
function class_wnd_lesson:Start()
    self:Init(WND.Lesson  )
    wnd_lesson = self
     print("class_wnd_lesson Start============================")
    --self.currzone = -1 --当前zone
    --self.ptLoginWndShowing = false--平台登录窗口是否处于显示中
	QY2LessonManager.EvtDuiHua():AddCallback(self,self.OnDuiHua);
    QY2LessonManager.EvtEnterState():AddCallback(self,self.OnEnterState);
    --QY2LessonManager.EvtLessonFinish():AddCallback(self,self.OnLessonFinish);
    LessonEvtFun.EvtLFun():AddCallback(self,self.OnEvtFun)
    self.CurTopWnd = nil;
    --StartCoroutine(self,self.UpdateTopWnd, {})
    EventHandles.OnTopWndChanged:AddListener(self,self.OnTopWndChanged)


    self.Childs = {};
    self.ChildStrs = {"touch01","slide01","slide02"};
    --本窗口的gameObject上的脚本，负责将按钮移动到本窗口下和提升面板深度的脚本
    self.MaskGuide = nil;--component
    --镂空和镂空处碰撞盒的父亲
    self.BgObj = nil
    --整体遮挡面板
    self.MaskBgObj = nil
    --镂空面板
    self.BgObj_mask = nil;
    --镂空处的碰撞盒
    self.BgObj_collider = nil
    --指向当前显示的手势
    self.CurChild = nil;

end

--显示对话窗口
function class_wnd_lesson:OnDuiHua(lInfo) 
     print("OnDuiHua#1")
     if(lInfo ~= nil)then
        local duihuaId,typeID = lInfo:GetDuiHuaInfo();
        if(duihuaId ~= -1)then
	        wnd_GuankaJuqing:CurrentGuan(duihuaId,typeID)--这里的4是约定好的代表读取对话表的列
	        wnd_GuankaJuqing:Show()	
        end
    end

end
function class_wnd_lesson:OnEnterState(lInfo) 
     print("OnEnterState#1")
     if(lInfo ~= nil)then
       print("OnEnterState#1 lInfo")
        local stateId = lInfo:GetEStateID();
          print("OnEnterState#1 "..stateId)
        if(stateId ~= -1)then
          print("OnEnterState#11111111111111")
	      wnd_tuiguan:ForceOnCity()
            print("OnEnterState#122222222222222222")
           wnd_tuiguan:OnClickProvinces(nil,stateId);
             print("OnEnterState#133333333333333")
        end
    end

end
function class_wnd_lesson:OnEvtFun(LEvtFun) 
     print("OnEvtFun#1")
     if(LEvtFun ~= nil)then
       print("OnEvtFun#1 lInfo")
        local funType = LEvtFun:GetType();
        local lInfo = LEvtFun:GetLInfo();
          print("OnEvtFun#1   "..funType)
        if(funType == ELME_Type.HuanZhen)then
            --换阵
            print("OnEvtFun#1 funType == ELME_Type.HuanZhen ==")
            self:HuanZhenFun(lInfo);
        elseif(funType == ELME_Type.AddHero)then
            --将英雄上阵
            print("OnEvtFun#1  funType == ELME_Type.AddHero ==")
            self:AddHeroFun(lInfo);
        elseif(funType == ELME_Type.OpenShowShi)then
            --显示手势界面
            print("OnEvtFun#1  funType == ELME_Type.OpenShowShi ==")
            self:Show();
        elseif(funType == ELME_Type.LessonFinish)then
            --当前子新手指引完成
            print("OnEvtFun#1  funType == ELME_Type.LessonFinish ==")
            self:Hide();
            wnd_TYTips:Hide();
        elseif(funType == ELME_Type.OpenTips)then
            --显示tips窗口
            print("OnEvtFun#1  funType == ELME_Type.OpenTips ==")
            wnd_TYTips:Show();
        elseif(funType == ELME_Type.GuanQia)then
           -- 设置玩家选择的关卡
           self:ChangeGuanQia(lInfo);
        elseif(funType == ELME_Type.AddPaiZu)then
           -- 设置玩家选择的关卡
           self:AddPaiZu(lInfo);
        elseif(funType == ELME_Type.OpenWnd)then
           -- 因特殊原因停止所有关卡，这个时候要把新手指导相关的东西都关掉
           self:OpenWndFun(lInfo);
        elseif(funType == ELME_Type.Stop_All_Lesson)then
           -- 因特殊原因停止所有关卡，这个时候要把新手指导相关的东西都关掉
            wnd_TYTips:Hide();
            self:Hide(0);
        elseif(funType == ELME_Type.Other)then
            print("funType == ELME_Type.Other")
        else
            debug.LogError("OnEvtFun#1  funType not has fun "..funType);
        end
    end

end
--function class_wnd_lesson:OnLessonFinish(lInfo) 
--     print("OnDuiHua#1")
--     if(lInfo ~= nil and self.curLesson == lInfo)then
--       self:Hide();
--    end
--end
function class_wnd_lesson:HuanZhenFun(lInfo)
    if(lInfo ~= nil)then
        local bid,sid = lInfo:GetID();
        print("class_wnd_lesson:LM_HuanZhen:111111111111111",bid,sid)
        print("class_wnd_lesson:LM_HuanZhen:zfdddd ")
        local zf = lInfo:GetHuanZhenID();
        print("class_wnd_lesson:LM_HuanZhen:zf ",zf)
        if(zf ~= nil and zf ~= -1)then
            local jsonNM = QKJsonDoc.NewMap()	
	        jsonNM:Add("n","SetBuZhenInfo") 
	        jsonNM:Add("t",1)
	        local Formation = QKJsonDoc.NewMap()
            Formation:Add("zf",zf)
            local zfPos = QKJsonDoc.NewArray()
            local heroCount = lInfo:GetAddHeroCount();
                print("class_wnd_lesson:LM_HuanZhen:heroCount ",heroCount)
            for i = 0,heroCount-1 do
                local hid,id = lInfo:GetAddHeroID(i);
                print("class_wnd_lesson:LM_HuanZhen:heroCount i",i,hid,id);
                if(hid ~= -1)then
                    zfPos:Add(id,hid)
                end
            end
	        Formation:Add("zfPos",zfPos)
	        jsonNM:Add("f",Formation)
            print("class_wnd_lesson:LM_HuanZhen:zfPos ",zfPos)
            YQ2GameConn:SendRequest(jsonNM,0,true,self,self.NM_ReHuanZhenCallBack)
            return;
        end
    end
end
function class_wnd_lesson:NM_ReHuanZhenCallBack(_Result)
    if _Result:IsFirstFinished() ~= true then return end
    local jsonDoc = CodingEasyer:GetResult(_Result)
    --print("wnd_buzhengClass:NM_ReSetBuZhenInfo1",jsonDoc,self.CloseType)
    if self.CloseType == "Close" then self.CloseType = "" return end
    if jsonDoc == nil  then 
      
        return
    end 

    local Result = tonumber (jsonDoc:GetValue("r"))
    print("NM_ReHuanZhenCallBack Result:",Result)
    if 0 == Result  then
        Poptip.PopMsg("英雄上阵成功！",Color.white)
    else
        Poptip.PopMsg("英雄上阵出错",Color.white)
    end 

end
--和换阵二合一了
function class_wnd_lesson:AddHeroFun(lInfo)
    if(lInfo ~= nil)then
--        local count = lInfo:GetAddHeroCount();
--         print("AddHeroFun#1   count =="..count)
--        for i = 0,count-1 do
--           local heroID,posID = lInfo:GetAddHeroID(i);
--           print("AddHeroFun#1   "..heroID.."=posID=="..posID)
--        end
    end
end
function class_wnd_lesson:ChangeGuanQia(lInfo)
    if(lInfo ~= nil)then
        local str = lInfo:GetPerDesc2(ELMPer_Type.GuanQia);
         print("AddHeroFun#1   count =="..count)
         if(str ~= nil and str ~= "")then
            local gq = str+0;
             debug.LogError("新手指引里，没有对更换关卡进行处理"..str);
         end
    end
end
--打开某个窗口
function class_wnd_lesson:OpenWndFun(lInfo)
    if(lInfo ~= nil)then
        local wndName = lInfo:GetPerDesc2(ELMPer_Type.OpenWnd);
        local wndParam = lInfo:GetPerDesc3(ELMPer_Type.OpenWnd);
         print("OpenWndFun#1   wndName =="..wndName,wndParam);
         if(wndName ~= nil and wndName ~= "")then
            if(wndName == WND.PlayerCreate)then
                 wnd_PlayerCreate:Show();
            elseif(wndName == "ui_newcard")then
                debug.LogError("新手指引里，没有对这个窗口的处理"..wndName);
            else
                debug.LogError("新手指引里，没有对这个窗口的处理"..wndName);
            end
         end
    end
end
function class_wnd_lesson:AddPaiZu(lInfo)
    print("class_wnd_lesson#AddPaiZu===============================")
    if(lInfo ~= nil)then
        local count = lInfo:GetAddPaiZuCount();
        print("AddPaiZuFun#1   count =="..count)
        local heroIDStr = "";
        if(count == nil or count == 0 )then
            return;
        end
        heroIDStr = tostring( heroID);
        for i = 1,count-1 do
           local heroID = lInfo:GetAddPaiZuID(i);
           print("AddPaiZuFun#1   "..heroID)
           heroIDStr = heroIDStr..","..tostring( heroID);

        end
        if(heroIDStr ~= "")then
            local jsonNM = QKJsonDoc.NewMap()	
            jsonNM:Add ("n","SetAvaH")  
	        jsonNM:Add ("hidlist", heroIDStr)--当前出战英雄ID字符串
            print("heroIDStr",heroIDStr);
            print("class_wnd_lesson#AddPaiZu========heroIDStr",heroIDStr)
	        local loader = GameConn:CreateLoader(jsonNM,0) 
	        HttpLoaderEX.WaitRecall(loader,self,self.NM_ReAddPaiZuCallBack)
        end
    end
end
function class_wnd_lesson:NM_ReAddPaiZuCallBack(jsonDoc)
    local Result = tonumber (jsonDoc:GetValue("r"))
    print("AddPaiZuBack Result:",Result)
    if 0 == Result  then
        Poptip.PopMsg("保存英雄成功！",Color.white)
    else
        Poptip.PopMsg("保存英雄出错",Color.white)
    end 
end
function class_wnd_lesson:OnTopWndChanged(wnd)
   
--    -- print("class_wnd_lesson Update====")
    if(wnd ~= nil)then
       -- print("class_wnd_lesson Update===="..wnd)
	    if(self.CurTopWnd ~= wnd) then
            self.CurTopWnd = wnd.."";
           -- print("class_wnd_lesson Update==dddddddddddddd=="..type(wnd))
	       
            QY2LessonManager.SetCurWnd(self.CurTopWnd);
            --print("class_wnd_lesson OnTopWndChanged========="..wnd)

	    end
    end
end
function class_wnd_lesson:UpdateTopWnd()
    while (true) do
       -- print("class_wnd_lesson Update====")
        local curWnd  = Wnd.GetTopWnd();
        -- print("class_wnd_lesson UpdateTopWnd===="..curWnd.name)
	    if(self.CurTopWnd ~= curWnd) then
            print("class_wnd_lesson Update==dddddddddddddd=="..curWnd.name)
	       self.CurTopWnd = curWnd;
           QY2LessonManager:SetCurWnd(self.CurTopWnd);
	    end
        Yield();
    end
end
function class_wnd_lesson:OnShowDone()
    --这里要初始化窗口，哪些进行显示及设置位置，哪些隐藏
    self.curLesson = QY2LessonManager.GetCurLesson();
     --print("<color=#00ff00>======OnShowDone======curLesson=="..self.curLesson .."<color>")
    if(self.curLesson ~= nil)then

    ----------------------------设置蒙版------------------------------------------
     --根据count数字还判断后面有几个有效数字
        local count,d1,d2,d3,d4 = self.curLesson:GetPerDList(ELMPer_Type.Mask)
        print("<color=#00ff00>=======GetPerDList======count=="..count.."<color>")
        self.MaskBgObj:SetActive(false);
        if(count == 0)then
            self.BgObj:SetActive(false);
            self.MaskBgObj:SetActive(true);
        else
            local lmask = self.BgObj_mask:GetComponent(LessonMask.Name)
            if(lmask ~= nil)then
                lmask:SetRect(d1,d2,d3,d4)
                self.BgObj:SetActive(true);
            else
                self.BgObj:SetActive(false);
            end
        end
        local desc = self.curLesson:GetPerDesc2(ELMPer_Type.Mask)
        if(desc == "0")then
            self.BgObj_collider:SetActive(false);
        else 
            self.BgObj_collider:SetActive(true);
        end
       ---------------------------设置手势窗口的显示-----------------------------------------

        local ShoushiType,offx,offy = self.curLesson:GetShoushiType();
       -- print("<color=#00ff00>======OnShowDone======ShoushiType=="..self.ShoushiType .."<color>")
        if(ShoushiType == nil)then
            return;
        end
        local op,op2,op3 = self.curLesson:GetOperation()
        print("ShoushiType",ShoushiType,offx,offy);

        --注意这里ShoushiType 可能是 -1，这样就将手势都关闭了
        self.CurChild = nil;
        for i =1,(#self.ChildStrs) do
            if(ShoushiType == self.ChildStrs[i])then    
                self.CurChild = self.Childs[i];
                self.Childs[i]:SetActive(true);
            else
                self.Childs[i]:SetActive(false);
            end
        end
        --------------------------将需要隔离的按钮和panel放到新的panel上-------------------------------
        --这里注意下ui_fight是从c#里实现的，这里是查找不到的
       if(op ~= nil and self.CurChild ~= nil and (op == 1 or op == 4 )and op2 ~= "ui_fight" )then
            print("op",op,op2,op3);
            local sysScale = self.CurChild:GetComponent(UISysScaleFixed.Name);
            --local mask = self.Childs[#self.ChildStrs]:GetComponent(LessonMask.Name);
                      
            --获取要点击的窗口
            local opWnd = Wnd.Get(op2);
            if(opWnd ~= nil and opWnd.instance ~= nil)then
            print("opWnd ~= nil and opWnd.instance ~= nil "..op2);
                --获取要点击的窗口中的按钮
                local btn = opWnd:FindWidget(op3);
                if(btn ~= nil)then
                     print("opWnd ~= nil and opWnd.instance ~= nil btn ~= nil "..op3);
                    if(sysScale ~= nil)then
                        --让手势图标一直显示在按钮上
                        sysScale:SetTarget(btn,Vector3.new(offx,offy,0))
                    end
                    --将要点击的按钮设置到maskGuide面板上
                    if(self.MaskGuide ~= nil)then
                        self.MaskGuide:SetTarget(btn);
                        self.MaskGuide:Show(true);
                        if(op == 4)then
                            self.MaskGuide:SetPanelDepth(exui_CardCollection.instance:GetGameObject(),true)
                        end
                    else
                        debug.LogError(" class_wnd_lesson: self.MaskGuide is nil" );
                    end
                else
                    debug.LogError(op3 .." not found");
                    local t = {};
                    t.w = opWnd;
                    t.op3 = op3;
                    t.offx = offx;
                     t.offy = offy;
                    StartCoroutine(self,self.WaitForBtnCreate,t)
                end
            else    
                 print("opWnd == nil ",op2,op3);
            end
        end   
    end
     print("opWnd == OnShowDone  ------------------------------------------ ");
end
function class_wnd_lesson:WaitForBtnCreate(param)
    local sysScale = nil;
    if(param == nil or param == {})then
        return;
    end
     --print("class_wnd_lesson----WaitForBtnCreate------------begin---------- ");
    local opWnd =param.w;
    -- print("class_wnd_lesson----WaitForBtnCreate------------begin--opWnd "..opWnd);
    local op3=  param.op3;
    local offx = param.offx;
    local offy = param.offy;
     --print("class_wnd_lesson----WaitForBtnCreate------------begin-- op3 "..op3);
    if(self.CurChild ~= nil)then
        sysScale = self.CurChild:GetComponent(UISysScaleFixed.Name);
    end
     --print("class_wnd_lesson------------------WaitForBtnCreate------------begin11111111111111");
    if(opWnd ~= nil and opWnd.instance ~= nil and opWnd.instance:GetGameObject() ~= nil)then
        --获取要点击的窗口中的按钮
        local btn =nil;
        --警告这里出问题了
        -- print("class_wnd_lesson------------------WaitForBtnCreate------------2222222222");
        while (opWnd ~= nil and opWnd.instance ~= nil and opWnd.instance:GetGameObject() ~= nil and opWnd:FindWidget(op3)) == nil do
           -- print("class_wnd_lesson------------------WaitForBtnCreate------------33333333");
            Yield(0.5)
        end
         --print("class_wnd_lesson------------------WaitForBtnCreate------------4444444444444444");
        if(opWnd ~= nil and opWnd.instance ~= nil and opWnd.instance:GetGameObject() ~= nil)then
        -- print("class_wnd_lesson------------------WaitForBtnCreate------------555555555");
            btn = opWnd:FindWidget(op3)
            if(btn ~= nil)then
            -- print("class_wnd_lesson------------------WaitForBtnCreate------------6666666666");
                if(sysScale ~= nil)then
                    --让手势图标一直显示在按钮上
                    --print("class_wnd_lesson------------------WaitForBtnCreate------------77777777777");
                    sysScale:SetTarget(btn,Vector3.new(offx,offy,0))
                end
                --print("class_wnd_lesson------------------WaitForBtnCreate------------8888888888888");
                --将要点击的按钮设置到maskGuide面板上
                if(self.MaskGuide ~= nil)then
                --print("class_wnd_lesson------------------WaitForBtnCreate------------9999999999999999");
                    self.MaskGuide:SetTarget(btn);
                    self.MaskGuide:Show(true);
                    if(op == 4)then
                   -- print("class_wnd_lesson------------------WaitForBtnCreate------------01000000000");
                        self.MaskGuide:SetPanelDepth(exui_CardCollection.instance:GetGameObject(),true)
                    end
                else
                    debug.LogError(" class_wnd_lesson: WaitForBtnCreate self.MaskGuide is nil" );
                end
            else
                debug.LogError(op3 .." not found WaitForBtnCreate");
            end
        end
    else    
            print("opWnd ==WaitForBtnCreate  nil ",op2,op3);
    end
     print("class_wnd_lesson:WaitForBtnCreate is finish");
end


function class_wnd_lesson:OnNewInstance()
--    self.touch01 = self.instance:FindWidget("touch01")
--    self.slide_left = self.instance:FindWidget("slide_left")
--    self.slide_right = self.instance:FindWidget("slide_right")
--    self.slide_up = self.instance:FindWidget("slide_up")
--    self.slide_down = self.instance:FindWidget("slide_down")
    local touch = self.instance:GetGameObject()
    if(touch ~= nil)then
        self.MaskGuide = touch:GetComponent(MaskGuide.Name);
    else
        print("class_wnd_lesson:OnNewInstance touch == nil " ,MaskGuide.Name );
    end
    for i =1,#self.ChildStrs do
        self.Childs[i] = self.instance:FindWidget(self.ChildStrs[i])
    end
    self.MaskBgObj = self.instance:FindWidget("maskbg");
    if(self.MaskBgObj == nil)then
        debug.LogError("class_wnd_lesson:OnNewInstance  self.MaskBgObj == nil");
    end
    self.BgObj = self.instance:FindWidget("bg_obj");
    self.BgObj_mask = self.instance:FindWidget("bg_obj/mask");
    self.BgObj_collider = self.instance:FindWidget("bg_obj/bg_collider");

end

function class_wnd_lesson:OnLostInstance()

end

function class_wnd_lesson:Show(duration) 
    --挂载服务器列表更新组件
	self:_Show(duration)
end

function class_wnd_lesson:Hide(duration) 
    if(self.MaskGuide ~= nil)then
        self.MaskGuide:SetPanelDepth(nil,false)
        self.MaskGuide:ClearButton();
    end
    wnd_NetConnectWait:Hide();
	self:_Hide(duration)
end


return class_wnd_lesson.new

--endregion
