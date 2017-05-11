using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_MissionMonster : MonoEX.Singleton<SData_MissionMonster>
{
    public SData_MissionMonster()
    {
        Single = this;
        int min = int.MaxValue;
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载  MissionMonster");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "MissionMonster");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    MissionMonsterInfo sa = new MissionMonsterInfo(reader, i);
                    Data.Add(sa.ID, sa);

                    if (sa.ID < min && sa.ID>100000)
                        min = sa.ID;
                }
                FirstGK = Get(min);
            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 MissionMonster 完毕!");

        }
    }

    /// <summary>
    /// 根据ID 获取 信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public MissionMonsterInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }


    #region (属性)

    public static SData_MissionMonster Single = null;

    Dictionary<int, MissionMonsterInfo> Data = new Dictionary<int, MissionMonsterInfo>();

    public MissionMonsterInfo FirstGK = null;


    #endregion


}


public class MissionMonsterInfo
{
    public MissionMonsterInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI32(IID, row);
        Name = reader.GetS(IName, row);
        Note = reader.GetS(INote, row);
        CityID = reader.GetI16(ICityID, row);
        MapID = reader.GetI16(IMapID, row);
        Music = reader.GetI16(IMusic, row);
        ZhenfaID = reader.GetI16(IZhenfaID, row);
        MonsterArmyNo = reader.GetI16(IMonsterArmyNo, row);
        HuifuHp = reader.GetF(IHuifuHp, row);
        ExpDiaoluo = reader.GetI32(IExpDiaoluo, row);
        MoneyDiaoluo = reader.GetI32(IMoneyDiaoluo, row);
        NextMonster = reader.GetI32(INextMonster, row);
        MonsterLv = reader.GetI16(IMonsterLv, row);

        for (int i = 0; i < heroNum; i++)
        {
            MonsterHeroInfo[i] = reader.GetI32(reader.ColumnName2Index("MonsterHeroID" + (i + 1).ToString()), row);
        }
        for (int i = 0; i < diaoluoNum; i++)
        {
            DiaoLuoList[i].DiaoluoTypeID = reader.GetI16(reader.ColumnName2Index("DiaoluoTypeID" + (i + 1).ToString()), row);
            DiaoLuoList[i].BookName = reader.GetI16(reader.ColumnName2Index("BookName" + (i + 1).ToString()), row);
            DiaoLuoList[i].SubBookName = reader.GetI16(reader.ColumnName2Index("SubBookName" + (i + 1).ToString()), row);
            DiaoLuoList[i].DiaoluoNum = reader.GetI32(reader.ColumnName2Index("Num" + (i + 1).ToString()), row);
        }

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        INote = reader.ColumnName2Index("Note");
        ICityID = reader.ColumnName2Index("CityID");
        IMapID = reader.ColumnName2Index("MapID");
        IMusic = reader.ColumnName2Index("Music");
        IZhenfaID = reader.ColumnName2Index("ZhenfaID");
        IMonsterArmyNo = reader.ColumnName2Index("MonsterArmyNo");
        IHuifuHp = reader.ColumnName2Index("HuifuHp");
        IExpDiaoluo = reader.ColumnName2Index("ExpDiaoluo");
        IMoneyDiaoluo = reader.ColumnName2Index("MoneyDiaoluo");
        INextMonster = reader.ColumnName2Index("NextMonster");
        IMonsterLv = reader.ColumnName2Index("MonsterLv");

    }

    public readonly int ID;
    public readonly string Name;
    public readonly string Note;
    public readonly int CityID;
    public readonly int MapID;
    public readonly int Music;
    public readonly int ZhenfaID;
    public readonly int MonsterArmyNo;
    public readonly int ExpDiaoluo;
    public readonly int MoneyDiaoluo;
    public readonly double HuifuHp;
    public readonly int NextMonster;
    public readonly int MonsterLv;
    public readonly int[] MonsterHeroInfo = new int[heroNum];
    public readonly DiaoLuoInfo[] DiaoLuoList = new DiaoLuoInfo[diaoluoNum];



    /*索引变量*/
    internal static short IID;
    internal static short IName;
    internal static short INote;
    internal static short ICityID;
    internal static short IMapID;
    internal static short IMusic;
    internal static short IZhenfaID;
    internal static short IMonsterArmyNo;
    internal static short IHuifuHp;
    internal static short IExpDiaoluo;
    internal static short IMoneyDiaoluo;
    internal static short INextMonster;
    internal static short IMonsterLv;



    const int heroNum = 5;
    const int diaoluoNum = 3;
}

public struct DiaoLuoInfo
{
    public int DiaoluoTypeID;
    public int BookName;
    public int SubBookName;
    public int DiaoluoNum;
}


