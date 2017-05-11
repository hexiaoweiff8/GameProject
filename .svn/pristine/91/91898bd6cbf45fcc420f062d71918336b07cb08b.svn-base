--region *.lua
--Date 20151009
--关卡主界面
--Author Wenchuan

 

local wnd_guankaClass = class(wnd_base)

wnd_guanka = nil--单例


local VolumeST = {} --卷状态
VolumeST.Shrinking = 1--收缩中
VolumeST.Stretch = 2--展开中
VolumeST.Opened = 3--打开的
VolumeST.Closed = 4--关闭的

--判定某卷是否为当前关卡所在卷
function wnd_guankaClass:IsCurrGKJuan(juanID)
	local nextc,nextm = sdata_Mission:GetNextGK(PlayerData.data.CurrChapterID,PlayerData.data.CurrMissionID)
	local missionID = nextc*10+nextm
	local data = sdata_Mission:GetRow(missionID)
	if(data==nil) then return false end
	return (data[sdata_Mission.I__JuanID] == juanID)
end

--获取最大的当前可视卷ID
function wnd_guankaClass:GetMaxVisibleJuanID()
	local nextc,nextm = sdata_Mission:GetNextGK(PlayerData.data.CurrChapterID,PlayerData.data.CurrMissionID)
	local missionID = nextc*10+nextm
	local data = sdata_Mission:GetRow(missionID)
	if(data==nil) then
		data = sdata_Mission:GetRow(sdata_Mission:GetRow(PlayerData.data.CurrChapterID*10+PlayerData.data.CurrMissionID))
	end
	return data[sdata_Mission.I__JuanID]
end

function wnd_guankaClass:Start() 
	wnd_guanka = self
	self:Init(WND.GuanKa,false)
end


--有对象互访逻辑的初始化
function wnd_guankaClass:CrossInit() 
    
end
  
--缓存一些实例
function wnd_guankaClass:CacheInstance()
	self.mb_juanbg = {}
	self.mb_juanbg[1] = self.instance:FindWidget("mb_juanbg01")
	self.mb_juanbg[2] = self.instance:FindWidget("mb_juanbg02")
	self.mb_juanbg[3] = self.instance:FindWidget("mb_juanbg03")
	self.mb_juanbg[4] = self.instance:FindWidget("mb_juanbg04")

	self.mb_juan = self.instance:FindWidget("mb_juan")
	self.cityIcons = {}
	for i = 1,20 do 
		local iconName = string.sformat("gtb{0}",i)
		self.cityIcons[iconName] = self.instance:FindWidget( iconName )
	end

	self.ico_currMission = self.instance:FindWidget("currMission")
	self.ico_currMissionWidget = self.ico_currMission:GetComponent(CMUIWidget.Name)

	self.ico_Horse = self.instance:FindWidget("Horse")

	self.mb_chengitem = self.instance:FindWidget("mb_chengitem")
	self.mb_pathPoint = self.instance:FindWidget("mb_pathPoint")
	
	
	local bgObj = self.instance:FindWidget("bg")
	self.bgWidget = bgObj:GetComponent(CMUIWidget.Name)
	
	local mb_juanbgWidget = self.mb_juanbg[1]:GetComponent(CMUIWidget.Name)
	local mb_juanWidget = self.mb_juan:GetComponent(CMUIWidget.Name)
	 
	local mb_juanbgSize = mb_juanbgWidget:GetSize()
	local mb_juanSize = mb_juanWidget:GetSize()
end

--初始化实例
function wnd_guankaClass:OnNewInstance()
	self:CacheInstance()--缓存一些实例
	
	self.ScreenSize = self.bgWidget:GetSize()	
	self.xscale = self.ScreenSize.x/960 --水平方向缩放系数
	self.yscale = self.ScreenSize.y/640 --垂直方向缩放系数

	--绑定事件
    self:BindUIEvent("btn_close",UIEventType.Click,"OnCloseClick")

	--自动初始化数据
	if(PlayerData.data.volumeInfos == nil) then
		PlayerData.data.volumeInfos = {}
		local maxVolume = sdata_Mission.maxVolume 
		for currVolume = 1,maxVolume do
			local volumeAttr = {}
			volumeAttr.st = VolumeST.Closed
			volumeAttr.zsWidth = 1
			PlayerData.data.volumeInfos[currVolume] = volumeAttr
		end
	end

	--创建卷
	self:CreateVolume() 

	--[[
	w 0.0390625
	h 0.3125 
	--]]
