
local wnd_MailClass = class(wnd_base)
wnd_Mail = nil -- 单例


local ChickBtn = {
	NorMail = 1,
	SysMail = 2,
	RewardTxt = 3,
}

function wnd_MailClass:Start() 
	wnd_Mail = self
	self:Init(WND.Mail)
end
local function SortFunc(item1, item2)
    local Judgement 
    if ( string.len(item1.ishavefujian) > 0 and string.len(item2.ishavefujian) > 0 and item1.islook ~= 2 and item2.islook ~= 2) or 
        ( string.len(item1.ishavefujian) == 0 and string.len(item2.ishavefujian) == 0) or
        ( string.len(item1.ishavefujian) > 0 and string.len(item2.ishavefujian) > 0 and item1.islook == 2 and item2.islook == 2 ) or
        (string.len(item1.ishavefujian) > 0 and string.len(item2.ishavefujian) == 0 and item1.islook == 2)  or
        (string.len(item1.ishavefujian) == 0 and string.len(item2.ishavefujian) > 0 and item2.islook == 2)then--有无附件
        if item1.islook == item2.islook then--是否已读                      
            Judgement = item1.TimeStamp > item2.TimeStamp                 
        else
            Judgement = item1.islook == 0
        end
    else
        Judgement = string.len(item1.ishavefujian) > 0 and item1.islook ~= 2 
    end  
    return Judgement
    
end
function wnd_MailClass:FillData(jsonDoc) 
	local MailListNode = jsonDoc:GetValue("MailList")
	self.m_Mail1 = {}
	self.m_Mail2 = {}
	local rankFunc = function(id,mailInfos)
		local list = {}
			list.id = id + 1
			list.Id = tostring(mailInfos:GetValue("Id"))
			list.Title = tostring(mailInfos:GetValue("Title"))
			list.TimeStamp =tostring(mailInfos:GetValue("Time"))
			list.TheSender = tostring(mailInfos:GetValue("Sender") )
			list.ishavefujian = tostring(mailInfos:GetValue("Attach") )
			list.islook = tonumber(mailInfos:GetValue("State") )
			list.Content = tostring(mailInfos:GetValue("Content") )
			list.MailType = tonumber(mailInfos:GetValue("MailType") )
			if list.MailType == 1 then
				table.insert(self.m_Mail2,1,list)
			else
				table.insert(self.m_Mail1,1,list) 
			end 
            

    end
    MailListNode:Foreach(rankFunc)
    table.sort(self.m_Mail2,SortFunc)

end
function wnd_MailClass:OnNewInstance()
	self.chickType = 1
	self.awardnum = 0
	self.awardPage = 1
	self:BindUIEvent("btn_mailclose",UIEventType.Click,"OnBackChick")
	self:BindUIEvent("btn_help",UIEventType.Click,"OnHelpChick")

	self:SetLabel ("page_normal1/txt_normal1",SData_Id2String.Get(5198))
	self:SetLabel ("page_normal2/txt_normal2",SData_Id2String.Get(5199))
	self:SetLabel ("page_normal3/txt_normal3",SData_Id2String.Get(5200))
	
	self:SetLabel ("page_select1/txt_select1",SData_Id2String.Get(5198))
	self:SetLabel ("page_select2/txt_select2",SData_Id2String.Get(5199))
	self:SetLabel ("page_select3/txt_select3",SData_Id2String.Get(5200))
	self:SetLabel ("btn_alldel/txt_alldel",SData_Id2String.Get(5202))
	self:SetLabel ("btn_alltake/txt_alltake",SData_Id2String.Get(5201))

	self:SetLabel ("scrollview1/txt_nonemail1",SData_Id2String.Get(5203))
	self:SetLabel ("scrollview2/txt_nonemail2",SData_Id2String.Get(5208))
	self:SetLabel ("scrollview3/txt_nonemail3",SData_Id2String.Get(5305))

	local uiTween = self.instance:FindWidget("close/diban_Allmail")
	self.pageObj = uiTween:GetComponents(CMUITweener.Name)
 --绑定选项卡事件
    self:BindUIEvent("page_normal1",UIEventType.Click,"OnTabSelectChanged",ChickBtn.NorMail)--收件箱
    self:BindUIEvent("page_normal2",UIEventType.Click,"OnTabSelectChanged",ChickBtn.SysMail)--系统收件箱
    self:BindUIEvent("page_normal3",UIEventType.Click,"OnTabSelectChanged",ChickBtn.RewardTxt)--领取记录

    --查找邮件（收件箱、系统邮件、接收邮件）
    self.container_array = {
		self.instance:FindWidget("scrollview1/grid_mail1"),
		self.instance:FindWidget("scrollview2/grid_mail2"),
		self.instance:FindWidget("scrollview3/grid_mail3")
	}
    --附件
	self.m_Item = self.instance:FindWidget("grid_onemail/pic_itme1")
    --附件grid
    self.itemContainer = self.instance:FindWidget("itempart/grid_onemail")
    --附件容器
	self.txtable = self.instance:FindWidget("scrollview4/onemailtab")

