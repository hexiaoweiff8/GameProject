---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:56
---
local userInfo_view = {}


local view
function userInfo_view:initView(arg)
    view = arg

    self.userInfo = view.transform:Find("userInfoBg").gameObject
    self.myGameInfo = view.transform:Find("myInfo").gameObject
    self.enemyGameInfo = view.transform:Find("enemyInfo").gameObject
    self.MyHP = self.myGameInfo.transform:Find("bloodBG/hp_fg").gameObject
    self.MyAnimHP = self.myGameInfo.transform:Find("bloodBG/hp_anim").gameObject
    self.BeHitTips = self.myGameInfo.transform:Find("beHitTips").gameObject
    self.lowBloodTips = view.transform:Find("lowBloodTips").gameObject
end


return userInfo_view