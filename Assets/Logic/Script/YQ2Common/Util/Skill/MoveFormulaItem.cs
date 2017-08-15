using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using Util;

/// <summary>
/// 位移效果
/// </summary>
public class MoveFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 单位检测时间间隔
    /// </summary>
    public float CheckTime = 0.05f;

    /// <summary>
    /// 超时时间
    /// </summary>
    public float OutTime = 3f;

    /// <summary>
    /// 目标点
    /// 0: 自己的位置
    /// 1: 目标的位置
    /// 2: 目标点选择的位置
    /// </summary>
    public int TargetPos { get; private set; }

    /// <summary>
    /// 移动速度
    /// </summary>
    public float Speed { get; private set; }

    /// <summary>
    /// 是否瞬间移动
    /// </summary>
    public bool IsBlink { get; private set; }

    ///// <summary>
    ///// 初始化
    ///// </summary>
    ///// <param name="formulaType">单元行为类型(0: 不等待完成, 1: 等待其执行完毕)</param>
    ///// <param name="speed">移动速度(如果isBlink为1则无效, isBlink为0才有效)</param>
    ///// <param name="isBlink">是否瞬间移动(0: 否, 1: 是)</param>
    //public MoveFormulaItem(int formulaType, float speed, int isBlink)
    //{
    //    FormulaType = formulaType;
    //    Speed = speed;
    //    IsBlink = isBlink;
    //}

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>单元行为类型(0: 不等待完成, 1: 等待其执行完毕)
    /// 1>移动速度(如果isBlink为1则无效, isBlink为0才有效)
    /// 2>是否瞬间移动(0: 否, 1: 是)
    public MoveFormulaItem(string[] array)
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

        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var targetPos = GetDataOrReplace<int>("TargetPos", array, 1, ReplaceDic);
        var speed = GetDataOrReplace<float>("Speed", array, 2, ReplaceDic);
        var isBlink = GetDataOrReplace<bool>("IsBlink", array, 3, ReplaceDic);

        FormulaType = formulaType;
        TargetPos = targetPos;
        Speed = speed;
        IsBlink = isBlink;
    }

    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">数据</param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            return null;
        }

        // 替换替换符数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myCheckTime = CheckTime;
        var myTargetPos = TargetPos;
        var mySpeed = Speed;
        var myIsBlink = IsBlink;
        var member = paramsPacker.ReleaseMember;
        var target = paramsPacker.ReceiverMenber;
        var myFormulaType = FormulaType;
        // 最大移动次数(防溢出)
        var moveTime = 300;
        if (member == null || member.GameObj == null || member.ClusterData == null)
        {
            return null;
        }

        IFormula result = new Formula((callback, scope) =>
        {
            // 获取目标位置
            var targetPos = GetPosByType(myTargetPos, paramsPacker, scope); ;
            //如果不是霸体则进行移动
            if (!member.ClusterData.AllData.MemberData.IsDambody)
            {
                if (myIsBlink)
                {
                    // 瞬移
                    // 数据层面移动
                    member.ClusterData.X = targetPos.x;
                    member.ClusterData.Y = targetPos.y;
                    // 显示层面移动
                    member.GameObj.transform.position = targetPos;
                }
                else
                {
                    // 计时器(超时停止, 防止双重移动导致一直无法到达终点)
                    var timer = new Timer(myCheckTime, OutTime);
                    // 移动
                    Action completeCallback = () =>
                    {
                        // 计算夹角
                        var diffDir = member.GameObj.transform.position - targetPos;
                        // 判断达到目标, 停止
                        if (diffDir.magnitude < mySpeed || moveTime <= 0)
                        {
                            timer.Kill();
                        }
                        var angle = Vector3.Angle(Vector3.forward, diffDir);
                        // 求旋转方向
                        float dir = (Vector3.Dot(Vector3.up, Vector3.Cross(Vector3.forward, diffDir)) < 0 ? 1 : -1);
                        // 位置移动
                        var xMove = (float)Math.Sin(angle * dir) * mySpeed;
                        var yMove = (float)Math.Cos(angle * dir) * mySpeed;
                        member.GameObj.transform.position += new Vector3(xMove, 0, yMove);
                        moveTime--;
                    };
                    timer.OnCompleteCallback(completeCallback).Start();
                }
            }
            callback();
        }, myFormulaType);

        return result;
    }
}