--region *.lua
--Date 20150826
--片头视频

local wnd_TitlesVideoClass = class(wnd_base)

wnd_TitlesVideo = nil--单例

function wnd_TitlesVideoClass:Start() 
	wnd_TitlesVideo = self
	self:Init(WND.TitlesVideo)
end
 

--初始化实例
function wnd_TitlesVideoClass:OnNewInstance()
    --绑定视频点击事件
    self:BindUIEvent("video",UIEventType.Click,"OnVideoClick")

	--监听视频播放完成事件
    local videoObj = self.instance:FindWidget("video")    
    local cmPlayMovie = videoObj:GetComponent(CMPlayMovie.Name)
    cmPlayMovie:GetPlayFinishdEvent():AddCallback(self,self.OnMovieStop) --绑定播放完成回调
    cmPlayMovie:Play() --开始播放
end

--视频播放结束
function wnd_TitlesVideoClass:OnMovieStop(_)
    self:Hide(0.05)--隐藏
end
 
--实例即将被丢失
function wnd_TitlesVideoClass:OnLostInstance()
end 

--视频被点击
function wnd_TitlesVideoClass:OnVideoClick(gameObj)
    self:Hide(0.05)--隐藏
end
 
return wnd_TitlesVideoClass.new
--endregion
