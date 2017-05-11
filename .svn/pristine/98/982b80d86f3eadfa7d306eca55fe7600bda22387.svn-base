using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using YQ2Common.CObjects;


/// <summary>
/// 抽奖货币类型
/// </summary>
public enum CJHuobiType
{
    Copper = 1,
    Gold = 2,
    Other = 0,
}


public class ChouJiangJL
{
    public int ID;
    public int Item;
    public int Quanzhong;
    public BOOK_NAME BookName;
    public int SubType = -99;

    int _num = -99;
    public int Num
    {
        get
        {
            if (_num == -99)
                _num = cjItem.GetRandNum();
            return _num;
        }
        set
        {
            _num = value;
        }
    }
    CJItemInfo _cjItem = null;
    public CJItemInfo cjItem
    {
        get
        {
            if (_cjItem == null)
                _cjItem = SData_ChoujiangItem.Single.Get(Item);
            return _cjItem;
        }
        set
        {
            _cjItem = value;
        }
    }
}


public class ChouJiangInfo
{
    public ChouJiangInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(reader.ColumnName2Index("ID"), row);
        Huobi = reader.GetI16(reader.ColumnName2Index("Currency"), row);
        LV = reader.GetI16(reader.ColumnName2Index("LV"), row);
        Lvmax = reader.GetI16(reader.ColumnName2Index("Lvmax"), row);


        string[] getnumStr;
        getnumStr = reader.GetS(reader.ColumnName2Index("GetNum"), row).Split(';');
        if (getnumStr.Length > 1)
        {
            GetNum[0] = int.Parse(getnumStr[0]);
            GetNum[1] = int.Parse(getnumStr[1]);
        }

        {//金币十连抽对应奖励序列
            String[] _Lian10;
            _Lian10 = reader.GetS(reader.ColumnName2Index("Gold10LianTimes"), row).Split('_');
            if (_Lian10.Length == 1)
            {
                if (String.IsNullOrEmpty(_Lian10[0]))
                    Gold10LianTimes = null;
                else
                {
                    if (_Lian10[0] != "-1")
                    {
                        string[] tempL = _Lian10[0].Split(':');
                        if (tempL.Length > 1)
                        {
                            for (int i = int.Parse(tempL[0]); i <= int.Parse(tempL[1]); i++)
                            {
                                Gold10LianTimes.Add(i);
                            }
                        }
                        else if (tempL.Length == 1)
                        {
                            Gold10LianTimes.Add(int.Parse(tempL[0]));
                        }
                    }
                }
            }
            else
            {
                int TempIndex = 0;
                foreach (string str in _Lian10)
                {
                    string[] tempL = str.Split(':');
                    if (tempL.Length > 1)
                    {
                        for (int i = int.Parse(tempL[0]); i <= int.Parse(tempL[1]); i++)
                        {
                            Gold10LianTimes.Add(i);
                        }
                    }
                    else if (tempL.Length == 1)
                    {
                        Gold10LianTimes.Add(int.Parse(tempL[0]));
                    }
                }
            }
        }

        {//金币一抽对应奖励序列
            String[] _Jin1;
            _Jin1 = reader.GetS(reader.ColumnName2Index("GoldTimes"), row).Split('_');
            if (_Jin1.Length == 1)
            {
                if (String.IsNullOrEmpty(_Jin1[0]))
                    GoldTimes = null;
                else
                {
                    if (_Jin1[0] != "-1")
                    {
                        string[] tempL = _Jin1[0].Split(':');
                        if (tempL.Length > 1)
                        {
                            for (int i = int.Parse(tempL[0]); i <= int.Parse(tempL[1]); i++)
                            {
                                GoldTimes.Add(i);
                            }
                        }
                        else if (tempL.Length == 1)
                        {
                            GoldTimes.Add(int.Parse(tempL[0]));
                        }
                    }
                }
            }
            else
            {
                int TempIndex = 0;
                foreach (string str in _Jin1)
                {
                    string[] tempL = str.Split(':');
                    if (tempL.Length > 1)
                    {
                        for (int i = int.Parse(tempL[0]); i <= int.Parse(tempL[1]); i++)
                        {
                            GoldTimes.Add(i);
                        }
                    }
                    else if (tempL.Length == 1)
                    {
                        GoldTimes.Add(int.Parse(tempL[0]));
                    }
                }
            }
        }

