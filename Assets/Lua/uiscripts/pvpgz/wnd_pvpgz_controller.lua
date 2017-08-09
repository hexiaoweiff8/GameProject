---
--- Created by Administrator.
--- DateTime: 2017/7/17 16:39
---

wnd_pvpgz_controller ={
    OnShowDone,
    CreatList,
    initListener,
}

local class = require("common/middleclass")
wnd_pvpgz_controller = class("wnd_pvpgz_controller", wnd_base)
local this = wnd_pvpgz_controller

function wnd_pvpgz_controller:OnShowDone()
    this.view = require("uiscripts/pvpgz/wnd_pvpgz_view")
    this.view:initview(self)

    this.model = require("uiscripts/pvpgz/wnd_pvpgz_model")
    this.model:initModel()

    this:CreatList()
    this:initListener()

    print("wnd_pvpguize_controller  ++++  OnShowDone")
end


function wnd_pvpgz_controller:initListener()
    UIEventListener.Get(this.view.CloseBtn).onClick = function()
        this.view.MainPanel:SetActive(false)
    end
end




function wnd_pvpgz_controller:CreatList()

    ------------TO  DO --------边框颜色和图标还没定！！！！！！！！----------------------------
    local preobj = this.view.ui_pvpgz_awardlevel
    local pobj = this.view.ui_pvpgz_awardgrid
    local go = nil
    for index = 1,#this.model.local_contestgain do
        if(index~=1) then
            go =  GameObjectExtension.InstantiateFromPreobj(preobj,pobj)
            pobj:GetComponent("UIGrid"):AddChild(go.transform,false)
        else
            go = this.view.ui_pvpgz_awardlevel
        end
        go.transform:Find("paiming_label").gameObject:GetComponent("UILabel").text = this.model:getitemRank(index)
        ----TODO:set  value-----
        local PkPtInfo = this.model:getPkPt(index)
        print("index-------"..index )
        --go.transform:Find("award_1/awardquality_bg/awardquality_frame").gameObject:GetComponent(typeof(UISprite)).spriteName,
        --go.transform:Find("award_1/awardquality_bg").gameObject:GetComponent(typeof(UISprite)).spriteName
        --= require("uiscripts/shop/wnd_shop_model"):getQualitySpriteStr(PkPtInfo["Quality"])

        go.transform:Find("award_1/awardquality_bg/awardquality_frame").gameObject:GetComponent(typeof(UISprite)).spriteName="pvp_jiangli_jiao_chengse"
        go.transform:Find("award_1/awardquality_bg").gameObject:GetComponent(typeof(UISprite)).spriteName="pvp_jiangli_kuang_chengse"

        go.transform:Find("award_1/awardquality_bg/awardquality_frame/awardquality_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
        = PkPtInfo["Icon"]
        go.transform:Find("award_1/awardquality_bg/awardquality_frame/awardquality_icon/award_number").gameObject:GetComponent("UILabel").text
        = "x"..tostring(PkPtInfo["Num"])

        ---------------------------------

        local CoinInfo = this.model:getCoin(index)
        print("index-------"..index )
        --go.transform:Find("award_2/awardquality_bg/awardquality_frame").gameObject:GetComponent(typeof(UISprite)).spriteName,
        --go.transform:Find("award_2/awardquality_bg").gameObject:GetComponent(typeof(UISprite)).spriteName
        --= require("uiscripts/shop/wnd_shop_model"):getQualitySpriteStr(CoinInfo["Quality"])
        go.transform:Find("award_2/awardquality_bg/awardquality_frame").gameObject:GetComponent(typeof(UISprite)).spriteName="pvp_jiangli_jiao_chengse"
        go.transform:Find("award_2/awardquality_bg").gameObject:GetComponent(typeof(UISprite)).spriteName="pvp_jiangli_kuang_chengse"


        go.transform:Find("award_2/awardquality_bg/awardquality_frame/awardquality_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
        = CoinInfo["Icon"]
        go.transform:Find("award_2/awardquality_bg/awardquality_frame/awardquality_icon/award_number").gameObject:GetComponent("UILabel").text
        = "x"..tostring(CoinInfo["Num"])

        -------------------------------------------------------------
        local ItemInfo = this.model:getItem(index)
        --go.transform:Find("award_3/awardquality_bg/awardquality_frame").gameObject:GetComponent(typeof(UISprite)).spriteName,
        --go.transform:Find("award_3/awardquality_bg").gameObject:GetComponent(typeof(UISprite)).spriteName
        --= require("uiscripts/shop/wnd_shop_model"):getQualitySpriteStr(ItemInfo["Quality"])

        go.transform:Find("award_3/awardquality_bg/awardquality_frame").gameObject:GetComponent(typeof(UISprite)).spriteName="pvp_jiangli_jiao_chengse"
        go.transform:Find("award_3/awardquality_bg").gameObject:GetComponent(typeof(UISprite)).spriteName="pvp_jiangli_kuang_chengse"
        go.transform:Find("award_3/awardquality_bg/awardquality_frame/awardquality_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
        = ItemInfo["Icon"]
        go.transform:Find("award_3/awardquality_bg/awardquality_frame/awardquality_icon/award_number").gameObject:GetComponent("UILabel").text
        = "x"..tostring(ItemInfo["Num"])
        if(ItemInfo["Num"] == 0) then
            go.transform:Find("award_3").gameObject:SetActive(false)
        end
    end
end


return wnd_pvpgz_controller