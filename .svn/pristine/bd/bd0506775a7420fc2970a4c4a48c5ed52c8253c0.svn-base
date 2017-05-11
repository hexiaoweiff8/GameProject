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
    -- 普通窗口用来导航用到的堆栈
    self._NORMAL_back_sequence = stack:create()
    -- 弹出窗口用来导航用到的堆栈
    self._popup_back_sequence = stack:create()
    
    local ui_layer_go = GameObject.Find("UIRoot")
    self.ui_layer = ui_layer_go.transform
    assert(not tolua.isnull(self.ui_layer), "UILayer is cannot find~~~~~~")
    
    self.globalZ = 0
end


function ui_manager:reset()
    self._all_wnd_bases = {}
    self._shown_wnd_bases = {}
    self._NORMAL_back_sequence:clear()
    self._popup_back_sequence:clear()
end


function ui_manager:show_wnd_base(wnd_base, duration, dontneed_pushOris_close_cur)
    if not wnd_base then return end
    local wnd_base_id = wnd_base.wnd_base_id
    
    if self._shown_wnd_bases[wnd_base_id] ~= nil then
        return
    end
    
    wnd_base:Show(duration)
    
    if wnd_base.wnd_base_type == wnd_base_type.POPUP then
        if dontneed_pushOris_close_cur then
            local cur_top_popwnd_base = self._popup_back_sequence:peek()
            if cur_top_popwnd_base then
                local cur_toppop_id = cur_top_popwnd_base.wnd_base_id
                if cur_toppop_id == wnd_base_id then
                    return
                else
                    self._shown_wnd_bases[cur_toppop_id]:destroy_wnd_base()
                    self._shown_wnd_bases[cur_toppop_id] = nil
                    self._all_wnd_bases[cur_toppop_id] = nil
                    self._popup_back_sequence:pop()
                end
            end
        end
        self._popup_back_sequence:push(wnd_base)
    elseif wnd_base.wnd_base_type == wnd_base_type.NORMAL then
        self:close_current_wnd_base()
        if wnd_base.is_first_wnd_base then
            self._NORMAL_back_sequence:clear()
            self.last_wnd_base = nil
        else
            if dontneed_pushOris_close_cur == nil then
                self.last_wnd_base = self.current_wnd_base
                self._NORMAL_back_sequence:push(wnd_base)
            end
        end
        self.current_wnd_base = wnd_base
    end
    
    self._all_wnd_bases[wnd_base_id] = wnd_base
    self._shown_wnd_bases[wnd_base_id] = wnd_base
end

function ui_manager:hide_wnd_base(wnd_base_id)
    if self._shown_wnd_bases[wnd_base_id] == nil then
        return
    end
    self._shown_wnd_bases[wnd_base_id]:Hide()
    self._shown_wnd_bases[wnd_base_id] = nil
end

function ui_manager:destroy_wnd_base(wnd_base_id, duration)
    if self._all_wnd_bases[wnd_base_id].wnd_base_type == wnd_base_type.POPUP then
        local top_pop_wnd_base = self._popup_back_sequence:peek()
        if not top_pop_wnd_base then
            return
        end
        top_pop_wnd_base:Destroy(duration)
        local top_pop_wnd_base_id = top_pop_wnd_base.wnd_base_id
        self._shown_wnd_bases[top_pop_wnd_base_id] = nil
        self._all_wnd_bases[top_pop_wnd_base_id] = nil
        self._popup_back_sequence:pop()
    else
        if not self._all_wnd_bases[wnd_base_id] then
            return
        end
        if self._shown_wnd_bases[wnd_base_id] then
            self._shown_wnd_bases[wnd_base_id] = nil
        end
        self._all_wnd_bases[wnd_base_id]:Destroy(duration)
        self._all_wnd_bases[wnd_base_id] = nil
    end
end

function ui_manager:close_current_wnd_base()
    -- 关闭当前界面
    if self.current_wnd_base then
        local cur_wnd_base_id = self.current_wnd_base.wnd_base_id
        if not cur_wnd_base_id then return end
        if cur_wnd_base_id == WND.None then return end
        if self._NORMAL_back_sequence:getn() <= 1 then return end
        local cur_top_wnd_base = self._NORMAL_back_sequence:peek()
        if cur_top_wnd_base then
            local cur_top_wnd_base_id = cur_top_wnd_base.wnd_base_id
            if cur_wnd_base_id == cur_top_wnd_base_id then
                self._NORMAL_back_sequence:pop()
            end
        end
        self:destroy_wnd_base(cur_wnd_base_id)
    end
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

function ui_manager:create_layer_root(go_name, sort_order)
    local tmp_go = GameObject(go_name)
    
    local rt_transform = tmp_go:GetComponent(typeof(UnityEngine.Transform))
    
    rt_transform:SetParent(self.ui_layer, false)
    
    self:change_child_layer(tmp_go, LayerMask.NameToLayer("UI"))
    
    return rt_transform
end

function ui_manager:get_wnd_base_root(wnd_base_type2)
    
    if wnd_base_type2 == wnd_base_type.BACKGROUND then
        if not self.background_root then
            self.background_root = self:create_layer_root("BackGroundRoot", 2)
        end
        return self.background_root
    elseif wnd_base_type2 == wnd_base_type.NORMAL then
        if not self.normal_root then
            self.normal_root = self:create_layer_root("NormalRoot", 10)
        end
        return self.normal_root
    elseif wnd_base_type2 == wnd_base_type.FIXED then
        if not self.fixed_root then
            self.fixed_root = self:create_layer_root("FixedRoot", 250)
        end
        return self.fixed_root
    elseif wnd_base_type2 == wnd_base_type.POPUP then
        if not self.popup_root then
            self.popup_root = self:create_layer_root("PopUpRoot", 500)
        end
        return self.popup_root
    elseif wnd_base_type2 == wnd_base_type.ABOVE_POPUP then
        if not self.above_popup_root then
            self.above_popup_root = self:create_layer_root("AbovePopUpRoot", 750)
        end
        return self.above_popup_root
    elseif wnd_base_type2 == wnd_base_type.TUTORIAL then
        if not self.tutorial_root then
            self.tutorial_root = self:create_layer_root("TutorialRoot", 1000)
        end
        return self.tutorial_root
    elseif wnd_base_type2 == wnd_base_type.ABOVE_TUTORIAL then
        if not self.above_tutorial_root then
            self.above_tutorial_root = self:create_layer_root("AboveTutorialRoot", 1250)
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
        local pre_wnd_base_id = self.last_wnd_base and self.last_wnd_base.wnd_base_id or WND.None
        
        if pre_wnd_base_id == WND.None then
            pre_wnd_base_id = self.current_wnd_base.pre_wnd_base_id
        end
        
        if pre_wnd_base_id ~= WND.None then
            self:show_wnd_base(self.last_wnd_base, false, args)
            return true
        else
            
            return false
        end
    else
        self._NORMAL_back_sequence:pop()
        
        local back_wnd_base = self._NORMAL_back_sequence:peek()
        if back_wnd_base then
            self:show_wnd_base(back_wnd_base, false, args)
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


function ui_manager:destroy_all_shown_wnd_bases(include_fixed)
    if include_fixed == nil then include_fixed = true end
    if include_fixed then
        for k, v in pairs(self._shown_wnd_bases) do
            self:destroy_wnd_base(k, 0.1)
        end
    else
        for k, v in pairs(self._shown_wnd_bases) do
            if v.wnd_base_type ~= wnd_base_type.FIXED then
                self:destroy_wnd_base(k, 0.1)
            end
        end
    end
end


return ui_manager