        for (int i = 0; i < JLInfo.Length; i++)
        {
            String stri = (i + 1).ToString();
            ChouJiangJL n = new ChouJiangJL();
            n.Quanzhong = reader.GetI16(reader.ColumnName2Index("Quanzhong" + stri), row);
            n.Item = reader.GetI16(reader.ColumnName2Index("Item" + stri), row);
            n.cjItem = SData_ChoujiangItem.Single.Get(n.Item);
            n.BookName = n.cjItem.BookName;
            n.SubType = n.cjItem.SubType;
            n.ID = i + 1;
            JLInfo[i] = n;

            if (i == 8) //第9个是首次必出的奖励
                FirstJL = n;

            sumQuanzhong += n.Quanzhong;
        }
    }

    /// <summary>
    /// 打乱奖励序列
    /// </summary>
    public void RandomJLSort()
    {
        for (int i = 0; i < 5; i++)
        {
            int index1 = SData_KeyValue.Single.RandomInt(0, JLInfo.Length - 1);
            int index2 = SData_KeyValue.Single.RandomInt(0, JLInfo.Length - 1);
            if (index1 == index2) continue;

            ChouJiangJL z = JLInfo[index1];
            JLInfo[index1] = JLInfo[index2];
            JLInfo[index2] = z;
        }
    }

    /// <summary>
    /// 随机获取奖励
    /// </summary>
    /// <returns></returns>
    public ChouJiangJL RandomJL()
    {
        int qz = SData_KeyValue.Single.RandomInt(0, sumQuanzhong - 1);
        foreach (ChouJiangJL jl in JLInfo)
        {
            if (qz < jl.Quanzhong) return jl;
            qz -= jl.Quanzhong;
        }

        return JLInfo[0];
    }

    /// <summary>
    /// 按权重从奖池的部分奖励中获取一个奖励
    /// </summary>
    /// <returns></returns>
    public ChouJiangJL RandomJL(List<int> IdxList)
    {
        int sumQZ = 0;
        foreach (int idx in IdxList)
        {
            sumQZ += JLInfo[idx].Quanzhong;
        }
        int qz = SData_KeyValue.Single.RandomInt(0, sumQZ - 1);
        foreach (int idx in IdxList)
        {
            if (qz < JLInfo[idx].Quanzhong) return JLInfo[idx];
            qz -= JLInfo[idx].Quanzhong;
        }

        return JLInfo[0];
    }

    /// <summary>
    /// 按权重筛选10连抽奖励
    /// </summary>
    /// <returns></returns>
    public List<ChouJiangJL> RandomJL(int reCount, int reQZ)
    {

        //随机赋值权重
        //第一个int为奖池列表下标索引、第一个int为权重排序值
        List<KeyValuePair<int, int>> wlist = new List<KeyValuePair<int, int>>();
        for (int i = 0; i < JLInfo.Length; i++)
        {
            // （权重+1） + 从0到（总权重-1）的随机数
            int NewQ = (JLInfo[i].Quanzhong + 1) + SData_KeyValue.Single.RandomInt(0, sumQuanzhong - 1);
            wlist.Add(new KeyValuePair<int, int>(i, NewQ));
        }

        //降序
        wlist.Sort(
          delegate(KeyValuePair<int, int> kvp1, KeyValuePair<int, int> kvp2)
          {
              return kvp2.Value - kvp1.Value;
          });

        //依据需求取列表
        List<ChouJiangJL> reList = new List<ChouJiangJL>();

        foreach(KeyValuePair<int,int> curr in wlist)
        {
            if (reCount <= 0) break;
            ChouJiangJL item = JLInfo[curr.Key];
            if (item.Quanzhong >= reQZ)
            {
                reList.Add(item);
                reCount--;
            }
        }

        if(reCount!=0)
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "奖池中抽取部分奖励是，未能抽出满足条件对应个数的奖励！");

        return reList;
    }

    /// <summary>
    /// 返回抽出个数
    /// </summary>
    public int reCount
    {
        get
        {
            if (GetNum.Length > 1)
                return GetNum[0];
            else
                return 10;
        }
    }
    /// <summary>
    /// 返回抽取个数最低限制权重
    /// </summary>
    public int reQZ
    {
        get
        {
            if (GetNum.Length > 1)
                return GetNum[1];
            else
                return 0;
        }
    }

    public readonly ChouJiangJL FirstJL = null;
    public readonly int sumQuanzhong = 0;//总权重
    public readonly int ID;
    public readonly int Huobi;
    public readonly int LV;
    public readonly int Lvmax;
    public readonly List<int> GoldTimes = new List<int>();
    public readonly List<int> Gold10LianTimes = new List<int>();
    public readonly int[] GetNum = new int[2];
    public readonly ChouJiangJL[] JLInfo = new ChouJiangJL[10];

}

