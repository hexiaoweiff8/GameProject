using System;
using System.Collections.Generic;
using System.Linq;
using DeveloperConsole.CommandFramework;

namespace DeveloperConsole.Commands
{
    [Command("bat", "批量添加指定类型装备/物品/卡牌\n" +
                    "Usage:bat equip (可选)(-num <Int32> -suitId <Int32> -eqType <Int32> -ex <Int32>)\n" +
                    "Usage:bat item (可选)(-num <Int32> -count <Int32> -useType <Int32>)\n" +
                    "Usage:bat card (可选)(-num <Int32>)\n", CommandType.Server)]
    class Batch : CommandBase
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
            if (arguments.Length == 0)//0个参数时显示提示
            {
                ConsoleLog.Println(commandNotes);
                return;
            }
            var type = arguments[0];

            List<string> paramsStrings = arguments.Skip(1).ToList();
            Dictionary<string, int> args = new Dictionary<string, int>();

            foreach (var param in paramsStrings)
            {
                if (param.StartsWith("-"))
                {
                    if (paramsStrings.IndexOf(param) + 1 <= paramsStrings.Count - 1)
                    {
                        try
                        {
                            args[param] = int.Parse(paramsStrings[paramsStrings.IndexOf(param) + 1]);
                        }
                        catch (FormatException e)
                        {
                            ConsoleLog.Println("参数不正确");
                            return;
                        }
                    }
                    else
                    {
                        ConsoleLog.Println("参数中有无效值");
                        return;
                    }
                }//end if
            }

