--region *.lua
--Date 20150901
--游戏场景
--Author Wenchuan
--[[
--场景卸载要做的事情
--清休闲动作播放timer
--]]
local cm_GameScene = class()

GameScene = nil --单例

function cm_GameScene:Start()
	GameScene = self
	
	--绑定登陆成功事件
	EventHandles.OnLoginSuccess:AddListener(self,self.OnLoginSuccess)
end


--登陆成功回调处理
function cm_GameScene:OnLoginSuccess(_)
	print("cm_GameScene:OnLoginSuccess")
	self:LoadLevel(1)--装载主城场景
end


function cm_GameScene:ParseTextureNode(xmlTextureNode)
	local re = {}
	re.texture = xmlTextureNode:GetAttribute("texture")
	re.xoffset = tonumber(xmlTextureNode:GetAttribute("xoffset") )
	
	re.bump = xmlTextureNode:GetAttribute("bump")--法线图
	
	local height = xmlTextureNode:GetAttribute("height")
	if (height~=nil) then re.height = tonumber(height) end
	
	local width = xmlTextureNode:GetAttribute("width")
	if (width~=nil) then re.width = tonumber(width) end
	
	local min_yoffset = xmlTextureNode:GetAttribute("min_yoffset")
	if (min_yoffset~=nil) then re.min_yoffset = tonumber(min_yoffset) end
	
	local max_yoffset = xmlTextureNode:GetAttribute("max_yoffset")
	if (max_yoffset~=nil) then re.max_yoffset = tonumber(max_yoffset) end
	
	local leftExtended = xmlTextureNode:GetAttribute("leftExtended")
	if (leftExtended~=nil) then re.leftExtended = tonumber(leftExtended) end
	
	local rightExtended = xmlTextureNode:GetAttribute("rightExtended")
	if (rightExtended~=nil) then re.rightExtended = tonumber(rightExtended) end
	
	return re;
end


function cm_GameScene:CreateBG(scene_commonPack,scene_packet,bgRootObjName,bgPresetName,bgInfo,zDepth)
	local foregroundObject = GameObject.Find(bgRootObjName)--获取游戏对象
	local foregroundPreset = scene_commonPack:Get(bgPresetName)--取得预置
	local foregroundTexture = scene_packet:GetTexture(bgInfo.texture)--取得纹理
	local txW,txH=foregroundTexture:GetSize()--取纹理尺寸
	local aspectRatio = txW/txH--宽高比
	local screenW,screenH = Application.GetScreenSize()--视口尺寸
	local showH = bgInfo.height * screenH --纹理显示高度
	local showW = showH * aspectRatio--纹理显示宽度
	local xs = 2.0/screenH * (1+(1 - self.bgViewPortY))
	
	
	local  foregroundWidth = bgInfo.width + bgInfo.rightExtended + bgInfo.leftExtended
	local pos_x = -bgInfo.leftExtended
	
	--[[while(pos_x<foregroundWidth) do
	local blockWidth = showW --单块宽度
	if(pos_x+blockWidth>foregroundWidth) then blockWidth = foregroundWidth-pos_x end --当超出设定尺寸时进行纠错
	
	--创建游戏物体
	local blockObj = GameObject.InstantiateFromPreobj(foregroundPreset,foregroundObject)
	blockObj:SetLocalPosition( Vector3.new(pos_x*xs -1,0,zDepth) )
	
	--设置缩放参数
	blockObj:SetLocalScale(  Vector3.new(blockWidth*xs,showH*xs,1) )
	
	--设置纹理
	local cmRenderer = blockObj:GetComponent(CMRenderer.Name)
	local mat = cmRenderer:GetMaterial()
	mat:SetMainTexture( foregroundTexture )
	
	--设置纹理的平铺次数
	mat:SetMainTextureScale( Vector2.new(blockWidth/showW,1) )
	
	--块位置递增
	pos_x=pos_x+blockWidth
end--]]

end




