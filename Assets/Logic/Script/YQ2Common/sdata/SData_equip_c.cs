using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_equip_c : MonoEX.Singleton<SData_equip_c>
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
            equip_cInfo dif = new equip_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "EquipID": dif.EquipID = (int)(double)o22; break;
					case "EquipName": dif.EquipName = (string)o22; break;
					case "EquipIcon": dif.EquipIcon = (string)o22; break;
					case "EquipType": dif.EquipType = (short)(double)o22; break;
					case "SuitID": dif.SuitID = (short)(double)o22; break;
					case "MainAttribute": dif.MainAttribute = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.EquipID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.EquipID.ToString());
            Data.Add(dif.EquipID, dif);
        });
    }

    public equip_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("equip_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, equip_cInfo> Data = new Dictionary<int, equip_cInfo>();
}


public struct equip_cInfo
{
	 /// <summary>
	 ///装备ID
	 /// </summary>
	public int EquipID;
	 /// <summary>
	 ///装备名称
	 /// </summary>
	public string EquipName;
	 /// <summary>
	 ///装备图标
	 /// </summary>
	public string EquipIcon;
	 /// <summary>
	 ///装备类型
	 /// </summary>
	public short EquipType;
	 /// <summary>
	 ///套装ID
	 /// </summary>
	public short SuitID;
	 /// <summary>
	 ///主属性
	 /// </summary>
	public int MainAttribute;
}
