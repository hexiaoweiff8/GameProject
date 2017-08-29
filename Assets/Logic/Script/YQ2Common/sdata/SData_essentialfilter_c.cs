using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_essentialfilter_c : MonoEX.Singleton<SData_essentialfilter_c>
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
            essentialfilter_cInfo dif = new essentialfilter_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "EssentialFilterID": dif.EssentialFilterID = (int)(double)o22; break;
					case "TargetTacticTypeID": dif.TargetTacticTypeID = (int)(double)o22; break;
					case "ChooseTacticTypeID": dif.ChooseTacticTypeID = (int)(double)o22; break;
					case "ChooseCondition": dif.ChooseCondition = (float)(double)o22; break;
					case "SecondCondition": dif.SecondCondition = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.EssentialFilterID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.EssentialFilterID.ToString());
            Data.Add(dif.EssentialFilterID, dif);
        });
    }

    public essentialfilter_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("essentialfilter_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, essentialfilter_cInfo> Data = new Dictionary<int, essentialfilter_cInfo>();
}


public struct essentialfilter_cInfo
{
	 /// <summary>
	 ///必选筛选ID
	 /// </summary>
	public int EssentialFilterID;
	 /// <summary>
	 ///敌方的目标类型ID
	 /// </summary>
	public int TargetTacticTypeID;
	 /// <summary>
	 ///我方的必选类型ID
	 /// </summary>
	public int ChooseTacticTypeID;
	 /// <summary>
	 ///必选条件：费用比例下限
	 /// </summary>
	public float ChooseCondition;
	 /// <summary>
	 ///次要条件：费用比例
	 /// </summary>
	public float SecondCondition;
}
