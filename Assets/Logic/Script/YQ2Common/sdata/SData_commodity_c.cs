using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_commodity_c : MonoEX.Singleton<SData_commodity_c>
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
            commodity_cInfo dif = new commodity_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "CommID": dif.CommID = (short)(double)o22; break;
					case "DropType": dif.DropType = (string)o22; break;
					case "DropID": dif.DropID = (string)o22; break;
					case "DropNum": dif.DropNum = (int)(double)o22; break;
					case "Quality": dif.Quality = (short)(double)o22; break;
					case "MoneyType": dif.MoneyType = (string)o22; break;
					case "Value": dif.Value = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.CommID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.CommID.ToString());
            Data.Add(dif.CommID, dif);
        });
    }

    public commodity_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("commodity_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, commodity_cInfo> Data = new Dictionary<int, commodity_cInfo>();
}


public struct commodity_cInfo
{
	 /// <summary>
	 ///商品ID
	 /// </summary>
	public short CommID;
	 /// <summary>
	 ///产出类型
	 /// </summary>
	public string DropType;
	 /// <summary>
	 ///物品ID
	 /// </summary>
	public string DropID;
	 /// <summary>
	 ///物品数量
	 /// </summary>
	public int DropNum;
	 /// <summary>
	 ///品质
	 /// </summary>
	public short Quality;
	 /// <summary>
	 ///货币类型
	 /// </summary>
	public string MoneyType;
	 /// <summary>
	 ///价格
	 /// </summary>
	public int Value;
}
