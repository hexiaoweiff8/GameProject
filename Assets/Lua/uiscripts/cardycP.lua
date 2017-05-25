local class = require("common/middleclass")

UserRole = class("UserRole")
--用户id, 服务器id, 角色数字id, 角色名, 经验值, vip经验值, 可堆叠道具(背包)
function UserRole:initialize(uid,hostId,rId,userName,exp,vipexp,lv,vipLv,item)
    self.uid = uid
    self.hostId = hostId
    self.rId = rId
    self.userName = userName
    self.exp = exp
    self.vipexp = vipexp
    self.lv = lv
    self.vipLv = vipLv
    self.item = item
end
userRoleTbl ={}

Currency = class("Currency")
--金币, 钻石, 技能点, 经验池, 兵牌, 体力
function Currency:initialize(gold,diamond,skillpt,expPool,coin,tili)
    self.gold = gold
    self.diamond = diamond
    self.skillpt = skillpt
    self.expPool = expPool
    self.coin = coin
    self.tili = tili
end
currencyTbl ={}

Card = class("Card")
--id,经验,星级,兵员等级,军阶等级,卡牌数量,插槽状态表,技能表,协同表
function Card:initialize(id,exp,star,slv,rlv,num,slot,skill,team,lv)
    self.id = id
    self.exp = exp
    self.star = star
    self.slv = slv 
    self.rlv = rlv
    self.num = num
    self.slot = slot
    self.skill = skill
    self.team = team
    self.lv = lv
end
cardTbl = {}
