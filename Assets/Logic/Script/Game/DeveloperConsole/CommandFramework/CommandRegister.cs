using System;
using System.Reflection;
using System.Linq;

namespace DeveloperConsole.CommandFramework
{
    class CommandRegister
    {
        private static CommandRegister instance;
        /// <summary>
        /// 命令注册器 单例
        /// </summary>
        public static CommandRegister _ins
        {
            get {
                if (instance == null)
                    instance = new CommandRegister();
                return instance;
            }
            private set { instance = value; }
        }
        public void Register(Assembly InAssembly)
        {
            RegisterMethodCommand(InAssembly);
            RegisterClassCommand(InAssembly);
        }
        /// <summary>
        /// @DONE:将带有CommandEntryMethod特性的方法注册到命令仓库中
        /// @FIXME:注册的方法必须是静态无参方法(注册筛选:静态,无参)
        /// </summary>
        /// <param name="asm">typeof(Target).Assembly</param>
        public void RegisterMethodCommand(Assembly asm)
        {
            Type[] types = asm.GetTypes();
            //Type[] types = asm.GetExportedTypes();
            /***
             * 在所有程序集中查找特性为CommandEntryMethodAttribute的类型
             ***/
            Func<System.Attribute[], bool> IsMethodCommand = attrs =>
            {
                foreach (Attribute cm in attrs)
                    if (cm is CommandEntryAttribute)
                        return true;

                return false;
            };
            /***
             * 在所有程序集中查找特性为CommandEntryMethodAttribute的类型
             ***/
            Type[] commandGroupTypes = types.Where(attrs => {
                return IsMethodCommand(System.Attribute.GetCustomAttributes(attrs, true));
            }).ToArray();
            /***
             * 遍历特性为CommandEntryMethodAttribute的类,注册到命令仓库 
             ***/
            foreach (var commandGroup in commandGroupTypes)
            {
                foreach (var commandMethod in commandGroup.GetMethods())
                {
                    /* 注册静态方法 */
                    if (commandMethod.IsStatic)
                    {
                        //创建命令类实例
                        var methodAttr = commandMethod.GetCustomAttributes(typeof(CommandEntryMethodAttribute), true)[0] as
                            CommandEntryMethodAttribute;
                        var commandName = methodAttr.CommandName;

                        CommandsRepository._ins.RegisterCommand(commandName, new CommandMethod(commandMethod, commandName, methodAttr));
                    }
                }
            }
        }
        /// <summary>
        /// @DONE:将带有Command特性的类注册到命令仓库中
        /// </summary>
        /// <param name="asm">typeof(Target).Assembly</param>
        public void RegisterClassCommand(Assembly asm)
        {
            Type[] types = asm.GetTypes();
            //Type[] types = asm.GetExportedTypes();
            /***
             * 在所有程序集中查找特性为CommandAttribute的类型
             ***/
            Func<System.Attribute[], bool> IsCommand = attrs =>
            {
                foreach (Attribute cm in attrs)
                    if (cm is CommandAttribute)
                        return true;

                return false;
            };
            /***
             * 在所有程序集中查找特性为CommandAttribute的类型
             ***/
            Type[] commandTypes = types.Where(attrs =>{
                return IsCommand(System.Attribute.GetCustomAttributes(attrs, true));
            }).ToArray();
            /***
             * 遍历特性为CommandAttribute的类,注册到命令仓库 
             ***/
            foreach (var command in commandTypes)
            {
                //创建命令类实例
//                var objref = ConsoleGUI._ins.gameObject.AddComponent(command);
                var obj = command.Assembly.CreateInstance(command.FullName);
                if (obj != null && obj is CommandBase)
                {
                    var preExecuteCommand = obj as CommandBase;

                    CommandsRepository._ins.RegisterCommand(
                        (command.GetCustomAttributes(typeof(CommandAttribute),true)[0] as CommandAttribute).CommandName,
                        preExecuteCommand);
                }
            }
        }
    }
}
