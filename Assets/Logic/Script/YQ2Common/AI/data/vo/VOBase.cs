using UnityEngine;
using System.Collections;

public class VOBase
{
    private int _voType;
    private float _totalHP;
    private float _currentHP;
    private int _entityID;
    private string _name;
    private string _ziyuanbaoming;
    private ObjectID _objID;

    private int _armyID;
    private short _armyType;
    private float _armor;
    private float _antiArmor;
    private float _antiCrit;
    private float _crit;
    private float _dodge;
    private float _hit;
    private float _attackRange;
    private float _moveSpeed;
    private string _modelID;
    private int _camp;



    public int UniqueID;
    /// <summary>
    /// 兵种等级
    /// </summary>
    public short ArmyLevel;
    /// <summary>
    /// 目标空地类型
    /// </summary>
    public short AimGeneralType;
    /// <summary>
    /// 部署时间
    /// </summary>
    public float DeployTime;
    /// <summary>
    /// 自身空地建筑属性总类型
    /// </summary>
    public short GeneralType;
    /// <summary>
    /// 火力
    /// </summary>
    public float Attack1;
  
    /// <summary>
    /// 弹容量
    /// </summary>
    public short Clipsize1;

    /// <summary>
    /// 攻击速度
    /// </summary>
    public float AttackRate1;
  
    /// <summary>
    /// 装填时间
    /// </summary>
    public float ReloadTime1;
   
    /// <summary>
    /// 精准度
    /// </summary>
    public float Accuracy;
    /// <summary>
    /// 体积因子(受击半径)
    /// </summary>
    public float SpaceSet;
    /// <summary>
    /// 散布半径
    /// </summary>
    public float SpreadRange;
    /// <summary>
    /// 防御
    /// </summary>
    public float Defence;
    /// <summary>
    /// 弹道抛射角度值
    /// </summary>
    public float BallisticsAngle;
    /// <summary>
    /// 爆击伤害
    /// </summary>
    public float CritDamage;
    /// <summary>
    /// 子弹类型
    /// </summary>
    public short BulletType;
    /// <summary>
    /// 子弹速度
    /// </summary>
    public float BulletSpeed;
    /// <summary>
    /// 攻击类型（单体/AOE）
    /// </summary>
    public short AttackType;
    /// <summary>
    /// 多目标攻击上限
    /// </summary>
    public short MultiAimMax;
    /// <summary>
    ///视野范围
    /// </summary>
    public float SightRange;
    /// <summary>
    /// 是否隐形
    /// </summary>
    public bool IsHide;
    /// <summary>
    /// 是否反隐形
    /// </summary>
    public bool IsAntiHide;
    /// <summary>
    /// 生存时间
    /// </summary>
    public float LifeTime; 
    /// <summary>
    /// 技能1
    /// </summary>
    public int Skill1;
    /// <summary>
    /// 技能2
    /// </summary>
    public int Skill2;
    /// <summary>
    /// 技能3
    /// </summary>
    public int Skill3;
    /// <summary>
    /// 技能4
    /// </summary>
    public int Skill4;
    /// <summary>
    /// 技能5
    /// </summary>
    public int Skill5;


    /// <summary>
    /// 穿甲属性
    /// </summary>
    public float AntiArmor
    {
        get { return _antiArmor; }
        set { _antiArmor = value; }
    }
    /// <summary>
    /// 对应的模型资源文件名
    /// </summary>
    public string ModelID
    {
        get { return _modelID; }
        set { _modelID = value; }
    }

    /// <summary>
    /// 战斗中的移动速度
    /// </summary>
    public float MoveSpeed
    {
        get { return _moveSpeed; }
        set { _moveSpeed = value; }
    }
    /// <summary>
    /// 攻击范围
    /// </summary>
    public float AttackRange
    {
        get { return _attackRange; }
        set { _attackRange = value; }
    }
    /// <summary>
    /// 命中
    /// </summary>
    public float Hit
    {
        get { return _hit; }
        set { _hit = value; }
    }
    /// <summary>
    /// 闪避
    /// </summary>
    public float Dodge
    {
        get { return _dodge; }
        set { _dodge = value; }
    }
    /// <summary>
    /// 暴击概率
    /// </summary>
    public float Crit
    {
        get { return _crit; }
        set { _crit = value; }
    }
    /// <summary>
    /// 防爆率
    /// </summary>
    public float AntiCrit
    {
        get { return _antiCrit; }
        set { _antiCrit = value; }
    }
    /// <summary>
    /// 护甲
    /// </summary>
    public float Armor
    {
        get { return _armor; }
        set { _armor = value; }
    }

