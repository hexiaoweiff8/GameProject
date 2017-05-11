using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_KeyValueMath : MonoEX.Singleton<SData_KeyValueMath>
{

    public SData_KeyValueMath()
    {
        try
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 KeyValueMath");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "KeyValueMath");

                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    LevelInfo sa = new LevelInfo(reader, row);
                    Data.Add(sa.Number, sa);
                    if (sa.Number > _MaxLv) _MaxLv = sa.Number;
                    _UpExp.Add(sa.Number, sa.Exp);
                }
            }
        }
        catch (System.Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "KeyValueMath初始化失败");
            throw ex;
        }
    }

    /// <summary>
    /// 获取升级相关消耗数据
    /// </summary>
    /// <param name="number"></param>
    /// <returns></returns>
    public LevelInfo Get(int number)
    {
        if (!Data.ContainsKey(number))
            number = _MaxLv;
        return Data[number];
    }

    /// <summary>
    /// 根据经验计算等级
    /// </summary>
    /// <param name="exp"></param>
    /// <returns></returns>
    public int reCalculateLV(int exp)
    {
        int reLV = 0;
        foreach(KeyValuePair<int,int> curr in _UpExp)
        {
            if (exp >= curr.Value)
            {
                reLV = curr.Key;
            }
            else
                break;
        }
        return reLV;
    }

    /// <summary>
    /// 返回升下一级所需经验值
    /// </summary>
    /// <param name="lv"></param>
    /// <returns></returns>
    public int getUpExp(int lv)
    {
        if (_UpExp.ContainsKey(lv))
            return _UpExp[lv];

        return 0;
    }

    public int MaxLV { get { return _MaxLv; } }

    int _MaxLv = 0;
    Dictionary<int, LevelInfo> Data = new Dictionary<int, LevelInfo>();
    ////升下一级所需经验 <当前等级,升级所需经验>
    //Dictionary<int, int> _UpExp = new Dictionary<int, int>();

    //角色升下一级所需经验 <当前等级,升级所需经验>
    Dictionary<int, int> _UpExp = new Dictionary<int, int>();
}

public class LevelInfo
{


    public LevelInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        SkillLvup = reader.GetI32(ISkillLvup, row);
        ShoudongSkillLvUp = reader.GetI32(IShoudongSkillLvUp, row);
        Exp = reader.GetI32(IExp, row);
        Number = reader.GetI16(INumber, row);
        KakuMax = reader.GetI16(IKakuMax, row);
        ArmyNo = reader.GetI16(IArmyNo, row);
        LingGoldPrice = reader.GetI16(ILingGoldPrice, row);
        Zenyuan = reader.GetI16(IZenyuan, row);
    }


    internal static void FillFieldIndex(ITabReader reader)
    {
        IExp = reader.ColumnName2Index("EXP");
        ISkillLvup = reader.ColumnName2Index("SkillLvUp");
        IShoudongSkillLvUp = reader.ColumnName2Index("ShoudongSkillLvUp");
        INumber = reader.ColumnName2Index("Number");
        IKakuMax = reader.ColumnName2Index("KakuMax");
        ILingGoldPrice = reader.ColumnName2Index("LingGoldPrice");
        IArmyNo = reader.ColumnName2Index("ArmyNo");
        IZenyuan = reader.ColumnName2Index("Zenyuan");
    }

    #region(属性)
    public readonly int SkillLvup = 9999999;
    public readonly int ShoudongSkillLvUp = 9999999;
    public readonly int Exp = 9999999;
    public readonly int Number = 0;
    public readonly int KakuMax = 10;
    public readonly int LingGoldPrice = 0;
    public readonly int ArmyNo = 0;
    public readonly int Zenyuan = 0;
    
    

    /**索引属性**/
    internal static short IExp;
    internal static short ISkillLvup;
    internal static short IShoudongSkillLvUp;
    internal static short INumber;
    internal static short IKakuMax;
    internal static short ILingGoldPrice;
    internal static short IArmyNo;
    internal static short IZenyuan;
    
    

    #endregion

}



