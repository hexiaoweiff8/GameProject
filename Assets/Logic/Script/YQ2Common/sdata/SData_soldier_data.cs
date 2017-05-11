using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_soldier_data : MonoEX.Singleton<SData_soldier_data>
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
            soldier_dataInfo dif = new soldier_dataInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "ArrayID": dif.ArrayID = (short)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "TrainCost": dif.TrainCost = (short)(double)o22; break;
					case "ArmyType": dif.ArmyType = (short)(double)o22; break;
					case "Attack": dif.Attack = (float)(double)o22; break;
					case "Clipsize": dif.Clipsize = (short)(double)o22; break;
					case "AttackRate": dif.AttackRate = (float)(double)o22; break;
					case "ReloadTime": dif.ReloadTime = (float)(double)o22; break;
					case "HP": dif.HP = (float)(double)o22; break;
					case "Armor": dif.Armor = (float)(double)o22; break;
					case "AntiArmor": dif.AntiArmor = (float)(double)o22; break;
					case "AntiCrit": dif.AntiCrit = (float)(double)o22; break;
					case "Crit": dif.Crit = (float)(double)o22; break;
					case "Dodge": dif.Dodge = (float)(double)o22; break;
					case "Hit": dif.Hit = (float)(double)o22; break;
					case "AttackRange": dif.AttackRange = (float)(double)o22; break;
					case "MoveSpeed": dif.MoveSpeed = (float)(double)o22; break;
					case "ModelID": dif.ModelID = (string)o22; break;
					case "CardImageID": dif.CardImageID = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyID.ToString());
            Data.Add(dif.ArmyID, dif);
        });
    }

    public soldier_dataInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("soldier_dataInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, soldier_dataInfo> Data = new Dictionary<int, soldier_dataInfo>();
}


public struct soldier_dataInfo
{
	 /// <summary>
	 ///
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///
	 /// </summary>
	public short ArrayID;
	 /// <summary>
	 ///
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///
	 /// </summary>
	public short TrainCost;
	 /// <summary>
	 ///
	 /// </summary>
	public short ArmyType;
	 /// <summary>
	 ///
	 /// </summary>
	public float Attack;
	 /// <summary>
	 ///
	 /// </summary>
	public short Clipsize;
	 /// <summary>
	 ///
	 /// </summary>
	public float AttackRate;
	 /// <summary>
	 ///
	 /// </summary>
	public float ReloadTime;
	 /// <summary>
	 ///
	 /// </summary>
	public float HP;
	 /// <summary>
	 ///
	 /// </summary>
	public float Armor;
	 /// <summary>
	 ///
	 /// </summary>
	public float AntiArmor;
	 /// <summary>
	 ///
	 /// </summary>
	public float AntiCrit;
	 /// <summary>
	 ///
	 /// </summary>
	public float Crit;
	 /// <summary>
	 ///
	 /// </summary>
	public float Dodge;
	 /// <summary>
	 ///
	 /// </summary>
	public float Hit;
	 /// <summary>
	 ///
	 /// </summary>
	public float AttackRange;
	 /// <summary>
	 ///
	 /// </summary>
	public float MoveSpeed;
	 /// <summary>
	 ///
	 /// </summary>
	public string ModelID;
	 /// <summary>
	 ///
	 /// </summary>
	public string CardImageID;
}
