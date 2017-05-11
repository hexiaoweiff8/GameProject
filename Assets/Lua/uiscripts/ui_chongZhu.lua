local class = require("common/middleclass")
local ui_chongzhu = class("ui_chongzhu", wnd_base)
local v
function ui_chongzhu:OnShowDone()
    ui_chongzhu = self
    self.bg = self.transform:Find("bg")--eqBg
    self.eqBg = self.bg:Find("eqBg")--eqBg
    self.chongzhushuxingBg = self.bg:Find("shuxingBg")--3条待选属性bg
    self.daojuBg = self.bg:Find("daojuBg")--道具bg
    self.djBg = self.daojuBg:Find("bg")--道具bg
    local eqNameUL = self.eqBg:Find("nameBg/eqName"):GetComponent(typeof(UILabel))
    
    
    if iseqShuXingBg then --装备详情界面跳转
        v = equipP.nowEqList[eqInfoType]
    else --更换装备界面跳转
        v = equipP.allEqList[eqChangeType][eqChangeIndex]
    end
    
    setEqIconView(self.eqBg, v)
    eqNameUL.text = sdata_Equip_data:GetV(sdata_Equip_data.I_EquipName, v.EquipID)
    eqNameUL.color = eqNameColor[v.EquipQuality]
    self.bg:Find("maiShuxingBg/shuxing"):GetComponent(typeof(UILabel)).text = sdata_EffectName_data:GetV(sdata_EffectName_data.I_EffectName, v.MainEffectID) .. "+" .. sdata_EquipPlan_data[sdata_Equip_data:GetV(sdata_Equip_data.I_MainEffect, v.EquipID)][v.MainEffectID].up .. sdata_EffectName_data:GetV(sdata_EffectName_data.I_Symbol, v.MainEffectID)
    
    
    self.shuxingBg = {}--5个附加属性btn
    self.shuxingBgSpr = {}--5个附加属性UISprite
    self.shuxingUL = {}--5个附加属性UILabel
    
    for i = 1, 5 do
        self.shuxingBg[i] = self.bg:Find("shuxingBg" .. i)
        self.shuxingBgSpr[i] = self.shuxingBg[i]:GetComponent(typeof(UISprite))
        self.shuxingUL[i] = self.shuxingBg[i]:Find("shuxing"):GetComponent(typeof(UILabel))
    end
    
    
    --设置附加属性
    for i, v in ipairs(v.ViceEffect) do --已激活属性
        self.shuxingBgSpr[i].spriteName = "chongzhu_annv_shuxingxuanze_yijihuo"
        self.shuxingUL[i].text = sdata_EffectName_data:GetV(sdata_EffectName_data.I_EffectName, v.ShuXingID) .. "+" .. v.ShuXingNum .. sdata_EffectName_data:GetV(sdata_EffectName_data.I_Symbol, v.ShuXingID)
        UIEventListener.Get(self.shuxingBg[i].gameObject).onClick = function(go)
            if self.chongzhushuxingBg.gameObject.activeSelf then
                return
            end
            --点击增加选中效果
            for j, v in ipairs(self.shuxingBg) do
                if j ~= i then
                    self.shuxingBg[j]:Find("selectEffect1").gameObject:SetActive(false)
                    self.shuxingBgSpr[j].spriteName = "chongzhu_annv_shuxingxuanze_yijihuo"
                end
            end
            self.shuxingBgSpr[i].spriteName = "chongzhu_annv_shuxingxuanze_xuanzhong"
            self.shuxingBg[i]:Find("selectEffect1").gameObject:SetActive(true)
            self:setDaoJuInfo(i)
        end
    end
    local str = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 10001)
    for i = #v.ViceEffect + 1, v.EquipQuality - 1 do --未激活属性
        self.shuxingBgSpr[i].spriteName = "chongzhu_annv_shuxingxuanze_weijihuo"
        self.shuxingUL[i].text = string.gsub(str, "#N", tostring(i * 3))
    end
    for i = v.EquipQuality, 5 do --不可激活属性
        self.shuxingBgSpr[i].spriteName = "chongzhu_annv_shuxingxuanze_bukecaozuo"
        self.shuxingBg[i]:Find("czsuoSpr").gameObject:SetActive(true)
        self.shuxingUL[i].enabled = false
    end
    
    self.backBtn = self.bg:Find("backBtn")--返回按钮
    UIEventListener.Get(self.backBtn.gameObject).onClick = function(go)
            -- if self.chongzhushuxingBg.gameObject.activeSelf then --TODODO 如果已经在选择重铸属性则不可关闭界面
            --     return
            -- end
            ui_manager:DestroyWB(self)
    end
    
    
    
    self.cz_shuxingBg = {}--3个重铸属性btn
    self.cz_selectEffect = {}--3个重铸属性Bg选中效果
    self.cz_shuxingUL = {}--3个重铸属性UILabel
    for i = 1, 3 do
        self.cz_shuxingBg[i] = self.chongzhushuxingBg:Find("shuxingBg" .. i)
        self.cz_selectEffect[i] = self.cz_shuxingBg[i]:Find("selectEffect")
        self.cz_shuxingUL[i] = self.cz_shuxingBg[i]:Find("shuxing"):GetComponent(typeof(UILabel))
        UIEventListener.Get(self.cz_shuxingBg[i].gameObject).onClick = function(go)
                --点击增加选中效果
                for j, v in ipairs(self.cz_shuxingBg) do
                    if j ~= i then
                        self.cz_selectEffect[j].gameObject:SetActive(false)
                    end
                end
                self.cz_selectEffect[i].gameObject:SetActive(true)
        end
    end
    
    for i, v in ipairs(v.ViceEffect) do --如果有待替换副属性设置左侧选中状态
        if v.Remake then --如果有待替换副属性
            self.shuxingBgSpr[i].spriteName = "chongzhu_annv_shuxingxuanze_xuanzhong"
            self.shuxingBg[i]:Find("selectEffect1").gameObject:SetActive(true)
            self.daojuBg.gameObject:SetActive(false)
            
            self.bg:Find("info2 (1)").gameObject:SetActive(false)
            self.bg:Find("info1 (1)").gameObject:SetActive(true)
            self:setCZShuXingInfo(i)
            break
        end
    end
end

--设置消耗道具显示信息
function ui_chongzhu:setDaoJuInfo(index)
    self.djBg.gameObject:SetActive(true)
end

--设置3条重铸属性显示信息
function ui_chongzhu:setCZShuXingInfo(index)
    self.chongzhushuxingBg.gameObject:SetActive(true)
    for i, v in ipairs(v.ViceEffect[index].Remake) do
        self.cz_shuxingUL[i].text = sdata_EffectName_data:GetV(sdata_EffectName_data.I_EffectName, v.RemakeShuXingID) .. "+" .. v.RemakeShuXingNum .. sdata_EffectName_data:GetV(sdata_EffectName_data.I_Symbol, v.RemakeShuXingID)
    end
end

return ui_chongzhu
