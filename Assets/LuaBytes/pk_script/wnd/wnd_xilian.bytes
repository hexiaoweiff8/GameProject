
--author:shenhuyun
--date:2016/8/2


local equip_ID_list = {}--装备仓库

local cailiao_ID_list = {}--材料仓库按钮对象列表
local zhuangbei_ID_list = {}--材料仓库按钮对象列表

local temp_info = {
                        t = 0,
                        id = 0,
                        num = 0
                   }
local xilian_info = {}


--记录需要的洗练材料ID
local xilian_zhuangbei = {}
local temp_zhuangbei = {id = 0}


local wnd_xilianClass = class(wnd_base)

wnd_xilian = nil--单例

function wnd_xilianClass:Start() 
   
	wnd_xilian = self
	self:Init(WND.Xilian)
end


--窗体被实例化时被调用
--初始化实例
function wnd_xilianClass:OnNewInstance()
    self.backpackEquips = {}--背包的装备
    self.backpackCailiaoEquips = {}
    self.backpackWujuObj = {}
    self.backpackCailiaoEquipsObj = {}
    self.backpackCailiao = {}
    self.backpackCailiaoObj = {}


    self.isCailiaoCreate = false
    --全局变量
    self.IsXilian = false  
    self.shuxing1_flag = false--全局变量为true时，表示11-1，到2，3时会根据它来显示对应的信息
    self.Eq_grid = self:FindWidget("equipment_scrollview/equipment_grid")
    self.Equip = self.Eq_grid:FindChild("equipment_btn")
    self.scrollView = self:FindWidget("equipment_scrollview") 
    self.CMScrollView = self.scrollView:GetComponent(CMUIScrollView.Name)--滚动视组件
    self.cailiaoPage = self:FindWidget("cailiao_page")
    self.cmCaiLiaoScrollView = self.cailiaoPage:GetComponent(CMUIScrollView.Name)
    self.light_flashObj = self.instance:FindWidget("light_flash")
    self.cmTweenLight_Flash = self.light_flashObj:GetComponent(CMUITweener.Name)
    --绑定事件
    self:BindUIEvent("btn_panel/btn_back",UIEventType.Click,"OnClose")--退出窗体
    self:BindUIEvent("btn_panel/change_btn",UIEventType.Click,"CreateEquipUI")--更换洗练装备
    self:BindUIEvent("mg_panel/e_bg_btn",UIEventType.Click,"CreateEquipUI")--更换洗练装备
    self:BindUIEvent("xilian_widget/btn_panel/xilian_btn",UIEventType.Click,"OnXilianStart")--开始洗练
    self:BindUIEvent("blur_panel/blur",UIEventType.Click,"OnBlur_XC")
    --组件时间
    self.backObj = self.instance:FindWidget("btn_panel/btn_back")
    self.cmBtnBack = self.backObj:GetComponent(CMUIButton.Name)

    --洗练属性
    self.xilian01_name_obj = self.instance:FindWidget("shuxing_widget/xilian01_name")
    self.cmLabel_xilian01_name = self.xilian01_name_obj:GetComponent(CMUILabel.Name)

    self.xilian01_shuxing_obj = self.instance:FindWidget("shuxing_widget/xilian01_shuxing")
    self.cmLabel_xilian01_shuxing = self.xilian01_shuxing_obj:GetComponent(CMUILabel.Name)

    self.xilian02_name_obj = self.instance:FindWidget("shuxing_widget/xilian02_name")
    self.cmLabel_xilian02_name = self.xilian02_name_obj:GetComponent(CMUILabel.Name)

    self.xilian02_shuxing01_obj = self.instance:FindWidget("shuxing_widget/xilian02_shuxing01")
    self.cmLabel_xilian02_shuxing01 = self.xilian02_shuxing01_obj:GetComponent(CMUILabel.Name)

    self.xilian02_shuxing02_obj = self.instance:FindWidget("shuxing_widget/xilian02_shuxing02")
    self.cmLabel_xilian02_shuxing02 = self.xilian02_shuxing02_obj:GetComponent(CMUILabel.Name)

    self.xilian03_name_obj = self.instance:FindWidget("shuxing_widget/xilian03_name")
    self.cmLabel_xilian03_name = self.xilian03_name_obj:GetComponent(CMUILabel.Name)

    self.xilian03_shuxing_obj = self.instance:FindWidget("shuxing_widget/xilian03_shuxing")
    self.cmLabel_xilian03_shuxing = self.xilian03_shuxing_obj:GetComponent(CMUILabel.Name)

    --洗练属性（仓库上）
    self.skill_name_obj = self.instance:FindWidget("right_class/shuxing")
    self.cmLabel_skill_name = self.skill_name_obj:GetComponent(CMUILabel.Name)
    self.shuxing01_obj = self.instance:FindWidget("right_class/shuxing01")
    self.cmLabel_shuxing01 = self.shuxing01_obj:GetComponent(CMUILabel.Name)
    self.shuxing02_obj = self.instance:FindWidget("right_class/shuxing02")
    self.cmLabel_shuxing02 = self.shuxing02_obj:GetComponent(CMUILabel.Name)
    self.jineng_obj = self.instance:FindWidget("right_class/jineng")
    self.cmLabel_jineng = self.jineng_obj:GetComponent(CMUILabel.Name)
end
function wnd_xilianClass:OnShowDone()
    self.isShuaxinCailiaoEquips = true
    self.isShuaxinCailiao = true
    self.isShuaxinEquips = true
    print("OnShowDone")
    table.clear(zhuangbei_ID_list)
    local id = nil
    local a = Player:GetEquips()
	local eachFunc = function (syncObj)
        id = syncObj:GetValue(EquipAttrNames.ID)
	end
	a:ForeachEquips(eachFunc)
    if self.xilian_id == nil then
         self.xilian_id = id           
    end
    --初始化洗练界面

    self:InitXilian()
end
--初始化按键中的TXT
function wnd_xilianClass:InitLabel()
    --按键中的id2
    self:SetLabel("top_lab/title_bg/txt",SData_Id2String.Get(5059))

    self:SetLabel("change_btn/txt",SData_Id2String.Get(5062))
    self:SetLabel("xilian_btn/txt",SData_Id2String.Get(5063))
    self:SetLabel("warehouse_bg/title_bg/txt",SData_Id2String.Get(5076))

    self:SetLabel("shuxing_widget/xilian",SData_Id2String.Get(5067))
    self:SetLabel("left_class/jichu",SData_Id2String.Get(5077))
    self:SetLabel("right_class/xilian",SData_Id2String.Get(5079))

    self:SetLabel("define_btn/txt",SData_Id2String.Get(5059))
    self:SetLabel("cancel_btn/txt",SData_Id2String.Get(5082))


end
function wnd_xilianClass:InitXilian()
    self:CreateCailiaoUI()--初始化材料仓库      
    self:InitLeft()--初始化左边的页面
    self:ShowEquipmentInfo(self.xilian_id)--初始化装备信息
    print(wnd_heroinfo.wuju_flag," ",wnd_heroinfo.hujia_flag)
--    self:SetWidgetActive("warehouse_widget",true)
--    self:ShowEquipmentShuXing(obj,self.xilian_id)
--    print("555")
end

function wnd_xilianClass:InitLeft()
    local XLZ = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Xilian,wnd_heroinfo:ID_DataID(self.xilian_id)))
    sum_xilian = 0
    table.clear(xilian_zhuangbei)
    table.clear(cailiao_ID_list)
    self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),sum_xilian,XLZ))
    --洗练槽进度条
    local m_Item = self.instance:FindWidget( "bg_panel/xiliancao_img" )
    local xlcObj = m_Item:GetComponent(CMUIProgressBar.Name)
    xlcObj:SetValue( 0/XLZ )
    self:SetWidgetActive("tips_bg",false)
    self:SetWidgetActive("btn_panel/xilian_mask_btn",true)
    self:SetWidgetActive("light_outside",false)
    --装备图标
    self:SetWidgetActive("fg_panel/equipment_img",true)
    local sprite = self.instance:FindWidget( "fg_panel/equipment_img" )
	local equip = sprite:GetComponent(CMUISprite.Name)
    local DataID = wnd_heroinfo:ID_DataID(self.xilian_id)
	equip:SetSpriteName(sdata_EquipData:GetV(sdata_EquipData.I_Icon,DataID))

end

--进入洗练界面的判断
function wnd_xilianClass:ShowXilianUIByEquip()
    if wnd_heroinfo:IsHasEquip() then
        self.showShuXingFlag = true
        self:Show()
    else
        Poptip.PopMsg("当前没有装备！",Color.white)
    end
