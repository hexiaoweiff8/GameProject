---
--- Created by Administrator.
--- DateTime: 2017/8/2 20:00
---
ui_skill_view = {



}

--local this = wnd_skill_view
function ui_skill_view:initView()
    self.skilllist = {}
    local parent = UnityEngine.GameObject.Find("UIRoot/FlyRoot")
    self.root = GameObjectExtension.InstantiateFromPacket("ui_skill", "ui_skill", parent).gameObject
    self.root.name = "ui_skill"
    self.ui_skill_grid = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid").gameObject
    self.skillitem = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill1").gameObject
    self.beselect = self.root.transform:Find("ui_skill_panel_col/beselect").gameObject
    self.skillselect = self.root.transform:Find("ui_skill_panel_col/selectskill_bg").gameObject

    self.ui_skill_panel_col = self.root.transform:Find("ui_skill_panel_col").gameObject


    self.root.transform:Find("ui_skill_panel_col/ui_skill_panel").gameObject:GetComponent("UIPanelEX").depth = 9997

    --self.skillitem:SetActive(true)
    self.ui_skill_grid:GetComponent("UIGrid").enabled = true
    self.ui_skill_grid:GetComponent("UIGrid"):Reposition()
    self:Getskilllist()
    self:AddColForSkill()
    self.root:SetActive(false)
end

function ui_skill_view:Getskilllist()
    ---测试数据-----
    local skillItem1 = {}
    local skillpicItem1 = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill1").gameObject

    local skilldataItem1 = {}
    skilldataItem1["canbeselect"] = true
    skilldataItem1["selectstate"] = 2

    skillItem1["pic"] = skillpicItem1
    skillItem1["data"] = skilldataItem1

    local skillItem2 = {}
    local skillpicItem2 = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill2").gameObject

    local skilldataItem2 = {}
    skilldataItem2["canbeselect"] = true
    skilldataItem2["selectstate"] = 1

    skillItem2["pic"] = skillpicItem2
    skillItem2["data"] = skilldataItem2

    local skillItem3 = {}
    local skillpicItem3 = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill3").gameObject

    local skilldataItem3 = {}
    skilldataItem3["canbeselect"] = true
    skilldataItem3["selectstate"] = 3

    skillItem3["pic"] = skillpicItem3
    skillItem3["data"] = skilldataItem3

    local skillItem4 = {}
    local skillpicItem4 = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill4").gameObject

    local skilldataItem4 = {}
    skilldataItem4["canbeselect"] = true
    skilldataItem4["selectstate"] = 0

    skillItem4["pic"] = skillpicItem4
    skillItem4["data"] = skilldataItem4

    local skillItem5 = {}
    local skillpicItem5 = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill1 (4)").gameObject

    local skilldataItem5 = {}
    skilldataItem5["canbeselect"] = false
    skilldataItem5["selectstate"] = 0

    skillItem5["pic"] = skillpicItem5
    skillItem5["data"] = skilldataItem5

    local skillItem6 = {}
    local skillpicItem6 = self.root.transform:Find("ui_skill_panel_col/ui_skill_panel/ui_skill_grid/skill1 (5)").gameObject

    local skilldataItem6 = {}
    skilldataItem6["canbeselect"] = false
    skilldataItem6["selectstate"] = 0

    skillItem6["pic"] = skillpicItem6
    skillItem6["data"] = skilldataItem6

    table.insert(self.skilllist,skillItem1)
    table.insert(self.skilllist,skillItem2)
    table.insert(self.skilllist,skillItem3)
    table.insert(self.skilllist,skillItem4)
    table.insert(self.skilllist,skillItem5)
    table.insert(self.skilllist,skillItem6)

end


function ui_skill_view:AddColForSkill()
    for k,v in pairs(self.skilllist) do
        collider = v["pic"]:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.isTrigger = true
        collider.center = Vector3.zero
        collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0)
    end
end


return ui_skill_view