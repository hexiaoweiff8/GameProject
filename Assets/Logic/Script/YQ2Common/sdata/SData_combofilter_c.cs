using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_combofilter_c : MonoEX.Singleton<SData_combofilter_c>
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
            combofilter_cInfo dif = new combofilter_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ComboFilterID": dif.ComboFilterID = (int)(double)o22; break;
					case "TargetID": dif.TargetID = (int)(double)o22; break;
					case "ChooseID": dif.ChooseID = (string)o22; break;
					case "ComboCondition": dif.ComboCondition = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ComboFilterID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ComboFilterID.ToString());
            Data.Add(dif.ComboFilterID, dif);
        });
    }

    public combofilter_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("combofilter_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, combofilter_cInfo> Data = new Dictionary<int, combofilter_cInfo>();
}


public struct combofilter_cInfo
{
	 /// <summary>
	 ///套路筛选ID
	 /// </summary>
	public int ComboFilterID;
	 /// <summary>
	 ///套路的目标单位ID
	 /// </summary>
	public int TargetID;
	 /// <summary>
	 ///套路的可选牌ID
	 /// </summary>
	public string ChooseID;
	 /// <summary>
	 ///套路条件：费用下限
	 /// </summary>
	public short ComboCondition;
}
