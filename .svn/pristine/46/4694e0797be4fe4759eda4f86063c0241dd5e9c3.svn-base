--heroinfo.lua
--Date 2016/7/27
--此文件由[BabeLua]插件自动生成


local wnd_heroinfoClass = class(wnd_base)
  
local wuju_temp = 0--对比数据
local hujia_temp = 0--对比数据

 
wnd_heroinfo = nil--单例



local SendData = {
        HeroID = 0,
        equipID = 0,
        ic = 0
	}


--装备所属面板枚举
local EquipOwnerPanel = {
    Body = 1,--穿戴在身上
    Backpack = 2--在背包中
}


------------------------------
--拖拽控制
local DragDropCtrl = classWC()

function DragDropCtrl:ctor(DragDropSurface)
    self.Surface = DragDropSurface
end

function DragDropCtrl:Init()
    local Surface = self.Surface;
    --CMDragDropSurface
    
    Surface:AddDragDropJoinItemEvent(self,self.OnDragDropJoinItem)--绑定拖拽物加入事件 
    Surface:AddDragDropLeaveEvent(self,self.OnDragDropLeave)--绑定拖拽物离开事件
     
end

function DragDropCtrl:OnDragDropJoinItem(dragDropItem)
    print("OnDragDropJoinItem")
    --CMDragDropItem
    local equipInfo = self:GetEquipInfo(EquipOwnerPanel.Backpack,dragDropItem)--获取背包中的装备信息
    if equipInfo == nil then return end --背包中不存在这个装备


    local heroID = equipInfo.heroID
    local lv = equipInfo.sinfo[sdata_EquipData.I_RequireLv]--装备等级
    local ZGLV = tonumber(Player:GetNumberAttr(PlayerAttrNames.Level))--获取主公等级
    --若当前英雄已死，装备是死之前穿的，则不能穿装备
    if wnd_heroinfo.IsHeroDied == true then
        local tp = equipInfo.sinfo[sdata_EquipData.I_Type]--装备类型 
        local oldEquip = wnd_heroinfo:GetBodyEquip(tp)--位置上原来放的装备
        if oldEquip ~= nil then
            local canEq = wnd_heroinfo:GetEquipOperationByID(oldEquip.dyID)
            if canEq == 0 then
                Poptip.PopMsg(SData_Id2String.Get(3149),Color.red)
                local obj = dragDropItem.gameObject
                if obj~=nil then obj:Destroy() end  return --销毁后返回函数 
            end       
        end      
    end

    --判断拖拽物能否被穿戴
    
    local canEq = wnd_heroinfo:GetEquipOperationByID(equipInfo.dyID)
    if canEq == 0 then
        Poptip.PopMsg(SData_Id2String.Get(3150),Color.red)
        local obj = dragDropItem.gameObject
        if obj~=nil then obj:Destroy() end  return --销毁后返回函数 
    end
    --以下是活人正常穿戴
    if heroID == wnd_heroinfo.firstID then--装备已穿
        Poptip.PopMsg(SData_Id2String.Get(3142),Color.red)
        local obj = dragDropItem.gameObject
        if obj~=nil then  obj:Destroy() end
    elseif heroID ~= 0 and heroID ~= nil then--装备被别人穿，是否强制替换
        wnd_heroinfo:PlayShuangXuan(dragDropItem)       
    else
        if ZGLV < lv then
            Poptip.PopMsg(SData_Id2String.Get(3146),Color.red)
            local obj = dragDropItem.gameObject
            if obj~=nil then obj:Destroy() end return
        end
        --以下为正常穿戴
        local tp = equipInfo.sinfo[sdata_EquipData.I_Type]--装备类型 
        local oldEquip = wnd_heroinfo:GetBodyEquip(tp)--位置上原来放的装备
        if oldEquip~=nil then

            oldEquip:Destroy()--销毁
            wnd_heroinfo:SetBodyEquip(tp,nil)

            --由于装备从身上卸下，刷新背包中这个装备的显示外观
            local eInfo = self:GetEquipInfo(EquipOwnerPanel.Backpack, oldEquip)
            if eInfo~=nil then
                eInfo.heroID = nil
                wnd_heroinfo:OnEquipOwnerChanged( eInfo  )
            end
        end

        --克隆出新装备信息，并进行必要修改
        local newEquip = equipInfo:Clone()
        newEquip.gameObject = dragDropItem.gameObject
        newEquip.ownerPanel = EquipOwnerPanel.Body
        newEquip.heroID = wnd_heroinfo.firstID

        --背包中的装备所属英雄改变
        equipInfo.heroID = wnd_heroinfo.firstID

        --放入新装备
        wnd_heroinfo:SetBodyEquip(tp,newEquip)

        --所属面板改变，对外观和一些组件属性做相应调整
        wnd_heroinfo:OnEquipOwnerChanged(newEquip)
        wnd_heroinfo:OnEquipOwnerChanged(equipInfo)

        --发送穿戴协议
        wnd_heroinfo:DragDropChuanDai(newEquip.dyID)

    end

end

function DragDropCtrl:OnDragDropLeave(dragDropItem)
    print("OnDragDropLeave")
    local equipInfo = self:GetEquipInfo(EquipOwnerPanel.Body,dragDropItem)--获取已穿戴的装备信息
    if equipInfo == nil then return end --身上不存在这个装备
    local canEq = wnd_heroinfo:GetEquipOperationByID(equipInfo.dyID)
    if canEq == 0 then
        Poptip.PopMsg(SData_Id2String.Get(3149),Color.red)
        local DataID = equipInfo.sinfo[sdata_EquipData.I_ID]
        local tp = equipInfo.sinfo[sdata_EquipData.I_Type]
        --设置为空
        wnd_heroinfo:SetBodyEquip(tp,nil)
        wnd_heroinfo.BodyEquips[tp] = wnd_heroinfo:CreateEquip(equipInfo.dyID, DataID, equipInfo.heroID, EquipOwnerPanel.Body)
        wnd_heroinfo:OnEquipOwnerChanged(wnd_heroinfo.BodyEquips[tp])
    else
        local tp = equipInfo.sinfo[sdata_EquipData.I_Type]--装备类型 
        local oldEquip = wnd_heroinfo:GetBodyEquip(tp)--位置上原来放的装备
        if oldEquip~=nil then 
            --oldEquip:Destroy()--销毁
            wnd_heroinfo:SetBodyEquip(tp,nil)
            local eInfo = self:GetEquipInfo(EquipOwnerPanel.Backpack, oldEquip)
            if eInfo~=nil then
                eInfo.heroID = nil             
                wnd_heroinfo:OnEquipOwnerChanged( eInfo  )--由于装备从身上卸下，刷新背包中这个装备的显示外观
            end
        end
        --发送卸载装备的协议
        wnd_heroinfo:DragDropXiezai(equipInfo.dyID)
    end
end

function DragDropCtrl:GetEquipInfo(OwnerPanel,dragDropItem)

    local id 
    if dragDropItem.dyID~=nil then --传入的是装备动态属性表
        id = dragDropItem.dyID
    else --传入的是拖拽组件
        id = dragDropItem:GetUserData() 
    end
     
    if OwnerPanel == EquipOwnerPanel.Backpack then
        return wnd_heroinfo:GetBackpackEquipByID(id)
    else
        return wnd_heroinfo:GetBodyEquipByID(id)
    end
end

------------------------------------------------------------------------
--英雄信息界面
------------------------------------------------------------------------
function wnd_heroinfoClass:Start() 
	wnd_heroinfo = self
	self:Init(WND.Heroinfo)
	self.currshowye = 1
	self.bIslistenmoney = false --金币铜币监听标记
end
function wnd_heroinfoClass:PlayerHeroData(id,T,y)--T代表当前应用的武将列表
	self.NUMMM = y
	local list =  Player:GetHeros()
	self.firstID = id
	self.heroList = {}
	for k,v in pairs (T)do
		for i = 1,#list do
			if tonumber(list[i]:GetAttr(HeroAttrNames.DataID)) == v then
				self.heroList[#self.heroList+1] = list[i]
			end
		end
	end
end
local money = {
	gold = 4,
	tb = 5
}
local zhuangbei = {
    ShuXing = 1,
    JiNeng = 2,
    ShiBing = 3,
    WuJu = 5,
    HuJia = 6,
    WuJuShuxing = 7,
    YiJian = 8,
	Liezhuan = 9,
}
--窗体被实例化时被调用
--初始化实例
function wnd_heroinfoClass:OnNewInstance()
	self.BisJN = false --是否在技能页
	self.JNItem = false--技能item
	self.SXxing = false--属性的星星
	self.SBxing = false--士兵的星星
    self.bIsGengti = false--对比数据
    self.wuju_flag = false--控制武具仓库动画
    self.hujia_flag = false--控制护甲仓库动画
    self.wujuinfo_flag = false--控制武具信息动画
    self.hujiainfo_flag = false--控制护甲信息动画
    self.shuxing1_flag = true
    
    self.isCreateWujuAgain = true-- 是否重新创建武具	
    self.isCreateHujiaAgain = true-- 是否重新创建护甲

    self.isShuxinWuju = true
    self.isShuxinHujia = true

	self:SetWidgetActive("heroinfo",false)


    self.backpackWujuObj = {}
    self.backpackHujiaObj = {}

    self.backpackWujuEquips = {}
    self.backpackHujiaEquips = {}

    self.isFromXilian = false
    self.isFromXilianToInfo = false

    self.CurrEquipmentInfo = 0--当前显示信息的装备
    self.CurrEquipmentShuxing = 0--当前仓库板子上显示的装备
    	

    --equipment_page
    self.equipment = self.instance:FindWidget("equipment_panel/equipment_page")
    self.equipmentObj = self.equipment:GetComponents(CMUITweener.Name)
    --e_shuxing_page
    self.e_shuxing_page = self.instance:FindWidget("e_shuxing_panel/e_shuxing_page")
    self.e_shuxing_pageObj = self.e_shuxing_page:GetComponents(CMUITweener.Name)
    --blur
    self.blur = self.instance:FindWidget("blur")
    self.blurObj = self.blur:GetComponent(CMUITweener.Name)
    --一键穿戴按钮
    self.changeObj = self.instance:FindWidget("change_btn")
    self.cmBtnChange = self.changeObj:GetComponent(CMUIButton.Name) 
    
    --武具按钮
    self.wujuObj = self.instance:FindWidget("wuju_bg")
    self.cmBtnWuju = self.wujuObj:GetComponent(CMBoxCollider.Name)
    --护甲按钮
    self.hujiaObj = self.instance:FindWidget("hujia_bg")
    self.cmBtnHujia = self.hujiaObj:GetComponent(CMBoxCollider.Name)
    --加号
    self.plus01Obj = self.instance:FindWidget("plus/plus01")
    self.cmColorTweenPlus01 = self.plus01Obj:GetComponent(CMUITweener.Name)
    --加号
    self.plus02Obj = self.instance:FindWidget("plus/plus02")
    self.cmColorTweenPlus02 = self.plus02Obj:GetComponent(CMUITweener.Name)
    --一键穿戴边框
    self.yijianOutsideObj = self.instance:FindWidget("change_btn/outside_light")
    self.cmAlphaTweenYijian = self.yijianOutsideObj:GetComponent(CMUITweener.Name)
    --ID2
	self:SetLabel("property_active/txt",SData_Id2String.Get(5245))
	self:SetLabel("property_inactive/txt",SData_Id2String.Get(5245))
	self:SetLabel("skill_active/txt",SData_Id2String.Get(5246))
	self:SetLabel("skill_inactive/txt",SData_Id2String.Get(5246))
	self:SetLabel("soldier_active/txt",SData_Id2String.Get(5015))
	self:SetLabel("soldier_inactive/txt",SData_Id2String.Get(5015))
	self:SetLabel("change_btn/Label",SData_Id2String.Get(5247))
	self:SetLabel("title_bg/txt",SData_Id2String.Get(5244))

	self:BindUIEvent("btn_back",UIEventType.Click,"OnBackClick",1)
	self:BindUIEvent("btn_lastpage",UIEventType.Click,"RunPage",0)
	self:BindUIEvent("btn_nextpage",UIEventType.Click,"RunPage",1)
    self:BindUIEvent("gold_buy",UIEventType.Click,"OnGold")
	self:BindUIEvent("property_inactive",UIEventType.Click,"ShowPagebyTabId",zhuangbei.ShuXing)
	self:BindUIEvent("liezhuan_btn",UIEventType.Click,"ShowPagebyTabId",zhuangbei.Liezhuan)
	self:BindUIEvent("skill_inactive",UIEventType.Click,"ShowPagebyTabId",zhuangbei.JiNeng)
	self:BindUIEvent("soldier_inactive",UIEventType.Click,"ShowPagebyTabId",zhuangbei.ShiBing)
	self:BindUIEvent("wuju_bg",UIEventType.Click,"ShowPagebyTabId",zhuangbei.WuJu)
	self:BindUIEvent("hujia_bg",UIEventType.Click,"ShowPagebyTabId",zhuangbei.HuJia)
    self:BindUIEvent("change_btn",UIEventType.Click,"ShowPagebyTabId",zhuangbei.YiJian)
    self:BindUIEvent("e_btn&bg_panel/blur",UIEventType.Click,"OnBlur") 

  
    self.bodyWuju = self:FindWidget("e_btn&bg_panel/wuju_bg");
    self.bodyHujia = self:FindWidget("e_btn&bg_panel/hujia_bg");
    self.backpackWuju = self:FindWidget("wuju_panel/wuju_grid");
    self.backpackHujia =  self:FindWidget("hujia_panel/hujia_grid");

    self.wuju_panel = self.instance:FindWidget("wuju_panel")
    self.cmWuJuScrollView = self.wuju_panel:GetComponent(CMUIScrollView.Name)
    self.hujia_panel = self.instance:FindWidget("hujia_panel")
    self.cmHuJiaScrollView = self.hujia_panel:GetComponent(CMUIScrollView.Name)


    self.DragEquipMB = self.backpackWuju:FindChild("dragItem") --拖拽物模板
    self.DragEquipMB:SetActive(false)--立即隐藏

    self.wuju_btn = self.backpackWuju:FindChild("wuju_btn")--背包中放武具的格子底版
    self.hujia_btn = self.backpackHujia:FindChild("hujia_btn")--背包中放防具的格子底板

    self.wuju_btn:SetActive(false)
    self.hujia_btn:SetActive(false)

    --创建拖拽控制器
    DragDropCtrl.new(self.bodyWuju:GetComponent(CMDragDropSurface.Name)):Init()
    DragDropCtrl.new(self.bodyHujia:GetComponent(CMDragDropSurface.Name)):Init()
    --洗练属性(信息板上)
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
    self.skill_name_obj = self.instance:FindWidget("right_class/skill_name")
    self.cmLabel_skill_name = self.skill_name_obj:GetComponent(CMUILabel.Name)
    self.shuxing01_obj = self.instance:FindWidget("right_class/shuxing01")
    self.cmLabel_shuxing01 = self.shuxing01_obj:GetComponent(CMUILabel.Name)
    self.shuxing02_obj = self.instance:FindWidget("right_class/shuxing02")
    self.cmLabel_shuxing02 = self.shuxing02_obj:GetComponent(CMUILabel.Name)
    self.jineng_obj = self.instance:FindWidget("right_class/jineng")
    self.cmLabel_jineng = self.jineng_obj:GetComponent(CMUILabel.Name)
end



--创建装备
function wnd_heroinfoClass:CreateEquip(dyID,staticID,heroID,ownerPanel)
    --info.gameObject 拖拽物游戏物体
    --info.sinfo 静态数据
    --info.heroID 所属英雄ID
    --info.ownerPanel:EquipOwnerPanel 装备当前所在位置
    --info.dyID 动态数据ID 
    local info = {}
    info.heroID = heroID
    info.dyID = dyID
    info.ownerPanel = ownerPanel--记录所属面板
    info.sinfo = sdata_EquipData:GetRow(staticID)--取得静态数据
    local tp = info.sinfo [sdata_EquipData.I_Type]--装备类型 
    
    --获取父对象
    local parent
    if ownerPanel == EquipOwnerPanel.Body then --一件穿戴好的装备
        parent = ifv(tp==EquipType.Wuju, self.bodyWuju,self.bodyHujia)
    else --背包中的装备 
        --创建放道具的格子底板

        if tp==EquipType.Wuju then
           parent = GameObject.InstantiateFromPreobj(self.wuju_btn,self.backpackWuju)
        else
           parent = GameObject.InstantiateFromPreobj(self.hujia_btn,self.backpackHujia)
        end
         
         parent:SetActive(true)
        --parent = ifv(tp==EquipType.Wuju, self.backpackWuju, self.backpackHujia) 
    end 

    --创建出拖拽物
    info.gameObject = GameObject.InstantiateFromPreobj(self.DragEquipMB,parent)
    info.gameObject:SetName("Equip_"..staticID)
    info.gameObject:SetActive(true)
    info.gameObject:SetLocalPosition(Vector3.Zero())
    
    --实现销毁接口
    info.Destroy = function(this)
        if this.ownerPanel==EquipOwnerPanel.Body then--已经穿戴的
            this.gameObject:Destroy()
        else --背包中的，连同格子一起销毁
            this.gameObject:GetParent():Destroy()
        end
    end

    --实现克隆接口
    info.Clone = function(this)
        return table.shallowCopy(this)
    end
     
    
    --设置正确的拖拽物tag
    local dragDropItem = info.gameObject:GetComponent(CMDragDropItem.Name)
    dragDropItem:SetUserData(dyID)--拖拽物上设置动态ID
     
    if tp==EquipType.Wuju then --武器
        dragDropItem:SetTags({"wuju"})
    else
        dragDropItem:SetTags({"hujia"})
    end 

    
    local dragScrollView = info.gameObject:GetComponent(CMUIDragScrollView.Name)

    --设置拖拽物所属表面
    if ownerPanel == EquipOwnerPanel.Body then --一件穿戴好的装备
        if tp==EquipType.Wuju then
            dragDropItem:SetOwnerSurface(self.bodyWuju)
        else
            dragDropItem:SetOwnerSurface(self.bodyHujia)
        end
        dragScrollView:SetScrollView(nil)--设置所属滚动视图 
    else --背包中的
        --设置所属滚动视图 
        if tp==EquipType.Wuju then
            dragScrollView:SetScrollView(  self.backpackWuju:GetParent():GetComponent( CMUIScrollView.Name ) )
        else
            dragScrollView:SetScrollView(  self.backpackHujia:GetParent():GetComponent( CMUIScrollView.Name ) )
        end  
    end


    
  
    --self:OnEquipOwnerChanged(info)
    return info--返回创建好的装备
end


--某装备所属面板发生变化
function  wnd_heroinfoClass:OnEquipOwnerChanged(info)
    info.gameObject:SetActive(true)
    local heroNameObj = info.gameObject:FindChild("name_txt")
    local lvObj = info.gameObject:FindChild("lv_txt")
    local dragDropItem = info.gameObject:GetComponent(CMDragDropItem.Name)
   
    local cmevt = CMUIEvent.Go(info.gameObject,UIEventType.Click)
    --设置装备外观
    local sprite = info.gameObject:FindChild("wuju_img") 
	local cmIcon = sprite:GetComponent(CMUISprite.Name)
	cmIcon:SetSpriteName(info.sinfo[sdata_EquipData.I_Icon])
    --设置洗练底纹
    local cmSprite = info.gameObject:GetComponent(CMUISprite.Name)
    local attr = self:GetXilianNum(info.dyID)
    local DewenName = ""
    if attr == 1 then--洗练属性1
        DewenName = info.sinfo[sdata_EquipData.I_XilianDiwen1]
    elseif attr == 2 then --洗练属性2
        DewenName = info.sinfo[sdata_EquipData.I_XilianDiwen2]
    elseif attr == 3 then --洗练属性3
        DewenName = info.sinfo[sdata_EquipData.I_XilianDiwen3]
    else--未洗练底纹
        DewenName = info.sinfo[sdata_EquipData.I_WeixilianDewen]
    end
    cmSprite:SetSpriteName(DewenName)

     --穿戴等级
    local RequireLv = info.sinfo[sdata_EquipData.I_RequireLv]
    local plyLv = Player:GetNumberAttr(PlayerAttrNames.Level)
    local lvObj = info.gameObject:FindChild("lv_txt")
    local cmLv = lvObj:GetComponent(CMUILabel.Name)
    cmLv:SetValue(string.sformat(SData_Id2String.Get(5075),info.sinfo[sdata_EquipData.I_RequireLv])) 
    --等级高设置成红色 
    if plyLv < RequireLv then
        cmLv:SetColor(Color.red)
    else
        cmLv:SetColor(Color.white)
    end
    if info.ownerPanel==EquipOwnerPanel.Body then  
        --允许各个方向拖出        
        dragDropItem:SetRestriction(DragDropRestriction.None) 
        --取消拖拽时，不用克隆
        dragDropItem:SetCloneOnDrag(false) 
        --绑定点击事件
        cmevt:Listener(info.gameObject,UIEventType.Click,self,"OnBodyEquipClickd",info)--info.sinfo[sdata_EquipData.I_Type])
        --将克隆过来的光圈灭掉
        local frame = info.gameObject:FindChild("wuju_frame")
        frame:SetActive(false)
        --将该物体上的所有动画设置启用
        local obj = info.gameObject
        local p = obj:GetComponents(UIPlayTween.Name)
        for i = 1,#p do
            p[i]:SetEnable(true)
        end

        --隐藏所属英雄名
        heroNameObj:SetActive(false)
        --隐藏等级
        lvObj:SetActive(false)
        dragDropItem:SetEnable(true) --已穿戴的必然允许拖拽
    else 
        --仅允许水平拖出,垂直方向拖留给滚动视图用
        dragDropItem:SetRestriction(DragDropRestriction.Horizontal) 
        --取消拖拽时，克隆
        dragDropItem:SetCloneOnDrag(true) 
        --绑定点击事件
        cmevt:Listener(info.gameObject,UIEventType.Click,self,"OnBackpackEquipClickd",info)
        
        --将该物体的所有动画禁用
        local obj = info.gameObject
        local p = obj:GetComponents(UIPlayTween.Name)
        for i = 1,#p do
            p[i]:SetEnable(false)
        end  
        --显示等级
        lvObj:SetActive(true)
        --判定需求等级
        local RequireLv = info.sinfo[sdata_EquipData.I_RequireLv]
        local plyLv = Player:GetNumberAttr(PlayerAttrNames.Level)      
        --显示所属英雄名
        if info.heroID~=nil and info.heroID>0 then
            heroNameObj:SetActive(true)
            local cmNameLabel = heroNameObj:GetComponent(CMUILabel.Name)                     
            cmNameLabel:SetValue(SData_Hero.GetHero(info.heroID):Name())
        else
            heroNameObj:SetActive(false)
        end     
    end    
