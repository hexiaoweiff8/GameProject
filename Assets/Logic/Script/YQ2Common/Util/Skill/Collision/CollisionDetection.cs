using System.Collections.Generic;

/// <summary>
/// 碰撞检测器
/// </summary>
public class CollisionDetection : IFormulaItem
{
    // 使用目标选择器选择范围内适合的单位

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
    public CollisionDetection(int formulaType, int targetCount, int receivePos, TargetCampsType targetCamps, GraphicType scopeType, float[] scopeParams, int skillNum)
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

            //// TODO 将图形传入某个类, 传出FormulaParamsPacker列表
            //// 检查范围内对象
            //IList<PositionObject> targetList = new List<PositionObject>();
            //var aroundList = paramsPacker.TargetList.QuadTree.GetScope(graphics);

            //var camps = -1;
            //// 分判阵营
            //switch (TargetCamps)
            //{
            //    // 非己方
            //    case TargetCampsType.Different:
            //        camps = 1;
            //        break;
            //    // 己方
            //    case TargetCampsType.Same:
            //        camps = 2;
            //        break;
            //}
            //for (var i = 0; i < aroundList.Count; i++)
            //{
            //    var item = aroundList[i];
            //    // 非己方
            //    if (item.MemberData.Camp != camps)
            //    {
            //        targetList.Add(item);
            //    }
            //}


            //// 获取目标数量个单位
            //if (aroundList.Count > TargetCount)
            //{
            //    for (var i = 0; i < TargetCount; i++)
            //    {
            //        targetList.Add(aroundList[i]);
            //    }
            //}
            //else
            //{
            //    targetList = aroundList;
            //}
            //// Debug.Log("搜索到" + targetList.Count + "个单位.");
            //// 对他们释放技能(技能编号)
            //foreach (var target in targetList)
            //{
            //    // TODO 构建新的Packer
            //    //Debug.Log(target.name);
            //    //paramsPacker.TargetObj = target.gameObject;
            //    //paramsPacker.TargetPos = target.transform.position;
            //    SkillManager.Single.DoSkillNum(SkillNum, paramsPacker);
            //}
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