function cm_GameScene:CreateGround(scene_commonPack,scene_packet,groundInfo,scene_width,scene_height)
	local groundObject = GameObject.Find("/SceneRoot/Ground")--获取地面游戏对象
	local blockPreset
	print("当前游戏场景信息------------")
	
	local bumpTexture = nil
	if (groundInfo.bump~=nil and groundInfo.bump~="")
		then bumpTexture = scene_packet:GetTexture(groundInfo.bump)
	end
	
	if (bumpTexture==nil) then
		blockPreset = scene_commonPack:Get("GroundBlock")--取得地面块预置
	else
		blockPreset = scene_commonPack:Get("GroundBumpBlock")--取得带法线图的地面块预置
	end
	
	local blockTexture = scene_packet:GetTexture(groundInfo.texture)
	local blockPos_x = -groundInfo.leftExtended
	
	local front_height = 10--z0到摄像机之间，有个空当，进行填充
	
	local blockHeight = scene_height + front_height --单块高度和场景高一致
	
	local terrainWidth = scene_width + groundInfo.rightExtended + groundInfo.leftExtended
	
	while(blockPos_x<terrainWidth) do
		local blockWidth = 20 --单块宽度
		
		if(blockPos_x+blockWidth>terrainWidth) then blockWidth = terrainWidth-blockPos_x end --当超出场景尺寸时进行纠错
		
		--创建地面游戏物体
		local blockObj = GameObject.InstantiateFromPreobj(blockPreset,groundObject)
		blockObj:SetLocalPosition( Vector3.new(blockPos_x,0,-front_height) )
		--设置缩放参数
		blockObj:SetLocalScale(  Vector3.new(blockWidth,blockHeight,1) )
		
		--设置纹理
		local cmRenderer = blockObj:GetComponent(CMRenderer.Name)
		local mat = cmRenderer:GetMaterial()
		mat:SetMainTexture( blockTexture )--设置主纹理
		mat:SetMainTextureScale( Vector2.new(blockWidth/2,blockHeight/2) )  --设置主纹理的平铺次数
		
		if (bumpTexture~=nil) then
			mat:SetTexture("_Bump",bumpTexture) --设置法线纹理
			mat:SetTextureScale("_Bump", Vector2.new(blockWidth/2,blockHeight/2) )--设置法线图缩放
		end
		
		--块位置递增
		blockPos_x=blockPos_x+blockWidth
	end
end

function cm_GameScene:CreateOrnament(scene_packet)
	local OrnamentRoot = GameObject.Find("SceneRoot/Ornament")
	--PacketManage.GetPacket("scene_common")
	local ornamentTxt = scene_packet:GetText("ornament")
	if (ornamentTxt==nil) then  return end
	
	print("解释装饰配置")
	
	self.ornaments = {}
	
	local ornamentXml = XML.Parse(ornamentTxt)
	local ornamentNodes = ornamentXml:SelectNodes("xml/a")--取出装饰物配置信息数组
	
	for _,ornamentCfg in pairs(ornamentNodes) do
		
		local lgname = ornamentCfg:GetAttribute("lgname")
		local chance = ornamentCfg:GetAttribute("chance")
		local act = ornamentCfg:GetAttribute("act")
		local billboard = ornamentCfg:GetAttribute("billboard")
		
		local ornamentInfo = {}
		ornamentInfo.lgname = lgname
		
		ornamentInfo.chance = Vector2.FromString(chance)
		ornamentInfo.act = act
		
		if (ornamentInfo.chance==nil) then ornamentInfo.chance = Vector2.Zero() end
		ornamentInfo.billboard =  ifv(billboard~=nil,tonumber(billboard),0)
		
		table.insert(self.ornaments,ornamentInfo)--信息加入到列表
		
	end
	
	local mainCameraObject = GameObject.Find("/SceneRoot/SceneCamera")--获取场景渲染相机游戏对象
	local cm_Camera = mainCameraObject:GetComponent(CMCamera.Name)--获取相机组件
	
	--创建装饰物
	for _,ornamentInfo in pairs(self.ornaments) do
		local presetObj = scene_packet:Get(ornamentInfo.act)--取得预置
		local newObj = GameObject.InstantiateFromPreobj(presetObj,OrnamentRoot)
		
		if(ornamentInfo.billboard==1) then --绑定招牌版组件
			local cmBillboard = newObj:AddComponent(CMBillboard.Name)
			cmBillboard:SetCamera(cm_Camera)
		end
		if (ornamentInfo.lgname~=nil) then
			--绑定场景拖拽组件
			local scrollContainerDrag = newObj:AddComponent( CMScrollContainerDrag.Name )
			scrollContainerDrag:SetScrollContainer(self.sceneDragObj)
			
			--绑定高精度碰检组件
			newObj:AddComponent(CMHightAccuracyCollider.Name)
			
			--绑定点击事件
			local cm_uievt_click =  CMUIEvent.Go(newObj,UIEventType.PixelClick)
			cm_uievt_click:Listener(newObj,UIEventType.PixelClick,self,"OnOrnamentClick",ornamentInfo.lgname)
			
			local cm_uievt_press =  CMUIEvent.Go(newObj,UIEventType.PixelPress)
			cm_uievt_press:Listener(newObj,UIEventType.PixelPress,self,"OnOrnamentPress",ornamentInfo.lgname)
			
			
		end
		
		if(ornamentInfo.chance.x>0 and ornamentInfo.chance.y>0) then--这是一个有动作的装饰物
			
			Yield()--等待组件初始化完成
			
			ornamentInfo.cmAvatarAnimator = newObj:GetComponent( CMAvatarAnimator_Auto.Name )
			
			--用timer播放休闲动画
			self:OnOrnamentShowEnd(ornamentInfo)
		end
		
		ornamentInfo.obj = newObj
		
	end
