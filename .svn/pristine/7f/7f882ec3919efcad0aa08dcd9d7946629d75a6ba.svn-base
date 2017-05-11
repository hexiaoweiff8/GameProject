using UnityEngine;
/// <summary>  
/// 个性化的编辑器的Log输出格式化  
/// </summary>  
public abstract class GAMELOG
{
    /// <summary>  
    /// <param name="level">不同等级的level</param>
    /// </summary>  
    public static void Log(string log, int level, string myDebugIP, bool isOpenSysLog)
    {
        if (!isOpenSysLog)
        {
            level = 0;
        }
#if UNITY_EDITOR

        switch (level)
        {
            case 1:
                Debug.Log(string.Format("<b><color={0}><size={1}>{2}</size></color></b>", "#BBBBBB", 15, log));
                break;
            case 2:
                Debug.Log(string.Format("<b><color={0}><size={1}>{2}</size></color></b>", "#0070BB", 15, log));
                break;
            case 3:
                Debug.Log(string.Format("<b><color={0}><size={1}>{2}</size></color></b>", "#D2691E", 15, log));
                break;
            case 4:
                Debug.Log(string.Format("<b><color={0}><size={1}>{2}</size></color></b>", "#BBBB23", 15, log));
                break;
            case 5:
                Debug.Log(string.Format("<b><color={0}><size={1}>{2}</size></color></b>", "#FF0006", 15, log));
                break;
            default:
                Debug.Log(Network.player.ipAddress == myDebugIP
                    ? string.Format("<b><color={0}><size={1}>{2}</size></color></b>", "lime", 15, log)
                    : log);
                break;
        }
#endif
    }
}


public class LGYLOG : GAMELOG
{
    private const bool isOpenSysLog = true;
    private const string myDebugIP = "192.168.1.96"; //自己的log类，填写自己的ip

    public static void Log(string log)
    {
        Log(log, 0, myDebugIP, isOpenSysLog);
    }

    public static void Log(string log, int level)
    {
        Log(log, level, myDebugIP, isOpenSysLog);
    }
}



public class NAME1LOG : GAMELOG
{
    private const bool isOpenSysLog = true;
    private const string myDebugIP = "192.168.1.**"; //自己的log类，填写自己的ip

    public static void Log(string log)
    {
        Log(log, 0, myDebugIP, isOpenSysLog);
    }

    public static void Log(string log, int level)
    {
        Log(log, level, myDebugIP, isOpenSysLog);
    }
}