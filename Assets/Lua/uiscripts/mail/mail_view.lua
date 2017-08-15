mail_view = {

    btn_shanchuyidu,
    btn_yijianlingqu,
    btn_close,
    closeZZ,--透明关闭遮罩

    leftWindow,
    rightWindow,

    mailItem_perfab,
    fujianItem_perfab,

    left_ScrollView,
    left_ScrollView_node,

    ----Right控件----
    right_peopleName_Label,
    right_time_Label,
    right_title_Label,
    right_zhengwen_Label,
    right_grid,
    btn_lingqufujian,
    ----Right控件----

    ----静态处理的Label----
    left_top_Title_Label,
    left_btn_shanchuyidu_Label,
    left_btn_yijianlingqu_Label,
    right_btn_lingqufujian_Label,
    right_sendPeople_Label,
    right_window_ScrollView_content_fujianlabel_Label,
    mailItem_sendPeopleLabel_Label,
    ----静态处理的Label----

    loopSV, -- 循环加载类的对象
}
local this = mail_view

function mail_view:InitView(root)
    this.btn_shanchuyidu = root.transform:FindChild("left/btn_shanchuyidu").gameObject
    this.btn_yijianlingqu = root.transform:FindChild("left/btn_yijianlingqu").gameObject
    this.btn_close = root.transform:FindChild("left/top/btn_close").gameObject
    this.closeZZ = root.transform:FindChild("closeZZ").gameObject

    this.leftWindow = root.transform:FindChild("left").gameObject
    this.rightWindow = root.transform:FindChild("right").gameObject

    this.mailItem_perfab = root.transform:FindChild("mailItem").gameObject
    this.fujianItem_perfab = root.transform:FindChild("fujianItem").gameObject

    this.left_ScrollView = root.transform:FindChild("left/window/Scroll View").gameObject
    this.left_ScrollView_node = root.transform:FindChild("left/window/Scroll View/parent").gameObject


    ----Right控件----
    this.right_peopleName_Label = root.transform:FindChild("right/sendPeople/peopleName"):GetComponent("UILabel")
    this.right_time_Label = root.transform:FindChild("right/timeLabel"):GetComponent("UILabel")
    this.right_title_Label = root.transform:FindChild("right/window/Scroll View/content/title"):GetComponent("UILabel")
    this.right_zhengwen_Label = root.transform:FindChild("right/window/Scroll View/content/zhengwen"):GetComponent("UILabel")
    this.right_grid = root.transform:FindChild("right/window/Scroll View/content/Grid"):GetComponent("UIGrid")
    this.btn_lingqufujian = root.transform:FindChild("right/btn_lingqufujian").gameObject
    ----Right控件----

    ----静态处理的Label----
    this.left_top_Title_Label = root.transform:FindChild("left/top/Title"):GetComponent("UILabel")
    this.left_btn_shanchuyidu_Label = root.transform:FindChild("left/btn_shanchuyidu/Label"):GetComponent("UILabel")
    this.left_btn_yijianlingqu_Label = root.transform:FindChild("left/btn_yijianlingqu/Label"):GetComponent("UILabel")
    this.right_btn_lingqufujian_Label = root.transform:FindChild("right/btn_lingqufujian/Label"):GetComponent("UILabel")
    this.right_sendPeople_Label = root.transform:FindChild("right/sendPeople"):GetComponent("UILabel")
    this.right_window_ScrollView_content_fujianlabel_Label = root.transform:FindChild("right/window/Scroll View/content/fujianlabel"):GetComponent("UILabel")
    this.mailItem_sendPeopleLabel_Label = root.transform:FindChild("mailItem/sendPeopleLabel"):GetComponent("UILabel")
    this:InitStatic_String()
    ----静态处理的Label----


    this.mailItem_perfab:AddComponent(typeof(MailItem))
    this.left_ScrollView:AddComponent(typeof(MailLoopGrid))

    this.loopSV = this.left_ScrollView:GetComponent("MailLoopGrid")
    this.rightWindow:SetActive(false)
end

function mail_view:InitStatic_String()
    this.left_top_Title_Label.text = stringUtil:getString(30501)
    this.left_btn_shanchuyidu_Label.text = stringUtil:getString(30503)
    this.left_btn_yijianlingqu_Label.text = stringUtil:getString(30504)
    this.right_btn_lingqufujian_Label.text = stringUtil:getString(30505)
    this.right_sendPeople_Label.text = stringUtil:getString(30502)
    this.right_window_ScrollView_content_fujianlabel_Label.text = stringUtil:getString(30506)
    this.mailItem_sendPeopleLabel_Label.text = stringUtil:getString(30502)
end

function mail_view:ShowRightWindow()
    this.rightWindow.gameObject:SetActive(true)
   
    local leftWidth = this.leftWindow:GetComponent("UIWidget").width
    local rightWidth = this.rightWindow:GetComponent("UIWidget").width
    TweenPosition.Begin(this.leftWindow,0.1,Vector3(-leftWidth/2 ,0,0),false)
    TweenPosition.Begin(this.rightWindow,0.1,Vector3(rightWidth/2 ,0,0),false)
end

function mail_view:HideRightWindow()
    this.rightWindow.gameObject:SetActive(false)
    this.rightWindow.gameObject.transform.localPosition = Vector3(100,0,0)
    TweenPosition.Begin(this.leftWindow,0.1,Vector3(0,0,0),false)
    --TweenPosition.Begin(this.rightWindow,0.1,Vector3(255.5,0.5,0,0),false)
end

function mail_view:CloseWindow()
    this.rightWindow.gameObject:SetActive(false)
    this.rightWindow.gameObject.transform.localPosition = Vector3(100,0,0)
    this.leftWindow.gameObject.transform.localPosition = Vector3(0,0,0)

end

return mail_view