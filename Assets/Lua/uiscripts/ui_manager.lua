-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local class = require("common/middleclass")
ui_manager = class("ui_manager")
function ui_manager:initialize()
    -- 所有已加载的 wnd_base
    self._all_wnd_bases = {}
    -- 当前正在显示的 wnd_base
    self._shown_wnd_bases = {}
    -- 弹出窗口用来导航用到的堆栈
    self._popup_back_sequence = stack:create()
    --UIRoot
    self.ui_layer = GameObject.Find("UIRoot").transform
end
function ui_manager:reset()
    self._all_wnd_bases = {}
    self._shown_wnd_bases = {}
    self._popup_back_sequence:clear()
end
function ui_manager:ShowWB(wnd_base, duration, is_close_curPop)
    if type(wnd_base) == "string" then
        wnd_base = _all_Reg_Wnd_list[wnd_base]
    end
    local wnd_base_id = wnd_base.wnd_base_id
    if self._shown_wnd_bases[wnd_base_id] ~= nil then
        return
    end
    if wnd_base.wnd_base_type == wnd_base_type.POPUP then
        if is_close_curPop then
            self:DestroyWB(self._popup_back_sequence:peek())
        end
        self._popup_back_sequence:push(wnd_base)
    elseif wnd_base.wnd_base_type == wnd_base_type.NORMAL or wnd_base.wnd_base_type == wnd_base_type.LOADING then
        self:destroy_all_shown_pop()
        if self.current_wnd_base then
            self:DestroyWB(self.current_wnd_base)
            self.current_wnd_base = nil
        end
        if wnd_base.wnd_base_type == wnd_base_type.NORMAL then
            self.current_wnd_base = wnd_base
        end
    end

    wnd_base:Show(duration)
	ui_manager._all_wnd_bases[wnd_base_id] = wnd_base
	ui_manager._shown_wnd_bases[wnd_base_id] = wnd_base
end
function ui_manager:DestroyWB(wnd_base, duration, isPop)
    if type(wnd_base) == "string" then
        wnd_base = _all_Reg_Wnd_list[wnd_base]
    end
    if wnd_base.wnd_base_type == wnd_base_type.POPUP then
        if wnd_base.Resident == 1 then
            wnd_base:Hide(duration)
        else
            wnd_base:Destroy(duration)
        end
        if isPop == nil then
            self._popup_back_sequence:pop()
        end
    else
        if wnd_base.Resident == 1 then
            wnd_base:Hide(duration)
        else
            wnd_base:Destroy(duration)
        end
    end
    self._all_wnd_bases[wnd_base.wnd_base_id] = nil
    self._shown_wnd_bases[wnd_base.wnd_base_id] = nil
end
function ui_manager:PreLoadWB(wnd_base)
    if type(wnd_base) == "string" then
        wnd_base = _all_Reg_Wnd_list[wnd_base]
    end
    wnd_base:PreLoad()
end
function ui_manager:change_child_layer(go, layer)
    go.layer = layer
    local tmp_tr = go.transform
    for i = 0, tmp_tr.childCount - 1 do
        local child = tmp_tr:GetChild(i)
        child.gameObject.layer = layer
        self:change_child_layer(child, layer)
    end
end
function ui_manager:create_layer_root(go_name)
    local tmp_go = GameObject(go_name)
    local rt_transform = tmp_go:GetComponent(typeof(UnityEngine.Transform))
    rt_transform:SetParent(self.ui_layer, false)
    self:change_child_layer(tmp_go, LayerMask.NameToLayer("UI"))
    return rt_transform
end
function ui_manager:get_wnd_base_root(_wnd_base_type)
    if _wnd_base_type == wnd_base_type.BACKGROUND then
        if not self.background_root then
            self.background_root = self:create_layer_root("BackGroundRoot")
        end
        return self.background_root
    elseif _wnd_base_type == wnd_base_type.NORMAL then
        if not self.normal_root then
            self.normal_root = self:create_layer_root("NormalRoot")
        end
        return self.normal_root
    elseif _wnd_base_type == wnd_base_type.FIXED then
        if not self.fixed_root then
            self.fixed_root = self:create_layer_root("FixedRoot")
        end
        return self.fixed_root
    elseif _wnd_base_type == wnd_base_type.POPUP then
        if not self.popup_root then
            self.popup_root = self:create_layer_root("PopUpRoot")
        end
        return self.popup_root
    elseif _wnd_base_type == wnd_base_type.ABOVE_POPUP then
        if not self.above_popup_root then
            self.above_popup_root = self:create_layer_root("AbovePopUpRoot")
        end
        return self.above_popup_root
    elseif _wnd_base_type == wnd_base_type.TUTORIAL then
        if not self.tutorial_root then
            self.tutorial_root = self:create_layer_root("TutorialRoot")
        end
        return self.tutorial_root
    elseif _wnd_base_type == wnd_base_type.LOADING then
        if not self.loading_root then
            self.loading_root = self:create_layer_root("LoadingRoot")
        end
        return self.loading_root
    elseif _wnd_base_type == wnd_base_type.ABOVE_TUTORIAL then
        if not self.above_tutorial_root then
            self.above_tutorial_root = self:create_layer_root("AboveTutorialRoot")
        end
        return self.above_tutorial_root
    else
        return self.ui_layer
    end
end
function ui_manager:do_go_back(args)
    if not self.current_wnd_base then return false end
    if self._NORMAL_back_sequence:getn() <= 1 then
        -- 如果当前BackSequenceData 不存在返回数据
        -- 检测lastwnd_base
        local pre_wnd_base_id = self.last_wnd_base and self.last_wnd_base.wnd_base_id or WNDTYPE.None
        if pre_wnd_base_id == WNDTYPE.None then
            pre_wnd_base_id = self.current_wnd_base.pre_wnd_base_id
        end
        if pre_wnd_base_id ~= WNDTYPE.None then
            self:ShowWB(self.last_wnd_base, false, args)
            return true
        else
            return false
        end
    else
        self._NORMAL_back_sequence:pop()
        local back_wnd_base = self._NORMAL_back_sequence:peek()
        if back_wnd_base then
            self:ShowWB(back_wnd_base, false, args)
        else
            return false
        end
    end
end
function ui_manager:go_back(pre_goback_handler, args)
    if pre_goback_handler then
        local need_return = pre_goback_handler()
        if not need_return then
            return false
        end
    end
    return self:do_go_back(args)
end
function ui_manager:destroy_all_shown_pop(duration)
    if duration == nil then
        duration = 0.5
    end
    self._popup_back_sequence:list(function(i, popwnd_base)
        self:DestroyWB(popwnd_base, duration, false)
    end)
    self._popup_back_sequence:clear()
end
function ui_manager:destroy_all_shown_wnd_bases(include_fixed)
    if include_fixed == nil then include_fixed = true end
    if include_fixed then
        for k, v in pairs(self._shown_wnd_bases) do
            self:DestroyWB(v, 0.1)
        end
    else
        for k, v in pairs(self._shown_wnd_bases) do
            if v.wnd_base_type ~= wnd_base_type.FIXED then
                self:DestroyWB(v, 0.1)
            end
        end
    end
end

--通过ID获取窗口table
function ui_manager:GetWB(wnd_base_id)
    return self._shown_wnd_bases[wnd_base_id]
end

return ui_manager
