using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_Equip_suit_data : MonoEX.Singleton<SData_Equip_suit_data>
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
            Equip_suit_dataInfo dif = new Equip_suit_dataInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "SuitID": dif.SuitID = (short)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "SuitEffect2": dif.SuitEffect2 = (int)(double)o22; break;
					case "Effect2Point": dif.Effect2Point = (float)(double)o22; break;
					case "SuitEffect3": dif.SuitEffect3 = (int)(double)o22; break;
					case "Effect3Point": dif.Effect3Point = (float)(double)o22; break;
					case "SuitEffect5": dif.SuitEffect5 = (int)(double)o22; break;
					case "Effect5Point": dif.Effect5Point = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.SuitID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.SuitID.ToString());
            Data.Add(dif.SuitID, dif);
        });
    }

    public Equip_suit_dataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("Equip_suit_dataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, Equip_suit_dataInfo> Data = new Dictionary<int, Equip_suit_dataInfo>();
}


public struct Equip_suit_dataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public short SuitID;
	 /// <summary>
	 ///
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///
	 /// </summary>
	public int SuitEffect2;
	 /// <summary>
	 ///
	 /// </summary>
	public float Effect2Point;
	 /// <summary>
	 ///
	 /// </summary>
	public int SuitEffect3;
	 /// <summary>
	 ///
	 /// </summary>
	public float Effect3Point;
	 /// <summary>
	 ///
	 /// </summary>
	public int SuitEffect5;
	 /// <summary>
	 ///
	 /// </summary>
	public float Effect5Point;
}