end

function wnd_guankaClass:CreateVolume()   
	local ScreenHeight = math.INT(self.ScreenSize.y) 

	ScreenHeight = ScreenHeight+2 --修正浮点误差导致无法铺满屏幕

	local juanShouWidth = math.INT(80 * self.xscale)
	local juanShouSize = Vector2.new(juanShouWidth,ScreenHeight)--收起的卷尺寸
	local juanZhanSize = Vector2.new(math.INT(800 * self.xscale),ScreenHeight)--展开的卷尺寸
	local topY = -1--顶部y坐标
	local tmpUVOffset = Vector2.new(0,0)
	self.VolumeWidgets = {}

	local posx = 0
	local maxVolume = sdata_Mission.maxVolume 
	for currVolume = 1,maxVolume do
		local juanShou = GameObject.InstantiateFromPreobj(self.mb_juan,self.mb_juan:GetParent()) --克隆出收缩状态的卷
		local juanShouWidget = juanShou:GetComponent(CMUIWidget.Name)
		juanShou:SetActive(true)--激活对象
		
		juanShouWidget:SetSize(juanShouSize)--设置尺寸
		juanShou:SetLocalPosition(Vector3.new(posx,topY,0))--设置位置

		if(currVolume<25) then
			tmpUVOffset.y = 0
			tmpUVOffset.x = 0.00048828125 + 0.0390625*(currVolume-1)
		elseif(currVolume<30) then
			tmpUVOffset.y = 0.68798828125
			tmpUVOffset.x = 0.78466796875 + 0.0390625*(currVolume-25)
		else
			tmpUVOffset.y = 0.37060546875
			tmpUVOffset.x = 0.78466796875 + 0.0390625*(currVolume-30)
		end

		local juanShouUITexture = juanShou:GetComponent(CMUITexture.Name)
		juanShouUITexture:SetUVOffset(tmpUVOffset.x,tmpUVOffset.y)

		posx = posx+juanShouSize.x--递增x位置

		--生成卷属性，并添加到队列中
		local volumeAttr = {}
		volumeAttr.juanShou = juanShou
		volumeAttr.juanShouWidget = juanShouWidget
		self.VolumeWidgets[currVolume] = volumeAttr; 


		--绑定收缩卷点击事件
        local cmevt = CMUIEvent.Go(juanShou,UIEventType.Click)
		cmevt:Listener(juanShou,UIEventType.Click,self,"OnStretchVolumes",currVolume) 
	end


	self.juanShouSize = juanShouSize--收起的卷尺寸
	self.juanZhanSize = juanZhanSize--展开的卷尺寸
end

--展开一批卷
function wnd_guankaClass:OpenVolumes(volumeList,animationTime)
	if(animationTime<0.1) then
		self.coOpenVolumes({vl = volumeList,atime=animationTime}) --直接调用接口瞬间展开
	else
		StartCoroutine(self,self.coOpenVolumes,{vl = volumeList,atime=animationTime})--协程模式展开
	end
end

