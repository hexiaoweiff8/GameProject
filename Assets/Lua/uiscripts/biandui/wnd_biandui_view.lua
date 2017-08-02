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


function wnd_biandui_view:initview(root)
    self = root

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
    this.qianfeng_bushu = self.transform:Find("qianfeng_panel/qianfeng_bg/qianfeng_bushu").gameObject

    this.AddIcon = self.transform:Find("daying_item_panel_col/daying_item_panel/daying_item_grid/add_bg").gameObject

    this.MainPanel = self.transform.gameObject

    this.card_item_grid = self.transform:Find("card_item_panel_col/card_item_panel/card_item_grid").gameObject
    this.daying_item_grid = self.transform:Find("daying_item_panel_col/daying_item_panel/daying_item_grid").gameObject

    this.select_card_panel = self.transform:Find("select_card_panel").gameObject
    this.card_clone_panel = self.transform:Find("card_clone_panel").gameObject
    this.card_clone_item = this.card_clone_panel.transform:Find("card_clone_item").gameObject

    this.TriggerBox = self.transform:Find("TriggerBOX").gameObject

    this.daying_item_panel_col = self.transform:Find("daying_item_panel_col").gameObject
    this.card_item_panel_col = self.transform:Find("card_item_panel_col").gameObject

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