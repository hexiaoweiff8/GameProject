--[[
	wnd_pve_controller:
		variable:
			
		function:
			OnShowDone() extend wnd_base:OnShowDone()
			OnDestroyDone() extend wnd_base:OnDestroyDone()
			initListener() 初始化界面按钮事件逻辑
]]
wnd_pve_controller = require("common/middleclass")("wnd_pve_controller",wnd_base)

local this = wnd_pve_controller

function wnd_pve_controller:OnShowDone()
	this.view = require('uiscripts/PVE/wnd_PVE_view')

	this.view:initView(self)

	this:initListener()
	this.view:initCollider()

	this.view.Layout_buyAvoidWar.panel:SetActive(false)
	this.view.Layout_selectAvoidWar.panel_info:SetActive(false)
	this.view.Layout_selectAvoidWar.panel:SetActive(false)

end
function wnd_pve_controller:OnDestroyDone()
	
end
----------------------------------------------------------------
--★Init 
function wnd_pve_controller:initListener()
	UIEventListener.Get(this.view.Button_back).onClick = function()
			-- TODO: PVE界面：返回按钮的实现
			
		end
	UIEventListener.Get(this.view.Button_avoidWar).onClick = function()
			-- TODO: 免战
			this.view.Layout_selectAvoidWar.panel:SetActive(true)
			
		end
		
	UIEventListener.Get(this.view.Layout_selectAvoidWar.btn_close).onClick = function()
		this.view.Layout_selectAvoidWar.panel:SetActive(false)
	end
	UIEventListener.Get(this.view.Layout_selectAvoidWar.btn_info).onClick = function()
		-- 免战信息
		this.view.Layout_selectAvoidWar.panel_info:SetActive(true)

		local collider = this.view.Layout_selectAvoidWar.panel_info:AddComponent(typeof(UnityEngine.BoxCollider))
		collider.isTrigger = true
		collider.center = Vector3.zero
		collider.size = Vector3(1136,640,0) 

		UIEventListener.Get(this.view.Layout_selectAvoidWar.panel_info).onClick = function()
			this.view.Layout_selectAvoidWar.panel_info:SetActive(false)
		end
	end
end

return wnd_pve_controller