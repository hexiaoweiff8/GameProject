using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardskillcost_c : MonoEX.Singleton<SData_armycardskillcost_c>
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
            armycardskillcost_cInfo dif = new armycardskillcost_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "SkillLevel": dif.SkillLevel = (short)(double)o22; break;
					case "SkillPt": dif.SkillPt = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.SkillLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.SkillLevel.ToString());
            Data.Add(dif.SkillLevel, dif);
        });
    }

    public armycardskillcost_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardskillcost_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardskillcost_cInfo> Data = new Dictionary<int, armycardskillcost_cInfo>();
}


public struct armycardskillcost_cInfo
{
	 /// <summary>
	 ///技能等级
	 /// </summary>
	public short SkillLevel;
	 /// <summary>
	 ///技能点数量
	 /// </summary>
	public int SkillPt;
}
