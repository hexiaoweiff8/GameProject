using System;
using System.Net;
using System.Text;
using DeveloperConsole.CommandFramework;

namespace DeveloperConsole.Commands
{
    [Command("add","添加道具/装备(add <type> <id> <num> [可选]<ex> \n 添加货币可以使用(add <moneyType> <num>)快速添加)\n",CommandType.Server)]
    class Add : CommandBase
    {
        public override string commandName
        {
            get
            {
                return (this.GetType().GetCustomAttributes(typeof (CommandAttribute), true)[0] as CommandAttribute).CommandName;
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
            if (arguments.Length == 0)//0个参数时显示提示
            {
                ConsoleLog.Println(commandNotes);
                return;
            }
            if (arguments.Length != 0&&arguments.Length < 2)
            {
                ConsoleLog.Println("参数不匹配");
            }
            if (arguments.Length == 2)
            {
                //使用简化的添加货币指令
                Send(arguments[0],int.Parse(arguments[1]));
                return;
            }

            string  type = null;
            string  moneyType = null;
            int     id = -1;
            int     num = -1;
            int     ex = -1;

            for (int i = 0; i < arguments.Length; i++)
            {
                switch (i + 1)
                {
                    case 1:
                        type = arguments[i];
                        break;
                    case 2:
                        if (!int.TryParse(arguments[i], out id))
                            moneyType = arguments[i];
                        break;
                    case 3:
                        num = int.Parse(arguments[i]);
                        break;
                    case 4:
                        ex = int.Parse(arguments[i]);
                        break;
                }
            }
            if (string.IsNullOrEmpty(moneyType))
            {
                if(ex != -1)
                    Send(type, id, num ,ex);
                else Send(type, id, num);
            }
            else Send(type, moneyType, num);
        }

        private void Send(string type, int id, int num)
        {
            //string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD + '?' +
            //             "roleid=" + getUserRID() +
            //             "&data={'rewardList':[{" + 
            //             "'type':'" + type + "'," + 
            //             "'name':" + id + "," +
            //             "'num':" + num +
            //             "}]}";
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""rewardList"":[{" +
                         @"""type"":""" + type + @"""," +
                         @"""name"":" + id + @"," +
                         @"""num"":" + num +
                         @"}]}";
            //ConsoleLog.Println("角色id:"+ getUserRID() + "添加"+num+"件"+type+"(id:"+id+")");
            //ConsoleLog.Println();
            ConsoleLog.Println(ServerUtil.Post(url,postData));
            ConsoleLog.Println();
        }

        private void Send(string type, string moneyType, int num)
        {
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""rewardList"":[{" +
                         @"""type"":""" + type + @"""," +
                         @"""name"":""" + moneyType + @"""," +
                         @"""num"":" + num +
                         @"}]}";
            //ConsoleLog.Println("角色id:" + getUserRID() + " " + moneyType + "+" + num);
            //ConsoleLog.Println();
            ConsoleLog.Println(ServerUtil.Post(url, postData));
            ConsoleLog.Println();
        }

        private void Send(string moneyType, int num)
        {
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""rewardList"":[{" +
                         @"""type"":""" + "currency" + @"""," +
                         @"""name"":""" + moneyType + @"""," +
                         @"""num"":" + num +
                         @"}]}";
            //ConsoleLog.Println("角色id:" + getUserRID() + " " + moneyType + "+" + num);
            //ConsoleLog.Println();
            ConsoleLog.Println(ServerUtil.Post(url, postData));
            ConsoleLog.Println();
        }

        private void Send(string type, int id, int num, int ex)
        {
            string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
            string postData = @"roleid=" + UserUtil.getUserRID() +
                         @"&data={""rewardList"":[{" +
                         @"""type"":""" + type + @"""," +
                         @"""name"":" + id + @"," +
                         @"""num"":" + num +
                         (ex == -1 ? "" : (@",""ex"":" + ex)) +
                         @"}]}";
            //ConsoleLog.Println("角色id:" + getUserRID() + "添加" + num + "件" + (ex == -1 ? "" : ("品质=" + ex + "的")) + type + "(id:" + id + ")" );
            //ConsoleLog.Println();
            ConsoleLog.Println(ServerUtil.Post(url, postData));
            ConsoleLog.Println();
        }
    }
}
