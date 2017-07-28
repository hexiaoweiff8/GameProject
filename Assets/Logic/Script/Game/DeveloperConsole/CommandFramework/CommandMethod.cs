using System;
using System.Reflection;

namespace DeveloperConsole.CommandFramework
{
    class CommandMethod : CommandBase
    {
        MethodInfo                  Method;
        string                      CommandName;
        CommandEntryMethodAttribute MethodAttr;
        public override string commandName
        {
            get
            {
                return MethodAttr.CommandName;
            }
            set { return; }
        }

        public override string commandNotes
        {
            get
            {
                return MethodAttr.Notes;
            }
            set { return; }
        }

        public CommandMethod(MethodInfo InMethod,
            string CommandName,
            CommandEntryMethodAttribute InMethodAttr)
        {
            Method = InMethod;
            this.CommandName = CommandName;
            MethodAttr = InMethodAttr;
        }

        public override void Execute(string[] arguments)
        {
            ConsoleLog.Println(Method.Invoke(null, null) as string);
        }
    }
}
