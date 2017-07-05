local class = require("common/middleclass")
SkillItem = class("SkillItem")


function SkillItem:initialize(parent, position, index, func)
    
    self.skillItem = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "skillFrame", parent).gameObject
    self.skillItem_bg = self.skillItem.transform:Find("bg").gameObject --
    self.skillItem_lv_bg = self.skillItem.transform:Find("bg/lv_bg").gameObject --
    self.skillItem_imgSp = self.skillItem.transform:Find("img_Sp").gameObject --技能图
    self.skillItem_name_Lab = self.skillItem.transform:Find("name_Lab").gameObject --技能名
    self.skillItem_lv_Lab = self.skillItem.transform:Find("lv_Lab").gameObject --
    self.skillItem_redDot = self.skillItem.transform:Find("redDot").gameObject --
    self.skillItem_bklockSp = self.skillItem.transform:Find("bklockSp").gameObject
    self.skillItem_bklockSp_Sprite = self.skillItem_bklockSp.transform:Find("Sprite").gameObject
    self.skillItem_bklockSp_LockSp = self.skillItem_bklockSp.transform:Find("lockSp").gameObject


    local depthNum = parent.transform:GetComponent("UIWidget").depth
    self.skillItem.transform:GetComponent("UIWidget").depth = depthNum
    self.skillItem.transform.localPosition = position

    self.skillItem_bg.transform:GetComponent("UISprite").depth = depthNum + 1
    self.skillItem_lv_bg.transform:GetComponent("UISprite").depth = depthNum + 3
    self.skillItem_imgSp.transform:GetComponent("UISprite").depth = depthNum + 2
    self.skillItem_name_Lab.transform:GetComponent("UILabel").depth = depthNum + 1
    self.skillItem_lv_Lab.transform:GetComponent("UILabel").depth = depthNum + 3
    self.skillItem_redDot.transform:GetComponent("UISprite").depth = depthNum + 3
    self.skillItem_bklockSp.transform:GetComponent("UISprite").depth = depthNum + 4
    self.skillItem_bklockSp_Sprite.transform:GetComponent("UISprite").depth = depthNum + 5
    self.skillItem_bklockSp_LockSp.transform:GetComponent("UISprite").depth = depthNum + 5

    self.skillItem_bg:SetActive(true)
    self.skillItem_bklockSp:SetActive(false)

    --如果index不存在，则显示在详细信息面板上，则不用显示以下内容
    if not index then 
        -- self.skillItem_lv_bg:SetActive(false)
        -- self.skillItem_lv_Lab:SetActive(false)
        -- self.skillItem_bklockSp:SetActive(false)
        -- self.skillItem_bklockSp = nil
        self.skillItem_redDot:SetActive(false)
        self.skillItem_redDot = nil
    end
    if func then 
        UIEventListener.Get(self.skillItem_imgSp).onClick = function()
            func(_,index)
        end
    end
end

function SkillItem:refresh(skillId, skillLv, starLv, index)

    self.skillItem_imgSp.transform:GetComponent("UISprite").spriteName = skillUtil:getskillIconByID(skillId)
    self.skillItem_name_Lab.transform:GetComponent("UILabel").text = skillUtil:getskillNameByID(skillId)   --解锁技能名
    
    --通过红点的状态判断技能图标的显示状态
    if not self.skillItem_redDot  then 
        self.skillItem_bg:SetActive(true)
        self.skillItem_lv_bg:SetActive(false)
        self.skillItem_lv_Lab:SetActive(false)  
        self.skillItem_bklockSp:SetActive(false)   
        return 
    end 
    
    --技能尚未解锁
    if index > starLv then 
        self.skillItem_bg:SetActive(false)
        self.skillItem_lv_bg:SetActive(false)
        self.skillItem_lv_Lab:SetActive(false)   
        self.skillItem_bklockSp:SetActive(true)   
        self.skillItem_bklockSp_Sprite:SetActive(false)
        self.skillItem_redDot:SetActive(false)
        self.skillItem_name_Lab.transform:GetComponent("UILabel").text = stringUtil:getString(20043 + index)
        return
    end 


    --技能已经解锁
    self.skillItem_bg:SetActive(true)
    self.skillItem_lv_bg:SetActive(true)
    self.skillItem_lv_Lab:SetActive(true)   
    self.skillItem_bklockSp:SetActive(false)   
    self.skillItem_redDot:SetActive(redDotFlag.RD_SKILLITEMS[index])
    self.skillItem_lv_Lab.transform:GetComponent("UILabel").text = skillLv
       
end
return SkillItem