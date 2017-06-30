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
    public IDictionary<long, SkillInfo> SkillInfoDic = new Dictionary<long, SkillInfo>();

    /// <summary>
    /// skill具体实现的字典
    /// (buffAddtionId, Buff类)
    /// </summary>
    private IDictionary<long, SkillInfo> skillInstanceDic = new Dictionary<long, SkillInfo>();


    /// <summary>
    /// 技能触发字典
    /// </summary>
    private static IDictionary<ObjectID, IDictionary<TriggerLevel1, IDictionary<TriggerLevel2, List<TriggerData>>>>
        triggerList = new Dictionary <ObjectID, IDictionary<TriggerLevel1, IDictionary<TriggerLevel2, List<TriggerData>>>>();

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
    /// 加载并创建技能实例
    /// </summary>
    /// <param name="skillId">技能ID 必须为>0的整数</param>
    /// <returns>技能实例</returns>
    public SkillInfo CreateSkillInfo(int skillId)
    {
        return CreateSkillInfo(skillId, null);
    }

    /// <summary>
    /// 加载并创建技能实例
    /// TODO 需要判断当前运行状态, 并添加包加载方式
    /// </summary>
    /// <param name="skillId">技能ID</param>
    /// <param name="skillHolder">技能持有单位</param>
    /// <returns>技能实例</returns>
    public SkillInfo CreateSkillInfo(int skillId, DisplayOwner skillHolder = null)
    {
        SkillInfo result = null;

        // 验证技能ID的有效性
        if (skillId > 0)
        {
            // 检查缓存
            if (SkillInfoDic.ContainsKey(skillId))
            {
                // 复制技能数据
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
                        result = FormulaConstructor.SkillConstructor(skillTxt);
                        // 将其放入缓存
                        AddSkillInfo(result);
                    }
                }
            }
        }
        result = CopySkillInfo(result);
        result.ReleaseMember = skillHolder;
        // 将技能实现放入实现列表
        skillInstanceDic.Add(result.AddtionId, result);
        return result;
    }

    /// <summary>
    /// 创建技能实例
    /// </summary>
    /// <param name="skillIdList">技能ID列表</param>
    /// <param name="skillHolder">技能持有者</param>
    /// <returns>技能信息列表</returns>
    public IList<SkillInfo> CreateSkillInfoList(IList<int> skillIdList, DisplayOwner skillHolder = null)
    {
        List<SkillInfo> result = null;
        if (skillIdList != null && skillIdList.Count > 0)
        {
            result = new List<SkillInfo>();
            foreach (var skillId in skillIdList)
            {
                var skillInfo = CreateSkillInfo(skillId, skillHolder);
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

    /// <summary>
    /// 将技能中的属性(如果有)附加到单位属性上
    /// </summary>
    /// <param name="skillInfo">技能信息</param>
    /// <param name="memberData">单位属性</param>
    public void AttachSkillAttribute(SkillInfo skillInfo, VOBase memberData)
    {
        if (skillInfo == null || memberData == null)
        {
            return;
        }
        SkillBase.AdditionAttribute(memberData, skillInfo);
    }

    /// <summary>
    /// 复制技能信息
    /// </summary>
    /// <param name="skillInfo">被复制信息</param>
    /// <returns>复制数据</returns>
    public SkillInfo CopySkillInfo(SkillInfo skillInfo)
    {
        SkillInfo result = null;
        if (skillInfo != null)
        {
            result = new SkillInfo(skillInfo.Num)
            {
                CDGroup = skillInfo.CDGroup,
                CDTime = skillInfo.CDTime,
                DataList = skillInfo.DataList,
                ChangeData = skillInfo.ChangeData,
                ChangeDataTypeDic = skillInfo.ChangeDataTypeDic,
                Description = skillInfo.Description,
                Icon = skillInfo.Icon,
                ReleaseMember = skillInfo.ReleaseMember,
                ReleaseTime = skillInfo.ReleaseTime,
                TickTime = skillInfo.TickTime,
                TriggerLevel1 = skillInfo.TriggerLevel1,
                TriggerLevel2 = skillInfo.TriggerLevel2
            };
            result.AddActionFormulaItem(skillInfo.GetActionFormulaItem());
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
            //var objId = packer.ReleaseMember.ClusterData.AllData.MemberData.ObjID.ID;
            //var skillNum = skillInfo.Num;
            // 技能是否在CD
            if (!CDTimer.Instance().IsInCD(skillInfo.AddtionId))
            {
                CDTimer.Instance().SetInCD(skillInfo.AddtionId, 1);
                // 技能CDGroup
                // 技能可释放次数-暂时不做

                DoFormula(skillInfo.GetFormula(packer));
            }
            // 否则技能在CD中不能释放
        }
    }

    /// <summary>
    /// 按照技能ID执行技能
    /// 会创建一个新的技能实例并执行
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
        // 创建新的技能实例
        var skillInfo = CopySkillInfo(SkillInfoDic[skillNum]);
        DoShillInfo(skillInfo, packer, isSubSkill);
    }

    /// <summary>
    /// 添加技能原始类到字典中
    /// 原始类不会再做变更, 执行该ID的技能会复制该技能的内容后使用复制类执行
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
        if (SkillInfoDic.ContainsKey(skillInfo.Num))
        {
            throw new Exception("已存在技能编号:" + skillInfo.Num);
        }

        // 将技能加入字典中
        SkillInfoDic.Add(skillInfo.Num, skillInfo);
    }

    /// <summary>
    /// 是否包含指定Id的唯一实现
    /// </summary>
    /// <param name="skillAddtionId"></param>
    /// <returns></returns>
    public bool ContainsInstanceSkillId(long skillAddtionId)
    {
        return SkillInfoDic.ContainsKey(skillAddtionId);
    }

    /// <summary>
    /// 获得skill的指定实例
    /// </summary>
    /// <param name="skillAddtionId">skill实例唯一ID</param>
    /// <returns>如果存在返回指定对象, 不存在返回null</returns>
    public SkillInfo GetSkillInstance(long skillAddtionId)
    {
        if (ContainsInstanceSkillId(skillAddtionId))
        {
            return skillInstanceDic[skillAddtionId];
        }
        return null;
    }

    /// <summary>
    /// 删除skill具体实现
    /// </summary>
    /// <param name="skillAddtionId">skill具体实现唯一ID</param>
    public void DelBuffInstance(long skillAddtionId)
    {
        skillInstanceDic.Remove(skillAddtionId);
    }


    ///// <summary>
    ///// 检查并执行符合条件的技能
    ///// </summary>
    ///// <param name="skillsList">被检查列表</param>
    ///// <param name="releaseOwner">技能释放单位</param>
    ///// <param name="receiveOwner">技能被释放单位</param>
    ///// <param name="type1">第一级技能触发类型</param>
    ///// <param name="type2">第二级技能触发类型</param>
    //public void CheckAndDoSkillInfo(IList<SkillInfo> skillsList,
    //    DisplayOwner releaseOwner,
    //    DisplayOwner receiveOwner,
    //    TriggerLevel1 type1,
    //    TriggerLevel2 type2)
    //{
    //    // 如果攻击时触发
    //    foreach (var skill in skillsList.Where(skill => skill != null && skill.TriggerLevel1 == type1 && skill.TriggerLevel2 == type2))
    //    {
    //        // 触发技能
    //        DoShillInfo(skill, FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(skill, releaseOwner, receiveOwner));
    //    }
    //}

    /// <summary>
    /// 检查并执行符合条件的技能
    /// </summary>
    /// <param name="skillsList">被检查列表</param>
    /// <param name="triggerData">事件数据</param>
    public void CheckAndDoSkillInfo(IList<SkillInfo> skillsList, TriggerData triggerData)
    {
        // 如果攻击时触发
        foreach (var skill in skillsList.Where(skill => skill != null && skill.TriggerLevel1 == triggerData.TypeLevel1 && skill.TriggerLevel2 == triggerData.TypeLevel2))
        {
            var paramsPacker = FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(skill, triggerData.ReleaseMember,
                triggerData.ReceiveMember);
            // 将触发数据传入
            paramsPacker.TriggerData = triggerData;
            // 触发技能
            DoShillInfo(skill, paramsPacker);
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

            } while (topNode != null && topNode.CanMoveNext);
        }
    }

    // ------------------------------------技能事件检测-----------------------------------

    /// <summary>
    /// 添加事件数据
    /// </summary>
    /// <param name="triggerData">事件数据</param>
    public void SetTriggerData(TriggerData triggerData)
    {
        if (triggerData == null || triggerData.ReleaseMember == null)
        {
            return;
        }

        var objId = triggerData.ReleaseMember.ClusterData.AllData.MemberData.ObjID;
        if (!triggerList.ContainsKey(objId))
        {
            triggerList.Add(objId,
                new Dictionary<TriggerLevel1, IDictionary<TriggerLevel2, List<TriggerData>>>()
                {
                    {
                        triggerData.TypeLevel1, new Dictionary<TriggerLevel2, List<TriggerData>>()
                        {
                            {triggerData.TypeLevel2, new List<TriggerData>() {triggerData}}
                        }
                    }
                });
        }
        else
        {
            var dicLevel1 = triggerList[objId];
            if (!dicLevel1.ContainsKey(triggerData.TypeLevel1))
            {
                dicLevel1.Add(triggerData.TypeLevel1,
                    new Dictionary<TriggerLevel2, List<TriggerData>>()
                    {
                        {
                            triggerData.TypeLevel2, new List<TriggerData>() {triggerData}
                        }
                    });
            }
            else
            {
                var dicLevel2 = dicLevel1[triggerData.TypeLevel1];
                if (!dicLevel2.ContainsKey(triggerData.TypeLevel2))
                {
                    dicLevel2.Add(triggerData.TypeLevel2, new List<TriggerData>() {triggerData});
                }
                else
                {
                    dicLevel2[triggerData.TypeLevel2].Add(triggerData);
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
    public List<TriggerData> GetSkillTriggerDataList(ObjectID objId, TriggerLevel1 type1,
        TriggerLevel2 type2)
    {
        if (triggerList.ContainsKey(objId))
        {
            var dicLevel1 = triggerList[objId];
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
    public void ClearSkillTriggerData(ObjectID objId, TriggerLevel1 typeLevel1, TriggerLevel2 typeLevel2)
    {
        if (triggerList.ContainsKey(objId))
        {
            var dicLevel1 = triggerList[objId];
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
        triggerList.Clear();
    }

    ///// <summary>
    ///// 循环整体事件列表并执行each
    ///// </summary>
    ///// <param name="each">被执行单位处理</param>
    ///// <param name="isDelBeforeEnd">是否执行完毕后删除</param>
    //public void SetEachAction(Action<ObjectID, TriggerLevel1, TriggerLevel2, TriggerData> each, bool isDelBeforeEnd = false)
    //{
    //    if (each == null)
    //    {
    //        return;
    //    }
    //    foreach (var objKV in triggerList)
    //    {
    //        var objId = objKV.Key;
    //        foreach (var typeLevel1Dic in objKV.Value)
    //        {
    //            var typeLevel1 = typeLevel1Dic.Key;
    //            foreach (var typeLevel2Dic in typeLevel1Dic.Value)
    //            {
    //                var typeLevel2 = typeLevel2Dic.Key;
    //                foreach (var skillTrigger in typeLevel2Dic.Value)
    //                {
    //                    each(objId, typeLevel1, typeLevel2, skillTrigger);
    //                }
    //                // 如果需要执行完毕后删除
    //                if (isDelBeforeEnd)
    //                {
    //                    ClearSkillTriggerData(objId, typeLevel1, typeLevel2);
    //                }
    //            }
    //        }
    //    }
    //}

    /// <summary>
    /// 循环整体事件列表并执行each
    /// </summary>
    /// <param name="objId">单位ObjId</param>
    /// <param name="each">被执行单位处理</param>
    /// <param name="isDelBeforeEnd">是否执行完毕后删除</param>
    public void SetEachAction(ObjectID objId, Action<TriggerLevel1, TriggerLevel2, TriggerData> each, bool isDelBeforeEnd)
    {
        if (each == null || !triggerList.ContainsKey(objId))
        {
            return;
        }
        // 保证线程数据安全
        lock (triggerList)
        {
            var objKV = triggerList[objId];
            foreach (var typeLevel1Dic in objKV)
            {
                var typeLevel1 = typeLevel1Dic.Key;
                foreach (var typeLevel2Dic in typeLevel1Dic.Value)
                {
                    var typeLevel2 = typeLevel2Dic.Key;
                    foreach (var triggerDic in typeLevel2Dic.Value)
                    {
                        each(typeLevel1, typeLevel2, triggerDic);

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
