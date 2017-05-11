using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class ZhenfaInfo
{
    public const int LCount = 4;

    internal static short IID;
    internal static short IZhenName;
    internal static short IJianjie;
    internal static short IZhenfaBuzhi;
    //internal static short[] IZhenfaBuzhi = new short[LCount];
    //internal static short[] IArmyNo = new short[LCount];

    internal static short IStartLv;
    internal static short IIsFangyuzhen; 
    internal static short IIcon;  

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IZhenName = reader.ColumnName2Index("ZhenName");
        IJianjie = reader.ColumnName2Index("Jianjie");
        IStartLv = reader.ColumnName2Index("StartLv");
        IIsFangyuzhen = reader.ColumnName2Index("IsFangyuzhen");
        IIcon = reader.ColumnName2Index("Icon");
        //IZhenWei = reader.ColumnName2Index("ZhenWei");

        /*
        for (int i = 0; i < LCount; i++)
        {
            string istr = (i + 1).ToString();
            IArmyNo[i] = reader.ColumnName2Index("ArmyNo" + istr);
            IZhenfaBuzhi[i] = reader.ColumnName2Index("ZhenfaBuzhi" + istr);
        }*/
        IZhenfaBuzhi = reader.ColumnName2Index("ZhenfaBuzhi" );
    }

    public ZhenfaInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(IID, row);
        ZhenName = reader.GetS(IZhenName, row);
        Jianjie = reader.GetS(IJianjie, row);
        StartLv = reader.GetI16(IStartLv, row);
        IsFangyuzhen = reader.GetI16(IIsFangyuzhen, row)==1;
        Icon = reader.GetS(IIcon, row);
        
        /*
         for (int i = 0; i < LCount; i++)
         {
             ArmyNo[i] = reader.GetI16(IArmyNo[i], row);
             ZhenfaBuzhi[i] = reader.GetS(IZhenfaBuzhi[i], row);
         }*/

         ZhenfaBuzhi = reader.GetS(IZhenfaBuzhi, row);
         //ZhenWei = reader.GetS(IZhenWei, row).Split(';');
    }

    public readonly short ID;
    public readonly string ZhenName;
    public readonly string Jianjie;
    public readonly short StartLv;
    public readonly bool IsFangyuzhen;
    public readonly string ZhenfaBuzhi;
    public readonly string Icon;
    public TacticalDeployment ZhenInfo;

    //public readonly short[] ArmyNo = new short[LCount];
    //public readonly string[] ZhenfaBuzhi = new string[LCount];

    /// <summary>
    /// 获取阵法布置名
    /// </summary>
    /*public string GetZhenfaBuzhi(int armyCount)
    {
        for(int i=0;i<LCount;i++)
        {
            if (armyCount <= ArmyNo[i])
                return ZhenfaBuzhi[i];
        }
        return ZhenfaBuzhi[LCount-1];
    }*/
    //public readonly string[] ZhenWei = { "1", "2", "3", "4", "5" };

}
 
public class SData_Zhenfa : MonoEX.Singleton<SData_Zhenfa>
{
    public SData_Zhenfa()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            int minLevel = 999999;
            StartZhenfaInfo = null;

            reader.Load("bsv", "Zhenfa");
            ZhenfaInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                ZhenfaInfo zfInfo = new ZhenfaInfo(reader, row);
                Data.Add(zfInfo.ID, zfInfo);


                if (zfInfo.StartLv < minLevel)
                {
                    minLevel = zfInfo.StartLv;
                    StartZhenfaInfo = zfInfo;
                }
            }
        }
    }

    //SData_TacticalDeployment

    public ZhenfaInfo Get(short id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    public TacticalDeployment QixiZhenBuzhi;

    //startLv最小的一个记录
    public readonly ZhenfaInfo StartZhenfaInfo = null;

    public Dictionary<short, ZhenfaInfo> Data = new Dictionary<short, ZhenfaInfo>(); 
}