end

function wnd_MailClass:OnTabSelectChanged(gameObj,Type)
	self:DestroyItem(self.chickType)
	self.awardPage = 1
	self:SetWidgetActive("diban_onemail",false)
	if Type == ChickBtn.NorMail then
		self.chickType = ChickBtn.NorMail
		self:ShowNorSbyTabId(ChickBtn.NorMail)
	elseif Type == ChickBtn.SysMail then
		self.chickType = ChickBtn.SysMail
		self:ShowNorSbyTabId(ChickBtn.SysMail)
	elseif Type == ChickBtn.RewardTxt then
		self:SetWidgetActive("btn_alltake",false)
		self:SetWidgetActive("btn_alldel",false)
		self.chickType = ChickBtn.RewardTxt
		local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","MailRecord")  
		local loader = GameConn:CreateLoader(jsonNM,0) 
		HttpLoaderEX.WaitRecall(loader,self,self.NM_ReMailRecord)
--		self:showLQjilu()
		--self:ShowNorSbyTabId(ChickBtn.RewardTxt)
	else
	end
end
--显示领取记录
function wnd_MailClass:NM_ReMailRecord(jsonDoc)
--Owner:<string,该记录所属玩家>，
--From:<string,来源邮件的唯一标识>,
--Atta:<string,附件>,
--Time:<领取时间>
	local RecordsNode = jsonDoc:GetValue("Records")
	self.m_Award = {}
	local n = 1
	local rankFunc = function(_,mailInfos)
        local rank = {}
        rank.Owner = tostring( mailInfos:GetValue("Owner") )
        rank.From = tostring( mailInfos:GetValue("From") )
        rank.Atta = tostring( mailInfos:GetValue("Atta") )
		rank.Time = tostring( mailInfos:GetValue("Time") )
		self.m_Award [n] = rank   
		n = n + 1 
    end
    RecordsNode:Foreach(rankFunc)
	self:ShowNorSbyTabId(ChickBtn.RewardTxt)
	
end
function wnd_MailClass:OnHelpChick()
	self:SetWidgetActive("mailhelp",true)
	self:SetLabel("diban_helpnotedi/txt_helptitle",SData_Id2String.Get(5213))
	self:SetLabel("diban_helpnotedi/txt_helpnote",SData_Id2String.Get(5214))
	self:BindUIEvent("diban_mailhelpbantou",UIEventType.Click,"OnHelpBackChick")
end
function wnd_MailClass:OnHelpBackChick()
	self:SetWidgetActive("mailhelp",false)
