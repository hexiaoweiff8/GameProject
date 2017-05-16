using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_equipsuit_c : MonoEX.Singleton<SData_equipsuit_c>
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
            equipsuit_cInfo dif = new equipsuit_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "SuitID": dif.SuitID = (short)(double)o22; break;
					case "SuitIcon": dif.SuitIcon = (string)o22; break;
					case "SuitName": dif.SuitName = (string)o22; break;
					case "SuitEffect2": dif.SuitEffect2 = (int)(double)o22; break;
					case "Effect2Point": dif.Effect2Point = (float)(double)o22; break;
					case "SuitEffect3": dif.SuitEffect3 = (int)(double)o22; break;
					case "Effect3Point": dif.Effect3Point = (float)(double)o22; break;
					case "SuitEffect5": dif.SuitEffect5 = (int)(double)o22; break;
					case "Effect5Point": dif.Effect5Point = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.SuitID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.SuitID.ToString());
            Data.Add(dif.SuitID, dif);
        });
    }

    public equipsuit_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("equipsuit_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, equipsuit_cInfo> Data = new Dictionary<int, equipsuit_cInfo>();
}


public struct equipsuit_cInfo
{
	 /// <summary>
	 ///套装ID
	 /// </summary>
	public short SuitID;
	 /// <summary>
	 ///套装图标
	 /// </summary>
	public string SuitIcon;
	 /// <summary>
	 ///套装名称
	 /// </summary>
	public string SuitName;
	 /// <summary>
	 ///两件套属性
	 /// </summary>
	public int SuitEffect2;
	 /// <summary>
	 ///两件套属性值
	 /// </summary>
	public float Effect2Point;
	 /// <summary>
	 ///三件套属性
	 /// </summary>
	public int SuitEffect3;
	 /// <summary>
	 ///三件套属性值
	 /// </summary>
	public float Effect3Point;
	 /// <summary>
	 ///五件套属性
	 /// </summary>
	public int SuitEffect5;
	 /// <summary>
	 ///五件套属性值
	 /// </summary>
	public float Effect5Point;
}