end
--blur
function wnd_xilianClass:OnBlur_XC()
    StartCoroutine(self,self.OnBlur,{})--启动协程
end
function wnd_xilianClass:OnBlur()
    local e_bg_btn = self.instance:FindWidget("mg_panel/e_bg_btn")
    local cmBtnCollider_e_bg_btn = e_bg_btn:GetComponent(CMBoxCollider.Name)
    local change_btn = self.instance:FindChild("btn_panel/change_btn")
    local cmBtnCollider_change_btn = change_btn:GetComponent(CMBoxCollider.Name)
    cmBtnCollider_e_bg_btn:SetEnable(false)
    cmBtnCollider_change_btn:SetEnable(false)
    Yield(0.4)
    cmBtnCollider_e_bg_btn:SetEnable(true)
    cmBtnCollider_change_btn:SetEnable(true)
end

--排序
local function SortFun(item1, item2)
        local Judgement
        if item1.TYPE == item2.TYPE  then
            if item1.LV == item2.LV then--根据等级排            
                if item1.SKILL_NUM == item2.SKILL_NUM then--根据洗练属性排               
                    local heroid1 = tonumber(item1.HeroID)
                    local heroid2 = tonumber(item2.HeroID)
                    if (heroid1 ~= 0 and heroid2 ~= 0)  or (heroid1 == 0 and heroid2 == 0) then--根据穿戴情况排
                        if item1.ZDL == item2.ZDL then--根据战斗力排
                       
                            Judgement = item1.DataID > item2.DataID
                        else
                            Judgement = item1.ZDL > item2.ZDL
                        end
                    else
                        Judgement = (heroid1 == 0 and heroid2 ~= 0)            
                    end
                else
                    Judgement = item1.SKILL_NUM > item2.SKILL_NUM
                end
            else
                Judgement = item1.LV > item2.LV
            end
        else
            Judgement = (item1.TYPE == 1 and item2.TYPE == 2)      
        end       
        
        return Judgement
end

--装备仓库页 
function wnd_xilianClass:CreateEquipUI()
    StartCoroutine(self,self.ShowEquipment,{})--启动协程
end


function wnd_xilianClass:ShowEquipment()
      
    local cmTable = self.Eq_grid:GetComponent(CMUIGrid.Name)
    self:SetWidgetActive("equipment_scrollview",false)
    Yield(0.5)
    
--    if self.isCreateEquip == false then
--        cmTable:Reposition()
--        return
--    end
--    Yield()
    --防止重复刷新
    if self.isShuaxinEquips == false then 
        self:SetWidgetActive("equipment_scrollview",true)
        self.CMScrollView:ResetPosition()      
        self:ShowEquipmentShuXing(_,self.backpackWujuObj[1].id)
        cmTable:Reposition()
        return
    end
    --将装备信息插入到表中
    table.clear(equip_ID_list)
    local a = Player:GetEquips()
		local eachFunc = function (syncObj)
            local temp_info = {}--单个装备信息
            local id = syncObj:GetValue(EquipAttrNames.ID)
            local dataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
            local lv = sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,tonumber(dataID))
            local heroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            local curr_skill = syncObj:GetValue(EquipAttrNames.CurrSkill)
            local zdl = syncObj:GetValue(EquipAttrNames.eZDL)
            local skill_num = wnd_heroinfo:GetXilianNum(id)
            local type = sdata_EquipData:GetV(sdata_EquipData.I_Type,tonumber(dataID))
            temp_info = {ID = id, DataID = dataID, LV = lv, HeroID = heroID, Curr_Skill = curr_skill, ZDL = zdl, SKILL_NUM = skill_num, TYPE = type}
		    table.insert(equip_ID_list,temp_info)
		end
	a:ForeachEquips(eachFunc)
    table.sort(equip_ID_list,SortFun)
    --销毁button
    Yield()
	for i = 1,#equip_ID_list do
		-- 实例化装备
        if self.backpackEquips[equip_ID_list[i].ID] == nil then
            local wuju = equip_ID_list[i]
		    self.backpackEquips[wuju.ID] = self:CreateEquips(wuju.ID,wuju.DataID,wuju.HeroID)
            local info = {}
            info.gameObject = self.backpackEquips[wuju.ID].gameObject
            info.id = wuju.ID
		    table.insert(self.backpackWujuObj,info)              
        end	 
	end
    Yield()
    
    for i = 1,#self.backpackWujuObj do
        self.backpackWujuObj[i].gameObject:SetActive(false)      
    end

	--设置武具的外观显示
    self:SetWidgetActive("equipment_scrollview",true)
    local flag = true
    local k = 1
	for i = 1,#equip_ID_list do
        self:SetEquipContent(self.backpackWujuObj[i].gameObject,equip_ID_list[i])
        self.backpackWujuObj[i].id = equip_ID_list[i].ID
        local cmevt = CMUIEvent.Go(self.backpackWujuObj[i].gameObject,UIEventType.Click)
        cmevt:Listener(self.backpackWujuObj[i].gameObject,UIEventType.Click,self,"ShowEquipmentShuXing",equip_ID_list[i].ID)        
        cmTable:Reposition()
        if flag then
            flag = false
            self:ShowEquipmentShuXing(obj,equip_ID_list[1].ID)
        end
        if k == 30 then
            k = 1
            cmTable:Reposition()
            Yield()
        end
        k = k + 1           	
    end
    cmTable:Reposition()
    self.cmBtnBack:SetIsEnabled(true)--唤醒返回按键

    self.isShuaxinEquips = false
end
--创建装备实例
function wnd_xilianClass:CreateEquips(dyID,staticID,heroID)
    local info = {}
    info.gameObject = GameObject.InstantiateFromPreobj(self.Equip,self.Eq_grid)
    info.dyID = dyID
    info.heroID = heroID
    info.gameObject:SetName(dyID)
    info.sinfo = sdata_EquipData:GetRow(staticID)--取得静态数据
    return info   
end
--设置装备的显示外观
function wnd_xilianClass:SetEquipContent(gameObject,info)
--设置装备外观
    local equipInfo = sdata_EquipData:GetRow(tonumber(info.DataID))
    --装备图标
    local sprite = gameObject:FindChild("equipment_img")
	local cmIcon = sprite:GetComponent(CMUISprite.Name)
	cmIcon:SetSpriteName(equipInfo[sdata_EquipData.I_Icon])
    --装备等级
    local lvObj = gameObject:FindChild("lv_txt")
    local cmLv = lvObj:GetComponent(CMUILabel.Name)
    cmLv:SetValue(string.sformat(SData_Id2String.Get(5075),equipInfo[sdata_EquipData.I_RequireLv]))
    --穿戴信息
    local heroNameObj = gameObject:FindChild("name_txt")
    if info.HeroID~=nil and info.HeroID>0 then
        heroNameObj:SetActive(true)
        local cmNameLabel = heroNameObj:GetComponent(CMUILabel.Name)                     
        cmNameLabel:SetValue(SData_Hero.GetHero(info.HeroID):Name())
    else
        heroNameObj:SetActive(false)
    end
    
    --洗练底纹
    local attr = wnd_heroinfo:GetXilianNum(info.ID)
    local sprite = gameObject:FindChild("equipment_bg")
	local cmSprite = sprite:GetComponent(CMUISprite.Name)
    local DewenName = ""
    if attr == 1 then
        DewenName = equipInfo[sdata_EquipData.I_XilianDiwen1]
    elseif attr == 2 then
        DewenName = equipInfo[sdata_EquipData.I_XilianDiwen2]
    elseif attr == 3 then
        DewenName = equipInfo[sdata_EquipData.I_XilianDiwen3]
    else
        DewenName = equipInfo[sdata_EquipData.I_WeixilianDewen]
    end
    cmSprite:SetSpriteName(DewenName) 
    gameObject:SetActive(true)
    gameObject:SetName(info.ID)
    --改变内容
    self.backpackEquips[info.ID].gameObject = gameObject
    self.backpackEquips[info.ID].dyID = info.ID
    self.backpackEquips[info.ID].heroID = info.HeroID
    self.backpackEquips[info.ID].sinfo = sdata_EquipData:GetRow(info.DataID)--取得静态数据    
end