end

function cm_GameScene:DelayPlayOrnamentShow(ornamentInfo)
	local showtime = math.random(ornamentInfo.chance.x,ornamentInfo.chance.y)
	ornamentInfo.timerHanel = TimeLine.StartTimer(showtime,self,self.OnOrnamentShowTimerReCall,ornamentInfo)
end

--播放show动画回调
function cm_GameScene:OnOrnamentShowTimerReCall(ornamentInfo)
	ornamentInfo.cmAvatarAnimator:Play("Show",false,false) --播放动画
	local showLen = ornamentInfo.cmAvatarAnimator:GetClipLength("Show")--取得动画长度
	--定时启动下一轮休闲动作播放
	ornamentInfo.timerHanel = TimeLine.StartTimer(showLen,self,self.OnOrnamentShowEnd,ornamentInfo)
end

--一个休闲动作播放完成
function cm_GameScene:OnOrnamentShowEnd(ornamentInfo)
	--播放站立动画
	ornamentInfo.cmAvatarAnimator:Play("Stand",true,true)
	
	--延迟播放休闲动画
	self:DelayPlayOrnamentShow(ornamentInfo)
end

--装饰物被点击
function cm_GameScene:OnOrnamentClick(gameObj,lgname)
	--高光效果？？！
	
	--抛出装饰物被点击事件
	EventHandles.OnOrnamentClick:Call( lgname )
end

--装饰物上按下或抬起触摸点
function cm_GameScene:OnOrnamentPress(gameObj,isPress,lgname)
	--print("OnOrnamentPress",lgname,isPress)
	
	local cmRender = gameObj:GetComponent( CMRenderer.Name )
	local mat = cmRender:GetMaterial()
	
	if (isPress) then
		self.lastOrnamentColor = mat:GetColor()
		local lightPower = 1.2--高光强度
		local lightColor = Color.new(self.lastOrnamentColor.r*lightPower,self.lastOrnamentColor.g*lightPower,self.lastOrnamentColor.b*lightPower,self.lastOrnamentColor.a)
		mat:SetColor(lightColor)
	else
		mat:SetColor( self.lastOrnamentColor )
	end
end

