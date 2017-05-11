using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using QKSDKUtils;

namespace QKSDK
{
    static class SDKConfig
    {
        /// <summary>
        /// 用户中心地址
        /// </summary>
        public const string UserCenterDomain = "qksdkusercenter.qikuai.com.cn";


        /// <summary>
        /// 应用Key
        /// </summary>
        public static string AppKey = string.Empty;
        /// <summary>
        /// 应用安全标识
        /// </summary>
        public static string AppSecret = string.Empty;

        /// <summary>
        /// 用户的账号缓存
        /// </summary>
        public static Dictionary<string, string> AccountCache = new Dictionary<string, string>();

        /// <summary>
        /// 初始化配置信息
        /// </summary>
        public static void AutoInit(ISDKListener listener)
        {
            AppKey = listener.AppKey;
            AppSecret = listener.AppSecret;
            LoadAccountCache();
        }

        /// <summary>
        /// 缓存一个账号
        /// </summary>
        public static void CacheAccount(string account,string pass)
        {
            AccountCache[account] = pass;
            SaveAccountCache();
        }

        /// <summary>
        /// 清空一个账号缓存
        /// </summary>
        public static void ClearAccountCache(string account)
        {
            if(AccountCache.ContainsKey(account))
            {
                AccountCache.Remove(account);
                SaveAccountCache();
            }
        }

        /// <summary>
        /// 清空账号缓存
        /// </summary>
        public static void ClearAccountCache()
        {
            AccountCache.Clear();
            SaveAccountCache();
        }

        /// <summary>
        /// 保存缓存的账号列表
        /// </summary>
        static void SaveAccountCache()
        {
            SDKCookie.SetValue("SDKAccountList", AccountCache.TryToString());
        }

        /// <summary>
        /// 加载账号缓存
        /// </summary>
        static void LoadAccountCache()
        {
            if (SDKCookie.ContainKey("SDKAccountList"))
            {
                AccountCache.Clear();
                Dictionary<string, string> temp = SDKCookie.GetValue("SDKAccountList").TryToDictionary();
                if(null != temp)
                {
                    AccountCache = new Dictionary<string, string>(temp);
                }
            }
        }
    }
}
