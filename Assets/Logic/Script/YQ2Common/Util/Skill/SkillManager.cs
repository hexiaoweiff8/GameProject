using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

/// <summary>
/// 技能管理器
/// </summary>
public class SkillManager
{
    /// <summary>
    /// 单例
    /// </summary>
    public static SkillManager Single
    {
        get
        {
            if (single == null)
            {
                single = new SkillManager();
            }
            return single;
        }
    }

    /// <summary>
    /// 单例对象
    /// </summary>
    private static SkillManager single = null;


    /// <summary>
    /// 是否暂停功能
    /// </summary>
    public static bool isPause { get; private set; }

    /// <summary>
    /// 技能字典
    /// </summary>
    public IDictionary<int, SkillInfo> SkillInfoDic = new Dictionary<int, SkillInfo>();


    // TODO 注册事件


    // -------------------------------技能加载----------------------------------


    /// <summary>
    /// 加载技能
    /// TODO 需要判断当前运行状态, 并添加包加载方式
    /// </summary>
    /// <param name="skillId">技能ID 必须为>0的整数</param>
    /// <returns>技能信息</returns>
    public SkillInfo LoadSkillInfo(int skillId)
    {
        SkillInfo result = null;

        // 验证技能ID的有效性
        if (skillId > 0)
        {
            // 检查缓存
            if (SkillInfoDic.ContainsKey(skillId))
            {
                result = SkillInfoDic[skillId];
            }
            else
            {
                // 检测文件是否存在
                var file = new FileInfo(Application.streamingAssetsPath + Path.DirectorySeparatorChar + "SkillScript" + skillId + ".txt");
                if (file.Exists)
                {
                    // 加载文件内容
                    var skillTxt = Utils.LoadFileInfo(file);
                    if (!string.IsNullOrEmpty(skillTxt))
                    {
                        result = FormulaConstructor.Constructor(skillTxt);
                        // 将其放入缓存
                        SkillInfoDic.Add(skillId, result);
                    }
                }
            }
        }

        return result;
    }


    // -------------------------------技能执行----------------------------------


    /// <summary>
    /// 执行方程式
    /// </summary>
    /// <param name="formula">方程式对象</param>
    public void DoFormula(IFormula formula)
    {
        if (formula == null)
        {
            throw new Exception("方程式对象为空.");
        }

        CoroutineManage.AutoInstance();
        CoroutineManage.Single.StartCoroutine(LoopDoFormula(formula));
    }

    /// <summary>
    /// 执行技能
    /// </summary>
    /// <param name="skillInfo">技能对象</param>
    /// <param name="packer">技能数据包</param>
    /// <param name="isSubSkill">是否为子技能</param>
    public void DoShillInfo(SkillInfo skillInfo, FormulaParamsPacker packer, bool isSubSkill = false)
    {
        if (skillInfo == null)
        {
            throw new Exception("方程式对象为空.");
        }
        if (isSubSkill)
        {
            DoFormula(skillInfo.GetFormula(packer));
        }
        else
        {
            var objId = packer.ReleaseMember.ClusterData.MemberData.ObjID.ID;
            var skillNum = skillInfo.SkillNum;
            // 技能是否在CD
            if (!CDTimer.Instance().IsInCD(objId, skillNum))
            {
                CDTimer.Instance().SetInCD(objId, skillNum, 1);
                // 技能CDGroup
                // 技能可释放次数-暂时不做

                DoFormula(skillInfo.GetFormula(packer));
            }
            // 否则技能在CD中不能释放
        }
    }

    /// <summary>
    /// 按照技能ID执行技能
    /// </summary>
    /// <param name="skillNum">技能ID</param>
    /// <param name="packer">技能数据包</param>
    /// <param name="isSubSkill">是否为子技能</param>
    public void DoSkillNum(int skillNum, FormulaParamsPacker packer, bool isSubSkill = false)
    {
        if (!SkillInfoDic.ContainsKey(skillNum))
        {
            throw new Exception("技能ID不存在:" + skillNum);
        }

        var skillInfo = SkillInfoDic[skillNum];
        DoShillInfo(skillInfo, packer, isSubSkill);
    }

    /// <summary>
    /// 添加技能到字典中
    /// </summary>
    /// <param name="skillInfo">技能信息, 不能为空</param>
    public void AddSkillInfo(SkillInfo skillInfo)
    {
        // 技能类不为空
        if (skillInfo == null)
        {
            throw new Exception("技能对象为空!");
        }
        // 是否已存在技能ID
        if (SkillInfoDic.ContainsKey(skillInfo.SkillNum))
        {
            throw new Exception("已存在技能编号:" + skillInfo.SkillNum);
        }

        // 将技能加入字典中
        SkillInfoDic.Add(skillInfo.SkillNum, skillInfo);
    }

    /// <summary>
    /// 暂停功能
    /// </summary>
    public void Pause()
    {
        // 暂停功能
        isPause = true;
    }

    /// <summary>
    /// 继续
    /// </summary>
    public void Start()
    {
        // 继续功能
        isPause = false;
    }

