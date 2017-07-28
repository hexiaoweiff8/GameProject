chatWindow_view = {

    panel,
    --按钮
    btn_shijie,
    btn_juntuan,

    btn_send,
    btn_chatBack,
    --精灵
    btn_shijie_sprite,
    btn_juntuan_sprite,

    --label
    input_label,
    input_com,

    --Item_perfabs
    --item_perfab={
    --    otherChatItem,
    --    selfChatItem,
    --    timeItem,
    --},

    chatItemPerfab,

    --滑动窗口
    worldscrollView,
    juntuanscrollView,


    --table
    --worldTable,
    --juntuanTable,
}

local this = chatWindow_view


function chatWindow_view:InitView(root)
    this.panel = root.transform.gameObject

    this.btn_chatBack = this.panel.transform:FindChild("Window/botton_bg/btn_chatBack").gameObject
    this.btn_send = this.panel.transform:FindChild("Window/botton_bg/btn_send").gameObject
    this.btn_shijie = this.panel.transform:FindChild("Window/left_bg/btn_shijie").gameObject
    this.btn_juntuan = this.panel.transform:FindChild("Window/left_bg/btn_juntuan").gameObject

    this.btn_btn_shijie_sprite = this.panel.transform:FindChild("Window/left_bg/btn_shijie/Sprite").gameObject
    this.btn_juntuan_sprite = this.panel.transform:FindChild("Window/left_bg/btn_juntuan/Sprite").gameObject

    this.input_label = this.panel.transform:FindChild("Window/botton_bg/input/Label"):GetComponent("UILabel")
    this.input_com = this.panel.transform:FindChild("Window/botton_bg/input"):GetComponent("UIInput")

    --this.item_perfab.otherChatItem = this.panel.transform:FindChild("Window/otherChatItem").gameObject
    --this.item_perfab.selfChatItem = this.panel.transform:FindChild("Window/selfChatItem").gameObject
    --this.item_perfab.timeItem = this.panel.transform:FindChild("Window/timeItem").gameObject
    this.chatItemPerfab = this.panel.transform:FindChild("Window/ChatItem").gameObject

    --this.worldTable = this.panel.transform:FindChild("Window/Window_bg/scrollView/worldTable").gameObject
    --this.juntuanTable = this.panel.transform:FindChild("Window/Window_bg/scrollView/juntuanTable").gameObject

    this.worldscrollView = this.panel.transform:FindChild("Window/Window_bg/worldscrollView"):GetComponent("UIScrollView")
    this.juntuanscrollView = this.panel.transform:FindChild("Window/Window_bg/juntuanscrollView"):GetComponent("UIScrollView")
    --this.scrollView.

    this.chatItemPerfab:AddComponent(typeof(chatItem))
    this.worldscrollView.gameObject:AddComponent(typeof(LoopItemScrollView))
    this.juntuanscrollView.gameObject:AddComponent(typeof(LoopItemScrollView))

end

--左边栏目先显示世界按钮的图片
function chatWindow_view:ShowOneBtnSprite(type)

    this.btn_btn_shijie_sprite:SetActive(false)
    this.btn_juntuan_sprite:SetActive(false)

    this.worldscrollView.gameObject:SetActive(false)
    this.juntuanscrollView.gameObject:SetActive(false)

    if type == 0 then--世界
        this.btn_btn_shijie_sprite:SetActive(true)
        this.worldscrollView.gameObject:SetActive(true)
    else if type ==1 then--军团
        this.btn_juntuan_sprite:SetActive(true)
        this.juntuanscrollView.gameObject:SetActive(true)
    end
    end
end

return chatWindow_view