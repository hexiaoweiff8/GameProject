using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public enum VibrationAnimMode
{
    Loop = 1,//循环
    LiveLoop = 2,//生命时间内循环
    AutoDie = 3,//播放一遍后死亡
}


public class VibrationInfo
{
    internal static short IID;
    internal static short IVibration;
    internal static short IStartTime;
    internal static short IAnimMode;
    internal static short ILiveTime;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IVibration = reader.ColumnName2Index("Vibration");
        IStartTime = reader.ColumnName2Index("StartTime");
        IAnimMode = reader.ColumnName2Index("AnimMode");
        ILiveTime = reader.ColumnName2Index("LiveTime");
    }

    public VibrationInfo(ITabReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        Vibration = reader.GetS(IVibration, row);
        StartTime =  (float)reader.GetI16(IStartTime, row)/1000.0f;
            AnimMode = (VibrationAnimMode)reader.GetI16(IAnimMode, row);
            LiveTime = (float)reader.GetI16(ILiveTime, row) / 1000.0f;
    }

    public readonly int ID;
    public readonly string Vibration;
    public readonly float StartTime;
    public readonly VibrationAnimMode AnimMode;
    public readonly float LiveTime;
}

public class SData_Vibration : MonoEX.Singleton<SData_Vibration>
{
    public SData_Vibration()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 Vibration");
            reader.Load("bsv", "Vibration");
            VibrationInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                var sa = new VibrationInfo(reader, row);
                try
                {
                    Data.Add(sa.ID, sa);
                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("Vibration重复的ID: {0}", sa.ID));
                }
            }
        }
    }

    public VibrationInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    Dictionary<int, VibrationInfo> Data = new Dictionary<int, VibrationInfo>(); 
} 