function wnd_guankaClass:CreateCitys(wInfo,juanID)
	local juanDepth = juanID*10 
	local pathPointDepth = juanDepth + 1
	local cityItemDepth = juanDepth + 2
	local cityIconDepth = juanDepth + 3
	local cityXingDepth = juanDepth + 4
	local winDepth = juanDepth + 5
	 
	local ownerObj = wInfo.juanZhan

	local tmpPos = Vector3.new()

	local nextc,nextm = sdata_Mission:GetNextGK(PlayerData.data.CurrChapterID,PlayerData.data.CurrMissionID)
	 

	--创建城池和路径
	wInfo.citys = {}
	local cityDatas = sdata_Mission:GetMissionsByJuanID(juanID)

	for _,cityData in pairs(cityDatas) do 
		local pic = cityData[sdata_Mission.I__MissionChengPic]
		local posx = cityData[sdata_Mission.I__MissionPicX]
		local posy = cityData[sdata_Mission.I__MissionPicY]
		local luxian = cityData[sdata_Mission.I__Luxian] 
		local missionName = cityData[sdata_Mission.I_MissionName]
		local chengItem = GameObject.InstantiateFromPreobj(self.mb_chengitem,ownerObj) 
		chengItem:SetActive(true)

		local chengIcon = GameObject.InstantiateFromPreobj(self.cityIcons[pic],chengItem)  
		local chengItem_Widget = chengItem:GetComponent(CMUIWidget.Name)
		local chengIcon_Widget = chengIcon:GetComponent(CMUIWidget.Name)

		local xings={}
		xings[1] = chengItem:FindChild("xing1")
		xings[2] = GameObject.InstantiateFromPreobj(xings[1],chengItem)
		xings[3] = GameObject.InstantiateFromPreobj(xings[1],chengItem) 
		local win = chengItem:FindChild("win")
		local nameLabel= chengItem:FindChild("nameLabel")
		local name= chengItem:FindChild("name")
		local nameWidget = name:GetComponent(CMUIWidget.Name)

		local xingWidgets={}
		xingWidgets[1] = xings[1]:GetComponent(CMUIWidget.Name)
		xingWidgets[2] = xings[2]:GetComponent(CMUIWidget.Name)
		xingWidgets[3] = xings[3]:GetComponent(CMUIWidget.Name)

		local win_Widget = win:GetComponent(CMUIWidget.Name)
		 
		
		--设置关卡名
		local cmNameLable = nameLabel:GetComponent(CMUILabel.Name)
		cmNameLable:SetValue(missionName) 
		local nameLableWidget = nameLabel:GetComponent(CMUIWidget.Name)

		--设置深度
		chengItem_Widget:SetDepth(cityItemDepth)
		chengIcon_Widget:SetDepth(cityIconDepth)
		win_Widget:SetDepth(winDepth)
		xingWidgets[1]:SetDepth(cityXingDepth)
		xingWidgets[2]:SetDepth(cityXingDepth)
		xingWidgets[3]:SetDepth(cityXingDepth)
		nameLableWidget:SetDepth(winDepth)
		nameWidget:SetDepth(winDepth)

		--适配位置
		tmpPos.x = posx * self.xscale
		tmpPos.y = -posy * self.yscale
		chengItem:SetLocalPosition(tmpPos)

		local chengItemSize = chengItem_Widget:GetSize()
		local chengIconSize = chengIcon_Widget:GetSize()
		tmpPos.x = (chengItemSize.x - chengIconSize.x)/2
		tmpPos.y = -(chengItemSize.y - chengIconSize.y)/2
		chengIcon:SetLocalPosition(tmpPos)
		 
		local winWidgetSize = win_Widget:GetSize()
		tmpPos.x = chengItemSize.x/2
		tmpPos.y = -chengItemSize.y + winWidgetSize.y/2
		win:SetLocalPosition(tmpPos) 
		local xingSize = xingWidgets[1]:GetSize()
		local xjg = xingSize.x
		tmpPos.y = -chengItemSize.y
		tmpPos.x = (chengItemSize.x - xjg*2 - xingSize.x*3 )/2 +  xingSize.x/2
		xings[1]:SetLocalPosition(tmpPos) 
		tmpPos.x = tmpPos.x + xingSize.x+xjg
		xings[2]:SetLocalPosition(tmpPos)

		tmpPos.x = tmpPos.x + xingSize.x+xjg
		xings[3]:SetLocalPosition(tmpPos) 
		 
		--创建路径
		local pathObjs = {}
		local luxianstr = cityData[sdata_Mission.I__Luxian]
		local pointsStr = string.split(luxianstr,";")
		for _,point_s in pairs(pointsStr) do 
			 local pointxy = string.split(point_s,",") 
			 tmpPos.x = (tonumber(pointxy[1])- posx) *self.xscale 
			 tmpPos.y = -(tonumber(pointxy[2])- posy) *self.yscale  

			 local pointObj = GameObject.InstantiateFromPreobj(self.mb_pathPoint,chengItem)--ownerObj
			 pointObj:SetActive(true)
			 pointObj:SetLocalPosition(tmpPos) 

			 local cmPointWidget = pointObj:GetComponent(CMUIWidget.Name)
			 cmPointWidget:SetDepth(pathPointDepth)

			 table.insert(pathObjs,pointObj)
		end 
		local cityWidgets = {}
		cityWidgets.Item_Widget = chengItem_Widget
		cityWidgets.Item = chengItem
		cityWidgets.PathObjs = pathObjs
		wInfo.citys[cityData[sdata_Mission.I_ID]] = cityWidgets

		--显隐处理
		local cid = cityData[sdata_Mission.I_ChapterID]
		local mid = cityData[sdata_Mission.I_MissionID] 
		if(not sdata_Mission:IsWin(cid,mid)) then--未胜利的关卡 
			win:SetActive(false)--隐藏胜利标记

			--隐藏星星
			xings[1]:SetActive(false)
			xings[2]:SetActive(false)
			xings[3]:SetActive(false)

			
			if(cid~=nextc or mid~=nextm) then --不是当前关 
				chengItem:SetActive(false)--隐藏掉整个城池item
			else --当前关
				for _,pathObj in pairs(pathObjs) do pathObj:SetActive(false) end  --隐藏掉路径
			end
		end  
	end 
