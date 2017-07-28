using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_shop_c : MonoEX.Singleton<SData_shop_c>
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
            shop_cInfo dif = new shop_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ShopID": dif.ShopID = (short)(double)o22; break;
					case "ShopType": dif.ShopType = (string)o22; break;
					case "Label": dif.Label = (int)(double)o22; break;
					case "Icon": dif.Icon = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ShopID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ShopID.ToString());
            Data.Add(dif.ShopID, dif);
        });
    }

    public shop_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("shop_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, shop_cInfo> Data = new Dictionary<int, shop_cInfo>();
}


public struct shop_cInfo
{
	 /// <summary>
	 ///商店ID
	 /// </summary>
	public short ShopID;
	 /// <summary>
	 ///商店类型
	 /// </summary>
	public string ShopType;
	 /// <summary>
	 ///标签文本
	 /// </summary>
	public int Label;
	 /// <summary>
	 ///标签图片
	 /// </summary>
	public string Icon;
}
