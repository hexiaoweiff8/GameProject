---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:14
---

local skill_controller = {}
local _view
local _data
function skill_controller:Init(view)
    _view = require("uiscripts/fight/skill/skill_view")
    _data = require("uiscripts/fight/skill/skill_model")
    _view:initView(view)
    local i = 100
    for var = 1, Const.FIGHT_SKILLNUM do
        UIEventListener.Get(_view.skill[var].gameObject).onPress = function(go, args)
            if args then
                print("skill"..var)
                AStarControl:SetMaxDropX(i)
                i = i + 100
            end
        end
    end

end


function skill_controller:OnDestroyDone()
    _view = nil
    _data = nil
    Memory.free("uiscripts/fight/skill/skill_view")
    Memory.free("uiscripts/fight/skill/skill_model")
end
return skill_controller