end

function wnd_heroinfoClass:OnBackpackEquipClickd(_,info)
    
    local equip = self:GetBackpackEquipByID(info.dyID) 
    local tp = equip.sinfo [sdata_EquipData.I_Type]--装备类型 
    --刷新属性显示
    if tp == EquipType.Wuju then
        self:ShowWuJuShuXing(nil,info.dyID)       
    else
        self:ShowHuJiaShuXing(nil,info.dyID)
    end
end

function wnd_heroinfoClass:OnBodyEquipClickd(_,info)    
    local equip = self:GetBodyEquipByID(info.dyID) 
    local tp = equip.sinfo[sdata_EquipData.I_Type]
    if tp == EquipType.Wuju then
        self:ShowWujuInfo(info.dyID)--显示武具属性
        self:PlayWujuFrame()--设置光圈

    elseif tp == EquipType.Hujia then
        self:ShowHujiaInfo(info.dyID)--显示护甲属性
        self:PlayHujiaFrame()--设置光圈
    end     
end

--设置wuju_frame光圈
function wnd_heroinfoClass:PlayWujuFrame()
    print("武具亮")
    self:SetWidgetActive("bg_frame",true)    
    local wuju_frame = self:FindWidget("bg_frame")
    local v3pos = self.wujuObj:GetLocalPosition()
    wuju_frame:SetLocalPosition(v3pos)
    local frameObj = wuju_frame:GetComponent(CMUITweener.Name)
    frameObj:PlayForward()
end
--设置hujia_frame光圈
function wnd_heroinfoClass:PlayHujiaFrame()
    print("护甲亮")
    self:SetWidgetActive("bg_frame",true)    
    local hujia_frame = self:FindWidget("bg_frame")
    local v3pos = self.hujiaObj:GetLocalPosition()
    hujia_frame:SetLocalPosition(v3pos)
    local frameObj = hujia_frame:GetComponent(CMUITweener.Name)
    frameObj:PlayForward()
end 
--根据动态ID获取背包中的装备
function wnd_heroinfoClass:GetBackpackEquipByID(dyID)
    if self.backpackHujiaEquips~=nil then
        local re = self.backpackHujiaEquips[dyID]
        if re~=nil then return re end
    end
    if self.backpackWujuEquips==nil then return nil end
    return  self.backpackWujuEquips[dyID] 
end

--根据动态ID获取已穿戴的装备
function wnd_heroinfoClass:GetBodyEquipByID(dyID)
     for _,equipInfo in pairs (self.BodyEquips) do
            if equipInfo.dyID == dyID then return equipInfo end
     end
     return nil
end

function wnd_heroinfoClass:OnShowDone()
    self.isCreateHujiaAgain = true
    self.isCreateWujuAgain = true
    self.isShuxinWuju = true
    self.isShuxinHujia = true
	self:SetLabel("title_bg/txt",SData_Id2String.Get(5244))
	self:InitEquip()--初始化装备显示
    self:callbackFunc()
    if not self.bIslistenmoney then
	    OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Gold,self,self.callbackFunc)
	    OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Copper,self,self.callbackFunc)
	    self.bIslistenmoney = true
    end
    self:OnHeroinfoClick(self.firstID)	
    self:SetWidgetActive("shuxing_widget/shuxing1_duibi",false)
    self:SetWidgetActive("shuxing_widget/shuxing2_duibi",false)
    self:SetWidgetActive("shuxing_bg/shuxing_widget",false)
    self:InitLabel()
end 


function wnd_heroinfoClass:InitLabel()
    --静态ID2
    self:SetLabel("left_class/jichu",SData_Id2String.Get(5077))
    self:SetLabel("right_class/xilian",SData_Id2String.Get(5079))
    self:SetLabel("shuxing_widget/jichu",SData_Id2String.Get(5077))
    self:SetLabel("shuxing_widget/xilian",SData_Id2String.Get(5079))
    --按键ID2
    self:SetLabel("e_shuxing_bg/gengti_btn/txt",SData_Id2String.Get(5262))
    self:SetLabel("e_shuxing_bg/xilian_btn/txt",SData_Id2String.Get(5059))
--    self:SetLabel("define_btn/txt",SData_Id2String.Get(5089))
--    self:SetLabel("cancel_btn/txt",SData_Id2String.Get(5058))
    self:SetLabel("shuxing_widget/xilian_btn/txt",SData_Id2String.Get(5059))
    self:SetLabel("shuxing_widget/chuandai_btn/txt",SData_Id2String.Get(5261))
end
--监听金币和铜币数量变化
function wnd_heroinfoClass:callbackFunc()
	if wnd_heroinfo.isVisible == false then 
        return 
    end 
	self:SetLabel ("tb_bg/tb_num",Player:GetNumberAttr(PlayerAttrNames.Copper))
	self:SetLabel ("gold_bg/gold_num",Player:GetNumberAttr(PlayerAttrNames.Gold))
end




--初始化装备图标
function wnd_heroinfoClass:InitEquip() 
    if self.firstID == nil then
        return
    end 
    --销毁身上穿的装备
    if self.BodyEquips~=nil then
        for _,equipInfo in pairs (self.BodyEquips) do
            equipInfo:Destroy()
        end
    end 
    self.BodyEquips = {}--身上穿的装备
     
	local PlayerHeroInfo = Player:GetHeros()
    local equips = Player:GetEquips()
    local equipsIndexByID = {} 

    local eachFunc = function (eq) 
        equipsIndexByID[eq:GetValue(EquipAttrNames.ID)]  = eq
	end
	equips:ForeachEquips(eachFunc)

	for i = 1,#PlayerHeroInfo do
		if tonumber(PlayerHeroInfo[i]:GetAttr(HeroAttrNames.DataID)) == self.firstID then
			if PlayerHeroInfo[i]:GetAttr(HeroAttrNames.WuID) ~= "" then
                local wuID = PlayerHeroInfo[i]:GetAttr(HeroAttrNames.WuID)
                self.BodyEquips[EquipType.Wuju] = self:CreateEquip(
                wuID,
                tonumber(equipsIndexByID[wuID]:GetValue(EquipAttrNames.DataID)),
                tonumber(equipsIndexByID[wuID]:GetValue(EquipAttrNames.HeroID)),
                EquipOwnerPanel.Body
                )
                self:OnEquipOwnerChanged(self.BodyEquips[EquipType.Wuju])
                if self.isShuxinWuju == false then
                    self.backpackWujuEquips[wuID].heroID = self.firstID
                    self:OnEquipOwnerChanged(self.backpackWujuEquips[wuID])             
                end
                

			end

			if PlayerHeroInfo[i]:GetAttr(HeroAttrNames.FangID) ~= ""  then
                local fangID = PlayerHeroInfo[i]:GetAttr(HeroAttrNames.FangID)
                self.BodyEquips[EquipType.Hujia] = self:CreateEquip(
                fangID,
                tonumber(equipsIndexByID[fangID]:GetValue(EquipAttrNames.DataID)),
                tonumber(equipsIndexByID[fangID]:GetValue(EquipAttrNames.HeroID)),
                EquipOwnerPanel.Body
                )
                self:OnEquipOwnerChanged(self.BodyEquips[EquipType.Hujia])
                if self.isShuxinHujia == false then
                    self.backpackHujiaEquips[fangID].heroID = self.firstID
                    self:OnEquipOwnerChanged(self.backpackHujiaEquips[fangID])
                end
                
			end
		end
	end	
    --读本hero是死是活
    self.IsHeroDied =  self:GetHeroState(self.firstID)--true为死了
    
    self:PlayKeChuanDaiLight()
     
end
--当有可穿戴的装备时，显示亮框
function wnd_heroinfoClass:PlayKeChuanDaiLight()
    local yijian_flag = false
    --特效
    self.HasWujuEquip = false
    self.HasHujiaEquip = false
    local ZGLV = tonumber(Player:GetNumberAttr(PlayerAttrNames.Level))--获取主公等级
    local list = Player:GetEquips()
	local eachFunc = function (syncObj)
        local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
        local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
        local lv = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,DataID))
        if EquipType.Wuju == tonumber(syncObj:GetValue(EquipAttrNames.EType)) then           
            if ZGLV >= lv and HeroID == 0 then
                self.HasWujuEquip = true
            end
        else
            if ZGLV >= lv and HeroID == 0 then
                self.HasHujiaEquip = true
            end
        end
	end
	list:ForeachEquips(eachFunc)
    self:SetWidgetActive("plus01_fx",false)
    self:SetWidgetActive("plus02_fx",false)
    if self.BodyEquips[EquipType.Wuju] == nil and self.HasWujuEquip then
        --self:SetWidgetActive("plus01_fx",true)
        self.cmColorTweenPlus01:ResetToBeginning()
        self.cmColorTweenPlus01:PlayForward()
        yijian_flag = true

    end
    if self.BodyEquips[EquipType.Hujia] == nil and self.HasHujiaEquip then
        --self:SetWidgetActive("plus02_fx",true)
        self.cmColorTweenPlus02:ResetToBeginning()
        self.cmColorTweenPlus02:PlayForward()
        yijian_flag = true
    end
    --显示一键穿戴外面的光圈
    if yijian_flag then
        self:SetWidgetActive("change_btn/outside_light",true)
        self.cmAlphaTweenYijian:ResetToBeginning()
--        self.cmColorTweenPlus01:ResetToBeginning()
--        self.cmColorTweenPlus02:ResetToBeginning()
        self.cmAlphaTweenYijian:PlayForward()
--        self.cmColorTweenPlus01:PlayForward() 
--        self.cmColorTweenPlus02:PlayForward()
    else
        self:SetWidgetActive("change_btn/outside_light",false)
--        self.cmAlphaTweenYijian:ResetToBeginning()
--        self.cmAlphaTweenYijian:PlayReverse()
    end

end

--获取已经穿戴上的装备
function wnd_heroinfoClass:GetBodyEquip(equipType)
    return self.BodyEquips[equipType]
end

--设置已穿戴上的装备
function wnd_heroinfoClass:SetBodyEquip(equipType,equipInfo)
    self.BodyEquips[equipType] = equipInfo
