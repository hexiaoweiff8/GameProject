--C#调用LUA方法的接口。直接写入controller会报错
--这个LUA文件需要再对应的controller里面require以下否则报不存在

mailCall = {

}
local this = mailCall

--播放邮件打开的动画
function mailCall.ShowRightWindow()
    mail_view:ShowRightWindow()
end
--播放邮件隐藏的动画
function mailCall.HideRightWindow()
    mail_view:HideRightWindow()
end

--通过邮件ID更新右边栏目的信息
function mailCall.InitRightWindow(mailID)
    mail_controller:InitRightWindow(mailID)
end

function mailCall.SendReadMail(mailID,_new)
    --遍历邮件列表更新邮件对应那条的数据
    for k ,v in ipairs(mail_model.mail_data_list) do
        if v.id == mailID then
            v.new = _new;
            --print("更新状态成功")
            break
        end
    end

    --print("请求阅读邮件！"..mailID)
    Message_Manager:SendPB_10025(mailID)
end

function mailCall.SendDelMail(mailID)
    --print("请求删除邮件！"..mailID)
    Message_Manager:SendPB_10026(mailID)
end

--更新领取附件按钮 领取对应的
function mailCall.UpdateRight_Btn_lingqufujian(mailID,isHavefujian,_new,autoDel)

    if isHavefujian then

        if _new == 2 then
            mail_view.btn_lingqufujian:SetActive(false)
        else
            mail_view.btn_lingqufujian:SetActive(true)
        end

        UIEventListener.Get(mail_view.btn_lingqufujian).onClick =
        function ()
            --发送领取信号
            Message_Manager:SendPB_10020(mailID)
            --找到邮件里面这条数据然后变更状态为2传回给C#
            for k, v in ipairs(mail_model.mail_data_list) do
                if v.id == mailID then
                    v.new = 2
                    mail_view.loopSV:UpOneData(mailID,v)
                    break
                end
            end
            --隐藏领取按钮 和 开启每个Grid上面的已领取图标
            mail_view.btn_lingqufujian:SetActive(false)
            for i = 0,mail_view.right_grid.transform.childCount - 1 do
                mail_view.right_grid.transform:GetChild(i):FindChild("yilingquSP").gameObject:SetActive(true)
            end
            --领取完了过后如果是自动删除的邮件需要通知服务器自动删除
            if autoDel == 1 then
                Message_Manager:SendPB_10026(mailID)
            end
        end
    else

        mail_view.btn_lingqufujian:SetActive(false)
    end
end

function mailCall.LingquFujian(mailID,autoDel)
    --发送领取信号
    Message_Manager:SendPB_10020(mailID)
    --找到邮件里面这条数据然后变更状态为2传回给C#
    for k, v in ipairs(mail_model.mail_data_list) do
        if v.id == mailID then
            v.new = 2
            mail_view.loopSV:UpOneData(mailID,v)
            break
        end
    end
    --领取完了过后如果是自动删除的邮件需要通知服务器自动删除
    if autoDel == 1 then
        Message_Manager:SendPB_10026(mailID)
    end
end

--得到新数据前先把原来的数据清空
function mailCall.ClearDataList()
    mail_model.mail_data_list = {}
end
--删除已读邮件后更新数据
function mailCall.UpdaNewDataList(id, title,sender,receiver,content,rewards,time,way,_new,autoDel)
    local tb = {}
    tb.id = id
    tb.title = title
    tb.sender = sender
    tb.receiver = receiver
    tb.content = content
    tb.rewards = rewards
    tb.time = time
    tb.way = way
    tb.new = _new
    tb.autoDel = autoDel
    table.insert(mail_model.mail_data_list, tb)
end

return mailCall