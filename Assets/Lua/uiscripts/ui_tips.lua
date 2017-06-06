local class = require("common/middleclass")
ui_tips = class("ui_tips", wnd_base)

function ui_tips:OnShowDone()
    print("ui_tips!!!!!!")
    self.tipsLabel = self.transform:Find("Label").gameObject
    local animTime = self.transform:GetComponent("Animation").clip.length
    self.tipsLabel.transform:GetComponent("UILabel").text = tipsText
    self.gameObject:SetActive(true)
    local time = 0
    startTimer(3,function()
        time = time + Time.deltaTime
            if time > 3 then 
                self:animOverCallBack()
                allTimeTickerTb["tipsTimer"]:Stop()
            end
        end,nil,"tipsTimer")
end 

function ui_tips:animOverCallBack()
    print("onend")
    self.gameObject:SetActive(false)
    ui_manager:DestroyWB(self)
end

return ui_tips