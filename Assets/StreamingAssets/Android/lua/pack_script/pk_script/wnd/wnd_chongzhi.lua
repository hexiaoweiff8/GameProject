
local wnd_chongzhiClass = class(wnd_base)

wnd_chongzhi = nil--单例

function wnd_chongzhiClass:Start() 
	wnd_chongzhi = self
	self:Init(WND.Chongzhi)

	self.bIslistenmoney = false --金币铜币监听标记
end
--窗体被实例化时被调用
--初始化实例
function wnd_chongzhiClass:OnNewInstance()
	self.shouchong = false--首冲
	self.bIsshow = false--退出后窗体是否卸载
	self.vipOrCZ = false--默认不显示VIP
	self:saveVIPtable()
    self:BindUIEvent("btn_back",UIEventType.Click,"OnBackClick")
	self:BindUIEvent("vip_btn",UIEventType.Click,"OnVIPClick")

end
function wnd_chongzhiClass:OnShowDone()
	self:SetLabel("vip_btn/txt",SData_Id2String.Get(5148))
	self:SetLabel("diban_title1/txt_title1",SData_Id2String.Get(5128))
	self:callbackFunc()
	if not self.bIslistenmoney then
		OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Gold,self,self.callbackFunc)
		OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Rsum,self,self.callbackFunc)
		OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Copper,self,self.callbackFunc)
		self.bIslistenmoney = true
	end
	for i = 1,9 do
		self:SetLabel("pic_info"..i.."/txt_vippic"..i,SData_Id2String.Get(5133+i))
	end
	if not self.bIsshow then
		self.bIsshow = true
		local cmAttributeGird= {
				self.instance:FindWidget("tabscroll/inactivegrid"),
				self.instance:FindWidget("tabscroll/activitygrid")
		}
		local m_Item = self.instance:FindWidget("tabscroll/inactivegrid/btn_inapage1")
		local m_Item1= self.instance:FindWidget("tabscroll/activitygrid/btn_actpage1")
		local attupage = 0
		local i = 1
		local eatchfunch = function (key,value)
			local newItem = GameObject.InstantiateFromPreobj(m_Item, cmAttributeGird[1])
			newItem:SetName("inactive"..i)
			self:SetLabel("inactive"..i.."/norpay1/txt_nor1",string.sformat(SData_Id2String.Get(5132),sdata_Pay:GetV(sdata_Pay.I_Money,i)))
			self:SetLabel("inactive"..i.."/norpay1/txt_nor2",string.sformat(SData_Id2String.Get(5129),sdata_Pay:GetV(sdata_Pay.I_Gold,i)))
			local newItem = GameObject.InstantiateFromPreobj(m_Item1,cmAttributeGird[2])
			newItem:SetName("activity"..i)
			self:SetLabel("activity"..i.."/norpay2/txt_nor3",string.sformat(SData_Id2String.Get(5132),sdata_Pay:GetV(sdata_Pay.I_Money,i)))
			self:SetLabel("activity"..i.."/norpay2/txt_nor4",string.sformat(SData_Id2String.Get(5129),sdata_Pay:GetV(sdata_Pay.I_Gold,i)))
			local tiaozhuanCZ = self.instance:FindWidget("inactive"..i)
			local cmAttributePage = tiaozhuanCZ:GetComponent(CMUIAttributePage.Name)
			cmAttributePage:SetActivityButton(self.instance:FindWidget("tabscroll/activitygrid/activity"..i))
			cmAttributePage:SetInactiveButton(self.instance:FindWidget("tabscroll/inactivegrid/inactive"..i))
			self:BindUIEvent("inactive"..i,UIEventType.Click,"OnItemClick",i)
			i = i+1
		end
		sdata_Pay:Foreach(eatchfunch)
		self:onshowXXK()

		for k = 1 ,	2 do
			local container = cmAttributeGird[k]
			local cmGrid = container:GetComponent(CMUIGrid.Name)
			cmGrid:Reposition()
		end
	end
