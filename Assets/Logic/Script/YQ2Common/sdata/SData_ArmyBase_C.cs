using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armybase_c : MonoEX.Singleton<SData_armybase_c>
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
            armybase_cInfo dif = new armybase_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "ArmyID": dif.ArmyID = (int)(double)o22; break;
					case "ArmyLevel": dif.ArmyLevel = (short)(double)o22; break;
					case "Name": dif.Name = (string)o22; break;
					case "AimGeneralType": dif.AimGeneralType = (short)(double)o22; break;
					case "DeployTime": dif.DeployTime = (float)(double)o22; break;
					case "GeneralType": dif.GeneralType = (short)(double)o22; break;
					case "ArmyType": dif.ArmyType = (short)(double)o22; break;
					case "IsCreature": dif.IsCreature = (short)(double)o22; break;
					case "RangeType": dif.RangeType = (short)(double)o22; break;
					case "IsSummoned": dif.IsSummoned = (short)(double)o22; break;
					case "BehaviorType": dif.BehaviorType = (short)(double)o22; break;
					case "Attack1": dif.Attack1 = (float)(double)o22; break;
					case "Clipsize1": dif.Clipsize1 = (short)(double)o22; break;
					case "AttackRate1": dif.AttackRate1 = (float)(double)o22; break;
					case "ReloadTime1": dif.ReloadTime1 = (float)(double)o22; break;
					case "Accuracy": dif.Accuracy = (float)(double)o22; break;
					case "SpaceSet": dif.SpaceSet = (float)(double)o22; break;
					case "SpreadRange": dif.SpreadRange = (float)(double)o22; break;
					case "Defence": dif.Defence = (float)(double)o22; break;
					case "HP": dif.HP = (float)(double)o22; break;
					case "MoveSpeed": dif.MoveSpeed = (float)(double)o22; break;
					case "Dodge": dif.Dodge = (float)(double)o22; break;
					case "Hit": dif.Hit = (float)(double)o22; break;
					case "AntiArmor": dif.AntiArmor = (float)(double)o22; break;
					case "Armor": dif.Armor = (float)(double)o22; break;
					case "AntiCrit": dif.AntiCrit = (float)(double)o22; break;
					case "Crit": dif.Crit = (float)(double)o22; break;
					case "CritDamage": dif.CritDamage = (float)(double)o22; break;
					case "BulletType": dif.BulletType = (short)(double)o22; break;
					case "BulletSpeed": dif.BulletSpeed = (float)(double)o22; break;
					case "BulletModel": dif.BulletModel = (string)o22; break;
					case "BulletPath": dif.BulletPath = (short)(double)o22; break;
					case "MuzzleFlash": dif.MuzzleFlash = (string)o22; break;
					case "Ballistic": dif.Ballistic = (string)o22; break;
					case "GetHit": dif.GetHit = (string)o22; break;
					case "AttackType": dif.AttackType = (short)(double)o22; break;
					case "AttackRange": dif.AttackRange = (float)(double)o22; break;
					case "SightRange": dif.SightRange = (float)(double)o22; break;
					case "SkillRange": dif.SkillRange = (float)(double)o22; break;
					case "IsHide": dif.IsHide = (short)(double)o22; break;
					case "IsAntiHide": dif.IsAntiHide = (short)(double)o22; break;
					case "LifeTime": dif.LifeTime = (float)(double)o22; break;
					case "Skill1": dif.Skill1 = (int)(double)o22; break;
					case "Skill2": dif.Skill2 = (int)(double)o22; break;
					case "Skill3": dif.Skill3 = (int)(double)o22; break;
					case "Skill4": dif.Skill4 = (int)(double)o22; break;
					case "Skill5": dif.Skill5 = (int)(double)o22; break;
					case "Pack": dif.Pack = (string)o22; break;
					case "Texture": dif.Texture = (string)o22; break;
					case "Prefab": dif.Prefab = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public armybase_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armybase_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armybase_cInfo> Data = new Dictionary<int, armybase_cInfo>();
}


