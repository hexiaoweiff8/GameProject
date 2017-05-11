using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardstar_c : MonoEX.Singleton<SData_armycardstar_c>
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
            armycardstar_cInfo dif = new armycardstar_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "ArmyCardID": dif.ArmyCardID = (int)(double)o22; break;
					case "ArmyStarLevel": dif.ArmyStarLevel = (short)(double)o22; break;
					case "CardStarAttack": dif.CardStarAttack = (float)(double)o22; break;
					case "CardStarHP": dif.CardStarHP = (float)(double)o22; break;
					case "CardStarDefense": dif.CardStarDefense = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public armycardstar_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardstar_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardstar_cInfo> Data = new Dictionary<int, armycardstar_cInfo>();
}


public struct armycardstar_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///卡牌ID
	 /// </summary>
	public int ArmyCardID;
	 /// <summary>
	 ///卡牌星级
	 /// </summary>
	public short ArmyStarLevel;
	 /// <summary>
	 ///攻击成长系数加成
	 /// </summary>
	public float CardStarAttack;
	 /// <summary>
	 ///生命成长系数加成
	 /// </summary>
	public float CardStarHP;
	 /// <summary>
	 ///防御成长系数加成
	 /// </summary>
	public float CardStarDefense;
}
