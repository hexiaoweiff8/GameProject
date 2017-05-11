using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class CPlayerPrefs
{
    private static CPlayerPrefs single = null;
    public static CPlayerPrefs Single
    {
        get
        {
            if (single == null)
            {
                single = new CPlayerPrefs();
            }
            return single;
        }
    }
    private CPlayerPrefs()
    {
        Load();
    }


    /// <summary>
    /// 登录成功保存用户信息 uid 
    /// </summary>
    public void UpdateAllUserDate(string userid)
    {
        //如果是已经登录的角色则返回
        if (uid == userid)
            return;
        //判断该账户信息是否存在
        if (mData.ContainsKey(userid))
        {
            //存在则将该账户信息存储到本地
            Dictionary<string, string> tempUinfo = new Dictionary<string, string>();
            mData.TryGetValue(userid, out tempUinfo);
            userInfo.Clear();
            foreach (KeyValuePair<string, string> item in tempUinfo)
            {
                userInfo.Add(item.Key, item.Value);
            }
        }
        else
        {
            //没有则将登录成功的账户信息存储为新的
            if (null != userLoginList)
            {
                if (userLoginList.Count > 1)
                {
                    //本地保存账户信息
                    //##########################应该在新建userInfo时尽量初始化所有需要的key默认“”#############################
                    userInfo.Clear();
                    userInfo.Add("username", userLoginList[0]);
                    userInfo.Add("password", userLoginList[1]);
                    //userInfo.Add("sound", "1");
                    Dictionary<string, string> tempUinfo = new Dictionary<string, string>();
                    foreach (KeyValuePair<string, string> item in userInfo)
                    {
                        tempUinfo.Add(item.Key, item.Value);
                    }
                    mData.Add(userid, tempUinfo);
                }
            }
        }
        uid = userid;
        Save();
    }

    /// <summary>
    /// 获取本地存储的角色信息 
    /// key包含（username）（password）(sound) +++
    /// </summary>
    public string GetUserDate(string key)
    {
        if (userInfo == null)
            return null;
        if (userInfo.ContainsKey(key))
        {
            string getinfo;
            userInfo.TryGetValue(key, out getinfo);
            if (getinfo.Length < 20)
                return getinfo;
        }
        return null;
    }

    /// <summary>
    /// 本地信息存储 
    /// key包含（username）（password）(sound) +++
    /// </summary>
    public void SetUserDate(string key, string value)
    {
        if (userInfo == null)
            return;
        if (userInfo.ContainsKey(key) && value.Length < 20)
        {
            //如果已经存在则改变值
            userInfo[key] = value;
        }
        else
        {
            //##########################不存在此key则#######################
            userInfo.Add(key, value);
        }
        Dictionary<string, string> tempUinfo = new Dictionary<string, string>();
        foreach (KeyValuePair<string, string> item in userInfo)
        {
            tempUinfo.Add(item.Key, item.Value);
        }
        mData[uid] = tempUinfo;
        Save();
    }


    /// <summary>
    /// 将登录的用户密码信息存储在本地
    /// </summary>
    public void SetUserLoginList(string userText, string passText)
    {
        if (userText.Length > 15 || passText.Length > 15) return;

        string uInfo = PlayerPrefs.GetString(LoginedUserAddress, "");
        string user01 = userText + "\t" + passText;
        if (uInfo == "")
            PlayerPrefs.SetString(LoginedUserAddress, user01);

        //使用StringBuilder操作字符串连续相加的问题  现存储上最新登录成功的账号
        StringBuilder userDatesbuilder = new StringBuilder(user01);
        string[] users = uInfo.Split('\n');
        if (users == null)
        {
            PlayerPrefs.SetString(LoginedUserAddress, userDatesbuilder.ToString());
            GetUserLoginList();
            return;
        }
        for (int i = 0; i <= users.Length - 1; i++)
        {
            string[] player = users[i].Split('\t');
            //已存储的账户信息跳过
            if (player[0] != userText)
            {
                userDatesbuilder.Append('\n');
                userDatesbuilder.Append(users[i]);
            }
        }
        PlayerPrefs.SetString(LoginedUserAddress, userDatesbuilder.ToString());
        GetUserLoginList();
    }

    /// <summary>
    /// 获取本地存储的用户密码信息表
    /// </summary>
    public List<string> GetUserLoginList()
    {
        string uInfo = PlayerPrefs.GetString(LoginedUserAddress, "");
        if (uInfo == "")
            return null;

        userLoginList.Clear();
        //将信息读取存入userLoginList
        string[] users = uInfo.Split('\n');
        for (int i = 0; i <= users.Length - 1; i++)
        {
            string[] player = users[i].Split('\t');
            for (int j = 0; j <= player.Length - 1; j++)
            {
                if (player[j].Length < 25)
                    userLoginList.Add(player[j]);
            }
        }
        return userLoginList;
    }

    /// <summary>
    /// 删除本地存储的账户详细数据信息
    /// </summary>
    public void DeleteUsersInfo()
    {
        PlayerPrefs.DeleteKey(AllUserAddress);
    }

    /// <summary>
    /// 删除本地存储的一切账户信息与账户登录信息
    /// </summary>
    public void DeleteAllUsers()
    {
        PlayerPrefs.DeleteKey(AllUserAddress);
        PlayerPrefs.DeleteKey(LoginedUserAddress);
    }

    //读取全部本地账户信息
    void Load()
    {
        // 
        string dataStr = PlayerPrefs.GetString(AllUserAddress, "");
        if (String.IsNullOrEmpty(dataStr)) return;

        QK_JsonValue_Map tData = new QK_JsonValue_Map();

        if (!tData.Parse(dataStr)) return;

        mData.Clear();
        foreach (KeyValuePair<string, QK_JsonValue> kuser in tData)
        {
            QK_JsonValue_Map uData = kuser.Value as QK_JsonValue_Map;

            string uid = kuser.Key;
            Dictionary<string, string> userIn = new Dictionary<string, string>();
            foreach (KeyValuePair<string, QK_JsonValue> uda in uData)
            {
                string uvalue = uda.Value as QK_JsonValue_Str;
                //反转译字符串  防止多次转译
                uvalue = System.Text.RegularExpressions.Regex.Unescape(uvalue);
                userIn.Add(uda.Key, uvalue);
            }
            mData.Add(kuser.Key, userIn);
        }
    }

    //保存信息
    void Save()
    {
        QK_JsonValue_Map tData = new QK_JsonValue_Map();

        foreach (KeyValuePair<string, Dictionary<string, string>> userKeyValue in mData)
        {
            QK_JsonValue_Map tUser = new QK_JsonValue_Map();

            foreach (KeyValuePair<string, string> kv in userKeyValue.Value)
            {

                tUser.addStrValue(kv.Key, kv.Value);
            }

            tData.addValue(userKeyValue.Key, tUser);
        }

        String usersDate = tData.ToString();
        PlayerPrefs.SetString(AllUserAddress, usersDate);
    }


    //所有账户信息表地址
    string AllUserAddress = "UsersData";
    //所有账户登录表地址
    string LoginedUserAddress = "LoginedUser";
    //登录过的账号列表
    List<string> userLoginList = new List<string>();
    // 用户UID :Dictionary<Key,Value>用户的本地信息存储
    Dictionary<string, Dictionary<string, string>> mData = new Dictionary<string, Dictionary<string, string>>();
    // 当前账户的信息 
    Dictionary<string, string> userInfo = new Dictionary<string, string>();
    // 用户的唯一标号
    string uid = "";
}
