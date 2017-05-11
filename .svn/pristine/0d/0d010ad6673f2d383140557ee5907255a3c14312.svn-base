--region *.lua
--Date 20150806
--游戏中的Cookie管理

GameCookies = {}

function GameCookies.GetZone()
    return Cookies.GetInt("login_zone")
end

function GameCookies.SetZone(zone)
    Cookies.SetInt("login_zone",zone)
end

--- <summary>
--- 保存登陆用户信息
--- </summary>
function GameCookies.SaveLoginInfo(uid,pass,plyName)
    Cookies.SetString("login_uid",uid)
    Cookies.SetString("login_pass",pass)
    Cookies.SetString("login_plyname",plyName)
    GameCookies.Save()
end
 
 
 
--- <summary>
--- 获取登陆用户信息
--- ret uid,pass,plyName
--- </summary>
function GameCookies.GetLoginInfo()
    local uid = Cookies.GetString("login_uid")
    local pass = Cookies.GetString("login_pass")
    local ply = Cookies.GetString("login_plyname") 
    return uid,pass,ply
end

function GameCookies.Save()
    Cookies.Save()
end
--endregion
