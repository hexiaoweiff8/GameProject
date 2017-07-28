using System.Linq;
using DeveloperConsole.CommandFramework;

/// <summary>
/// 执行命令操作
/// </summary>
public class ConsoleSubmitAction : ConsoleAction
{
    public override void Activate()
    {
        if (ConsoleGUI._ins.input.isSelected)
        {
            var parts = ConsoleGUI._ins.input.value.Split(' ');
            var command = parts[0];
            var args = parts.Skip(1).ToArray();

            ConsoleLog.Log(ConsoleGUI._ins.input.value);
            /* 保存指令历史纪录 */
            ConsoleCommandHistory.PushCommand(ConsoleGUI._ins.input.value);

            if (CommandsRepository._ins.HasCommand(command))
            {
                string returnInfo = CommandsRepository._ins.ExecuteCommand(command, args);
                if (returnInfo != null)
                    ConsoleLog.Log(returnInfo);
            }
            else
            {
                ConsoleLog.Println("Command '" + command + "' not found");
            }
            ConsoleGUI._ins.input.value = "";
            /* 重置指令历史索引 */
            ConsoleCommandHistory.ResetSelection();
        }
        else
        {
            /*如果输入框处于非激活状态，则激活输入框*/
            ConsoleGUI._ins.input.isSelected = true;
        }
    }
}