end



--根据装备ID获取装备静态ID

function wnd_heroinfoClass:ID_DataID(ID)
    local DataID = 0
    local list = Player:GetEquips()
	local eachFunc = function (syncObj)
        if ID == syncObj:GetValue(EquipAttrNames.ID) then
            DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
        end
	end
	list:ForeachEquips(eachFunc)
    return 	DataID
end
--得到武将属性
function wnd_heroinfoClass:GetHeroAttr() 
	local EquipList = {}
	local wujuID = 0
	local fangjuID = 0
	local wujuhave = false
	local fangjuhave = false
	for i = 1,#self.heroList do
		if tonumber(self.heroList[i]:GetAttr(HeroAttrNames.DataID)) == self.firstID then
			self:SetLabel("zhandouli_bg/txt", math.ceil( self.heroList[i]:GetAttr(HeroAttrNames.ZDL)/100))
			wujuID = self.heroList[i]:GetAttr(HeroAttrNames.WuID)
			fangjuID = self.heroList[i]:GetAttr(HeroAttrNames.FangID)
		end
	end
	local wuqi = Equip.new()--创建武器实例
	local fangju = Equip.new()--创建防具实例

	local a = Player:GetEquips()
	local eachFunc = function (syncObj)
		if syncObj:GetValue(EquipAttrNames.ID) == wujuID then
			wujuhave = true
			local num = syncObj:GetValue(EquipAttrNames.CurrSkill)
			wuqi:SetStaticID(syncObj:GetValue(EquipAttrNames.DataID))--设置装备数据
			wuqi:SetXilianST(num)--(self:returntable(num))--设置装备洗练状态	
		end
		if syncObj:GetValue(EquipAttrNames.ID) == fangjuID then
			fangjuhave = true
			local num = syncObj:GetValue(EquipAttrNames.CurrSkill)
			fangju:SetStaticID(syncObj:GetValue(EquipAttrNames.DataID))--设置装备数据ID
			fangju:SetXilianST(num)--(self:returntable(num))--设置装备洗练状态
		end
	end
	a:ForeachEquips(eachFunc)
	if fangjuhave  and wujuhave then
		return wuqi,fangju
	elseif not fangjuhave  and wujuhave then
		return wuqi
	elseif not wujuhave  and fangjuhave then
		return fangju
	end
end 

function wnd_heroinfoClass:OnBackClick(obj,Type)
    self.cmBtnChange:SetIsEnabled(true) 
	if Type == 1 then
		if self.NUMMM == 2 then
			self:Hide()
		else
			EventHandles.OnWndExit:Call(WND.Heroinfo)
		end
		
		self.currshowye = 1
	elseif Type == 2 then
		self:SetWidgetActive("skillinfo_panel/skillinfo_widget",false)
	end
end 

function wnd_heroinfoClass:OnHeroinfoClick(id)
	self.firstID = id
	self:SetLabel("img_widget/hero_level",string.sformat(SData_Id2String.Get(5075),Player:GetNumberAttr(PlayerAttrNames.Level)))
	self.MaHeroInfoList = SData_Hero.GetHero(self.firstID)
	self:SetLabel("img_widget/hero_name",self.MaHeroInfoList:Name())--"蔡琰")
	local Banshen = self.instance:FindWidget( "hero_img" )
	local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
	HeroBanshen:SetIcon(self.firstID,false)


	local page = 0
	local long = 0
	self.HeroXJ = 0
	self.SoldierXJ = 0
	for k,v in pairs (self.heroList) do
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) )== self.firstID then
			page = k
			self.HeroXJ = self.heroList[k]:GetAttr(HeroAttrNames.XJ)
			self:SetLabel("zhandouli_bg/txt", math.ceil( self.heroList[k]:GetAttr(HeroAttrNames.ZDL)/100))
			self.SoldierXJ = self.heroList[k]:GetAttr(HeroAttrNames.SXJ)
		end
		long = long + 1 
	end
	self:showStar() 
	--武将所属阵营图标
	local typeicon = self.instance:FindWidget("hero_img/hero_type" )
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..self.MaHeroInfoList:TypeIcon())

	self:SetWidgetActive("btn_nextpage",true)
	self:SetWidgetActive("btn_lastpage",true)
	if page == 1 then
		self:SetWidgetActive("btn_lastpage",false)	
	end
	if page == long then
		self:SetWidgetActive("btn_nextpage",false)
	end
--	--每次显示
	local str = ""
	if self.currshowye == 1 then
		str = "property_inactive"
	elseif self.currshowye == 2 then
		str = "skill_inactive"
	elseif self.currshowye == 3 then
		str = "soldier_inactive"
	else
		str = "property_inactive"
	end
	local tiaozhuanCZ = self.instance:FindWidget(str)
	local cmAttributePage = tiaozhuanCZ:GetComponent(CMUIAttributePage.Name)
	cmAttributePage:SetActivity() 
	self:ShowPagebyTabId(gameObj,self.currshowye)

end
--刷新战斗力
function wnd_heroinfoClass:refresZDL() 
	for k,v in pairs (self.heroList) do
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) )== self.firstID then
			self:SetLabel("zhandouli_bg/txt", math.ceil( self.heroList[k]:GetAttr(HeroAttrNames.ZDL)/100))
		end
	end
end
function wnd_heroinfoClass:showStar() 
	
	
	for k = 1 ,7 do
		local obj = "StarGrid1/star"..k
		self:SetWidgetActive(obj.."/on",false)
		if k == tonumber(self.HeroXJ) or k < tonumber(self.HeroXJ) then
			self:SetWidgetActive(obj.."/on",true)
		end
	end
	local PlayerJH = Player:GetJianghunNum(self.firstID)
	self:SetWidgetActive("hero_progress_num",true)
	self:SetWidgetActive("btn_earnhero",true)
	--将魂收集
	local pro = self.instance:FindWidget( "hero_progress_bg" )
	local pro_pro = pro:GetComponent(CMUIProgressBar.Name)
	if  tonumber(self.HeroXJ) > 6 then--满星
		--self:SetWidgetActive("btn_earnhero",false)
		self:SetLabel("btn_earnhero/txt",SData_Id2String.Get(5310))
		self:BindUIEvent("btn_earnhero",UIEventType.Click,"showMan")
		self:SetWidgetActive("hero_progress_num",false)
		pro_pro:SetValue(1)	--玩家拥有武将的将魂数
	else
		local str = 0
		if tonumber(PlayerJH) < tonumber(sdata_keyvalue:GetFieldV((self.HeroXJ).."xingCost",1)) then
			str = 5193
			self:BindUIEvent("btn_earnhero",UIEventType.Click,"showHuoqu",1)
		else
			str = 5310
			self:BindUIEvent("btn_earnhero",UIEventType.Click,"sendSXmange")
		end
		self:SetLabel("btn_earnhero/txt",SData_Id2String.Get(str))
		pro_pro:SetValue(PlayerJH/sdata_keyvalue:GetFieldV((self.HeroXJ).."xingCost",1))	--玩家拥有武将的将魂数
		self:SetLabel("hero_progress_num",string.sformat(SData_Id2String.Get(5005),PlayerJH,sdata_keyvalue:GetFieldV(self.HeroXJ.."xingCost",1)))
	end
end
function wnd_heroinfoClass:showMan() 
	Poptip.PopMsg("武将星级已满",Color.blue)
end
--function wnd_heroinfoClass:WJSXnetwork() 
--	--判断拥有的武将碎片和通用碎片
----	local PlayerJH = tonumber(Player:GetJianghunNum(self.firstID))--玩家拥有的碎片
----	local owerSuipian = sdata_keyvalue:GetFieldV((self.HeroXJ).."xingCost",1)--升星需要的碎片
----	local a = owerSuipian - PlayerJH
----	local owerTY = Player:GetNumberAttr(PlayerAttrNames.Tysp)

----	if PlayerJH < owerSuipian then
----		local needTY = self.MaHeroInfoList:TongYongSuiPian()*a--需要的通用碎片数
----		if owerTY < needTY then
----			Poptip.PopMsg("资源不足~",Color.red)
----		else
----			local str = "当前"..self.MaHeroInfoList:Name().."碎片不足，可用"..needTY.."个通用武将碎片兑换"..a.."个"..self.MaHeroInfoList:Name().."碎片。主公当前拥有"..owerTY.."个通用碎片，是否兑换？"
----			MsgBox.Show(str,"否","是",self,self.OnBoxClose)	
----		end		
----	else
--	self:sendSXmange()
----	end
--end 
--function wnd_heroinfoClass:OnBoxClose(result)	
--	if result == 1 then
--		return nil
--	elseif result == 2 then
--		self:sendSXmange()	
--	end
--end
--升星
function wnd_heroinfoClass:sendSXmange()
		local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","hsx")  
		jsonNM:Add("hid",self.firstID)  
		local loader = GameConn:CreateLoader(jsonNM,0) 
		HttpLoaderEX.WaitRecall(loader,self,self.bIsShengXing) 
end
function wnd_heroinfoClass:bIsShengXing(jsonDoc) 
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		--type==1代表升星
		wnd_success:showType(1) 
		wnd_success:Show() 
		self.HeroXJ = self.HeroXJ + 1 
		self:showStar()
		self:ShowShuXing()
		if self.BisJN then
			self:ShowJiNing()
		end
        wnd_CardHouse:SetCardStar(self.firstID)
	elseif num == 1 then
		Poptip.PopMsg("资源不足~",Color.red)
	elseif num == 2 then
		Poptip.PopMsg("英雄等级不足~",Color.red)
	else
		Poptip.PopMsg("各种原因导致失败~",Color.red)
	end
end
function wnd_heroinfoClass:ShowPagebyTabId(_,num)
	self.BisJN = false
	if num == 1 then
		self.currshowye = 1
		self:ShowShuXing()
	elseif num == 2 then
		self.currshowye = 2
		self.BisJN = true
		self:ShowJiNing()
	elseif num == 3 then
		self.currshowye = 3
		self:ShowShiBing()
    elseif num == 5 then
		self:CreateWujuUI()
	elseif num == 4 then
		--wnd_chongzhi:Show()临时
--	elseif num == 5 then
--		self:ShowShiBing()
   
    elseif num == 6 then
        self:CreateHujiaUI()
--    elseif num == 7 then
--		self:ShowWuJuShuxing()
    elseif num == 8 then
        self:OnYiJianChange()
	elseif num == 9 then
		wnd_liezhuan:SetHeroId(self.firstID)
		wnd_liezhuan:Show()
	end
end  
---------------------------属性页---------------------------
function wnd_heroinfoClass:ShowShuXing()
	self:BuildStar("stargrid2/Sprite","stargrid2",1)
--	self:BindUIEvent("heroinfo_shuoming",UIEventType.Click,"ShowHeroInfo")

	--武将所属阵营图标
	local typeicon = self.instance:FindWidget( "property_widget/type_icon" )
	local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..self.MaHeroInfoList:TypeIcon())

	self:SetLabel("info_bg/property_widget/hero_name",self.MaHeroInfoList:Name())--武将名字
	self:SetLabel("info_bg/property_widget/hero_lv",string.sformat(SData_Id2String.Get(5075),Player:GetNumberAttr(PlayerAttrNames.Level)))--等级
	local baseNu,baseHP,baseTili,baseWuli = 0
	local SkillsLevel = {}
	for k,v in pairs (self.heroList) do
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
			baseHP = self.heroList[k]:GetHP()--气血
			baseWuli = self.heroList[k]:GetWuli()--武力
			baseTili = self.heroList[k]:GetTili()--体力
			baseNu = self.heroList[k]:GetNu()--怒气
			SkillsLevel = self.heroList[k]:GetSkillLevels()
		end
	end	
	local  bhp,bwuli,btili,bnu,bspeed = nil--基础技能被动属性
	local  qhp,qwuli,qtili,qnu = nil--装备属性
	if self:GetHeroAttr()~= nil then
		qhp,qwuli,qtili,qnu = SData_Hero.CalculationEquips(self:GetHeroAttr())
	end
	bhp,bwuli,btili,bnu,bspeed = SData_Hero.CalculateHeroBeidongSkillAttr(self.MaHeroInfoList,SkillsLevel) 
	local hp,wuli,tili,nu = ""
	if qhp ~= nil and  qhp:GetAddV() ~= 0 then
		hp = baseHP + bhp:GetAddV().."   [99ff00]+"..qhp:GetAddV()
	else
		hp = baseHP + bhp:GetAddV()
	end
	if qwuli ~= nil and qwuli:GetAddV() ~= 0 then
		wuli = baseWuli + bwuli:GetAddV().."   [99ff00]+"..qwuli:GetAddV()
	else
		wuli = baseWuli + bwuli:GetAddV()
	end
	if qtili ~= nil and qtili:GetAddV() ~= 0  then
		tili = baseTili + btili:GetAddV().."   [99ff00]+"..qtili:GetAddV()
	else
		tili = baseTili + btili:GetAddV()
	end
	if qnu ~= nil and qnu:GetAddV() ~= 0 then
		nu = baseNu + bnu:GetAddV().."   [99ff00]+"..qnu:GetAddV()
	else
		nu = baseNu + bnu:GetAddV()
	end
	self:SetLabel("info_bg/property_widget/wuli_label",string.sformat(SData_Id2String.Get(5038),wuli))--武力
	self:SetLabel("info_bg/property_widget/qixue_label",string.sformat(SData_Id2String.Get(5036),hp))--气血
	self:SetLabel("info_bg/property_widget/tili_label",string.sformat(SData_Id2String.Get(5037),tili))--体力
	self:SetLabel("info_bg/property_widget/nuqi_label",string.sformat(SData_Id2String.Get(5039),nu))--怒气
	self:SetLabel("info_bg/property_widget/yidongli_label",string.sformat(SData_Id2String.Get(5040),self.MaHeroInfoList:Speed()+bspeed:GetAddV()))--移动力
	self:SetLabel("info_bg/property_widget/gongjijuli_label",string.sformat(SData_Id2String.Get(5041),self.MaHeroInfoList:AtkRange()))--攻击距离
	self:SetLabel("info_bg/property_widget/guojia_label",SData_Id2String.Get(self:HeroCountry(self.MaHeroInfoList:HeroZhenying())))--所属国家
	self:SetLabel("info_bg/property_widget/daibingshu_label",string.sformat(SData_Id2String.Get(5329),sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_ArmyNo ,Player:GetNumberAttr(PlayerAttrNames.Level))))--所属国家
	self:SetLabel("info_bg/property_widget/introduction_txt1",SData_Id2String.Get(5253))
	self:SetLabel("info_bg/property_widget/introduction_txt2",self.MaHeroInfoList:Special())--介绍
	self:SetLabel("info_bg/property_widget/zhili_label",string.sformat(SData_Id2String.Get(5391),self.MaHeroInfoList:CalculationZhili(Player:GetAttr(PlayerAttrNames.Level),self.HeroXJ)))--智力
	self:SetLabel("info_bg/property_widget/jingshen_label",string.sformat(SData_Id2String.Get(5392),self.MaHeroInfoList:CalculationJingshen(Player:GetAttr(PlayerAttrNames.Level),self.HeroXJ)))--精神力
end 
--function wnd_heroinfoClass:ShowHeroInfo()
--	self:SetLabel("heroinfo/title",SData_Id2String.Get(5254))	
--	local scene_packet = PacketManage.GetPacket("liezhuan")--取得列传资源包
--	if scene_packet:GetText("lz_"..self.firstID) ~= nil then
--		self:SetWidgetActive("heroinfo",true)
--		local cfgtext = scene_packet:GetText("lz_"..self.firstID)--取得列传配置
--		self:SetLabel("txt_panel/txt",cfgtext)
--	end

