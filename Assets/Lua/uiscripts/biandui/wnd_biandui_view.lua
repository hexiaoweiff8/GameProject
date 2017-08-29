wnd_biandui_view = {
    biandui_btn = {},

    dayingItem,
    cardItem,
    MainPanel,
    AddIcon,
    select_card_panel,
    btn_delete,

    card_item_panel_col,
    daying_item_panel_col,
    card_clone_panel,
    daying_item_panel,

    daying_bingli,

    qianfeng_bingli_now,
    qianfeng_bingli_limit,

    daying_bingli_now,
    daying_bingli_limit,

    pjbingli,
    zongbingli_now,
    zongbingli_limit,

    bingli_huizong,
    card_item_grid,
    daying_item_grid,
    card_item_star_grid,
    TriggerBox,

    qianfeng_bushu,
}

local this = wnd_biandui_view

require("uiscripts/commonGameObj/Model")
function wnd_biandui_view:initview(root)
    self = root

    this.biandui = self.transform

    this.biandui_btn["BackBtn"] = self.transform:Find("ui_biandui_btn/btn_back").gameObject
    this.biandui_btn["CardBtn"] = self.transform:Find("ui_biandui_btn/btn_card").gameObject
    this.biandui_btn["LeftDragBtn"] = self.transform:Find("ui_biandui_btn/btn_left").gameObject
    this.biandui_btn["RightDragBtn"] = self.transform:Find("ui_biandui_btn/btn_right").gameObject

    this.cardItem = self.transform:Find("card_item_panel_col/card_item_panel/card_item_grid/card_item").gameObject
    this.dayingItem = self.transform:Find("daying_item_panel_col/daying_item_panel/daying_item_grid/card_item").gameObject

    this.qianfeng_bingli_now = self.transform:Find("qianfeng_panel/qianfeng/qianfeng_bingli_now").gameObject
    this.qianfeng_bingli_limit = self.transform:Find("qianfeng_panel/qianfeng/qianfeng_bingli_limit").gameObject

    this.daying_bingli_now = self.transform:Find("daying_panel/daying/daying_bingli_now").gameObject
    this.daying_bingli_limit = self.transform:Find("daying_panel/daying/daying_bingli_limit").gameObject

    this.pjbingli = self.transform:Find("bingli_frame/pjbingli").gameObject
    this.zongbingli_now = self.transform:Find("bingli_frame/zongbingli_now").gameObject
    this.zongbingli_limit = self.transform:Find("bingli_frame/zongbingli_limit").gameObject

    this.daying_item_panel = self.transform:Find("daying_item_panel_col/daying_item_panel").gameObject
    this.card_item_panel = self.transform:Find("card_item_panel_col/card_item_panel").gameObject
    this.qianfeng_item_panel_bg = self.transform:Find("qianfeng_item_panel").gameObject


    this.AddIcon = self.transform:Find("daying_item_panel_col/daying_item_panel/daying_item_grid/add_bg").gameObject

    this.MainPanel = self.transform.gameObject

    this.card_item_grid = self.transform:Find("card_item_panel_col/card_item_panel/card_item_grid").gameObject
    this.daying_item_grid = self.transform:Find("daying_item_panel_col/daying_item_panel/daying_item_grid").gameObject

    this.select_card_panel = self.transform:Find("select_card_panel").gameObject
    this.card_clone_panel = self.transform:Find("card_clone_panel").gameObject
    this.card_clone_panel.transform.localPosition = self.transform:Find("daying_item_panel_col").gameObject.transform.localPosition
    this.card_clone_item = this.card_clone_panel.transform:Find("card_clone_item").gameObject

    this.TriggerBox = self.transform:Find("TriggerBOX").gameObject

    this.daying_item_panel_col = self.transform:Find("daying_item_panel_col").gameObject
    this.card_item_panel_col = self.transform:Find("card_item_panel_col").gameObject

    this.btn_zhanshu = self.transform:Find("ui_biandui_btn/btn_card").gameObject

    this.tishi_bg = this.card_clone_panel.transform:Find("tishi_bg").gameObject
    this.tishi_ok = this.tishi_bg.transform:Find("btn_ok").gameObject
    this.tishi_back = this.tishi_bg.transform:Find("btn_back").gameObject

    -----静态文本-----
    this.daying_bingli_label = self.transform:Find("daying_panel/daying/daying_bingli_label").gameObject
    this.daying_bingli_fg = self.transform:Find("daying_panel/daying/daying_bingli_fg").gameObject
    this.pjbingli_label = self.transform:Find("bingli_frame/pjbingli_label").gameObject
    this.zongbingli_label = self.transform:Find("bingli_frame/zongbingli_label").gameObject
    this.zongbingli_fg = self.transform:Find("bingli_frame/zongbingli_fg").gameObject
    this.qianfeng_bingli_label = self.transform:Find("qianfeng_panel/qianfeng/qianfeng_bingli_label").gameObject
    this.qianfeng_bingli_fg = self.transform:Find("qianfeng_panel/qianfeng/qianfeng_bingli_fg").gameObject
    this.card_label = self.transform:Find("ui_biandui_btn/btn_card/card_label").gameObject
    this.select_card_info_label = self.transform:Find("select_card_panel/select_card_bg/select_card_info/select_card_info_label").gameObject
    this.select_card_add_label = self.transform:Find("select_card_panel/select_card_bg/select_card_add/select_card_add_label").gameObject
    -------------------

    ----技能按钮------
    this.skill1 = self.transform:Find("skill_panel/skill_1").gameObject
    this.skill2 = self.transform:Find("skill_panel/skill_2").gameObject
    this.skill3 = self.transform:Find("skill_panel/skill_3").gameObject
    -----------------

    ---------显示模型--------------
    this.playerModelTexture = self.transform:Find("qianfeng_item_panel/playerModelTexture").gameObject
    this.camera3D = self.transform:Find("Camera3D").gameObject

    this.myTexture = UnityEngine.RenderTexture(1024, 1024, 24)
    this.myTexture:Create()
    this.camera3D:GetComponent(typeof(UnityEngine.Camera)).targetTexture = this.myTexture
    this.playerModelTexture:GetComponent(typeof(UITexture)).mainTexture = this.myTexture


    this.CloneTexture = self.transform:Find("card_clone_panel/CloneTexture").gameObject
    this.CloneCamera = self.transform:Find("CloneCamera").gameObject
    this.myclonetexture = UnityEngine.RenderTexture(1024, 1024, 24)
    this.myclonetexture:Create()
    this.CloneCamera:GetComponent(typeof(UnityEngine.Camera)).targetTexture = this.myclonetexture
    this.CloneTexture:GetComponent(typeof(UITexture)).mainTexture = this.myclonetexture

    ---高亮位置外部碰撞体---
    this.pos_col = {}
    for i =1,6 do
        this.pos_col[i] = self.transform:Find("qianfeng_item_panel/"..tostring(i)).gameObject
    end

    ---高亮位置图片---
    this.pos = {}
    for i =1,6 do
        this.pos[i] = self.transform:Find("qianfeng_item_panel/"..tostring(i).."/".."pos"..tostring(i)).gameObject
    end
    this:AddcolliderforBtn()
    this:InitItem()
end


function wnd_biandui_view:AddcolliderforBtn()
    for k,v in pairs(this.biandui_btn) do
        collider = v:AddComponent(typeof(UnityEngine.BoxCollider))
        collider.isTrigger = true
        collider.center = Vector3.zero
        collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0)
    end
end


function wnd_biandui_view:InitItem()
    this.dayingItem:SetActive(false)
    this.cardItem:SetActive(false)
end

return wnd_biandui_view