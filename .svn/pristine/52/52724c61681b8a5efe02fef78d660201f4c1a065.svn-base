using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardquality_c : MonoEX.Singleton<SData_armycardquality_c>
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
            armycardquality_cInfo dif = new armycardquality_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "ArmyQualityLevel": dif.ArmyQualityLevel = (short)(double)o22; break;
					case "CardQualityAttack": dif.CardQualityAttack = (float)(double)o22; break;
					case "CardQualityHP": dif.CardQualityHP = (float)(double)o22; break;
					case "CardQualityDefense": dif.CardQualityDefense = (float)(double)o22; break;
					case "CardEquip1": dif.CardEquip1 = (int)(double)o22; break;
					case "Point1": dif.Point1 = (float)(double)o22; break;
					case "ItemID1": dif.ItemID1 = (int)(double)o22; break;
					case "Num1": dif.Num1 = (int)(double)o22; break;
					case "CardEquip2": dif.CardEquip2 = (int)(double)o22; break;
					case "Point2": dif.Point2 = (float)(double)o22; break;
					case "ItemID2": dif.ItemID2 = (int)(double)o22; break;
					case "Num2": dif.Num2 = (int)(double)o22; break;
					case "CardEquip3": dif.CardEquip3 = (int)(double)o22; break;
					case "Point3": dif.Point3 = (float)(double)o22; break;
					case "ItemID3": dif.ItemID3 = (int)(double)o22; break;
					case "Num3": dif.Num3 = (int)(double)o22; break;
					case "CardEquip4": dif.CardEquip4 = (int)(double)o22; break;
					case "Point4": dif.Point4 = (float)(double)o22; break;
					case "ItemID4": dif.ItemID4 = (int)(double)o22; break;
					case "Num4": dif.Num4 = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public armycardquality_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardquality_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardquality_cInfo> Data = new Dictionary<int, armycardquality_cInfo>();
}


public struct armycardquality_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///卡牌ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///军阶等级
	 /// </summary>
	public short ArmyQualityLevel;
	 /// <summary>
	 ///品质攻击加成
	 /// </summary>
	public float CardQualityAttack;
	 /// <summary>
	 ///品质生命加成
	 /// </summary>
	public float CardQualityHP;
	 /// <summary>
	 ///品质防御加成
	 /// </summary>
	public float CardQualityDefense;
	 /// <summary>
	 ///插槽1
	 /// </summary>
	public int CardEquip1;
	 /// <summary>
	 ///插槽1数值
	 /// </summary>
	public float Point1;
	 /// <summary>
	 ///插槽1需求道具
	 /// </summary>
	public int ItemID1;
	 /// <summary>
	 ///插槽1需求道具数量
	 /// </summary>
	public int Num1;
	 /// <summary>
	 ///插槽2
	 /// </summary>
	public int CardEquip2;
	 /// <summary>
	 ///插槽2数值
	 /// </summary>
	public float Point2;
	 /// <summary>
	 ///插槽2需求道具
	 /// </summary>
	public int ItemID2;
	 /// <summary>
	 ///插槽2需求道具数量
	 /// </summary>
	public int Num2;
	 /// <summary>
	 ///插槽3
	 /// </summary>
	public int CardEquip3;
	 /// <summary>
	 ///插槽3数值
	 /// </summary>
	public float Point3;
	 /// <summary>
	 ///插槽3需求道具
	 /// </summary>
	public int ItemID3;
	 /// <summary>
	 ///插槽3需求道具数量
	 /// </summary>
	public int Num3;
	 /// <summary>
	 ///插槽4
	 /// </summary>
	public int CardEquip4;
	 /// <summary>
	 ///插槽4数值
	 /// </summary>
	public float Point4;
	 /// <summary>
	 ///插槽4需求道具
	 /// </summary>
	public int ItemID4;
	 /// <summary>
	 ///插槽4需求道具数量
	 /// </summary>
	public int Num4;
}