--	self:BindUIEvent("mask_btn",UIEventType.Click,"OnHelpBackClick")
--end
--function wnd_heroinfoClass:OnHelpBackClick()
--	self:SetWidgetActive("heroinfo",false)
--end
---------------------------技能页---------------------------
function wnd_heroinfoClass:ShowJiNing()
	self:SetLabel("skill_title_bg/txt",SData_Id2String.Get(5258))
	local m_Item = self.instance:FindWidget("skillgrid/skill_single")
	local m_Item1 = self.instance:FindWidget("skillgrid/skill_passive")
	self.skillTable = self.MaHeroInfoList:Skills()

	local newItem = nil
	if self.JNItem == false then
		for k = 2 ,#self.skillTable do
			if k%2 ~= 0 or k < 4 then
				newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("skillgrid"))
			else
				newItem = GameObject.InstantiateFromPreobj(m_Item1,self.instance:FindWidget("skillgrid"))
			end
			newItem:SetName("jiNeng"..k)
			newItem:SetActive(true)
			self.JNItem = true
		end
		local container = self.instance:FindWidget("skillgrid")
		local cmTable = container:GetComponent(CMUIGrid.Name)
		cmTable:Reposition()
	end
	for i = 2 ,#self.skillTable do
		self:SetWidgetActive("jiNeng"..i,false)
		if self.skillTable[i] > 0  then
			self:SetWidgetActive("jiNeng"..i,true)

			local Skills = SData_Skill.GetSkill(self.skillTable[i])
			self:SetLabel("jiNeng"..i.."/lock_msk/txt",string.sformat(SData_Id2String.Get(5255),i-1))
			local skillName = Skills:Name()
			self:SetLabel("jiNeng"..i.."/skill_bg/skill_name",skillName)

			local skillIcon = Skills:Icon()
			local sprite = self.instance:FindWidget("jiNeng"..i.."/skill_bg/skill_icon")
			local jnTB = sprite:GetComponent(CMUISprite.Name)
			jnTB:SetSpriteName( skillIcon)

			local level = 0
			for k,v in pairs (self.heroList) do
				if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
					level = self.heroList[k]:GetSkillLevelByIndex(i)
				end
			end	

			self:SetLabel("jiNeng"..i.."/skill_bg/skill_lv",string.sformat(SData_Id2String.Get(5075),level))
			self:SetLabel("jiNeng"..i.."/skill_bg/skill_txt",Skills:SkillNoteMin())
			local button = nil 
			if i%2 ~= 0 or i < 4  then
				self:SetWidgetActive("jiNeng"..i.."/btn_promote/jinengshengji",false)
				local JNjia = self.instance:FindWidget("jiNeng"..i.."/btn_promote")
				button = JNjia:GetComponent(CMUIButton.Name) 
				if tonumber(level) > 0 then
					if i == 2 then
						self:SetLabel("jiNeng"..i.."/skill_bg/cost_img/txt",sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_ShoudongSkillLvUp,tonumber(level)))
					else
						self:SetLabel("jiNeng"..i.."/skill_bg/cost_img/txt",sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_SkillLvUp,tonumber(level)))
					end
				end
			end

			--判断技能等级
			if level > 0 or (level == 0 and i == 2) then
				if i%2 ~= 0 or i < 4 then					
					button:SetIsEnabled(true)
					self:SetWidgetActive("jiNeng"..i.."/skill_bg/cost_img",true)
					self:BindUIEvent("jiNeng"..i.."/btn_promote",UIEventType.Click,"OnJiNengUp",i)
					self:BindUIEvent("jiNeng"..i.."/btn_promote",UIEventType.LongPress,"OnJiNUp",i)
					self:BindUIEvent("jiNeng"..i.."/btn_promote",UIEventType.Press,"OnP_Reduce")
				end
				self:SetWidgetActive("jiNeng"..i.."/lock_msk",false)
				self:SetWidgetActive("jiNeng"..i.."/skill_bg/skill_lv",true)

				self:BindUIEvent("jiNeng"..i,UIEventType.Press,"OnJiNengClick",i)
				

			else
				if i%2 ~= 0 or i < 4  then
					button:SetIsEnabled(false)
					self:SetWidgetActive("jiNeng"..i.."/skill_bg/cost_img",false)
				end
				self:SetWidgetActive("jiNeng"..i.."/lock_msk",true)
				self:SetWidgetActive("jiNeng"..i.."/skill_bg/skill_lv",false)
				
			end
		end
	end

end 
function wnd_heroinfoClass:OnP_Reduce(obj,flag)
    if flag == false then
        self.ReduceFlag = false--当鼠标抬起设置标志位为false
    end
end
function wnd_heroinfoClass:OnJiNUp(obj,i)	
	if isPress == false then return end
	StartCoroutine(self,self.OnLP_Reduce,i)--启动协程
	local a = 0


end 
--长按事件回调函数
function wnd_heroinfoClass:OnLP_Reduce(i)
    print("LP_Reduce")
	self.selectorMode = true
	local level = 0
	for k,v in pairs (self.heroList) do
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
			level = self.heroList[k]:GetSkillLevelByIndex(i)
		end
	end	
	local copper = tonumber(Player:GetNumberAttr(PlayerAttrNames.Copper))

	local money = 0
    self.ReduceFlag = true
	local b = 0
    while true do
        Yield(0.2)
		self:SetWidgetActive("jiNeng"..i.."/btn_promote/jinengshengji",false)
		if i == 2 then 
			money = sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_ShoudongSkillLvUp,tonumber(level+b))
		else
			money = sdata_KeyValueMath:GetV(sdata_KeyValueMath.I_SkillLvUp,tonumber(level+b))
		end
		if money <= copper then
			self:SetLabel("jiNeng"..i.."/skill_bg/skill_lv",string.sformat(SData_Id2String.Get(5075),level+b))
			b = b + 1 
			local c = self.instance:FindWidget("jiNeng"..i.."/btn_promote/jinengshengji")
			c :SetActive(true)
			copper = copper - money
			self:SetLabel ("tb_bg/tb_num",copper)
			self:SetLabel("jiNeng"..i.."/skill_bg/cost_img/txt",money)
			
		else
			break
		end
        if self.ReduceFlag == false then break end
	end
	self:OnJiNengUpN(obj,i,b)
end

--技能升级
function wnd_heroinfoClass:OnJiNengUp(obj,i)
	self.selectorMode = false
	self:OnJiNengUpN(obj,i)
end
function wnd_heroinfoClass:OnJiNengUpN(obj,i,Time)
	self:SetWidgetActive("jiNeng"..i.."/btn_promote/jinengshengji",false)
	if Time == nil then
		Time = 1
	end
	self.skillidx = i
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","upSk")  
    jsonNM:Add("hid",self.firstID) 
	jsonNM:Add("sk",self.skillTable[i]) 
	jsonNM:Add("cs",Time) 
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.bIsJN)
end
function wnd_heroinfoClass:bIsJN(jsonDoc) 
	local num = tonumber(jsonDoc:GetValue("r"))
	if self.selectorMode then
		if num == 0 then
			self:refresZDL() 
			self:ShowJiNing()
			self:SetWidgetActive("jiNeng"..self.skillidx.."/btn_promote/jinengshengji",true)
		else
			print("ffffffffffffffffffff----",num)
			Poptip.PopMsg("技能升级失败~",Color.red)
		end
	else
		if num == 0 then
			self:ShowJiNing()
			self:refresZDL() 
			self:SetWidgetActive("jiNeng"..self.skillidx.."/btn_promote/jinengshengji",true)
			Poptip.PopMsg("升级技能成功~",Color.red)
		elseif num == 1 then
			Poptip.PopMsg("资源不足~",Color.red)
		elseif num == 2 then
			Poptip.PopMsg("等级不能超过英雄~",Color.red)
		else
			Poptip.PopMsg("各种原因导致失败~",Color.red)
		end
	end
end
---------------------------士兵页---------------------------
function wnd_heroinfoClass:ShowShiBing()
	self:SetLabel("soldier_title/txt",SData_Id2String.Get(5259))
	local Army = SData_Army.GetRow(self.MaHeroInfoList:Army())
	self:SetLabel("soldier_widget/lv_txt",string.sformat(SData_Id2String.Get(5075),Player:GetNumberAttr(PlayerAttrNames.Level)))--等级
	self:BindUIEvent("soldier_btn_instruction",UIEventType.Press,"OnsNoteClick",Army)
	local basehp,basewuli,basetili,basespeed = 0
	local SkillsLevel = {}
	for k,v in pairs (self.heroList) do
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
			basewuli = self.heroList[k]:GetArmyWuli()--武力
			basehp = self.heroList[k]:GetArmyHP()--气血
			basetili = self.heroList[k]:GetArmyTili()--体力
			self:SetLabel("soldier_widget/zhandouli_txt", math.ceil(self.heroList[k]:GetAttr(HeroAttrNames.aZDL)/100))--战斗力
			SkillsLevel = self.heroList[k]:GetSkillLevels()
		end
	end	
	local bhp,bwuli,btili,bspeed = nil--基础技能被动属性
	bhp,bwuli,btili,bspeed = SData_Hero.CalculateSoldiersBeidongSkillAttr(self.MaHeroInfoList,SkillsLevel)
	self:SetLabel("soldier_widget/wuli_txt",string.sformat(SData_Id2String.Get(5038),basewuli+ bwuli:GetAddV()))--武力
	self:SetLabel("soldier_widget/qixue_txt",string.sformat(SData_Id2String.Get(5036),basehp + bhp:GetAddV()))--气血
	self:SetLabel("soldier_widget/tili_txt",string.sformat(SData_Id2String.Get(5037),basetili + btili:GetAddV()))--体力
	self:SetLabel("soldier_widget/name_txt",Army:Name() )--名字
	local sprite = self.instance:FindWidget( "soldier_img" )
	local HeroBanshen = sprite:GetComponent(CMUISprite.Name)
	local ggg = self.MaHeroInfoList:Army()
	HeroBanshen:SetSpriteName( "sh"..Army:SoldierBanshen() )

	self:SetLabel("info_bg/soldier_widget/yidongli_txt",string.sformat(SData_Id2String.Get(5040),Army:Speed()+ bspeed:GetAddV()))--移动力
	self:SetLabel("info_bg/soldier_widget/gongjijuli_txt",string.sformat(SData_Id2String.Get(5041),Army:AtkRange()))--攻击距离
	self:SetLabel("soldier_widget/fendanshanghai_txt",string.sformat(SData_Id2String.Get(5377),math.floor(Army:DefProportion()*100).."%"))--分担伤害比例
	self:SetLabel("soldier_widget/zhili_txt",string.sformat(SData_Id2String.Get(5391),Army:CalculationZhili(Player:GetAttr(PlayerAttrNames.Level),self.SoldierXJ)))--智力
	self:SetLabel("soldier_widget/jingshen_txt",string.sformat(SData_Id2String.Get(5392),Army:CalculationJingshen(Player:GetAttr(PlayerAttrNames.Level),self.SoldierXJ)))--精神力
	self:SetLabel("soldier_widget/type_txt",string.sformat(SData_Id2String.Get(5383),self:returnBingzhong(Army:Type())))--兵种
	local SoldierType,Modulus = 0
	local len = Army:GetRestraintAttrLen()
	if(len ~= nil and len > 0)then
		for i =0, len-1 do
			SoldierType,Modulus = Army:GetRestraintAttrInfo(i)
			
		end
	end 
	if tonumber(SoldierType )  == 0 then
		self:SetWidgetActive("soldier_widget/kezhi_txt",false)
	else
		self:SetWidgetActive("soldier_widget/kezhi_txt",true)
		local numModulus = (Modulus*100).."%"
		self:SetLabel("soldier_widget/kezhi_txt",string.sformat(SData_Id2String.Get(5389),self:returnBingzhong(SoldierType),numModulus))--兵种
	end
	local pro = self.instance:FindWidget( "soldier_progress_bg" )
	local pro_pro = pro:GetComponent(CMUIProgressBar.Name)
	self:BuildStar("stargrid3/star","stargrid3",2)
	local SsuiPIAN = tonumber(Player:GetSoldierPieceNum(ggg))
	if  tonumber(self.SoldierXJ) < 7  then
		local str = 0
		if tonumber(SsuiPIAN) < tonumber(sdata_keyvalue:GetFieldV((self.SoldierXJ).."xingArmyCost",1)) then
			str = 5193
			self:BindUIEvent("soldier_staricon",UIEventType.Click,"showHuoqu",2)
		else
			str = 5310
			self:BindUIEvent("soldier_staricon",UIEventType.Click,"shibingSX")
		end
		self:SetLabel("soldier_staricon/txt",SData_Id2String.Get(str))
		self:SetWidgetActive("soldier_progress_num",true)
		self:SetWidgetActive("soldier_staricon",true)
		pro_pro:SetValue(SsuiPIAN/sdata_keyvalue:GetFieldV((self.SoldierXJ).."xingArmyCost",1))
		self:SetLabel("soldier_progress_num",string.sformat(SData_Id2String.Get(5005),SsuiPIAN,sdata_keyvalue:GetFieldV(self.SoldierXJ.."xingArmyCost",1)))
	else
		self:SetWidgetActive("soldier_progress_num",false)
		pro_pro:SetValue(1)
		self:SetWidgetActive("soldier_staricon",false)
	end
end 
function wnd_heroinfoClass:OnsNoteClick(obj,isPress,tab)
	if isPress == false then return end
	self:SetLabel("soldierinfo_bg/name",tab:Name())
	self:SetLabel("soldierinfo_bg/txt",tab:Note())

end
function wnd_heroinfoClass:returnBingzhong(num)
	local int = 5384
	local T = tonumber(num)
	if T == 2 then
		int = 5384
	elseif T == 3 then
		int = 5385
	elseif T == 4 then
		int = 5386
	elseif T == 5 then
		int = 5387
	elseif T == 6 then
		int = 5388
	end
	return SData_Id2String.Get(int)
end
---------------------------------------------武具装备页-------------------------------------------------------
--初始化动画效果
function wnd_heroinfoClass:OnBlur()
    self.wuju_flag = false--武具仓库为关闭状态
    self.hujia_flag = false--护甲仓库为关闭状态
    self.wujuinfo_flag = false--武具属性板为关闭状态
    self.hujiainfo_flag = false--护甲属性板为关闭状态
    self.CreateWuJuFlag = true--停止创建武具
    self.CreateHuJiaFlag = true--停止创建护甲
    self:SetWidgetActive("wuju_panel",false)
    self:SetWidgetActive("hujia_panel",false)
end
--武具

function wnd_heroinfoClass:CreateWujuUI()
    
    StartCoroutine(self,self.ShowWuJu,{})
end


--排序
local function SortFunc(item1, item2)
    local Judgement 
        
    if item1.IsEquip == item2.IsEquip then
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
        Judgement = item1.IsEquip
    end
      
    return Judgement
end


function wnd_heroinfoClass:ShowWuJu()
    local cmTable = self.backpackWuju:GetComponent(CMUIGrid.Name)
    --防止仓库一直刷新
    if self.isFromXilian == false then
        if self.wuju_flag == true then return end
        
    end
    self:SetWidgetActive("wuju_panel",false)
    self.isFromXilian = false
    --控制动画
    self.wuju_flag = true
    --若护甲仓库已弹出，则执行弹出再弹回的动画
    if self.hujia_flag == true then
        self.hujia_flag = false
        self.equipmentObj[2]:ResetToBeginning()
        self.equipmentObj[2]:PlayForward()
    end
    --护甲属性板子
    if self.hujiainfo_flag == true then
        self.hujiainfo_flag = false
    end
    self:SetWidgetActive("hujia_panel",false)
    self:SetLabel("equipment_page/equipment_bg/title_bg/txt",SData_Id2String.Get(5304))
    self:PlayWujuFrame()--武具光圈
    --Yield()  
    self:SetWidgetActive("wuju_panel",true)
    self.cmWuJuScrollView:ResetPosition()--初始化滑动条位置
    Yield()  
    if self.isCreateWujuAgain == false then
        self:SetWidgetActive("shuxing_bg/shuxing_widget",false)
        if self.backpackWujuObj ~= nil then
            self:ShowWuJuShuXing(_,self.backpackWujuObj[1].id)
            self:SetWidgetActive("shuxing_bg/shuxing_widget",true)
        end
        
        cmTable:Reposition()
        return 
    end
    Yield(0.4)
    local wuju_ID_list = {}
    local PlayerLv = tonumber(Player:GetNumberAttr(PlayerAttrNames.Level))--获取主公等级
    local a = Player:GetEquips()
    local eachFunc = function (syncObj)
        
        if tonumber(syncObj:GetValue(EquipAttrNames.EType)) == 1 then
	        local temp_info = {}--单个装备信息
            local id = syncObj:GetValue(EquipAttrNames.ID)
            local dataID = tonumber( syncObj:GetValue(EquipAttrNames.DataID) )
            local lv = sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,tonumber(dataID))
            local heroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            local curr_skill = syncObj:GetValue(EquipAttrNames.CurrSkill)
            local zdl = syncObj:GetValue(EquipAttrNames.eZDL)
            local skill_num = self:GetXilianNum(id)
            local isequip = ifv(PlayerLv >= lv, true, false)
            temp_info = {ID = id, DataID = dataID, LV = lv, HeroID = heroID, Curr_Skill = curr_skill, ZDL = zdl, SKILL_NUM = skill_num, IsEquip = isequip}
            table.insert(wuju_ID_list, temp_info)
        end
        
    end
    a:ForeachEquips(eachFunc)  
    table.sort(wuju_ID_list,SortFunc)
    
    
