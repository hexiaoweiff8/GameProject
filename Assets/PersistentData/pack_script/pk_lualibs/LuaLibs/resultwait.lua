--------------------------------------------------------
--各种结果等待器

MsgboxResultWait = class()
function MsgboxResultWait:GetResult()
	while(self.result==nil) do  
	Yield()  
	end	--等待对话框关闭
	return self.result
end

function MsgboxResultWait:OnMsgBoxClose(result)
	self.result = result
end