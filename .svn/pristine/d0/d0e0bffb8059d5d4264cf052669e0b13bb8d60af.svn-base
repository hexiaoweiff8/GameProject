
local wnd_playerinfoClass = class(wnd_base)

wnd_playerinfo = nil--单例

local bTn_Info = {
	changeHead = 1,
	changeName = 2,
	Noice = 3,
	Kefu = 4,
	GameSetting = 5,
	Exit = 6,
}

function wnd_playerinfoClass:Start() 
	wnd_playerinfo = self
	self:Init(WND.Playerinfo)

	self.bIslistenmoney = false --金币铜币监听标记
end
function wnd_playerinfoClass:OnNewInstance()
	self.table3 = {}
	self:SetLabel ("btn_txchang/txt_txchange",SData_Id2String.Get(5215))--更改头像
	self:SetLabel ("pic_kefu1/txt_notice",SData_Id2String.Get(5217))--客服
	self:SetLabel ("pic_notice1/txt_notice",SData_Id2String.Get(5218))--公告
	self:SetLabel ("pic_xgnc1/txt_xgnc",SData_Id2String.Get(5219))--修改昵称
	self:SetLabel ("btn_yxsz/txt_yxsz",SData_Id2String.Get(5220))--游戏设置
	self:SetLabel ("btn_tcdl/txt_tcdl",SData_Id2String.Get(5221))--退出登录
	self:SetLabel ("btn_txt1",SData_Id2String.Get(5222))--服务条款
	self:SetLabel ("btn_txt2",SData_Id2String.Get(5223))--游戏许可及服务协议
	self:SetLabel ("btn_txt3",SData_Id2String.Get(5224))--隐私政策

	self:BindUIEvent ("btn_xgnc", UIEventType.Click, "OnClick",bTn_Info.changeName)  --修改昵称
	self:BindUIEvent ("btn_yxsz", UIEventType.Click, "OnClick",bTn_Info.GameSetting) --游戏设置
	self:BindUIEvent ("btn_txchang", UIEventType.Click, "OnClick",bTn_Info.changeHead) --更换头像
	self:BindUIEvent ("pic_kefu", UIEventType.Click, "OnClick",bTn_Info.Kefu) --客服
	self:BindUIEvent ("btn_back", UIEventType.Click, "OnBack") --返回
	self:BindUIEvent ("btn_tcdl", UIEventType.Click, "OncloseBack") --退出登录
	
    --玩家头像
    local m_H = self.instance:FindWidget("diban_shensexinxi/pic_head")
    --获取2d精灵组件
    self.pHead = m_H:GetComponent(CMUISprite.Name)
    --选中头像光标
    self.txtableLight = self.instance:FindWidget("headchangtuozhuai/yyytx01tx")

end
function wnd_playerinfoClass:OncloseBack() 
	GameCookies.SaveLoginInfo(nil,nil,nil)
	self:Hide()
	wnd_login:Show()
end
function wnd_playerinfoClass:OnShowDone()
	local uiTween = self.instance:FindWidget("btn_back/diban_xinxibeijing")
	local pageObj = uiTween:GetComponent(CMUITweener.Name)
	pageObj:ResetToBeginning()
	pageObj:PlayForward()
	local each_func = function(key,row)
		if row[sdata_NormalHead.I_ID] == Player:GetNumberAttr(PlayerAttrNames.FaceIndex) then

			self.pHead:SetAtlas(row[sdata_NormalHead.I_PackageName], row[sdata_NormalHead.I_AtlasName])
			self.pHead:SetSpriteName(row[sdata_NormalHead.I_Skin])
		end
	end
	sdata_NormalHead:Foreach(each_func)
----	self:GetDotHave()
	local viplv = tonumber(Player:GetNumberAttr(PlayerAttrNames.CZLJCS))
	self:SetLabel ("pic_vipdi/txt_vip",sdata_VIP:GetV(sdata_VIP.I_Xunjue,viplv))
	self:SetLabel ("diban_shensexinxi/txt_playername",Player:GetAttr(PlayerAttrNames.Name))
	self:callbackFunc()
	if not self.bIslistenmoney then
		OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Gold,self,self.callbackFunc)
		OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Copper,self,self.callbackFunc)
		self.bIslistenmoney = true
	end

	self:SetLabel ("txt_ID","ID : "..Player:GetAttr(PlayerAttrNames.id))
