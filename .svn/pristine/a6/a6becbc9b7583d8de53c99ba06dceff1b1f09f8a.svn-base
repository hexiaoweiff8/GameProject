local cm_lightai = classWC()

local avatarY = 1

function cm_lightai:ctor()	
	self.m_lostTime = 0 
end

function cm_lightai:Start()
	self.mainCameraObject = GameObject.Find("/SceneRoot/SceneCamera")--获取场景渲染相机游戏对象
	self.cmLight = self.gameObject:GetComponent(CMLight.Name)

	self.lightColor = Color.new(1,1,1)
	self.lightColorTo =  Color.new(math.random(0.5,1),math.random(0.5,1),math.random(0.5,1))
	self:SetState( )
end
 
 
function cm_lightai:Update()
	 
	self.m_lostTime = self.m_lostTime + Time.deltaTime()
	 
	local t
	if(self.m_CountTime==0) then 
		t=0 
	else 
		t=self.m_lostTime/self.m_CountTime
	end
		
	t=math.clamp(t,0,1)
		
	local nx = math.lerp(self.m_StartPos.x, self.m_MoveTo.x, t)
	local nz = math.lerp(self.m_StartPos.z, self.m_MoveTo.z, t)
	local currPos = Vector3.new(nx,avatarY,nz)	
	if(t>0.999) then
		self:SetState()
	else 
		local cameraPos = self.mainCameraObject:GetLocalPosition()
		currPos.x=currPos.x+cameraPos.x
		currPos.z=currPos.z+cameraPos.z
		self.gameObject:SetLocalPosition(currPos) 
	end
	 

	local curr_r = self:ValueTo(self.lightColor.r,self.lightColorTo.r)
	local curr_g = self:ValueTo(self.lightColor.g,self.lightColorTo.g)
	local curr_b = self:ValueTo(self.lightColor.b,self.lightColorTo.b)

	if(curr_r==self.lightColorTo.r) then
		self.lightColorTo.r = math.random(0.5,1)
	end

	if(curr_g==self.lightColorTo.g) then
		self.lightColorTo.g = math.random(0.5,1)
	end

	if(curr_b==self.lightColorTo.b) then
		self.lightColorTo.b = math.random(0.5,1)
	end

	self.lightColor.r = curr_r
	self.lightColor.g = curr_g
	self.lightColor.b = curr_b
	self.cmLight:SetColor(self.lightColor)


end

function cm_lightai:ValueTo(curr,to)
	
	if(curr<to) then 
		curr=curr+0.01 
		if(curr>to) then 
			curr = to
		end
	else
		curr=curr-0.01 
		if(curr<to) then 
			curr= to
		end
	end
	return curr
end
 

function cm_lightai:SetState()
		self.m_moveSpeed = math.random(3,10)
		self.m_StartPos = ifv(self.m_MoveTo==nil,Vector3.Zero(),self.m_MoveTo) 
		self.m_MoveTo = Vector3.new(math.random(-5,5),0,math.random(1, 2))
          
		self.m_lostTime = 0
		local distance = math.max(math.abs(self.m_MoveTo.x-self.m_StartPos.x),math.abs(self.m_MoveTo.z-self.m_StartPos.z))
		self.m_CountTime = distance / self.m_moveSpeed;        
end


return cm_lightai.new