function wnd_xilianClass:ShowEquipmentShuXing(obj,ID)    
    print("#self.backpackWujuObj",#self.backpackWujuObj)
    --显示被选中光圈
    for i = 1,#self.backpackWujuObj do
        local frame = self.backpackWujuObj[i].gameObject:FindChild("equipment_frame")
        frame:SetActive(ifv(ID == self.backpackWujuObj[i].id,true,false) )    
    end
--    for currID,equip in pairs(self.backpackEquips) do 
--         local frame = equip.gameObject:FindChild("equipment_frame")
--         frame:SetActive(ifv(currID==ID,true,false))
--    end  
--    local ID = info.equipInfo.ID
    local a = Player:GetEquips()
	local eachFunc = function (syncObj)
		if(syncObj:GetValue(EquipAttrNames.ID) == ID) then
            local type = tonumber(syncObj:GetValue(EquipAttrNames.EType))
            local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
            local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            if HeroID ~= 0 then
                local HeroName = SData_Hero.GetHero(HeroID):Name()
                self:SetWidgetActive("equipment_bg/name_bg",true)
                self:SetLabel("name_bg/name_Label",HeroName)
            else
                self:SetWidgetActive("equipment_bg/name_bg",false)
            end
            local lv = sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,DataID)
            self:SetLabel("equipment_bg/lv_txt",string.sformat(SData_Id2String.Get(5075),lv))              
            self:SetLabel("shuxing_widget/left_class/name",sdata_EquipData:GetV(sdata_EquipData.I_Name,DataID))
            if type == 1 then
                local wuli = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Wuli,DataID))
                local nu = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Nu,DataID))
                self:SetLabel("shuxing_widget/left_class/shuxing01",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),wuli))
                self:SetLabel("shuxing_widget/left_class/shuxing02",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),nu))
            elseif type == 2 then
                local hp = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_HP,DataID))
                local tili = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Tili,DataID))
                self:SetLabel("shuxing_widget/left_class/shuxing01",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),nu))
                self:SetLabel("shuxing_widget/left_class/shuxing02",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),tili))
            end
            --装备图标
            local sprite = self.instance:FindWidget( "shuxing_widget/equipment_bg/equipment_img" )
	        local equip = sprite:GetComponent(CMUISprite.Name)
	        equip:SetSpriteName(sdata_EquipData:GetV(sdata_EquipData.I_Icon,DataID))               
            self:split(syncObj:GetValue(EquipAttrNames.SkillAttr),DataID)

            --洗练底纹
            local attr = wnd_heroinfo:GetXilianNum(ID)
            local sprite = self.instance:FindWidget( "shuxing_widget/equipment_bg/equipment_frame" )
            local cmSprite = sprite:GetComponent(CMUISprite.Name)
            local DewenName = ""
            if attr == 1 then
                DewenName = sdata_EquipData:GetV(sdata_EquipData.I_XilianDiwen1,DataID)
            elseif attr == 2 then
                DewenName = sdata_EquipData:GetV(sdata_EquipData.I_XilianDiwen2,DataID)
            elseif attr == 3 then
                DewenName = sdata_EquipData:GetV(sdata_EquipData.I_XilianDiwen3,DataID)
            else
                DewenName = sdata_EquipData:GetV(sdata_EquipData.I_WeixilianDewen,DataID)
            end
            cmSprite:SetSpriteName(DewenName)   
        end
	end
	a:ForeachEquips(eachFunc)
    self:BindUIEvent("shuxing_widget/define_btn",UIEventType.Click,"OnXiLian",ID)  
    --self:BindUIEvent("shuxing_widget/cancel_btn",UIEventType.Click,"OnBack") 
    
    
end



--装备详细属性
function wnd_xilianClass:ShowEquipmentInfo(ID)
    local a = Player:GetEquips()
    local eachFunc = function (syncObj)
	    if(syncObj:GetValue(EquipAttrNames.ID) == ID) then
            local id = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
            local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            local lv = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,id))
            local zdl = tonumber(syncObj:GetValue(EquipAttrNames.eZDL))
            if HeroID ~= 0 then
                local HeroName = SData_Hero.GetHero(HeroID):Name()
                self:SetLabel("center_widget/mid_bg/shuxing_widget/dangqian",string.sformat(SData_Id2String.Get(5066),HeroName))
            else
                self:SetLabel("center_widget/mid_bg/shuxing_widget/dangqian",string.sformat(SData_Id2String.Get(5066),SData_Id2String.Get(5307)))
            end         
            self:SetLabel("shuxing_widget/title_txt",sdata_EquipData:GetV(sdata_EquipData.I_Name,id))
            self:SetLabel("center_widget/mid_bg/shuxing_widget/zhandouli",math.ceil(zdl/100))
            self:SetLabel("center_widget/mid_bg/shuxing_widget/level",string.sformat(SData_Id2String.Get(5065),lv))         
            self:split_info(syncObj:GetValue(EquipAttrNames.SkillAttr),id)
        end
    end
    a:ForeachEquips(eachFunc)  
end

--将装备ＩＤ传过来
function wnd_xilianClass:ID(k)
    self.xilian_id = k
end
--材料排序
local function SortCailiao(item1, item2)
    return item1.XLZ > item2.XLZ
end
function wnd_xilianClass:CreateCailiaoUI()
    StartCoroutine(self,self.ShowCaiLiao,{})--启动协程
end
--材料仓库

