using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_mission_c : MonoEX.Singleton<SData_mission_c>
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
            mission_cInfo dif = new mission_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (short)(double)o22; break;
					case "Des": dif.Des = (string)o22; break;
					case "PreMission": dif.PreMission = (short)(double)o22; break;
					case "ClearHide": dif.ClearHide = (short)(double)o22; break;
					case "Type": dif.Type = (short)(double)o22; break;
					case "Refresh": dif.Refresh = (short)(double)o22; break;
					case "TargetValue": dif.TargetValue = (short)(double)o22; break;
					case "UnlockLevel": dif.UnlockLevel = (short)(double)o22; break;
					case "UIDefine": dif.UIDefine = (string)o22; break;
					case "Exp": dif.Exp = (short)(double)o22; break;
					case "Gold": dif.Gold = (int)(double)o22; break;
					case "Diamond": dif.Diamond = (short)(double)o22; break;
					case "SkillPt": dif.SkillPt = (short)(double)o22; break;
					case "Item1": dif.Item1 = (int)(double)o22; break;
					case "Num1": dif.Num1 = (short)(double)o22; break;
					case "Item2": dif.Item2 = (int)(double)o22; break;
					case "Num2": dif.Num2 = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public mission_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("mission_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, mission_cInfo> Data = new Dictionary<int, mission_cInfo>();
}


public struct mission_cInfo
{
	 /// <summary>
	 ///ID
	 /// </summary>
	public short ID;
	 /// <summary>
	 ///任务描述
	 /// </summary>
	public string Des;
	 /// <summary>
	 ///前置任务
	 /// </summary>
	public short PreMission;
	 /// <summary>
	 ///达成后隐藏
	 /// </summary>
	public short ClearHide;
	 /// <summary>
	 ///类型
	 /// </summary>
	public short Type;
	 /// <summary>
	 ///刷新类型
	 /// </summary>
	public short Refresh;
	 /// <summary>
	 ///目标值
	 /// </summary>
	public short TargetValue;
	 /// <summary>
	 ///开启等级
	 /// </summary>
	public short UnlockLevel;
	 /// <summary>
	 ///UI链接
	 /// </summary>
	public string UIDefine;
	 /// <summary>
	 ///经验
	 /// </summary>
	public short Exp;
	 /// <summary>
	 ///金币
	 /// </summary>
	public int Gold;
	 /// <summary>
	 ///钻石
	 /// </summary>
	public short Diamond;
	 /// <summary>
	 ///技能点
	 /// </summary>
	public short SkillPt;
	 /// <summary>
	 ///道具1
	 /// </summary>
	public int Item1;
	 /// <summary>
	 ///数量1
	 /// </summary>
	public short Num1;
	 /// <summary>
	 ///道具2
	 /// </summary>
	public int Item2;
	 /// <summary>
	 ///数量2
	 /// </summary>
	public short Num2;
}
