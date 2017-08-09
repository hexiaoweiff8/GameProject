
wnd_pvpgz_model =
{
    local_contestgain ={},
    initLocalContestgain,
    getPkPt,
    getitemRank,
    getCoin,
    getItem
}

local this = wnd_pvpgz_model
function wnd_pvpgz_model:initModel()
    this:initLocalContestgain()

end


---读本地表的function---
function wnd_pvpgz_model:initLocalContestgain()
    if sdata_contestgain_data == nil then
        print("没获取到以下数据：sdata_contestgain_data")
        return
    end
    for k,v in pairs(sdata_contestgain_data.mData.body) do
        local Tab = {}
        Tab["ID"] = v[sdata_contestgain_data.mFieldName2Index['ID']]
        Tab["Rank1"] = v[sdata_contestgain_data.mFieldName2Index['Rank1']]
        Tab["Rank2"] = v[sdata_contestgain_data.mFieldName2Index['Rank2']]
        Tab["PkPt"] = v[sdata_contestgain_data.mFieldName2Index['PkPt']]
        Tab["Coin"] = v[sdata_contestgain_data.mFieldName2Index['Coin']]
        Tab["Item"] = v[sdata_contestgain_data.mFieldName2Index['Item']]
        Tab["Num"] = v[sdata_contestgain_data.mFieldName2Index['Num']]
        table.insert(this.local_contestgain,Tab)
    end
    table.sort(this.local_contestgain,function(a,b)
        return a["ID"] < b["ID"]
    end)

end

function wnd_pvpgz_model:getitemRank(ID)
    if(this.local_contestgain[ID]["Rank1"] == this.local_contestgain[ID]["Rank2"]) then
        return tostring(this.local_contestgain[ID]["Rank1"])
    elseif(this.local_contestgain[ID]["Rank1"] ~= this.local_contestgain[ID]["Rank2"] and this.local_contestgain[ID]["Rank2"]~=-1) then
        return tostring(this.local_contestgain[ID]["Rank1"]).."~"..tostring(this.local_contestgain[ID]["Rank2"])
    else
        return tostring(this.local_contestgain[ID]["Rank1"]).."+"
    end
end

function wnd_pvpgz_model:getPkPt(ID)
    local PkPtInfo = nil
    PkPtInfo = require("uiscripts/shop/wnd_shop_model"):getShopCurrencyDataRefByField("PkPt")
    PkPtInfo["Num"] = this.local_contestgain[ID]["PkPt"]
    return PkPtInfo
end

function wnd_pvpgz_model:getCoin(ID)
    local CoinInfo = nil
    CoinInfo = require("uiscripts/shop/wnd_shop_model"):getShopCurrencyDataRefByField("coin")
    CoinInfo["Num"] = this.local_contestgain[ID]["Coin"]
    return CoinInfo
end

function wnd_pvpgz_model:getItem(ID)
    local Awarditem = this.local_contestgain[ID]["Item"]
    local _ItemData = nil
    _ItemData = require("uiscripts/cangku/wnd_cangku_model"):getLocalItemDataRefByItemID(tonumber(Awarditem))
    _ItemData["Num"] = this.local_contestgain[ID]["Num"]
    return _ItemData
end



return wnd_pvpgz_model