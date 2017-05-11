using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/*
public enum SubTexiaoTypeEnum
{
    FlyObj = 1,//飞行物
    Shifa =2,//施法特效
    Beiji = 3,//被击特效
    Jianyu =4,//箭雨
}*/

public enum ZiyuanTypeEnum
{
    Lizi = 1,//粒子
    Jianyu = 2,//箭雨
}

public enum TexiaoAnimMode
{
    Loop = 1,//循环
    LiveLoop = 2,//生命时间内循环
    AutoDie = 3,//播放一遍后死亡
    Scale = 4,//生命时间内播放一遍
}
public class TexiaoInfo
{
    internal static short IID; 
    //internal static short ISubTexiaoType;
    internal static short IZiyuanType;
    internal static short ITexiaoName;
    internal static short IStartTime;
    internal static short IAnimMode;
    internal static short ILiveTime;
    internal static short IOffSetX;
    internal static short IOffSetXEnd;
    internal static short IOffSetY;
    internal static short IOffSetYEnd;
    internal static short IOffSetZ;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        //ISubTexiaoType = reader.ColumnName2Index("SubTexiaoType");
        ITexiaoName = reader.ColumnName2Index("TexiaoName");
        IStartTime = reader.ColumnName2Index("StartTime");
        IAnimMode = reader.ColumnName2Index("AnimMode");
        ILiveTime = reader.ColumnName2Index("LiveTime");
        IOffSetX = reader.ColumnName2Index("OffSetX");
        IOffSetXEnd = reader.ColumnName2Index("OffSetXEnd");
        IOffSetY = reader.ColumnName2Index("OffSetY");
        IOffSetYEnd = reader.ColumnName2Index("OffSetYEnd");
        
        IOffSetZ = reader.ColumnName2Index("OffSetZ");
        IZiyuanType = reader.ColumnName2Index("ZiyuanType");
    }

    public TexiaoInfo(ITabReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        ZiyuanType = (ZiyuanTypeEnum)reader.GetI16(IZiyuanType, row);
        TexiaoName = reader.GetS(ITexiaoName, row).Split(';');
        StartTime = (float)reader.GetI16(IStartTime, row) / 1000.0f;
        AnimMode = (TexiaoAnimMode)reader.GetI16(IAnimMode, row);
        LiveTime = (float)reader.GetI16(ILiveTime, row) / 1000.0f;

        OffSetX = reader.GetF(IOffSetX, row);
        OffSetXEnd = reader.GetF(IOffSetXEnd, row);
        OffSetY = reader.GetF(IOffSetY, row);
        OffSetZ = reader.GetF(IOffSetZ, row);
        OffSetYEnd = reader.GetF(IOffSetYEnd, row);
        

        //if (ZiyuanType == ZiyuanTypeEnum.Jianyu) JianID = int.Parse(TexiaoName);
    }


    public readonly ZiyuanTypeEnum ZiyuanType;
    //public readonly int GongJianName;//箭雨类型，弓箭资源名
    public readonly string[] TexiaoName;
    public readonly float StartTime;
    public readonly TexiaoAnimMode AnimMode;
    public readonly float LiveTime;
    public readonly float OffSetX;
    public readonly float OffSetXEnd;
    public readonly float OffSetY;
    public readonly float OffSetYEnd;
    public readonly float OffSetZ;
    public readonly int ID; 
}


public class SData_Texiao : MonoEX.Singleton<SData_Texiao>
{
    public SData_Texiao()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 Texiao");
            reader.Load("bsv", "Texiao");
            TexiaoInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                TexiaoInfo sa = new TexiaoInfo(reader, row);
                try
                {
                    Data.Add(sa.ID, sa);
                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("Texiao重复的ID: {0}", sa.ID));
                }
            }
        }
    }

    public TexiaoInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    Dictionary<int, TexiaoInfo> Data = new Dictionary<int, TexiaoInfo>(); 
} 
