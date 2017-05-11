using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_skill_c : MonoEX.Singleton<SData_skill_c>
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
            skill_cInfo dif = new skill_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "SkillID": dif.SkillID = (int)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "Des": dif.Des = (string)o22; break;
					case "SkillIcon": dif.SkillIcon = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.SkillID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.SkillID.ToString());
            Data.Add(dif.SkillID, dif);
        });
    }

    public skill_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("skill_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, skill_cInfo> Data = new Dictionary<int, skill_cInfo>();
}


public struct skill_cInfo
{
	 /// <summary>
	 ///技能ID
	 /// </summary>
	public int SkillID;
	 /// <summary>
	 ///技能名字
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///技能描述
	 /// </summary>
	public string Des;
	 /// <summary>
	 ///技能图标
	 /// </summary>
	public string SkillIcon;
}