--	local GJ = sdata_OfflicalRank:GetV(sdata_OfflicalRank.I_OfflicalName,tonumber(Player:GetNumberAttr(PlayerAttrNames.GJID)))
--	self:SetLabel ("txt_guanzhi","官阶 ："..GJ)
	self:SetLabel ("pic_lv/txt_lv",Player:GetNumberAttr(PlayerAttrNames.Level))

end 
function wnd_playerinfoClass:callbackFunc()
	if wnd_playerinfo.isVisible == false then 
		return 
	end 
	self:SetLabel ("diban_tongbi/txt_tongbinum",Player:GetNumberAttr(PlayerAttrNames.Copper))
	self:SetLabel ("diban_jinbi/txt_jinbinum",Player:GetNumberAttr(PlayerAttrNames.Gold))
end

function  wnd_playerinfoClass:OnClick(gameObj,bTn)
	if bTn == bTn_Info.changeName then	
		self:SetWidgetActive("diban_namechangebantou",true)	
		self:SetLabel ("diban_namechange/txt_zysx",SData_Id2String.Get(5225))
		self:SetLabel ("btn_cancel/txt_sfghnc",SData_Id2String.Get(5058))
		self:SetLabel ("btn_sfghnc/txt_sfghnc",SData_Id2String.Get(5089))
		self:BindUIEvent ("btn_sfghnc", UIEventType.Click, "ChangeName")
		self:BindUIEvent ("btn_cancel", UIEventType.Click, "BackToInfo","diban_namechangebantou")
		self:BindUIEvent ("diban_namechangebantou", UIEventType.Click, "BackToInfo","diban_namechangebantou")
--		self:BindUIEvent ("diban_namechangebantou", UIEventType.Click, "BackToInfo","diban_namechangebantou")	
	elseif bTn == bTn_Info.GameSetting then
		self:SetLabel ("pic_xsztitle/txt_yxsztitle",SData_Id2String.Get(5220))
		self:SetLabel ("pic_sy/txt_zhuyinliang",SData_Id2String.Get(5226))
		self:SetLabel ("txt_yinxiao",SData_Id2String.Get(5227))
		self:SetLabel ("pic_sytitle/txt_shengyin",SData_Id2String.Get(5228))
		self:SetLabel ("pic_musicon/txt_open",SData_Id2String.Get(5229))
		self:SetLabel ("pic_musicoff/txt_close",SData_Id2String.Get(5230))
		self:SetLabel ("pic_soundon/txt_open",SData_Id2String.Get(5229))
		self:SetLabel ("pic_soundoff/txt_close",SData_Id2String.Get(5230))
		self:SetLabel ("pic_phtitle/txt_shengyin",SData_Id2String.Get(5231))
		self:SetLabel ("pic_ph/txt_huazhi",SData_Id2String.Get(5232))
		self:SetLabel ("pic_ph/txt_di",SData_Id2String.Get(5233))
		self:SetLabel ("pic_ph/txt_zhong",SData_Id2String.Get(5234))
		self:SetLabel ("pic_ph/txt_gao",SData_Id2String.Get(5235))
		self:SetLabel ("Sprite/Label",SData_Id2String.Get(5236))



		self:SetWidgetActive("diban_shezhibantou",true)
        local musicVolume = UserDatas.GetUserData("music")
        if musicVolume==nil or musicVolume == "" then
            self:Setmusic(obj,1)
        else
            self:Setmusic(obj,tonumber(musicVolume))
        end

        local soundVolume = UserDatas.GetUserData("sound")
        if soundVolume==nil or soundVolume == "" then
            self:SetSound(obj,1)
        else
            self:SetSound(obj,tonumber(soundVolume))
        end

        self:BindUIEvent ("diban_shezhibantou", UIEventType.Click, "BackToInfo","diban_shezhibantou")	
        --音乐
		self:BindUIEvent ("btn_music_open", UIEventType.Click, "Setmusic",0)	
		self:BindUIEvent ("btn_music_close", UIEventType.Click, "Setmusic",1)	
        --音效
        self:BindUIEvent ("btn_sound_open", UIEventType.Click, "SetSound",0)	
		self:BindUIEvent ("btn_sound_close", UIEventType.Click, "SetSound",1)	
        --剧情
		self:BindUIEvent ("drama_btn", UIEventType.Click, "ShowJuqing")	

	elseif bTn == bTn_Info.changeHead then
		self:SetLabel ("diban_yyytitle/txt_yyytitle",SData_Id2String.Get(5237))
		self:SetLabel ("diban_hmytitle/txt_hmytitle",SData_Id2String.Get(5238))
		self:SetLabel ("diban_hdtitle/txt_hdtitle",SData_Id2String.Get(5239))
		self:SetWidgetActive("diban_headchangebantou",true)
		local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","ReFaceList")  
		local loader = GameConn:CreateLoader(jsonNM,0) 
		HttpLoaderEX.WaitRecall(loader,self,self.NM_ReGetHDList)
	elseif bTn == bTn_Info.Kefu then
		self:SetLabel ("title/txt",SData_Id2String.Get(5217))
		self:SetLabel ("txt_kefuxx1",SData_Id2String.Get(5240))
		self:SetLabel ("txt_kefuxx2",SData_Id2String.Get(5241))
		self:SetLabel ("txt_kefuxx3",SData_Id2String.Get(5242))
		self:SetLabel ("txt_kefuxx4",SData_Id2String.Get(5243))
		self:SetLabel ("txt_kefuclose",SData_Id2String.Get(5031))
		self:SetWidgetActive("diban_kefubantou",true)
		self:BindUIEvent ("btn_kefuclose", UIEventType.Click, "BackToInfo","btn_kefuclose")
	else
	end
