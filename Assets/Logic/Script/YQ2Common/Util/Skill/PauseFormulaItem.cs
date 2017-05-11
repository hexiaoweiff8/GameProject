using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Util;

/// <summary>
/// 暂停
/// </summary>
public class PauseFormulaItem : IFormulaItem
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
    /// 获取行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns>暂停行为节点</returns>
    public IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        return new Formula((callback) =>
        {
            var timer = new Timer(CheckTime);
            Action completeCallback = () => { };

            completeCallback = () =>
            {
                if (SkillManager.isPause)
                {
                    // 继续暂停
                    timer = new Timer(CheckTime);
                    timer.OnCompleteCallback(completeCallback);
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
