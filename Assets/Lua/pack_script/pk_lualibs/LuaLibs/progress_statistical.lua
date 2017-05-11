--------------------------------------------------------
--用于统计进度
--Date 20150806
--作者 wenchuan

ProgressStatistical = classWC()

function ProgressStatistical:ctor()	 
	self.startPogress = 0
	self.endPogress =0
	self.currMissionPogress = 0
	self.recall_func = nil 
end


--新建一个子任务，并指定子任务完成时的总进度
function ProgressStatistical:NewMission(totalProgress)--missionWeight 
	self.startPogress = self.endPogress--设置上个任务完成度100%
	self.currMissionPogress = 0--重置当前任务进度
	self.endPogress = totalProgress--self.endPogress+missionWeight--设置当前任务完成后的总进度
end

function ProgressStatistical:IsComplete()
	return (self.currMissionPogress>=1 and self.endPogress>=1)
end

--设定任务完成百分比 0-1 
function ProgressStatistical:SetMissionPogress(v) 
	self.currMissionPogress = v 
	local totalPogress = self:GetTotalPogress() 

	if(self.recall_func~=nil) then
		self.recall_func(self.recall_self,totalPogress)
	end
end

function ProgressStatistical:GetTotalPogress()
	return math.lerp(self.startPogress,self.endPogress,self.currMissionPogress)
end

function ProgressStatistical:SetRecall(_self,func)
	self.recall_self = _self
	self.recall_func = func
end