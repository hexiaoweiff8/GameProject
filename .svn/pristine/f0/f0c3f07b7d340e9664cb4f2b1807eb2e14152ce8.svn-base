using UnityEngine;
using System.Collections;
/// <summary>
/// 所有游戏可显示对象的唯一抽象id
/// </summary>
public class ObjectID {
    public enum ObjectType : int
    {
        /// <summary>
        /// 基地
        /// </summary>
        MyJiDi = 1,
        /// <summary>
        /// 敌方基地
        /// </summary>
        EnemyJiDi = 2,
        /// <summary>
        /// 我方普通士兵
        /// </summary>
        MySoldier= 3,
        /// <summary>
        /// 敌方普通士兵
        /// </summary>
        EnemySoldier = 4,
        /// <summary>
        /// 我方机甲单位
        /// </summary>
        MyTank = 5,
        /// <summary>
        /// 敌方机甲单位
        /// </summary>
        EnemyTank = 6,
        /// <summary>
        /// 我方障碍物 如 我放电网
        /// </summary>
        MyObstacle = 7,
        /// <summary>
        /// 敌方障碍物
        /// </summary>
        EnemyObstacle =8,
        /// <summary>
        /// 中立障碍物 可能有血条 但没有阵营
        /// </summary>
        NPCObstacle = 9
    }
    /// <summary>
    /// 所有可显示对象起始id
    /// </summary>
    private static int _id = 0;
    /// <summary>
    /// 临时变量 接收静态_id的值 避免将_id直接对外
    /// </summary>
    private int tempID = 0;

    private ObjectType _objType;

    public ObjectType ObjType
    {
        get { return _objType; }
    }

    /// <summary>
    /// 所有可显示对象起始id
    /// </summary>
    public int ID
    {
        get { return tempID; }
    }
    /// <summary>
    /// 每次创建ObjectID id递增
    /// </summary>
    /// <param name="objType"></param>
    public ObjectID(ObjectType objType = 0)
    {
        _id++;
        tempID = _id;
        _objType = objType;
    }
}
