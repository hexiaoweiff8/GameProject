mail_model = {
    mail_data_list={},--储存邮件信息的地方
    new_mail_data={},-- 暂时存邮件信息地方

}


local this = mail_model

function mail_model:InitMode()
    this.mail_data_list = {}
    this.new_mail_data = {}
    this:UpdateData()
end

function mail_model:UpdateData()
    Message_Manager:SendPB_10019()
end
function mail_model:insertData(datalist)

    for i=1,#datalist do
        --required string _id         =1;
        --required string title       =2;
        --required string sender      =3;
        --required int32 receiver     =4;
        --required string content     =5;
        --repeated Rewardfrm rewards = 6;
        --required int32 time         =7;
        --required string way         =8;
        --required int32 new          =9;
        --required int32 autoDel      =10;
        local tb = {}
        tb.id = datalist[i]._id
        tb.title = datalist[i].title
        tb.sender = datalist[i].sender
        tb.receiver = datalist[i].receiver
        tb.content = datalist[i].content
        tb.rewards = datalist[i].rewards
        tb.time = datalist[i].time
        tb.way = datalist[i].way
        tb.new = datalist[i].new
        tb.autoDel = datalist[i].autoDel
        --print("--id:"..tb.id.."--title:"..tb.title.."--sender:"..tb.sender)
        --print("--receiver:"..tb.receiver.."--content:"..tb.content)
        --print(tb.rewards)
        --print("rewards长度："..#tb.rewards)
        --print(tb.rewards[1].type.."---"..tb.rewards[1].name.."---"..tb.rewards[1].num.."---"..tb.rewards[1].ex)
        --print("--time:"..tb.time.."--way:"..tb.way.."--new:"..tb.new.."--autoDel:"..tb.autoDel)
        --print(i)
        table.insert(this.new_mail_data,tb)
    end



end

return mail_model