end
--show剧情
function wnd_playerinfoClass:ShowJuqing()	
	local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","Gpolt")  
	local loader = GameConn:CreateLoader(jsonNM,0)
	HttpLoaderEX.WaitRecall(loader,self,self.NM_juqingCallBack)
end
function wnd_playerinfoClass:NM_juqingCallBack(jsonDoc)
	wnd_Storybooks:FillData(jsonDoc)
	wnd_Storybooks:Show()
end	
function wnd_playerinfoClass:SetSound(obj,one)	
	print("wnd_playerinfoClass:SetSound",one)
--背景音乐（主音量）
	local object1 = ""
	if one == 0 then 
		object1 = "btn_sound_close"
		QKGameSetting.SetVolume(0)
        UserDatas.SetUserData("sound",0)
	elseif one == 1 then 
		object1 = "btn_sound_open"
		QKGameSetting.SetVolume(1)
        UserDatas.SetUserData("sound",1)
	end
	local Sound = self.instance:FindWidget(object1)
	local cmAttributePage = Sound:GetComponent(CMUIAttributePage.Name)
	cmAttributePage:SetActivity() 
--音效
end

function wnd_playerinfoClass:Setmusic(obj,one)	
	print("3##########",one)
--背景音乐（主音量）
	local object1 = ""
	if one == 0 then 
		object1 = "btn_music_close"
		BackgroundMusicManage.SetVolume(0)
        UserDatas.SetUserData("music",0)
	elseif one == 1 then 
		object1 = "btn_music_open"
		BackgroundMusicManage.SetVolume(1)
        UserDatas.SetUserData("music",1)
	end
	local BackgroundMusic = self.instance:FindWidget(object1)
	local cmAttributePage = BackgroundMusic:GetComponent(CMUIAttributePage.Name)
	cmAttributePage:SetActivity() 
--音效
end
function wnd_playerinfoClass:NM_ReGetHDList(jsonDoc)	
	local i = 1
	local HDList = {}
	self.HDtable = jsonDoc:GetValue("TF")
	local rankFunc = function(id,X)
		self.table3[i] = tostring(X)
		i = i + 1 
    end
    self.HDtable:Foreach(rankFunc)
	self:CreateHeads()
	self:BindUIEvent ("diban_headchangebantou", UIEventType.Click, "BackToInfo","diban_headchangebantou")
