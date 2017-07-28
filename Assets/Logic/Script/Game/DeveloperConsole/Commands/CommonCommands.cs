using System;
using UnityEditor;

namespace DeveloperConsole.CommandFramework
{
    [CommandEntry("System")]
    class CommonCommands
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

        [CommandEntryMethod("rid", "获取用户roleid")]
        public static string GetUserID()
        {
            return Convert.ToInt32(Tools.CallMethod("userModel", "getRID")[0]).ToString();
        }

    }
}