end
--vip等级及进度条显示
function wnd_chongzhiClass:title1bgShow()
	local viplv = Player:GetNumberAttr(PlayerAttrNames.CZLJCS)
	local currCost = Player:GetNumberAttr(PlayerAttrNames.Rsum)
	self:SetWidgetActive("viplv_bg1",true)
	self:SetWidgetActive("viplv_bg2",true)
	self:SetLabel("viplv_bg1/txt",self.YKList[viplv+1].Xunjue)
	local pro = self.instance:FindWidget( "progressbar_bg" )
	local pro_pro = pro:GetComponent(CMUIProgressBar.Name)
	if self.vipnum == viplv  then 		
		self:SetWidgetActive("viplv_bg2",false)
		self:SetWidgetActive("vip/txt",false)
	else
		local a = self.YKList[viplv+2].Xunjue
		self:SetLabel("viplv_bg2/txt",a)		
		local b = self.YKList[viplv+2].ChongZhiRequire - currCost
		self:SetLabel("vip/txt",string.sformat(SData_Id2String.Get(5149),a,b))

	end
	local str1 = ""
	if currCost < self.YKList[self.vipnum+1].ChongZhiRequire  then 		
		pro_pro:SetValue(currCost/self.YKList[viplv+2].ChongZhiRequire)
		str1 = string.sformat(SData_Id2String.Get(5005),currCost,self.YKList[viplv+2].ChongZhiRequire)
	else
		pro_pro:SetValue(1)
		str1 = string.sformat(SData_Id2String.Get(5005),currCost,self.YKList[self.vipnum+1].ChongZhiRequire)
	end
	self:SetLabel("progressbar_bg/txt",str1)
end
--得到最适当的充值金额
function wnd_chongzhiClass:getchongzhiyuanbai()
	local viplv = Player:GetNumberAttr(PlayerAttrNames.CZLJCS)--当前的VIP等级
	if viplv < self.vipnum then
		local b = self.YKList[viplv+2].ChongZhiRequire -  Player:GetNumberAttr(PlayerAttrNames.Rsum)
		local chongzhiID = 0 
		local chongzhinum = 0 
		local tag = false
		local i = 1
		local eatchfunch = function (key,value)	
			local id = 0
			local num = 0
			id = i
			num = sdata_Pay:GetV(sdata_Pay.I_Gold,i) - b 	
								
			if sdata_Pay:GetV(sdata_Pay.I_Gold,i) - b  > 0 then
				tag = true
				if i == 1 then 
					chongzhiID = id
					chongzhinum = num
				else
					if chongzhinum >= num then	
						chongzhiID = id
					end
				end
				
			else 
				if tag then
					return
				else
					if i == 1 then 
						chongzhiID = id
						chongzhinum = num
					else
						if chongzhinum >= math.abs(num) then	
							chongzhiID = id
						end
					end
				end
			end
			i = i+1
		end
		sdata_Pay:Foreach(eatchfunch)
		return chongzhiID
	else
		return 1
	end
	 
end
--点击VIP
function wnd_chongzhiClass:OnVIPClick()
	if self.vipOrCZ then
		self.vipOrCZ = false
	else
		self.vipOrCZ = true
		local viplv = Player:GetNumberAttr(PlayerAttrNames.CZLJCS)
		self.nextlv = viplv + 1
		self:vipchange()
	end
	
end
--VIP对应页面显示
function wnd_chongzhiClass:vipchange()
	local idx = self:getchongzhiyuanbai() 
	self:SetLabel("buy_btn/txt",SData_Id2String.Get(5143))
	self:BindUIEvent("buy_btn",UIEventType.Click,"onClickCZbtn",idx)
	self:SetLabel("price_bg/txt",string.sformat(SData_Id2String.Get(5132),sdata_Pay:GetV(sdata_Pay.I_Money,idx)))
	if self.nextlv >= self.vipnum then
		self:SetLabel("title_bg/txt",self.YKList[self.nextlv].Xunjue)
		self:vipInFo(self.nextlv)
	else	
		self:SetLabel("title_bg/txt",self.YKList[self.nextlv+1].Xunjue)
		self:vipInFo(self.nextlv+1)
	end
	self:BindUIEvent("right_btn",UIEventType.Click,"changePage",0)
	self:BindUIEvent("left_btn",UIEventType.Click,"changePage",1)
	
	self:SetWidgetActive("right_btn",true)
	self:SetWidgetActive("left_btn",true)
	if self.nextlv == 1 then--左右两个指引对显隐的判断
		self:SetWidgetActive("left_btn",false)
	elseif self.nextlv  == self.vipnum+1 then
		self:SetWidgetActive("right_btn",false)
	end
end
function wnd_chongzhiClass:vipInFo(lv)
	local num = tonumber(lv+5149)
	--local tab = self:getJLitem(lv)
	self:SetLabel("info_bg/txt",SData_Id2String.Get(num))
	
