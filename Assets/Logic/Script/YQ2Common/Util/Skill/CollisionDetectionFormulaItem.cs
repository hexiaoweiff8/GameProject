using System.Collections.Generic;

/// <summary>
/// 碰撞检测器
/// </summary>
public class CollisionDetectionFormulaItem : IFormulaItem
{
    /// <summary>
    /// 当前数据层级
    /// </summary>
    public int Level { get; private set; }

    /// <summary>
    /// 行为类型
    /// 0: 不等待其执行结束继续
    /// 1: 等待期执行结束调用callback
    /// </summary>
    public int FormulaType { get; private set; }

    /// <summary>
    /// 选取目标数量上限
    /// </summary>
    public int TargetCount { get; private set; }

    /// <summary>
    /// 接收技能位置
    /// </summary>
    public int ReceivePos { get; private set; }

    /// <summary>
    /// 目标阵营
    /// </summary>
    public TargetCampsType TargetCamps { get; private set; }

    /// <summary>
    /// 检测范围形状
    /// </summary>
    public GraphicType ScopeType { get; private set; }

    /// <summary>
    /// 范围描述参数
    /// </summary>
    public float[] ScopeParams { get; private set; }

    /// <summary>
    /// 技能ID
    /// </summary>
    public int SkillNum { get; private set; }

    /// <summary>
    /// 初始化碰撞检测
    /// </summary>
    /// <param name="formulaType">行为单元类型(0: 不等待, 1: 等待)</param>
    /// <param name="targetCount">目标数量</param>
    /// <param name="receivePos">接收技能方(0: 放技能方, 1: 目标方)</param>
    /// <param name="targetCamps">目标阵营</param>
    /// <param name="scopeType">范围类型</param>
    /// <param name="scopeParams">范围参数</param>
    /// <param name="skillNum">释放技能ID</param>
    public CollisionDetectionFormulaItem(int formulaType, int targetCount, int receivePos, TargetCampsType targetCamps, GraphicType scopeType, float[] scopeParams, int skillNum)
    {
        FormulaType = formulaType;
        TargetCount = targetCount;
        ReceivePos = receivePos;
        TargetCamps = targetCamps;
        ScopeType = scopeType;
        ScopeParams = scopeParams;
        SkillNum = skillNum;
    }

    /// <summary>
    /// 生成行为单元
    /// </summary>
    /// <returns>行为单元对象</returns>
    public IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            return null;
        }
        IFormula result = null;

        result = new Formula((callback) =>
        {
            // TODO 技能数据应该在paramsPacker中

            // 检测范围
            // 获取图形对象
            ICollisionGraphics graphics = null;
            var pos = ReceivePos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            switch (ScopeType)
            {
                case GraphicType.Circle:
                    // 圆形
                    graphics = new CircleGraphics(pos, ScopeParams[0]);
                    break;

                case GraphicType.Rect:
                    // 矩形
                    graphics = new RectGraphics(pos, ScopeParams[0], ScopeParams[1], ScopeParams[2]);
                    break;

                case GraphicType.Sector:
                    // 扇形
                    graphics = new SectorGraphics(pos, ScopeParams[2], ScopeParams[0], ScopeParams[1]);
                    break;
            }

            // TODO 获得单位列表后将他们压入堆栈
            var packerList = FormulaParamsPackerFactroy.Single.GetFormulaParamsPackerList(graphics, paramsPacker.StartPos, TargetCamps,
                paramsPacker.TargetMaxCount);
            // 对他们释放技能(技能编号)
            if (packerList != null)
            {
                foreach (var packer in packerList)
                {
                    SkillManager.Single.DoSkillNum(SkillNum, packer);
                }
            }
        });
       

        return result;
    }




}

/// <summary>
/// 目标阵营类型
/// </summary>
public enum TargetCampsType
{
    All = -1,
    Same = 0,
    Different = 1
}