-------------------------------------------新代码---------------------------------------------
    for i = 1,#wuju_ID_list do
		-- 实例化装备
        if self.backpackWujuEquips[wuju_ID_list[i].ID] == nil then        
            local equip = wuju_ID_list[i]
            self.backpackWujuEquips[equip.ID] = self:CreateEquip(equip.ID,equip.DataID,equip.HeroID,EquipOwnerPanel.Backpack)
            local info = {}
            info.gameObject = self.backpackWujuEquips[equip.ID].gameObject
            info.id = self.backpackWujuEquips[equip.ID].dyID
		    table.insert(self.backpackWujuObj,info)              
        end	 
	end
--    if #self.backpackWujuObj > #wuju_ID_list then
--        local temp = #self.backpackWujuObj - #wuju_ID_list
--        for i = #self.backpackWujuObj,#self.backpackWujuObj - temp + 1,-1 do
--            self.backpackWujuObj[i].gameObject:GetParent():SetActive(false)
--        end

--    end
    if #wuju_ID_list <= 0 then
        self:SetWidgetActive("shuxing_bg/shuxing_widget",false)
    else
        --self:ShowWuJuShuXing(_,wuju_ID_list[1].ID)
        self:SetWidgetActive("shuxing_bg/shuxing_widget",true)
    end
    
	--设置武具的外观显示
    local flag = true
    local k = 1
	for i = 1,#wuju_ID_list do
        if self.isShuxinWuju == false then
            
            break
        end
        local dyID = wuju_ID_list[i].ID
        self.backpackWujuObj[i].id = dyID
        self.backpackWujuEquips[dyID].gameObject = self.backpackWujuObj[i].gameObject
        self.backpackWujuEquips[dyID].dyID = wuju_ID_list[i].ID
        self.backpackWujuEquips[dyID].heroID = wuju_ID_list[i].HeroID
        self.backpackWujuEquips[dyID].ownerPanel = EquipOwnerPanel.Backpack--记录所属面板
        self.backpackWujuEquips[dyID].sinfo = sdata_EquipData:GetRow(wuju_ID_list[i].DataID)--取得静态数据
        self.backpackWujuEquips[dyID].gameObject:SetName("Equip_"..wuju_ID_list[i].DataID)
        local dragDropItem = self.backpackWujuEquips[dyID].gameObject:GetComponent(CMDragDropItem.Name)
        dragDropItem:SetUserData(dyID)--拖拽物上设置动态ID
        self:OnEquipOwnerChanged(self.backpackWujuEquips[dyID])       
        local cmevt = CMUIEvent.Go(self.backpackWujuEquips[dyID].gameObject,UIEventType.Click)
        cmevt:Listener(self.backpackWujuEquips[dyID].gameObject,UIEventType.Click,self,"ShowWuJuShuXing",dyID)
        if flag then
            flag = false
            self:ShowWuJuShuXing(_,wuju_ID_list[1].ID)
        end
        k = k + 1
        if k == 26 then
            k = 1
            cmTable:Reposition()
            Yield(0.1)
        end                	
    end
    self.isShuxinWuju = false
---------------------------------------------------------------------------------------------- 
    

     
    
	cmTable:Reposition()
    self.isCreateWujuAgain = false
end
--护甲

function wnd_heroinfoClass:CreateHujiaUI()
    
    StartCoroutine(self,self.ShowHuJia,{})
end

function wnd_heroinfoClass:ShowHuJia()
    local cmTable = self.backpackHujia:GetComponent(CMUIGrid.Name)
    --防止仓库一直刷新
    if self.isFromXilian == false then
        if self.hujia_flag ==true then return end       
    end  
    self:SetWidgetActive("hujia_panel",false) 
    self.isFromXilian = false
  
    --控制动画
    self.hujia_flag = true
    if self.wuju_flag == true then
        self.wuju_flag = false
        self.equipmentObj[2]:ResetToBeginning()
        self.equipmentObj[2]:PlayForward()
    end
     --武具属性板子、武具仓库板子
    if self.wujuinfo_flag == true then
        self.wujuinfo_flag = false
    end
    self:SetWidgetActive("wuju_panel",false)
    self:SetLabel("equipment_page/equipment_bg/title_bg/txt",SData_Id2String.Get(5265))
    self:PlayHujiaFrame()--护甲光圈
    --Yield() 
    self:SetWidgetActive("hujia_panel",true)
    self.cmHuJiaScrollView:ResetPosition()--初始化滑动条位置
    Yield()
    if self.isCreateHujiaAgain == false then
        self:SetWidgetActive("shuxing_bg/shuxing_widget",false)
        if self.backpackHujiaObj ~= nil then
            self:ShowHuJiaShuXing(_,self.backpackHujiaObj[1].id)
            self:SetWidgetActive("shuxing_bg/shuxing_widget",true)
        end
        cmTable:Reposition()
        return 
    end
    Yield(0.4)
    local  hujia_ID_list = {}
    local PlayerLv = tonumber(Player:GetNumberAttr(PlayerAttrNames.Level))--获取主公等级
    local a = Player:GetEquips()
    local eachFunc = function (syncObj)
        if tonumber(syncObj:GetValue(EquipAttrNames.EType)) == 2 then
	        local temp_info = {}--单个装备信息
            local id = syncObj:GetValue(EquipAttrNames.ID)
            local dataID = tonumber( syncObj:GetValue(EquipAttrNames.DataID) )
            local lv = sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,tonumber(dataID))
            local heroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            local curr_skill = syncObj:GetValue(EquipAttrNames.CurrSkill)
            local skill_num = self:GetXilianNum(id)
            local zdl = sdata_EquipData:GetV(sdata_EquipData.I_Zhandouli,tonumber(dataID))
            local isequip = ifv(PlayerLv >= lv, true, false)
            temp_info = {ID = id, DataID = dataID, LV = lv, HeroID = heroID, Curr_Skill = curr_skill, ZDL = zdl, SKILL_NUM = skill_num,IsEquip = isequip}
            table.insert(hujia_ID_list, temp_info)
        end
    end
    a:ForeachEquips(eachFunc)
    table.sort(hujia_ID_list,SortFunc)
    --创建button
    
    -------------------------------------------huajia新代码---------------------------------------------
    for i = 1,#hujia_ID_list do
		-- 实例化装备
        if self.backpackHujiaEquips[hujia_ID_list[i].ID] == nil then        
            local equip = hujia_ID_list[i]
            self.backpackHujiaEquips[equip.ID] = self:CreateEquip(equip.ID,equip.DataID,equip.HeroID,EquipOwnerPanel.Backpack)
            local info = {}
            info.gameObject = self.backpackHujiaEquips[equip.ID].gameObject
            info.id = self.backpackHujiaEquips[equip.ID].dyID
		    table.insert(self.backpackHujiaObj,info)              
        end	 
	end
--    if #self.backpackHujiaObj > #hujia_ID_list then
--        local temp = #self.backpackHujiaObj - #hujia_ID_list
--        for i = #self.backpackHujiaObj,#self.backpackHujiaObj - temp + 1,-1 do
--            self.backpackHujiaObj[i].gameObject:GetParent():SetActive(false)
--        end

--    end
    if #hujia_ID_list <= 0 then
        self:SetWidgetActive("shuxing_bg/shuxing_widget",false)
    else
        --self:ShowHuJiaShuXing(_,hujia_ID_list[1].ID)
        self:SetWidgetActive("shuxing_bg/shuxing_widget",true)
    end
	--设置武具的外观显示
    local flag = true
    local k = 1
	for i = 1,#hujia_ID_list do
        if self.isShuxinHujia == false then            
            break
        end
        local dyID = hujia_ID_list[i].ID
        self.backpackHujiaObj[i].id = dyID
        self.backpackHujiaEquips[dyID].gameObject = self.backpackHujiaObj[i].gameObject
        self.backpackHujiaEquips[dyID].dyID = hujia_ID_list[i].ID
        self.backpackHujiaEquips[dyID].heroID = hujia_ID_list[i].HeroID
        self.backpackHujiaEquips[dyID].ownerPanel = EquipOwnerPanel.Backpack--记录所属面板
        self.backpackHujiaEquips[dyID].sinfo = sdata_EquipData:GetRow(hujia_ID_list[i].DataID)--取得静态数据
        self.backpackHujiaEquips[dyID].gameObject:SetName("Equip_"..hujia_ID_list[i].DataID)
        local dragDropItem = self.backpackHujiaEquips[dyID].gameObject:GetComponent(CMDragDropItem.Name)
        dragDropItem:SetUserData(dyID)--拖拽物上设置动态ID
        self:OnEquipOwnerChanged(self.backpackHujiaEquips[dyID])                         	
        local cmevt = CMUIEvent.Go(self.backpackHujiaEquips[dyID].gameObject,UIEventType.Click)
        cmevt:Listener(self.backpackHujiaEquips[dyID].gameObject,UIEventType.Click,self,"ShowHuJiaShuXing",dyID)
        if flag then
            flag = false
            self:ShowHuJiaShuXing(_,hujia_ID_list[1].ID)
        end
        k = k + 1
        if k == 26 then
            k = 1
            cmTable:Reposition()
            Yield(0.1)
        end     
    end
    self.isShuxinHujia = false
----------------------------------------------------------------------------------------------  
	cmTable:Reposition()
    self.isCreateHujiaAgain = false
    
end


--武具简单属性
function wnd_heroinfoClass:ShowWuJuShuXing(_,ID)

    self.CurrEquipmentShuxing = ID
    self:SetWidgetActive("shuxing_widget/name_txt",true)

    --显示被选中光圈 
    for i = 1,#self.backpackWujuObj do
        local frame = self.backpackWujuObj[i].gameObject:FindChild("wuju_frame")
        frame:SetActive(ifv(self.backpackWujuObj[i].id == ID,true,false))
    end
    local chuandai_info = {}--穿戴参数
    local a = Player:GetEquips()
		local eachFunc = function (syncObj)
		    if(syncObj:GetValue(EquipAttrNames.ID) == ID) then
                
                local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
                local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
                if HeroID ~= 0 then
                     local HeroName = SData_Hero.GetHero(HeroID):Name()
                     self:SetLabel("shuxing_widget/name_txt",HeroName)
                else
                    self:SetWidgetActive("shuxing_widget/name_txt",false)
                end
                --装备图标
                local sprite = self.instance:FindWidget( "shuxing_widget/equipment_img" )
	            local equip = sprite:GetComponent(CMUISprite.Name)
	            equip:SetSpriteName(sdata_EquipData:GetV(sdata_EquipData.I_Icon,DataID))
                local LV = tonumber( sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,DataID) )
                local plyLv = Player:GetNumberAttr(PlayerAttrNames.Level)
                local wuli = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Wuli,DataID))
                local nu = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Nu,DataID))
                self:SetLabel("shuxing_widget/left_class/equipment_name",sdata_EquipData:GetV(sdata_EquipData.I_Name,DataID))
                self:SetLabel("shuxing_widget/left_class/shuxing01",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),wuli))
                self:SetLabel("shuxing_widget/left_class/shuxing02",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),nu))               
                local lvObj = self.instance:FindWidget("shuxing_widget/equipment_lv")
                local cmLvLabel = lvObj:GetComponent(CMUILabel.Name)
                if plyLv < LV then
                    cmLvLabel:SetColor(Color.red)
                else
                    cmLvLabel:SetColor(Color.white)                
                end
                self:SetLabel("shuxing_widget/equipment_lv",string.sformat(SData_Id2String.Get(5075),LV))
                self:split(syncObj:GetValue(EquipAttrNames.SkillAttr),DataID)
                --洗练底纹
                local attr = self:GetXilianNum(ID)
                local sprite = self.instance:FindWidget( "shuxing_widget/equipment_frame" )
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


                chuandai_info = {id = ID, lv = LV, heroID = HeroID}
            end
		end
	    a:ForeachEquips(eachFunc)
   
    self.ShuxingToXilian = ID
     --绑定事件
     self:BindUIEvent("equipment_page/shuxing_bg/shuxing_widget/xilian_btn",UIEventType.Click,"ShowXiLian",ID)
     self:BindUIEvent("shuxing_widget/chuandai_btn",UIEventType.Click,"OnClickChuanDai",chuandai_info)--点击穿戴
    --显示对比数据
    if  self.bIsGengti == true then
        self:SetWidgetActive("shuxing_widget/shuxing1_duibi",true)
        self:SetWidgetActive("shuxing_widget/shuxing2_duibi",true)
        local wuli1 = 0
        local wuli2 = 0
        local nu1 = 0
        local nu2 = 0
        local a = Player:GetEquips()
		local eachFunc = function (syncObj)
       
	    if syncObj:GetValue(EquipAttrNames.ID) == ID then
                local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
                wuli1 = sdata_EquipData:GetV(sdata_EquipData.I_Wuli,DataID)
                nu1 = sdata_EquipData:GetV(sdata_EquipData.I_Nu,DataID)
            end
            if syncObj:GetValue(EquipAttrNames.ID) == wuju_temp then
                local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
                wuli2 = sdata_EquipData:GetV(sdata_EquipData.I_Wuli,DataID)
                nu2 = sdata_EquipData:GetV(sdata_EquipData.I_Nu,DataID)
            end
		end
	    a:ForeachEquips(eachFunc)

        if wuli1 > wuli2 then
            local m_Item1 = self.instance:FindWidget("shuxing_widget/shuxing1_duibi")
            local obj1 = m_Item1:GetComponent(CMUILabel.Name)
            obj1:SetColor(Color.green)
            self:SetLabel("shuxing_widget/shuxing1_duibi","+"..wuli1 - wuli2)
            self:SetWidgetActive("01up",true)
            self:SetWidgetActive("01down",false)

        elseif wuli1 < wuli2 then
            local m_Item2 = self.instance:FindWidget("shuxing_widget/shuxing1_duibi")
            local obj2 = m_Item2:GetComponent(CMUILabel.Name)
            obj2:SetColor(Color.red)
            self:SetLabel("shuxing_widget/shuxing1_duibi",wuli1 - wuli2)
            self:SetWidgetActive("01down",true)
            self:SetWidgetActive("01up",false)
        else
            self:SetWidgetActive("shuxing_widget/shuxing1_duibi",false)
            self:SetWidgetActive("01down",false)
            self:SetWidgetActive("01up",false)
        end

        if nu1 > nu2 then
            local m_Item1 = self.instance:FindWidget("shuxing_widget/shuxing2_duibi")
            local obj1 = m_Item1:GetComponent(CMUILabel.Name)
            obj1:SetColor(Color.green)
            self:SetLabel("shuxing_widget/shuxing2_duibi","+"..nu1 - nu2)
            self:SetWidgetActive("02up",true)
            self:SetWidgetActive("02down",false)
        elseif nu1 < nu2 then
            local m_Item2 = self.instance:FindWidget("shuxing_widget/shuxing2_duibi")
            local obj2 = m_Item2:GetComponent(CMUILabel.Name)
            obj2:SetColor(Color.red)
            self:SetLabel("shuxing_widget/shuxing2_duibi",nu1 - nu2)
            self:SetWidgetActive("02down",true)
            self:SetWidgetActive("02up",false)
        else
            self:SetWidgetActive("shuxing_widget/shuxing2_duibi",false)
            self:SetWidgetActive("02down",false)
            self:SetWidgetActive("02up",false)
        end

    end
end

