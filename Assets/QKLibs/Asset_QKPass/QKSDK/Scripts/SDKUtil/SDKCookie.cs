using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace QKSDK
{
    partial class SDKCookieKey
    {
        
    }
    static class SDKCookie
    {
        public static void SetValue(string key,string v)
        {
            PlayerPrefs.SetString(NewKey(key), v);
        }

        public static bool ContainKey(string key)
        {
            return PlayerPrefs.HasKey(NewKey(key));
        }

        public static string GetValue(string key)
        {
            return PlayerPrefs.GetString(NewKey(key));
        }

        static string NewKey(string key)
        {
            return string.Format("QKSDK_Cache_{0}", key);
        }
    }
}