            if (type == "equip")
            {
                generateRandomEquip(args);
                return;
            }
            if (type == "item")
            {
                generateRandomItem(args);
                return;
            }
            if (type == "card")
            {
                generateRandomCard(args);
                //ConsoleLog.Println("批量添加卡牌功能施工中...");
            }
            else
            {
                ConsoleLog.Println("参数不正确");
            }
        }

        private void generateRandomEquip(Dictionary<string, int> args)
        {
            int suitid = -1;
            int eqtype = -1;
            int ex = -1;
            int num = -1;
            foreach (var arg in args)
            {
                switch (arg.Key)
                {
                    case "-suitid":
                        suitid = arg.Value;break;
                    case "-eqtype":
                        eqtype = arg.Value;break;
                    case "-ex":
                        ex = arg.Value;break;
                    case "-num":
                        num = arg.Value;break;
                }
            }
            ConsoleLog.Println("筛选条件:suitid = " + suitid + " eqtype = "+ eqtype + " ex = "+ ex);
            var Range = generateRandomEquipIDRange(suitid, eqtype);

            var Count = 0;
            for (int i = 0;i < (num == -1 ? UnityEngine.Random.Range(0, 100) : num); i++)
            {
                string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
                string postData = @"roleid=" + UserUtil.getUserRID() +
                             @"&data={""rewardList"":[{" +
                             @"""type"":""equip""," +
                             @"""name"":" + Range[UnityEngine.Random.Range(0, Range.Count)] + @"," +
                             @"""num"":" + 1 +
                             @",""ex"":" + (ex == -1 ? UnityEngine.Random.Range(1,7) : ex) +
                             @"}]}";
                //UnityEngine.Debug.Log(url+postData);
                ConsoleLog.Println(postData);
                ConsoleLog.Println(ServerUtil.Post(url, postData));
                Count ++;
            }
            ConsoleLog.Println("生成了"+Count+"件装备.");
        }
        /* 生成给定筛选条件的随机装备id列表 */
        private List<int> generateRandomEquipIDRange(int suitid, int eqtype)
        {
            List<int> equipment =         new List<int> { 300110, 300120, 300130, 300140, 300150, 300160, 300170, 300180, 300210, 300220, 300230, 300240, 300250, 300260, 300270, 300280, };
            var filterBySuitID =          new List<int>();
            var filterByEquipmentType =   new List<int>();
            var equipGenerateRange =      new List<int>();
            if (suitid != -1)
            {
                foreach (var equip in equipment)
                {
                    //UnityEngine.Debug.Log("ID:"+ equip + " SuitID:" + equip.ToString().Substring(1, 3));
                    /* SuitID 从第二位到第四位 */
                    if (int.Parse(equip.ToString().Substring(1, 3)) == suitid)
                    {
                        filterBySuitID.Add(equip);
                    }
                }
            }
            if (eqtype != -1)
            {
                foreach (var equip in equipment)
                {
                    /* EquipmentType 第五位 */
                    if (int.Parse(equip.ToString().ElementAt(4).ToString()) == eqtype)
                    {
                        filterByEquipmentType.Add(equip);
                    }
                }
            }

            if (filterBySuitID.Count != 0 && filterByEquipmentType.Count != 0)
            {
                foreach (var id in filterBySuitID)
                    if (filterByEquipmentType.Contains(id))
                        equipGenerateRange.Add(id);
            }else if (filterBySuitID.Count != 0 && filterByEquipmentType.Count == 0)
            {
                equipGenerateRange.AddRange(filterBySuitID);
            }
            else
            {
                equipGenerateRange.AddRange(filterByEquipmentType);
            }

            if (equipGenerateRange.Count != 0)
            {
                return equipGenerateRange;
            }
            else
            {
                ConsoleLog.Println("现有装备列表中不存在给定筛选条件的装备\n将从所有装备中随机生成");
                return equipment;
            }
        }

        private void generateRandomItem(Dictionary<string, int> args)
        {
            int count = -1;
            int useType = -1;
            int num = -1;
            foreach (var arg in args)
            {
                switch (arg.Key)
                {
                    case "-count":
                        count = arg.Value; break;
                    case "-usetype":
                        useType = arg.Value; break;
                    case "-num":
                        num = arg.Value;break;
                }
            }
            ConsoleLog.Println("筛选条件:count = " + count + " useType = " + useType);
            var Range = generateRandomItemID(useType);

            var Count = 0;
            for (int i = 0; i < (count == -1 ? UnityEngine.Random.Range(0, 100) : count); i++)
            {
                string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
                string postData = @"roleid=" + UserUtil.getUserRID() +
                             @"&data={""rewardList"":[{" +
                             @"""type"":""item""," +
                             @"""name"":" + Range[UnityEngine.Random.Range(0, Range.Count)]+ @"," +
                             @"""num"":" + (num == -1 ? UnityEngine.Random.Range(1, 100):num) +
                             @"}]}";
                //UnityEngine.Debug.Log(postData);
                ConsoleLog.Println(ServerUtil.Post(url, postData));
                Count++;
            }
            ConsoleLog.Println("生成了" + Count + "个物品.");
        }

        private List<int> generateRandomItemID(int useType)
        {
            List<int> Items = new List<int>()
            {
                300144, 300145, 300146, 310044, 310045, 310046, 420001, 420002, 420003, 420004, 420005, 430001, 440001, 450001, 450002, 460001, 460002, 460003, 460004, 470001, 470002, 470003, 470004, 470005, 470006, 470007, 470008, 470009, 480001, 480002, 480003, 480004, 480005, 480006,
            };
            var itemGenerateRange = new List<int>();

            if (useType != -1)
            {
                foreach (var item in Items)
                {
                    /* EquipmentType 第二位 */
                    if (int.Parse(item.ToString().ElementAt(1).ToString()) == useType)
                    {
                        itemGenerateRange.Add(item);
                    }
                }
            }
            if (itemGenerateRange.Count != 0)
                return itemGenerateRange;
            else return Items;
        }

        private void generateRandomCard(Dictionary<string, int> args)
        {
            int num = -1;
            foreach (var arg in args)
            {
                switch (arg.Key)
                {
                    case "-num":
                        num = arg.Value; break;
                }
            }
            var Count = 0;
            for (int i = 0; i < (num == -1 ? UnityEngine.Random.Range(0, 100) : num); i++)
            {
                string url = Const.Protocol + "://" + Const.IP + ':' + Const.Port + Const.PATH + Const.MSG_SINGLE_REWARD;
                string postData = @"roleid=" + UserUtil.getUserRID() +
                             @"&data={""rewardList"":[{" +
                             @"""type"":""card""," +
                             @"""name"":" + "1010" + UnityEngine.Random.Range(1, 10).ToString("00") + @"," +
                             @"""num"":" + UnityEngine.Random.Range(1, 100) +
                             @"}]}";
                UnityEngine.Debug.Log(postData);
                ConsoleLog.Println(ServerUtil.Post(url, postData));
                Count++;
            }
            ConsoleLog.Println("生成了" + Count + "张卡牌.");

        }
    }
}
