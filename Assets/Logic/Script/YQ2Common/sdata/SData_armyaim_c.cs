using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armyaim_c : MonoEX.Singleton<SData_armyaim_c>
{
    public void setData(LuaTable table1, LuaTable table2)
    {
        var head = new string[table1.Length];
        SDataUtils.dealTable(table1, (Object o1, Object o2) =>
        {
            head[(int)(double)o1 - 1] = (string)o2;
        });
        SDataUtils.dealTable(table2, (Object o1, Object o2) =>
        {
            armyaim_cInfo dif = new armyaim_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "Camp": dif.Camp = (short)(double)o22; break;
					case "CampType": dif.CampType = (short)(double)o22; break;
					case "Surface": dif.Surface = (short)(double)o22; break;
					case "SurfaceType": dif.SurfaceType = (short)(double)o22; break;
					case "Air": dif.Air = (short)(double)o22; break;
					case "AirType": dif.AirType = (short)(double)o22; break;
					case "Build": dif.Build = (short)(double)o22; break;
					case "BuildType": dif.BuildType = (short)(double)o22; break;
					case "Human": dif.Human = (short)(double)o22; break;
					case "HumanType": dif.HumanType = (short)(double)o22; break;
					case "Orc": dif.Orc = (short)(double)o22; break;
					case "OrcType": dif.OrcType = (short)(double)o22; break;
					case "Omnic": dif.Omnic = (short)(double)o22; break;
					case "OmnicType": dif.OmnicType = (short)(double)o22; break;
					case "Hide": dif.Hide = (short)(double)o22; break;
					case "HideType": dif.HideType = (short)(double)o22; break;
					case "Taunt": dif.Taunt = (short)(double)o22; break;
					case "TauntType": dif.TauntType = (short)(double)o22; break;
					case "RangeMin": dif.RangeMin = (short)(double)o22; break;
					case "RangeMinType": dif.RangeMinType = (short)(double)o22; break;
					case "RangeMax": dif.RangeMax = (short)(double)o22; break;
					case "RangeMaxType": dif.RangeMaxType = (short)(double)o22; break;
					case "HealthMin": dif.HealthMin = (short)(double)o22; break;
					case "HealthMinType": dif.HealthMinType = (short)(double)o22; break;
					case "HealthMax": dif.HealthMax = (short)(double)o22; break;
					case "HealthMaxType": dif.HealthMaxType = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyID.ToString());
            Data.Add(dif.ArmyID, dif);
        });
    }

    public armyaim_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armyaim_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armyaim_cInfo> Data = new Dictionary<int, armyaim_cInfo>();
}


public struct armyaim_cInfo
{
	 /// <summary>
	 ///兵种ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///阵营筛选
	 /// </summary>
	public short Camp;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short CampType;
	 /// <summary>
	 ///对地权重
	 /// </summary>
	public short Surface;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short SurfaceType;
	 /// <summary>
	 ///对空权重
	 /// </summary>
	public short Air;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short AirType;
	 /// <summary>
	 ///对建筑权重
	 /// </summary>
	public short Build;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short BuildType;
	 /// <summary>
	 ///人类
	 /// </summary>
	public short Human;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short HumanType;
	 /// <summary>
	 ///兽人
	 /// </summary>
	public short Orc;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short OrcType;
	 /// <summary>
	 ///智械
	 /// </summary>
	public short Omnic;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short OmnicType;
	 /// <summary>
	 ///隐身
	 /// </summary>
	public short Hide;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short HideType;
	 /// <summary>
	 ///嘲讽
	 /// </summary>
	public short Taunt;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short TauntType;
	 /// <summary>
	 ///距离最近
	 /// </summary>
	public short RangeMin;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short RangeMinType;
	 /// <summary>
	 ///距离最远
	 /// </summary>
	public short RangeMax;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short RangeMaxType;
	 /// <summary>
	 ///生命最小
	 /// </summary>
	public short HealthMin;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short HealthMinType;
	 /// <summary>
	 ///生命最高
	 /// </summary>
	public short HealthMax;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short HealthMaxType;
}
