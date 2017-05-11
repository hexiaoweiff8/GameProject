--wnd_achievements.lua
--Date
--此文件由[BabeLua]插件自动生成


local wnd_itemgetClass = class(wnd_base)

wnd_itemget = nil--单例

function wnd_itemgetClass:Start() 
	wnd_itemget = self
	self:Init(WND.Itemget)
	self.tab = {}
	self.tabSec = {} 
end
--窗体被实例化时被调用
--初始化实例
function wnd_itemgetClass:OnNewInstance()
	self.number = 0

	self:BindUIEvent("diban_itemget/back_btn",UIEventType.Click,"OnClickBack")
end
function wnd_itemgetClass:Fdata(table,wnd)
	self.wnd = wnd
	self.tab = table
end 

function wnd_itemgetClass:FdataSec(table)
	self.tabSec = table
end 

function wnd_itemgetClass:JLtype(type)
	self.type = type
end

function wnd_itemgetClass:OnShowDone()
	local m_Item = self.instance:FindWidget("tx_itemget")
    local pageObj = m_Item:GetComponents(CMUITweener.Name)

	local m_Item1 = self.instance:FindWidget("pic_itemdi")
    local pageObj1 = m_Item1:GetComponent(CMUITweener.Name)

	local m_Item2 = self.instance:FindWidget("plural_panel")
    local pageObj2 = m_Item2:GetComponent(CMUITweener.Name)

	
	if self.wnd == "wnd_Mail" then
		pageObj[1]:ResetToBeginning()
		pageObj[1]:PlayForward()
		pageObj1:ResetToBeginning()
		pageObj1:PlayForward()
		self:onlyItem()
	elseif self.wnd == "wnd_tuiguan" then
--		if #self.tabSec == 0 then
--			pageObj[1]:ResetToBeginning()
--			pageObj[1]:PlayForward()
--			pageObj1:ResetToBeginning()
--			pageObj1:PlayForward()
--		else
			pageObj[2]:ResetToBeginning()
			pageObj[2]:PlayForward()
			pageObj2:ResetToBeginning()
			pageObj2:PlayForward()
--		end
		self:twoGrid()
	else
	end
end
function wnd_itemgetClass:onlyItem()
	local m_Item = self.instance:FindWidget("itemgetgrid/item01")
	for k = 1,#self.tab do
		local newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("pic_itemdi/itemgetgrid"))
		newItem:SetName("award"..k)
		CodingEasyer:SetJLIcon(self.instance:FindWidget("award"..k),self.tab[k])
		newItem:SetActive(true)--激活对象
	end
	local container = self.instance:FindWidget("pic_itemdi/itemgetgrid")
	local cmGrid = container:GetComponent(CMUIGrid.Name)
	cmGrid:Reposition()	
end
function wnd_itemgetClass:twoGrid()
	self.tableJL = {}
	self.tableJL[#self.tableJL+1] = self.tab

	local n = 0
	if #self.tabSec ~= 0 then
		self.tableJL[#self.tableJL+1] = self.tabSec
	end
	local m_Item = self.instance:FindWidget("itemclass_grid/class01")
	local m_Item1 = self.instance:FindWidget("itemclass_grid/class01/itemgrid/item01")
	for k = 1,#self.tableJL do
		local newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("itemclass_grid"))
		newItem:SetName("lable"..k)
		if self.type == 0 then
			self:SetLabel("lable"..k.."/txt",SData_Id2String.Get(5343))
		elseif self.type == 1 and #self.tabSec ~= 0 then
			self:SetLabel("lable"..k.."/txt",SData_Id2String.Get(5345-k))
		elseif self.type == 1 and #self.tabSec == 0 then
			self:SetLabel("lable"..k.."/txt",SData_Id2String.Get(5344))
		end
		
		for i = 1,#self.tableJL[k] do
			local newItem1 = GameObject.InstantiateFromPreobj(m_Item1,self.instance:FindWidget("lable"..k.."/itemgrid"))
			newItem1:SetName("award"..k..i)
			CodingEasyer:SetJLIcon(self.instance:FindWidget("award"..k..i),self.tableJL[k][i])
			newItem1:SetActive(true)--激活对象
		end
		local container1 = self.instance:FindWidget("lable"..k.."/itemgrid")
		local cmGrid1 = container1:GetComponent(CMUIGrid.Name)
		cmGrid1:Reposition()			
		newItem:SetActive(true)--激活对象
	end
	local container = self.instance:FindWidget("itemclass_grid")
	local cmGrid = container:GetComponent(CMUIGrid.Name)
	cmGrid:Reposition()		
end
function wnd_itemgetClass:OnClickBack()
	if self.wnd  == "wnd_Mail" then
		for k = 1 ,#self.tab do
			if(self.instance:FindWidget("award"..k)~=nil) then
				self.instance:FindWidget("award"..k):Destroy() --销毁实例
			end
		end
	elseif self.wnd == "wnd_tuiguan" then
		for k = 1,#self.tableJL do	
			if(self.instance:FindWidget("lable"..k)~=nil) then
					self.instance:FindWidget("lable"..k):Destroy() --销毁实例
			end			
			for i = 1,#self.tableJL[k] do		
				if(self.instance:FindWidget("award"..k..i)~=nil) then
					self.instance:FindWidget("award"..k..i):Destroy() --销毁实例
				end
			end
		end
	end
	self.tab = {}
	self.tabSec = {} 
	self:Hide()
end 

--实例即将被丢失
function wnd_itemgetClass:OnLostInstance()
end 

return wnd_itemgetClass.new
 

--endregion
