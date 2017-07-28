using System;

namespace DeveloperConsole.CommandFramework
{
    [AttributeUsage(AttributeTargets.Class)]
    class CommandArgumentAttribute : Attribute
    {
        public CommandArgumentAttribute(int index,Type argType,string desc)
        {

        }
    }
}
