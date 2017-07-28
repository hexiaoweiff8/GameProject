using System;
using UnityEngine;

namespace DeveloperConsole.CommandFramework
{
    public abstract class CommandBase
    {
        public abstract string commandName { get; set; }
        public abstract string commandNotes { get; set; }
        public abstract void Execute(string[] arguments);
    }
}
