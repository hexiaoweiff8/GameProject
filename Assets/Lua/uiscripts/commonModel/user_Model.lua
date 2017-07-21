---
--- Created by Administrator.
--- DateTime: 2017/6/30 10:57
---
local class = require("common/middleclass")

local UserRole = class("UserRole")
--用户id, 服务器id, 角色数字id, 角色名, 经验值, vip经验值, 角色等级，VIP等级，可堆叠道具(背包)
function UserRole:initialize(uid,hostId,rId,userName,exp,vipexp,lv,vipLv,sex,sign)
    self.uid = uid
    self.hostId = hostId
    self.rId = rId
    self.userName = userName
    self.exp = exp
    self.vipexp = vipexp
    self.lv = lv
    self.vipLv = vipLv
    self.sex = sex
    self.sign = {
        isSigned = sign.isSigned,
        days = sign.days
    }
end

userModel = {}
local userRoleTbl ={}

function userModel:initUserRoleTbl(user)
    print( string.format("User==> uid:%d, hostid:%d, rid:%d, username:%s, exp:%d, vipexp:%d, sex:%d isSign:%d",user.uId, user.hostId, user.rId, user.userName, user.exp, user.vipexp, user.sex, user.sign.isSigned))
    userRoleTbl = UserRole(user.uId, user.hostId, user.rId, user.userName, user.exp, user.vipexp, user.lv, user.vip, user.sex, user.sign)
end

function userModel:setUserID(user)
    userRoleTbl.uId = user.uId
end
function userModel:setHostID(user)
    userRoleTbl.hostId = user.hostId
end
function userModel:setRID(user)
    userRoleTbl.rId = user.rId
end
function userModel:getRID()
    return userRoleTbl.rId
end
function userModel:setUserName(user)
    userRoleTbl.userName = user.userName
end
function userModel:setExp(user)
    userRoleTbl.exp = user.exp
end
function userModel:setVipExp(user)
    userRoleTbl.vipexp = user.vipexp
end
function userModel:setLv(user)
    userRoleTbl.lv = user.lv
end
function userModel:setVipLv(user)
    userRoleTbl.vipLv= user.vip
end
function userModel:setSex(user)
    userRoleTbl.sex= user.sex
end
function userModel:setSign(sign)
    userRoleTbl.sign.isSigned = sign.isSigned
    userRoleTbl.sign.days = sign.days
end

function userModel:getUserRoleTbl()
    return userRoleTbl
end