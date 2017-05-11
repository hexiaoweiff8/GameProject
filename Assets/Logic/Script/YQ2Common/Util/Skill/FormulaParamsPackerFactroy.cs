using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
    public FormulaParamsPacker GetFormulaParamsPacker(GameObject startObj, GameObject targetObj, int targetMaxCount)
    {
        var result = new FormulaParamsPacker()
        {
            StartObj = startObj,
            TargetObj = targetObj,
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
    public FormulaParamsPacker GetFormulaParamsPacker(Vector3 startPos, Vector3 targetPos, GameObject startObj, GameObject targetObj, int targetMaxCount)
    {
        var result = new FormulaParamsPacker()
        {
            StartObj = startObj,
            TargetObj = targetObj,
            TargetMaxCount = targetMaxCount
        };

        return result;
    }


    public IList<FormulaParamsPacker> GetFormulaParamsPackerList(ICollisionGraphics graphics, GameObject startObj, int targetMaxCount)
    {
        // 获取集群中的单位列表
        IList<FormulaParamsPacker> result = null;



        return result;
    }

}