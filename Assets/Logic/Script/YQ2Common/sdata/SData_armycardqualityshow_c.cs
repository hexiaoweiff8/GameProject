using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardqualityshow_c : MonoEX.Singleton<SData_armycardqualityshow_c>
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
            armycardqualityshow_cInfo dif = new armycardqualityshow_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "QualityLevel": dif.QualityLevel = (short)(double)o22; break;
					case "CardLevel": dif.CardLevel = (short)(double)o22; break;
					case "QualityIcon": dif.QualityIcon = (string)o22; break;
					case "QualityColor": dif.QualityColor = (short)(double)o22; break;
					case "PlusNum": dif.PlusNum = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.QualityLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.QualityLevel.ToString());
            Data.Add(dif.QualityLevel, dif);
        });
    }

    public armycardqualityshow_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardqualityshow_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardqualityshow_cInfo> Data = new Dictionary<int, armycardqualityshow_cInfo>();
}


public struct armycardqualityshow_cInfo
{
	 /// <summary>
	 ///品质等级（军阶）
	 /// </summary>
	public short QualityLevel;
	 /// <summary>
	 ///卡牌等级
	 /// </summary>
	public short CardLevel;
	 /// <summary>
	 ///品质图标
	 /// </summary>
	public string QualityIcon;
	 /// <summary>
	 ///品质颜色
	 /// </summary>
	public short QualityColor;
	 /// <summary>
	 ///颜色数值
	 /// </summary>
	public short PlusNum;
}