-----------
function wnd_xilianClass:ShowCaiLiao()
    local m_Item1 = self.instance:FindWidget("cailiao_grid")
    local cmTable = m_Item1:GetComponent(CMUIGrid.Name)
    local panel = self.instance:FindWidget("cailiao_page")
    panel:SetActive(false)
    Yield(0.4)

    
    
    
    local s1 = os.clock()
    --清除ID表
    table.clear(cailiao_ID_list)
    table.clear(zhuangbei_ID_list)
 
    --洗练材料
    local b = Player:GetEquipMaterials()
	local eachFunc = function (syncObj)
        local tempinfo = {}
        local id = tonumber(syncObj:GetValue(EquipMaterialsAttrNames.DataID))
        local num = syncObj:GetValue(EquipMaterialsAttrNames.NUM)
        local xlz = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Xilianzhi,id)
        tempinfo = {ID = id,NUM = num,LEFT = 0,RIGHT = num,XLZ = xlz}
        table.insert(cailiao_ID_list,tempinfo)
	end
	b:ForeachEquipMaterials(eachFunc)

    table.sort(cailiao_ID_list, SortCailiao)

     ------------------------------------cailiao--------------------------------------
     if self.isCailiaoCreate == false then
        self.isCailiaoCreate = true
        for i = 1,5 do
            local info = self:CreateCailiao()
            table.insert(self.backpackCailiaoObj,info.gameObject) 
        end
     end
    
    Yield()
    for i = 1,#self.backpackCailiaoObj do
        self.backpackCailiaoObj[i]:SetActive(false)      
    end
	--设置武具的外观显示
	for i = 1,#cailiao_ID_list do
        self:SetCailiaoContent(self.backpackCailiaoObj[i],cailiao_ID_list[i])
        --local cmevt = CMUIEvent.Go(self.backpackCailiaoEquipsObj[i],UIEventType.Click)
        local info = {}
        info.obj = self.backpackCailiaoObj[i]
        info.cailiaoInfo = cailiao_ID_list[i]       
        self:BindUIEvent("cailiao_grid/"..cailiao_ID_list[i].ID.."/reduce",UIEventType.Click,"OnReduceShitou",info)
        self:BindUIEvent("cailiao_grid/"..cailiao_ID_list[i].ID.."/reduce",UIEventType.LongPress,"LP_Reduce",info)
        self:BindUIEvent("cailiao_grid/"..cailiao_ID_list[i].ID.."/reduce",UIEventType.Press,"OnP_Reduce")
        
        self:BindUIEvent("cailiao_grid/"..cailiao_ID_list[i].ID,UIEventType.Click,"OnAddShitou",info)                	
        self:BindUIEvent("cailiao_grid/"..cailiao_ID_list[i].ID,UIEventType.LongPress,"LongPress",info)--长按事件
        self:BindUIEvent("cailiao_grid/"..cailiao_ID_list[i].ID,UIEventType.Press,"OnPress")--用于接收鼠标松开事件
    end
    --防止重复刷新
    if self.isShuaxinCailiaoEquips == false then
        panel:SetActive(true)
        self.cmCaiLiaoScrollView:ResetPosition()--设置滑动条初始位置
        cmTable:Reposition()
        return
    end
    ----------------------------------zhuangbei------------------------------------
    --装备材料
    local a = Player:GetEquips()
	local eachFunc = function (syncObj)
        local tempinfo = {}
        local id = syncObj:GetValue(EquipAttrNames.ID)
        local dataid = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
        local heroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
        local lv = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,dataid))
        local zdl = syncObj:GetValue(EquipAttrNames.eZDL)
        local skill_num = wnd_heroinfo:GetXilianNum(id)
        local type = sdata_EquipData:GetV(sdata_EquipData.I_Type,dataid)
        tempinfo = {ID = id,DataID = dataid,HeroID = heroID,LV = lv,ZDL = zdl,SKILL_NUM = skill_num,TYPE = type}
		table.insert(zhuangbei_ID_list,tempinfo) 
	end
	a:ForeachEquips(eachFunc)

    table.sort(zhuangbei_ID_list,SortFun)
    print("仓库装备数：",#zhuangbei_ID_list)
    local s2 = os.clock()
    print("同步：",s2 - s1)
    --销毁button
   
    

    for i = 1,#zhuangbei_ID_list do
		-- 实例化装备
        if self.backpackCailiaoEquips[zhuangbei_ID_list[i].ID] == nil then           
            local equip = zhuangbei_ID_list[i]
            self.backpackCailiaoEquips[equip.ID] = self:CreateCailiaoEquips(equip.ID,equip.DataID,equip.HeroID)
            local info = {}
            info.gameObject = self.backpackCailiaoEquips[equip.ID].gameObject
            info.id = self.backpackCailiaoEquips[equip.ID].dyID
		    table.insert(self.backpackCailiaoEquipsObj,info)              
        end	 
	end
    Yield()
    for i = 1,#self.backpackCailiaoEquipsObj do
        self.backpackCailiaoEquipsObj[i].gameObject:SetActive(false)      
    end
    
    panel:SetActive(true)
    self.cmCaiLiaoScrollView:ResetPosition()--设置滑动条初始位置
	--设置武具的外观显示
    local s3 = os.clock()
    local k = 1
	for i = 1,#zhuangbei_ID_list do
        self:SetCailiaoEquipContent(self.backpackCailiaoEquipsObj[i].gameObject,zhuangbei_ID_list[i])
        self.backpackCailiaoEquipsObj[i].id = zhuangbei_ID_list[i].ID
        if k == 30 then
            k = 1           
            cmTable:Reposition()
            Yield()
        end 
        k = k + 1         	
    end
    local s4 = os.clock()
    print("shuaxin:",s4 - s3)
    
	cmTable:Reposition()
    self.isShuaxinCailiaoEquips = false
    -------------------------------------------------------------------------------------------

end

function wnd_xilianClass:CreateCailiaoEquips(dyID,staticID,heroID)
    local equipBtn = self.instance:FindWidget("cailiao_grid/e_cailiao_btn")
    local cailiao_Grid = self.instance:FindWidget("cailiao_grid")
    local info = {}
    info.gameObject = GameObject.InstantiateFromPreobj(equipBtn,cailiao_Grid)
    info.dyID = dyID
    info.heroID = heroID
    info.gameObject:SetName(dyID)
    info.sinfo = sdata_EquipData:GetRow(staticID)--取得静态数据
    return info   
end
--设置装备的显示外观
function wnd_xilianClass:SetCailiaoEquipContent(gameObject,info)
--设置装备外观
    local equipInfo = sdata_EquipData:GetRow(tonumber(info.DataID))
    --装备图标
    local sprite = gameObject:FindChild("cailiao_img")
	local cmIcon = sprite:GetComponent(CMUISprite.Name)
	cmIcon:SetSpriteName(equipInfo[sdata_EquipData.I_Icon])
    --装备等级
    local lvObj = gameObject:FindChild("lv_txt")
    local cmLv = lvObj:GetComponent(CMUILabel.Name)
    cmLv:SetValue(string.sformat(SData_Id2String.Get(5075),equipInfo[sdata_EquipData.I_RequireLv]))
    --穿戴信息
    local heroNameObj = gameObject:FindChild("name_txt")
    if info.HeroID~=nil and info.HeroID>0 then
        heroNameObj:SetActive(true)
        local cmNameLabel = heroNameObj:GetComponent(CMUILabel.Name)                     
        cmNameLabel:SetValue(SData_Hero.GetHero(info.HeroID):Name())
    else
        heroNameObj:SetActive(false)
    end 

    --洗练底纹
    local attr = wnd_heroinfo:GetXilianNum(info.ID)
    local sprite = gameObject:FindChild("cailiao_bg")
	local cmSprite = sprite:GetComponent(CMUISprite.Name)
    local DewenName = ""
    if attr == 1 then
        DewenName = equipInfo[sdata_EquipData.I_XilianDiwen1]
    elseif attr == 2 then
        DewenName = equipInfo[sdata_EquipData.I_XilianDiwen2]
    elseif attr == 3 then
        DewenName = equipInfo[sdata_EquipData.I_XilianDiwen3]
    else
        DewenName = equipInfo[sdata_EquipData.I_WeixilianDewen]
    end
    cmSprite:SetSpriteName(DewenName)
    gameObject:SetActive(true)
    gameObject:SetName(info.ID)
    --改变内容
    self.backpackCailiaoEquips[info.ID].gameObject = gameObject
    self.backpackCailiaoEquips[info.ID].dyID = info.ID
    self.backpackCailiaoEquips[info.ID].heroID = info.HeroID
    self.backpackCailiaoEquips[info.ID].sinfo = sdata_EquipData:GetRow(info.DataID)--取得静态数据

    local p_info = {}
    p_info.obj = gameObject
    p_info.equipInfo = info       
    self:BindUIEvent("cailiao_grid/"..info.ID.."/reduce",UIEventType.Click,"OnReduceEquip",p_info)
    self:BindUIEvent("cailiao_grid/"..info.ID,UIEventType.Click,"OnAddEquip",p_info)  
   
end

function wnd_xilianClass:CreateCailiao()
    local cailiaoBtn = self.instance:FindWidget("cailiao_grid/s_cailiao_btn")
    local cailiao_Grid = self.instance:FindWidget("cailiao_grid")
    local info = {}
    info.gameObject = GameObject.InstantiateFromPreobj(cailiaoBtn,cailiao_Grid)
    return info   
end
--设置装备的显示外观
function wnd_xilianClass:SetCailiaoContent(gameObject,info)
--设置装备外观
    local cailiaoInfo = sdata_XilianshiData:GetRow(tonumber(info.ID))
    local sprite = gameObject:FindChild("cailiao_img")
	local cmIcon = sprite:GetComponent(CMUISprite.Name)
	cmIcon:SetSpriteName(cailiaoInfo[sdata_XilianshiData.I_Icon])
    local amount_txt = gameObject:FindChild("amount_txt")
    local cmLabelAmountTxt = amount_txt:GetComponent(CMUILabel.Name)
    cmLabelAmountTxt:SetValue(info.NUM)
    gameObject:SetActive(true)
    gameObject:SetName(info.ID)    
end
--协程
function wnd_xilianClass:LongPress(obj,info)
    StartCoroutine(self,self.OnLongPress,info)--启动协程
end
local k = 0
function wnd_xilianClass:OnPress(obj,flag)
    if flag == false then
        self.Flag = false--当鼠标抬起设置标志位为false
    end
end
--长按事件回调函数
function wnd_xilianClass:OnLongPress(info)
    local m_Item = info.obj:FindChild("reduce")--self.instance:FindWidget("s_cailiao_btn"..i.."/reduce")
    local cailiaoObj = m_Item:GetComponent(CMUITweener.Name)
    --装备洗练所需洗练值     
    local XLZ = sdata_EquipData:GetV(sdata_EquipData.I_Xilian,wnd_heroinfo:ID_DataID(self.xilian_id))
    if sum_xilian >= XLZ then
        if info.cailiaoInfo.LEFT > 0 then
            
            cailiaoObj:PlayForward()
            --Poptip.PopMsg(SData_Id2String.Get(3186),Color.white) 
            self.cmTweenLight_Flash:ResetToBeginning()
            self.cmTweenLight_Flash:PlayForward()
            return   
        end 
        --Poptip.PopMsg(SData_Id2String.Get(3186),Color.white) 
        self.cmTweenLight_Flash:ResetToBeginning()
        self.cmTweenLight_Flash:PlayForward()     
        return 
    end
    self.Flag = true
    while true do
        Yield(0.08)
        self:OnAddShitou(obj,info)
               
        --播放动画
        --self:SetWidgetActive("s_cailiao_btn"..i.."/reduce",true)
        m_Item:SetActive(true)
        cailiaoObj:ResetToBeginning()
        cailiaoObj:PlayForward()
        if self.Flag == false then break end
        if sum_xilian >= XLZ then break end
    end
end
--reduce长按事件
function wnd_xilianClass:LP_Reduce(obj,info)
    print("LP_Reduce")
    StartCoroutine(self,self.OnLP_Reduce,info)--启动协程
end
function wnd_xilianClass:OnP_Reduce(obj,flag)
    print("OnP_Reduce")
    if flag == false then
        self.ReduceFlag = false--当鼠标抬起设置标志位为false
    end
end
--长按事件回调函数
function wnd_xilianClass:OnLP_Reduce(info)
    print("LP_Reduce")
    self.ReduceFlag = true
    while true do
        Yield(0.08)
        self:OnReduceShitou(obj,info)
        if self.ReduceFlag == false then break end
        if tonumber(info.cailiaoInfo.LEFT) <= 0 then
            break
        end
    end
end

--添加洗练石头 
function wnd_xilianClass:OnAddShitou(obj,info)
	--装备洗练所需洗练值     
    local XLZ = sdata_EquipData:GetV(sdata_EquipData.I_Xilian,wnd_heroinfo:ID_DataID(self.xilian_id))
    --材料用尽
    if tonumber(info.cailiaoInfo.RIGHT) <= 0 then
        Poptip.PopMsg(SData_Id2String.Get(3182),Color.red)
        return
    end
    --超过洗脸值，可以洗练
    if sum_xilian >= XLZ then
        self.cmTweenLight_Flash:ResetToBeginning()
        self.cmTweenLight_Flash:PlayForward()
        self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),XLZ,XLZ))
        --Poptip.PopMsg(SData_Id2String.Get(3186),Color.white) 
        self:SetWidgetActive("btn_panel/xilian_mask_btn",false)
        self:SetWidgetActive("light_outside",true)
        --print(cailiao_ID_list[i].LEFT..".................."..cailiao_ID_list[i].RIGHT)
        if tonumber(info.cailiaoInfo.LEFT) == 0 then
            --播放动画
            local m_Item = info.obj:FindChild("reduce")--self.instance:FindWidget("s_cailiao_btn"..i.."/reduce")
            local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
            cailiaoObj[1]:ResetToBeginning()
            cailiaoObj[1]:PlayReverse()
        end 
        return      
    end
    --计算洗脸值
    local xlz = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Xilianzhi,tonumber(info.cailiaoInfo.ID))
    sum_xilian = sum_xilian + xlz
    info.cailiaoInfo.LEFT = info.cailiaoInfo.LEFT + 1--左边+1
    info.cailiaoInfo.RIGHT = info.cailiaoInfo.RIGHT - 1--右边减1
    self:SetLabel(info.cailiaoInfo.ID.."/amount_txt",string.sformat(SData_Id2String.Get(5005),info.cailiaoInfo.LEFT,info.cailiaoInfo.RIGHT))         
    
    --洗练槽进度条
    --self:ProgressSlowGrow_XC(tonumber(xlz),tonumber(sum_xilian),tonumber(XLZ))
    local m_Item = self.instance:FindWidget( "bg_panel/xiliancao_img" )
    local xlcObj = m_Item:GetComponent(CMUIProgressBar.Name)
    xlcObj:SetValue( tonumber(sum_xilian)/tonumber(XLZ) )
    if sum_xilian >= XLZ then
        self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),XLZ,XLZ))
        --Poptip.PopMsg(SData_Id2String.Get(3186),Color.white) 
        self:SetWidgetActive("btn_panel/xilian_mask_btn",false)
        self:SetWidgetActive("light_outside",true)
    else
        self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),sum_xilian,XLZ))
    end   
    

    
