local class = require("common/middleclass")
mail_controller = class("mail_controller",wnd_base)

local this = mail_controller

local view = require("uiscripts/mail/mail_view")
local model = require("uiscripts/mail/mail_model")
local mailCall = require("uiscripts/mail/mailCall")--C#调用LUA方法的接口。直接写入controller会报错

local mail_panel


function mail_controller:OnShowDone()
    --print("mail_controller:OnShowDone")

    view:InitView(self)
    model:InitMode()
    this:InitBtn()


    mail_panel = self
    --this.PutDataToLoop()
end

function mail_controller:InitBtn()

    UIEventListener.Get(view.btn_shanchuyidu).onClick = function ()
        view:ShowRightWindow()
    end

    UIEventListener.Get(view.btn_yijianlingqu).onClick = function ()
        print("一键领取")
        view.loopSV:OneBtnGet()
    end

    UIEventListener.Get(view.btn_close).onClick = function ()
        print("关闭按钮")
        view.loopSV:InitWindow()
        ui_manager:DestroyWB(WNDTYPE.mail)
        --mail_panel:Hide(0)

        --ui_manager:DestroyWB(wnd_base, duration, isPop)

        --mail_panel.gameObject:SetActive(false)
    end
    UIEventListener.Get(view.closeZZ).onClick = function ()
        view.loopSV:InitWindow()
        ui_manager:DestroyWB(WNDTYPE.mail)
    end



    UIEventListener.Get(view.btn_shanchuyidu).onClick = function ()
        view.loopSV:DelYDorYLQ_Mail()
    end

end

--数据往C#端推送
function mail_controller:PutDataToLoop()
    if #model.new_mail_data ~= 0 and view.loopSV ~= nil then

        view.loopSV:InsertDataBack(model.new_mail_data)
        for k ,v in ipairs(model.new_mail_data) do
            table.insert(model.mail_data_list,v)
        end
        model.new_mail_data = {}
    end

end

function mail_controller:Update()
    if #model.new_mail_data ~= 0 then
        mail_controller:PutDataToLoop()
    end
end

function mail_controller:InitRightWindow(mailID)
    print(mailID)
    --遍历整个model表找到mailID的数据然后更新RightWidow的显示
    for k,v in ipairs(model.mail_data_list) do
        if v.id == mailID then
            print("找到对应ID的数据")
            view.right_peopleName_Label.text = v.sender
            view.right_time_Label.text = os.date("%Y/%m/%d",v.time)
            --print(os.date("%Y/%m/%d",v.time))
            view.right_title_Label.text = v.title
            view.right_zhengwen_Label.text = v.content

            --添加附件 1.删除之前的附件 2.遍历这个数据里面的附件动态加载附件
            NGUITools.DestroyChildren(view.right_grid.transform)
            for i=1,#v.rewards do
                --print(v.rewards[i].type)
                --print(v.rewards[i].name)
                --print(v.rewards[i].num)
                --print(v.rewards[i].ex)
                local item = NGUITools.AddChild(view.right_grid.gameObject,view.fujianItem_perfab)
                --GameObject NGUITools.AddChild(GameObject parent,GameObject prefab)
                if v.rewards[i].type == "currency" then--货币Item处理
                    local itemdata =  wnd_shop_model:getShopCurrencyDataRefByField(v.rewards[i].name)
                    --没有图集先暂时用着默认图片
                    --item.transform:FindChild("wupingsp"):GetComponent("UISprite").spriteName = itemdata.Icon
                    item.transform:FindChild("num"):GetComponent("UILabel").text = v.rewards[i].num
                elseif v.rewards[i].type == "item" then--道具Item处理
                elseif v.rewards[i].type == "equip" then--装备Item处理
                elseif v.rewards[i].type == "card" then--卡片Item处理
                end
            end

            --是否显示已领取图标
            if v.new == 2 then
                for i = 0,mail_view.right_grid.transform.childCount - 1 do
                    mail_view.right_grid.transform:GetChild(i):FindChild("yilingquSP").gameObject:SetActive(true)
                end
            end


            view.right_grid:Reposition()
            break;
        end
    end
end

return mail_controller