using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_attribute_c : MonoEX.Singleton<SData_attribute_c>
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
            attribute_cInfo dif = new attribute_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "AttributeID": dif.AttributeID = (int)(double)o22; break;
					case "AttributeName": dif.AttributeName = (string)o22; break;
					case "Symbol": dif.Symbol = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.AttributeID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.AttributeID.ToString());
            Data.Add(dif.AttributeID, dif);
        });
    }

    public attribute_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("attribute_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, attribute_cInfo> Data = new Dictionary<int, attribute_cInfo>();
}


public struct attribute_cInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public int AttributeID;
	 /// <summary>
	 ///
	 /// </summary>
	public string AttributeName;
	 /// <summary>
	 ///
	 /// </summary>
	public string Symbol;
}