end


--添加洗练装备
function wnd_xilianClass:OnAddEquip(obj,info)
    print("OnAddEquip",info.equipInfo.ID)
    --初始化为未被穿戴的装备  true为穿戴   false未穿戴
    self.IsXilian = false
    --装备洗练所需洗练值     
    local XLZ = sdata_EquipData:GetV(sdata_EquipData.I_Xilian,wnd_heroinfo:ID_DataID(self.xilian_id))
    local dyID = info.equipInfo.ID
    --该装备时待洗练装备
    if dyID == self.xilian_id then
        Poptip.PopMsg(SData_Id2String.Get(3183),Color.white)
        --播放动画
        local m_Item = info.obj:FindChild("reduce")
        local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
        cailiaoObj[1]:PlayReverse()
        return
    end
     --已经添加进去的装备
    for k = 1, #xilian_zhuangbei do
        if xilian_zhuangbei[k] == dyID then
            Poptip.PopMsg(SData_Id2String.Get(3184),Color.white)
            flag = false
            return                        
        end
    end
    --洗脸值已满
    if sum_xilian >= XLZ then
        self.cmTweenLight_Flash:ResetToBeginning()
        self.cmTweenLight_Flash:PlayForward()
        --Poptip.PopMsg(SData_Id2String.Get(3186),Color.white)
        --播放动画
        local m_Item = info.obj:FindChild("reduce")
        local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
        cailiaoObj[1]:PlayReverse()
        return
    end 
 
    --下面为可以添加，并洗练的装备 
    if self.IsXilian == false then
        local ID = dyID
        local DataID = tonumber(info.equipInfo.DataID)
        local xilian_skill = wnd_heroinfo:GetXilianNum(ID)
        --以下为洗练出的装备与为洗练的装备提供的回收值不同      
        if xilian_skill ~= 0 then
            sum_xilian = sum_xilian + sdata_EquipData:GetV(sdata_EquipData.I_XilianRecycle,DataID)
        else
            sum_xilian = sum_xilian + sdata_EquipData:GetV(sdata_EquipData.I_Recycle,DataID)
        end
        temp_zhuangbei.id = dyID
        table.insert(xilian_zhuangbei,temp_zhuangbei.id)
        --洗练槽进度条
        local m_Item = self.instance:FindWidget( "bg_panel/xiliancao_img" )
        local xlcObj = m_Item:GetComponent(CMUIProgressBar.Name)
        xlcObj:SetValue( tonumber(sum_xilian)/tonumber(XLZ) )
                
        if tonumber(info.equipInfo.HeroID) ~= 0 then
                              
            wnd_ShuangXuan:SetLabelInfo("友情提示！",SData_Id2String.Get(3185), info)
            wnd_ShuangXuan:SetCurrFrame(3)
            wnd_ShuangXuan:Show()            
        end                        

    else
        --取消添加该材料，将会将减号关闭
        local m_Item = info.obj:FindChild("reduce")
        local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
        cailiaoObj[1]:ResetToBeginning()
        cailiaoObj[1]:PlayReverse()
    end
        
    --判断
    self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),sum_xilian,XLZ))
    if sum_xilian >= XLZ then
        self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),XLZ,XLZ)) 
        self:SetWidgetActive("btn_panel/xilian_mask_btn",false)
        self:SetWidgetActive("light_outside",true)
    end  

end

--强制当做洗练材料回调函数
function wnd_xilianClass:OnFinish(para)
    self.IsXilian = false
end
function wnd_xilianClass:OnCancel(info)
    self.IsXilian = true
    self:OnReduceEquip(_,info)
    --播放动画
    local m_Item = info.obj:FindChild("reduce")
    local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
    cailiaoObj[1]:PlayReverse()
end
--减少洗练石头

function wnd_xilianClass:OnReduceShitou(obj,info)

    --装备洗练所需洗练值     
    local XLZ = sdata_EquipData:GetV(sdata_EquipData.I_Xilian,wnd_heroinfo:ID_DataID(self.xilian_id))
    sum_xilian = sum_xilian - sdata_XilianshiData:GetV(sdata_XilianshiData.I_Xilianzhi,tonumber(info.cailiaoInfo.ID))
    info.cailiaoInfo.LEFT = info.cailiaoInfo.LEFT - 1
    info.cailiaoInfo.RIGHT = info.cailiaoInfo.RIGHT + 1
    if info.cailiaoInfo.LEFT == 0 then
        self:SetLabel(info.cailiaoInfo.ID.."/amount_txt",info.cailiaoInfo.RIGHT)
    else
        self:SetLabel(info.cailiaoInfo.ID.."/amount_txt",string.sformat(SData_Id2String.Get(5005),info.cailiaoInfo.LEFT,info.cailiaoInfo.RIGHT))
    end
    if tonumber(info.cailiaoInfo.LEFT) > 0 then
        local m_Item = info.obj:FindChild("reduce")
        local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
        cailiaoObj[1]:ResetToBeginning()
        cailiaoObj[1]:PlayForward()
    
    else
        --播放动画
        local m_Item = info.obj:FindChild("reduce")
        local cailiaoObj = m_Item:GetComponents(CMUITweener.Name)
        
        cailiaoObj[1]:PlayReverse()
    end  
    self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),sum_xilian,XLZ))
    --洗练槽进度条
    local m_Item = self.instance:FindWidget( "bg_panel/xiliancao_img" )
    local xlcObj = m_Item:GetComponent(CMUIProgressBar.Name)
    xlcObj:SetValue( tonumber(sum_xilian)/tonumber(XLZ) )
    if sum_xilian >= XLZ then 
        self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),XLZ,XLZ))
        self:SetWidgetActive("btn_panel/xilian_mask_btn",false)
        self:SetWidgetActive("light_outside",true)

    else
        self:SetWidgetActive("btn_panel/xilian_mask_btn",true)
        self:SetWidgetActive("light_outside",false)
    end
     
