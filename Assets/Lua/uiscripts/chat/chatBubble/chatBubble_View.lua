
chatBubble_View = {

    --panel
    panel,

    --控件
    MessageGrid_1,
    MessageGrid_2,
    username001,
    username002,
    userMessage001,
    userMessage002,


    --按钮
    btn_Bubble,

    --显示文本1还是文本2  1是1 2是2
    showIndex = 2;


}

local this = chatBubble_View

function chatBubble_View:InitView(root)
    --self = root
    this.panel = root.transform.gameObject
    this.MessageGrid_1 = this.panel.transform:Find("Bubble/windowPanel/MessageGrid_1").gameObject
    this.MessageGrid_2 = this.panel.transform:Find("Bubble/windowPanel/MessageGrid_2").gameObject
    this.username001 = this.MessageGrid_1.transform:FindChild("userName"):GetComponent("UILabel")
    this.username002 = this.MessageGrid_2.transform:FindChild("userName"):GetComponent("UILabel")
    this.userMessage001 = this.MessageGrid_1.transform:FindChild("userMessage"):GetComponent("UILabel")
    this.userMessage002 = this.MessageGrid_2.transform:FindChild("userMessage"):GetComponent("UILabel")

    this.btn_Bubble = this.panel.transform:Find("Bubble/Btn_BubbleImg").gameObject

    --this:set_Sprite_Alpha_zero(this.MessageGrid_2)
    --this:ShowNextMessageGrid()
    --panel.transform.gameObject:SetActive(false)

    this.username001.text = ""
    this.username002.text = ""
    this.userMessage001.text = ""
    this.userMessage002.text = ""

    this.showIndex = 2
end

function chatBubble_View:set_Sprite_Alpha_zero(go)
    --go.transform:GetComponent("UISprite").color = Color(1,1,1,0)

    --test
    --this.ShowNextMessageGrid()
end

function chatBubble_View:ShowNextMessageGrid()
    if this.showIndex == 1 then
        --this.MessageGrid_1.transform:DoLocalMoveY(60,1)
        ChatBubbleAni.NextMessageAni(1,this.MessageGrid_1,this.MessageGrid_2)
        this.showIndex = 2
    else
        ChatBubbleAni.NextMessageAni(2,this.MessageGrid_1,this.MessageGrid_2)
        this.showIndex = 1
    end
end

return chatBubble_View