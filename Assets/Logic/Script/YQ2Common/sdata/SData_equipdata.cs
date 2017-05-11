using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using YQ2Common.CObjects;
public enum EquipType
{
    Wuju = 1,//武具
    Hujia = 2,//护甲
}

/// <summary>
/// 洗练加成属性
/// </summary>
public enum EquipAddAttrType
{
    HP = 1,
    WL = 2,
    TL = 3,
    NU = 4,
}

public class EquipDataInfo
{
    internal static short IID;
    internal static short IName;
    internal static short IRequireLv;
    internal static short IType;
    internal static short IIcon;
    internal static short IDescription;
    internal static short IZhandouli;
    internal static short IHP;
    internal static short IWuli;
    internal static short ITili;
    internal static short INu;
    internal static short IXilian;
    internal static short IRecycle;
    internal static short IXilianRecycle;
    internal static short IXilianshuxingName1;
    internal static short IXilianShuxing1;
    internal static short IXilianShuxingNum1;
    internal static short IXilianShuxingQuanzhong1;
    internal static short IXilianshuxingName1B;//
    internal static short IXilianShuxing1B;//
    internal static short IXilianShuxingNum1B;//
    internal static short IXilianShuxingQuanzhong1B;//
    internal static short IXilianshuxingName2;
    internal static short IXilianShuxing2A;
    internal static short IXilianShuxingNum2A;
    internal static short IXilianShuxing2B;
    internal static short IXilianShuxingNum2B;
    internal static short IXilianShuxingQuanzhong2;
    internal static short IXilianSkillName3;
    internal static short IXilianSkill3;
    internal static short IXilianSkillQuanzhong3;
    internal static short IWeixilianDiwen;
    internal static short[] IXilianDiwen = new short[XilianLen];


    public const short XilianLen = 3;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        IRequireLv = reader.ColumnName2Index("RequireLv");
        IType = reader.ColumnName2Index("Type");
        IIcon = reader.ColumnName2Index("Icon");
        IDescription = reader.ColumnName2Index("Description");
        IZhandouli = reader.ColumnName2Index("Zhandouli");
        IHP = reader.ColumnName2Index("HP");
        IWuli = reader.ColumnName2Index("Wuli");
        ITili = reader.ColumnName2Index("Tili");
        INu = reader.ColumnName2Index("Nu");
        IXilian = reader.ColumnName2Index("Xilian");
        IRecycle = reader.ColumnName2Index("Recycle");
        IXilianRecycle = reader.ColumnName2Index("XilianRecycle");
        IXilianshuxingName1 = reader.ColumnName2Index("XilianshuxingName1");
        IXilianShuxing1 = reader.ColumnName2Index("XilianShuxing1");
        IXilianShuxingNum1 = reader.ColumnName2Index("XilianShuxingNum1");
        IXilianShuxingQuanzhong1 = reader.ColumnName2Index("XilianShuxingQuanzhong1");
        IXilianshuxingName1B = reader.ColumnName2Index("XilianshuxingName1B");
        IXilianShuxing1B = reader.ColumnName2Index("XilianShuxing1B");
        IXilianShuxingNum1B = reader.ColumnName2Index("XilianShuxingNum1B");
        IXilianShuxingQuanzhong1B = reader.ColumnName2Index("XilianShuxingQuanzhong1B");
        IXilianshuxingName2 = reader.ColumnName2Index("XilianshuxingName2");
        IXilianShuxing2A = reader.ColumnName2Index("XilianShuxing2A");
        IXilianShuxingNum2A = reader.ColumnName2Index("XilianShuxingNum2A");
        IXilianShuxing2B = reader.ColumnName2Index("XilianShuxing2B");
        IXilianShuxingNum2B = reader.ColumnName2Index("XilianShuxingNum2B");
        IXilianShuxingQuanzhong2 = reader.ColumnName2Index("XilianShuxingQuanzhong2");
        IXilianSkillName3 = reader.ColumnName2Index("XilianSkillName3");
        IXilianSkill3 = reader.ColumnName2Index("XilianSkill3");
        IXilianSkillQuanzhong3 = reader.ColumnName2Index("XilianSkillQuanzhong3");

