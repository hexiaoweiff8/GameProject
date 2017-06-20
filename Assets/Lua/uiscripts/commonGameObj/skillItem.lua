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
    
    --设置图集
    -- skillItem.skillItem_imgSp.transform:GetComponent("UISprite").atlas = TestAtlas



    self.skillItem_bg:SetActive(true)
    self.skillItem_bklockSp:SetActive(false)

    if func then 
        UIEventListener.Get(self.skillItem_imgSp).onClick = function()
            func(_,index)
        end
    end
end

function SkillItem:refresh(skillId, skillLv, starLv, index)
    self.skillItem_imgSp.transform:GetComponent("UISprite").spriteName = skillUtil:getskillIconByID(skillId)
    self.skillItem_redDot:SetActive(redDotFlag.RD_SKILLITEMS[index])
    if index > starLv then
        self.skillItem_bg:SetActive(false)
        self.skillItem_bklockSp:SetActive(true)
        self.skillItem_lv_Lab.transform:GetComponent("UILabel").text = "0"
        --根据index显示该技能解锁的星级 
        self.skillItem_name_Lab.transform:GetComponent("UILabel").text = stringUtil:getString(20043 + index)
        self.skillItem_imgSp.transform:GetComponent("UISprite").color = Color(123/255,123/255,123/255,123/255)
        return
    end
    --根据当前星级设置该技能的显示状态
    self.skillItem_bg:SetActive(true)
    self.skillItem_bklockSp:SetActive(false)
    self.skillItem_imgSp.transform:GetComponent("UISprite").color= Color(1,1,1,1)
    self.skillItem_lv_Lab.transform:GetComponent("UILabel").text = skillLv
    self.skillItem_name_Lab.transform:GetComponent("UILabel").text = skillUtil:getskillNameByID(skillId)   --解锁技能名
    
end
return SkillItem