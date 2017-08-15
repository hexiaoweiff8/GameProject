mail_model = {
    mail_data_list={},--储存邮件信息的地方
    new_mail_data={},-- 暂时存邮件信息地方


    new_mailNum = 0,--新邮件的数量
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

function mail_model:InitMode(HCCallback)
    this.mail_data_list = {}
    this.new_mail_data = {}
    this:UpdateData(HCCallback)
end

function mail_model:UpdateData(HCCallback)
    Message_Manager:SendPB_10019(HCCallback)
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
    --设置新邮件的数量
    local new_num = 0
    for i = 1, #this.new_mail_data do
        if this.new_mail_data[i].new == 0 then
            new_num = new_num + 1
        end
    end
    this.new_mailNum = new_num
end

--设置新邮件的数量
function mail_model:SetNewNum(num)
    mail_model.new_mailNum = num
end
--获取新邮件数量
function mail_model:GetNewNum(HCCallback)
    --先判断邮件数据是否是0如果是两种情况1.没打开过邮件系统所以没新邮件得自己请求，2打开过但是在次请求防止邮件数据更新
    if HCCallback~=nil then
        mail_model:InitMode(HCCallback)
    end
end

return mail_model