--构建测试军队
function cm_GameScene:BuildTestArmy()
	
	--创建预备军数据
	local L1 = self:BuildOneArmy(11021,1021,ArmyFlag.Attacker)
	local L2 = self:BuildOneArmy(11022,1022,ArmyFlag.Attacker)
	local L3 = self:BuildOneArmy(11023,1023,ArmyFlag.Attacker)
	local L6 = self:BuildOneArmy(11024,1024,ArmyFlag.Attacker)
	local L7 = self:BuildOneArmy(11025,1025,ArmyFlag.Attacker)
	
	local R1 = self:BuildOneArmy(11026,1026,ArmyFlag.Defender)
	local R2 = self:BuildOneArmy(11027,1027,ArmyFlag.Defender)
	local R4 = self:BuildOneArmy(11028,1028,ArmyFlag.Defender)
	local R5 = self:BuildOneArmy(11029,1029,ArmyFlag.Defender)
	local R6 = self:BuildOneArmy(11030,1030,ArmyFlag.Defender)
	print("cm_GameScene:BuildTestArmy#2")
	--预备军加入到列表
	self.PreArmys = {}
	table.insert(self.PreArmys,L1)
	table.insert(self.PreArmys,L2)
	table.insert(self.PreArmys,L3)
	table.insert(self.PreArmys,L6)
	table.insert(self.PreArmys,L7)
	print("cm_GameScene:BuildTestArmy#2.1")
	table.insert(self.PreArmys,R1)
	table.insert(self.PreArmys,R2)
	table.insert(self.PreArmys,R4)
	table.insert(self.PreArmys,R5)
	table.insert(self.PreArmys,R6)
	print("cm_GameScene:BuildTestArmy#2.2")
	--创建预备军阵型信息
	self.LeftFormation = Formation.new()
	print("cm_GameScene:BuildTestArmy#2.3")
	self.LeftFormation.zw = {L1.dyHeroID,L2.dyHeroID,L3.dyHeroID,-1,-1,L6.dyHeroID,L7.dyHeroID}
	print("cm_GameScene:BuildTestArmy#3")
	self.RightFormation = Formation.new()
	self.RightFormation.zw = {R1.dyHeroID,R2.dyHeroID,-1,R4.dyHeroID,R5.dyHeroID,R6.dyHeroID,-1}
	print("cm_GameScene:BuildTestArmy#4")
end

--构建一支军队
function cm_GameScene:BuildOneArmy(dyHeroID,staticHeroID,flag)
	local hInfo = SData_Hero.GetHeroData(staticHeroID)
	local Item1,Item2,Item3
	
	Item1 = nil
	Item2 = nil
	Item3 = nil
	
	if (hInfo~=nil) then
		Item1 = {sid=hInfo:Wuqi(),lv=1,xj=1}
		Item2 = {sid=hInfo:Hujia(),lv=1,xj=1}
		Item3 = {sid=hInfo:Ma(),lv=1,xj=1}
	end
	local attrs = {
	dyHeroID = dyHeroID,
	staticHeroID = staticHeroID,
	heroInfo = SData_Hero.GetMonsterData(staticHeroID),--读出英雄信息
	soldiersCount = 90,
	heroLevel = 5,
	sxj=1,
	hxj=1,
	sklv1=1,
	sklv2=1,
	sklv3=1,
	sklv4=1,
	sklv5=1,
	sklv6=1,
	--cd;//手动蓄力 lua层可选属性
	--hp;//当前生命 lua层可选属性
	zs=false,
	flag = flag,
	Item1 = Item1,  --武器
	Item2 = Item2,  --防具
	Item3 = Item3,  --坐骑
	}
	return attrs
end


function cm_GameScene:InsertAvatarPack(avatarPacks,actID)
	local actInfo = SData_AvatarAct.GetRow(actID)
	local actPackName = string.sformat("{0}{1:D3}",actInfo:GetActMB(),actInfo:GetActID() ) --一个动画的纹理包
	avatarPacks[actPackName] = 1--放入临时包队列，去重复
end

function cm_GameScene:coLoadLevel(sceneID)
	print("cm_GameScene:coLoadLevel")
	
	--装载场景资源，并创建出场景
	local packetLoader = PacketLoader.new()--创建一个包加载器
	local scenePackName = string.sformat("scene_{0:D2}",sceneID)--场景包名
	local needLoadPacks = {scenePackName,"scene_common"}--需要装载的包
	print("cm_GameScene:coLoadLevel #0")
	self:BuildTestArmy()--构建战斗测试数据
	print("cm_GameScene:coLoadLevel #0.1")
	--生成战场avatar依赖包
	local avatarPacks = {}
	for _,armyAttrs in pairs(self.PreArmys) do
		local heroInfo = armyAttrs.heroInfo
		
		--处理士兵资源包
		local armyInfo = SData_Army.GetRow(heroInfo:Army())
		self:InsertAvatarPack(avatarPacks,armyInfo:ActID())
		
		--处理士兵坐骑资源包
		if (armyInfo:ZuoqiID()>0) then
			self:InsertAvatarPack(avatarPacks,armyInfo:ZuoqiID())
		end
		
		--处理英雄资源包
		self:InsertAvatarPack(avatarPacks,heroInfo:ActID())
		
		--处理英雄坐骑资源包
		if(heroInfo:NPCZuoqiID()>0) then --优先显示配置表中的装备
			self:InsertAvatarPack(avatarPacks,heroInfo:NPCZuoqiID())
		else
			if(armyAttrs.Item3~=nil) then --存在坐骑装备
				local equipInfo = SData_equipdata.GetRow(armyAttrs.Item3.sid,armyAttrs.Item3.lv)
				self:InsertAvatarPack(avatarPacks,equipInfo:HouseAvatarID())
			end
		end
	end
	
	print("cm_GameScene:coLoadLevel #0.2")
	for actPackName,_ in pairs(avatarPacks) do
		table.insert(needLoadPacks,actPackName)--追加包到预加载列表
	end
	
	packetLoader:Start(needLoadPacks)--装载资源包
	
	print("cm_GameScene:coLoadLevel #0.3")
	while(not packetLoader:IsDone()) do
		if (packetLoader:HasError()) then
			debug.LogError("装载场景资源包遇到错误");
			Application.Quit();
		while(true) do  Yield() end
	end
	
	Yield()
