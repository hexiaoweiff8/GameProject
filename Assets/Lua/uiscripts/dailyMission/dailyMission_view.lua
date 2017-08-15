
dailyMission_view = {
    --每日任务Item预制体
    missionItemPerfab,

    --左侧标签
    meirirenwu,
    zhanluemubiao,

    --显示每日任务的Grid
    itemGrid,

    --按钮
    btn_close,


    ----静态文字----
    meirirenwu_label,
    zhanluemubiao_label,
    title_label,
    missionItemPerfab_btnlingqu_label,
    missionItemPerfab_btnqianwang_label,
    ----静态文字----


}


local this = dailyMission_view

function dailyMission_view:InitView(root)
    this.missionItemPerfab = root.transform:FindChild("missionItem").gameObject

    this.meirirenwu = root.transform:FindChild("left/Grid/meirirenwu").gameObject
    this.zhanluemubiao = root.transform:FindChild("left/Grid/zhanluemubiao").gameObject

    this.itemGrid = root.transform:FindChild("Windows/Scroll View/Grid"):GetComponent("UIGrid")

    this.btn_close = root.transform:FindChild("Top/btn_close").gameObject
    ----静态文字----
    this.meirirenwu_label = root.transform:FindChild("left/Grid/meirirenwu/Label"):GetComponent("UILabel")
    this.zhanluemubiao_label = root.transform:FindChild("left/Grid/zhanluemubiao/Label"):GetComponent("UILabel")
    this.title_label = root.transform:FindChild("Top/renwuLabel"):GetComponent("UILabel")
    this.missionItemPerfab_btnlingqu_label = root.transform:FindChild("missionItem/right/btn_lingqu/Label"):GetComponent("UILabel")
    this.missionItemPerfab_btnqianwang_label = root.transform:FindChild("missionItem/right/btn_qianwang/Label"):GetComponent("UILabel")
    this:InitStaticString()
    ----静态文字----


end

function dailyMission_view:InitStaticString()
    this.meirirenwu_label.text = stringUtil:getString(32002)
    this.zhanluemubiao_label.text = stringUtil:getString(32003)
    this.title_label.text = stringUtil:getString(32001)
    this.missionItemPerfab_btnlingqu_label.text = stringUtil:getString(32004)
    this.missionItemPerfab_btnqianwang_label.text = stringUtil:getString(32005)

end

return dailyMission_view