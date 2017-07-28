---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:14
---

local skill_view = {}

local view
function skill_view:initView(arg)
    view = arg
    self.skill = {}
    self.skill_CDBar= {}

    for i = 1, Const.FIGHT_SKILLNUM do
        self.skill[i] = view.transform:Find("skill/skill" .. i).gameObject
        self.skill_CDBar[i] = self.skill[i].transform:Find("CDBar").gameObject
    end

end

return skill_view