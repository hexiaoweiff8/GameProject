using UnityEngine;
using System.Collections;

public class ConsoleLog {
    public static void Log(string message) {
        ConsoleGUI._ins.output.Add("> " + message);
    }
    public static void Println()
    {
        ConsoleGUI._ins.output.Add("");
    }
    public static void Println(string message)
    {
        ConsoleGUI._ins.output.Add(" " + message);
    }
    //public static void LogWarrning(string message)
    //{
    //    ConsoleGUI._ins.output.Add(" [DC143C]" + message + "[-]");
    //}
}