    /// <summary>
    /// 自身大兵种类型
    /// </summary>
    public short ArmyType
    {
        get { return _armyType; }
        set { _armyType = value; }
    }
    /// <summary>
    /// 
    /// </summary>
    public int ArmyID
    {
        get { return _armyID; }
        set { _armyID = value; }
    }
    /// <summary>
    /// 存储在vo类身上的ObjectID 通过它 把数据和显示对象关联
    /// </summary>
    public ObjectID ObjID
    {
        get { return _objID; }
        set { _objID = value; }
    }
    
    /// <summary>
    /// 模版中存储的名字 
    /// </summary>
    public string Name
    {
        get { return _name; }
        set { _name = value; }
    }

    public string ZiYuanBaoMing
    {
        get { return _ziyuanbaoming; }
        set { _ziyuanbaoming = value; }
    }

    /// <summary>
    /// 数据类型 1.普通单位 2.机甲单位 3.建筑物  
    /// </summary>
    public int VOType
    {
        get { return _voType; }
        set { _voType = value; }
    }
    /// <summary>
    /// 总血量所有可被攻击的对象都有总血量和血量属性
    /// </summary>
    public float TotalHp
    {
        get { return _totalHP; }
        set { _totalHP = value; }
    }
    /// <summary>
    /// 当前实际血量[0,TotalHp]
    /// </summary>
    public float CurrentHP
    {
        get { return _currentHP; }
        set
        {
            _currentHP = value;
            _currentHP = Mathf.Max(0,Mathf.Min(_currentHP, TotalHp));
        }
    }

    /// <summary>
    /// 对象的实体ID 唯一id 
    /// </summary>
    public int EntityID
    {
        get { return _entityID; }
        set { _entityID = value; }
    }

    /// <summary>
    /// 定义玩家的阵营1，我方 2 敌方
    /// </summary>
    public int Camp
    {
        get { return _camp; }
        set { _camp = value; }
    }
    //----------------------------字段声明都在上半部分---------------------------------


    /// <summary>
    /// 装填单位属性
    /// </summary>
    public void SetSoldierData(armybase_cInfo data)
    {
        Name = data.Name;
        ArmyID = data.ArmyID;
        ArmyType = data.ArmyType;
        TotalHp = data.HP;
        CurrentHP = TotalHp;
        Armor = data.Armor;
        AntiArmor = data.AntiArmor;
        AntiCrit = data.AntiCrit;
        Crit = data.Crit;
        Dodge = data.Dodge;
        Hit = data.Hit;
        AttackRange = data.AttackRange;
        MoveSpeed = data.MoveSpeed;
        ModelID = data.ModelID;
        UniqueID = data.UniqueID;
        ArmyLevel = data.ArmyLevel;
        AimGeneralType = data.AimGeneralType;
        DeployTime = data.DeployTime;
        GeneralType = data.GeneralType;
        Attack1 = data.Attack1;
        Clipsize1 = data.Clipsize1;
        AttackRate1 = data.AttackRate1;
        ReloadTime1 = data.ReloadTime1;
        Accuracy = data.Accuracy;
        SpaceSet = data.SpaceSet;
        SpreadRange = data.SpreadRange;
        Defence = data.Defence;
        CritDamage = data.CritDamage;
        BulletType = data.BulletType;
        BulletSpeed = data.BulletSpeed;
        AttackType = data.AttackType;
        MultiAimMax = data.MultiAimMax;
        SightRange = data.SightRange;
        IsHide = data.IsHide == 1;
        IsAntiHide = data.IsAntiHide == 1;
        LifeTime = data.LifeTime;
        Skill1 = data.Skill1;
        Skill2 = data.Skill2;
        Skill3 = data.Skill3;
        Skill4 = data.Skill4;
        Skill5 = data.Skill5;
    }
}
