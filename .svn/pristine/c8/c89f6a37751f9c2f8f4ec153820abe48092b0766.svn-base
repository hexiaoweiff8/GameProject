using System;
using System.Collections.Generic;
using UnityEngine;

public class UserDatas
{
    //本地账户信息存储 
    static public void SetUserData(string key, string v)
    {
        CPlayerPrefs.Single.SetUserDate(key, v);
    }

    //获取本地存储的角色信息
    static public string GetUserData(string key)
    {
        return CPlayerPrefs.Single.GetUserDate(key);
    }
}
