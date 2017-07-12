using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_Constant : MonoEX.Singleton<SData_Constant>
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
            ConstantInfo dif = new ConstantInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (int)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "Value": dif.Value = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public ConstantInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("ConstantInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, ConstantInfo> Data = new Dictionary<int, ConstantInfo>();
}


public struct ConstantInfo
{
	 /// <summary>
	 ///ID
	 /// </summary>
	public int ID;
	 /// <summary>
	 ///名称
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///数值
	 /// </summary>
	public float Value;
}
