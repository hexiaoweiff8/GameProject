using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_kejitree_fangyu_data : MonoEX.Singleton<SData_kejitree_fangyu_data>
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
            kejitree_fangyu_dataInfo dif = new kejitree_fangyu_dataInfo();
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
					case "RequireGold": dif.RequireGold = (int)(double)o22; break;
					case "RequireTime": dif.RequireTime = (int)(double)o22; break;
					case "UserLevel": dif.UserLevel = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public kejitree_fangyu_dataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("kejitree_fangyu_dataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, kejitree_fangyu_dataInfo> Data = new Dictionary<int, kejitree_fangyu_dataInfo>();
}


public struct kejitree_fangyu_dataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///
	 /// </summary>
	public int TechID;
	 /// <summary>
	 ///
	 /// </summary>
	public string TechName;
	 /// <summary>
	 ///
	 /// </summary>
	public short LabelID;
	 /// <summary>
	 ///
	 /// </summary>
	public string TechDes;
	 /// <summary>
	 ///
	 /// </summary>
	public string TechIcon;
	 /// <summary>
	 ///
	 /// </summary>
	public string FunctionDes;
	 /// <summary>
	 ///
	 /// </summary>
	public int AttributeID;
	 /// <summary>
	 ///
	 /// </summary>
	public short Level;
	 /// <summary>
	 ///
	 /// </summary>
	public float Point;
	 /// <summary>
	 ///
	 /// </summary>
	public int RequireGold;
	 /// <summary>
	 ///
	 /// </summary>
	public int RequireTime;
	 /// <summary>
	 ///
	 /// </summary>
	public short UserLevel;
}
