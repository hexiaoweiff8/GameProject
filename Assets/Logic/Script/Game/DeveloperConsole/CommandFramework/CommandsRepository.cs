using System;
using System.Collections.Generic;

namespace DeveloperConsole.CommandFramework
{
    class CommandsRepository
    {
        private static CommandsRepository                       _instance;
        public readonly Dictionary<string, CommandBase>         repository;
        /// <summary>
        /// 命令仓库 单例
        /// </summary>
        public static CommandsRepository _ins
        {
            get
            {
                if (_instance == null)
                    _instance = new CommandsRepository();
                return _instance;
            }
            private set { _instance = value; }
        }

        private CommandsRepository()
        {
            repository = new Dictionary<string, CommandBase>();
        }
        public void RegisterCommand(string command, CommandBase commandClass)
        {
            //UnityEngine.Debug.Log("import " + command + " " + commandClass.GetType().Name);
            repository[command] = commandClass;
        }
        /// <summary>
        /// 执行指令
        /// </summary>
        /// <param name="command">指令字符串</param>
        /// <param name="args">指令参数</param>
        /// <returns></returns>
        public string ExecuteCommand(string command, string[] args)
        {
            command = command.ToLower();

            if (repository.ContainsKey(command))
            {
                repository[command].Execute(args);
                return null;
            }
            else
            {
                return "'" + command +  "' not found";
            }
        }

        public bool HasCommand(string command)
        {
            command = command.ToLower();

            if (repository.ContainsKey(command))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        /// <summary>
        /// 在所有命令中查找以指定头开始的命令
        /// </summary>
        /// <param name="InPrefix">待匹配的指令字符串</param>
        /// <returns></returns>
        public List<CommandBase> FilterByString(string InPrefix)
        {
            if (string.IsNullOrEmpty(InPrefix))
                return null;
            List<CommandBase> Results = new List<CommandBase>(16);

            var Iter = repository.GetEnumerator();

            while (Iter.MoveNext())
            {
                var Command = Iter.Current.Value;

                var baseCommand = (Command.GetType().GetCustomAttributes(typeof(CommandAttribute), false)[0] as CommandAttribute).CommandName;

                if (baseCommand.StartsWith(InPrefix, StringComparison.CurrentCultureIgnoreCase) ||
                    string.IsNullOrEmpty(InPrefix)
                    )
                {
                    Results.Add(Command);
                }
            }

            return Results;
        }
    }
}
