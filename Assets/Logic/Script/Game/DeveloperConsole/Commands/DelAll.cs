using System;
using DeveloperConsole.CommandFramework;

namespace DeveloperConsole.Commands
{
    [Command("delall", "删除玩家身上所有指定类型的物品\nUsage:delall <type>\n", CommandType.Server)]
    class DelAll : CommandBase
    {
        public override string commandName
        {
            get
            {
                return (this.GetType().GetCustomAttributes(typeof(CommandAttribute), true)[0] as CommandAttribute).CommandName;
            }
            set { return; }
        }

        public override string commandNotes
        {
            get
            {
                return (this.GetType().GetCustomAttributes(typeof(CommandAttribute), true)[0] as CommandAttribute).Notes;
            }
            set { return; }
        }

        public override void Execute(string[] arguments)
        {
            if (arguments.Length == 0)
            {
                ConsoleLog.Println(commandNotes);
                return;
            }
            var type = arguments[0];

            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_DEL + type + "_bag";
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={}";
            ConsoleLog.Println(ServerUtil.Post(url,postData));
        }
    }
}
