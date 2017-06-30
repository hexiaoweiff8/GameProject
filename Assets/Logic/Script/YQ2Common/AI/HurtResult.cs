using System;
using UnityEngine;
using System.Collections;

public class HurtResult
{
    /// <summary>
    /// 普通战斗伤害结算
    /// </summary>
    /// <param name="active">伤害发起的主动方</param>
    /// <param name="target">伤害被动方</param>
    /// <returns></returns>
    public static float GetHurt(DisplayOwner active, DisplayOwner target)
    {
        var zhanqianJueduizhi = active.ClusterData.AllData.MemberData.Attack1;
        var zhandouJueduizhiAdd = 0.0f;
        var zhanqianBaifenbiAdd = 0.0f;
        var zhandouBaifenbiAdd = 0.0f;

        var huoli = (zhanqianJueduizhi + zhandouJueduizhiAdd)*(1 + zhanqianBaifenbiAdd + zhandouBaifenbiAdd);
        var baojixishu = AdjustIsBaoji(active, target);
        var hurtAdd = 0.0f;
        var antiHurtAdd = 0.0f;
        var jianshanglv = AdjustJianshang(active, target);
        var kezhixishu = AdjustKezhi(active, target);

        var shanghaijiacheng = 0.0f;
        var mianyijiacheng = 0.0f;
        var jinengjiacheng = 0.0f;

        /**
         * 最终伤害=进攻方火力*（1-减伤率）*（IF（本次暴击，暴击伤害系数，1））*
         * （IF（满足克制关系，1+克制伤害加成，1））*
         * （1+Max（-40%，（进攻方伤害加成-防守方免伤加成）））+
         * 攻守双方技能绝对值加成和
         * */
        var hurt = huoli*(1 - jianshanglv)*baojixishu*kezhixishu*
                   (1 + Mathf.Max(-0.4f,(shanghaijiacheng - mianyijiacheng))) + jinengjiacheng;
        return hurt;

    }

    /// <summary>
    /// 计算技能伤害/治疗
    /// </summary>
    /// <param name="target">技能目标</param>
    /// <param name="type">伤害或治疗</param>
    /// <param name="unitType">伤害/治疗值类型</param>
    /// <param name="value">具体值, 必须大于等于0</param>
    /// <returns>伤害/治疗具体量</returns>
    public static float GetHurtForSkill(DisplayOwner target, DemageOrCure type, HealthChangeType unitType, float value)
    {
        if (target == null || target.ClusterData == null || target.ClusterData.AllData.MemberData == null)
        {
            throw new Exception("目标对象为空.");
        }
        if (value < 0)
        {
            throw new Exception("伤害/治疗值不能为负数.");
        }
        var result = value;
        if (unitType == HealthChangeType.Percentage)
        {
            result = target.ClusterData.AllData.MemberData.TotalHp*value;
        }

        // 如果是伤害 则乘-1
        if (type == DemageOrCure.Demage)
        {
            result *= -1;
        }

        return result;
    }

    /// <summary>
    /// 判断是否命中
    /// </summary>
    /// <param name="active">攻击方</param>
    /// <param name="target">被攻击方</param>
    /// <returns>是否命中</returns>
    public static bool AdjustIsMiss(DisplayOwner active, DisplayOwner target)
    {
        /**
         * 计算攻击方【战斗属性-命中率】
            命中率=战前加成和
            战前属性的计算在文档的开始部分
            3.5.2计算进攻方【战斗属性-命中率加成】
            命中率加成=战斗中百分比加成和
            PS1:战斗中加成目前已知来源：被附加的BUFF，友方的光环
            PS2:战斗中的加成因为BUFF的属性，所以这里的加成和是计算增益减益和
            计算防守方【战斗属性-闪避率】
            闪避率=战前加成和
            计算防守方【战斗属性-闪避率加成】
            闪避率加成=战斗中百分比加成和
            计算命中率差值
            命中率差值=Max（30%，进攻方命中率*（1+命中率加成）-防守方闪避率*（1+闪避率加成））
            判定攻击是否命中
            在1-1000中取随机整数a
	        如果a<=命中率差值*1000,判定为命中
	        如果a>命中率差值*1000,判定为闪避
        **/
        if (null == target || null == target.ClusterData || target.ClusterData.AllData.MemberData.CurrentHP <= 0 ||
            null == active || null == active.ClusterData)
        {
            return true;
        }
        var gongjiMingzhong = active.ClusterData.AllData.MemberData.Hit;
        var gongjiMingzhongAdd = 0.0f;

        var fangshouShanbi = target.ClusterData.AllData.MemberData.Dodge;
        var fangshouShanbiAdd = 0.0f;

        var mingzhongchazhi = Mathf.Max(0.3f,
            gongjiMingzhong*(1 + gongjiMingzhongAdd) - fangshouShanbi*(1 + fangshouShanbiAdd));
        var ran = new QKRandom((int)DateTime.Now.Ticks);
        var value = ran.RangeI(0, 1000);
        bool isMiss = value >= mingzhongchazhi*1000;
        return isMiss;
    }

