--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--header
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

wnd_pvpgz_view = {
    CloseBtn,
    MainPanel,
    ui_pvpgz_awardlevel,
    ui_pvpgz_awardgrid,
    AddcolliderforCloseBtn,
}

local this = wnd_pvpgz_view


function wnd_pvpgz_view:initview(root)
    self = root
    this.ui_pvpgz_awardlevel = self.transform:Find("ui_pvpgz_awardpanel/ui_pvpgz_awardgrid/ui_pvpgz_awardlevel_1").gameObject
    this.CloseBtn = self.transform:Find("ui_pvpgz_staticitem/CloseBtn").gameObject
    this.MainPanel = self.transform.gameObject
    this.ui_pvpgz_awardgrid = self.transform:Find("ui_pvpgz_awardpanel/ui_pvpgz_awardgrid").gameObject
    this:AddcolliderforCloseBtn()
end


function wnd_pvpgz_view:AddcolliderforCloseBtn()
    collider = this.CloseBtn:AddComponent(typeof(UnityEngine.BoxCollider))
    collider.isTrigger = true
    collider.center = Vector3.zero
    collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0)
end

return wnd_pvpgz_view