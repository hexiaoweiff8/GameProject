using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.Assertions.Comparers;
using Util;

public class SlideCollisionDetectionFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 检查时间间隔
    /// </summary>
    public float CheckTime = 0.1f;

    /// <summary>
    /// 速度
    /// </summary>
    public float Speed { get; private set; }

    /// <summary>
    /// 搜索宽度
    /// </summary>
    public float Width { get; private set; }

    /// <summary>
    /// 搜索长度
    /// </summary>
    public float Length { get; private set; }

    /// <summary>
    /// 目标阵营
    /// </summary>
    public TargetCampsType TargetCamps { get; private set; }


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="formulaType">行为单元类型</param>
    /// <param name="speed">扫描速度(单位扫描次数的长度)</param>
    /// <param name="width">扫描宽度</param>
    /// <param name="length">扫描总长度</param>
    /// <param name="targetCamps">目标阵营类型</param>
    public SlideCollisionDetectionFormulaItem(int formulaType, float speed, float width, float length, TargetCampsType targetCamps)
    {
        FormulaType = formulaType;
        Speed = speed;
        Width = width;
        Length = length;
        TargetCamps = targetCamps;
    }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>行为单元类型
    /// 1>扫描速度(单位扫描次数的长度)
    /// 2>扫描宽度
    /// 3>扫描总长度
    /// 4>目标阵营类型
    public SlideCollisionDetectionFormulaItem(string[] array)
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

        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var speed = GetDataOrReplace<float>("Speed", array, 1, ReplaceDic);
        var width = GetDataOrReplace<float>("Width", array, 2, ReplaceDic);
        var length = GetDataOrReplace<float>("Length", array, 3, ReplaceDic);
        var targetCamps = GetDataOrReplace<TargetCampsType>("TargetCamps", array, 4, ReplaceDic);


        FormulaType = formulaType;
        Speed = speed;
        Width = width;
        Length = length;
        TargetCamps = targetCamps;
    }

    /// <summary>
    /// 获取行为节点
    /// </summary>
    /// <param name="paramsPacker">目标数据</param>
    /// <returns>滑动碰撞检测行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (Speed < Utils.ApproachZero)
        {
            throw new Exception("滑动碰撞检测的速度不能小于等于0");
        }

        // 替换数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var mySpeed = Speed;
        var myCheckTime = CheckTime;
        var myLength = Length;
        var myTargetCamps = TargetCamps;
        var myFormulaType = FormulaType;

        var clusterData = paramsPacker.ReleaseMember.ClusterData;

        // 上一次列表
        List<FormulaParamsPacker> prvPackerList = new List<FormulaParamsPacker>();
        IList<FormulaParamsPacker> tmpPackerList = null;

        IFormula result = new Formula((callback) =>
        {

            // 当前长度
            var nowLength = 0f;

            // 计时器
            var timer = new Timer(myCheckTime, true);
            // 计时器行为
            Action completeCallback = () =>
            {
                // 是否到达目标
                if (nowLength < Length)
                {
                    // 搜索位置+1
                    nowLength += mySpeed;
                    // 从发射位置向目标位置一节一节搜索目标
                    // 速度影响单次搜索的长度
                    var diffPos = paramsPacker.TargetPos - paramsPacker.StartPos;
                    var pos = (diffPos) * nowLength / myLength + paramsPacker.StartPos;
                    // 创建图形
                    var diffPosNoY = new Vector3(diffPos.x, 0, diffPos.z);
                    // 求旋转角度
                    var rotation = Vector3.Angle(Vector3.forward, diffPosNoY);
                    // 求旋转方向
                    float dir = (Vector3.Dot(Vector3.up, Vector3.Cross(Vector3.forward, diffPosNoY)) < 0 ? 1 : -1);
                    // 获得图形
                    var graphics = new RectGraphics(new Vector2(pos.x, pos.z), Width, mySpeed, rotation * dir);
                    Utils.DrawGraphics(graphics, Color.white);
                    // 搜索当前节范围内的单位
                    tmpPackerList = FormulaParamsPackerFactroy.Single.GetFormulaParamsPackerList(graphics, paramsPacker.StartPos, myTargetCamps, 
                        paramsPacker.TargetMaxCount);

                    // 执行子技能
                    if (tmpPackerList != null && tmpPackerList.Count > 0 && SubFormulaItem != null)
                    {
                        // 排除不可选择目标
                        for (var i = 0; i < tmpPackerList.Count; i++)
                        {
                            var nowPacker = tmpPackerList[i];
                            if (!TargetSelecter.CouldSelectTarget(nowPacker.ReceiverMenber.ClusterData, clusterData))
                            {
                                tmpPackerList.RemoveAt(i);
                                i--;
                            }
                        }

                        // 排除上次被攻击过的目标
                        bool isExist;
                        for (var j = 0; j < prvPackerList.Count; j++)
                        {
                            isExist = false;
                            var prvPacker = prvPackerList[j];
                            // 判断是否存在上次被攻击的对象
                            // 从列表中删除重复对象
                            for (var i = 0; i < tmpPackerList.Count; i++)
                            {
                                var nowPacker = tmpPackerList[i];
                                if (prvPacker.ReceiverMenber.Equals(nowPacker.ReceiverMenber))
                                {
                                    // 删除本次攻击中上次攻击存在的单位
                                    tmpPackerList.RemoveAt(i);
                                    i--;
                                    isExist = true;
                                    break;
                                }
                            }

                            // 删除上次攻击中本次攻击不存在的单位
                            if (!isExist)
                            {
                                prvPackerList.RemoveAt(j);
                                j--;
                            }
                        }

                        prvPackerList.AddRange(tmpPackerList);

                        foreach (var packer in tmpPackerList)
                        {
                            var subSkill = new SkillInfo(packer.SkillNum);
                            FormulaParamsPackerFactroy.Single.CopyPackerData(paramsPacker, packer);
                            subSkill.DataList = paramsPacker.DataList;
                            subSkill.AddActionFormulaItem(SubFormulaItem);
                            //subSkill.GetFormula(packer);
                            SkillManager.Single.DoShillInfo(subSkill, packer, true);
                        }
                    }
                }
                else
                {
                    // 结束计时
                    timer.Kill();
                    // 完成回调
                    callback();
                }
            };

            timer.OnCompleteCallback(completeCallback);
            timer.Start();
        }, myFormulaType);

        return result;
    }
}