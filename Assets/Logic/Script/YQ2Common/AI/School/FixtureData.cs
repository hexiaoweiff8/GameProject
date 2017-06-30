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
        AllData.MemberData = new VOBase();
        Quality = 10000;
        SpeedDirection = Vector3.zero;
        
    }
    public override bool CouldMove
    {
        get { return false; }
    }

    ///// <summary>
    ///// 物理信息
    ///// </summary>
    //public override PhysicsInfo PhysicsInfo
    //{
    //    get
    //    {
    //        if (physicsInfo == null)
    //        {
    //            physicsInfo = new PhysicsInfo();
    //        }
    //        if (physicsInfo.Quality < Utils.ApproachZero)
    //        {
    //            physicsInfo.Quality = 10000;
    //        }
    //        if (physicsInfo.SpeedDirection.magnitude > 0)
    //        {
    //            physicsInfo.SpeedDirection = Vector3.zero;
    //        }
    //        return physicsInfo;
    //    }
    //}


    ///// <summary>
    ///// 获取障碍物列表
    ///// </summary>
    ///// <param name="mapInfo">地图数据</param>
    ///// <param name="offsetPos">起始位置偏移</param>
    ///// <param name="mapHeight">地图高度</param>
    ///// <param name="mapWidth">地图宽度</param>
    ///// <param name="unitWidth">单位宽度</param>
    ///// <returns>障碍物列表</returns>
    //public static IList<FixtureData> GetFixtureDataList(int[][] mapInfo, Vector3 offsetPos, float mapWidth, float mapHeight, float unitWidth)
    //{
    //    // 验证列表
    //    if (mapInfo == null || unitWidth < 0)
    //    {
    //        return null;
    //    }
    //    var result = new List<FixtureData>();

    //    // 设置偏移
    //    for (var i = 0; i < mapInfo.Length; i++)
    //    {
    //        var row = mapInfo[i];
    //        for (int j = 0; j < row.Length; j++)
    //        {
    //            switch (row[j])
    //            {
    //                case Utils.Obstacle:
    //                    var fixItem = GameObject.CreatePrimitive(PrimitiveType.Cube);
    //                    fixItem.layer = LayerMask.NameToLayer("Scenery");//TODODO 下边测试
    //                    fixItem.name += i;
    //                    var fix = fixItem.AddComponent<FixtureData>();
    //                    fix.MemberData = new VOBase()
    //                    {
    //                        ObjID = new ObjectID(ObjectID.ObjectType.NPCObstacle),
    //                        SpaceSet = 1 * unitWidth
    //                    };
    //                    fix.transform.localScale = new Vector3(unitWidth, unitWidth, unitWidth);
    //                    fix.transform.position = Utils.NumToPosition(offsetPos, new Vector2(j, i), unitWidth, mapWidth, mapHeight);
    //                    fix.X = j * unitWidth - mapWidth * unitWidth * 0.5f + offsetPos.x;
    //                    fix.Y = i * unitWidth - mapHeight * unitWidth * 0.5f + offsetPos.z;
    //                    fix.Diameter = 1 * unitWidth;
    //                    result.Add(fix);
    //                    break;
    //            }
    //        }
    //    }

    //    // 设置单位宽度

    //    return result;
    //}
}