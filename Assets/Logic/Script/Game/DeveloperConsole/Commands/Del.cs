using DeveloperConsole.CommandFramework;

namespace DeveloperConsole.Commands
{
    [Command("del", "从服务器数据中删除一件装备/一个物品\n Usage:del <type> <id>\n", CommandType.Server)]
    class Del : CommandBase
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
            if (arguments.Length != 0 && arguments.Length < 2)
            {
                ConsoleLog.Println("参数不匹配");
            }
            string type = null;
            int id = -1;

            for (int i = 0; i < arguments.Length; i++)
            {
                switch (i + 1)
                {
                    case 1:
                        type = arguments[i];
                        break;
                    case 2:
                        int.TryParse(arguments[i], out id);
                        break;
                }
            }
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_DEL + type;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""uuid"":" + id +
                         @"}";
            ConsoleLog.Println(ServerUtil.Post(url,postData));
            ConsoleLog.Println();
        }

    }
}
