using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_item_c : MonoEX.Singleton<SData_item_c>
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
            item_cInfo dif = new item_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ItemID": dif.ItemID = (int)(double)o22; break;
					case "UseType": dif.UseType = (short)(double)o22; break;
					case "RelationID": dif.RelationID = (string)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "Des": dif.Des = (string)o22; break;
					case "FunctionDes": dif.FunctionDes = (string)o22; break;
					case "Icon": dif.Icon = (string)o22; break;
					case "AvatarMode": dif.AvatarMode = (string)o22; break;
					case "Quality": dif.Quality = (short)(double)o22; break;
					case "OverlapUse": dif.OverlapUse = (short)(double)o22; break;
					case "OverlapLimit": dif.OverlapLimit = (short)(double)o22; break;
					case "SaleGold": dif.SaleGold = (int)(double)o22; break;
					case "ComposeNum": dif.ComposeNum = (short)(double)o22; break;
					case "ComposeID": dif.ComposeID = (int)(double)o22; break;
					case "ComposeQuality": dif.ComposeQuality = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ItemID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ItemID.ToString());
            Data.Add(dif.ItemID, dif);
        });
    }

    public item_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("item_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, item_cInfo> Data = new Dictionary<int, item_cInfo>();
}


public struct item_cInfo
{
	 /// <summary>
	 ///道具ID
	 /// </summary>
	public int ItemID;
	 /// <summary>
	 ///功能类型
	 /// </summary>
	public short UseType;
	 /// <summary>
	 ///关联ID
	 /// </summary>
	public string RelationID;
	 /// <summary>
	 ///名称
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///描述
	 /// </summary>
	public string Des;
	 /// <summary>
	 ///功能描述
	 /// </summary>
	public string FunctionDes;
	 /// <summary>
	 ///图标
	 /// </summary>
	public string Icon;
	 /// <summary>
	 ///时装模型
	 /// </summary>
	public string AvatarMode;
	 /// <summary>
	 ///品质
	 /// </summary>
	public short Quality;
	 /// <summary>
	 ///重叠使用
	 /// </summary>
	public short OverlapUse;
	 /// <summary>
	 ///重叠上限
	 /// </summary>
	public short OverlapLimit;
	 /// <summary>
	 ///出售金币价格
	 /// </summary>
	public int SaleGold;
	 /// <summary>
	 ///合成数量
	 /// </summary>
	public short ComposeNum;
	 /// <summary>
	 ///合成ID
	 /// </summary>
	public int ComposeID;
	 /// <summary>
	 ///合成品质
	 /// </summary>
	public short ComposeQuality;
}
