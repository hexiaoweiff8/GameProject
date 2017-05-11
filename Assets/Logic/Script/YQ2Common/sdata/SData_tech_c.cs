using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_tech_c : MonoEX.Singleton<SData_tech_c>
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
            tech_cInfo dif = new tech_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "TechID": dif.TechID = (int)(double)o22; break;
					case "TechName": dif.TechName = (string)o22; break;
					case "LabelID": dif.LabelID = (short)(double)o22; break;
					case "TechDes": dif.TechDes = (string)o22; break;
					case "TechIcon": dif.TechIcon = (string)o22; break;
					case "FunctionDes": dif.FunctionDes = (string)o22; break;
					case "AttributeID": dif.AttributeID = (int)(double)o22; break;
					case "Level": dif.Level = (short)(double)o22; break;
					case "Point": dif.Point = (float)(double)o22; break;
					case "UserLevel": dif.UserLevel = (short)(double)o22; break;
					case "RequireGold": dif.RequireGold = (int)(double)o22; break;
					case "RequireTime": dif.RequireTime = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public tech_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("tech_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, tech_cInfo> Data = new Dictionary<int, tech_cInfo>();
}


public struct tech_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///科技ID
	 /// </summary>
	public int TechID;
	 /// <summary>
	 ///科技名称
	 /// </summary>
	public string TechName;
	 /// <summary>
	 ///科技标签
	 /// </summary>
	public short LabelID;
	 /// <summary>
	 ///科技描述
	 /// </summary>
	public string TechDes;
	 /// <summary>
	 ///科技图标
	 /// </summary>
	public string TechIcon;
	 /// <summary>
	 ///功能描述
	 /// </summary>
	public string FunctionDes;
	 /// <summary>
	 ///属性ID
	 /// </summary>
	public int AttributeID;
	 /// <summary>
	 ///科技的等级
	 /// </summary>
	public short Level;
	 /// <summary>
	 ///加成数值
	 /// </summary>
	public float Point;
	 /// <summary>
	 ///玩家等级
	 /// </summary>
	public short UserLevel;
	 /// <summary>
	 ///需求金币
	 /// </summary>
	public int RequireGold;
	 /// <summary>
	 ///需求时间
	 /// </summary>
	public int RequireTime;
}
