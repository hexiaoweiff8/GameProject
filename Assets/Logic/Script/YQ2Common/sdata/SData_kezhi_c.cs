using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_kezhi_c : MonoEX.Singleton<SData_kezhi_c>
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
            kezhi_cInfo dif = new kezhi_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyType": dif.ArmyType = (short)(double)o22; break;
					case "KezhiType": dif.KezhiType = (short)(double)o22; break;
					case "BeikezhiType": dif.BeikezhiType = (short)(double)o22; break;
					case "KezhiAdd": dif.KezhiAdd = (float)(double)o22; break;
					case "ArmyTypeIcon": dif.ArmyTypeIcon = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyType))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyType.ToString());
            Data.Add(dif.ArmyType, dif);
        });
    }

    public kezhi_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("kezhi_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, kezhi_cInfo> Data = new Dictionary<int, kezhi_cInfo>();
}


public struct kezhi_cInfo
{
	 /// <summary>
	 ///攻击方大兵种类型
	 /// </summary>
	public short ArmyType;
	 /// <summary>
	 ///克制的大兵种类型
	 /// </summary>
	public short KezhiType;
	 /// <summary>
	 ///被克制的大兵种类型
	 /// </summary>
	public short BeikezhiType;
	 /// <summary>
	 ///克制加成数值
	 /// </summary>
	public float KezhiAdd;
	 /// <summary>
	 ///兵种的图标
	 /// </summary>
	public string ArmyTypeIcon;
}