end
print("cm_GameScene:coLoadLevel #1")
local scene_commonPack = PacketManage.GetPacket("scene_common")
local scene_packet = PacketManage.GetPacket(scenePackName)--取得场景资源包

local cfgtext = scene_packet:GetText("cfg")--取得场景配置
local cfgxml = XML.Parse(cfgtext)

local baseNode = cfgxml:SelectSingleNode("xml/Base")--width="100" height="50"
local scene_width = tonumber( baseNode:GetAttribute("width") )
local scene_height = tonumber( baseNode:GetAttribute("height") )
local bgViewPortY = tonumber( baseNode:GetAttribute("bgy") )
local sunColorStr = baseNode:GetAttribute("sunColor")
if(sunColorStr~=nil) then --设定太阳颜色
	local rgb = Vector3.FromString(sunColorStr)
	local suncolor = Color.new(rgb.x,rgb.y,rgb.z)
	--取得太阳游戏物体
	local sunObj = GameObject.Find("/SceneRoot/Sun")
	if (sunObj~=nil) then
		local cmLight = sunObj:GetComponent(CMLight.Name)
		cmLight:SetColor(suncolor)
	end
end
print("cm_GameScene:coLoadLevel #2")

local cameraNode = cfgxml:SelectSingleNode("xml/Camera")--near="0.1" far="100000" fov="59"
local camera_near = tonumber( cameraNode:GetAttribute("near") )
local camera_far = tonumber( cameraNode:GetAttribute("far") )
local camera_fov = tonumber( cameraNode:GetAttribute("fov") )

local groundInfo = self:ParseTextureNode( cfgxml:SelectSingleNode("xml/Ground") )
local foregroundInfo = self:ParseTextureNode( cfgxml:SelectSingleNode("xml/Foreground") )
local mediumShotInfo = self:ParseTextureNode( cfgxml:SelectSingleNode("xml/MediumShot") )
local perspectiveInfo = self:ParseTextureNode( cfgxml:SelectSingleNode("xml/Perspective") )

self.groundInfo = groundInfo
self.foregroundInfo = foregroundInfo
self.mediumShotInfo = mediumShotInfo
self.perspectiveInfo = perspectiveInfo
print("cm_GameScene:coLoadLevel #3")

self.bgViewPortY = bgViewPortY
self.SceneWidth = scene_width
self.SceneHeight = scene_height
self.foregroundWidth = foregroundInfo.width
self.mediumShotWidth = mediumShotInfo.width
self.perspectiveWidth = perspectiveInfo.width

CameraCtrl:SetBGViewPortY(bgViewPortY)--背景相机应用视口y参数
self:CreateGround(scene_commonPack,scene_packet,groundInfo,scene_width,scene_height) --创建地面
self:CreateBG(scene_commonPack,scene_packet,"/SceneRoot/Foreground","Foreground",foregroundInfo,60)--创建近景
self:CreateBG(scene_commonPack,scene_packet,"/SceneRoot/MediumShot","MediumShot",mediumShotInfo,90)--创建中景
self:CreateBG(scene_commonPack,scene_packet,"/SceneRoot/Perspective","Perspective",perspectiveInfo,100)--创建远景
self:CreateDrag(scene_width,scene_height) --创建场景拖拽控制器

