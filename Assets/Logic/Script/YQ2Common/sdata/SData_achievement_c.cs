using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_achievement_c : MonoEX.Singleton<SData_achievement_c>
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
            achievement_cInfo dif = new achievement_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (short)(double)o22; break;
					case "Type": dif.Type = (string)o22; break;
					case "Des": dif.Des = (string)o22; break;
					case "TargetValue": dif.TargetValue = (short)(double)o22; break;
					case "UIDefine": dif.UIDefine = (string)o22; break;
					case "Exp": dif.Exp = (short)(double)o22; break;
					case "Gold": dif.Gold = (int)(double)o22; break;
					case "Diamond": dif.Diamond = (short)(double)o22; break;
					case "SkillPt": dif.SkillPt = (short)(double)o22; break;
					case "GiftType1": dif.GiftType1 = (string)o22; break;
					case "ID1": dif.ID1 = (int)(double)o22; break;
					case "Num1": dif.Num1 = (short)(double)o22; break;
					case "GiftType2": dif.GiftType2 = (string)o22; break;
					case "ID2": dif.ID2 = (int)(double)o22; break;
					case "Num2": dif.Num2 = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public achievement_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("achievement_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, achievement_cInfo> Data = new Dictionary<int, achievement_cInfo>();
}


public struct achievement_cInfo
{
	 /// <summary>
	 ///ID
	 /// </summary>
	public short ID;
	 /// <summary>
	 ///
	 /// </summary>
	public string Type;
	 /// <summary>
	 ///任务描述
	 /// </summary>
	public string Des;
	 /// <summary>
	 ///目标值
	 /// </summary>
	public short TargetValue;
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
	 ///奖励类型1
	 /// </summary>
	public string GiftType1;
	 /// <summary>
	 ///道具1
	 /// </summary>
	public int ID1;
	 /// <summary>
	 ///数量1
	 /// </summary>
	public short Num1;
	 /// <summary>
	 ///奖励类型2
	 /// </summary>
	public string GiftType2;
	 /// <summary>
	 ///道具2
	 /// </summary>
	public int ID2;
	 /// <summary>
	 ///数量2
	 /// </summary>
	public short Num2;
}
