using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_missionstage_c : MonoEX.Singleton<SData_missionstage_c>
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
            missionstage_cInfo dif = new missionstage_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (short)(double)o22; break;
					case "Chapter": dif.Chapter = (short)(double)o22; break;
					case "Stage": dif.Stage = (short)(double)o22; break;
					case "Des": dif.Des = (string)o22; break;
					case "NPC": dif.NPC = (string)o22; break;
					case "Target1": dif.Target1 = (string)o22; break;
					case "Target2": dif.Target2 = (string)o22; break;
					case "Target3": dif.Target3 = (string)o22; break;
					case "UserExp": dif.UserExp = (short)(double)o22; break;
					case "Gift": dif.Gift = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public missionstage_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("missionstage_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, missionstage_cInfo> Data = new Dictionary<int, missionstage_cInfo>();
}


public struct missionstage_cInfo
{
	 /// <summary>
	 ///关卡ID
	 /// </summary>
	public short ID;
	 /// <summary>
	 ///章节
	 /// </summary>
	public short Chapter;
	 /// <summary>
	 ///关卡顺序
	 /// </summary>
	public short Stage;
	 /// <summary>
	 ///任务情报
	 /// </summary>
	public string Des;
	 /// <summary>
	 ///NPC
	 /// </summary>
	public string NPC;
	 /// <summary>
	 ///任务目标1
	 /// </summary>
	public string Target1;
	 /// <summary>
	 ///任务目标2
	 /// </summary>
	public string Target2;
	 /// <summary>
	 ///任务目标3
	 /// </summary>
	public string Target3;
	 /// <summary>
	 ///关卡经验
	 /// </summary>
	public short UserExp;
	 /// <summary>
	 ///关卡奖励
	 /// </summary>
	public string Gift;
}