    /// <summary>
    /// 携程循环
    /// </summary>
    private IEnumerator LoopDoFormula(IFormula formula)
    {
        if (formula != null)
        {
            // 获取链表中的第一个
            var topNode = formula.GetFirst();

            // 顺序执行每一个操作
            do
            {
                //Debug.Log("执行");
                var isWaiting = true;
                // 创建回调
                Action callback = () =>
                {
                    //Debug.Log("Callback");
                    isWaiting = false;
                };
                topNode.Do(callback);
                if (topNode.FormulaType == Formula.FormulaWaitType)
                {
                    while (isWaiting)
                    {
                        yield return new WaitForEndOfFrame();
                    }
                }
                topNode = topNode.NextFormula;
                //if (topNode == null)
                //{
                //    //Debug.Log("结束了");
                //}
            } while (topNode != null);
        }
    }
}



/// <summary>
/// 行为链单位
/// </summary>
public class Formula : IFormula
{

    /// <summary>
    /// 下一个节点
    /// </summary>
    public IFormula NextFormula { get; set; }

    /// <summary>
    /// 上一个节点
    /// </summary>
    public IFormula PreviewFormula { get; set; }

    /// <summary>
    /// 常量 不等待直接下一节点执行
    /// </summary>
    public const int FormulaNotWaitType = 0;

    /// <summary>
    /// 常亮 等待完成后继续执行
    /// </summary>
    public const int FormulaWaitType = 1;

    // -------------------------属性---------------------------


    /// <summary>
    /// 行为链类型
    /// 0: 无需等待直接继续下一节点
    /// 1: 等待当前节点执行完成再执行下一节点
    /// </summary>
    public int FormulaType {
        get { return formulaType; }
        set { formulaType = value; } }

    /// <summary>
    /// 当前节点执行的操作 
    /// 外部只读
    /// </summary>
    public Action<Action> Do { get; protected set; }


    /// <summary>
    /// 行为链执行方式
    /// 0: 无需等待直接继续下一节点
    /// 1: 等待当前节点执行完成再执行下一节点
    /// </summary>
    protected int formulaType = FormulaNotWaitType;


    // -----------------------公用方法-----------------------
    
    //protected Formula()
    //{
        
    //}

    /// <summary>
    /// 构建方法
    /// 传入执行操作
    /// </summary>
    /// <param name="doForWaitAction">当前节点的行为</param>
    /// <param name="type">执行类型, 0:不等待是否执行完毕继续下一届点, 1:等待节点执行完毕调用回调.</param>
    public Formula(Action<Action> doForWaitAction, int type = FormulaNotWaitType)
    {
        Do = doForWaitAction;
        formulaType = type;
    }

    /// <summary>
    /// 获取行为链链头
    /// </summary>
    /// <returns>链头单位</returns>
    public IFormula GetFirst()
    {
        IFormula tmpItem = PreviewFormula;
        IFormula first = this;
        while (tmpItem != null)
        {
            first = tmpItem;
            tmpItem = tmpItem.PreviewFormula;
        }
        return first;
    }

    /// <summary>
    /// 当前节点是否有下一单位
    /// </summary>
    /// <returns></returns>
    public bool HasNext()
    {
        if (NextFormula != null)
        {
            return true;
        }
        return false;
    }
    

    /// <summary>
    /// 添加下一个节点
    /// </summary>
    /// <param name="nextBehavior">下一个节点</param>
    /// <returns>下一节点</returns>
    public IFormula After(IFormula nextBehavior)
    {
        if (nextBehavior != null)
        {
            // 如果后一个单位不为空则向后移
            if (NextFormula != null)
            {
                NextFormula.After(NextFormula);
            }
            NextFormula = nextBehavior;
            nextBehavior.PreviewFormula = this;

            return nextBehavior;
        }
        return this;
    }

    /// <summary>
    /// 添加前一个节点
    /// </summary>
    /// <param name="preBehavior">前一个节点</param>
    /// <returns>前一节点</returns>
    public IFormula Before(IFormula preBehavior)
    {
        if (preBehavior != null)
        {
            // 如果前一个单位不为空则向前移
            if (PreviewFormula != null)
            {
                PreviewFormula.Before(PreviewFormula);
            }
            PreviewFormula = preBehavior;
            preBehavior.NextFormula = this;

            return preBehavior;
        }
        return this;
    }
}




// ----------------------------抽象类-------------------------------

/// <summary>
/// 行为链单位接口
/// </summary>
public interface IFormula
{
    /// <summary>
    /// 下一个节点
    /// </summary>
    IFormula NextFormula { get; set; }

    /// <summary>
    /// 上一个节点
    /// </summary>
    IFormula PreviewFormula { get; set; }
    /// <summary>
    /// 行为链类型
    /// 0: 无需等待直接继续下一节点
    /// 1: 等待当前节点执行完成再执行下一节点
    /// </summary>
    int FormulaType { get; set; }

    /// <summary>
    /// 具体执行lambda表达式
    /// </summary>
    Action<Action> Do { get; }

    /// <summary>
    /// 添加下一节点
    /// </summary>
    /// <param name="nextBehavior">下一个节点</param>
    /// <returns>下一个节点</returns>
    IFormula After(IFormula nextBehavior);

    /// <summary>
    /// 添加前一节点
    /// </summary>
    /// <param name="preBehavior">前一个节点</param>
    /// <returns>前一个节点</returns>
    IFormula Before(IFormula preBehavior);

    /// <summary>
    /// 当前节点是否有下一节点
    /// </summary>
    /// <returns></returns>
    bool HasNext();

    /// <summary>
    /// 获取链头
    /// </summary>
    /// <returns>链头单位</returns>
    IFormula GetFirst();
}