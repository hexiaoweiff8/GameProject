local cm_armyai = class()


--AI状态
local AIStateEnum={
	Move = 0,--移动
	Hit = 1,--攻击
}

local avatarY = 0.001

function cm_armyai:ctor()	
	self.m_lostTime = 0 
end

function cm_armyai:Start()
	
	--local cms = self.gameObject:GetComponents(CMAnimator.Name)--获取动画组件
    --self.cm_Animator = cms[1]
    
    self.cmAnimator = self.gameObject:GetComponent(CMAvatarAnimator_Auto.Name)
	self:SetState(AIStateEnum.Move)
end
 
 
function cm_armyai:Update()
	 
	self.m_lostTime = self.m_lostTime + Time.deltaTime()
	if(self.m_state == AIStateEnum.Move)
	then
	 
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
			self:RandState()
		else 
			self.gameObject:SetLocalPosition(currPos) 
		end
		 
	elseif (self.m_state == AIStateEnum.Hit) then
		if (self.m_lostTime > 1.0) then
			self:RandState()
		end
	end 
	 
end



function cm_armyai:RandState()
	if(math.random(0,5)<1) then
		self:SetState(AIStateEnum.Move)
	else
		self:SetState(AIStateEnum.Hit)
	end
end

function cm_armyai:SetState(state)
	self.m_state = state
	if(self.m_state == AIStateEnum.Move)
	then
		
        self.cmAnimator:Play("run")
		self.m_moveSpeed = math.random(2,5)
		self.m_StartPos = self.gameObject:GetLocalPosition()
		self.m_MoveTo = Vector3.new(math.random(0, GameScene.SceneWidth ),0,math.random(0, 20))

          
		self.m_lostTime = 0
		local distance = math.max(math.abs(self.m_MoveTo.x-self.m_StartPos.x),math.abs(self.m_MoveTo.z-self.m_StartPos.z))
		self.m_CountTime = distance / self.m_moveSpeed;
        
		--设置精灵方向 
        self.cmAnimator:SetFlip(
            ifv(self.m_MoveTo.x>self.m_StartPos.x,SpriteFlip.Nothing,SpriteFlip.Horizontally)
        )
	else
        self.cmAnimator:Play("hit",false)
		self.m_lostTime = 0
	end
end


return cm_armyai.new