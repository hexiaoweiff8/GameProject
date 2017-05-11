
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
    /// 生成行为单元
    /// </summary>
    /// <returns>行为单元对象</returns>
    IFormula GetFormula(FormulaParamsPacker paramsPacker);
}