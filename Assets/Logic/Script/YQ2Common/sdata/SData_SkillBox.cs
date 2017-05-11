using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SkillBoxInfo
{
    const int TakeEffectCount = 5;
    internal static void FillFieldIndex(ITabReader reader)
    {
        ISkillBoxID = reader.ColumnName2Index("SkillBoxID");
        IIsLvUp = reader.ColumnName2Index("IsLvUp");
        IIsDiejia = reader.ColumnName2Index("IsDiejia");
        IDiejiaType = reader.ColumnName2Index("IsDiejia");
        IBoxDanwei = reader.ColumnName2Index("BoxDanwei");
        ISkillRangeID = reader.ColumnName2Index("SkillRangeID");
        IEndSkillTrigger = reader.ColumnName2Index("EndSkillTrigger");
        IStartSkillTrigger = reader.ColumnName2Index("StartSkillTrigger");

        ITakeEffects = new short[TakeEffectCount];
        for (int i = 0; i < TakeEffectCount; i++) ITakeEffects[i] = reader.ColumnName2Index("TakeEffect" + (i + 1).ToString());
        IDiaoyongAudioFx = reader.ColumnName2Index("DiaoyongAudioFx");
        IShengcunAudioFx = reader.ColumnName2Index("ShengcunAudioFx");
        ISiwangAudioFx = reader.ColumnName2Index("SiwangAudioFx");
       
        ISkillArriveID = reader.ColumnName2Index("SkillArriveID");
    }


    static List<int> tmpTakeEffects = new List<int>();
    public SkillBoxInfo(ITabReader reader, int row)
    {
        SkillBoxID = reader.GetI32(ISkillBoxID, row);
        SkillRangeID = reader.GetI32(ISkillRangeID, row);
        EndSkillTriggerID = reader.GetI32(IEndSkillTrigger, row);
        StartSkillTriggerID = reader.GetI32(IStartSkillTrigger, row);

        tmpTakeEffects.Clear();
        TakeEffects = new int[TakeEffectCount];
        for (int i = 0; i < TakeEffectCount; i++)
        {
            int effectID = reader.GetI32(ITakeEffects[i], row);
            if (effectID > 0) tmpTakeEffects.Add(effectID);
        }
        TakeEffects = tmpTakeEffects.ToArray();

        DiaoyongAudioFx = reader.GetI32(IDiaoyongAudioFx, row);
        ShengcunAudioFx = reader.GetI32(IShengcunAudioFx, row);
        SiwangAudioFx = reader.GetI32(ISiwangAudioFx, row);

        IsLvUp = (LvUpEnum)reader.GetI16(IIsLvUp, row);
        IsDiejia = reader.GetI16(IIsDiejia, row) == 1;
        DiejiaType = reader.GetI16(IDiejiaType, row);
        BoxDanwei = (BoxDanweiEnum)reader.GetI16(IBoxDanwei, row);
         
        SkillArriveID = reader.GetI32(ISkillArriveID, row);
    } 

    public void BuildLinks()
    {
        if (DiaoyongAudioFx > 0) DiaoyongAudioFxObj = SData_AudioFx.Single.Get(DiaoyongAudioFx);
        if (ShengcunAudioFx > 0) ShengcunAudioFxObj = SData_AudioFx.Single.Get(ShengcunAudioFx);
        if (SiwangAudioFx > 0) SiwangAudioFxObj = SData_AudioFx.Single.Get(SiwangAudioFx);

        int len = TakeEffects.Length;

        TakeEffectObjs = new SkillEffect[len];
        for (int i = 0; i < len; i++) TakeEffectObjs[i] = SData_Skill.Single.GetEffect(TakeEffects[i]);

        if (EndSkillTriggerID > 0) EndSkillTrigger = SData_SkillTrigger.Single.Get(EndSkillTriggerID);
        if (StartSkillTriggerID > 0) StartSkillTrigger = SData_SkillTrigger.Single.Get(StartSkillTriggerID);
 
        SkillRange = SData_SkillRange.Single.Get(SkillRangeID);

        SkillArriveObj = SData_SkillArrive.Single.Get(SkillArriveID); 
    }

    public readonly int SkillBoxID;
    readonly int SkillRangeID;
    public SkillRangeInfo SkillRange;
     

    public readonly int EndSkillTriggerID;
    public readonly int StartSkillTriggerID;

    readonly int SkillArriveID;
    public SkillArriveInfo SkillArriveObj;


    public SkillTriggerInfo EndSkillTrigger;
    public SkillTriggerInfo StartSkillTrigger;

    public readonly int DiaoyongAudioFx;
    public readonly int ShengcunAudioFx;
    public readonly int SiwangAudioFx;
    public readonly int[] TakeEffects;




    public SkillEffect[] TakeEffectObjs;
    public AudioFxInfo DiaoyongAudioFxObj;
    public AudioFxInfo ShengcunAudioFxObj;
    public AudioFxInfo SiwangAudioFxObj;

    public readonly LvUpEnum IsLvUp;
    public readonly bool IsDiejia;
    public readonly short DiejiaType;
    public readonly BoxDanweiEnum BoxDanwei;

    internal static short ISkillBoxID;
    internal static short IIsLvUp;
    internal static short IIsDiejia;
    internal static short IDiejiaType;
    internal static short IBoxDanwei;
    internal static short ISkillRangeID;
    internal static short IEndSkillTrigger;
    internal static short IStartSkillTrigger;
    internal static short[] ITakeEffects;
    internal static short IDiaoyongAudioFx;
    internal static short IShengcunAudioFx;
    internal static short ISiwangAudioFx;

    
    internal static short ISkillArriveID;

   
}

public enum LvUpEnum
{
    None = 0,//不升级
    JieshuTiaojian = 1,//结束条件升级
    ChufaTiaojian = 2,//触发条件升级
}

public enum BoxDanweiEnum
{
    None = 0,
    None1 = -1,
    Hero = 1,//武将
    Grid = 2,//逻辑格子
}

public class SData_SkillBox : MonoEX.Singleton<SData_SkillBox>
{
    public SData_SkillBox()
    {

        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SkillBox");
            reader.Load("bsv", "SkillBox");
            SkillBoxInfo.FillFieldIndex(reader);
            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                var sa = new SkillBoxInfo(reader, row);
                if (Data.ContainsKey(sa.SkillBoxID))
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + sa.SkillBoxID.ToString());
                Data.Add(sa.SkillBoxID, sa);
            }
        }
    }

    public SkillBoxInfo Get(int id)
    {
        try
        {
            return Data[id];
        }
        catch (Exception)
        {
            throw new Exception(String.Format("SData_SkillBox Get ID:{0}", id));
        }
    }

    public void BuildLinks()
    {
        foreach (var kv in Data) kv.Value.BuildLinks();
    }


    Dictionary<int, SkillBoxInfo> Data = new Dictionary<int, SkillBoxInfo>();
}