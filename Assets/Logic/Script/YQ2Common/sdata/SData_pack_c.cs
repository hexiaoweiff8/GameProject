using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_pack_c : MonoEX.Singleton<SData_pack_c>
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
            pack_cInfo dif = new pack_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "LabelID": dif.LabelID = (short)(double)o22; break;
					case "TextID": dif.TextID = (int)(double)o22; break;
					case "Goods": dif.Goods = (string)o22; break;
					case "Maintype": dif.Maintype = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.LabelID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.LabelID.ToString());
            Data.Add(dif.LabelID, dif);
        });
    }

    public pack_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("pack_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, pack_cInfo> Data = new Dictionary<int, pack_cInfo>();
}


public struct pack_cInfo
{
	 /// <summary>
	 ///标签ID
	 /// </summary>
	public short LabelID;
	 /// <summary>
	 ///文本ID
	 /// </summary>
	public int TextID;
	 /// <summary>
	 ///物品
	 /// </summary>
	public string Goods;
	 /// <summary>
	 ///主类型
	 /// </summary>
	public short Maintype;
}
