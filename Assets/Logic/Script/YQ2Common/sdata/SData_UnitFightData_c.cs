using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_UnitFightData_c : MonoEX.Singleton<SData_UnitFightData_c>
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
            UnitFightData_cInfo dif = new UnitFightData_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "CostPerUnit": dif.CostPerUnit = (short)(double)o22; break;
					case "ArmyType": dif.ArmyType = (short)(double)o22; break;
					case "GeneralType": dif.GeneralType = (short)(double)o22; break;
					case "AntiAir": dif.AntiAir = (short)(double)o22; break;
					case "AntiSurface": dif.AntiSurface = (short)(double)o22; break;
					case "Hide": dif.Hide = (short)(double)o22; break;
					case "AntiHide": dif.AntiHide = (short)(double)o22; break;
					case "Group": dif.Group = (short)(double)o22; break;
					case "AntiGroup": dif.AntiGroup = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyID.ToString());
            Data.Add(dif.ArmyID, dif);
        });
    }

    public UnitFightData_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("UnitFightData_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, UnitFightData_cInfo> Data = new Dictionary<int, UnitFightData_cInfo>();
}


public struct UnitFightData_cInfo
{
	 /// <summary>
	 ///兵种ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///单位费用
	 /// </summary>
	public short CostPerUnit;
	 /// <summary>
	 ///自身种族
	 /// </summary>
	public short ArmyType;
	 /// <summary>
	 ///自身空地
	 /// </summary>
	public short GeneralType;
	 /// <summary>
	 ///是否为对空类
	 /// </summary>
	public short AntiAir;
	 /// <summary>
	 ///是否为对地类
	 /// </summary>
	public short AntiSurface;
	 /// <summary>
	 ///是否为隐形类
	 /// </summary>
	public short Hide;
	 /// <summary>
	 ///是否为反隐类
	 /// </summary>
	public short AntiHide;
	 /// <summary>
	 ///是否为群体类
	 /// </summary>
	public short Group;
	 /// <summary>
	 ///是否为克制群体类
	 /// </summary>
	public short AntiGroup;
}
