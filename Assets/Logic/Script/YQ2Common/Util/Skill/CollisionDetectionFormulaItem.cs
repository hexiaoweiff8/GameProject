using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 碰撞检测器
/// </summary>
public class CollisionDetectionFormulaItem : AbstractFormulaItem
{

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

    ///// <summary>
    ///// 技能ID
    ///// </summary>
    //public int SkillNum { get; private set; }

    /// <summary>
    /// 初始化碰撞检测
    /// </summary>
    /// <param name="formulaType">行为单元类型(0: 不等待, 1: 等待)</param>
    /// <param name="targetCount">目标数量</param>
    /// <param name="receivePos">接收技能方(0: 放技能方, 1: 目标方)</param>
    /// <param name="targetCamps">目标阵营</param>
    /// <param name="scopeType">范围类型</param>
    /// <param name="scopeParams">范围参数</param>
    public CollisionDetectionFormulaItem(int formulaType, int targetCount, int receivePos, TargetCampsType targetCamps, GraphicType scopeType, float[] scopeParams)
    {
        FormulaType = formulaType;
        TargetCount = targetCount;
        ReceivePos = receivePos;
        TargetCamps = targetCamps;
        ScopeType = scopeType;
        ScopeParams = scopeParams;
        //SkillNum = skillNum;
    }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>行为单元类型(0: 不等待, 1: 等待)
    /// 1>目标数量
    /// 2>接收技能方(0: 放技能方, 1: 目标方)
    /// 3>目标阵营
    /// 4>范围类型
    /// 5[67]>范围参数
    public CollisionDetectionFormulaItem(string[] array)
    {

        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 5;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方), 检测范围形状(0圆, 1方),
        // 目标阵营(-1:都触发, 0: 己方, 1: 非己方),
        // 范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
        var formulaType = Convert.ToInt32(array[0]);
        var targetCount = Convert.ToInt32(array[1]);
        var receivePos = Convert.ToInt32(array[2]);
        var scopeType = (GraphicType)Enum.Parse(typeof(GraphicType), array[3]);
        var targetTypeCamps = (TargetCampsType)Enum.Parse(typeof(TargetCampsType), array[4]);
        float[] scopeArgs = new float[array.Length - argsCount];
        // 范围参数
        for (var i = 0; i < array.Length - argsCount; i++)
        {
            scopeArgs[i] = Convert.ToSingle(array[i + argsCount]);
        }

        FormulaType = formulaType;
        TargetCount = targetCount;
        ReceivePos = receivePos;
        TargetCamps = targetTypeCamps;
        ScopeType = scopeType;
        ScopeParams = scopeArgs;
    }

    /// <summary>
    /// 生成行为单元
    /// </summary>
    /// <returns>行为单元对象</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            return null;
        }
        IFormula result = null;

        // 数据本地化
        var myReceivePos = ReceivePos;
        var myTargetCamps = TargetCamps;
        var selecterData = paramsPacker.ReleaseMember.ClusterData.MemberData;
        result = new Formula((callback) =>
        {
            // 检测范围
            ICollisionGraphics graphics = null;
            var pos = myReceivePos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            // 获取图形对象
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

            // 获取周围单位DisplayOwner列表
            var packerList = FormulaParamsPackerFactroy.Single.GetFormulaParamsPackerList(graphics, paramsPacker.StartPos, myTargetCamps,
                paramsPacker.TargetMaxCount);
            // 排除不可选择目标
            for (var i = 0; i < packerList.Count; i++)
            {
                var nowPacker = packerList[i];
                if (!TargetSelecter.CouldSelectTarget(nowPacker.ReceiverMenber.ClusterData.MemberData, selecterData))
                {
                    packerList.RemoveAt(i);
                    i--;
                }
            }
            // 对他们释放技能(技能编号)
            if (packerList != null)
            {
                foreach (var packer in packerList)
                {
                    // 执行子行为链
                    if (subFormulaItem != null)
                    {
                        var subSkill = new SkillInfo(-1);
                        subSkill.AddFormulaItem(subFormulaItem);
                        subSkill.GetFormula(packer);
                        SkillManager.Single.DoShillInfo(subSkill, packer);
                    }
                }
            }

            // 执行完成, 回调
            callback();
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