end

------------------------------------减少洗练材料
function wnd_xilianClass:OnReduceEquip(obj,info)
    print("OnReduceEquip")
    --装备洗练所需洗练值     
    local XLZ = sdata_EquipData:GetV(sdata_EquipData.I_Xilian,wnd_heroinfo:ID_DataID(self.xilian_id))

    local ID = info.equipInfo.ID
    local DataID = tonumber(info.equipInfo.DataID)
    local xilian_skill = wnd_heroinfo:GetXilianNum(ID)
    if xilian_skill ~= 0 then
        sum_xilian = sum_xilian - sdata_EquipData:GetV(sdata_EquipData.I_XilianRecycle,DataID)
    else
        sum_xilian = sum_xilian - sdata_EquipData:GetV(sdata_EquipData.I_Recycle,DataID)
    end
  
    for k = 1, #xilian_zhuangbei do
        if xilian_zhuangbei[k] == ID then
            table.remove(xilian_zhuangbei,k)
        end
    end

    --洗练槽进度条
    local m_Item = self.instance:FindWidget( "bg_panel/xiliancao_img" )
    local xlcObj = m_Item:GetComponent(CMUIProgressBar.Name)
    xlcObj:SetValue( tonumber(sum_xilian)/tonumber(XLZ) )               
    self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),sum_xilian,XLZ))
    if sum_xilian >= XLZ then 
        self:SetLabel("xilianzhi_bg/txt",string.sformat(SData_Id2String.Get(5005),XLZ,XLZ))
        self:SetWidgetActive("btn_panel/xilian_mask_btn",false)
        self:SetWidgetActive("light_outside",true)
    else
        self:SetWidgetActive("btn_panel/xilian_mask_btn",true)
        self:SetWidgetActive("light_outside",false)
    end

end
--更新洗练页
function wnd_xilianClass:OnXiLian(obj,ID)
    if ID ~= self.xilian_id then
        for i = 1,#xilian_zhuangbei do
            local reduce = self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject:FindChild("reduce")
            reduce:SetActive(false)  
        end
        for i = 1,#self.backpackCailiaoObj do
            local reduce = self.backpackCailiaoObj[i]:FindChild("reduce")
            reduce:SetActive(false)
        end

        self.xilian_id = ID
        self:InitXilian()      
    end
end

--解析装备简单洗练属性
function wnd_xilianClass:split(str,ID)
    
    if string.len(str) ~= 0 then
        local EquipInfo1 = string.split(str,',')
        for i =1 ,#EquipInfo1 do
            local EquipInfo2 = string.split(EquipInfo1[i],':')
            local StateKey = tonumber( EquipInfo2[1] )--11,12,2,3...
            local StateValue = tonumber(EquipInfo2[2] )--1,0

            if StateKey == 11 then
                if StateValue == 1 then
                    --显示1-1
                    self.cmLabel_skill_name:SetColor(Color.new(0,155/255,1,1))
                    self.cmLabel_shuxing01:SetColor(Color.new(0,155/255,1,1))

                    self.shuxing01_obj:SetActive(true)
                    self.shuxing02_obj:SetActive(false)
                    self.jineng_obj:SetActive(false)

                    local shuxing1 = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing1,ID)
                    local xlsxName1 = sdata_EquipData:GetV(sdata_EquipData.I_XilianshuxingName1,ID)
                    local xlsxNum1 = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum1,ID))
                    self.cmLabel_skill_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName1))
                    if shuxing1 == 1 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum1))
                    elseif shuxing1 == 2 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum1))
                    elseif shuxing1 == 3 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum1))
                    elseif shuxing1 == 4 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum1))
                    end     
                end
            elseif StateKey == 12 then
                if StateValue == 1 then
                    --显示1-1
                    self.cmLabel_skill_name:SetColor(Color.new(0,155/255,1,1))
                    self.cmLabel_shuxing01:SetColor(Color.new(0,155/255,1,1))

                    self.shuxing01_obj:SetActive(true)
                    self.shuxing02_obj:SetActive(false)
                    self.jineng_obj:SetActive(false)


                    local shuxing1B = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing1B,ID)
                    local xlsxName1B = sdata_EquipData:GetV(sdata_EquipData.I_XilianshuxingName1B,ID)
                    local xlsxNum1B = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum1B,ID))
                    self.cmLabel_skill_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName1B))
                    if shuxing1B == 1 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum1B))
                    elseif shuxing1B == 2 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum1B))
                    elseif shuxing1B == 3 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum1B))
                    elseif shuxing1B == 4 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum1B))
                    end     
                end

            elseif StateKey == 2 then          
                if StateValue == 1 then  
                    self.cmLabel_skill_name:SetColor(Color.new(180/255,0,1,1))                  
                    self.cmLabel_shuxing01:SetColor(Color.new(180/255,0,1,1))
                    self.cmLabel_shuxing02:SetColor(Color.new(180/255,0,1,1))

                    self.shuxing01_obj:SetActive(true)
                    self.shuxing02_obj:SetActive(true)
                    self.jineng_obj:SetActive(false)

                    local shuxing_2A = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing2A,ID)
                    local xlsxName2 = sdata_EquipData:GetV(sdata_EquipData.I_XilianshuxingName2,ID)
                    local xlsxNum2A = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum2A,ID))
                    self.cmLabel_skill_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName2))
                    if shuxing_2A == 1 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum2A))
                    elseif shuxing_2A == 2 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum2A))
                    elseif shuxing_2A == 3 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum2A))
                    elseif shuxing_2A == 4 then
                        self.cmLabel_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum2A))
                    end

                    local shuxing_2B = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing2B,ID)
                    local xlsxNum2B = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum2B,ID))
                    if shuxing_2B == 1 then
                        self.cmLabel_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum2B))
                    elseif shuxing_2B == 2 then
                        self.cmLabel_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum2B))                    
                    elseif shuxing_2B == 3 then
                        self.cmLabel_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum2B))
                    elseif shuxing_2B == 4 then
                        self.cmLabel_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum2B))
                    end

                end
            elseif StateKey == 3 then     
                if StateValue == 1 then
                    self.cmLabel_skill_name:SetColor(Color.new(212/255,84/255,0,1))  
                    self.cmLabel_jineng:SetColor(Color.new(212/255,84/255,0,1))
                    self.jineng_obj:SetActive(true)
                    self.shuxing01_obj:SetActive(false)
                    self.shuxing02_obj:SetActive(false)
                    local xlsxName3 = sdata_EquipData:GetV(sdata_EquipData.I_XilianSkillName3,ID)                  
                    self.cmLabel_skill_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName3))
                    local skill_id = sdata_EquipData:GetV(sdata_EquipData.I_XilianSkill3,ID)
                    local skillinfo = SData_Skill.GetSkill(skill_id)
                    local skill_name = skillinfo:SkillNoteMin()
                    self.cmLabel_jineng:SetValue(string.sformat(SData_Id2String.Get(5081),skill_name))
                end
                 
            end
        end
    else 
        self.jineng_obj:SetActive(true)
        self.shuxing01_obj:SetActive(false)
        self.shuxing02_obj:SetActive(false)
        self.cmLabel_jineng:SetColor(Color.white)
        self.cmLabel_jineng:SetValue("无")
        self.cmLabel_skill_name:SetValue("")
    end   

