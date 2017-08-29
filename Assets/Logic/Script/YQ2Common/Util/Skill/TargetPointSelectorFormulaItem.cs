using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;


/// <summary>
/// 目标点选择器
/// </summary>
public class TargetPointSelectorFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 相对于
    /// 0: 相对于自己找目标点(自己)
    /// 1: 相对于目标找目标点(目标单位)
    /// 2: 相对于目标点找目标点(找了一次相对于改点再找)
    /// 3: 相对两人的位置(施法者向接受者的方向, 角度无效)
    /// 4: 相对两人的位置(接受者向示范者的方向, 角度无效)
    /// 5: 我方基地位置
    /// 6: 敌方基地位置
    /// </summary>
    public int RelativeTo { get; private set; }

    /// <summary>
    /// 距离
    /// </summary>
    public FormulaItemValueComputer Distance { get; private set; }

    /// <summary>
    /// 角度(- +180度)
    /// </summary>
    public float Angle { get; private set; }



    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public TargetPointSelectorFormulaItem(string[] array)
    {

        if (array == null)
        {
            throw new Exception("数据列表为空");
        }

        var argsCount = 4;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        RelativeTo = GetDataOrReplace<int>("RelativeTo", array, 1);
        Distance = GetDataOrReplace<FormulaItemValueComputer>("Distance", array, 2);
        Angle = GetDataOrReplace<float>("Angle", array, 3);

    }



    /// <summary>
    /// 生成行为链节点
    /// </summary>
    /// <param name="paramsPacker">数据包装类</param>
    /// <returns>行为链节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        if (paramsPacker == null)
        {
            throw new Exception("调用参数 paramsPacker 为空.");
        }

        // 数据替换
        ReplaceData(paramsPacker);
        // 数据本地化
        var myFormulaType = FormulaType;
        var myRelativeTo = RelativeTo;
        var myDistance = Distance.GetValue();
        var myAngle = Angle;

        // 自己位置
        var mySelfPos = paramsPacker.ReleaseMember == null
            ? Vector2.zero 
            : new Vector2(paramsPacker.ReleaseMember.ClusterData.X, paramsPacker.ReleaseMember.ClusterData.Y);
        // 自己朝向
        var myDir = paramsPacker.ReleaseMember == null
            ? Vector2.zero
            : new Vector2(paramsPacker.ReleaseMember.ClusterData.Direction.x, paramsPacker.ReleaseMember.ClusterData.Direction.z);
        // 目标位置
        var targetPos = paramsPacker.ReceiverMenber == null
            ? Vector2.zero
            : new Vector2(paramsPacker.ReceiverMenber.ClusterData.X, paramsPacker.ReceiverMenber.ClusterData.Y);
        // 目标朝向
        var targetDir = paramsPacker.ReceiverMenber == null
            ? Vector2.zero
            : new Vector2(paramsPacker.ReceiverMenber.ClusterData.Direction.x, paramsPacker.ReceiverMenber.ClusterData.Direction.z);

        result = new Formula((callback, scope) =>
        {
            // 位置X
            var posX = 0f;
            // 位置Y
            var posY = 0f;

            // 判断类型
            switch (myRelativeTo)
            {
                case (int) RelativeToType.MySelf:
                {
                    // 获取自己的位置
                    // 计算相对自己位置的角度与距离
                    // 当前角度
                    // 方向有效
                    if (myDir != Vector2.zero)
                    {
                        // 计算角度正负
                        var sign = Vector2.Angle(myDir, Vector2.right) < 90;
                        // 计算与正方向角度
                        var angle = Vector2.Angle(myDir, Vector2.up)*(sign ? 1 : -1);
                        angle += myAngle;
                        var newPos = new Vector2((float) Math.Sin(angle*Utils.AngleToPi),
                            (float)Math.Cos(angle * Utils.AngleToPi)) * myDistance + mySelfPos;
                        posX = newPos.x;
                        posY = newPos.y;
                    }
                }
                    break;
                case (int) RelativeToType.Target:
                {
                    // 计算相对于目标的角度与距离
                    if (targetDir != Vector2.zero)
                    {
                        // 计算角度正负
                        var sign = Vector2.Angle(targetDir, Vector2.right) < 90;
                        // 计算与正方向角度
                        var angle = Vector2.Angle(targetDir, Vector2.up) * (sign ? 1 : -1);
                        angle += myAngle;
                        var newPos = new Vector2((float)Math.Sin(angle * Utils.AngleToPi),
                            (float)Math.Cos(angle * Utils.AngleToPi)) * myDistance + mySelfPos;
                        posX = newPos.x;
                        posY = newPos.y;
                    }
                }
                    break;
                case (int) RelativeToType.TargetPoint:
                {
                    // 计算相对于上次选择的目标点的角度与位置(Z轴正方向为0度)
                    var newPos = new Vector2((float)Math.Sin(myAngle * Utils.AngleToPi),
                           (float)Math.Cos(myAngle * Utils.AngleToPi)) * myDistance + mySelfPos;
                    posX = newPos.x;
                    posY = newPos.y;
                }
                    break;
                case (int) RelativeToType.MeToTarget:
                {
                    // 计算我到目标这个方向的距离
                    var dir = targetPos - mySelfPos;
                    if (dir == Vector2.zero)
                    {
                        dir = Vector2.up;
                    }
                    var newPos = targetPos + dir.normalized * myDistance;
                    posX = newPos.x;
                    posY = newPos.y;
                }
                    break;
                case (int) RelativeToType.TargetToMe:
                {
                    // 计算目标到我这个方向的距离
                    var dir = mySelfPos - targetPos;
                    if (dir == Vector2.zero)
                    {
                        dir = Vector2.up;
                    }
                    var newPos = mySelfPos + dir.normalized * myDistance;
                    posX = newPos.x;
                    posY = newPos.y;
                }
                    break;
                case (int)RelativeToType.MyBase:
                    {
                        // 计算目标到我这个方向的距离
                        var myBasePos = Utils.V3ToV2WithouY(FightManager.Single.GetPos(Utils.MyCamp, FightManager.MemberType.Base));
                        var dir = myBasePos - targetPos;
                        if (dir == Vector2.zero)
                        {
                            dir = Vector2.up;
                        }
                        var newPos = mySelfPos + dir.normalized * myDistance;
                        posX = newPos.x;
                        posY = newPos.y;
                    }
                    break;
                case (int)RelativeToType.EnemyBase:
                    {
                        // 计算目标到我这个方向的距离
                        var dir = mySelfPos - targetPos;
                        if (dir == Vector2.zero)
                        {
                            dir = Vector2.up;
                        }
                        var newPos = mySelfPos + dir.normalized * myDistance;
                        posX = newPos.x;
                        posY = newPos.y;
                    }
                    break;
            }

            // 保存位置点
            scope.SetFloat(Utils.TargetPointSelectorXKey, posX);
            scope.SetFloat(Utils.TargetPointSelectorYKey, posY);
            callback();
        },
        myFormulaType);


        return result;
    }

    /// <summary>
    /// 相对类型
    /// 0: 相对于自己找目标点(自己)
    /// 1: 相对于目标找目标点(目标单位)
    /// 2: 相对于目标点找目标点(找了一次相对于改点再找)
    /// 3: 相对两人的位置(施法者向接受者的方向, 角度无效)
    /// 4: 相对两人的位置(接受者向示范者的方向, 角度无效)
    /// </summary>
    public enum RelativeToType
    {
        MySelf = 0,
        Target = 1,
        TargetPoint = 2,
        MeToTarget = 3,
        TargetToMe = 4,
        MyBase = 5,
        EnemyBase = 6
    }
}