--护甲简单属性
function wnd_heroinfoClass:ShowHuJiaShuXing(_,ID)--点击装备显示装备属性
    print("ShowHuJiaShuXing")
    self.CurrEquipmentShuxing = ID
    self:SetWidgetActive("shuxing_widget/name_txt",true)
    
    --显示被选中光圈  
    for i = 1,#self.backpackHujiaObj do
        local frame = self.backpackHujiaObj[i].gameObject:FindChild("wuju_frame")
        frame:SetActive(ifv(self.backpackHujiaObj[i].id == ID,true,false))
    end
    local chuandai_info = {}--穿戴参数
     local a = Player:GetEquips()
		local eachFunc = function (syncObj)
		    if(syncObj:GetValue(EquipAttrNames.ID) == ID) then
                local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
                local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
                if HeroID ~= 0 then
                     local HeroName = SData_Hero.GetHero(HeroID):Name()
                     self:SetLabel("shuxing_widget/name_txt",HeroName)
                else
                    self:SetWidgetActive("shuxing_widget/name_txt",false)
                end

                --装备图标
                local sprite = self.instance:FindWidget( "shuxing_widget/equipment_img" )
	            local equip = sprite:GetComponent(CMUISprite.Name)
	            equip:SetSpriteName(sdata_EquipData:GetV(sdata_EquipData.I_Icon,DataID))
                local LV = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,DataID))
                local plyLv = Player:GetNumberAttr(PlayerAttrNames.Level)
                local hp = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_HP,DataID))
                local tili = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Tili,DataID))
                self:SetLabel("shuxing_widget/left_class/equipment_name",sdata_EquipData:GetV(sdata_EquipData.I_Name,DataID))
                self:SetLabel("shuxing_widget/left_class/shuxing01",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),hp))
                self:SetLabel("shuxing_widget/left_class/shuxing02",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),tili))  
                local lvObj = self.instance:FindWidget("shuxing_widget/equipment_lv")
                local cmLvLabel = lvObj:GetComponent(CMUILabel.Name)
                if plyLv < LV then
                    cmLvLabel:SetColor(Color.red)
                else
                    cmLvLabel:SetColor(Color.white)                
                end
                self:SetLabel("shuxing_widget/equipment_lv",string.sformat(SData_Id2String.Get(5075),LV))
                self:split(syncObj:GetValue(EquipAttrNames.SkillAttr),DataID)
            
                --洗练底纹
                local attr = self:GetXilianNum(ID)
                local sprite = self.instance:FindWidget( "shuxing_widget/equipment_frame" )
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

                chuandai_info = {id = ID, heroID = HeroID,lv = LV}--给穿戴参数赋值
            end
		end
	    a:ForeachEquips(eachFunc)   
        self.ShuxingToXilian = ID
        self:BindUIEvent("shuxing_widget/chuandai_btn",UIEventType.Click,"OnClickChuanDai",chuandai_info)--点击穿戴
        self:BindUIEvent("equipment_page/shuxing_bg/shuxing_widget/xilian_btn",UIEventType.Click,"ShowXiLian",ID)

    --显示对比数据
    if  self.bIsGengti == true then
        self:SetWidgetActive("shuxing_widget/shuxing1_duibi",true)
        self:SetWidgetActive("shuxing_widget/shuxing2_duibi",true)
        local hp1 = 0
        local hp2 = 0
        local tili1 = 0
        local tili2 = 0
        local a = Player:GetEquips()
		local eachFunc = function (syncObj)
   
		    if syncObj:GetValue(EquipAttrNames.ID) == ID then
                local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
                hp1 = sdata_EquipData:GetV(sdata_EquipData.I_HP,DataID)
                tili1 = sdata_EquipData:GetV(sdata_EquipData.I_Tili,DataID)
            end
            if syncObj:GetValue(EquipAttrNames.ID) == hujia_temp then
                local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
                hp2 = sdata_EquipData:GetV(sdata_EquipData.I_HP,DataID)
                tili2 = sdata_EquipData:GetV(sdata_EquipData.I_Tili,DataID)
            end
		end
	    a:ForeachEquips(eachFunc)

        if hp1 > hp2 then
            local m_Item1 = self.instance:FindWidget("shuxing_widget/shuxing1_duibi")
            local obj1 = m_Item1:GetComponent(CMUILabel.Name)
            obj1:SetColor(Color.green)
            self:SetLabel("shuxing_widget/shuxing1_duibi","+"..hp1 - hp2)
            self:SetWidgetActive("01up",true)
            self:SetWidgetActive("01down",false)

        elseif hp1 < hp2 then
            local m_Item2 = self.instance:FindWidget("shuxing_widget/shuxing1_duibi")
            local obj2 = m_Item2:GetComponent(CMUILabel.Name)
            obj2:SetColor(Color.red)
            self:SetLabel("shuxing_widget/shuxing1_duibi",hp1 - hp2)
            self:SetWidgetActive("01down",true)
            self:SetWidgetActive("01up",false)
        else
            self:SetWidgetActive("shuxing_widget/shuxing1_duibi",false)
            self:SetWidgetActive("01down",false)
            self:SetWidgetActive("01up",false)
        end

        if tili1 > tili2 then
            local m_Item1 = self.instance:FindWidget("shuxing_widget/shuxing2_duibi")
            local obj1 = m_Item1:GetComponent(CMUILabel.Name)
            obj1:SetColor(Color.green)
            self:SetLabel("shuxing_widget/shuxing2_duibi","+"..tili1 - tili2)
            self:SetWidgetActive("02up",true)
            self:SetWidgetActive("02down",false)

        elseif tili1 < tili2 then
            local m_Item2 = self.instance:FindWidget("shuxing_widget/shuxing2_duibi")
            local obj2 = m_Item2:GetComponent(CMUILabel.Name)
            obj2:SetColor(Color.red)
            self:SetLabel("shuxing_widget/shuxing2_duibi",tili1 - tili2)
            self:SetWidgetActive("02down",true)
            self:SetWidgetActive("02up",false)
        else
            self:SetWidgetActive("shuxing_widget/shuxing2_duibi",false)
            self:SetWidgetActive("02down",false)
            self:SetWidgetActive("02up",false)
        end

    end

end


--武具详细信息
function wnd_heroinfoClass:ShowWujuInfo(ID)
    if self.isFromXilianToInfo == false then      
        if self.wujuinfo_flag then 
            if self.wuju_flag then
                self:SetWidgetActive("gengti_maskbtn",false)
                self:SetWidgetActive("gengti_btn/light",false) 
            end
            --self:SetWidgetActive("gengti_maskbtn",false) 
            return 
        end             
    end
    self.isFromXilianToInfo = false
    
    self.CurrEquipmentInfo = ID
    self.CreateWuJuFlag = true--停止创建武具
    self.CreateHuJiaFlag = true--停止创建护甲
    self:SetWidgetActive("wuju_panel",true)
    self:SetWidgetActive("hujia_panel",false)

    --控制动画
    if self.hujia_flag == true or self.wuju_flag == true then
        self.hujia_flag = false
        self.wuju_flag = false
    end
    self.wujuinfo_flag = true
    if self.hujiainfo_flag == true then
        self.hujiainfo_flag = false
        local m_Item = self.instance:FindWidget("center_widget/e_shuxing_panel/e_shuxing_page")
        local equip_info1 = m_Item:GetComponents(CMUITweener.Name)
        equip_info1[2]:ResetToBeginning()
        equip_info1[2]:PlayForward()
    end
    --self:SetWidgetActive("gengti_btn/light",false)
   -----------详细信息
    local a = Player:GetEquips()
	local eachFunc = function (syncObj)
		if(syncObj:GetValue(EquipAttrNames.ID) == ID) then
            local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
            local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            if HeroID ~= 0 then
                local HeroName = SData_Hero.GetHero(HeroID):Name()
                self:SetLabel("shuxing_widget/dangqian",string.sformat(SData_Id2String.Get(5065),HeroName))
            else
                self:SetLabel("shuxing_widget/dangqian",string.sformat(SData_Id2String.Get(5065),SData_Id2String.Get(5307)))
            end

            --装备图标
            local sprite = self.instance:FindWidget( "e_shuxing_bg/shuxing_widget/equipment_img" )
	        local equip = sprite:GetComponent(CMUISprite.Name)
	        equip:SetSpriteName(sdata_EquipData:GetV(sdata_EquipData.I_Icon,DataID))
            local lv = sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,DataID)
            local wuli = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Wuli,DataID))
            local nu = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Nu,DataID))
            self:SetLabel("shuxing_widget/level",string.sformat(SData_Id2String.Get(5065),lv))
            self:SetLabel("shuxing_widget/name",sdata_EquipData:GetV(sdata_EquipData.I_Name,DataID))
            self:SetLabel("shuxing_widget/shuxing1",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5072),wuli))
            self:SetLabel("shuxing_widget/shuxing2",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5074),nu))
			local zdl = tonumber(syncObj:GetValue(EquipAttrNames.eZDL))
            self:SetLabel("shuxing_widget/zhandouli",math.ceil(zdl/100))             
            self:split_info(syncObj:GetValue(EquipAttrNames.SkillAttr),DataID)
            self:SetLabel("shuxing_widget/jianjie",sdata_EquipData:GetV(sdata_EquipData.I_Description,DataID))

            --洗练底纹
            local attr = self:GetXilianNum(ID)
            local sprite = self.instance:FindWidget( "e_shuxing_bg/shuxing_widget/equipment_frame" )
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
    ----------详细信息end

    self:BindUIEvent("e_shuxing_page/e_shuxing_bg/gengti_btn",UIEventType.Click,"OnGengTi",1)
    self:BindUIEvent("e_shuxing_bg/xilian_btn",UIEventType.Click,"ShowXiLian",ID)


    wuju_temp = ID

    self:SetWidgetActive("shuxing_widget/shuxing1_duibi",false)
    self:SetWidgetActive("shuxing_widget/shuxing2_duibi",false)
    self:SetWidgetActive("gengti_maskbtn",false)
    self:SetWidgetActive("gengti_btn/light",false)




    
    self.InfoToXilian = ID
end


--护甲详细信息
function wnd_heroinfoClass:ShowHujiaInfo(ID)
    if self.isFromXilianToInfo == false then
        if self.hujiainfo_flag then 
            if self.hujia_flag then
                self:SetWidgetActive("gengti_maskbtn",false)
                self:SetWidgetActive("gengti_btn/light",false) 
            end
            --self:SetWidgetActive("gengti_maskbtn",false) 
            return 
        end       
    end
    self.isFromXilianToInfo = false
    print("ShowHujiaInfo")
    self.CurrEquipmentInfo = ID
    self.CreateWuJuFlag = true--停止创建武具
    self.CreateHuJiaFlag = true--停止创建护甲
    self:SetWidgetActive("hujia_panel",true)
    self:SetWidgetActive("wuju_panel",false)

    --控制动画
    if self.wuju_flag == true or self.hujia_flag == true then
        self.wuju_flag = false
        self.hujia_flag = false
    end

    self.hujiainfo_flag = true
    if self.wujuinfo_flag == true then
        self.wujuinfo_flag = false
        local m_Item = self.instance:FindWidget("center_widget/e_shuxing_panel/e_shuxing_page")
        local equip_info1 = m_Item:GetComponents(CMUITweener.Name)
        equip_info1[2]:ResetToBeginning()
        equip_info1[2]:PlayForward()
    end
    self:SetWidgetActive("gengti_btn/light",false)
   -----------详细信息
   local a = Player:GetEquips()
	local eachFunc = function (syncObj)
        if(syncObj:GetValue(EquipAttrNames.ID) == ID) then
            local DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
            local HeroID = tonumber(syncObj:GetValue(EquipAttrNames.HeroID))
            if HeroID ~= 0 then
                local HeroName = SData_Hero.GetHero(HeroID):Name()
                self:SetLabel("shuxing_widget/dangqian",string.sformat(SData_Id2String.Get(5065),HeroName))
            else
                self:SetLabel("shuxing_widget/dangqian",string.sformat(SData_Id2String.Get(5065),SData_Id2String.Get(5307)))
            end

            --装备图标
            local sprite = self.instance:FindWidget( "e_shuxing_bg/shuxing_widget/equipment_img" )
	        local equip = sprite:GetComponent(CMUISprite.Name)
	        equip:SetSpriteName(sdata_EquipData:GetV(sdata_EquipData.I_Icon,DataID))
            local lv = sdata_EquipData:GetV(sdata_EquipData.I_RequireLv,DataID)
            local zdl = tonumber(syncObj:GetValue(EquipAttrNames.eZDL))
            local hp = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_HP,DataID))
            local tili = tonumber(sdata_EquipData:GetV(sdata_EquipData.I_Tili,DataID))
            self:SetLabel("e_shuxing_bg/shuxing_widget/level",string.sformat(SData_Id2String.Get(5065),lv))
            self:SetLabel("e_shuxing_bg/shuxing_widget/name",sdata_EquipData:GetV(sdata_EquipData.I_Name,DataID))
            self:SetLabel("e_shuxing_bg/shuxing_widget/shuxing1",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5071),hp))
            self:SetLabel("e_shuxing_bg/shuxing_widget/shuxing2",string.sformat(SData_Id2String.Get(5078),SData_Id2String.Get(5073),tili))
            self:SetLabel("zhandouli",math.ceil(zdl/100))             
            self:split_info(syncObj:GetValue(EquipAttrNames.SkillAttr),DataID)
            self:SetLabel("shuxing_widget/jianjie",sdata_EquipData:GetV(sdata_EquipData.I_Description,DataID))

            --洗练底纹
            local attr = self:GetXilianNum(ID)
            local sprite = self.instance:FindWidget( "e_shuxing_bg/shuxing_widget/equipment_frame" )
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
    
    ----------详细信息end

    self:BindUIEvent("e_shuxing_page/e_shuxing_bg/gengti_btn",UIEventType.Click,"OnGengTi",2)
    self:BindUIEvent("e_shuxing_page/e_shuxing_bg/xilian_btn",UIEventType.Click,"ShowXiLian",ID)

    hujia_temp = ID

    self:SetWidgetActive("shuxing_widget/shuxing1_duibi",false)
    self:SetWidgetActive("shuxing_widget/shuxing2_duibi",false)
    self:SetWidgetActive("gengti_maskbtn",false)
    self:SetWidgetActive("gengti_btn/light",false)

    
    self.InfoToXilian = ID
end


--穿戴
function wnd_heroinfoClass:OnClickChuanDai(_,chuandai_info)--点击穿戴
    

    local ZGLV = tonumber(Player:GetNumberAttr(PlayerAttrNames.Level))--获取主公等级
    
--    if self.IsHeroDied == true then
--        Poptip.PopMsg("该英雄已挂，不能穿戴！",Color.red)
--        return
--    end
    local equipInfo = self:GetBackpackEquipByID(chuandai_info.id)
    local tp = equipInfo.sinfo[sdata_EquipData.I_Type]--装备类型 
    local oldEquip = self:GetBodyEquip(tp)--位置上原来放的装备
    if oldEquip ~= nil then
        local canEq = wnd_heroinfo:GetEquipOperationByID(oldEquip.dyID)
        if canEq == 0 then
            Poptip.PopMsg(SData_Id2String.Get(3149),Color.red)
            return
        end       
    end      
    --判断身上穿的装备是否为0
    local canEq = self:GetEquipOperationByID(chuandai_info.id)
    if canEq == 0 then
        Poptip.PopMsg(SData_Id2String.Get(3150),Color.red)
        return
    end
    if  ZGLV < chuandai_info.lv then
        Poptip.PopMsg(SData_Id2String.Get(3146),Color.red)  return
    end
    
    if chuandai_info.heroID == 0 then --无人穿戴的装备
        SendData.equipID = chuandai_info.id
        SendData.HeroID = self.firstID
        SendData.ic = 0
        self:SendZBNetWork()
    elseif chuandai_info.heroID == self.firstID then --穿在自己身上的装备
        Poptip.PopMsg(SData_Id2String.Get(3148),Color.red)
    else--穿在别人身上的装备
--        local flag = self:GetHeroState(chuandai_info.heroID)
--        if flag == true then 
--            Poptip.PopMsg("穿戴该装备的武将已挂掉，不能穿死人装备",Color.red)
--            return 
--        end
       --弹出双选框begin
--       self:SetLabel("tips_bg/txt",SData_Id2String.Get(3147))
--       self:SetWidgetActive("changetips_panel/bg",true)
--       self:SetWidgetActive("changetips_panel/tips_bg",true)
--       local bg = self:FindWidget("changetips_panel/bg")
--       local tips_bg = self:FindWidget("changetips_panel/tips_bg")
--       local bgObj = bg:GetComponent(CMUITweener.Name)
--       local tipsObj = tips_bg:GetComponent(CMUITweener.Name)
--       bgObj:PlayForward()
--       tipsObj:ResetToBeginning()
--       tipsObj:PlayForward()
       --弹出双选框end
       
       --self:BindUIEvent("define_btn",UIEventType.Click,"OnQZChuanDai",chuandai_info.id)
    wnd_ShuangXuan:SetLabelInfo("友情提示！",SData_Id2String.Get(3147), chuandai_info.id)
    wnd_ShuangXuan:SetCurrFrame(6)
    wnd_ShuangXuan:Show() 
    end
    
