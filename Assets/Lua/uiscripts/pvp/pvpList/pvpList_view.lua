
pvpList_view = {

    pindao_toggle =
    {
        --大页签
        jingjibiwu,
        jingjibiwu2,
        --子页签
        jingjibiwu_benqu,
        jingjibiwu_quanfu,
        jingjibiwu_weiwang,
        jingjibiwu_lingdi,

        jingjibiwu2_benqu,
        jingjibiwu2_quanfu,
        jingjibiwu2_weiwang,
        jingjibiwu2_lingdi,
        --子标签的Grid
        jingjibiwu_grid,
        jingjibiwu2_grid,
    },

    pindao_toggle_table,

    pvpItemPerfab,
    pvpScollerView_Grid,


    --3D模型节点
    modeParent,
}

local this = pvpList_view

function pvpList_view:InitView(root)

    this.pindao_toggle.jingjibiwu = root.transform:FindChild("left/Table/jingjibiwu").gameObject
    this.pindao_toggle.jingjibiwu2 = root.transform:FindChild("left/Table/jingjibiwu (1)").gameObject
    this.pindao_toggle.jingjibiwu_benqu = root.transform:FindChild("left/Table/jingjibiwu/Grid/benqu").gameObject
    this.pindao_toggle.jingjibiwu_quanfu = root.transform:FindChild("left/Table/jingjibiwu/Grid/quanfu").gameObject
    this.pindao_toggle.jingjibiwu_weiwang = root.transform:FindChild("left/Table/jingjibiwu/Grid/weiwang").gameObject
    this.pindao_toggle.jingjibiwu_lingdi = root.transform:FindChild("left/Table/jingjibiwu/Grid/lingdi").gameObject
    this.pindao_toggle.jingjibiwu2_benqu = root.transform:FindChild("left/Table/jingjibiwu (1)/Grid/benqu").gameObject
    this.pindao_toggle.jingjibiwu2_quanfu = root.transform:FindChild("left/Table/jingjibiwu (1)/Grid/quanfu").gameObject
    this.pindao_toggle.jingjibiwu2_weiwang = root.transform:FindChild("left/Table/jingjibiwu (1)/Grid/weiwang").gameObject
    this.pindao_toggle.jingjibiwu2_lingdi = root.transform:FindChild("left/Table/jingjibiwu (1)/Grid/lingdi").gameObject

    this.pindao_toggle.jingjibiwu_grid = root.transform:FindChild("left/Table/jingjibiwu/Grid"):GetComponent("UIGrid")
    this.pindao_toggle.jingjibiwu2_grid = root.transform:FindChild("left/Table/jingjibiwu (1)/Grid"):GetComponent("UIGrid")

    this.pindao_toggle_table = root.transform:FindChild("left/Table"):GetComponent("UITable")

    this.pvpItemPerfab = root.transform:FindChild("pvpRankItemPerfab").gameObject
    this.pvpScollerView_Grid = root.transform:FindChild("Window/Scroll View/Grid").gameObject

    --模型节点
   this.modeParent = root.transform:FindChild("3DModeParent").gameObject

    this.pvpItemPerfab:AddComponent(typeof(PVPListItem))
    this.pvpScollerView_Grid:AddComponent(typeof(PVPloopGrid))

end

function pvpList_view:ShowPindao(type) --展示那个频道的标签1.竞技比武 2.竞技比武2（后续再改）
    this.pindao_toggle.jingjibiwu_grid.gameObject:SetActive(false)
    this.pindao_toggle.jingjibiwu2_grid.gameObject:SetActive(false)
    if type == 1 then
        this.pindao_toggle.jingjibiwu_grid.gameObject:SetActive(true)
        else if type == 2 then
        this.pindao_toggle.jingjibiwu2_grid.gameObject:SetActive(true)
        end
    end

    this.pindao_toggle_table.repositionNow = true
    this.pindao_toggle_table:Reposition()
end


return pvpList_view