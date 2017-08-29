using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_unittacticdata_c : MonoEX.Singleton<SData_unittacticdata_c>
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
            unittacticdata_cInfo dif = new unittacticdata_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "GeneralType": dif.GeneralType = (int)(double)o22; break;
					case "AntiSurface": dif.AntiSurface = (int)(double)o22; break;
					case "AntiAir": dif.AntiAir = (int)(double)o22; break;
					case "RaceGeneralType": dif.RaceGeneralType = (int)(double)o22; break;
					case "RaceAntiSurface": dif.RaceAntiSurface = (int)(double)o22; break;
					case "RaceAntiAir": dif.RaceAntiAir = (int)(double)o22; break;
					case "HideType": dif.HideType = (int)(double)o22; break;
					case "AntiHideSurface": dif.AntiHideSurface = (int)(double)o22; break;
					case "AntiHideAir": dif.AntiHideAir = (int)(double)o22; break;
					case "GroupType": dif.GroupType = (int)(double)o22; break;
					case "AntiGroupSurface": dif.AntiGroupSurface = (int)(double)o22; break;
					case "AntiGroupAir": dif.AntiGroupAir = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyID.ToString());
            Data.Add(dif.ArmyID, dif);
        });
    }

    public unittacticdata_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("unittacticdata_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, unittacticdata_cInfo> Data = new Dictionary<int, unittacticdata_cInfo>();
}


public struct unittacticdata_cInfo
{
	 /// <summary>
	 ///单位ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///空地类型
	 /// </summary>
	public int GeneralType;
	 /// <summary>
	 ///对地类型
	 /// </summary>
	public int AntiSurface;
	 /// <summary>
	 ///对空类性
	 /// </summary>
	public int AntiAir;
	 /// <summary>
	 ///种族和空地类型
	 /// </summary>
	public int RaceGeneralType;
	 /// <summary>
	 ///种族对地类型
	 /// </summary>
	public int RaceAntiSurface;
	 /// <summary>
	 ///种族对空类型
	 /// </summary>
	public int RaceAntiAir;
	 /// <summary>
	 ///隐形类型
	 /// </summary>
	public int HideType;
	 /// <summary>
	 ///对地反隐类型
	 /// </summary>
	public int AntiHideSurface;
	 /// <summary>
	 ///对空反隐类型
	 /// </summary>
	public int AntiHideAir;
	 /// <summary>
	 ///群体类型
	 /// </summary>
	public int GroupType;
	 /// <summary>
	 ///对地克制群体类型
	 /// </summary>
	public int AntiGroupSurface;
	 /// <summary>
	 ///对空克制群体类型
	 /// </summary>
	public int AntiGroupAir;
}