public struct armybase_cInfo
{
	 /// <summary>
	 ///唯一标识
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///兵种标识ID
	 /// </summary>
	public int ArmyID;
	 /// <summary>
	 ///兵种等级
	 /// </summary>
	public short ArmyLevel;
	 /// <summary>
	 ///兵种名称
	 /// </summary>
	public string Name;
	 /// <summary>
	 ///目标空地类型
	 /// </summary>
	public short AimGeneralType;
	 /// <summary>
	 ///部署时间
	 /// </summary>
	public float DeployTime;
	 /// <summary>
	 ///自身空地建筑属性总类型
	 /// </summary>
	public short GeneralType;
	 /// <summary>
	 ///种族类型
	 /// </summary>
	public short ArmyType;
	 /// <summary>
	 ///机械生命属性
	 /// </summary>
	public short IsCreature;
	 /// <summary>
	 ///攻击距离属性
	 /// </summary>
	public short RangeType;
	 /// <summary>
	 ///主体/召唤
	 /// </summary>
	public short IsSummoned;
	 /// <summary>
	 ///行为类型
	 /// </summary>
	public short BehaviorType;
	 /// <summary>
	 ///火力
	 /// </summary>
	public float Attack1;
	 /// <summary>
	 ///弹容量
	 /// </summary>
	public short Clipsize1;
	 /// <summary>
	 ///攻击速度
	 /// </summary>
	public float AttackRate1;
	 /// <summary>
	 ///装填时间
	 /// </summary>
	public float ReloadTime1;
	 /// <summary>
	 ///精准度
	 /// </summary>
	public float Accuracy;
	 /// <summary>
	 ///体积
	 /// </summary>
	public float SpaceSet;
	 /// <summary>
	 ///散布半径
	 /// </summary>
	public float SpreadRange;
	 /// <summary>
	 ///防御
	 /// </summary>
	public float Defence;
	 /// <summary>
	 ///生命
	 /// </summary>
	public float HP;
	 /// <summary>
	 ///移速
	 /// </summary>
	public float MoveSpeed;
	 /// <summary>
	 ///闪避率
	 /// </summary>
	public float Dodge;
	 /// <summary>
	 ///命中率
	 /// </summary>
	public float Hit;
	 /// <summary>
	 ///穿甲
	 /// </summary>
	public float AntiArmor;
	 /// <summary>
	 ///装甲
	 /// </summary>
	public float Armor;
	 /// <summary>
	 ///防暴率
	 /// </summary>
	public float AntiCrit;
	 /// <summary>
	 ///暴击率
	 /// </summary>
	public float Crit;
	 /// <summary>
	 ///暴击伤害
	 /// </summary>
	public float CritDamage;
	 /// <summary>
	 ///子弹类型
	 /// </summary>
	public short BulletType;
	 /// <summary>
	 ///子弹速度
	 /// </summary>
	public float BulletSpeed;
	 /// <summary>
	 ///子弹模型
	 /// </summary>
	public string BulletModel;
	 /// <summary>
	 ///子弹轨迹
	 /// </summary>
	public short BulletPath;
	 /// <summary>
	 ///枪口火焰
	 /// </summary>
	public string MuzzleFlash;
	 /// <summary>
	 ///弹道特效
	 /// </summary>
	public string Ballistic;
	 /// <summary>
	 ///受击特效组
	 /// </summary>
	public string GetHit;
	 /// <summary>
	 ///攻击类型（单体/AOE）
	 /// </summary>
	public short AttackType;
	 /// <summary>
	 ///攻击范围
	 /// </summary>
	public float AttackRange;
	 /// <summary>
	 ///视野范围
	 /// </summary>
	public float SightRange;
	 /// <summary>
	 ///技能释放范围
	 /// </summary>
	public float SkillRange;
	 /// <summary>
	 ///是否隐形
	 /// </summary>
	public short IsHide;
	 /// <summary>
	 ///是否反隐
	 /// </summary>
	public short IsAntiHide;
	 /// <summary>
	 ///生存时间
	 /// </summary>
	public float LifeTime;
	 /// <summary>
	 ///技能1
	 /// </summary>
	public int Skill1;
	 /// <summary>
	 ///技能2
	 /// </summary>
	public int Skill2;
	 /// <summary>
	 ///技能3
	 /// </summary>
	public int Skill3;
	 /// <summary>
	 ///技能4
	 /// </summary>
	public int Skill4;
	 /// <summary>
	 ///技能5
	 /// </summary>
	public int Skill5;
	 /// <summary>
	 ///包名
	 /// </summary>
	public string Pack;
	 /// <summary>
	 ///贴图
	 /// </summary>
	public string Texture;
	 /// <summary>
	 ///预制体
	 /// </summary>
	public string Prefab;
}
