using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_Equip_data : MonoEX.Singleton<SData_Equip_data>
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
            Equip_dataInfo dif = new Equip_dataInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "EquipID": dif.EquipID = (int)(double)o22; break;
					case "EquipName": dif.EquipName = (string)o22; break;
					case "EquipResName": dif.EquipResName = (string)o22; break;
					case "EquipType": dif.EquipType = (short)(double)o22; break;
					case "SuitID": dif.SuitID = (short)(double)o22; break;
					case "MainEffect": dif.MainEffect = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.EquipID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.EquipID.ToString());
            Data.Add(dif.EquipID, dif);
        });
    }

    public Equip_dataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("Equip_dataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, Equip_dataInfo> Data = new Dictionary<int, Equip_dataInfo>();
}


public struct Equip_dataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public int EquipID;
	 /// <summary>
	 ///
	 /// </summary>
	public string EquipName;
	 /// <summary>
	 ///
	 /// </summary>
	public string EquipResName;
	 /// <summary>
	 ///
	 /// </summary>
	public short EquipType;
	 /// <summary>
	 ///
	 /// </summary>
	public short SuitID;
	 /// <summary>
	 ///
	 /// </summary>
	public int MainEffect;
}