        for (var i = 0; i < XilianLen; i++)
        {
            string istr = (i + 1).ToString();
            IXilianDiwen[i] = reader.ColumnName2Index("XilianDiwen" + istr);
        }
        IWeixilianDiwen = reader.ColumnName2Index("WeixilianDiwen");
    }


    public EquipDataInfo(ITabReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        Name = reader.GetS(IName, row);
        RequireLv = reader.GetI16(IRequireLv, row);
        Type = (EquipType)reader.GetI16(IType, row);
        Icon = reader.GetS(IIcon, row);
        Description = reader.GetS(IDescription, row);
        Zhandouli = reader.GetI32(IZhandouli, row);
        HP = reader.GetI32(IHP, row);
        Wuli = reader.GetI32(IWuli, row);
        Tili = reader.GetI32(ITili, row);
        Nu = reader.GetI32(INu, row);
        Xilian = reader.GetI32(IXilian, row);
        Recycle = reader.GetI32(IRecycle, row);
        XilianRecycle = reader.GetI32(IXilianRecycle, row);
        XilianshuxingName1 = reader.GetS(IXilianshuxingName1, row);
        XilianShuxing1 = reader.GetI16(IXilianShuxing1, row);
        XilianShuxingNum1 = reader.GetI32(IXilianShuxingNum1, row);
        XilianShuxingQuanzhong1 = reader.GetI32(IXilianShuxingQuanzhong1, row);
        XilianshuxingName1B = reader.GetS(IXilianshuxingName1B, row);
        XilianShuxing1B = reader.GetI16(IXilianShuxing1B, row);
        XilianShuxingNum1B = reader.GetI32(IXilianShuxingNum1B, row);
        XilianShuxingQuanzhong1B = reader.GetI16(IXilianShuxingQuanzhong1B, row);
        XilianshuxingName2 = reader.GetS(IXilianshuxingName2, row);
        XilianShuxing2A = reader.GetI16(IXilianShuxing2A, row);
        XilianShuxingNum2A = reader.GetI32(IXilianShuxingNum2A, row);
        XilianShuxing2B = reader.GetI16(IXilianShuxing2B, row);
        XilianShuxingNum2B = reader.GetI32(IXilianShuxingNum2B, row);
        XilianShuxingQuanzhong2 = reader.GetI16(IXilianShuxingQuanzhong2, row);
        XilianSkillName3 = reader.GetS(IXilianSkillName3, row);
        XilianSkill3 = reader.GetI32(IXilianSkill3, row);
        XilianSkillQuanzhong3 = reader.GetI16(IXilianSkillQuanzhong3, row);

        XilianDiwen = new string[XilianLen];
        for (var i = 0; i < XilianLen; i++)
        {
            XilianDiwen[i] = reader.GetS(IXilianDiwen[i], row);
        }
        WeixilianDiwen = reader.GetS(IWeixilianDiwen, row);

        Quanzhong1 = XilianShuxingQuanzhong1 + XilianShuxingQuanzhong1B;
        sumQuanzhong = Quanzhong1 + XilianShuxingQuanzhong2 + XilianSkillQuanzhong3;//总权重
    }

    public readonly int ID;
    public readonly string Name;
    public readonly short RequireLv;
    public readonly EquipType Type;
    public readonly string Icon;
    public readonly string Description;
    public readonly int Zhandouli;
    public readonly int HP;
    public readonly int Wuli;
    public readonly int Tili;
    public readonly int Nu;
    public readonly int Xilian;
    public readonly int Recycle;
    public readonly int XilianRecycle;
    public readonly string XilianshuxingName1;
    public readonly short XilianShuxing1;
    public readonly int XilianShuxingNum1;
    public readonly int XilianShuxingQuanzhong1;
    public readonly string XilianshuxingName1B;//
    public readonly short XilianShuxing1B;//
    public readonly int XilianShuxingNum1B;//
    public readonly short XilianShuxingQuanzhong1B;//
    public readonly string XilianshuxingName2;
    public readonly short XilianShuxing2A;
    public readonly int XilianShuxingNum2A;
    public readonly short XilianShuxing2B;
    public readonly int XilianShuxingNum2B;
    public readonly short XilianShuxingQuanzhong2;
    public readonly string XilianSkillName3;
    public readonly int XilianSkill3;
    public readonly short XilianSkillQuanzhong3;
    public readonly string[] XilianDiwen;
    public readonly string WeixilianDiwen;

    public readonly int sumQuanzhong = 0;//总权重
    public readonly int Quanzhong1 = 0;//1号总权重

    /// <summary>
    /// 依据权重选出洗练属性
    /// </summary>
    /// <returns></returns>
    public int RandomXiLian(int currSkill = 0)
    {
        int currSumQZ = 0;
        switch (currSkill)
        {
            case 11:
            case 12:
                currSumQZ = sumQuanzhong - Quanzhong1;
                break;
            case 2:
                currSumQZ = sumQuanzhong - XilianShuxingQuanzhong2;
                break;
            case 3:
                currSumQZ = sumQuanzhong - XilianSkillQuanzhong3;
                break;
        }
        int qz = SData_KeyValue.Single.RandomInt(0, currSumQZ - 1);
        for (int i = 1; i <= 3; i++)
        {
            if (i == 1)
            {
                if (currSkill != 11 && currSkill != 12)
                {
                    if (qz < Quanzhong1)
                    {
                        int qz1 = SData_KeyValue.Single.RandomInt(0, currSumQZ - 1);
                        if (qz1 < XilianShuxingQuanzhong1)
                            return 11;
                        else
                            return 12;
                    }
                    else
                        qz -= Quanzhong1;
                }
            }
            if (i == 2 && i != currSkill)
            {
                if (qz < XilianShuxingQuanzhong2) return i;
                else
                    qz -= XilianShuxingQuanzhong2;
            }
            if (i == 3 && i != currSkill)
            {
                if (qz < XilianSkillQuanzhong3) return i;
                else
                    qz -= XilianSkillQuanzhong3;
            }
        }
        return 11;
    }

    /// <summary>
    /// 计算血量
    /// </summary>
    /// <param name="level"></param>
    /// <param name="currSkill"></param>
    /// <returns></returns>
    public int CalculationHP(int currSkill)
    {
        int addNum = 0;
        XiLiAddType(ref addAttr, currSkill);
        if (addAttr.ContainsKey(EquipAddAttrType.HP))
            addNum = addAttr[EquipAddAttrType.HP];
        var jichu = HP + addNum;
        return (int)jichu;
    }
    /// <summary>
    /// 计算武力
    /// </summary>
    /// <param name="level"></param>
    /// <param name="currSkill"></param>
    /// <returns></returns>
    public int CalculationWL(int currSkill)
    {
        int addNum = 0;
        XiLiAddType(ref addAttr, currSkill);
        if (addAttr.ContainsKey(EquipAddAttrType.WL))
            addNum = addAttr[EquipAddAttrType.WL];
        var jichu = Wuli + addNum;
        return (int)jichu;
    }

    /// <summary>
    /// 计算体力
    /// </summary>
    /// <param name="level"></param>
    /// <param name="currSkill"></param>
    /// <returns></returns>
    public int CalculationTL(int currSkill)
    {
        int addNum = 0;
        XiLiAddType(ref addAttr, currSkill);
        if (addAttr.ContainsKey(EquipAddAttrType.TL))
            addNum = addAttr[EquipAddAttrType.TL];
        var jichu = Tili + addNum;
        return (int)jichu;
    }
    /// <summary>
    /// 计算怒气
    /// </summary>
    /// <param name="level"></param>
    /// <param name="currSkill"></param>
    /// <returns></returns>
    public int CalculationNU(int currSkill)
    {
        int addNum = 0;
        XiLiAddType(ref addAttr, currSkill);
        if (addAttr.ContainsKey(EquipAddAttrType.NU))
            addNum = addAttr[EquipAddAttrType.NU];
        var jichu = Nu + addNum;
        return (int)jichu;
    }


    /// <summary>
    /// 计算洗练属性加成
    /// </summary>
    /// <param name="addAttr"></param>
    /// <param name="currSkill"></param>
    /// <returns></returns>
    public void XiLiAddType(ref Dictionary<EquipAddAttrType, int> addAttr, int currSkill)
    {
        if (currSkill == 0)
            return;
        switch (currSkill)
        {
            case 11://洗练出1
                if (!addAttr.ContainsKey((EquipAddAttrType)XilianShuxing1))
                    addAttr.Add((EquipAddAttrType)XilianShuxing1, XilianShuxingNum1);
                break;
            case 12://洗练出1B
                if (!addAttr.ContainsKey((EquipAddAttrType)XilianShuxing1B))
                    addAttr.Add((EquipAddAttrType)XilianShuxing1B, XilianShuxingNum1B);
                break;
            case 2://洗练出2
                if (!addAttr.ContainsKey((EquipAddAttrType)XilianShuxing2A))
                    addAttr.Add((EquipAddAttrType)XilianShuxing2A, XilianShuxingNum2A);
                if (!addAttr.ContainsKey((EquipAddAttrType)XilianShuxing2B))
                    addAttr.Add((EquipAddAttrType)XilianShuxing2B, XilianShuxingNum2B);
                break;
            case 3://洗练出3
                Skill skillattr = SData_Skill.Single.Get(XilianSkill3);
                if (skillattr != null)
                {
                    foreach (SkillEffect currE in skillattr.TakeEffects)
                    {
                        if (currE.EffectType == SkillEffectType.EditAttr)
                        {
                            switch (currE.ShuxingType)
                            {
                                case SkillDVType.hpmap:
                                case SkillDVType.currhp:
                                    {
                                        switch (currE.HitType)
                                        {
                                            case SkillHitType.Jia:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.HP))
                                                    addAttr.Add(EquipAddAttrType.HP, (int)currE.HitNo);
                                                break;
                                            case SkillHitType.JiaBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.HP))
                                                    addAttr.Add(EquipAddAttrType.HP, (int)((1 + currE.HitNo) * HP));
                                                break;
                                            case SkillHitType.Jian:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.HP))
                                                    addAttr.Add(EquipAddAttrType.HP, -(int)currE.HitNo);
                                                break;
                                            case SkillHitType.JianBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.HP))
                                                    addAttr.Add(EquipAddAttrType.HP, -(int)((1 + currE.HitNo) * HP));
                                                break;
                                        }
                                    }
                                    break;
                                case SkillDVType.wl:
                                    {
                                        switch (currE.HitType)
                                        {
                                            case SkillHitType.Jia:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.WL))
                                                    addAttr.Add(EquipAddAttrType.WL, (int)currE.HitNo);
                                                break;
                                            case SkillHitType.JiaBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.WL))
                                                    addAttr.Add(EquipAddAttrType.WL, (int)((1 + currE.HitNo) * Wuli));
                                                break;
                                            case SkillHitType.Jian:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.WL))
                                                    addAttr.Add(EquipAddAttrType.WL, -(int)currE.HitNo);
                                                break;
                                            case SkillHitType.JianBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.WL))
                                                    addAttr.Add(EquipAddAttrType.WL, -(int)((1 + currE.HitNo) * Wuli));
                                                break;
                                        }
                                    }
                                    break;
                                case SkillDVType.tl:
                                    {
                                        switch (currE.HitType)
                                        {
                                            case SkillHitType.Jia:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.TL))
                                                    addAttr.Add(EquipAddAttrType.TL, (int)currE.HitNo);
                                                break;
                                            case SkillHitType.JiaBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.TL))
                                                    addAttr.Add(EquipAddAttrType.TL, (int)((1 + currE.HitNo) * Tili));
                                                break;
                                            case SkillHitType.Jian:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.TL))
                                                    addAttr.Add(EquipAddAttrType.TL, -(int)currE.HitNo);
                                                break;
                                            case SkillHitType.JianBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.TL))
                                                    addAttr.Add(EquipAddAttrType.TL, -(int)((1 + currE.HitNo) * Tili));
                                                break;
                                        }
                                    }
                                    break;
                                case SkillDVType.nu:
                                    {
                                        switch (currE.HitType)
                                        {
                                            case SkillHitType.Jia:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.NU))
                                                    addAttr.Add(EquipAddAttrType.NU, (int)currE.HitNo);
                                                break;
                                            case SkillHitType.JiaBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.NU))
                                                    addAttr.Add(EquipAddAttrType.NU, (int)((1 + currE.HitNo) * Nu));
                                                break;
                                            case SkillHitType.Jian:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.NU))
                                                    addAttr.Add(EquipAddAttrType.NU, -(int)currE.HitNo);
                                                break;
                                            case SkillHitType.JianBfb:
                                                if (!addAttr.ContainsKey(EquipAddAttrType.NU))
                                                    addAttr.Add(EquipAddAttrType.NU, -(int)((1 + currE.HitNo) * Nu));
                                                break;
                                        }
                                    }
                                    break;
                            }
                        }
                    }
                }
                break;
        }
    }

    /// <summary>
    /// 清除当次属性加成
    /// </summary>
    public void CleanAttrList()
    {
        addAttr.Clear();
    }

    //洗练属性加成
   Dictionary<EquipAddAttrType, int> addAttr = new Dictionary<EquipAddAttrType, int>();

}

public class SData_EquipData : MonoEX.Singleton<SData_EquipData>
{
    public SData_EquipData()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 EquipData");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "EquipData");
            EquipDataInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                EquipDataInfo sa = new EquipDataInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 EquipData完毕");
    }

    public EquipDataInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    public List<int> GetAllEquipList()
    {
        List<int> relist = new List<int>();
        foreach(KeyValuePair<int,EquipDataInfo> curr in Data)
        {
            relist.Add(curr.Key);
        }
        return relist;
    }

    Dictionary<int, EquipDataInfo> Data = new Dictionary<int, EquipDataInfo>();
}
