using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_zhenxing_data : MonoEX.Singleton<SData_zhenxing_data>
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
            zhenxing_dataInfo dif = new zhenxing_dataInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArrayID": dif.ArrayID = (short)(double)o22; break;
					case "Position": dif.Position = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArrayID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArrayID.ToString());
            Data.Add(dif.ArrayID, dif);
        });
    }

    public zhenxing_dataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("zhenxing_dataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, zhenxing_dataInfo> Data = new Dictionary<int, zhenxing_dataInfo>();
}


public struct zhenxing_dataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public short ArrayID;
	 /// <summary>
	 ///
	 /// </summary>
	public string Position;
}
