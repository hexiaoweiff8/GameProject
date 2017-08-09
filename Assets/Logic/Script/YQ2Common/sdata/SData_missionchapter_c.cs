using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_missionchapter_c : MonoEX.Singleton<SData_missionchapter_c>
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
            missionchapter_cInfo dif = new missionchapter_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "Chapter": dif.Chapter = (short)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "UnlockLevel": dif.UnlockLevel = (short)(double)o22; break;
					case "CityID": dif.CityID = (short)(double)o22; break;
					case "ClearGift": dif.ClearGift = (string)o22; break;
					case "PerfectGift": dif.PerfectGift = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.Chapter))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.Chapter.ToString());
            Data.Add(dif.Chapter, dif);
        });
    }

    public missionchapter_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("missionchapter_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, missionchapter_cInfo> Data = new Dictionary<int, missionchapter_cInfo>();
}


public struct missionchapter_cInfo
{
	 /// <summary>
	 ///章节
	 /// </summary>
	public short Chapter;
	 /// <summary>
	 ///章节名称
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///解锁等级
	 /// </summary>
	public short UnlockLevel;
	 /// <summary>
	 ///入口城市序号
	 /// </summary>
	public short CityID;
	 /// <summary>
	 ///通关奖励
	 /// </summary>
	public string ClearGift;
	 /// <summary>
	 ///完美通关奖励
	 /// </summary>
	public string PerfectGift;
}
