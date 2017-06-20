using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


/// <summary>
/// 目标点范围攻击
/// 目标点范围内受攻击
/// </summary>
public class PointToPositionScopeGeneralAttack : IGeneralAttack
{

    /// <summary>
    /// 特效
    /// </summary>
    private EffectBehaviorAbstract effect = null;


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="attacker">攻击者</param>
    /// <param name="effectKey">特效key(或Path)数组(第一个为飞行特效, 第二个为范围特效)</param>
    /// <param name="releasePos">发射点</param>
    /// <param name="targetPos">目标点</param>
    /// <param name="scopeRaduis">范围伤害半径</param>
    /// <param name="speed">飞行速度</param>
    /// <param name="durTime">范围特效持续时间</param>
    /// <param name="taType">弹道类型</param>
    /// <param name="callback">完成回调</param>
    public PointToPositionScopeGeneralAttack(PositionObject attacker, 
        string[] effectKey, 
        Vector3 releasePos, 
        Vector3 targetPos, 
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
            var positionScopeAttack = new PositionScopeGeneralAttack(attacker,
                key2, 
                targetPos, 
                scopeRaduis,
                durTime, 
                callback);
            positionScopeAttack.Begin();
        };
        //if (callback != null)
        //{
        //    // 先调用伤害在调用回调
        //    scopeDemage += callback;
        //}

        // 飞行轨迹
        effect = EffectsFactory.Single.CreatePointToPointEffect(key1, 
            ParentManager.Instance().GetParent(ParentManager.BallisticParent).transform,
            releasePos, 
            targetPos, 
            new Vector3(1, 1, 1), 
            speed, taType, 
            scopeDemage, 
            Utils.EffectLayer);
    }

    public void Begin()
    {
        if (effect != null)
        {
            effect.Begin();
        }
    }
}

