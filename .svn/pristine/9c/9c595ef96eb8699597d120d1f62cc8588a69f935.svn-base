local BackgroundMusic = class()
 
function BackgroundMusic:Start() 
    --监听顶层窗体变更事件
    EventHandles.OnTopWndChanged:AddListener(self,self.OnTopWndChanged)

    --挂载上则立即播放音乐
    BackgroundMusicManage.Play("music_normal0","NORMAL0",1)
end

function BackgroundMusic:OnTopWndChanged(wnd)
    if(wnd==WND.Arena) then
        BackgroundMusicManage.Play("music_expedition","EXPEDITION",1)
    else
        BackgroundMusicManage.Play("music_normal0","NORMAL0",1)
    end
    --music_athletics ATHLETICS
    --music_gzfight GuozhanFight
end
 
return BackgroundMusic.new
 