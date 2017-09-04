using System;
using UnityEditor;
using UnityEngine;

namespace DeveloperConsole.CommandFramework
{
    [CommandEntry("System")]
    sealed class CommonCommands
    {
        [CommandEntryMethod("cls", "清空屏幕")]
        public static string Clean()
        {
            ConsoleGUI._ins.output.Clear();
            return null;
        }

        [CommandEntryMethod("about","关于信息")]
        public static string About()
        {
            ConsoleLog.Println("=====Developer Console=====");
            ConsoleLog.Println("              Kanbaru");
            ConsoleLog.Println("=====Developer Console=====");
            return null;
        }

        [CommandEntryMethod("help", "获取指令集信息")]
        public static string GetHelp()
        {
            ConsoleLog.Println("All Commands:");
            foreach (var command in CommandsRepository._ins.repository)
            {
                ConsoleLog.Println("   " + command.Key + " " + command.Value.commandNotes);
            }
            return null;
        }

        [CommandEntryMethod("ver", "获取版本号信息")]
        public static string GetVersion()
        {
            ConsoleLog.Println("Developer Console Alpha 0.1");
            return null;
        }

        [CommandEntryMethod("time", "显示当前时间")]
        public static string GetCurrentTime()
        {
            ConsoleLog.Println("当前时间: " + DateTime.Now);
            return null;
        }

        [CommandEntryMethod("exit", "退出play模式,仅在Editor状态下有效")]
        public static string ExitPlayMode()
        {
            EditorApplication.isPlaying = false;
            return null;
        }

        [CommandEntryMethod("pause", "暂停play模式,仅在Editor状态下有效")]
        public static string PauseInPlayMode()
        {
            EditorApplication.isPaused = true;
            return null;
        }

        [CommandEntryMethod("uid", "获取userid")]
        public static string GetUserID()
        {
            return Tools.CallMethod("userModel", "getUID")[0].ToString();          
        }
        [CommandEntryMethod("hid", "获取hostid")]
        public static string GetHostID()
        {
            return Tools.CallMethod("userModel", "getHID")[0].ToString();
        }
        [CommandEntryMethod("rid", "获取roleid")]
        public static string GetRoleID()
        {
            return Tools.CallMethod("userModel", "getRID")[0].ToString();
        }
        [CommandEntryMethod("userinfo", "获取角色详细信息")]
        public static string GetUserInfo()
        {
            return Tools.CallMethod("userModel", "getUserInfo")[0].ToString();
        }
        [CommandEntryMethod("smail", "给当前用户发送不带奖励的邮件")]
        public static string SendMail()
        {
            /* http://106.75.36.113:2002/gm/send_mail?roleid=0&data=
            {"title":"first mail","content":"dafadfaf","sender":"xiaoA","reward": [{"type":"currency","name":"gold","num":100}],"hId":****,"way":"GM"} */
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.SEND_MAIL;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""title"":""控制台邮件"","+
                         @"""content"":""邮件内容100字"","+
                         @"""sender"":""GameConsole""," +
                         @"""reward"":[]," +
                         @"""hId"":101," +
                         @"""way"":""GM""}";
            UnityEngine.Debug.Log(url + postData);
            return ServerUtil.Post(url, postData);
        }

        [CommandEntryMethod("smailr", "给当前用户发送带奖励的邮件(货币/装备/道具)")]
        public static string SendRewardMail()
        {
            string[] rewards = new string[]
            {
                @"{""type"":""currency"",""name"":""gold"",""num"":100}",
                @"{""type"":""equip"",""name"":""300110"",""num"":1,""ex"":4}",
                @"{""type"":""item"",""name"":""470009"",""num"":3}",
            };
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.SEND_MAIL;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""title"":""控制台奖励邮件""," +
                         @"""content"":""邮件内容100字""," +
                         @"""sender"":""GameConsole""," +
                         @"""reward"":["+ rewards[UnityEngine.Random.Range(0,3)] + "]," +
                         @"""hId"":101," +
                         @"""way"":""GM""}";
            UnityEngine.Debug.Log(url + postData);
            return ServerUtil.Post(url, postData);
        }

        [CommandEntryMethod("sync", "重新连接服务器获取数据")]
        public static string RegetData()
        {
            return Tools.CallMethod("ConsoleUtil", "regetData")[0].ToString();
        }

        [CommandEntryMethod("clrlogin", "清除登录缓存")]
        public static string ClearLoginCache()
        {
            UnityEngine.PlayerPrefs.SetString("UserLoginCache","");
            return "UnityEngine.PlayerPrefs.SetString('UserLoginCache','');\nDone.";
        }
    }
}
