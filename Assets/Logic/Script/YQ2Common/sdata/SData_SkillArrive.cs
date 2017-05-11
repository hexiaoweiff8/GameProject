using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class SkillArriveInfo
{
    internal static short IFeixingwuAudioFx;
    internal static short IArriveTime;
    internal static short IFlySpeed;
    internal static short IFeixingwuGensui;
    internal static short IFeixingwuHuiguiYanchi;
    internal static short IFlyArc;
    internal static short IFlyAngle;
    internal static short IPiaoxueType;
    internal static short IID;
    internal static short IArriveType;
    internal static short IFeichuYanchi;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IArriveTime = reader.ColumnName2Index("ArriveTime");

        IFlySpeed = reader.ColumnName2Index("FlySpeed");
        IFeixingwuAudioFx = reader.ColumnName2Index("FeixingwuAudioFx");
        IFeixingwuGensui = reader.ColumnName2Index("FeixingwuGensui");

        IFeixingwuHuiguiYanchi = reader.ColumnName2Index("FeixingwuHuiguiYanchi");
        IFlyArc = reader.ColumnName2Index("FlyArc");
        IFlyAngle = reader.ColumnName2Index("FlyAngle");
        IPiaoxueType = reader.ColumnName2Index("PiaoxueType");
        IID = reader.ColumnName2Index("ID");
        IArriveType = reader.ColumnName2Index("ArriveType");
        IFeichuYanchi = reader.ColumnName2Index("FeichuYanchi");
        
    }

    public SkillArriveInfo(ITabReader reader, int row)
    {
        FeixingwuAudioFx = reader.GetI32(IFeixingwuAudioFx, row);
        FlySpeed = reader.GetF(IFlySpeed, row);
        ArriveTime = (float)reader.GetI16(IArriveTime, row) / 1000.0f;//转换为秒

        Gensui = reader.GetI16(IFeixingwuGensui, row) == 1;

        HuiguiYanchi = reader.GetI16(IFeixingwuHuiguiYanchi, row) / 1000.0f;

        FlyArc = (float)reader.GetI16(IFlyArc, row) / 10.0f;
        FlyAngle = reader.GetI16(IFlyAngle, row);
        ID = reader.GetI32(IID, row);

        ArriveType = (ArriveTypeEnum)reader.GetI16(IArriveType, row);
        FeichuYanchi = (float)reader.GetI16(IFeichuYanchi, row)/1000f;
        
    }

    public void BuildLinks()
    {
        if (FeixingwuAudioFx > 0) FeixingwuAudioFxObj = SData_AudioFx.Single.Get(FeixingwuAudioFx);
       
    }

    public readonly float ArriveTime;
    public  float FlySpeed;
    readonly int FeixingwuAudioFx;


    public AudioFxInfo FeixingwuAudioFxObj;
    public readonly bool Gensui;

    public readonly float HuiguiYanchi;
    public  float FlyArc;
    public  short FlyAngle;
    public readonly int ID;

    public readonly bool NeedPiaoxue;


    public readonly ArriveTypeEnum ArriveType;
    public readonly float FeichuYanchi;

    public enum ArriveTypeEnum
    {
        Yanchi = 1,//延迟
        Fly = 2,//飞行物
        Angle = 3//横扫
    }
}


public class SData_SkillArrive : MonoEX.Singleton<SData_SkillArrive>
{
    public SData_SkillArrive()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SkillArrive");

            reader.Load("bsv", "SkillArrive");
            SkillArriveInfo.FillFieldIndex(reader);
            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                SkillArriveInfo sa = new SkillArriveInfo(reader, row);

                try
                {
                    Data.Add(sa.ID, sa);
                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_DEBUG, "SkillArrive表重复的ID " + sa.ID.ToString());
                }
            }
        }
    }

    //构建对象之间的联系
    public void BuildLinks()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "SkillArrive 开始建立对象关联");
        foreach (var skillArrive in Data) skillArrive.Value.BuildLinks();
    }

    public SkillArriveInfo Get(int ID)
    {
        try
        {
            return Data[ID];
        }catch(Exception  ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "SkillArrive 不存在的id:" + ID.ToString());
            throw ex;
        }
    }

    Dictionary<int, SkillArriveInfo> Data = new Dictionary<int, SkillArriveInfo>();
}
