---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:14
---

local skill_controller = {}
local _view = require("uiscripts/fight/skill/skill_view")
local _data = require("uiscripts/fight/skill/skill_model")
function skill_controller:Init(view)
    _view:initView(view)
    for var = 1, Const.FIGHT_SKILLNUM do
        UIEventListener.Get(_view.skill[var].gameObject).onPress = function(go, args)
            if args then
                print("skill"..var)
            end
        end
    end

end

return skill_controller