end
--解析装备的详细属性并显示
function wnd_xilianClass:split_info(str,ID)
    self:InitXilianLabel()
    local flag = false--当为false时为11-0，true时是11-1    
    local EquipInfo1 = string.split(str,',')
    for i =1 ,#EquipInfo1 do
        local EquipInfo2 = string.split(EquipInfo1[i],':')
        local StateKey = tonumber( EquipInfo2[1] )--11,12,2,3...
        local StateValue = tonumber(EquipInfo2[2] )--1,0
        if StateKey == 11 then
            if StateValue == 1 then
                --显示1-1
                flag = true 
                self.shuxing1_flag = true--全局变量为true时，表示11-1，到2，3时会根据它来显示对应的信息             
                self.cmLabel_xilian01_name:SetColor(Color.new(0,155/255,1,1))
                self.cmLabel_xilian01_shuxing:SetColor(Color.new(0,155/255,1,1))
            else 
                flag = false
                self.cmLabel_xilian01_name:SetColor(Color.gray)
                self.cmLabel_xilian01_shuxing:SetColor(Color.gray)
            end

            local shuxing1 = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing1,ID)
            local xlsxName1 = sdata_EquipData:GetV(sdata_EquipData.I_XilianshuxingName1,ID)
            local xlsxNum1 = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum1,ID))
            self.cmLabel_xilian01_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName1))
            if shuxing1 == 1 then
                self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum1))
            elseif shuxing1 == 2 then
                self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum1))
            elseif shuxing1 == 3 then
                self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum1))
            elseif shuxing1 == 4 then
                self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum1))
            end 
                
        elseif StateKey == 12 then          
            if StateValue == 1 then
                --显示1-1
                flag = false
                self.shuxing1_flag = false               
                self.cmLabel_xilian01_name:SetColor(Color.new(0,155/255,1,1))
                self.cmLabel_xilian01_shuxing:SetColor(Color.new(0,155/255,1,1))
            else
                if flag == false and self.shuxing1_flag == false then
                    self.cmLabel_xilian01_name:SetColor(Color.gray)
                    self.cmLabel_xilian01_shuxing:SetColor(Color.gray)              
                end
            end

            local shuxing1B = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing1B,ID)
            local xlsxName1B = sdata_EquipData:GetV(sdata_EquipData.I_XilianshuxingName1B,ID)
            local xlsxNum1B = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum1B,ID))
            if flag == false and self.shuxing1_flag == false then
                self.cmLabel_xilian01_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName1B))
                if shuxing1B == 1 then
                    self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum1B))
                elseif shuxing1B == 2 then
                    self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum1B))
                elseif shuxing1B == 3 then
                    self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum1B))
                elseif shuxing1B == 4 then
                    self.cmLabel_xilian01_shuxing:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum1B))
                end     
            end


        elseif StateKey == 2 then
            
            if StateValue == 1 then 
                self.cmLabel_xilian02_name:SetColor(Color.new(180/255,0,1,1))                  
                self.cmLabel_xilian02_shuxing01:SetColor(Color.new(180/255,0,1,1))
                self.cmLabel_xilian02_shuxing02:SetColor(Color.new(180/255,0,1,1))

            else
                self.cmLabel_xilian02_name:SetColor(Color.gray)                  
                self.cmLabel_xilian02_shuxing01:SetColor(Color.gray)
                self.cmLabel_xilian02_shuxing02:SetColor(Color.gray)
            end

            local shuxing_2A = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing2A,ID)
            local xlsxName2 = sdata_EquipData:GetV(sdata_EquipData.I_XilianshuxingName2,ID)
            local xlsxNum2A = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum2A,ID))
            self.cmLabel_xilian02_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName2))
            if shuxing_2A == 1 then
                self.cmLabel_xilian02_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum2A))
            elseif shuxing_2A == 2 then
                self.cmLabel_xilian02_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum2A))
            elseif shuxing_2A == 3 then
                self.cmLabel_xilian02_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum2A))
            elseif shuxing_2A == 4 then
                self.cmLabel_xilian02_shuxing01:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum2A))
            end

            local shuxing_2B = sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxing2B,ID)
            local xlsxNum2B = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_XilianShuxingNum2B,ID))
            if shuxing_2B == 1 then
                self.cmLabel_xilian02_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),xlsxNum2B))
            elseif shuxing_2B == 2 then
                self.cmLabel_xilian02_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),xlsxNum2B))
            elseif shuxing_2B == 3 then
                self.cmLabel_xilian02_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),xlsxNum2B))
            elseif shuxing_2B == 4 then
                self.cmLabel_xilian02_shuxing02:SetValue(string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),xlsxNum2B))
            end


        elseif StateKey == 3 then 
             
            if StateValue == 1 then
                self.cmLabel_xilian03_name:SetColor(Color.new(212/255,84/255,0,1))  
                self.cmLabel_xilian03_shuxing:SetColor(Color.new(212/255,84/255,0,1))   
            else
                self.cmLabel_xilian03_name:SetColor(Color.gray)  
                self.cmLabel_xilian03_shuxing:SetColor(Color.gray)                    
            end
            local xlsxName3 = sdata_EquipData:GetV(sdata_EquipData.I_XilianSkillName3,ID)
            self.cmLabel_xilian03_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName3))                                  
            local skill_id = sdata_EquipData:GetV(sdata_EquipData.I_XilianSkill3,ID)
            local skillinfo = SData_Skill.GetSkill(skill_id)
            local skill_name = skillinfo:SkillNoteMin()--技能名字
            self.cmLabel_xilian03_shuxing:SetValue(string.sformat(SData_Id2String.Get(5080),skill_name))            
        end
    end

end


--初始化洗练属性状态
function wnd_xilianClass:InitXilianLabel()
    self.cmLabel_xilian01_name:SetColor(Color.gray)
    self.cmLabel_xilian01_name:SetValue(SData_Id2String.Get(5068))
    self.cmLabel_xilian01_shuxing:SetColor(Color.gray)
    self.cmLabel_xilian01_shuxing:SetValue(SData_Id2String.Get(5069))
    self.cmLabel_xilian02_name:SetColor(Color.gray)
    self.cmLabel_xilian02_name:SetValue(SData_Id2String.Get(5068))
    self.cmLabel_xilian02_shuxing01:SetColor(Color.gray)
    self.cmLabel_xilian02_shuxing01:SetValue(SData_Id2String.Get(5069))
    self.cmLabel_xilian02_shuxing02:SetColor(Color.gray)
    self.cmLabel_xilian02_shuxing02:SetValue(SData_Id2String.Get(5069))
    self.cmLabel_xilian03_name:SetColor(Color.gray)
    self.cmLabel_xilian03_name:SetValue(SData_Id2String.Get(5068))
    self.cmLabel_xilian03_shuxing:SetColor(Color.gray)
    self.cmLabel_xilian03_shuxing:SetValue(SData_Id2String.Get(5069))
end
--开始洗练
function wnd_xilianClass:OnXilianStart()
    print(wnd_heroinfo.wuju_flag,"OnXilianStart",wnd_heroinfo.hujia_flag)
    self:SetWidgetActive("xilian_mask_btn",true)
    self:SetWidgetActive("light_outside",false)
    
    --设置返回键为不可用
    print("关闭")
    self.cmBtnBack:SetIsEnabled(false)
    print("正在洗练的装备：",self.xilian_id)      
    table.clear(xilian_info)
    for i = 1,#xilian_zhuangbei do
        temp_info = {t = 1,id = xilian_zhuangbei[i],num = 1}
        table.insert(xilian_info,temp_info)
    end
    --将材料放入xilian_info
    for i  = 1,#cailiao_ID_list do
        if cailiao_ID_list[i].LEFT > 0 then
            local Num = tonumber(cailiao_ID_list[i].LEFT)
            local Id =  tonumber(cailiao_ID_list[i].ID)
            temp_info = {t = 0,id = Id,num = Num}
            table.insert(xilian_info,temp_info)
        end
    end  
	
    self:SendXilianInfo(self.xilian_id)       
end
--发送洗练信息协议
function wnd_xilianClass:SendXilianInfo(ID)
    local jsonNM = QKJsonDoc.NewMap()
    jsonNM:Add("n","ZBXL")
    jsonNM:Add("eid",ID)
    local requires = QKJsonDoc.NewArray()
    local jsonNM1 = QKJsonDoc.NewMap()
    for i = 1,#xilian_info do
        jsonNM1:Add("t",xilian_info[i].t)
        jsonNM1:Add("id",xilian_info[i].id)
        jsonNM1:Add("num",xilian_info[i].num)
         requires:Add("",jsonNM1)
    end
    jsonNM:Add("requires",requires)
    local  loader = GameConn:CreateLoader(jsonNM,0)
    HttpLoaderEX.WaitRecall(loader,self,self.OnXilianResult)    
end

