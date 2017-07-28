using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_currency_c : MonoEX.Singleton<SData_currency_c>
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
            currency_cInfo dif = new currency_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (int)(double)o22; break;
					case "Field": dif.Field = (string)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "Quality": dif.Quality = (short)(double)o22; break;
					case "Icon": dif.Icon = (string)o22; break;
					case "FunctionDes": dif.FunctionDes = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public currency_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("currency_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, currency_cInfo> Data = new Dictionary<int, currency_cInfo>();
}


public struct currency_cInfo
{
	 /// <summary>
	 ///编号
	 /// </summary>
	public int ID;
	 /// <summary>
	 ///字段
	 /// </summary>
	public string Field;
	 /// <summary>
	 ///名称
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///品质
	 /// </summary>
	public short Quality;
	 /// <summary>
	 ///图标
	 /// </summary>
	public string Icon;
	 /// <summary>
	 ///功能描述
	 /// </summary>
	public string FunctionDes;
}