    /// <summary>
    /// 判断是否暴击
    /// </summary>
    /// <param name="active">攻击方</param>
    /// <param name="target">被攻击方</param>
    /// <returns></returns>
    public static float AdjustIsBaoji(DisplayOwner active, DisplayOwner target)
    {
        var gongjiBaoji = active.ClusterData.AllData.MemberData.Crit;
        var gongjiBaojiAdd = 0.0f;

        var fangshouFangbao = target.ClusterData.AllData.MemberData.AntiCrit;
        var fangshouFangbaoAdd = 0.0f;

        var chazhi = Mathf.Max(0, gongjiBaoji*(1 + gongjiBaojiAdd) - fangshouFangbao*(1 + fangshouFangbaoAdd));

        //暴击伤害系数=战前百分比加成和+战斗中百分比加成和
        var beforeFight = 0.0f;
        var inFight = 0.0f;
        var ran = new QKRandom((int)DateTime.Now.Ticks);
        return ran.RangeI(0, 1000) <= chazhi*1000 ? (beforeFight + inFight) : 1;
    }

    /// <summary>
    /// 判断是否穿甲
    /// </summary>
    /// <param name="active">攻击方</param>
    /// <param name="target">被攻击方</param>
    /// <returns></returns>
    public static float AdjustJianshang(DisplayOwner active, DisplayOwner target)
    {
        /**
         *  穿甲=（战前值+战斗中绝对值加成和）*（1+战前加成和+战斗中百分比加成和）
            PS1:战斗中加成目前已知来源：被附加的BUFF，友方的光环
            PS2:战斗中的加成因为BUFF的属性，所以这里的加成和是计算增益减益和
            防御=（战前值+战斗中绝对值加成和）*（1+战前加成和+战斗中百分比加成和）
            装甲=（战前值+战斗中绝对值加成和）*（1+战前加成和+战斗中百分比加成和）
         * */
        //战斗中绝对值加成和
        var chuanjiaJueduizhiAdd = 0.0f;
        var chuanjiaBaifenbiAdd = 0.0f;
        var chuanjiaZhanqianAdd = 0.0f;

        var chuanjiashuxing = active.ClusterData.AllData.MemberData.AntiArmor;
        var chuanjia = (chuanjiashuxing + chuanjiaJueduizhiAdd)*(1 + chuanjiaZhanqianAdd + chuanjiaBaifenbiAdd);

        var fangyuJueduizhiAdd = 0.0f;
        var fangyuBaifenbiAdd = 0.0f;
        var fangyuZhanqianAdd = 0.0f;

        var fangyuShuxing = target.ClusterData.AllData.MemberData.Defence;
        var fangyu = (fangyuShuxing + chuanjiaJueduizhiAdd)*(1 + fangyuZhanqianAdd + fangyuBaifenbiAdd);

        var zhuangjiaJueduizhiADD = 0.0f;
        var zhuangjiaBaifenbiiADD = 0.0f;
        var zhuangjiaZhanqianADD = 0.0f;

        var zhuangjiaShuxing = target.ClusterData.AllData.MemberData.Armor;
        var zhuangjia = (zhuangjiaShuxing + zhuangjiaJueduizhiADD)*(1 + zhuangjiaZhanqianADD + zhuangjiaBaifenbiiADD);
        //判定攻击是否无视防御或装甲,攻击方有几率无视防御或装甲的技能，在1 - 1000中取随机整数a
        var wushifangyu = 0.0f;
        var wushizhuangjia = 0.0f;

        var ran = new QKRandom((int)DateTime.Now.Ticks);
        var a = ran.RangeI(0, 1000);
        var a1 = ran.RangeI(0, 1000);

        fangyu = a <= wushifangyu*1000 ? 0 : fangyu;
        zhuangjia = a1 <= wushizhuangjia*1000 ? 0 : zhuangjia;

        return (fangyu + Mathf.Max(0, zhuangjia - chuanjia))/
                          (fangyu + Mathf.Max(0, zhuangjia - chuanjia) + 2000);
    }

    /// <summary>
    /// 判断攻守防是否满足克制关系
    /// </summary>
    /// <param name="active"></param>
    /// <param name="target"></param>
    /// <returns></returns>
    public static float AdjustKezhi(DisplayOwner active, DisplayOwner target)
    {
        var config = SData_kezhi_c.Single.GetDataOfID(active.ClusterData.AllData.MemberData.ArmyType);
        if (config.KezhiType == target.ClusterData.AllData.MemberData.ArmyType)
        {
            return 1 + config.KezhiAdd;
        }
        return 1.0f;
    }
}