public class SData_ChouJiang : MonoEX.Singleton<SData_ChouJiang>
{
    public SData_ChouJiang()
    {
        //读取该表前提应读表
        SData_ChoujiangItem.AutoInstance();

        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 ChouJiang");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "ChouJiang");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    ChouJiangInfo sa = new ChouJiangInfo(reader, i);
                    Data.Add(sa.ID, sa);

                    switch (sa.Huobi)
                    {
                        case 1:
                            {
                                //if (
                                //    sa.ID < SData_KeyValue.Single.GoldchouleijiMix ||
                                //    sa.ID > SData_KeyValue.Single.GoldchouleijiMax
                                //    )
                                CopperJLIDList.Add(sa.ID);

                            }
                            break;
                        case 2:
                            GoldJLIDList.Add(sa.ID);
                            break;
                        default:
                            ZhaomulingJLIDList.Add(sa.ID);
                            break;
                    };
                    if (sa.GoldTimes != null)
                    {
                        foreach (int cs in sa.GoldTimes)
                        {
                            if (!_Jin1Range.ContainsKey(cs))
                                _Jin1Range.Add(cs, new List<int>());

                            _Jin1Range[cs].Add(sa.ID);
                        }
                    }
                    if (sa.Gold10LianTimes != null)
                    {
                        foreach (int cs in sa.Gold10LianTimes)
                        {
                            if (!_Lian10Range.ContainsKey(cs))
                                _Lian10Range.Add(cs, new List<int>());

                            _Lian10Range[cs].Add(sa.ID);
                        }
                    }
                }
                _GoldJLIDList = GoldJLIDList.ToArray();
                _CopperJLIDList = CopperJLIDList.ToArray();
                _ZhaomulingJLIDList = ZhaomulingJLIDList.ToArray();

                foreach (KeyValuePair<int, List<int>> curr in _Jin1Range)
                {
                    Jin1Range.Add(curr.Key, curr.Value.ToArray());
                }

