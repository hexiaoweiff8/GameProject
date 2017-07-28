using System;

namespace DeveloperConsole.CommandFramework
{
    class AutoRegisterAttribute : Attribute{ }

    [AttributeUsage(AttributeTargets.Class)]
    class CommandEntryAttribute : AutoRegisterAttribute
    {
        public string Group { get; protected set; }

        public CommandEntryAttribute(string InGroup)
        {
            Group = InGroup;
        }
    }

    [AttributeUsage(AttributeTargets.Method)]
    class CommandEntryMethodAttribute : AutoRegisterAttribute
    {
        public readonly string CommandName;
        public readonly string Notes;
        public CommandEntryMethodAttribute(string CommandName, string InNotes)
        {
            this.CommandName = CommandName;
            Notes = InNotes;
        }
    }
}