end
--创建头像列表
function wnd_playerinfoClass:CreateHeads()

	--获得三个容器
	local  container_array = {
		self.instance:FindWidget("ketuozhuai/yyygrid"),--已有头像
		self.instance:FindWidget("hmyketuozhuai/hmygrid"),--武将头像容器
		self.instance:FindWidget("hdketuozhuai/hmygrid"),--活动头像容器

	}
	--获得头像模板
	local m_Item = self.instance:FindWidget("yyygrid/yyytx01")
	local i = 1
	local PlayerHead = {}
	--已拥有头像
	local HaveHead = {}
	local each_func = function(key,row)
		if row[sdata_NormalHead.I_Type] == 1 then
			table.insert(HaveHead,#HaveHead+1,row[sdata_NormalHead.I_ID])
		end
	end
	sdata_NormalHead:Foreach(each_func)
	local list = Player:GetHeros()
	for k,v in pairs (list)do
		local each_func = function(key,row)	
			if row[sdata_NormalHead.I_Skin] == SData_Hero.GetHero(list[k]:GetAttr(HeroAttrNames.DataID)):HeroFace() then
				table.insert(HaveHead,#HaveHead+1,row[sdata_NormalHead.I_ID])
			end	
		end
		sdata_NormalHead:Foreach(each_func)
	end
	table.insert(PlayerHead,1,HaveHead)
--武将头像
	local HeroHead = self:GetDotHave()
	table.insert(PlayerHead,2,HeroHead)
--活动头像
	table.insert(PlayerHead,3,self.table3)
--创建列表头像
	for i = 1, #PlayerHead do
		for k ,v in pairs (PlayerHead[i])do
			local newItem = GameObject.InstantiateFromPreobj(m_Item,container_array[i])
			newItem:SetName("head"..tonumber(v))
			local pHead = newItem:GetComponent(CMUISprite.Name)
			pHead:SetAtlas(sdata_NormalHead:GetV(sdata_NormalHead.I_PackageName,tonumber(v)), sdata_NormalHead:GetV(sdata_NormalHead.I_AtlasName,tonumber(v)))
			pHead:SetSpriteName(sdata_NormalHead:GetV(sdata_NormalHead.I_Skin,tonumber(v)))
			newItem:SetActive(true)
			if i == 1 then
				self.type = i	
				self:BindUIEvent ("head"..v, UIEventType.Click, "OnchClick1",v)				
			elseif  i == 2 then
				self:BindUIEvent ("head"..v, UIEventType.Click, "OnchClick2",v)		
			elseif  i == 3 then
				self.type = i	
				self:BindUIEvent ("head"..v, UIEventType.Click, "OnchClick1",v)	
			end
			self:BindUIEvent ("cancel_btn", UIEventType.Click, "BackToInfo","diban_headchangebantou")
		end
	end

--	重排容器内的头像
	for i = 1,3 do
		local container = container_array[i]
		local cmGrid = container:GetComponent(CMUIGrid.Name)
		cmGrid:Reposition()
	end

	--重排容器位置
	local txtable = self.instance:FindWidget("headchangtuozhuai/yyytable")
	local cmTable = txtable:GetComponent(CMUITable.Name)
	cmTable:Reposition()

	local ItemPosition = self.instance:FindWidget("head"..Player:GetNumberAttr(PlayerAttrNames.FaceIndex)):GetPosition()
	
	self.txtableLight:SetPosition(ItemPosition)
	self:SetWidgetActive("yyytx01tx",true)	

end
function wnd_playerinfoClass:OnchClick2(gameObj,id)	

end
function wnd_playerinfoClass:OnchClick3(gameObj,id)	

end
--从系统设置返回的回调
function wnd_playerinfoClass:BackToInfo(gameObj,str)
	if str == "diban_namechangebantou" then
		self:SetWidgetActive("diban_namechangebantou",false)
	elseif str == "diban_shezhibantou" then
		self:SetWidgetActive("diban_shezhibantou",false)
	elseif str == "diban_headchangebantou" then
		local each_func = function(key,row)
			local tp = row[sdata_NormalHead.I_ID] 
			if(self.instance:FindWidget("head"..tp)~=nil) then
				self.instance:FindWidget("head"..tp):Destroy() --销毁实例
			end
		end
		sdata_NormalHead:Foreach(each_func)
		self:SetWidgetActive("diban_headchangebantou",false)
	elseif str == "btn_kefuclose" then
		self:SetWidgetActive("diban_kefubantou",false)
	end
	
--	self:SetWidgetActive(str,false)
--	self:SetWidgetActive("info_page",true)
end
--------------------------修改头像----------------------------
function wnd_playerinfoClass:OnchClick1(gameObj,id)	
	self.idx = id
	local ItemPosition = self.instance:FindWidget("head"..id):GetPosition()
	
	self.txtableLight:SetPosition(ItemPosition)
	local m_Head = self.instance:FindWidget("head"..id)
	local Head = m_Head:GetComponent(CMUISprite.Name)
	local m_skin = Head:GetSpriteName()
	self:SetWidgetActive("yyytx01tx",true)	
	self:BindUIEvent ("define_btn", UIEventType.Click, "OnBoxClose")
	--MsgBox.Show("是否确定修改头像?","否","是",self,self.OnBoxClose)

end
function wnd_playerinfoClass:OnBoxClose()	
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","ReFaceidx")  
	jsonNM:Add("faceidx",self.idx)  
	jsonNM:Add("t",self.type)  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReFace)
end

function wnd_playerinfoClass:NM_ReFace(jsonDoc)	
	
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 1 then
		Poptip.PopMsg("修改失败1~",Color.red)
	elseif num == 2 then
		Poptip.PopMsg("修改失败~",Color.red)
	elseif num == 0 then

		self.pHead:SetAtlas(sdata_NormalHead:GetV(sdata_NormalHead.I_PackageName,self.idx), sdata_NormalHead:GetV(sdata_NormalHead.I_AtlasName,self.idx))
		self.pHead:SetSpriteName(sdata_NormalHead:GetV(sdata_NormalHead.I_Skin,self.idx))
		wnd_tuiguan:reHeroface()
		self:BackToInfo(obj,"diban_headchangebantou")
	else
		Poptip.PopMsg("你可能到了个神奇的地方~",Color.red)
	end
end

--------------------------修改昵称----------------------------
function wnd_playerinfoClass:ChangeName()	
	local txt = self.instance:FindWidget( "diban_playername/txt_playername" )
	local txt_Lable = txt:GetComponent( CMUILabel.Name )--获得label组件
	self.Str_name = txt_Lable:GetValue()
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","ReName")  
	jsonNM:Add("name",self.Str_name)  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReName)

