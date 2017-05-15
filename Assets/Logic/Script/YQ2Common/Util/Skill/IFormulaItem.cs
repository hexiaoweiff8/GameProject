
using System;

/// <summary>
/// 行为链单元构造器接口
/// </summary>
public interface IFormulaItem
{
    /// <summary>
    /// 行为类型
    /// 0: 不等待其执行结束继续
    /// 1: 等待期执行结束调用callback
    /// </summary>
    int FormulaType { get; }


    /// <summary>
    /// 下一个节点
    /// </summary>
    IFormulaItem NextFormulaItem { get; set; }

    /// <summary>
    /// 上一个节点
    /// </summary>
    IFormulaItem PreviewFormulaItem { get; set; }

    /// <summary>
    /// 是否包含下一节点
    /// </summary>
    /// <returns>是否有下一节点</returns>
    bool HasNext();

    /// <summary>
    /// 添加下一节点
    /// </summary>
    /// <param name="nextBehavior">下一个节点</param>
    /// <returns>下一个节点</returns>
    IFormulaItem After(IFormulaItem nextBehavior);



    IFormulaItem GetFirst();



    /// <summary>
    /// 生成行为单元
    /// </summary>
    /// <returns>行为单元对象</returns>
    IFormula GetFormula(FormulaParamsPacker paramsPacker);

    /// <summary>
    /// 获得子集行为节点单元
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    IFormulaItem GetSubIFormulaItem();



    /// <summary>
    /// 获得子集行为节点单元
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    IFormulaItem AddSubFormulaItem(IFormulaItem formulaItem);
}


public abstract class AbstractFormulaItem : IFormulaItem
{

    /// <summary>
    /// 行为节点类型
    /// 0: 不等待该节点执行完毕
    /// 1: 等待该节点执行完毕后再继续执行之后的节点
    /// </summary>
    public int FormulaType { get; private set; }

    /// <summary>
    /// 下一节点
    /// </summary>
    public IFormulaItem NextFormulaItem { get; set; }

    /// <summary>
    /// 上一节点
    /// </summary>
    public IFormulaItem PreviewFormulaItem { get; set; }

    /// <summary>
    /// 子行为链
    /// </summary>
    protected IFormulaItem subFormulaItem { get; set; }

    /// <summary>
    /// 是否包含下一节点
    /// </summary>
    /// <returns></returns>
    public bool HasNext()
    {
        if (NextFormulaItem == null)
        {
            return false;
        }
        return true;
    }

    /// <summary>
    /// 添加下一节点
    /// </summary>
    /// <param name="nextBehavior">下一节点</param>
    /// <returns>当前节点</returns>
    public IFormulaItem After(IFormulaItem nextBehavior)
    {
        if (nextBehavior != null)
        {
            // 如果后一个单位不为空则向后移
            if (NextFormulaItem != null)
            {
                NextFormulaItem.After(NextFormulaItem);
            }
            NextFormulaItem = nextBehavior;
            nextBehavior.PreviewFormulaItem = this;

            return nextBehavior;
        }
        return this;
    }

    /// <summary>
    /// 获得行为链的head
    /// </summary>
    /// <returns>行为链Head</returns>
    public IFormulaItem GetFirst()
    {
        IFormulaItem result = this;

        while (result.PreviewFormulaItem != null)
        {
            result = result.PreviewFormulaItem;
        }
        return result;
    }

    /// <summary>
    /// 获取行为节点具体实现
    /// </summary>
    /// <param name="paramsPacker">数据对象</param>
    /// <returns></returns>
    public abstract IFormula GetFormula(FormulaParamsPacker paramsPacker);

    /// <summary>
    /// 获取该节点的子集行为
    /// </summary>
    /// <returns>子集行为链Head</returns>
    public IFormulaItem GetSubIFormulaItem()
    {
        return subFormulaItem;
    }

    /// <summary>
    /// 增加子集行为
    /// </summary>
    /// <param name="formulaItem">被添加进行为链的节点, 不能为null</param>
    /// <returns>当前被添加节点</returns>
    public IFormulaItem AddSubFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        if (subFormulaItem == null)
        {
            subFormulaItem = formulaItem;
        }
        else
        {
            subFormulaItem.After(formulaItem);
        }
        return formulaItem;
    }
}