end
function wnd_MailClass:ShowNorSbyTabId(btnid)
	self:SetWidgetActive("diban_onemail",false)
	local tp = 0
	local table = {}

	self:SetWidgetActive("btn_nextpage",false)
	self:SetWidgetActive("btn_lastpage",false)
	if btnid == ChickBtn.NorMail then
		tp = 1 
		table = self.m_Mail1
	elseif btnid == ChickBtn.SysMail then
		tp = 2
		table = self.m_Mail2
	elseif btnid == ChickBtn.RewardTxt then
		tp = 3
		if #self.m_Award > 0 then
			self:SetWidgetActive("txt_nonemail3",false)
		end
		self:Mailstatus()
	end

	if tp == 1 or tp == 2 then 
		self:SetWidgetActive("btn_alltake",true)
		self:SetWidgetActive("btn_alldel",true)
		self:SetLabel("grid_mail"..tp.."/pic_mail"..tp.."/txt_mfrom"..tp,SData_Id2String.Get(5207))
		self:BindUIEvent("btn_alltake",UIEventType.Click,"OnreveChick")--一键领取
		self:BindUIEvent("btn_alldel",UIEventType.Click,"OndelChick")--一键删除
	end

	local m_Item = self.instance:FindWidget("grid_mail"..tp.."/pic_mail"..tp)

	
	for k = 1 ,#table do 
		if #table > 0 then 
			self:SetWidgetActive("txt_nonemail"..tp,false)
			local newItem = GameObject.InstantiateFromPreobj(m_Item,self.container_array[tp])
			newItem:SetName("mail"..tp..k)
			if tp == 1 or tp == 2 then  	
				self:SetLabel("mail"..tp..k.."/txt_title"..tp,table[k].Title)
				self:SetLabel("mail"..tp..k.."/txt_from"..tp,table[k].TheSender)
				self:SetLabel("mail"..tp..k.."/txt_time"..tp,table[k].TimeStamp)
				self:BindUIEvent ("mail"..tp..k, UIEventType.Click,"OnmailChick",k)	--读取邮件
				local islook = tonumber(table[k].islook)
				if table[k].ishavefujian ~= "" then
--					print(k,tp)
					if islook == 0 then
--						print("有附件未读")
						self:SetWidgetActive("mail"..tp..k.."/pic_item"..tp,true)
					elseif islook == 1 then
						self:SetWidgetActive("mail"..tp..k.."/pic_item"..tp,true)
						self:SetWidgetActive("mail"..tp..k.."/pic_read"..tp,true)
--						print("有附件已读")
					elseif islook == 2 then
--						print("有附件已领取")
						self:SetWidgetActive("mail"..tp..k.."/pic_finish"..tp,true)
						self:SetWidgetActive("mail"..tp..k.."/pic_read"..tp,true)
					end
				else
				--没附件
					if islook == 1 then
						self:SetWidgetActive("mail"..tp..k.."/pic_read"..tp,true)
						self:SetWidgetActive("mail"..tp..k.."/pic_over"..tp,true)
					end
				end
			end	
			newItem:SetActive(true)
		else
			self:SetWidgetActive("txt_nonemail"..tp,true)
		end
	end
	local container = self.container_array[tp]
	local cmTable = container:GetComponent(CMUIGrid.Name)
	cmTable:Reposition()
end
--领取记录显示
function wnd_MailClass:Mailstatus()
	self.MaxPage = math.ceil(#self.m_Award/4)
	if  self.MaxPage > 1 then
		self:SetWidgetActive("scrollview3/btn_nextpage",true)	
	end
--	local m_Item = self.instance:FindWidget("grid_mail3/pic_mail3")
--	for k = 1 , 4 do 
--		local newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("scrollview3/grid_mail3"))
--		newItem:SetName("mail3"..k)
--	end
	self.pageNum = 1
	self:settingPage()
	self:BindUIEvent("scrollview3/btn_nextpage",UIEventType.Click,"OnpageChick",1)
	self:BindUIEvent("scrollview3/btn_lastpage",UIEventType.Click,"OnpageChick",0)