end

--强制穿戴
function wnd_heroinfoClass:OnQZChuanDai(ID)
    SendData.equipID = ID
    SendData.HeroID = self.firstID
    SendData.ic = 1  
    self:SendZBNetWork()
end


--一键穿戴
function wnd_heroinfoClass:OnYiJianChange()
    if self.BodyEquips[EquipType.Wuju] ~= nil and self.BodyEquips[EquipType.Hujia] ~= nil then
        Poptip.PopMsg(SData_Id2String.Get(5323),Color.red)
        return
    end
    
    self.cmBtnChange:SetIsEnabled(false)

    self:SendZBYJNetWork(self.firstID)
end
--更替
function wnd_heroinfoClass:OnGengTi(obj,type)
    local lightObj = self.instance:FindWidget("gengti_btn/light")
    local cmTweenLight = lightObj:GetComponent(CMUITweener.Name)
    self.bIsGengti = true
    self:SetWidgetActive("gengti_maskbtn",true)
    self:SetWidgetActive("gengti_btn/light",true)
    cmTweenLight:PlayForward()
    self:SetWidgetActive("wuju_panel",false)
    self:SetWidgetActive("hujia_panel",false)
    self.isFromXilian = true
    if type == 1 then
        self:CreateWujuUI()
    elseif type == 2 then
        self:CreateHujiaUI()
    end
end

--跳转到洗练页面
function wnd_heroinfoClass:ShowXiLian(obj,ID)
    wnd_xilian.showShuXingFlag = false 
    wnd_xilian.xilian_id = ID --传递装备ID
    wnd_xilian:Show()--显示洗练界面 
end



--解析装备简单的洗练属性
function wnd_heroinfoClass:split(str,ID)
 
    local Key = 0
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

--解析装备的详细洗练属性

function wnd_heroinfoClass:split_info(str,ID)
    self:InitXilianLabel()
    local flag = false--当为false时为11-0，true时是11-1
    --xilian03_img 
    local img3Obj = self.instance:FindWidget("xilian03_img")
    local  img3_sprite = img3Obj:GetComponent(CMUISprite.Name)
    img3_sprite:SetSpriteName("201")
    img3_sprite:SetColor(Color.white)
    --xilian02_img
    local img2Obj = self.instance:FindWidget("xilian02_img")
    local  img2_sprite = img2Obj:GetComponent(CMUISprite.Name)
    img2_sprite:SetSpriteName("201")
    img2_sprite:SetColor(Color.white)
    --xilian01_img
    local img1Obj = self.instance:FindWidget("xilian01_img")
    local  img1_sprite = img1Obj:GetComponent(CMUISprite.Name)
    img1_sprite:SetSpriteName("201")
    img1_sprite:SetColor(Color.white)
    --将第三个按钮精灵播放失效
    local uiplay = img3Obj:GetComponent(UIPlayTween.Name)
    uiplay:SetEnable(false)
     
    local Key = 0 
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
                img1_sprite:SetSpriteName("14")--设置精灵
                img1_sprite:SetColor(Color.white)--设置精灵为亮色
            else 
                flag = false
                self.cmLabel_xilian01_name:SetColor(Color.gray)
                self.cmLabel_xilian01_shuxing:SetColor(Color.gray)
                img1_sprite:SetSpriteName("14")
                img1_sprite:SetColor(Color.gray)--设置精灵为暗色
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
                img1_sprite:SetSpriteName("14")
                img1_sprite:SetColor(Color.white)--设置精灵为亮色
            else
                if flag == false and self.shuxing1_flag == false then
                    self.cmLabel_xilian01_name:SetColor(Color.gray)
                    self.cmLabel_xilian01_shuxing:SetColor(Color.gray)
                    img1_sprite:SetSpriteName("14")
                    img1_sprite:SetColor(Color.gray)   --设置精灵为暗色               
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
            img2_sprite:SetSpriteName("gold")
            
            if StateValue == 1 then 
                self.cmLabel_xilian02_name:SetColor(Color.new(180/255,0,1,1))                  
                self.cmLabel_xilian02_shuxing01:SetColor(Color.new(180/255,0,1,1))
                self.cmLabel_xilian02_shuxing02:SetColor(Color.new(180/255,0,1,1))
                img2_sprite:SetColor(Color.white)--设置精灵为亮色

            else
                self.cmLabel_xilian02_name:SetColor(Color.gray)                  
                self.cmLabel_xilian02_shuxing01:SetColor(Color.gray)
                self.cmLabel_xilian02_shuxing02:SetColor(Color.gray)
                img2_sprite:SetColor(Color.gray)--设置精灵为暗色
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
        
            uiplay:SetEnable(true)--允许弹出skillinfo_bg
            img3_sprite:SetSpriteName("vip_small")      
            if StateValue == 1 then
                self.cmLabel_xilian03_name:SetColor(Color.new(212/255,84/255,0,1))  
                self.cmLabel_xilian03_shuxing:SetColor(Color.new(212/255,84/255,0,1))
                img3_sprite:SetColor(Color.white) --设置精灵为亮色     
            else
                self.cmLabel_xilian03_name:SetColor(Color.gray)  
                self.cmLabel_xilian03_shuxing:SetColor(Color.gray)
                img3_sprite:SetColor(Color.gray)  --设置精灵为暗色                    
            end
            local xlsxName3 = sdata_EquipData:GetV(sdata_EquipData.I_XilianSkillName3,ID)
            self.cmLabel_xilian03_name:SetValue(string.sformat(SData_Id2String.Get(5080),xlsxName3))                                  
            local skill_id = sdata_EquipData:GetV(sdata_EquipData.I_XilianSkill3,ID)
            local skillinfo = SData_Skill.GetSkill(skill_id)
            local skill_name = skillinfo:SkillNoteMin()--技能名字
            self.cmLabel_xilian03_shuxing:SetValue(string.sformat(SData_Id2String.Get(5080),skill_name))
            local skillnote = skillinfo:SkillNote()--技能详情
            local skillname = skillinfo:Name()--技能名字
            self:SetLabel("skillinfo_bg/txt",skillnote)
            self:SetLabel("skillinfo_bg/title_bg/txt",skillname)             
        end
    end

end

--初始化洗练装备
function wnd_heroinfoClass:InitXilianLabel()

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

--根据装备ID获取装备洗练属性布尔值
function wnd_heroinfoClass:GetXiLianStateByID(_EquipID)
    local a = Player:GetEquips()
    local Key = 0
    local eachFunc = function (syncObj)
		if syncObj:GetValue(EquipAttrNames.ID) == _EquipID then
            local str = syncObj:GetValue(EquipAttrNames.SkillAttr,id)
            local EquipInfo1 = string.split(str,',')
            for i =1 ,#EquipInfo1 do
                local EquipInfo2 = string.split(EquipInfo1[i],':')
                local StateKey = tonumber( EquipInfo2[1] )
                local StateValue = tonumber(EquipInfo2[2] )

                if StateValue ~= 0 and Key == 0 then 
                    Key = StateKey
                end
            end

        end
    end

	a:ForeachEquips(eachFunc)
    return Key
end
function wnd_heroinfoClass:GetXilianNumZXY(_EquipID)
    local a = Player:GetEquips()
    local Key = 0
    local eachFunc = function (syncObj)
		if syncObj:GetValue(EquipAttrNames.ID) == _EquipID then
            local str = syncObj:GetValue(EquipAttrNames.SkillAttr,id)
            local EquipInfo1 = string.split(str,',')
            for i =1 ,#EquipInfo1 do
                local EquipInfo2 = string.split(EquipInfo1[i],':')
               
                local StateKey = tonumber( EquipInfo2[1] )
                local StateValue = tonumber(EquipInfo2[2] )
                if StateValue ~= 0 and Key == 0 then 
                    Key = StateKey
                end
            end

        end
    end

	a:ForeachEquips(eachFunc)
    if Key == nil then Key = 0 end
    return tonumber( Key )
end

function wnd_heroinfoClass:IsHasEquip()
    local flag = false
    local a = Player:GetEquips()
	local eachFunc = function (syncObj)
        local id = syncObj:GetValue(EquipAttrNames.ID)
        if id ~= nil then
            flag = true
        end
	end
	a:ForeachEquips(eachFunc)
    return flag
end

--返回当前洗练属性序号1，2，3......
function wnd_heroinfoClass:GetXilianNum(_EquipID)
    local a = Player:GetEquips()
    local Key = 0
    local eachFunc = function (syncObj)
		if syncObj:GetValue(EquipAttrNames.ID) == _EquipID then
            local str = syncObj:GetValue(EquipAttrNames.SkillAttr,id)
            local EquipInfo1 = string.split(str,',')
            for i =1 ,#EquipInfo1 do
                local EquipInfo2 = string.split(EquipInfo1[i],':')
                local StateKey = tonumber( EquipInfo2[1] )
                local StateValue = tonumber(EquipInfo2[2] )

                if StateValue ~= 0 and Key == 0 then 
                    Key = StateKey
                end
            end

        end
    end

	a:ForeachEquips(eachFunc)

    if Key == 11 or Key == 12 then 
        return 1
    elseif Key == 2 then 
        return 2
    elseif Key == 3 then 
        return 3
    else 
        return 0
    end
end

--根据武将ID获取武将的状态（死还是活）

function wnd_heroinfoClass:GetHeroState(heroID)
    print("#GetHeroState")
    local state = false
    local heros = Player:GetAHeroinfos()
	local eachFunc = function (syncObj)
		if heroID == tonumber(syncObj:GetValue(AHeroinfos.id)) then
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 1 then--读取英雄状态
                state = true
			end
		end
	end
	heros:ForeachAHeroinfos(eachFunc)
    return state
end

--根据装备ID获取装备是否可操作

function wnd_heroinfoClass:GetEquipOperationByID(ID)
    local IsOpera = 1
    local a = Player:GetEquips()
    local eachFunc = function (syncObj)
        if syncObj:GetValue(EquipAttrNames.ID) == ID then
            IsOpera = tonumber(syncObj:GetValue(EquipAttrNames.canEq))
        end     
    end
    a:ForeachEquips(eachFunc)
    return IsOpera
end


--播放双选框
function wnd_heroinfoClass:PlayShuangXuan(dragDropItem)
--    self:SetWidgetActive("changetips_panel/bg",true)
--    self:SetWidgetActive("changetips_panel/tips_bg",true)
--    local bg = self:FindWidget("changetips_panel/bg")
--    local tips_bg = self:FindWidget("changetips_panel/tips_bg")
--    local bgObj = bg:GetComponent(CMUITweener.Name)
--    local tipsObj = tips_bg:GetComponent(CMUITweener.Name)
--    bgObj:PlayForward()
--    tipsObj:ResetToBeginning()
--    tipsObj:PlayForward()
--    self:BindUIEvent("define_btn",UIEventType.Click,"OnDefineChuandai",dragDropItem)
--    self:BindUIEvent("cancel_btn",UIEventType.Click,"OnCancelChuandai",dragDropItem)
    wnd_ShuangXuan:SetLabelInfo("友情提示！",SData_Id2String.Get(3147), dragDropItem)
    wnd_ShuangXuan:SetCurrFrame(5)
    wnd_ShuangXuan:Show() 

end
--拖拽过来强制穿戴
function wnd_heroinfoClass:OnDefineChuandai(dragDropItem)
    local id = dragDropItem:GetUserData()
    local equipInfo = wnd_heroinfo:GetBackpackEquipByID(id)
    local tp = equipInfo.sinfo[sdata_EquipData.I_Type]--装备类型
    local oldEquip = wnd_heroinfo:GetBodyEquip(tp)--位置上原来放的装备
    if oldEquip~=nil then
        local id = oldEquip.dyID
        oldEquip:Destroy()--销毁
        wnd_heroinfo:SetBodyEquip(tp,nil)     
        local eInfo = wnd_heroinfo:GetBackpackEquipByID(id)
        if eInfo~=nil then
            eInfo.heroID = 0
            wnd_heroinfo:OnEquipOwnerChanged( eInfo  )
        end
    end

    --克隆出新装备信息，并进行必要修改
    local newEquip = equipInfo:Clone()
    newEquip.gameObject = dragDropItem.gameObject
    newEquip.ownerPanel = EquipOwnerPanel.Body
    newEquip.heroID = wnd_heroinfo.firstID

    --背包中的装备所属英雄改变
    equipInfo.heroID = wnd_heroinfo.firstID

    --放入新装备
    wnd_heroinfo:SetBodyEquip(tp,newEquip)

    --所属面板改变，对外观和一些组件属性做相应调整
    wnd_heroinfo:OnEquipOwnerChanged(newEquip)
    wnd_heroinfo:OnEquipOwnerChanged(equipInfo)

    --发送穿戴协议
    wnd_heroinfo:DragDropChuanDai(newEquip.dyID)
end

--拖拽过来取消强制穿戴
function wnd_heroinfoClass:OnCancelChuandai(dragDropItem)
    local obj = dragDropItem.gameObject
    if obj~=nil then
        obj:Destroy()--销毁
    end
end
--拖拽穿戴
function wnd_heroinfoClass:DragDropChuanDai(ID)
    SendData.equipID = ID
    SendData.HeroID = self.firstID
    SendData.ic = 1   
    self:SendZBNetWork(true)--发送穿戴协议，成功后不用刷新界面
    --self:PlayShuangXuan()

end

--拖拽卸载
function wnd_heroinfoClass:DragDropXiezai(ID)
    SendData.equipID = ID
    SendData.HeroID = self.firstID
    self:SendXZZBNetWork(true)--发送穿戴协议，成功后不用刷新界面
end


--装备穿戴协议
function wnd_heroinfoClass:SendZBNetWork(notReCtreate)
    self.CurrEquipmentInfo = SendData.equipID
    self.CurrEquipmentShuxing = SendData.equipID
    local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","ZBC")  
	jsonNM:Add ("hid", SendData.HeroID)
	jsonNM:Add ("eid", SendData.equipID)
	jsonNM:Add ("ic", SendData.ic)
	local loader = GameConn:CreateLoader(jsonNM,0) 

    --闭包传参给nm_ZBCallBack
    local reCall = function(this,jsonDoc)
        this:nm_ZBCallBack(jsonDoc,notReCtreate)
    end

	HttpLoaderEX.WaitRecall(loader,self,reCall)
end

function wnd_heroinfoClass:nm_ZBCallBack(jsonDoc,notReCtreate)
    local Result = tonumber (jsonDoc:GetValue("r"))
    if  Result ~= 0 then
        print("Result:",Result)
        if Result == 12 then
            Poptip.PopMsg(SData_Id2String.Get(3146),Color.red) 
        else
            Poptip.PopMsg(SData_Id2String.Get(3141),Color.red) 
        end
    else 
        print(self.wuju_flag,"nm_ZBCallBack",self.hujia_flag)
        local wuju = self.wuju_flag
        local hujia = self.hujia_flag   
        Poptip.PopMsg(SData_Id2String.Get(3140),Color.white)
        if not notReCtreate then 
            --self:InitEquip()           
        end  
        print(self.wujuinfo_flag,self.hujiainfo_flag)     
        self:InitBackpack()--更新背包信息
        if self.wujuinfo_flag == true then
            self.isFromXilianToInfo = true
            self:ShowWujuInfo(self.CurrEquipmentInfo)
            self:SetWidgetActive("gengti_btn/light",true)          
        elseif self.hujiainfo_flag == true then
            self.isFromXilianToInfo = true
            self:ShowHujiaInfo(self.CurrEquipmentInfo)
            self:SetWidgetActive("gengti_btn/light",true)           
        end
        self.wuju_flag = wuju
        self.hujia_flag = hujia
        if self.wuju_flag == true then
            self:ShowWuJuShuXing(_,self.CurrEquipmentShuxing)
        elseif  self.hujia_flag == true then
            self:ShowHuJiaShuXing(_,self.CurrEquipmentShuxing)
        end

        print(self.wuju_flag,"nm_ZBCallBack",self.hujia_flag)
		self:ShowShuXing()        
    end 
end

