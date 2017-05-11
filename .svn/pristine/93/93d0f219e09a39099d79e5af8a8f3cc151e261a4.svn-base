
using System.Collections.Generic;

public class SoldierInfo
{
    //------------------------士兵属性字段索引---------------------------------
    internal static short IndexArmyID;
    internal static short IndexName;
    internal static short IndexAttack;
    internal static short IndexClipsize;
    internal static short IndexAttackRate;
    internal static short IndexReloadTime;
    internal static short IndexHP;
    internal static short IndexArmor;
    internal static short IndexAntiArmor;
    internal static short IndexAntiCrit;
    internal static short IndexCrit;
    internal static short IndexDodge;
    internal static short IndexHit;
    internal static short IndexAttackRange;
    internal static short IndexMoveSpeed;

    //---------------------------士兵属性--------------------------------------
    public readonly int _ArmyID;
    public readonly string _Name;
    public readonly int _Attack;
    public readonly int _Clipsize;
    public readonly int _AttackRate;
    public readonly int _ReloadTime;
    public readonly int _HP;
    public readonly int _Armor;
    public readonly int _AntiArmor;
    public readonly int _AntiCrit;
    public readonly int _Crit;
    public readonly int _Dodge;
    public readonly int _Hit;
    public readonly int _AttackRange;
    public readonly int _MoveSpeed;

    public int ArmyID { get { return _ArmyID; } }

    internal SoldierInfo(ITabReader reader, int row)
    {
        _ArmyID = reader.GetI32(IndexArmyID, row);
        _Name = reader.GetS(IndexName, row);
        _Attack = reader.GetI32(IndexAttack, row);
        _Clipsize = reader.GetI32(IndexClipsize, row);
        _AttackRate = reader.GetI32(IndexAttackRate, row);
        _HP = reader.GetI32(IndexHP, row);
        _Armor = reader.GetI32(IndexArmor, row);
        _AntiArmor = reader.GetI32(IndexAntiArmor, row);
        _AntiCrit = reader.GetI32(IndexAntiCrit, row);
        _Crit = reader.GetI32(IndexCrit, row);
        _Dodge = reader.GetI32(IndexDodge, row);
        _Hit = reader.GetI32(IndexHit, row);
        _AttackRange = reader.GetI32(IndexAttackRange, row);
        _MoveSpeed = reader.GetI32(IndexMoveSpeed, row);

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IndexArmyID = reader.ColumnName2Index("_ArmyID");
        IndexName = reader.ColumnName2Index("_Name");
        IndexAttack = reader.ColumnName2Index("_Attack");
        IndexClipsize = reader.ColumnName2Index("_Clipsize");
        IndexAttackRate = reader.ColumnName2Index("_AttackRate");
        IndexReloadTime = reader.ColumnName2Index("_ReloadTime");
        IndexHP = reader.ColumnName2Index("_HP");
        IndexArmor = reader.ColumnName2Index("_Armor");
        IndexAntiArmor = reader.ColumnName2Index("_AntiArmor");
        IndexAntiCrit = reader.ColumnName2Index("_AntiCrit");
        IndexCrit = reader.ColumnName2Index("_Crit");
        IndexDodge = reader.ColumnName2Index("_Dodge");
        IndexHit = reader.ColumnName2Index("_Hit");
        IndexAttackRange = reader.ColumnName2Index("_AttackRange");
        IndexMoveSpeed = reader.ColumnName2Index("_MoveSpeed");
    }
    
    public void BuildLinks()
    {

    }
}
public class Sdata_Soldiers : MonoEX.Singleton<Sdata_Soldiers>
{
    public readonly int ID;
    public readonly string Name;
    internal Dictionary<int, SoldierInfo> Data = new Dictionary<int, SoldierInfo>();

    public Sdata_Soldiers()
    {

        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SoldierData");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "SoldierData");

            SoldierInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                SoldierInfo sa = new SoldierInfo(reader, row);
                if (Data.ContainsKey(sa.ArmyID))
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + sa.ArmyID.ToString());
                Data.Add(sa.ArmyID, sa);
            }
        }
    }

    public void BuildLinks()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "HeroData 开始建立对象关联");

        foreach (var kv in Data) kv.Value.BuildLinks();
    }
}
