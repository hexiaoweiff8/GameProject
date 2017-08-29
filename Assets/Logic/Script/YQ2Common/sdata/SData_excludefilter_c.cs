using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_excludefilter_c : MonoEX.Singleton<SData_excludefilter_c>
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
            excludefilter_cInfo dif = new excludefilter_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ExcludeFilterID": dif.ExcludeFilterID = (int)(double)o22; break;
					case "TargetTacticTypeID": dif.TargetTacticTypeID = (int)(double)o22; break;
					case "ExcludeTacticTypeID": dif.ExcludeTacticTypeID = (int)(double)o22; break;
					case "ExcludeCondition": dif.ExcludeCondition = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ExcludeFilterID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ExcludeFilterID.ToString());
            Data.Add(dif.ExcludeFilterID, dif);
        });
    }

    public excludefilter_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("excludefilter_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, excludefilter_cInfo> Data = new Dictionary<int, excludefilter_cInfo>();
}


public struct excludefilter_cInfo
{
	 /// <summary>
	 ///排除筛选ID
	 /// </summary>
	public int ExcludeFilterID;
	 /// <summary>
	 ///敌方的目标类型ID
	 /// </summary>
	public int TargetTacticTypeID;
	 /// <summary>
	 ///我方的排除类型ID
	 /// </summary>
	public int ExcludeTacticTypeID;
	 /// <summary>
	 ///排除条件：费用比例下限
	 /// </summary>
	public float ExcludeCondition;
}