--更新背包信息
function wnd_heroinfoClass:InitBackpack()

    local equipInfo = wnd_heroinfo:GetBackpackEquipByID(SendData.equipID)
    local tp = equipInfo.sinfo[sdata_EquipData.I_Type]--装备类型
    local oldEquip = self:GetBodyEquip(tp)--位置上原来放的装备
    if oldEquip~=nil then
        local id = oldEquip.dyID
        oldEquip:Destroy()--销毁
        wnd_heroinfo:SetBodyEquip(tp,nil)

        --由于装备从身上卸下，刷新背包中这个装备的显示外观
        --local eInfo = DragDropCtrl:GetEquipInfo(EquipOwnerPanel.Backpack, oldEquip)
        local eInfo = wnd_heroinfo:GetBackpackEquipByID(id)
        if eInfo~=nil then
            eInfo.heroID = nil
            self:OnEquipOwnerChanged( eInfo  )
        end
    end

    --克隆出新装备信息，并进行必要修改
    local newEquip = equipInfo:Clone()
    newEquip.gameObject = equipInfo.gameObject
    newEquip.ownerPanel = EquipOwnerPanel.Body
    newEquip.heroID = self.firstID

    --背包中的装备所属英雄改变
    equipInfo.heroID = self.firstID

    --放入新装备
    --self:SetBodyEquip(tp,newEquip)

    --所属面板改变，对外观和一些组件属性做相应调整
    self:OnEquipOwnerChanged(newEquip)
    self:OnEquipOwnerChanged(equipInfo)

    self:InitEquip()
end



--装备卸载协议
function wnd_heroinfoClass:SendXZZBNetWork(notReCtreate)
    local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","ZBR")  
	jsonNM:Add ("hid", SendData.HeroID)
	jsonNM:Add ("eid", SendData.equipID)
	local loader = GameConn:CreateLoader(jsonNM,0) 

    --闭包传参给nm_ZBCallBack
    local reCall = function(this,jsonDoc)
        this:nm_XZZBCallBack(jsonDoc,notReCtreate)
    end

	HttpLoaderEX.WaitRecall(loader,self,reCall)
end

function wnd_heroinfoClass:nm_XZZBCallBack(jsonDoc,notReCtreate)
    local Result = tonumber (jsonDoc:GetValue("r"))
    if  Result ~= 0 then       
        Poptip.PopMsg("卸载失败！",Color.red) 
    else    
        Poptip.PopMsg("卸载成功！",Color.white)
--        if not notReCtreate then 
--            self:InitEquip()
--        end
        self:InitEquip()
        if self.wuju_flag then
            self:ShowWuJuShuXing(_,SendData.equipID)
        elseif self.hujia_flag then
            self:ShowHuJiaShuXing(_,SendData.equipID)
        end
		self:ShowShuXing()
        if SendData.equipID ~= self.CurrEquipmentInfo then
            return 
        end
        self:PlayXiezai_XC()       
    end 
end
--协程
function wnd_heroinfoClass:PlayXiezai_XC()
    StartCoroutine(self,self.PlayXiezai,{})--启动协程
end
--卸载装备后的播放动画
function wnd_heroinfoClass:PlayXiezai()
    --无仓库在界面，则关掉blur和bg_frame
    if self.wuju_flag == false and self.hujia_flag == false then
        self:SetWidgetActive("bg_frame",false)
        self.blurObj:PlayReverse()       
    end
    --卸载装备后将属性框弹回去
    if self.wujuinfo_flag == true or self.hujiainfo_flag == true then
        self.wujuinfo_flag = false
        self.hujiainfo_flag = false
        self.e_shuxing_pageObj[1]:PlayReverse()
        Yield(0.5)       
        self:SetWidgetActive("e_shuxing_page",false)
    end
     
    self.InfoToXilian = 0        
end

--一键穿戴协议
function wnd_heroinfoClass:SendZBYJNetWork(id)
    local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","ZBAC")  
	jsonNM:Add ("hid", id)
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.nm_ZBYJCallBack)
end

function wnd_heroinfoClass:nm_ZBYJCallBack(jsonDoc)
    local Result = tonumber (jsonDoc:GetValue("r"))
    if Result ~= 0 then 
        print("Result",Result)
        self.cmBtnChange:SetIsEnabled(true)--激活一键穿戴  
        Poptip.PopMsg(SData_Id2String.Get(5325),Color.red) 
    elseif Result == 0  then
        self.cmBtnChange:SetIsEnabled(true)--激活一键穿戴
        Poptip.PopMsg(SData_Id2String.Get(5324),Color.white) 
        self:InitEquip() 
		self:ShowShuXing()
    end
   
end

--遍历英雄列表得到装备的ID
function wnd_heroinfoClass:GetEquipInfo()
    local HeroList = {}
    local PlayerHeros = Player:GetHeros()
    for i = 1,#PlayerHeros do
        local temp = {}
        temp.Weapon = PlayerHeros[i]:GetAttr(HeroAttrNames.WuID)
        temp.Equip = PlayerHeros[i]:GetAttr(HeroAttrNames.FangID)
        table.insert(HeroList,temp) 
    end
    return HeroList   
end

----------------------------------------------------------------装备end--------------------------------------------------


function wnd_heroinfoClass:showHuoqu(obj,k)
	wnd_gainmethod:ShowData(1,k,self.firstID)
	wnd_gainmethod:Show()
end
--兑换刷新
function wnd_heroinfoClass:duihuanrefresh(k)
	print("wnd_heroinfoClass:duihuanrefresh(k)",k)
	if k == 1 then
		self:showStar()()
	elseif k == 2 then
		self :ShowShiBing()
	end

end
function wnd_heroinfoClass:shibingSX()
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","asx")  
	jsonNM:Add("hid",self.firstID) 
	jsonNM:Add("aid",self.MaHeroInfoList:Army()) 
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.bIsBing)
end
function wnd_heroinfoClass:bIsBing(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		self.SoldierXJ = self.SoldierXJ + 1 
		self :ShowShiBing()
		self:refresZDL() 
		--type==1代表升星
		wnd_success:showType(1) 
		wnd_success:Show() 
	elseif num == 1 then
		Poptip.PopMsg("资源不足~",Color.red)
	elseif num == 2 then
		Poptip.PopMsg("英雄等级不足~",Color.red)
	else
		Poptip.PopMsg("各种原因导致失败~",Color.red)
	end
end 
function wnd_heroinfoClass:OnGold()
    WndJumpManage:Jump(WND.Heroinfo,WND.Chongzhi)
end
---------------------------翻页---------------------------
function wnd_heroinfoClass:RunPage(gameObj,Type)
	local id = 0
	for k,v in pairs (self.heroList) do
		local m_Item = self.instance:FindWidget("center_bg/change_mask")
		local pageObj = m_Item:GetComponent(CMUITweener.Name)
		pageObj:ResetToBeginning()
		pageObj:PlayForward()	
		
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
			if Type == 0 then
				self.idd = tonumber (self.heroList[k-1]:GetAttr(HeroAttrNames.DataID))
			elseif Type == 1 then
				self.idd = tonumber (self.heroList[k+1]:GetAttr(HeroAttrNames.DataID))
			end
		end
	end
	StartCoroutine(self,self.fanyeShow,{})

end 
function wnd_heroinfoClass:fanyeShow()
	local t = 0.2--ifv(debug.IsDev(),0.1,2.0)
	while(t>0) do   
		Yield(0.1)
		t = t-0.1
	end
	self:OnHeroinfoClick(self.idd)
    self:InitEquip()
end
function wnd_heroinfoClass:HeroCountry(num)
	local str = 0
	if num == 1 then--"魏"
		str = 5339
	elseif num == 2 then--"蜀"
		str = 5340
	elseif num == 3 then--"吴"
		str = 5341
	elseif num == 4 then--"群雄"
		str = 5342
	end
	return str
end
function wnd_heroinfoClass:BuildStar(objItem,objGrid,Type)
local HeroOrS = {
	self.HeroXJ,
	self.SoldierXJ
}
local StarHave = {
	self.SXxing,
	self.SBxing
}

	local m_item = self.instance:FindWidget(objItem)
	if StarHave[Type] == false  then
		for k = 1, 8 do
			local newItem = GameObject.InstantiateFromPreobj(m_item,self.instance:FindWidget(objGrid))
			newItem:SetName("sta"..k)
		end
		if Type == 1 then 
			self.SXxing = true
		elseif Type == 2 then 
			self.SBxing = true
		end
	end
	for k = 1 ,8 do
		local obj = objGrid.."/sta"..k
		self:SetWidgetActive(obj,false)
		if k == tonumber(HeroOrS[Type]) or k < tonumber(HeroOrS[Type]) then
			self:SetWidgetActive(obj,true)
		end
	end
	local container = self.instance:FindWidget(objGrid)
	local cmTable = container:GetComponent(CMUIGrid.Name)
	cmTable:Reposition()
end

function wnd_heroinfoClass:OnJiNengClick(obj,isPress,i)	
	if isPress == false then return end
	self:SetWidgetActive("skillinfo_panel/skillinfo_widget/skillinfo_bg1",false)
	self:SetWidgetActive("skillinfo_panel/skillinfo_widget/skillinfo_bg2",false)
	print(self.skillTable[i])
	local Skills = SData_Skill.GetSkill(self.skillTable[i])
	local level = 0
	for k,v in pairs (self.heroList) do
		if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
			level = self.heroList[k]:GetSkillLevelByIndex(i)
		end
	end
	local str = ""
	local tabbtn_inactive = self.instance:FindWidget("jiNeng"..i)
	local posy = tabbtn_inactive:GetPosition().y
	if posy > (-0.1) then
		str = "skillinfo_bg1"
	else
		str = "skillinfo_bg2"
	end
	self:SetLabel(str.."/skill_name",Skills:Name())		
	local a = tostring(Skills:SkillNote())
	local strnore = self:returnjinengstr(a,level)
	self:SetLabel(str.."/skill_note",strnore)
	self:SetWidgetActive("skillinfo_panel/skillinfo_widget/"..str,true)

end 
function wnd_heroinfoClass:returnjinengstr(note,level)
	local table1 = {}
	for k = 1 ,#note do
		table1[k] = string.sub(note,k,k)
	end
	local list = {}
	for k = 1 ,#table1 do
		if table1[k] == "{" then
			if table1[k+1] ~= "}" then
				local str = ""
				for i = k ,#table1 do
					if table1[i] == "}" then
						table.insert(list,#list+1,str)
						break
					else
						str = str..table1[i]
						table.insert(table1,i,"|")
						table.remove(table1,i+1)		
					end
				end
			end 
		end
	end
	local str1 = ""
	for k = 1 ,#list do
		str1 =str1..list[k]
	end
	local v2array = string.split(str1,"{")
	local table2 = {}
	for k = 1 ,#v2array do
		local w = string.split(v2array[k],";")
		if w[1] ~= "" then
--	公式1 SkillEffect:GetHitPercent
--	公式2 SkillEffect:GetSkillHit
--	公式4 SkillEffect:GetEditAttrV
--	公式6 SkillEffect:Float3rdTriggerEnd_Lv
--	公式7 SkillEffect:TriggerEndLv
			local skilleff = SData_Skill.GetSkillEffect(tonumber( w[1]))
			if tonumber( w[2]) == 1 then--F$HitPercent*I16$GrowWithLvID
				table2[#table2+1] = math.floor(skilleff:GetHitPercent(level))
			elseif tonumber( w[2]) == 2 then--F$HitPercent*I16$GrowWithLvID
				table2[#table2+1] = skilleff:GetSkillHit(level)
			elseif tonumber( w[2]) == 3 then--总伤害（LV+1）-总伤害LV;总伤害公式=Wuli*公式1+公式2
				local baseWuli = 0
				for k,v in pairs (self.heroList) do
					if tonumber (self.heroList[k]:GetAttr(HeroAttrNames.DataID) ) == self.firstID then
						baseWuli = self.heroList[k]:GetWuli()--武力
						SkillsLevel = self.heroList[k]:GetSkillLevels()
					end
				end	
				local  bhp,bwuli = nil--基础技能被动属性
				local  qhp,qwuli = nil--装备属性
				if self:GetHeroAttr()~= nil then
					qhp,qwuli= SData_Hero.CalculationEquips(self:GetHeroAttr())
				end
				bhp,bwuli = SData_Hero.CalculateHeroBeidongSkillAttr(self.MaHeroInfoList,SkillsLevel) 
				local hp,wuli = ""
				if qwuli ~= nil and qwuli:GetAddV() ~= 0 then
					wuli = baseWuli + bwuli:GetAddV()+qwuli:GetAddV()
				else
					wuli = baseWuli + bwuli:GetAddV()
				end
				local a1 = wuli* math.floor(skilleff:GetHitPercent(level+1)*100) + skilleff:GetSkillHit(level+1)
				local a2 = wuli* math.floor(skilleff:GetHitPercent(level)*100) + skilleff:GetSkillHit(level)
				table2[#table2+1] =  math.floor(a1 - a2)
			elseif tonumber( w[2]) == 4 then--F$HitNo*I16$GrowWithLvID
				table2[#table2+1] = skilleff:GetEditAttrV(level)
			elseif tonumber( w[2]) == 5 then--总属性值（LV+1）-总属性值LV
				local b1 = skilleff:GetEditAttrV(level+1)
				local b2 = skilleff:GetEditAttrV(level)
				table2[#table2+1] =  math.floor(b1 - b2)
			elseif tonumber( w[2]) == 6 then--S$3rdTriggerEnd+I16$TriggerEndLv*(LV-1)
				table2[#table2+1] =  math.floor(skilleff:Float3rdTriggerEnd_Lv(level))
			elseif tonumber( w[2]) == 7 then--I16$TriggerEndLv
				table2[#table2+1] = skilleff:TriggerEndLv()
			end
		end
	end
	local table3 = {}
	for k = 1 ,#table1 do
		if table1[k] ~= "|" then
			table3[#table3+1] = table1[k]
		end
	end
	local m = 1
	for k = 1 ,#table3 do
		if table3[k] == "}" then
			if table3[k-1] and table3[k-1] ~= "{" then
				table3[k] = table2[m]
				m = m + 1
			end			
		end
	end
	local strs = ""
	for k = 1 ,#table3 do
		strs = strs..table3[k]
	end
	return strs
end
--实例即将被丢失
function wnd_heroinfoClass:OnLostInstance()
    --界面销毁，所有实例无条件清空
    self.BodyEquips = {} 

    self.BisJN = nil --是否在技能页
	self.JNItem = nil--技能item
	self.SXxing = nil--属性的星星
	self.SBxing = nil--士兵的星星
    self.bIsGengti = nil--对比数据
    self.wuju_flag = nil--控制武具仓库动画
    self.hujia_flag = nil--控制护甲仓库动画
    self.wujuinfo_flag = nil--控制武具信息动画
    self.hujiainfo_flag = nil--控制护甲信息动画
    self.shuxing1_flag = nil
    
    self.isCreateWujuAgain = nil-- 是否重新创建武具	
    self.isCreateHujiaAgain = nil-- 是否重新创建护甲

    self.isShuxinWuju = nil
    self.isShuxinHujia = nil




    self.backpackWujuObj = {}
    self.backpackHujiaObj = {}

    self.backpackWujuEquips = {}
    self.backpackHujiaEquips = {}

    self.isFromXilian = nil
    self.isFromXilianToInfo = nil

    self.CurrEquipmentInfo = nil--当前显示信息的装备
    self.CurrEquipmentShuxing = nil--当前仓库板子上显示的装备
    	

    --equipment_page
    self.equipment = nil
    self.equipmentObj = nil
    --e_shuxing_page
    self.e_shuxing_page = nil
    self.e_shuxing_pageObj = nil
    --blur
    self.blur = nil
    self.blurObj = nil
    --一键穿戴按钮
    self.changeObj = nil
    self.cmBtnChange = nil
    
    --武具按钮
    self.wujuObj = nil
    self.cmBtnWuju = nil
    --护甲按钮
    self.hujiaObj = nil
    self.cmBtnHujia = nil
    --加号
    self.plus01Obj = nil
    self.cmColorTweenPlus01 = nil
    --加号
    self.plus02Obj = nil
    self.cmColorTweenPlus02 = nil
    --一键穿戴边框
    self.yijianOutsideObj = nil
    self.cmAlphaTweenYijian = nil
    
    self.bodyWuju = nil
    self.bodyHujia = nil
    self.backpackWuju = nil
    self.backpackHujia =  nil

    self.wuju_panel = nil
    self.cmWuJuScrollView = nil
    self.hujia_panel = nil
    self.cmHuJiaScrollView = nil


    self.DragEquipMB = nil


    self.wuju_btn = nil
    self.hujia_btn = nil

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

return wnd_heroinfoClass.new
 

--endregion
