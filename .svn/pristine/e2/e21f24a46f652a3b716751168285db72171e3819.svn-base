using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public enum AudioAnimMode
{
    Loop = 1,//循环
    LiveLoop = 2,//生命时间内循环
    AutoDie = 3,//播放一遍后死亡
}

public class AudioInfo
{
    internal static short IID;
    internal static short ISound;
    internal static short I2Dor3D;
    internal static short ISoundStart;
    internal static short IAnimMode;
    internal static short ILiveTime;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        ISound = reader.ColumnName2Index("Sound");
        I2Dor3D = reader.ColumnName2Index("2Dor3D");
        ISoundStart = reader.ColumnName2Index("SoundStart");
        IAnimMode = reader.ColumnName2Index("AnimMode");
        ILiveTime = reader.ColumnName2Index("LiveTime");
    }

    public AudioInfo(ITabReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        Sound = reader.GetS(ISound, row);
        _2Dor3D = reader.GetI16(I2Dor3D, row);
        SoundStart = (float)reader.GetI16(ISoundStart, row) / 1000f;
        AnimMode = (AudioAnimMode)reader.GetI16(IAnimMode, row);
        LiveTime = (float)reader.GetI16(ILiveTime, row) / 1000f;
    }
    public readonly int ID;
    public readonly string Sound;
    public readonly short _2Dor3D;
    public readonly float SoundStart;
    public readonly AudioAnimMode AnimMode;
    public readonly float LiveTime;
}

public class SData_Audio : MonoEX.Singleton<SData_Audio>
{
    public SData_Audio()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 Audio");
            reader.Load("bsv", "Audio");
            AudioInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                AudioInfo sa = new AudioInfo(reader, row);
                try
                {
                    Data.Add(sa.ID, sa);
                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("Audio重复的ID: {0}", sa.ID));
                }
            }
        }
    }

    public AudioInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    Dictionary<int, AudioInfo> Data = new Dictionary<int, AudioInfo>(); 
} 