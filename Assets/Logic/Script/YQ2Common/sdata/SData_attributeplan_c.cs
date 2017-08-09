using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_attributeplan_c : MonoEX.Singleton<SData_attributeplan_c>
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
            attributeplan_cInfo dif = new attributeplan_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "PlanID": dif.PlanID = (int)(double)o22; break;
					case "AttributeID": dif.AttributeID = (int)(double)o22; break;
					case "Value": dif.Value = (int)(double)o22; break;
					case "Min": dif.Min = (float)(double)o22; break;
					case "up": dif.up = (float)(double)o22; break;
					case "Max": dif.Max = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public attributeplan_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("attributeplan_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, attributeplan_cInfo> Data = new Dictionary<int, attributeplan_cInfo>();
}


public struct attributeplan_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///方案ID
	 /// </summary>
	public int PlanID;
	 /// <summary>
	 ///属性ID
	 /// </summary>
	public int AttributeID;
	 /// <summary>
	 ///权重
	 /// </summary>
	public int Value;
	 /// <summary>
	 ///最小值
	 /// </summary>
	public float Min;
	 /// <summary>
	 ///成长系数
	 /// </summary>
	public float up;
	 /// <summary>
	 ///最大值
	 /// </summary>
	public float Max;
}
