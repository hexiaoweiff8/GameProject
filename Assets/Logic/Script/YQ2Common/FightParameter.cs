using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

 
// 战斗类型
public enum FightType
{
    Tuiguan,//推关
    Other//其它
}


//洗练状态
public enum XilianST
{ 
    None = 0,//没有洗练过
    X1A = 11,//1A生效
    X1B = 12,//1B生效
    X2 = 2,//2生效
    X3 = 3,//3生效
}

/// <summary>
/// 装备信息
/// </summary>
public class Equip
{
    public int sid;//静态数据ID
    public XilianST XilianST = XilianST.None;//洗练状态
}

/// <summary>
/// 军队方阵信息
/// </summary>
public class ArmySquareInfo
{
    public int staticHeroID;//英雄数据ID 
    public int soldiersCount;//士兵总数
    public int heroLevel = 1;//英雄等级
    public int soldiersLevel { get { return heroLevel; } }//士兵等级
    public short sxj = 1;//士兵星级
    public short hxj = 1;//英雄星级
    public short[] sklv;//技能等级
    public Equip[] Equips;//道具队列

    public bool zs;//是否已转身
    public byte fid;//和战场阵位对应的id

    public float cd = -1;//手动蓄力 lua层可选属性,如果值>=0有效
    public int hp = -1;//英雄当前生命  -1表示满血
}

/// <summary>
/// 战斗系统入口参数
/// </summary>
public class FightParameter
{
    public List<ArmySquareInfo> Squares = new List<ArmySquareInfo>();//阵法信息
    public ArmySquareInfo QixiSquare = null;//奇袭阵

    public string Music;//背景音乐
    public int sceneID;//场景ID
    public FightType fightType = FightType.Tuiguan;//战斗类型
    public int tuiguan_zhang = 1;//推关章
    public int tuiguan_jie = 1;//推关节
}