end
function wnd_MailClass:OnpageChick(gameObj,page)
	 if page == 0 then 
		self.pageNum = self.pageNum -1
		self:SetWidgetActive("scrollview3/btn_nextpage",true)
		if self.pageNum == 1 then
			self:SetWidgetActive("scrollview3/btn_lastpage",false)
		end
        print("当前页数",self.pageNum)

    elseif page == 1 then 
		self.pageNum = self.pageNum +1
		self:SetWidgetActive("scrollview3/btn_lastpage",true)
		if self.pageNum == self.MaxPage then
			self:SetWidgetActive("scrollview3/btn_nextpage",false)
		end
        print("当前页数:",self.pageNum)
    end 
	self:settingPage()
end
function wnd_MailClass:settingPage()
	for k = 1, 4 do
		local pagenum = (self.pageNum-1)*4+k
		if self.m_Award[pagenum] ~= nil then
			self:SetLabel("mail3"..k.."/txt_logtime",self:changestr(self.m_Award[pagenum].Time))
			local award = self.m_Award[pagenum].Atta
			local awardStr = " "
				for k,v in pairs(self:returnJLitem(award))do
					local JLname = self:GetJLName(tonumber(v.BookName),tonumber(v.SubType))
					awardStr = awardStr..JLname.."X"..v.Num.."  "
				end
			self:SetLabel("mail3"..k.."/txt_lognote",string.sformat(SData_Id2String.Get(5209),awardStr))
			self:SetWidgetActive("mail3"..k,true)
		else
			self:SetWidgetActive("mail3"..k,false)
		end
	end
end
--一键删除
function wnd_MailClass:OndelChick()
    if #self.m_Mail2 == 0 then
        Poptip.PopMsg("当前没有邮件!",Color.red)
        return
    end
	MsgBox.Show("是否确定删除所有邮件?若删除系统将自动为您下发未领取的附件","否","是",self,self.OnBoxClose)	
end
function wnd_MailClass:OnBoxClose(result)	
	if result == 1 then
		return nil
	elseif result == 2 then
		if self.chickType == ChickBtn.NorMail then
			tab = 2
		elseif self.chickType == ChickBtn.SysMail then
			tab = 1
		end
		local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","DeleteAllMail")  
		jsonNM:Add("mode",tab)  
		local loader = GameConn:CreateLoader(jsonNM,0) 
		HttpLoaderEX.WaitRecall(loader,self,self.NM_RedelList)		
	else
		Poptip.PopMsg("error~",Color.red)
	end

end
function wnd_MailClass:NM_RedelList(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("Result"))
	if num == 0 then
		local tab = self:ShowMails()
		self:SetWidgetActive("diban_onemail",false)
		local allAward = {}
		local n = 1 
		for k = 1 , #tab do
			if tab[k].ishavefujian ~= "" and tab[k].islook ~= 2  then
				local award = tab[k].ishavefujian
				for k,v in pairs(self:returnJLitem(award))do
					allAward[n] = v		
					n = n+1
				end
			end	
			if(self.instance:FindWidget("mail"..self.chickType..k)~=nil) then
				self:SetWidgetActive("mail"..self.chickType..k,false)
			end
		end

		local awardTle = {}
		for k, v in pairs(allAward) do
			local bFind = false
			for m ,n in pairs(awardTle) do
				if n.BookName == v.BookName and n.SubType == v.SubType then
					n.Num = n.Num + v.Num
					bFind = true
					break
				end
			end
			if not bFind then
				table.insert(awardTle,v)
			end
		end
		if #awardTle > 0 then
			wnd_itemget:Fdata(awardTle,"wnd_Mail")
			wnd_itemget:Show()
		end
		
		local container = self.instance:FindWidget("grid_mail"..self.chickType)
		local cmGrid = container:GetComponent(CMUIGrid.Name)
		cmGrid:Reposition()
		self:SetWidgetActive("txt_nonemail"..self.chickType,true)
		if self.chickType == ChickBtn.NorMail then
			self.m_Mail1 = {}
		elseif self.chickType == ChickBtn.SysMail then
			self.m_Mail2 = {}
		end
        --当没有邮件时，不显示亮框
        self:SetWidgetActive("scrollview2/select",false)
	end