end

function wnd_guankaClass:coOpenVolumes(param)
	--锁定用户操作

	local volumeList = param.vl
	local animationTime = param.atime

	--获取星评信息
	for _,juanID in pairs(volumeList) do 
		local juanAttr = PlayerData.data.volumeInfos[juanID]
		if(juanAttr.XingPingInfo == nil) then
			--请求获取星评信息

			--等待星评信息获取完成

			--填充星评信息
		end
	end  

	
	for _,juanID in pairs(volumeList) do 
		local wInfo = self.VolumeWidgets[juanID]
		local dInfo = PlayerData.data.volumeInfos[juanID]

		--自动创建展开的界面
		if(wInfo.juanZhan == nil) then
			local mb_juanbg = self.mb_juanbg[(juanID-1)%4+1]
			wInfo.juanZhan = GameObject.InstantiateFromPreobj(mb_juanbg,mb_juanbg:GetParent()) --克隆出展开状态的卷
			wInfo.juanZhan:SetActive(true)

			wInfo.juanZhanWidget = wInfo.juanZhan:GetComponent(CMUIWidget.Name)
			wInfo.juanZhanWidget:SetSize(  self.juanZhanSize ) 

			local juanDepth = juanID*10
			wInfo.juanZhanWidget:SetDepth(juanDepth)

			--创建城池和路径
			self:CreateCitys(wInfo,juanID) 

			--处理当前关特效
			if(self:IsCurrGKJuan(juanID)) then
				local nextc,nextm = sdata_Mission:GetNextGK(PlayerData.data.CurrChapterID,PlayerData.data.CurrMissionID) 

				local cityInfo = wInfo.citys[nextc*10+nextm]
				local ownerCityItem = cityInfo.Item
				local ownerCityWidget = cityInfo.Item_Widget 
				self.ico_currMission:SetActive(true)
				self.ico_currMission:SetParent(ownerCityItem) 
				--特效位置适配 
				local cityItemSize = ownerCityWidget:GetSize() 
				local txPos = Vector2.new(
											(cityItemSize.x)/2,
											-(cityItemSize.y)/2-20
											) 
				self.ico_currMission:SetLocalPosition( txPos ) 
			end
		end

		--激活展开的界面
		wInfo.juanZhan:SetActive(true)
		
		if(dInfo.st~=VolumeST.Opened) then 
			--设置展开状态的控件尺寸
			if(dInfo.st ~= VolumeST.Stretch and dInfo.st ~= VolumeST.Shrinking) then 
				dInfo.zsWidth = 1
			end 

			dInfo.tweenStartWidth = dInfo.zsWidth  
			dInfo.st = VolumeST.Stretch--设置展开状态
		end
	end

	--演示展开动画
	local tmpSize = Vector2.new(1,self.juanZhanSize.y)
	local tmpPos = Vector3.new(0,-1,0)
	local _lostTime = 0 
	while(true) do 
		if(animationTime<0.1) then--瞬间展开
			_lostTime = animationTime+0.1
		else--逐渐展开
			Yield() --交出控制权
			_lostTime = _lostTime+Time.deltaTime()--时间递增
		end

		local lostTime = _lostTime
		if(lostTime>animationTime) then lostTime = animationTime end --矫正时间

		for _,juanID in pairs(volumeList) do 
			local wInfo = self.VolumeWidgets[juanID]
			local dInfo = PlayerData.data.volumeInfos[juanID]
			if(dInfo.st == VolumeST.Stretch) then
				local t = lostTime/animationTime
				dInfo.zsWidth = math.lerp( dInfo.tweenStartWidth,self.juanZhanSize.x, t )

				wInfo.juanShouWidget:SetAlpha( 1-t ) --设置收缩的卷透明度

				if(t>0.9999) then 
					wInfo.juanShou:SetActive(false) 
					dInfo.st = VolumeST.Opened	
				end --动画结束时完全隐藏掉收缩的卷
			end
		end

		--重设所有卷的位置
		local posx = 0
		local maxVolume = sdata_Mission.maxVolume 
		for juanID = 1,maxVolume do
			local wInfo = self.VolumeWidgets[juanID]
			local dInfo = PlayerData.data.volumeInfos[juanID]

			 
			local juanShouW = wInfo.juanShouWidget:GetSize().x

			if(dInfo.st == VolumeST.Stretch or dInfo.st == VolumeST.Shrinking) then 
				tmpPos.x = posx + dInfo.zsWidth - juanShouW
				wInfo.juanShou:SetLocalPosition( tmpPos )--设置标签位置
			end

			if(dInfo.st == VolumeST.Closed) then
				tmpPos.x = posx 
				wInfo.juanShou:SetLocalPosition( tmpPos )--设置标签位置
			end 

			if(dInfo.st == VolumeST.Stretch or dInfo.st == VolumeST.Shrinking or dInfo.st == VolumeST.Opened) then
				tmpPos.x = posx 
				wInfo.juanZhan:SetLocalPosition( tmpPos )--设置背景图位置
			end



			if(dInfo.st == VolumeST.Closed) then
				posx=posx+juanShouW--标签尺寸作为本卷宽度
			elseif(dInfo.st == VolumeST.Opened) then
				posx=posx+wInfo.juanZhanWidget:GetSize().x --背景尺寸作为本卷宽度
			else
				posx=posx+dInfo.zsWidth--运动中的宽度 
			end 
		end
		 
		--判断终止条件
		if(_lostTime>=animationTime) then break end
	end


	--视角切换到列表中的第一个卷位置

	--解锁用户操作
end

--关闭按钮被点击
function wnd_guankaClass:OnCloseClick(gameObj)
    self:Hide()
end

function wnd_guankaClass:OnStretchVolumes(gameObj,volumeID)
	if(volumeID>self:GetMaxVisibleJuanID()) then return end --当前还未开放
	self:OpenVolumes({volumeID},0.3)
end
 
--实例即将被丢失
function wnd_guankaClass:OnLostInstance()
	if(PlayerData.data.volumeInfos ~= nil) then
		for _,volumeAttr in pairs(PlayerData.data.volumeInfos) do 
			volumeAttr.st = VolumeST.Closed
		end
	end
end 

--显示完成
function wnd_guankaClass:OnShowDone()
end 
 
return wnd_guankaClass.new


--endregion
