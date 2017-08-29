function showWND(WNDTYPE_WndName)
	if ui_manager._shown_wnd_bases[WNDTYPE_WndName] == nil then
		ui_manager:ShowWB(WNDTYPE_WndName)
	else
		ui_manager._shown_wnd_bases[WNDTYPE_WndName]:Show()
	end
end