end
--一键领取
function wnd_MailClass:OnreveChick()
	if self.chickType == ChickBtn.NorMail then
		tab = 2
	elseif self.chickType == ChickBtn.SysMail then
		tab = 1
	end
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","ReceiveAllMailAttch")  
	jsonNM:Add("mode",tab)  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReallList)	
end

function wnd_MailClass:NM_ReallList(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("Result"))
	local allAward = {}
	local n = 1 
	if num == 0 then
		local tab = self:ShowMails()
		self:SetWidgetActive("diban_onemail",false)
		for k ,v in pairs (tab) do
			if tab[k].ishavefujian ~= "" and tab[k].islook ~= 2  then
				local award = tab[k].ishavefujian
				tab[k].islook = 2
				for m,j in pairs(self:returnJLitem(award))do
					allAward[n] = j	
					n = n+1
				end
			self:SetWidgetActive("mail"..self.chickType..k.."/pic_finish"..self.chickType,true)
			self:SetWidgetActive("mail"..self.chickType..k.."/pic_read"..self.chickType,true)
            self:SetWidgetActive("mail"..self.chickType..k.."/pic_item"..self.chickType,false)
			end	
		end

		local awardTle = {}
		for k, v in pairs(allAward) do
			local bFind = false
			for m ,n in pairs(awardTle) do
				if n.BookName == v.BookName and n.SubType == v.SubType then
					n.Num = n.Num + v.Num
					bFind = true
					break
				end
			end
			if not bFind then
				table.insert(awardTle,v)
			end
		end
		if #awardTle > 0 then
			wnd_itemget:Fdata(awardTle,"wnd_Mail")
			wnd_itemget:Show()
		end
		self:setJLitem(tab)
	elseif num == 1 then 
		Poptip.PopMsg("没有附件",Color.red)		
	end
end

function wnd_MailClass:OnShowDone()
	self.pageObj[1]:ResetToBeginning()
	self.pageObj[1]:PlayForward()
--	local tiaozhuanCZ = self.instance:FindWidget("page_normal1")
--	local cmAttributePage = tiaozhuanCZ:GetComponent(CMUIAttributePage.Name)
--	cmAttributePage:SetActivity() 
	--self:OnTabSelectChanged(gameObj,ChickBtn.NorMail)
    --self:SetWidgetActive("scrollview2",true)
    --默认显示系统邮件
    self.chickType = ChickBtn.SysMail
    self:ShowNorSbyTabId(ChickBtn.SysMail)
end
function wnd_MailClass:DestroyItem(bInd)
	if bInd == ChickBtn.RewardTxt then
		return
	else
		local table = 0
		if bInd == ChickBtn.NorMail then
			table = #self.m_Mail1
		elseif bInd == ChickBtn.SysMail then
			table = #self.m_Mail2
		end

		local function destroy()
			for k = 1 ,table do
				if(self.instance:FindWidget("mail"..bInd..k)~=nil) then
					self.instance:FindWidget("mail"..bInd..k):Destroy() --销毁实例
				end
			end
		end
		destroy()
	end
end 
--读取邮件请求函数
function wnd_MailClass:OnmailChick(gameObj,k)
    self:SetFrameToCurrPos(k)
	local tab = self:ShowMails()
	self.ID = k
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","ReadMail")  
	jsonNM:Add("id",tab[k].Id)  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReList)
end
function wnd_MailClass:SetFrameToCurrPos(k)
    local currClickObj = self.instance:FindWidget("grid_mail2/mail"..self.chickType..k)
    local select_frame = self.instance:FindWidget("scrollview2/select")
    local v3pos = currClickObj:GetLocalPosition()
    v3pos.y = v3pos.y + 145
    select_frame:SetLocalPosition(v3pos)
    select_frame:SetActive(true)
