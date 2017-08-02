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
    /// 可选参数
    /// 权重选择数据Id 
    /// </summary>
    public int TargetSelectDataId = -1;

    /// <summary>
    /// 可选参数
    /// 循环次数
    /// </summary>
    public int RepeatTime = 1;

    /// <summary>
    /// 参数1
    /// </summary>
    public float Arg1 { get; private set; }

    /// <summary>
    /// 可选参数
    /// 参数2
    /// </summary>
    public float Arg2 { get; private set; }

    /// <summary>
    /// 可选参数
    /// 参数3
    /// </summary>
    public float Arg3 { get; private set; }


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
        //ScopeParams = scopeParams;
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
        var argsCount = 10;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方), 检测范围形状(0圆, 1方),
        // 目标阵营(-1:都触发, 0: 己方, 1: 非己方),
        // 范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var targetCount = GetDataOrReplace<int>("TargetCount", array, 1, ReplaceDic);
        var receivePos = GetDataOrReplace<int>("ReceivePos", array, 2, ReplaceDic);
        var scopeType = GetDataOrReplace<GraphicType>("ScopeType", array, 3, ReplaceDic);
        var targetTypeCamps = GetDataOrReplace<TargetCampsType>("TargetCamps", array, 4, ReplaceDic);

        // 可选参数
        var arg1 = GetDataOrReplace<float>("Arg1", array, 5, ReplaceDic);
        var arg2 = GetDataOrReplace<float>("Arg2", array, 6, ReplaceDic);
        var arg3 = GetDataOrReplace<float>("Arg3", array, 7, ReplaceDic);

        var targetSelectDataId = GetDataOrReplace<int>("TargetSelectDataId", array, 8, ReplaceDic);
        var repeatTime = GetDataOrReplace<int>("RepeatTime", array, 9, ReplaceDic);


        FormulaType = formulaType;
        TargetCount = targetCount;
        ReceivePos = receivePos;
        ScopeType = scopeType;
        TargetCamps = targetTypeCamps;
        Arg1 = arg1;
        Arg2 = arg2;
        Arg3 = arg3;
        TargetSelectDataId = targetSelectDataId;
        RepeatTime = repeatTime;
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

        // 替换替换符的数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var myReceivePos = ReceivePos;
        var myTargetCamps = TargetCamps;
        var clusterData = paramsPacker.ReleaseMember.ClusterData;
        //var selecterData = clusterData.MemberData;
        var myFormulaType = FormulaType;
        var myScopeType = ScopeType;
        var myTargetCount = TargetCount;
        var myRepeatTime = RepeatTime;
        // 目标权重筛选数据

        var targetSelectData = new SelectWeightData();
        // 选择目标数据
        targetSelectData.AirWeight = -1;
        targetSelectData.BuildWeight = 100;
        targetSelectData.SurfaceWeight = 100;

        targetSelectData.HumanWeight = 10;
        targetSelectData.OrcWeight = 10;
        targetSelectData.OmnicWeight = 10;

        targetSelectData.HideWeight = -1;
        targetSelectData.TauntWeight = 1000;

        targetSelectData.HealthMaxWeight = 0;
        targetSelectData.HealthMinWeight = 10;
        targetSelectData.DistanceMaxWeight = 0;
        targetSelectData.DistanceMinWeight = 10;
        //var targetSelectData = TargetSelectDataId > 0 ? new SelectWeightData(SData_armyaim_c.Single.GetDataOfID(TargetSelectDataId)) : null;

        result = new Formula((callback, scope) =>
        {
            // 检测范围
            ICollisionGraphics graphics = null;
            // 获取目标位置
            var posX = 0f;
            var posY = 0f;
            switch (myReceivePos)
            {
                case 0:
                    {
                        posX = paramsPacker.ReleaseMember.ClusterData.X;
                        posY = paramsPacker.ReleaseMember.ClusterData.Y;
                    }
                    break;
                case 1:
                    {
                        posX = paramsPacker.ReceiverMenber.ClusterData.X;
                        posY = paramsPacker.ReceiverMenber.ClusterData.Y;
                    }
                    break;
                case 2:
                    {
                        posX = scope.GetFloat(Utils.TargetPointSelectorXKey) ?? 0f;
                        posY = scope.GetFloat(Utils.TargetPointSelectorYKey) ?? 0f;
                    }
                    break;
            }
            var pos = new Vector2(posX, posY);//Utils.V3ToV2WithouY(myReceivePos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos);
            // 获取图形对象
            switch (myScopeType)
            {
                case GraphicType.Circle:
                    // 圆形
                    graphics = new CircleGraphics(pos, Arg1);
                    break;

                case GraphicType.Rect:
                    // 矩形
                    graphics = new RectGraphics(pos, Arg1, Arg2, Arg3);
                    break;

                case GraphicType.Sector:
                    // 扇形
                    graphics = new SectorGraphics(pos, Arg3, Arg1, Arg2);
                    break;
            }

            // 获取周围单位DisplayOwner列表
            var packerList = FormulaParamsPackerFactroy.Single.GetFormulaParamsPackerList(graphics, 
                paramsPacker.StartPos, 
                myTargetCamps,
                paramsPacker.Skill,
                paramsPacker.TargetMaxCount);

            // 根据权重数据筛选目标
            if (targetSelectData != null)
            {
                packerList = TargetSelecter.TargetFilter(targetSelectData, clusterData, packerList);
            }

            // 重复次数
            var repeatedCount = 0;
            // 对他们释放技能(技能编号)
            if (packerList != null)
            {
                var counter = 0;
                foreach (var packer in packerList)
                {
                    // 如果设置了数量上限, 并且超过数量上限则跳出
                    if (myTargetCount > 0 && counter >= myTargetCount)
                    {
                        break;
                    }
                    // 执行子行为链
                    if (SubFormulaItem != null)
                    {
                        var subSkill = new SkillInfo(packer.SkillNum);
                        FormulaParamsPackerFactroy.Single.CopyPackerData(paramsPacker, packer);
                        subSkill.DataList = packer.DataList;
                        subSkill.AddActionFormulaItem(SubFormulaItem);
                        //subSkill.GetFormula(packer);
                        SkillManager.Single.DoSkillInfo(subSkill, packer, true, () =>
                        {
                            repeatedCount++;
                            if (repeatedCount >= myRepeatTime)
                            {
                                // 执行完成, 回调
                                callback();
                            }
                        });
                    }
                    counter++;
                }
            }

        }, myFormulaType);
        

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
