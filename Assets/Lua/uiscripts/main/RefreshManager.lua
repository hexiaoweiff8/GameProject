-- require 'uiscripts/main/util/Queue'
require 'uiscripts/main/mainSystemBar'
require 'uiscripts/main/mainCurrencyBar'
require 'uiscripts/main/PlayerInfoWidget'
require 'uiscripts/main/MobileInfoWidget'
RefreshManager = {}

-- local refreshQueue = Queue.new()

--@Des 从外部推送一个刷新指定界面红点标志的请求
function RefreshManager.RefreshRedDot(wnd_base_id)
	-- printf("收到刷新请求，"..wnd_base_id)
	ui_mainSystemBar.refreshRedDotBy_WND_base_id(wnd_base_id)
end
--@Des 刷新主界面玩家信息/货币信息/手机信息 
function RefreshManager.PushRefreshRequest()
	ui_mainCurrencyBar.updateCurrencyView()
	ui_playerInfo.updatePlayerInfo()
	ui_mobileInfo.updateBatteryInfo()
end

return RefreshManager