using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using Util;

/// <summary>
/// 暂停
/// </summary>
public class PauseFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 检查时间间隔
    /// </summary>
    public float CheckTime = 0.1f;

    /// <summary>
    /// 初始化
    /// </summary>
    public PauseFormulaItem() { }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    public PauseFormulaItem(string[] array)
    {
        FormulaType = 1;
    }

    /// <summary>
    /// 获取行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns>暂停行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        // 数据本地化
        var myCheckTime = CheckTime;

        result = new Formula((callback, scope) =>
        {
            //Debug.Log("Pause");
            var timer = new Timer(myCheckTime);
            Action completeCallback = () => { };

            completeCallback = () =>
            {
                if (SkillManager.isPause)
                {
                    // 继续暂停
                    timer = new Timer(myCheckTime);
                    timer.OnCompleteCallback(completeCallback).Start();
                }
                else
                {
                    // 暂停结束
                    callback();
                }
            };

            timer.OnCompleteCallback(completeCallback);
            timer.Start();
        }, FormulaType);

        return result;
    }

    ///// <summary>
    ///// 检查数据是否合法
    ///// </summary>
    ///// <param name="paramsPacker"></param>
    ///// <returns></returns>
    //private bool CheckData(FormulaParamsPacker paramsPacker)
    //{
    //    if (paramsPacker.ReceiverMenber.ClusterData == null || paramsPacker.ReleaseMember.ClusterData == null)
    //    {
    //        return false;
    //    }
    //    return true;
    //}
}
