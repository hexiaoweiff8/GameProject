using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 持续技能
/// </summary>
public class RemainInfo : AbilityBase
{

    // ---------------------------公共属性-----------------------------
    /// <summary>
    /// 作用范围半径
    /// </summary>
    public float Range = 0;

    /// <summary>
    /// 作用时间(地面持续技能使用)
    /// </summary>
    public float DuringTime = -1;

    /// <summary>
    /// 作用时间间隔
    /// </summary>
    public float ActionTime = 0.1f;

    /// <summary>
    /// 是否跟随
    /// </summary>
    public bool IsFollow = true;

    /// <summary>
    /// 产生效果的阵营
    /// -1:对所有阵营造成效果
    /// 1:对我方阵营造成效果
    /// 2:对敌方阵营造成效果
    /// </summary>
    public int ActionCamp = Utils.MyCamp;

    /// <summary>
    /// 是否可以作用到空中单位上
    /// </summary>
    public bool CouldActionOnAir = true;

    /// <summary>
    /// 是否可以作用到地面单位上
    /// </summary>
    public bool CouldActionOnSurface = true;

    /// <summary>
    /// 是否可以作用在建筑上
    /// </summary>
    public bool CouldActionOnBuilding = false;

    /// <summary>
    /// 是否包含Action行为
    /// </summary>
    public bool HasActionFormula = false;

    /// <summary>
    /// 是否包含Enter行为
    /// </summary>
    public bool HasAttachFormula = false;

    /// <summary>
    /// 是否包含out行为
    /// </summary>
    public bool HasDetachFormula = false;

    /// <summary>
    /// 范围技能位置(固定位置时使用, IsFollow = false)
    /// </summary>
    public Vector2 FixPostion = Vector2.zero;


    // ---------------------------私有属性-----------------------------

    /// <summary>
    /// 范围内已存在单位
    /// </summary>
    private IList<PositionObject> existMemberList = new List<PositionObject>();

    /// <summary>
    /// 最后一次执行Action的时间
    /// </summary>
    private long lastActionTime = -1;

    /// <summary>
    /// action事件间隔-毫秒
    /// </summary>
    private int actionTimeMillisecond = -1;

    /// <summary>
    /// 启动时间
    /// </summary>
    private long startTime = 0;

    /// <summary>
    /// 是否一结束
    /// </summary>
    private bool isDone = false;


    // ----------------------------公共方法---------------------------

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="num">编号</param>
    public RemainInfo(int num) : base()
    {
        Num = num;
        startTime = DateTime.Now.Ticks;
    }


    /// <summary>
    /// 检查范围技能
    /// TODO 优化
    /// </summary>
    public bool CheckRange()
    {
        // 已结束
        if (isDone)
        {
            return isDone;
        }

        // 当前时间
        long nowTicks = DateTime.Now.Ticks;

        // 执行范围技能
        var allData = ReleaseMember.ClusterData.AllData;
        if (allData.MemberData == null || allData.RemainInfoList.Count == 0)
        {
            return isDone;
        }

        // 计算时间差的毫秒数量
        actionTimeMillisecond = (int) (ActionTime*Utils.TicksTimeToSecond);

        // 当前技能位置
        var memberPos = IsFollow ? new Vector2(ReleaseMember.ClusterData.X, ReleaseMember.ClusterData.Y): FixPostion;
        
        // 检测范围内单位列表
        var memberList =
            ClusterManager.Single.GetPositionObjectListByGraphics(new CircleGraphics(memberPos, Range));

        // 检查阵营与是否符合可选空地建筑属性
        for (var i = 0; i < memberList.Count; i++)
        {
            var member = memberList[i];
            var memberData = member.AllData.MemberData;
            if (memberData.Camp == Utils.NeutralCamp)
            {
                // 中立阵营
                // 该目标不能选择
                memberList.RemoveAt(i);
                i--;
                continue;
            }
            // 判断空地属性
            if (!((CouldActionOnAir && memberData.GeneralType == Utils.GeneralTypeAir) ||
                  (CouldActionOnBuilding && memberData.GeneralType == Utils.GeneralTypeBuilding) ||
                  (CouldActionOnSurface && memberData.GeneralType == Utils.GeneralTypeSurface)))
            {
                // 该目标不能选择
                memberList.RemoveAt(i);
                i--;
            }
            switch (ActionCamp)
            {
                case Utils.MyCamp:
                {
                    // 判断阵营
                    if (memberData.Camp != Utils.MyCamp)
                    {
                        // 该目标不能选择
                        memberList.RemoveAt(i);
                        i--;
                    }
                }
                    break;
                // 敌方阵营
                case Utils.EnemyCamp:
                {
                    // 判断阵营
                    if (memberData.Camp == Utils.MyCamp)
                    {
                        // 该目标不能选择
                        memberList.RemoveAt(i);
                        i--;
                    }
                }
                    break;
            }
        }

        // 判断可执行单位数量
        if (memberList.Count > 0)
        {
            // 检查时间
            if (nowTicks - lastActionTime > actionTimeMillisecond)
            {
                // 对可作用单位造成效果
                var action = GetActionFormulaItem();
                DoActionWithList(action, memberList);
                // 重置事件
                lastActionTime = nowTicks;
            }
        }


        // 对比列表
        var notExistMemberList = memberList.Where(member => !existMemberList.Contains(member));
        // 出口入口唯一
        // 执行enter事件
        if (notExistMemberList.Any())
        {
            var enterAction = GetAttachFormulaItem();
            DoActionWithList(enterAction, notExistMemberList);
        }

        // 检测out事件
        var exitMemberList = existMemberList.Where(member => !memberList.Contains(member));

        if (exitMemberList.Any())
        {
            var outAction = GetDetachFormulaItem();
            DoActionWithList(outAction, exitMemberList);
        }

        // 保存列表
        existMemberList.Clear();
        existMemberList = memberList;

        // 如果有持续时间
        // 判断是否超过持续时间
        var targetTime = startTime + (long)(DuringTime * Utils.TicksTimeToSecond);
        if (DuringTime > 0 && targetTime < nowTicks)
        {
            isDone = true;
            // 对所有范围内单位执行Out事件
            var outAction = GetDetachFormulaItem();
            DoActionWithList(outAction, existMemberList);
        }

        return isDone;
    }


    // ---------------------------私有方法-----------------------------

    /// <summary>
    /// 针对单位列表执行行为
    /// </summary>
    /// <param name="formulaItem"></param>
    /// <param name="memberList"></param>
    private void DoActionWithList(IFormulaItem formulaItem, IEnumerable<PositionObject> memberList)
    {
        foreach (var notExistMember in memberList)
        {
            var memberDisplayOwner = DisplayerManager.Single.GetElementById(notExistMember.AllData.MemberData.ObjID);
            // 构建FormulaParamsPacker
            var packer = FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(
                ReleaseMember,
                memberDisplayOwner,
                null,
                -1);
            packer.SkillLevel = Level;
            formulaItem = formulaItem.GetFirst();
            SkillManager.Single.DoFormula(GetIFormula(packer, formulaItem));
        }
    }


}