--self:CreateOrnament(scene_packet)--创建装饰物

--设置fov
local mainCameraObject = GameObject.Find("/SceneRoot/SceneCamera")--获取场景渲染相机游戏对象
local cm_Camera = mainCameraObject:GetComponent(CMCamera.Name)--获取相机组件
cm_Camera:SetFieldOfView(57)
print("cm_GameScene:coLoadLevel #4")
--开始测试战斗
--self:TestFight()
print("cm_GameScene:coLoadLevel #5")
end


function cm_GameScene:TestFight()
	AI_Battlefield.Reset()
	--加入预备军
	for _,armyAttrs in pairs(self.PreArmys) do
		AI_Battlefield.AddPre(armyAttrs)
	end
	
	--设置双方阵型
	AI_Battlefield.SetLeftFormation(
	
	self.LeftFormation.zw[1],
	self.LeftFormation.zw[2],
	self.LeftFormation.zw[3],
	self.LeftFormation.zw[4],
	self.LeftFormation.zw[5],
	self.LeftFormation.zw[6],
	self.LeftFormation.zw[7],
	self.LeftFormation.zf
	)
	
	AI_Battlefield.SetRightFormation(
	self.RightFormation.zw[1],
	self.RightFormation.zw[2],
	self.RightFormation.zw[3],
	self.RightFormation.zw[4],
	self.RightFormation.zw[5],
	self.RightFormation.zw[6],
	self.RightFormation.zw[7],
	self.RightFormation.zf
	)
	--启动战斗
	AI_Battlefield.StartFight()
end

function cm_GameScene:CreateDrag(scene_width,scene_height)
	local sceneRoot = GameObject.Find("/SceneRoot")--获取场景根游戏对象
	--创建拖拽容器游戏物体
	self.sceneDragObj = GameObject.new("SceneDrag")
	self.sceneDragObj:SetParent(sceneRoot)
	
	--设置位置
	self.sceneDragObj:SetLocalPosition(Vector3.Zero())
	
	--设置缩放
	self.sceneDragObj:SetLocalScale(Vector3.new(1,1,1))
	
	
	local terrainWidth = scene_width + self.groundInfo.rightExtended + self.groundInfo.leftExtended
	
	--增加一个水平的包围盒
	local boxCollider = self.sceneDragObj:AddComponent(  CMBoxCollider.Name )
	boxCollider:SetCenter( Vector3.new(  -self.groundInfo.leftExtended + terrainWidth/2,0,scene_height/2)  )
	boxCollider:SetSize( Vector3.new(terrainWidth,0.001,scene_height) )
	
	--增加一个垂直的包围盒子
	local boxCollider = self.sceneDragObj:AddComponent(  CMBoxCollider.Name )
	boxCollider:SetCenter( Vector3.new(  -self.groundInfo.leftExtended + terrainWidth/2,0,scene_height)  )
	boxCollider:SetSize( Vector3.new(terrainWidth*2,99999,0.001) )
	
	--增加滚动容器组件
	local scrollContainer = self.sceneDragObj:AddComponent( CMScrollContainer.Name )
	
	--设置滚动容器参数
	scrollContainer:SetMomentum( Vector2.new(0.01,0.01) )--惯性
	scrollContainer:SetSpringSpeed( Vector2.new(5,5) )
	scrollContainer:SetSpringRange(1,1,1,1)--弹力范围
	scrollContainer:SetMargin(1,1,1,42)
	scrollContainer:SetScrollScale( Vector2.new(0.01,0.01) )
	scrollContainer:SetContainerSize( Vector2.new(1,20) )
	scrollContainer:SetDragFlip(SpriteFlip.Horizontally)--拖拽反转
	
	--增加滚动条目组件
	local scrollItem = self.sceneDragObj:AddComponent( CMScrollItem.Name )
	
	--设置滚动条目参数
	scrollItem:BindClass(CameraCtrl)
	--刷新滚动容器
	scrollContainer:Reposition()
end

--- <summary>
--- 装载一个关卡
--- </summary>
function cm_GameScene:LoadLevel(sceneID)
	print("cm_GameScene:LoadLevel")
	StartCoroutine(self,self.coLoadLevel,sceneID)
end

return cm_GameScene.new

--endregion
