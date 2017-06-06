using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
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


    /// <summary>
    /// 技能触发字典
    /// </summary>
    private static
        IDictionary<ObjectID, IDictionary<SkillTriggerLevel1, IDictionary<SkillTriggerLevel2, List<SkillTriggerData>>>>
        skillTriggerList =
            new Dictionary
                <ObjectID, IDictionary<SkillTriggerLevel1, IDictionary<SkillTriggerLevel2, List<SkillTriggerData>>>>();

    ///// <summary>
    ///// 攻击者列表[被攻击者ID, 攻击者列表]
    ///// </summary>
    //private static IDictionary<ObjectID, IList<DisplayOwner>> hitList = new Dictionary<ObjectID, IList<DisplayOwner>>();

    ///// <summary>
    ///// 伤害列表[被攻击者ID, 所受伤害]
    ///// </summary>
    //private static IDictionary<ObjectID, float> damageList = new Dictionary<ObjectID, float>();

    ///// <summary>
    ///// 闪避列表[被攻击者ID]
    ///// </summary>
    //private static HashSet<ObjectID> dodgeList = new HashSet<ObjectID>();


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
                var file =
                    new FileInfo(Application.streamingAssetsPath + Path.DirectorySeparatorChar + "SkillScript" + skillId +
                                 ".txt");
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

    /// <summary>
    /// 加载技能列表
    /// </summary>
    /// <param name="skillIdList">技能ID列表</param>
    /// <returns>技能信息列表</returns>
    public IList<SkillInfo> LoadSkillInfoList(IList<int> skillIdList)
    {
        List<SkillInfo> result = null;
        if (skillIdList != null && skillIdList.Count > 0)
        {
            result = new List<SkillInfo>();
            foreach (var skillId in skillIdList)
            {
                var skillInfo = LoadSkillInfo(skillId);
                if (skillInfo != null)
                {
                    result.Add(skillInfo);
                }
            }
            // 根据CD时间排序
            result.Sort((a, b) =>
            {
                if (a.CDTime > b.CDTime)
                {
                    return 1;
                }
                return -1;
            });
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
    /// 检查并执行符合条件的技能
    /// </summary>
    /// <param name="skillsList">被检查列表</param>
    /// <param name="releaseOwner">技能释放单位</param>
    /// <param name="receiveOwner">技能被释放单位</param>
    /// <param name="type1">第一级技能触发类型</param>
    /// <param name="type2">第二级技能触发类型</param>
    public void CheckAndDoSkillInfo(IList<SkillInfo> skillsList,
        DisplayOwner releaseOwner,
        DisplayOwner receiveOwner,
        SkillTriggerLevel1 type1,
        SkillTriggerLevel2 type2)
    {
        // 如果攻击时触发
        foreach (
            var skill in
                skillsList.Where(skill => skill != null && skill.TriggerLevel1 == type1 && skill.TriggerLevel2 == type2)
            )
        {
            // 触发技能
            DoShillInfo(skill,
                FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(skill, releaseOwner, receiveOwner));
        }
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

    // ------------------------------------技能事件检测-----------------------------------

    /// <summary>
    /// 添加事件数据
    /// </summary>
    /// <param name="triggerData">事件数据</param>
    public void SetSkillTriggerData(SkillTriggerData triggerData)
    {
        if (triggerData == null || triggerData.ReleaseMember == null)
        {
            return;
        }

        var objId = triggerData.ReleaseMember.ClusterData.MemberData.ObjID;
        if (!skillTriggerList.ContainsKey(objId))
        {
            skillTriggerList.Add(objId,
                new Dictionary<SkillTriggerLevel1, IDictionary<SkillTriggerLevel2, List<SkillTriggerData>>>()
                {
                    {
                        triggerData.TypeLevel1, new Dictionary<SkillTriggerLevel2, List<SkillTriggerData>>()
                        {
                            {triggerData.TypeLevel2, new List<SkillTriggerData>() {triggerData}}
                        }
                    }
                });
        }
        else
        {
            var dicLevel1 = skillTriggerList[objId];
            if (!dicLevel1.ContainsKey(triggerData.TypeLevel1))
            {
                dicLevel1.Add(triggerData.TypeLevel1, new Dictionary<SkillTriggerLevel2, List<SkillTriggerData>>()
                {
                    {triggerData.TypeLevel2, new List<SkillTriggerData>() {triggerData}}
                });
            }
            else
            {
                var dicLevel2 = dicLevel1[triggerData.TypeLevel1];
                if (!dicLevel2.ContainsKey(triggerData.TypeLevel2))
                {
                    dicLevel2.Add(triggerData.TypeLevel2, new List<SkillTriggerData>() {triggerData});
                }
                else
                {
                    var triggerDataList = dicLevel2[triggerData.TypeLevel2];
                    triggerDataList.Add(triggerData);
                }
            }
        }
    }

    /// <summary>
    /// 取出事件数据列表
    /// </summary>
    /// <param name="objId">被取单位ID</param>
    /// <param name="type1">被取出类型Level1</param>
    /// <param name="type2">被取出类型Level2</param>
    /// <returns>如果有列表返回列表, 否则返回null</returns>
    public List<SkillTriggerData> GetSkillTriggerDataList(ObjectID objId, SkillTriggerLevel1 type1,
        SkillTriggerLevel2 type2)
    {
        if (skillTriggerList.ContainsKey(objId))
        {
            var dicLevel1 = skillTriggerList[objId];
            if (dicLevel1.ContainsKey(type1))
            {
                var dicLevel2 = dicLevel1[type1];
                if (dicLevel2.ContainsKey(type2))
                {
                    return dicLevel2[type2];
                }
            }
        }
        return null;
    }

    /// <summary>
    /// 清空一个单位的Level1的Level2的事件列表
    /// </summary>
    /// <param name="objId">被清空单位ID</param>
    /// <param name="typeLevel1">被清空类型Level1</param>
    /// <param name="typeLevel2">被清空类型Level2</param>
    public void ClearSkillTriggerData(ObjectID objId, SkillTriggerLevel1 typeLevel1, SkillTriggerLevel2 typeLevel2)
    {
        if (skillTriggerList.ContainsKey(objId))
        {
            var dicLevel1 = skillTriggerList[objId];
            if (dicLevel1.ContainsKey(typeLevel1))
            {
                var dicLevel2 = dicLevel1[typeLevel1];
                if (dicLevel2.ContainsKey(typeLevel2))
                {
                    dicLevel2[typeLevel2].Clear();
                }
            }
        }
    }

    /// <summary>
    /// 清空所有触发
    /// </summary>
    public void ClearAllSkillTriggerData()
    {
        skillTriggerList.Clear();
    }

    /// <summary>
    /// 循环整体事件列表并执行each
    /// </summary>
    /// <param name="each">被执行单位处理</param>
    /// <param name="isDelBeforeEnd">是否执行完毕后删除</param>
    public void SetEachAction(Action<ObjectID, SkillTriggerLevel1, SkillTriggerLevel2, SkillTriggerData> each, bool isDelBeforeEnd = false)
    {
        if (each == null)
        {
            return;
        }
        foreach (var objKV in skillTriggerList)
        {
            var objId = objKV.Key;
            foreach (var typeLevel1Dic in objKV.Value)
            {
                var typeLevel1 = typeLevel1Dic.Key;
                foreach (var typeLevel2Dic in typeLevel1Dic.Value)
                {
                    var typeLevel2 = typeLevel2Dic.Key;
                    foreach (var skillTrigger in typeLevel2Dic.Value)
                    {
                        each(objId, typeLevel1, typeLevel2, skillTrigger);
                    }
                    // 如果需要执行完毕后删除
                    if (isDelBeforeEnd)
                    {
                        ClearSkillTriggerData(objId, typeLevel1, typeLevel2);
                    }
                }
            }
        }
    }

    /// <summary>
    /// 循环整体事件列表并执行each
    /// </summary>
    /// <param name="objId">单位ObjId</param>
    /// <param name="each">被执行单位处理</param>
    /// <param name="isDelBeforeEnd">是否执行完毕后删除</param>
    public void SetEachAction(ObjectID objId, Action<SkillTriggerLevel1, SkillTriggerLevel2, SkillTriggerData> each, bool isDelBeforeEnd = false)
    {
        if (each == null || !skillTriggerList.ContainsKey(objId))
        {
            return;
        }
        // 保证线程数据安全
        lock (skillTriggerList)
        {
            var objKV = skillTriggerList[objId];
            foreach (var typeLevel1Dic in objKV)
            {
                var typeLevel1 = typeLevel1Dic.Key;
                foreach (var typeLevel2Dic in typeLevel1Dic.Value)
                {
                    var typeLevel2 = typeLevel2Dic.Key;
                    foreach (var skillTrigger in typeLevel2Dic.Value)
                    {
                        each(typeLevel1, typeLevel2, skillTrigger);
                    }
                    // 如果需要执行完毕后删除
                    if (isDelBeforeEnd)
                    {
                        ClearSkillTriggerData(objId, typeLevel1, typeLevel2);
                    }
                }
            }
        }
    }


    ///// <summary>
    ///// 设置伤害
    ///// </summary>
    ///// <param name="beHurtMember">被伤害单位</param>
    ///// <param name="attackMember">攻击单位</param>
    ///// <param name="hurt">造成的伤害</param>
    //public  void SetDamage(DisplayOwner beHurtMember, DisplayOwner attackMember, float hurt)
    //{
    //    // 验证数据
    //    if (beHurtMember == null || attackMember == null)
    //    {
    //        return;
    //    }
    //    var objId = beHurtMember.ClusterData.MemberData.ObjID;
    //    // 保存攻击对象
    //    if (!hitList.ContainsKey(objId))
    //    {
    //        hitList.Add(objId, new List<DisplayOwner>()
    //        {
    //            attackMember
    //        });
    //    }
    //    else
    //    {
    //        hitList[objId].Add(attackMember);
    //    }
    //    // 保存伤害
    //    if (!damageList.ContainsKey(objId))
    //    {
    //        damageList.Add(objId, hurt);
    //    }
    //    else
    //    {
    //        damageList[objId] += hurt;
    //    }
    //}

    ///// <summary>
    ///// 获得该单位所受伤害
    ///// </summary>
    ///// <param name="objId"></param>
    ///// <returns></returns>
    //public  float GetDemage(ObjectID objId)
    //{
    //    var result = 0f;

    //    if (objId != null && damageList.ContainsKey(objId))
    //    {
    //        result = damageList[objId];
    //    }

    //    return result;
    //}


    //public  IList<DisplayOwner> GetAttackMemberList(ObjectID objId)
    //{
    //    IList<DisplayOwner> result = null;

    //    if (objId != null && hitList.ContainsKey(objId))
    //    {
    //        result = hitList[objId];
    //    }

    //    return result;
    //}

    ///// <summary>
    ///// 清空一个单位的伤害列表
    ///// </summary>
    ///// <param name="objId">被清空单位</param>
    //public  void ClearOneDamageList(ObjectID objId)
    //{
    //    if (objId == null)
    //    {
    //        return;
    //    }
    //    if (hitList.ContainsKey(objId))
    //    {
    //        hitList[objId].Clear();
    //    }
    //    if (damageList.ContainsKey(objId))
    //    {
    //        damageList[objId] = 0f;
    //    }
    //}

    ///// <summary>
    ///// 清空所有单位的伤害列表
    ///// </summary>
    //public  void ClearAllDamageList()
    //{
    //    hitList.Clear();
    //    damageList.Clear();
    //}

    ///// <summary>
    ///// 设置闪避
    ///// </summary>
    ///// <param name="objId">闪避者ID</param>
    //public  void SetDodge(ObjectID objId)
    //{
    //    if (objId == null)
    //    {
    //        return;
    //    }
    //    dodgeList.Add(objId);
    //}

    ///// <summary>
    ///// 是否闪避
    ///// </summary>
    ///// <param name="objId">闪避者ID</param>
    ///// <returns>是否闪避</returns>
    //public  bool HasDodge(ObjectID objId)
    //{
    //    return dodgeList.Contains(objId);
    //}

    ///// <summary>
    ///// 删除一个闪避单位
    ///// </summary>
    ///// <param name="objId">被删除ObjId</param>
    //public  void ClearOneDodge(ObjectID objId)
    //{
    //    if (objId == null)
    //    {
    //        return;
    //    }
    //    dodgeList.Remove(objId);
    //}

    ///// <summary>
    ///// 清空闪避列表
    ///// </summary>
    //public  void ClearAllDodge()
    //{
    //    dodgeList.Clear();
    //}

    // ------------------------------------技能事件检测-----------------------------------
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


// -------------------------------技能触发数据类----------------------------------

public class SkillTriggerData
{
    /// <summary>
    /// 技能类列表
    /// </summary>
    //public List<SkillInfo> SkillInfoList { get; set; }

    /// <summary>
    /// 释放技能单位
    /// </summary>
    public DisplayOwner ReleaseMember { get; set; }

    /// <summary>
    /// 接受技能单位
    /// </summary>
    public DisplayOwner ReceiveMember { get; set; }

    /// <summary>
    /// 技能分类Level1
    /// </summary>
    public SkillTriggerLevel1 TypeLevel1 { get; set; }

    /// <summary>
    /// 技能分类Level2
    /// </summary>
    public SkillTriggerLevel2 TypeLevel2 { get; set; }

    /// <summary>
    /// 伤害量
    /// </summary>
    public float HealthChangeValue { get; set; }

}