end
--读取邮件回调函数
function wnd_MailClass:NM_ReList(jsonDoc)
	--num网络回复
	local num = tonumber(jsonDoc:GetValue("Result"))
	if num == 0 then
		local tab = self:ShowMails()
		self:SetWidgetActive("pic_onemailfgx",false)
		self:SetWidgetActive("mail"..self.chickType..self.ID.."/pic_read"..self.chickType,true)--读过置灰
		self:SetWidgetActive("diban_onemail",true)--邮件内容界面
		self:setJLitem(tab)		
	elseif num == 1 then
		Poptip.PopMsg("没有邮件~",Color.red)
	end


end
--邮件读取显示
function wnd_MailClass:setJLitem(tab)
	if self.awardnum ~= 0 then
		for k = 1 , self.awardnum do
			if(self.instance:FindWidget("award"..k)~=nil) then
				self:SetWidgetActive("award"..k,false)
			end
		end
	end
	self:SetLabel ("diban_onemail/txt_fujian",SData_Id2String.Get(5210))
	self:SetLabel ("diban_onemail/btn_lingqu/txt_lingqu",SData_Id2String.Get(5212))
	self:SetWidgetActive("grid_onemail/pic_itme1",false)
	self:SetWidgetActive("diban_onemail/btn_lingqu",false)
	self:SetLabel("notepart/txt_note",tab[self.ID].Content)
    self:SetLabel("txt_fujian",tab[self.ID].Content)
	local award = tab[self.ID].ishavefujian 
	if tab[self.ID].ishavefujian ~= "" then
		local m_Item = self.instance:FindWidget("grid_onemail/pic_itme1")
		for k,v in pairs(self:returnJLitem(award))do
			self.awardnum = self.awardnum + 1 
			local newItem = GameObject.InstantiateFromPreobj(self.m_Item,self.itemContainer)
			newItem:SetName("award"..self.awardnum)
			self:SetItemIcon("award"..self.awardnum,tonumber(v.BookName),tonumber(v.SubType))
			--newItem
			self:SetLabel("award"..self.awardnum.."/txt_item1num",string.sformat(SData_Id2String.Get(5211),v.Num))
			newItem:SetActive(true)
			self:SetWidgetActive("pic_onemailfgx",true)
			local islook = tonumber(tab[self.ID].islook)
			if islook == 1 then
				self:SetWidgetActive("btn_lingqu",true)
				self:SetWidgetActive("award"..self.awardnum.."/pic_ok1",false)		
			elseif islook == 2 then
				self:SetWidgetActive("award"..self.awardnum.."/pic_ok1",true)
				self:SetWidgetActive("btn_lingqu",false)
			else
				self:SetWidgetActive("btn_lingqu",true)
			end
		
			local cmGrid = self.itemContainer:GetComponent(CMUIGrid.Name)
			cmGrid:Reposition()
		end
		self:BindUIEvent("btn_lingqu",UIEventType.Click,"OnOneMaillingqu",tab[self.ID].Id)
	end
		
		--重排容器位置
		local cmTable = self.txtable:GetComponent(CMUITable.Name)
		cmTable:Reposition()

end
--领取附件发送消息
function wnd_MailClass:OnOneMaillingqu(gameObj,Id)
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","ReceiveMailAttch")  
	jsonNM:Add("id",Id)  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReceiveMailAttch)
end
--领取附件回调
function wnd_MailClass:NM_ReceiveMailAttch(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("Result"))
	if num == 0 then
		local table = self:ShowMails()
		wnd_itemget:Fdata(self:returnJLitem(table[self.ID].ishavefujian),"wnd_Mail")
		wnd_itemget:Show()
		table[self.ID].islook = 2
		self:setJLitem(table)
		self:SetWidgetActive("mail"..self.chickType..self.ID.."/pic_finish"..self.chickType,true)
        self:SetWidgetActive("mail"..self.chickType..self.ID.."/pic_item"..self.chickType,false)
        self:JumpNextAttr(table)
	else
		print("NO")
	end
end
--领取完当前附件之后，显示下一个附件的内容 
function wnd_MailClass:JumpNextAttr(table)
    for i = 1,#table do 
        if table[i].ishavefujian ~= "" then
            if table[i].islook ~= 2 then
                self:OnmailChick(_,i)
                break
            end
        end
    end
