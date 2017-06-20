using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armyaoe_c : MonoEX.Singleton<SData_armyaoe_c>
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
            armyaoe_cInfo dif = new armyaoe_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "AOEAim": dif.AOEAim = (short)(double)o22; break;
					case "AOEArea": dif.AOEArea = (short)(double)o22; break;
					case "AOEAngle": dif.AOEAngle = (short)(double)o22; break;
					case "AOERadius": dif.AOERadius = (float)(double)o22; break;
					case "AOELength": dif.AOELength = (float)(double)o22; break;
					case "AOEWidth": dif.AOEWidth = (float)(double)o22; break;
                    case "BulletModel": dif.BulletModel = (string)o22; break;
					case "BulletPath": dif.BulletPath = (short)(double)o22; break;
					case "Ballistic": dif.Ballistic = (string)o22; break;
					case "DamageEffect": dif.DamageEffect = (string)o22; break;
					case "EffectTime": dif.EffectTime = (float)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ArmyID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ArmyID.ToString());
            Data.Add(dif.ArmyID, dif);
        });
    }

    public armyaoe_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armyaoe_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armyaoe_cInfo> Data = new Dictionary<int, armyaoe_cInfo>();
}


public struct armyaoe_cInfo
{
	 /// <summary>
	 ///兵种ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///AOE目标
	 /// </summary>
	public short AOEAim;
	 /// <summary>
	 ///AOE区域
	 /// </summary>
	public short AOEArea;
	 /// <summary>
	 ///AOE角度
	 /// </summary>
	public short AOEAngle;
	 /// <summary>
	 ///AOE半径
	 /// </summary>
	public float AOERadius;
	 /// <summary>
	 ///AOE长度
	 /// </summary>
	public float AOELength;
	 /// <summary>
	 ///AOE宽度
	 /// </summary>
	public float AOEWidth;
	 /// <summary>
	 ///子弹模型
	 /// </summary>
	public string BulletModel;
	 /// <summary>
	 ///子弹轨迹
	 /// </summary>
	public short BulletPath;
	 /// <summary>
	 ///弹道特效
	 /// </summary>
	public string Ballistic;
	 /// <summary>
	 ///范围伤害特效
	 /// </summary>
	public string DamageEffect;
	 /// <summary>
	 ///特效持续时间
	 /// </summary>
	public float EffectTime;
}
