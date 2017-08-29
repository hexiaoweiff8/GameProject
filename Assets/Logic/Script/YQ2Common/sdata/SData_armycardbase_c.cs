using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardbase_c : MonoEX.Singleton<SData_armycardbase_c>
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
            armycardbase_cInfo dif = new armycardbase_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyCardID": dif.ArmyCardID = (int)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "Des": dif.Des = (string)o22; break;
					case "Rarity": dif.Rarity = (short)(double)o22; break;
					case "TrainCost": dif.TrainCost = (short)(double)o22; break;
					case "IconID": dif.IconID = (string)o22; break;
					case "ModelID": dif.ModelID = (string)o22; break;
					case "ArrayID": dif.ArrayID = (int)(double)o22; break;
					case "AreaLimit": dif.AreaLimit = (short)(double)o22; break;
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "ArmyUnit": dif.ArmyUnit = (short)(double)o22; break;
					case "IsExchange": dif.IsExchange = (short)(double)o22; break;
					case "ShopType": dif.ShopType = (string)o22; break;
					case "Type": dif.Type = (string)o22; break;
					case "BasePrice": dif.BasePrice = (int)(double)o22; break;
					case "UpPrice": dif.UpPrice = (int)(double)o22; break;
					case "ExchangeCoin": dif.ExchangeCoin = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyCardID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyCardID.ToString());
            Data.Add(dif.ArmyCardID, dif);
        });
    }

    public armycardbase_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardbase_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardbase_cInfo> Data = new Dictionary<int, armycardbase_cInfo>();
}


public struct armycardbase_cInfo
{
	 /// <summary>
	 ///卡牌ID
	 /// </summary>
	public int ArmyCardID;
	 /// <summary>
	 ///卡牌名称
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///卡牌描述
	 /// </summary>
	public string Des;
	 /// <summary>
	 ///卡牌稀有度
	 /// </summary>
	public short Rarity;
	 /// <summary>
	 ///卡牌费用
	 /// </summary>
	public short TrainCost;
	 /// <summary>
	 ///卡牌图片
	 /// </summary>
	public string IconID;
	 /// <summary>
	 ///模型ID
	 /// </summary>
	public string ModelID;
	 /// <summary>
	 ///阵型ID
	 /// </summary>
	public int ArrayID;
	 /// <summary>
	 ///卡牌是否受兵线限制
	 /// </summary>
	public short AreaLimit;
	 /// <summary>
	 ///兵种ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///兵种数量
	 /// </summary>
	public short ArmyUnit;
	 /// <summary>
	 ///是否可以兑换
	 /// </summary>
	public short IsExchange;
	 /// <summary>
	 ///商店类型
	 /// </summary>
	public string ShopType;
	 /// <summary>
	 ///货币类型
	 /// </summary>
	public string Type;
	 /// <summary>
	 ///基础价格
	 /// </summary>
	public int BasePrice;
	 /// <summary>
	 ///成长系数
	 /// </summary>
	public int UpPrice;
	 /// <summary>
	 ///兑换兵牌
	 /// </summary>
	public short ExchangeCoin;
}