end
--function wnd_chongzhiClass:getJLitem(lv)
--	local JLnum = {}
--	for i = 1,15 do
--		if sdata_VIP:GetFieldV("BookNameDaily"..i,lv-1) and  sdata_VIP:GetFieldV("BookNameDaily"..i,lv-1) > 0 then
--			table.insert(JLnum,#JLnum+1,i)
--			print("sdata_VIP:GetFieldV",i)
--		end
--	end
--	local JLList = {}
--	local idx = 1
--	local VIPeatchfunch = function (id,value)	
--		if id == lv-1 then
--			for i = 1 , #JLnum do
--				local JLlist = {}
--				JLlist.BookName = sdata_VIP:GetFieldV("BookNameDaily"..JLnum[i],id)
--				JLlist.SubType = sdata_VIP:GetFieldV("SubTypeDaily"..JLnum[i],id)
--				JLlist.Num = sdata_VIP:GetFieldV("NumDaily"..JLnum[i],id)
--				print("1111111111111111111111111111111111111111",JLlist.BookName ,JLlist.SubType ,JLlist.Num)
--				JLList[idx] = JLlist
--				idx = idx + 1
--			end
--		end	
--	end
--	sdata_VIP:Foreach(VIPeatchfunch)	

--	local a ={}
--	for i = 1 ,#JLList do
--		if tonumber(JLList[i].BookName) == 1 then
--			table.insert(a,#a+1,JLList[i].Num)
--		elseif  tonumber(JLList[i].BookName) == 5 then
--			table.insert(a,#a+1,tab[i].Num)
--		elseif  tonumber(JLList[i].BookName) == 6 then
--			table.insert(a,#a+1,JLList[i].Num)
--		elseif  tonumber(JLList[i].BookName) == 7 then
--		elseif  tonumber(JLList[i].BookName) == 22 then
--			local b = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Name,table[i].SubType) ..","..JLList[i].Num
--			table.insert(a,#a+1,b)			
--		else
--			Poptip.PopMsg("没有找到该枚举",Color.red)
--		end
--	end
--	local c = ""
--	for k,v in pairs (a) do
--		c = c..v
--	end
--	return c
--end

--VIP翻页
function wnd_chongzhiClass:changePage(obj,num)
	if num == 1 then 
		self.nextlv = self.nextlv - 1 
	else
		self.nextlv = self.nextlv + 1 
	end
	self:showVIP(self.nextlv)
end
function wnd_chongzhiClass:showVIP(lv)	
	self:vipchange()
end
--监听金币和铜币数量变化
function wnd_chongzhiClass:callbackFunc()
	if wnd_chongzhi.isVisible == false then 
		return 
	end 
	self:title1bgShow()
	self:SetLabel ("diban_title3/txt_title3",Player:GetNumberAttr(PlayerAttrNames.Copper))
	self:SetLabel ("diban_title2/txt_title2",Player:GetNumberAttr(PlayerAttrNames.Gold))
end
--判断首冲及选项卡的显示
function wnd_chongzhiClass:onshowXXK()
	local pages = 0
	if self.shouchong  then--已经首充过了
		local rewardItem1 = self.instance:FindWidget("btn_inapage1")
		local cmUIAttributePage =  rewardItem1:GetComponent(CMUIAttributePage.Name)
		cmUIAttributePage:SetActivity() 
		cmUIAttributePage:SetHide(true)
		local rewardItem = self.instance:FindWidget("inactive1")
		local cmUIAttributePage1 =  rewardItem:GetComponent(CMUIAttributePage.Name)
		cmUIAttributePage1:SetActivity()
		self:OnItemClick(gameObj,1)
		local tabbtn_inactive = self.instance:FindWidget("inactivegrid")
		local pos = tabbtn_inactive:GetLocalPosition().y
		tabbtn_inactive:SetLocalPosition(Vector3.new(tabbtn_inactive:GetLocalPosition().x,pos+85,0))
		local tabbtn_activity = self.instance:FindWidget("activitygrid")
		tabbtn_activity:SetLocalPosition(Vector3.new(tabbtn_inactive:GetLocalPosition().x,pos+85,0))
	else--还没首充
		self:SetLabel ("spepay1/txt_spe1",SData_Id2String.Get(5133))
		self:SetLabel ("spepay2/txt_spe2",SData_Id2String.Get(5133))
		self:SetWidgetActive("btn_inapage1/norpay1",false)
		self:SetWidgetActive("btn_inapage1/spepay1",true)
		self:SetWidgetActive("btn_actpage1/norpay2",false)
		self:SetWidgetActive("btn_actpage1/spepay2",true)
		local rewardItem1 = self.instance:FindWidget("btn_inapage1")
		local cmUIAttributePage =  rewardItem1:GetComponent(CMUIAttributePage.Name)
		cmUIAttributePage:SetActivity() 
		self:OnshouchongClick()
		self:BindUIEvent("btn_inapage1",UIEventType.Click,"OnshouchongClick")
	end
end 
--切换充值选项
function wnd_chongzhiClass:OnItemClick(gameObj,id)
	
	--self:SetWidgetActive("pay/tabinfo1/pagebtn1",true)
	self:SetWidgetActive("pay/Firstpay",false)
	local temp = wnd_chongzhi:FindWidget("tabinfo1/tabscroll/tabwrap")
	local tempcm = temp:GetComponent(CMUIScrollPoint.Name)
	tempcm:SetIndex(id-1)
	local Index = tempcm:GetIndex()

	self:SetLabel("diban_info1/txt_info1",sdata_Pay:GetV(sdata_Pay.I_Note,id))
	self:SetLabel("diban_price1/txt_price1",string.sformat(SData_Id2String.Get(5132),sdata_Pay:GetV(sdata_Pay.I_Money,id)))
	--self:BindUIEvent("btn_buy1",UIEventType.Click,"onClickCZbtn",id)--点击充值的跳转
end 
--首冲
function wnd_chongzhiClass:OnshouchongClick()
	self:SetWidgetActive("pay/tabinfo1",true)
	--self:SetWidgetActive("pay/tabinfo1/pagebtn1",false)
	self:SetWidgetActive("pay/Firstpay",true)
	self:SetLabel("txt_buy1",SData_Id2String.Get(5143))
	self:SetLabel("diban_price2/txt_price2",SData_Id2String.Get(5146))
	self:SetLabel("diban_info2/txt_info2",SData_Id2String.Get(5147))
	self:SetLabel("btn_buy2/txt_buy2",SData_Id2String.Get(5143))
	self:BindUIEvent("btn_buy2",UIEventType.Click,"onClickCZbtn",0)

	self:SetLabel("pic_firstinfo/txt_fvippic",SData_Id2String.Get(5145))--sdata_FirstPay:GetV(sdata_FirstPay.I_Note,1))--解释说明

end 
--用做跳转  包括VIP和首冲跳到充值
function wnd_chongzhiClass:onClickCZbtn(gameObj,t)
	local id = t
	if t == 0 then
		local eatchfunch = function (k,v)
			if v[sdata_Pay.I_DefaultOptions] == 1 then
				id = v[sdata_Pay.I_ID]
			end
		end
		sdata_Pay:Foreach(eatchfunch)
	end
	local rewardItem1 = self.instance:FindWidget("inactive"..id)
	local cmUIAttributePage =  rewardItem1:GetComponent(CMUIAttributePage.Name)
	cmUIAttributePage:SetActivity() 

	if id >= 5 then
		local rewardItem = self.instance:FindWidget("tab/tabscroll")
		rewardItem:SetLocalPosition(Vector3.new(rewardItem:GetLocalPosition().x,0+470,0))
		local Panelset = rewardItem:GetComponent(CMUIPanel.Name)
		Panelset:SetClipOffset(Vector2.new( 0,-470))
	else
		local rewardItem = self.instance:FindWidget("tab/tabscroll")
		rewardItem:SetLocalPosition(Vector3.new(rewardItem:GetLocalPosition().x,0,0))
		local Panelset = rewardItem:GetComponent(CMUIPanel.Name)
		Panelset:SetClipOffset(Vector2.new( 0,0))		
	end
	self:OnItemClick(gameObj,id)
end
--返回响应
function wnd_chongzhiClass:OnBackClick()
    wnd_tuiguan:ShowOrHidePaikuTips() --推关界面，牌库上的红点提示
    EventHandles.OnWndExit:Call(WND.Chongzhi)
end 
--得到VIP表
function wnd_chongzhiClass:saveVIPtable()
	self.YKList = {}
	local idx = 1
	local VIPeatchfunch = function (id,value)
		local YkList = {}
		YkList.ID = sdata_VIP:GetV(sdata_VIP.I_ID,id)
		YkList.Xunjue = sdata_VIP:GetV(sdata_VIP.I_Xunjue,id)
		YkList.ChongZhiRequire = sdata_VIP:GetV(sdata_VIP.I_ChongZhiRequire,id)
		YkList.Id2String  = sdata_VIP:GetV(sdata_VIP.I_Id2String,id)
		self.YKList[idx] = YkList
		idx = idx + 1

	end
	sdata_VIP:Foreach(VIPeatchfunch)
	self.vipnum = idx-2
	table.sort(self.YKList,function(item1,item2) return (item1.ID < item2.ID) end  )	
end 
--实例即将被丢失
function wnd_chongzhiClass:OnLostInstance()
end 
 
return wnd_chongzhiClass.new