                foreach (KeyValuePair<int, List<int>> curr in _Lian10Range)
                {
                    Lian10Range.Add(curr.Key, curr.Value.ToArray());
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 ChouJiang 完毕!");
        }
    }

    #region (属性)


    List<int> GoldJLIDList = new List<int>();
    List<int> CopperJLIDList = new List<int>();
    List<int> ZhaomulingJLIDList = new List<int>();
    Dictionary<int, List<int>> _Lian10Range = new Dictionary<int, List<int>>();
    Dictionary<int, List<int>> _Jin1Range = new Dictionary<int, List<int>>();

    int[] _GoldJLIDList = null;
    int[] _CopperJLIDList = null;
    int[] _ZhaomulingJLIDList = null;
    Dictionary<int, ChouJiangInfo> Data = new Dictionary<int, ChouJiangInfo>();
    Dictionary<int, int[]> Jin1Range = new Dictionary<int, int[]>();
    Dictionary<int, int[]> Lian10Range = new Dictionary<int, int[]>();

    #endregion

    #region(方法)

    /// <summary>
    /// 获取抽奖数据
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public ChouJiangInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    /// <summary>
    /// 获取金币随机奖励数据
    /// </summary>
    /// <returns></returns>
    public ChouJiangInfo RandomGoldGroup(int lv)
    {
        int[] lvIndexList = GetLVDataInx(lv, (int)CJHuobiType.Gold).ToArray();
        int index = SData_KeyValue.Single.RandomInt(0, lvIndexList.Length - 1);
        return Data[lvIndexList[index]];
    }

    /// <summary>
    /// 获取多次金十连抽奖励序列
    /// </summary>
    /// <param name="cs"></param>
    /// <returns></returns>
    public ChouJiangInfo RandomGoldGroupLimit(int cs, int lv)
    {
        if (!Lian10Range.ContainsKey(cs))
        {
            return null;
            throw new Exception(String.Format("缺少金10连限制次数数据 cs:{0}", cs));
        }

        int[] ids = Lian10Range[cs];

        Dictionary<int, ChouJiangInfo> dataLV = new Dictionary<int, ChouJiangInfo>();//等级限制奖池列表
        GetLVData(ref dataLV, lv, ids, (int)CJHuobiType.Gold);
        int id = dataLV.Keys.ToArray<int>()[SData_KeyValue.Single.RandomInt(0, dataLV.Count - 1)];
        return dataLV[id];
    }

    /// <summary>
    /// 必出武将的金1抽随机
    /// </summary>
    /// <returns></returns>
    public ChouJiangInfo RandomGoldGroupMustHero()
    {
        //int id = SData_KeyValue.Single.RandomInt(SData_KeyValue.Single.GoldchouleijiMix, SData_KeyValue.Single.GoldchouleijiMax);
        int id = 1;
        return Data[id];
    }

    /// <summary>
    /// 首次金抽奖励
    /// </summary>
    /// <param name="groupID"></param>
    /// <returns></returns>
    public ChouJiangJL FirstGoldJL(ref int groupID)
    {
        ChouJiangInfo jlInfo = Get(2001);
        groupID = jlInfo.ID;
        return jlInfo.FirstJL;
    }

    /// <summary>
    /// 首次铜抽奖励
    /// </summary>
    /// <param name="groupID"></param>
    /// <returns></returns>
    public ChouJiangJL FirstTBJL(ref int groupID)
    {
        ChouJiangInfo jlInfo = Get(1001);
        groupID = jlInfo.ID;
        return jlInfo.FirstJL;
    }

    /// <summary>
    /// 随机获取金抽奖励
    /// </summary>
    /// <param name="groupID"></param>
    /// <returns></returns>
    public ChouJiangJL RandomGoldJL(int cs, ref int groupID, int lv)
    {
        ChouJiangInfo jlInfo = RandomGoldGroup(lv);
        groupID = jlInfo.ID;
        if (isGoldMustHero(cs) == 0)
            return jlInfo.RandomJL(SData_KeyValue.Single.MustHeroIdx);
        else
            return jlInfo.RandomJL();
    }
    /// <summary>
    /// 获取多次金一抽奖励序列
    /// </summary>
    /// <param name="cs"></param>
    /// <returns></returns>
    public ChouJiangJL RandomGoldLimit(int cs, ref int groupID, int lv)
    {
        if (!Jin1Range.ContainsKey(cs))
        {
            return null;
            throw new Exception(String.Format("缺少金10连限制次数数据 cs:{0}", cs));
        }
        int[] ids = Jin1Range[cs];

        Dictionary<int, ChouJiangInfo> dataLV = new Dictionary<int, ChouJiangInfo>();//等级限制奖池列表
        GetLVData(ref dataLV, lv, ids, (int)CJHuobiType.Gold);
        int id = dataLV.Keys.ToArray<int>()[SData_KeyValue.Single.RandomInt(0, dataLV.Count - 1)];
        groupID = id;
        if (isGoldMustHero(cs) == 0)
            return dataLV[id].RandomJL(SData_KeyValue.Single.MustHeroIdx);
        else
            return dataLV[id].RandomJL();
    }

    /// <summary>
    /// 是否必出武将
    /// </summary>
    /// <param name="currJin1CS"></param>
    /// <returns></returns>
    static int isGoldMustHero(int currJin1CS)
    {
        int re = -1;
        //GoldchouleijiNo
        int GoldLimit = SData_KeyValue.Single.GoldControllableTimes;
        if (currJin1CS <= GoldLimit)
        {
            int mustCS = 0;
            foreach (int cs in SData_KeyValue.Single.GoldGetHero)
            {
                mustCS += cs;
                if (currJin1CS == mustCS)
                {
                    re = 0;
                    break;
                }
            }
        }
        else
        {
            int lastIdx = SData_KeyValue.Single.GoldGetHero.Length - 1;
            int GoldchouleijiNo = SData_KeyValue.Single.GoldGetHero[lastIdx];
            re = GoldchouleijiNo - (currJin1CS % GoldchouleijiNo);//-1 排除第一次特殊抽
            if (re == GoldchouleijiNo)
                re = 0;
            else if (re > GoldchouleijiNo)
                re %= GoldchouleijiNo;//还没开始进入免费抽阶段
        }
        return re;
    }

    /// <summary>
    /// 距离必出武将剩余次数
    /// </summary>
    /// <param name="currJin1CS"></param>
    /// <returns></returns>
    public static int GoldMustHeroCS(int currJin1CS)
    {
        int re = 0;
        //GoldchouleijiNo
        int GoldLimit = SData_KeyValue.Single.GoldControllableTimes;
        if (currJin1CS <= GoldLimit)
        {
            int mustCS = 0;
            foreach (int cs in SData_KeyValue.Single.GoldGetHero)
            {
                mustCS += cs;
                if (currJin1CS < mustCS)
                {
                    re = mustCS - currJin1CS;
                    break;
                }
            }
        }
        else
        {
            int lastIdx = SData_KeyValue.Single.GoldGetHero.Length - 1;
            int GoldchouleijiNo = SData_KeyValue.Single.GoldGetHero[lastIdx];
            re = GoldchouleijiNo - (currJin1CS % GoldchouleijiNo);//-1 排除第一次特殊抽
        }
        return re - 1;//减一次
    }

    /// <summary>
    /// 随机获取金抽奖励
    /// </summary>
    /// <param name="groupID"></param>
    /// <returns></returns>
    public ChouJiangJL RandomGoldJLMustHero(ref int groupID)
    {
        ChouJiangInfo jlInfo = RandomGoldGroupMustHero();
        groupID = jlInfo.ID;
        return jlInfo.RandomJL();
    }


    /// <summary>
    /// 随机铜抽奖励
    /// </summary>
    /// <returns></returns>
    public ChouJiangInfo RandomCopperGroup(int lv)
    {
        int[] lvIndexList = GetLVDataInx(lv, (int)CJHuobiType.Copper).ToArray();
        int index = SData_KeyValue.Single.RandomInt(0, lvIndexList.Length - 1);
        return Data[lvIndexList[index]];
    }

    /// <summary>
    /// 随机铜抽奖励
    /// </summary>
    /// <param name="groupID"></param>
    /// <returns></returns>
    public ChouJiangJL RandomCopperJL(ref int groupID, int lv)
    {
        ChouJiangInfo jlInfo = RandomCopperGroup(lv);
        groupID = jlInfo.ID;
        return jlInfo.RandomJL();
    }

    /// <summary>
    /// 根据等级及货币类型筛选符合奖池索引列表
    /// </summary>
    /// <param name="LV"></param>
    /// <param name="huobi">1-铜币 2-金币 3-其他</param>
    /// <returns></returns>
    public List<int> GetLVDataInx(int LV, int huobi)
    {
        List<int> relist = new List<int>();
        switch (huobi)
        {
            case 1:
                {
                    foreach (int index in _CopperJLIDList)
                    {
                        if (LV >= Data[index].LV && LV <= Data[index].Lvmax)
                            relist.Add(index);
                    }
                }
                break;
            case 2:
                {
                    foreach (int index in _GoldJLIDList)
                    {
                        if (LV >= Data[index].LV && LV <= Data[index].Lvmax)
                            relist.Add(index);
                    }
                }
                break;
            default:
                {
                    foreach (int index in _ZhaomulingJLIDList)
                    {
                        if (LV >= Data[index].LV && LV <= Data[index].Lvmax)
                            relist.Add(index);
                    }
                }
                break;
        };
        //foreach (KeyValuePair<int, ChouJiangInfo> item in Data)
        //{
        //    if (item.Value.Huobi == huobi)
        //    {
        //        if (LV >= item.Value.LV && LV <= item.Value.Lvmax)
        //            relist.Add(item.Key);
        //    }
        //}
        return relist;
    }

    /// <summary>
    /// 根据等级筛选符合奖池列表
    /// </summary>
    /// <param name="LV"></param>
    /// <returns></returns>
    public Dictionary<int, ChouJiangInfo> GetLVData(ref Dictionary<int, ChouJiangInfo> relist, int LV, int[] canID, int huobi)
    {
        //foreach (KeyValuePair<int, ChouJiangInfo> item in Data)
        //{
        //    if (LV >= item.Value.LV && canID.Contains(item.Value.ID))
        //        relist.Add(item.Key, item.Value);
        //}
        switch (huobi)
        {
            case 1:
                {
                    foreach (int index in _CopperJLIDList)
                    {
                        if (LV >= Data[index].LV && LV <= Data[index].Lvmax && canID.Contains(Data[index].ID))
                            relist.Add(index, Data[index]);
                    }
                }
                break;
            case 2:
                {
                    foreach (int index in _GoldJLIDList)
                    {
                        if (LV >= Data[index].LV && LV <= Data[index].Lvmax && canID.Contains(Data[index].ID))
                            relist.Add(index, Data[index]);
                    }
                }
                break;
            default:
                {
                    foreach (int index in _ZhaomulingJLIDList)
                    {
                        if (LV >= Data[index].LV && LV <= Data[index].Lvmax && canID.Contains(Data[index].ID))
                            relist.Add(index, Data[index]);
                    }
                }
                break;
        };
        return relist;
    }

    #endregion
}

