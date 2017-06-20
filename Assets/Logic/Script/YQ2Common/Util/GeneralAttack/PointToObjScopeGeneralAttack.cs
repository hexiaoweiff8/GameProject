using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 点到对象范围攻击
/// </summary>
public class PointToObjScopeGeneralAttack : IGeneralAttack
{

    private EffectBehaviorAbstract effect;

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="attacker">攻击者数据</param>
    /// <param name="effectKey">子弹预设key(或path)</param>
    /// <param name="releasePos">子弹飞行起点</param>
    /// <param name="targetObj">子弹目标单位</param>
    /// <param name="scopeRaduis">范围半径</param>
    /// <param name="speed">子弹飞行速度</param>
    /// <param name="durTime">范围特效持续时间</param>
    /// <param name="taType">子弹飞行轨迹</param>
    /// <param name="callback">攻击结束回调</param>
    public PointToObjScopeGeneralAttack(PositionObject attacker, 
        string[] effectKey, 
        Vector3 releasePos, 
        GameObject targetObj, 
        float scopeRaduis, 
        float speed, 
        float durTime, 
        TrajectoryAlgorithmType taType, 
        Action callback)
    {
        if (attacker == null)
        {
            throw new Exception("攻击者集群数据为空");
        }
        var key1 = effectKey[0];
        var key2 = effectKey[1];
        // 范围伤害
        Action scopeDemage = () =>
        {
            var positionScopeAttack = new PositionScopeGeneralAttack(attacker, key2, targetObj.transform.position, scopeRaduis,
                durTime, callback);
            positionScopeAttack.Begin();
        };
        //if (callback != null)
        //{
        //    // 先调用伤害在调用回调
        //    scopeDemage += callback;
        //}

        // 飞行轨迹
        effect = EffectsFactory.Single.CreatePointToObjEffect(key1, 
            ParentManager.Instance().GetParent(ParentManager.BallisticParent).transform,
            releasePos, 
            targetObj, 
            new Vector3(1, 1, 1), 
            speed, 
            taType, 
            scopeDemage, 
            Utils.EffectLayer);
    }

    public void Begin()
    {
        effect.Begin();
    }
}
