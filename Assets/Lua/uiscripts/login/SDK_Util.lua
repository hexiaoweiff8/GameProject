SDK_Util = {}

function SDK_Util.new()

    local util = {}

    local json = require 'uiscripts/login/ThirdParty/json'
    local http = require "socket.http"
    local ltn12 = require "ltn12"

    local protocol = 'http://'
    local ip = '106.75.36.113'
    local port = 6666
    local command = 'process'

--@Des 使用POST方式请求指定链接
--@Params url 链接
--        body 请求内容
--@return HttpStatusCode,ResponseData
    function POST(url,body)
        local reqbody = body
        local respbody = {} 
        local body, code, headers, status = http.request {
            method = "POST",
            url = url,
            source = ltn12.source.string(reqbody),
            headers = 
                    {
                            ["Content-Type"] = "text/plain",
                            ["content-length"] = (reqbody == nil and 0 or #reqbody)
                    },
            sink = ltn12.sink.table(respbody)
        }
        return code,respbody
    end
--@return retCode 错误码说明
    function util.send_quickGame_reg(username,password,mac)
        local quickGame_header = '1-'
        return send_USERNAME_REGISTER(quickGame_header..username,password,mac)
    end
--@return retCode 错误码说明
    function util.send_reg_phoneUser(username,password,mac)
        local phoneUser_header = '2-'
        return send_USERNAME_REGISTER(phoneUser_header..username,password,mac)
    end
--@Des 用户名注册
--@Params username 注册用户名
--        password 密码
--        mac 硬件标识符
--@return retCode 结果
    function util.send_USERNAME_REGISTER(username,password,mac)
        local msgid = 'username_register'

        local username_register = {
            username = username,
            password = password,
            ext_info = {
                MAC = mac
            },
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(username_register)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local retCode = json.decode(data[1]).retCode
                print("---------------USERNAME_REGISTER--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 用户登录获取密令
--@Params username 用户名
--        password 密码
--@return retCode 结果
--        token 令牌
--        userinfo 用户绑定信息
    function util.send_GET_TOKEN(username,password)
        local msgid = 'get_token'

        local get_token = {
            username = username,
            password = password,
            ext_info = {
                MAC = mac
            },
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(get_token)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                local token = jsonData.resp.token
                local userinfo = jsonData.resp.userinfo
                print("---------------GET_TOKEN--------------")
                print("retCode = "..retCode)
                print("token = "..(token == nil and "nil" or token))
                print("userinfo = "..type(userinfo))
                print("---------------end--------------")
                return retCode,token,userinfo
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 绑定手机或手机注册请求短信验证码
--@Params phone 手机号码
--@return retCode 结果
    function util.send_GET_BIND_PHONE_CODE(phone)
        local msgid = 'get_bind_phone_code'

        local get_bind_phone_code = {
            phone = phone
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(get_bind_phone_code)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------GET_BIND_PHONE_CODE--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 完成手机注册或原游客帐号完成绑定
--@Params oldname 原用户名
--        phone 手机号
--        code 短信验证码
--        oldpassword 原密码
--@return retCode 结果
    function util.send_PHONE_REGISTER(phone,code,password,oldname,mac)
        local msgid = 'phone_register'

        local phone_register = {
            phone = phone,
            code = code,
            password = password,
            oldname = oldname,
            ext_info = {
                MAC = mac
            }
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(phone_register)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------PHONE_REGISTER--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 原普通用户名账号完成手机绑定
--@Params oldname 原用户名
--        phone 手机号
--        code 短信验证码
--        oldpassword 原密码
--@return retCode 结果
    function util.send_PHONE_BIND(oldname,phone,code,oldpassword)
        local msgid = 'phone_bind'

        local phone_bind = {
            oldname = oldname,
            phone = phone,
            code = code,
            oldpassword = oldpassword
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(phone_bind)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------PHONE_BIND--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 游客完成用户名绑定
--@Params oldname 原用户名
--        newname 新用户名
--        oldpassword 旧密码
--        newpassword 新密码
--@return retCode 结果
    function util.send_USERNAME_BIND(oldname,newname,oldpassword,newpassword)
        local msgid = 'username_bind'

        local username_bind = {
            oldname = oldname,
            newname = newname,
            oldpassword = oldpassword,
            newpassword = newpassword
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(username_bind)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------USERNAME_BIND--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 绑定邮箱
--@Params username 用户名
--        email 邮箱地址
--@return retCode 结果
    function util.send_MAILBOX_BIND(username,email)
        local msgid = 'mailbox_bind'

        local mailbox_bind = {
            username = username,
            mailbox = email,
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(mailbox_bind)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------MAILBOX_BIND--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 用户修改密码
--@Params username 用户名
--        oldpassword 旧密码
--        newpassword 新密码
    function util.send_MODIFY_PASSWORD(username,oldpassword,newpassword)
        local msgid = 'modify_password'

        local modify_password = {
            username = username,
            oldpassword = oldpassword,
            newpassword = newpassword
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(modify_password)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------MODIFY_PASSWORD--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 邮箱找回密码
--@Params username 原用户名
--@return retCode 结果
--        mail 邮箱
    function util.send_REKEY_VERIFY_LINK(username)
        local msgid = 'rekey_verify_link'

        local rekey_verify_link = {
            username = username,
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(rekey_verify_link)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                local mail = jsonData.resp.mail
                print("---------------REKEY_VERIFY_LINK--------------")
                print("retCode = "..retCode)
                print("mail = "..mail)
                print("---------------end--------------")
                return retCode,mail
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 手机找回密码请求短信验证码
--@Params username 原用户名
--@return retCode 结果
--        phone 手机号
    function util.send_REKEY_PHONE_CODE(username)
        local msgid = 'rekey_phone_code'

        local rekey_phone_code = {
            username = username,
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(rekey_phone_code)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                local phone = jsonData.resp.phone
                print("---------------REKEY_PHONE_CODE--------------")
                print("retCode = "..retCode)
                print("phone = "..(phone == nil and 'nil' or phone))
                print("---------------end--------------")
                return retCode,phone
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 手机找回密码
--@Params username 原用户名
--        code 短信验证码
--@return retCode 结果
--        key 原密码
    function util.send_REKEY_BY_PHONE(username,code)
        local msgid = 'rekey_by_phone'

        local rekey_by_phone  = {
            username = username,
            code = code,
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(rekey_by_phone)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                local key = jsonData.resp.key
                print("---------------REKEY_BY_PHONE--------------")
                print("retCode = "..retCode)
                print("key = "..(key == nil and 'nil' or key))
                print("---------------end--------------")
                return retCode,key
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
--@Des 实名认证
--@Params username 用户名
--        password 密码
--        xm 真实姓名
--        sfz 身份证号
--@return retCode 结果
    function util.send_IDEN_VERIFY(username,password,xm,sfz)
        local msgid = 'iden_verify'

        local iden_verify  = {
            username = username,
            password = password,
            xm = xm,
            sfz = sfz,
        }

        local url = protocol..ip..':'..port..'/'..command..'?'
                    ..'msgid='..msgid..'&data='..json.encode(iden_verify)

        local statusCode,data = POST(url)
        if statusCode == 200 then
            if data then
                local jsonData = json.decode(data[1])
                local retCode = jsonData.retCode
                print("---------------IDEN_VERIFY--------------")
                print("retCode = "..retCode)
                print("---------------end--------------")
                return retCode,key
            else
                print("返回内容为空")
            end
        else
            print("请求错误,状态码:"..statusCode)
        end
    end
----------------------------------------------------------------
--★验证部分

--@Des 验证用户名文本有效性
--@Params username 用户名文本
--@Return 有效则返回true
    function util.check_username(username)
        -- A.   账号不允许使用 @qksf.net 结尾，提示文字: 账号已存在
        local function check_tail(str)
            local s,e = string.find(str,'@qksf.net')
            -- print('len:',#str)
            -- print(s,' ',e)
            if s == nil or e == nil then
                return true
            elseif e ~= #str then
                return true
            else
                return false
            end
        end

        if username ~= nil and type(username) == 'string' and #username ~= 0 then
            return check_tail(username)
        end
        return false
    end
--@Des 验证密码文本有效性
--@Params password 密码文本
--@Return 有效则返回true
    function util.check_password(password)
        -- 密码位数限制：不低于6位，不超过18位
        if password ~= nil and type(password) == 'string' and #password >= 6 and #password <= 18 then
            return true
        end
        return false
    end
--@Des 验证手机号文本有效性
--@Params phoneNumber 手机号(string/long)
--@Return 有效则返回true
    function util.check_phoneNumber(phoneNumber)
        local phone = tonumber(phoneNumber)
        --数字有效性
        if not phone then
            return false
        end
        --位数有效性
        if #tostring(phone) ~= 11 then
            return false
        end
        --号段有效性
        local Interval = {
            "133","149","153","173","177","180","181","189",--电信号段
            "130","131","132","145","155","156","171","175","176","185","186",--联通号段
            "134","135","136","137","138","139","147","150","151","152","157","158","159","178","182","183","184","187","188",--移动号段
            "170",--虚拟运营商
        }
        local head = string.sub(tostring(phone),0,3)

        for _,v in ipairs(Interval) do
            if v == head then
                return true
            end
        end
        return false
    end
--@Des 验证邮箱文本有效性
--@Params email 邮箱地址文本
--@Return 有效则返回true
    function util.check_mail(email)
        if email ~= nil and type(email) == 'string' and #email ~= 0 then
            return email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") == email
        end
        return false
    end
--@Des 验证身份证文本有效性
--@Params sfc 身份证文本
--@Return 有效则返回true
    function util.check_sfz(sfz)
        -- 身份证位数限制：18位,字符串
        if sfz ~= nil and type(sfz) == 'string' and #sfz == 18 then
            return true
        end
        return false
    end

    function util.CreateLoopTimer(sec,OnTickFunc,OnKillFunc)
        local timer = Util.Timer.New(sec, true)
        return timer:OnCompleteCallback(OnTickFunc):OnKill(OnKillFunc):Start()
    end

    return util
end