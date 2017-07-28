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
end


return userInfo_view