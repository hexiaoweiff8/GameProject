using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 行为参数包装类工厂
/// </summary>
public class FormulaParamsPackerFactroy
{
    // 生产FormulaParamsPacker类
    /// <summary>
    /// 单例
    /// </summary>
    public static FormulaParamsPackerFactroy Single
    {
        get
        {
            if (single == null)
            {
                single = new FormulaParamsPackerFactroy();
            }
            return single;
        }
    }

    /// <summary>
    /// 单例
    /// </summary>
    private static FormulaParamsPackerFactroy single = null;


    /// <summary>
    /// 创建技能数据包装类
    /// 点对点方式
    /// </summary>
    /// <param name="startPos">技能起始位置</param>
    /// <param name="targetPos">技能目标位置</param>
    /// <param name="targetMaxCount">技能目标上限 如果-1则无数量限制</param>
    /// <returns>数据包装类</returns>
    public FormulaParamsPacker GetFormulaParamsPacker(Vector3 startPos, Vector3 targetPos, int targetMaxCount)
    {
        var result = new FormulaParamsPacker
        {
            StartPos = startPos,
            TargetPos = targetPos,
            TargetMaxCount = targetMaxCount
        };

        return result;
    }

    /// <summary>
    /// 创建技能数据包装类
    /// 对象对对象方式
    /// </summary>
    /// <param name="startObj">起始对象</param>
    /// <param name="targetObj">目标对象</param>
    /// <param name="targetMaxCount">技能目标上限 如果-1则无数量限制</param>
    /// <returns>数据包装类</returns>
    public FormulaParamsPacker GetFormulaParamsPacker(DisplayOwner startObj, DisplayOwner targetObj, int targetMaxCount)
    {
        var result = new FormulaParamsPacker()
        {
            ReleaseMember = startObj,
            ReceiverMenber = targetObj,
            TargetMaxCount = targetMaxCount
        };

        return result;
    }


    /// <summary>
    /// 创建技能数据包装类
    /// 对象对对象方式
    /// </summary>
    /// <param name="startPos">技能起始位置</param>
    /// <param name="targetPos">技能目标位置</param>
    /// <param name="startObj">起始对象</param>
    /// <param name="targetObj">目标对象</param>
    /// <param name="targetMaxCount">技能目标上限 如果-1则无数量限制</param>
    /// <returns>数据包装类</returns>
    public FormulaParamsPacker GetFormulaParamsPacker(Vector3 startPos, Vector3 targetPos, DisplayOwner startObj, DisplayOwner targetObj, int targetMaxCount)
    {
        var result = new FormulaParamsPacker()
        {
            ReleaseMember = startObj,
            ReceiverMenber = targetObj,
            TargetMaxCount = targetMaxCount
        };

        return result;
    }

    /// <summary>
    /// 获取图形范围内的单位数据包列表
    /// </summary>
    /// <param name="graphics">图形类</param>
    /// <param name="startObj">起始点(释放技能单位)</param>
    /// <param name="camp">阵营</param>
    /// <param name="targetMaxCount">获取最大数量单位</param>
    /// <returns></returns>
    public IList<FormulaParamsPacker> GetFormulaParamsPackerList(ICollisionGraphics graphics, DisplayOwner startObj, TargetCampsType camp, int targetMaxCount)
    {
        if (graphics == null || startObj == null)
        {
            return null;
        }
        // 获取集群中的单位列表
        IList<FormulaParamsPacker> result = null;

        var positionObjList = ClusterManager.Single.GetPositionObjectListByGraphics(graphics);
        if (positionObjList != null && positionObjList.Count != 0)
        {
            result = new List<FormulaParamsPacker>();
            for (var i = 0; i < positionObjList.Count; i++)
            {
                // 最大数量
                if (targetMaxCount > 0 && result.Count >= targetMaxCount)
                {
                    break;
                }
                var posObj = positionObjList[i];

                //判断阵营
                var camps = -1;
                switch (camp)
                {
                    // 非己方
                    case TargetCampsType.Different:
                        camps = 1;
                        break;
                    // 己方
                    case TargetCampsType.Same:
                        camps = 2;
                        break;
                }
                // 如果不是对应阵营排除
                if (posObj.MemberData.Camp == camps)
                {
                    continue;
                }

                // 查询外层持有类
                var targetDisplayOwner = DisplayerManager.Single.GetElementById(posObj.MemberData.ObjID);
                // 加入列表
                result.Add(new FormulaParamsPacker()
                {
                    ReleaseMember = startObj,
                    StartPos = startObj.GameObj.transform.position,
                    ReceiverMenber = targetDisplayOwner,
                    TargetPos = posObj.transform.position
                });
            }
        }

        return result;
    }

    /// <summary>
    /// 获取图形范围内的单位数据包列表
    /// </summary>
    /// <param name="graphics">图形类</param>
    /// <param name="startPos">起始点(释放技能单位)</param>
    /// <param name="camp">阵营</param>
    /// <param name="targetMaxCount">获取最大数量单位</param>
    /// <returns></returns>
    public IList<FormulaParamsPacker> GetFormulaParamsPackerList(ICollisionGraphics graphics, Vector3 startPos, TargetCampsType camp, int targetMaxCount)
    {
        if (graphics == null)
        {
            return null;
        }
        // 获取集群中的单位列表
        IList<FormulaParamsPacker> result = null;

        var positionObjList = ClusterManager.Single.GetPositionObjectListByGraphics(graphics);
        if (positionObjList != null && positionObjList.Count != 0)
        {
            result = new List<FormulaParamsPacker>();
            for (var i = 0; i < positionObjList.Count; i++)
            {
                // 最大数量
                if (targetMaxCount > 0 && result.Count >= targetMaxCount)
                {
                    break;
                }
                var posObj = positionObjList[i];

                //判断阵营
                var camps = -1;
                switch (camp)
                {
                    // 非己方
                    case TargetCampsType.Different:
                        camps = 1;
                        break;
                    // 己方
                    case TargetCampsType.Same:
                        camps = 2;
                        break;
                }
                // 如果不是对应阵营排除
                if (posObj.MemberData.Camp == camps)
                {
                    continue;
                }

                // 查询外层持有类
                var targetDisplayOwner = DisplayerManager.Single.GetElementById(posObj.MemberData.ObjID);
                // 加入列表
                result.Add(new FormulaParamsPacker()
                {
                    StartPos = startPos,
                    ReceiverMenber = targetDisplayOwner,
                    TargetPos = posObj.transform.position
                });
            }
        }

        return result;
    }

}