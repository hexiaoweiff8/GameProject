using System;

namespace DeveloperConsole
{
    [AttributeUsage(AttributeTargets.Class,AllowMultiple = false,Inherited = true)]
    class CommandAttribute : Attribute
    {
        public readonly CommandType     commandType;
        public readonly string          CommandName;
        public readonly string          Notes;
        /// <summary>
        /// 构造方法
        /// </summary>
        /// <param name="name">指令名</param>
        /// <param name="comment">指令描述型文字</param>
        /// <param name="type">指令类型(客户端/服务器端)</param>
        public CommandAttribute(string name,string comment,CommandType type)
        {
            CommandName = name;
            Notes = comment;
            commandType = type;
        }
    }
    public enum CommandType
    {
        Client,
        Server,
    }
}
