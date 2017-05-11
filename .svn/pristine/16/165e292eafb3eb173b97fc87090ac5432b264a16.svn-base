using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 固定障碍物
/// </summary>
public class FixtureData : PositionObject
{
    public FixtureData()
    {
        MemberData = new VOBase();
    }
    public override bool CouldMove
    {
        get { return false; }
    }

    /// <summary>
    /// 物理信息
    /// </summary>
    public override PhysicsInfo PhysicsInfo
    {
        get
        {
            if (physicsInfo == null)
            {
                physicsInfo = new PhysicsInfo();
            }
            if (physicsInfo.Quality < Utils.ApproachZero)
            {
                physicsInfo.Quality = 10000;
            }
            if (physicsInfo.SpeedDirection.magnitude > 0)
            {
                physicsInfo.SpeedDirection = Vector3.zero;
            }
            return physicsInfo;
        }
    }
}