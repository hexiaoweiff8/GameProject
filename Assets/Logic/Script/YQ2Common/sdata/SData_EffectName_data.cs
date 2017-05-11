using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_EffectName_data : MonoEX.Singleton<SData_EffectName_data>
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
            EffectName_dataInfo dif = new EffectName_dataInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "EffectID": dif.EffectID = (int)(double)o22; break;
					case "EffectName": dif.EffectName = (string)o22; break;
					case "Symbol": dif.Symbol = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.EffectID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.EffectID.ToString());
            Data.Add(dif.EffectID, dif);
        });
    }

    public EffectName_dataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("EffectName_dataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, EffectName_dataInfo> Data = new Dictionary<int, EffectName_dataInfo>();
}


public struct EffectName_dataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public int EffectID;
	 /// <summary>
	 ///
	 /// </summary>
	public string EffectName;
	 /// <summary>
	 ///
	 /// </summary>
	public string Symbol;
}
