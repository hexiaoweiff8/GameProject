chatWindow_view = {

    panel,
    --按钮
    btn_shijie,
    btn_juntuan,

    btn_send,
    btn_chatBack,

    backzezhao,
    --精灵
    btn_shijie_sprite,
    btn_juntuan_sprite,

    --label
    input_label,
    input_com,



    chatItemPerfab,

    --滑动窗口
    worldscrollView,
    juntuanscrollView,

    ----静态字段----
    btn_shijie_Label,
    btn_juntuan_Label,
    --btn_send_Label,
    ----静态字段----

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
    this.backzezhao = this.panel.transform:FindChild("Window/backzezhao").gameObject

    this.input_label = this.panel.transform:FindChild("Window/botton_bg/input/Label"):GetComponent("UILabel")
    this.input_com = this.panel.transform:FindChild("Window/botton_bg/input"):GetComponent("UIInput")


    this.chatItemPerfab = this.panel.transform:FindChild("Window/ChatItem").gameObject


    this.worldscrollView = this.panel.transform:FindChild("Window/Window_bg/worldscrollView"):GetComponent("UIScrollView")
    this.juntuanscrollView = this.panel.transform:FindChild("Window/Window_bg/juntuanscrollView"):GetComponent("UIScrollView")
    --this.scrollView.

    ----静态字段----
    this.btn_shijie_Label = this.panel.transform:FindChild("Window/left_bg/btn_shijie/Label"):GetComponent("UILabel")
    this.btn_juntuan_Label = this.panel.transform:FindChild("Window/left_bg/btn_juntuan/Label"):GetComponent("UILabel")
    --this.btn_send_Label = this.panel.transform:FindChild("botton_bg/btn_shijie/Label"):GetComponent("UILabel")
    this:InitStatic_String()
    ----静态字段----

    this.chatItemPerfab:AddComponent(typeof(chatItem))
    this.worldscrollView.gameObject:AddComponent(typeof(LoopItemScrollView))
    this.juntuanscrollView.gameObject:AddComponent(typeof(LoopItemScrollView))

end

function chatWindow_view:InitStatic_String()
    this.btn_shijie_Label.text = stringUtil:getString(31101)
    this.btn_juntuan_Label.text = stringUtil:getString(31102)

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