end
function wnd_playerinfoClass:NM_ReName(jsonDoc)	
	local num = tonumber(jsonDoc:GetValue("r"))
	if num ==1 then
		Poptip.PopMsg("好名字都让猪起了~",Color.red)
	elseif num == 2 then
		Poptip.PopMsg("余额不足呦~",Color.red)
	elseif num == 0 then
		self:SetLabel ("diban_shensexinxi/txt_playername",Player:GetAttr(PlayerAttrNames.Name))
		self:SetLabel ("TouxiangImg/txt_name",Player:GetAttr(PlayerAttrNames.Name))
--		self:SetLabel ("diban_jinbi/txt_jinbinum",Player:GetNumberAttr(PlayerAttrNames.Gold))
		Poptip.PopMsg("恭喜你可以用这个昵称~",Color.red)
	else
		Poptip.PopMsg("你可能到了个神奇的地方~",Color.red)
	end
	self:SetWidgetActive("diban_namechangebantou",false)
end
function wnd_playerinfoClass:OnBack()	
	self:Hide()
end
function wnd_playerinfoClass:OnLostInstance()
end 
--得到玩家没有的武将头像
function wnd_playerinfoClass:GetDotHave()
	local tb2 = Player:GetHeros()
	local tb3 = {}
	local each_func = function(key,row)
		local bFind = false
		for i, v1 in pairs(tb2) do
			if row[sdata_NormalHead.I_Skin] == SData_Hero.GetHero(tb2[i]:GetAttr(HeroAttrNames.DataID)):HeroFace()  then
				bFind = true
				break
			end
		end
		if not bFind then
			local bExit = false
			for k, v2 in pairs(tb3) do
				if id == v2 then
					bExit = true
					break
				end
			end
			if not bExit then
				if row[sdata_NormalHead.I_Type] == 2 then
					table.insert(tb3, row[sdata_NormalHead.I_ID])
				end		
			end
		end
	end
	sdata_NormalHead:Foreach(each_func)
	return tb3	
end

return wnd_playerinfoClass.new