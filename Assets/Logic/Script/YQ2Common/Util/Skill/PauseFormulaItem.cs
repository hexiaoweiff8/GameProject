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
    /// 行为节点类型
    /// </summary>
    public int FormulaType { get { return Formula.FormulaWaitType; } }

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
    public PauseFormulaItem(string[] array) { }

    /// <summary>
    /// 获取行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns>暂停行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        // 数据本地化
        var myCheckTime = CheckTime;
        return new Formula((callback) =>
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
    }
}