function wnd_xilianClass:OnXilianResult(jsonDoc)
    local Result = tonumber (jsonDoc:GetValue("r"))
    if  Result ~= 0 then
        self:SetWidgetActive("xilian_mask_btn",false)
        self:SetWidgetActive("light_outside",true)
        self.cmBtnBack:SetIsEnabled(true)
        print("打开")   
        if Result == 10 then
        Poptip.PopMsg("装备不存在",Color.red)
        elseif Result == 11 then
        Poptip.PopMsg("非法装备",Color.red)
        elseif Result == 20 then
        Poptip.PopMsg("洗练值不足",Color.red)
        end
    else
        
        
            
        wnd_heroinfo.isFromXilian = true
        --洗练后刷新仓库装备
        print(wnd_heroinfo.wuju_flag," ",wnd_heroinfo.hujia_flag)
        
        --若装备被洗掉  则退出属性板子
        print(#xilian_zhuangbei)
        for i = 1,#xilian_zhuangbei do
            print(xilian_zhuangbei[i],wnd_heroinfo.CurrEquipmentInfo)
            if xilian_zhuangbei[i] == wnd_heroinfo.CurrEquipmentInfo then 
                wnd_heroinfo:PlayXiezai_XC()

                break
            end
        end

--        for i = 1,#xilian_zhuangbei do
--            for k = 1,#self.backpackCailiaoEquipsObj do
--                if xilian_zhuangbei[i] == self.backpackCailiaoEquipsObj[k].id then
--                    self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject:SetActive(false)
--                    local reduce = self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject:FindChild("reduce")
--                    reduce:SetActive(false)
--                end         
--            end                
--        end
        for i = 1,#xilian_zhuangbei do
            print("IDDDD",xilian_zhuangbei[i])
            for k = #self.backpackCailiaoEquipsObj,1,-1 do
                if self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject == self.backpackCailiaoEquipsObj[k].gameObject then
                    print(self.backpackCailiaoEquipsObj[k].gameObject,"---------------",self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject)
                    print("remove:",self.backpackCailiaoEquipsObj[k].gameObject)
                    self.backpackCailiaoEquipsObj[k].gameObject:SetActive(false)
                    table.remove(self.backpackCailiaoEquipsObj, k)
                end   
            end
            if self.backpackWujuObj ~= nil then
                for k = #self.backpackWujuObj,1,-1 do
                    if self.backpackEquips[xilian_zhuangbei[i]].gameObject == self.backpackWujuObj[k].gameObject then
                        self.backpackWujuObj[k].gameObject:SetActive(false)
                        table.remove(self.backpackWujuObj, k)
                    end   
                end
            end
            if wnd_heroinfo.backpackWujuObj ~= nil and wnd_heroinfo.backpackWujuEquips[xilian_zhuangbei[i]] ~= nil then
                for k = #wnd_heroinfo.backpackWujuObj,1,-1 do
                    if wnd_heroinfo.backpackWujuEquips[xilian_zhuangbei[i]].gameObject == wnd_heroinfo.backpackWujuObj[k].gameObject then
                        wnd_heroinfo.backpackWujuObj[k].gameObject:GetParent():SetActive(false)
                        table.remove(wnd_heroinfo.backpackWujuObj, k)
                    end 
                end
            end
            if wnd_heroinfo.backpackHujiaObj ~= nil and wnd_heroinfo.backpackHujiaEquips[xilian_zhuangbei[i]] ~= nil then
                for k = #wnd_heroinfo.backpackHujiaObj,1,-1 do
                    if wnd_heroinfo.backpackHujiaEquips[xilian_zhuangbei[i]].gameObject == wnd_heroinfo.backpackHujiaObj[k].gameObject then
                        wnd_heroinfo.backpackHujiaObj[k].gameObject:GetParent():SetActive(false)
                        table.remove(wnd_heroinfo.backpackHujiaObj, k)
                    end 
                end
            end
      end
--        for i = 1,#xilian_zhuangbei do
--            for k = #self.backpackCailiaoEquipsObj,1,-1 do
--                if xilian_zhuangbei[i] == self.backpackCailiaoEquipsObj[k].id then
--                    print(self.backpackCailiaoEquipsObj[k].gameObject,"---------------",self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject)
--                    print("remove:",self.backpackCailiaoEquipsObj[k].gameObject)
--                    self.backpackCailiaoEquipsObj[k].gameObject:SetActive(false)
--                    table.remove(self.backpackCailiaoEquipsObj, k)

--                end   
--            end
--        end
  
       for i = 1,#self.backpackCailiaoObj do
            local reduce = self.backpackCailiaoObj[i]:FindChild("reduce")
            reduce:SetActive(false)
        end      
        print("end")
        --将下面两个参数存起来，防止下面函数修改
        local wuju_flag = wnd_heroinfo.wuju_flag
        local hujia_flag = wnd_heroinfo.hujia_flag
        --退出后刷新info板子
        if wnd_heroinfo.wujuinfo_flag and wnd_heroinfo.InfoToXilian ~= 0 then
            wnd_heroinfo.isFromXilianToInfo = true
            wnd_heroinfo:ShowWujuInfo(wnd_heroinfo.InfoToXilian)
        elseif wnd_heroinfo.hujiainfo_flag and wnd_heroinfo.InfoToXilian ~= 0 then
            wnd_heroinfo.isFromXilianToInfo = true
            wnd_heroinfo:ShowHujiaInfo(wnd_heroinfo.InfoToXilian)
        end
        --还原两参数
        wnd_heroinfo.wuju_flag = wuju_flag
        wnd_heroinfo.hujia_flag = hujia_flag
        --重新刷新装备仓库
        if wnd_heroinfo.wuju_flag == true then
            print("--CreateWujuUI()")
            --wnd_heroinfo.isCreateWujuAgain = true
            wnd_heroinfo.isShuxinWuju = true
            wnd_heroinfo:CreateWujuUI()
        elseif wnd_heroinfo.hujia_flag == true then
            print("--CreateHujiaUI()")
            --wnd_heroinfo.isCreateHujiaAgain = true
            wnd_heroinfo.isShuxinHujia = true
            wnd_heroinfo:CreateHujiaUI()
        end
--        self.isCreateEquip = true
        --type==3代表洗练
	    wnd_success:showType(3) 
        wnd_success:Show() 
        self:InitXilian()
        self.cmBtnBack:SetIsEnabled(true)
        print("打开")
        wnd_heroinfo:InitEquip()
    end
end

----------------------------退出页面
function wnd_xilianClass:OnClose()
    for i = 1,#xilian_zhuangbei do
        local reduce = self.backpackCailiaoEquips[xilian_zhuangbei[i]].gameObject:FindChild("reduce")
        reduce:SetActive(false)  
    end
    for i = 1,#self.backpackCailiaoObj do
        local reduce = self.backpackCailiaoObj[i]:FindChild("reduce")
        reduce:SetActive(false)
    end
    
    table.clear(xilian_zhuangbei)
    if self.showShuXingFlag == false then
        wnd_heroinfo:ShowShuXing() 
    end
    self.showShuXingFlag = false	   
    self:Hide() 
end
--实例即将被丢失
function wnd_xilianClass:OnLostInstance()
    --窗体卸载时，无条件销毁
    self.backpackEquips = {}--背包的装备
    self.backpackCailiaoEquips = {}
    self.backpackWujuObj = {}
    self.backpackCailiaoEquipsObj = {}
    self.backpackCailiao = {}
    self.backpackCailiaoObj = {}


    self.isCailiaoCreate = nil
    --全局变量
    self.IsXilian = nil  
    self.shuxing1_flag = nil--全局变量为true时，表示11-1，到2，3时会根据它来显示对应的信息
    self.Eq_grid = nil
    self.Equip = nil
    self.scrollView = nil
    self.CMScrollView = nil
    self.cailiaoPage = nil
    self.cmCaiLiaoScrollView = nil
    self.light_flashObj = nil
    self.cmTweenLight_Flash = nil
    
    --组件时间
    self.backObj = nil
    self.cmBtnBack = nil

    --洗练属性(信息板上)
    self.xilian01_name_obj = nil
    self.cmLabel_xilian01_name = nil

    self.xilian01_shuxing_obj = nil
    self.cmLabel_xilian01_shuxing = nil

    self.xilian02_name_obj = nil
    self.cmLabel_xilian02_name = nil

    self.xilian02_shuxing01_obj = nil
    self.cmLabel_xilian02_shuxing01 = nil

    self.xilian02_shuxing02_obj = nil
    self.cmLabel_xilian02_shuxing02 = nil

    self.xilian03_name_obj = nil
    self.cmLabel_xilian03_name = nil

    self.xilian03_shuxing_obj = nil
    self.cmLabel_xilian03_shuxing = nil
    --洗练属性（仓库上）
    self.skill_name_obj = nil
    self.cmLabel_skill_name = nil
    self.shuxing01_obj = nil
    self.cmLabel_shuxing01 = nil
    self.shuxing02_obj = nil
    self.cmLabel_shuxing02 = nil
    self.jineng_obj = nil
    self.cmLabel_jineng = nil
end 
return wnd_xilianClass.new
 