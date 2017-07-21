---
--- Created by Administrator.
--- DateTime: 2017/7/12 12:30
---
local remake_model = {
    equipToShow = nil,
    selectIndex = 0,
    chooseIndex = 0,


    ---
    ---初始化各个属性的重铸状态
    ---
    remakedNum = 0 ,       ---已重铸装备的数量
    remakedFlagList = {},  ---保存各个属性状态信息
    RemakedFlag = {        ---状态
        REMAKED = 2,            --已重铸
        REMAKE_AND_CHANGE = 1,  --已重铸，且可替换
        NOT_REMAKE = 0,         --未重铸
        UNACTIVE = -1           --未激活
    }

}

function remake_model:getProptyRemakeStatus()
    self.remakedNum = 0
    ---计算当前已重铸属性的数量,保存各个副属性的重铸状态
    for i = 1, Const.EQUIP_NORMALPROP_NUM do
        ---判断副属性是否存在
        if i <= #self.equipToShow.sndAttr then
            ---判断是否已经重铸
            if self.equipToShow.sndAttr[i].isRemake >= 1 then
                self.remakedNum = self.remakedNum + 1
                if self.equipToShow.sndAttr[i].remake and #self.equipToShow.sndAttr[i].remake ~= 0 then
                    self.remakedFlagList[i] = self.RemakedFlag.REMAKE_AND_CHANGE
                else
                    self.remakedFlagList[i] = self.RemakedFlag.REMAKED
                end

            else
                self.remakedFlagList[i] = self.RemakedFlag.NOT_REMAKE
            end
        else
            self.remakedFlagList[i] = self.RemakedFlag.UNACTIVE
        end
    end
end
return remake_model