end
function wnd_MailClass:OnBackChick()
    wnd_tuiguan:ShowOrHidePaikuTips() --推关界面，牌库上的红点提示
	self:DestroyItem(self.chickType)
	self.pageObj[2]:ResetToBeginning()
	self.pageObj[2]:PlayForward()
	self:Hide()
end 
--返回附件列表
function wnd_MailClass:returnJLitem(str)
	local item1 = {}
	for k = 1 ,#str do
		item1[k] = string.sub(str,k,k)
	end
	local lab = ""
	for k = 1 ,#item1 do
		if item1[k] == "\\" then
		else	
		lab = lab ..item1[k]
		end		
	end
	local item2 = {}
	local table1 = string.split(lab ,";")
	for k,v in pairs(table1)do
		table2 = string.split(v ,":")
			local rank = {}
			rank.BookName = table2[1]
			rank.SubType = table2[2]
			rank.Num = table2[3]
		item2[k]= rank
	end
	return item2
end 
--返回当前显示界面的邮件列表
function wnd_MailClass:ShowMails()
	local tab = {}
	if self.chickType == ChickBtn.NorMail then
		tab = self.m_Mail1
	elseif self.chickType == ChickBtn.SysMail then
		tab = self.m_Mail2
	end
	return tab
end
function wnd_MailClass:changestr(str)
	local item1 = {}
	for k = 1 ,#str do
		item1[k] = string.sub(str,k,k)
	end
	local lab = ""
	for k = 1 ,#item1 do
		if item1[k] == "\\" then
		else	
		lab = lab ..item1[k]
		end		
	end
	return lab
end
function wnd_MailClass:GetJLName(BookName,SubType)
    local Name = ""
    if BookName == 1 then 
        Name = sdata_itemdata:GetV(sdata_itemdata.I_Name,SubType)
    elseif BookName == 2 or BookName == 5 then
        Name = SData_Hero.GetHero(SubType):Name()
        if BookName == 5 then
            Name = Name.."碎片"
        end
    elseif BookName == 3 or BookName == 6 then
        --[[    目前没有士兵表
        Name = SData_Hero.GetHero(SubType):Name()
        if BookName == 6 then
            Name = Name.."碎片"
        end
        --]]
    elseif BookName == 21 then
        Name = sdata_EquipData:GetV(sdata_EquipData.I_Name,SubType)
    elseif BookName == 22 then
        Name = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Name,SubType)
    end
    return Name
end
function wnd_MailClass:SetItemIcon(obj,BookName,SubType)
	local Icon = self.instance:FindWidget(obj)
    local sprite = Icon:GetComponent(CMUISprite.Name)
    local SkinName = ""

    if BookName == 1 then --道具  
       sprite:SetAtlas("core","itemAtlas")
       SkinName = sdata_itemdata:GetV(sdata_itemdata.I_HuobiIcon,SubType)
    elseif BookName == 2 or BookName == 5 then -- 英雄 
       sprite:SetAtlas("hero","hero1Atlas")
       local HeroStruct = SData_Hero.GetHero(SubType)
       HeroStruct:SetHeroIcon(sprite)
       return
    elseif BookName == 3  or BookName == 6 then -- 士兵 
       sprite:SetAtlas("")
       SkinName = ""
    elseif BookName == 11 then
       sprite:SetAtlas("")
       SkinName = "限时头像"
    elseif BookName == 21 then
       sprite:SetAtlas("ui_equip","ui_equipAtlas")
       SkinName = sdata_EquipData:GetV(sdata_EquipData.I_Icon,SubType)
    elseif BookName == 22 then
       sprite:SetAtlas("ui_equip","ui_equipAtlas")
       SkinName = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Icon,SubType)
    end
    sprite:SetSpriteName( SkinName )
end
function wnd_MailClass:OnLostInstance()
end
 
return wnd_MailClass.new