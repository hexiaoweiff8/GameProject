using System.Collections.Generic;

public class ConsoleCommandHistory {

    static List<string> history = new List<string>();

    static int Selection = -1;

    public static void PushCommand(string InFullCommand)
    {
        for (int i = 0; i < history.Count; ++i)
        {
            if (history[i] == InFullCommand)
            {
                history.RemoveAt(i);
                break;
            }
        }
        history.Add(InFullCommand);
    }

    public static void ResetSelection()
    {
        Selection = -1;
    }

    public static string previousCommand
    {
        get
        {
            if (Selection > 0 && Selection < history.Count)
            {
                return history[--Selection];
            }
            else if (Selection == -1 && history.Count > 0)
            {
                Selection = history.Count - 1;
                return history[Selection];
            }
            else
            {
                return history.Count == 0 ? "" : history[0];
            }
        }
    }

    public static string nextCommand
    {
        get
        {
            if (Selection >= 0 && Selection < history.Count - 1)
            {
                return history[++Selection];
            }
            else
            {
                return history.Count == 0 ? "" : history[history.Count - 1];
            }
        }
    }
}
