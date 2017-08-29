using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_tactictype_c : MonoEX.Singleton<SData_tactictype_c>
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
            tactictype_cInfo dif = new tactictype_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "FightTypeID": dif.FightTypeID = (int)(double)o22; break;
					case "ArmyType": dif.ArmyType = (short)(double)o22; break;
					case "GeneralType": dif.GeneralType = (short)(double)o22; break;
					case "AntiSurface": dif.AntiSurface = (short)(double)o22; break;
					case "AntiAir": dif.AntiAir = (short)(double)o22; break;
					case "Hide": dif.Hide = (short)(double)o22; break;
					case "AntiHide": dif.AntiHide = (short)(double)o22; break;
					case "Group": dif.Group = (short)(double)o22; break;
					case "AntiGroup": dif.AntiGroup = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.FightTypeID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.FightTypeID.ToString());
            Data.Add(dif.FightTypeID, dif);
        });
    }

    public tactictype_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("tactictype_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, tactictype_cInfo> Data = new Dictionary<int, tactictype_cInfo>();
}


public struct tactictype_cInfo
{
	 /// <summary>
	 ///策略类型ID
	 /// </summary>
	public int FightTypeID;
	 /// <summary>
	 ///此类型需要的种族
	 /// </summary>
	public short ArmyType;
	 /// <summary>
	 ///此类型需要的空地属性
	 /// </summary>
	public short GeneralType;
	 /// <summary>
	 ///是否需要对地
	 /// </summary>
	public short AntiSurface;
	 /// <summary>
	 ///是否需要对空
	 /// </summary>
	public short AntiAir;
	 /// <summary>
	 ///是否需要隐形
	 /// </summary>
	public short Hide;
	 /// <summary>
	 ///是否需要反隐
	 /// </summary>
	public short AntiHide;
	 /// <summary>
	 ///是否需要属于群体类
	 /// </summary>
	public short Group;
	 /// <summary>
	 ///是否需要属于克制群体类
	 /// </summary>
	public short AntiGroup;
}
