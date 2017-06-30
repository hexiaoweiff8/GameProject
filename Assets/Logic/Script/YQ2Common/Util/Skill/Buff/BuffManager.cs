using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using JetBrains.Annotations;
using UnityEditor;
using UnityEngine;


/// <summary>
/// buff管理器
/// </summary>
public class BuffManager
{

    /// <summary>
    /// 单例
    /// </summary>
    public static BuffManager Single
    {
        get
        {
            if (single == null)
            {
                single = new BuffManager();
            }
            return single;
        }
    }

    /// <summary>
    /// 单例实体
    /// </summary>
    private static BuffManager single = null;

    /// <summary>
    /// Buff原始数据字典
    /// 读取后不作变更
    /// (buffID,Buff类)
    /// </summary>
    private IDictionary<int, BuffInfo> buffDic = new Dictionary<int, BuffInfo>();

    /// <summary>
    /// buff具体实现的字典
    /// (buffAddtionId, Buff类)
    /// </summary>
    private IDictionary<long, BuffInfo> buffInstanceDic = new Dictionary<long, BuffInfo>();


    /// <summary>
    /// 添加buff原始类到缓存中
    /// </summary>
    /// <param name="buffInfo">buff类</param>
    public void AddBuffInfo(BuffInfo buffInfo)
    {
        if (buffInfo == null)
        {
            throw new Exception("技能对象为空!");
        }
        // 是否已存在buffID
        if (buffDic.ContainsKey(buffInfo.Num))
        {
            throw new Exception("已存在buff编号:" + buffInfo.Num);
        }
        buffDic.Add(buffInfo.Num, buffInfo);
    }

    /// <summary>
    /// 是否包含指定Id的唯一实现
    /// </summary>
    /// <param name="buffAddtionId"></param>
    /// <returns></returns>
    public bool ContainsInstanceBuffId(long buffAddtionId)
    {
        return buffInstanceDic.ContainsKey(buffAddtionId);
    }

    /// <summary>
    /// 获得buff的指定实例
    /// </summary>
    /// <param name="buffAddtionId">buff实例唯一ID</param>
    /// <returns>如果存在返回指定对象, 不存在返回null</returns>
    public BuffInfo GetBuffInstance(long buffAddtionId)
    {
        if (ContainsInstanceBuffId(buffAddtionId))
        {
            return buffInstanceDic[buffAddtionId];
        }
        return null;
    }

    /// <summary>
    /// 删除buff具体实现
    /// </summary>
    /// <param name="buffAddtionId">buff具体实现唯一ID</param>
    public void DelBuffInstance(long buffAddtionId)
    {
        buffInstanceDic.Remove(buffAddtionId);
    }

    /// <summary>
    /// 加载buff类
    /// 如果缓存中没有就从文件照片那个加载
    /// </summary>
    /// <param name="buffId">buffID</param>
    /// <param name="receive">buff的接受者</param>
    /// <param name="release">buff的释放者</param>
    /// <returns></returns>
    public BuffInfo CreateBuffInfo(int buffId, DisplayOwner receive, DisplayOwner release)
    {
        BuffInfo result = null;

        // 验证技能ID的有效性
        if (buffId > 0)
        {
            // 检查缓存
            if (buffDic.ContainsKey(buffId))
            {
                // 复制buff
                result = buffDic[buffId];
            }
            else
            {
                // TODO 加载文件从包中加载 检测文件是否存在
                var file = new FileInfo(Application.streamingAssetsPath + Path.DirectorySeparatorChar + "BuffScript" + buffId + ".txt");
                if (file.Exists)
                {
                    // 加载文件内容
                    var buffTxt = Utils.LoadFileInfo(file);
                    if (!string.IsNullOrEmpty(buffTxt))
                    {
                        result = FormulaConstructor.BuffConstructor(buffTxt);
                        // 将其放入缓存
                        AddBuffInfo(result);
                    }
                }
                else
                {
                    Debug.LogError("ID为:" + buffId + "的buff不存在.");
                }
            }
        }
        result = CopySkillInfo(result);
        // 将实现放入实现列表
        buffInstanceDic.Add(result.AddtionId, result);
        result.ReceiveMember = receive;
        result.ReleaseMember = release;
        return result;
    }


    ///// <summary>
    ///// 加载buff列表
    ///// </summary>
    ///// <param name="buffIdList">BuffID列表</param>
    ///// <returns>Buff信息列表</returns>
    //public IList<BuffInfo> CreateBuffInfoList(IList<int> buffIdList)
    //{
    //    List<BuffInfo> result = null;
    //    if (buffIdList != null && buffIdList.Count > 0)
    //    {
    //        result = new List<BuffInfo>();
    //        foreach (var skillId in buffIdList)
    //        {
    //            var skillInfo = CreateBuffInfo(skillId);
    //            if (skillInfo != null)
    //            {
    //                result.Add(skillInfo);
    //            }
    //        }
    //    }

    //    return result;
    //}


    /// <summary>
    /// 复制buff信息
    /// </summary>
    /// <param name="buffInfo">被复制信息</param>
    /// <returns>复制数据</returns>
    public BuffInfo CopySkillInfo([NotNull]BuffInfo buffInfo)
    {
        BuffInfo result = null;
        result = new BuffInfo(buffInfo.Num)
        {
            BuffLevel = buffInfo.BuffLevel,
            BuffTime = buffInfo.BuffTime,
            BuffType = buffInfo.BuffType,
            ChangeData = buffInfo.ChangeData,
            ChangeDataTypeDic = buffInfo.ChangeDataTypeDic,
            DataList = buffInfo.DataList,
            Description = buffInfo.Description,
            //ExistType = buffInfo.ExistType,
            Icon = buffInfo.Icon,
            IsBeneficial = buffInfo.IsBeneficial,
            IsDeadDisappear = buffInfo.IsDeadDisappear,
            IsNotLethal = buffInfo.IsNotLethal,
            ReceiveMember = buffInfo.ReceiveMember,
            ReleaseMember = buffInfo.ReleaseMember,
            TickTime = buffInfo.TickTime,
            TriggerLevel1 = buffInfo.TriggerLevel1,
            TriggerLevel2 = buffInfo.TriggerLevel2,
            DetachTriggerLevel1 = buffInfo.DetachTriggerLevel1,
            DetachTriggerLevel2 = buffInfo.DetachTriggerLevel2,
            DetachQualifiedKeyList = buffInfo.DetachQualifiedKeyList,
            DetachQualifiedOptionList = buffInfo.DetachQualifiedOptionList,
            DetachQualifiedValueList = buffInfo.DetachQualifiedValueList
        };
        result.AddActionFormulaItem(buffInfo.GetActionFormulaItem());
        result.AddAttachFormulaItem(buffInfo.GetAttachFormulaItem());
        result.AddDetachFormulaItem(buffInfo.GetDetachFormulaItem());

        return result;
    }


    // -----------------------buff效果执行----------------------------

    ///// <summary>
    ///// 检查并执行符合条件的技能
    ///// </summary>
    ///// <param name="buffList">被检查列表</param>
    ///// <param name="releaseOwner">技能释放单位</param>
    ///// <param name="receiveOwner">技能被释放单位</param>
    ///// <param name="type1">第一级技能触发类型</param>
    ///// <param name="type2">第二级技能触发类型</param>
    //public void CheckAndDoBuffInfo(IList<BuffInfo> buffList,
    //    DisplayOwner releaseOwner,
    //    DisplayOwner receiveOwner,
    //    TriggerLevel1 type1,
    //    TriggerLevel2 type2)
    //{
    //    // 如果攻击时触发
    //    foreach (var buff in buffList.Where(skill => skill != null && skill.TriggerLevel1 == type1 && skill.TriggerLevel2 == type2))
    //    {
    //        // 触发技能
    //        DoBuff(buff, BuffDoType.Action, FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buff.ReleaseMember, buff.ReceiveMember, buff, 1, buff.IsNotLethal));
    //    }
    //}


    /// <summary>
    /// 检查并执行符合条件的技能
    /// </summary>
    /// <param name="buffList">被检查列表</param>
    /// <param name="triggerData">事件数据</param>
    public void CheckAndDoBuffInfo([NotNull]IList<BuffInfo> buffList, [NotNull]TriggerData triggerData)
    {
        if (buffList.Count == 0)
        {
            return;
        }
        if (triggerData.TypeLevel1 == TriggerLevel1.None || triggerData.TypeLevel2 == TriggerLevel2.None)
        {
            // 不存在事件不触发
            Debug.Log("空事件");
            return;
        }
        var list = buffList.Where(buff => buff != null
                                                    && ((buff.TriggerLevel1 == triggerData.TypeLevel1
                                                         && buff.TriggerLevel2 == triggerData.TypeLevel2)
                                                        || buff.DetachTriggerLevel1 == triggerData.TypeLevel1
                                                        && buff.DetachTriggerLevel2 == triggerData.TypeLevel2)).ToList();
        // 如果攻击时触发
        for (var i = 0; i < list.Count(); i++)
        {
            var buff = list[i];
            var paramsPacker = FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buff.ReleaseMember,
                buff.ReceiveMember, buff, 1, buff.IsNotLethal);
            paramsPacker.TriggerData = triggerData;

            // 触发技能
            // 触发action
            if (buff.TriggerLevel1 == triggerData.TypeLevel1 && buff.TriggerLevel2 == triggerData.TypeLevel2)
            {
                DoBuff(buff, BuffDoType.Action, paramsPacker);
            }
            // 检测Detach条件如果符合触发detach
            if (buff.DetachTriggerLevel1 == triggerData.TypeLevel1 && buff.DetachTriggerLevel2 == triggerData.TypeLevel2 && buff.CheckDetach())
            {
                DoBuff(buff, BuffDoType.Detach, paramsPacker);
            }
        }
    }

    /// <summary>
    /// buff的Attach事件
    /// </summary>
    /// <param name="buffInfo">buff数据</param>
    /// <param name="buffDoType">buff执行类型</param>
    /// <param name="paramsPacker"></param>
    public void DoBuff([NotNull]BuffInfo buffInfo, BuffDoType buffDoType, [NotNull]FormulaParamsPacker paramsPacker)
    {
        if (buffInfo.ReleaseMember == null || buffInfo.ReceiveMember == null)
        {
            throw new Exception("参数错误.");
        }

        IFormula formula = null;
        switch (buffDoType)
        {
            case BuffDoType.Action:
                formula = buffInfo.GetActionFormula(paramsPacker);
                break;

            case BuffDoType.Attach:

                // 互斥或叠加或共存的检测流程
                if (BuffAttachRule(buffInfo.ReceiveMember.ClusterData.AllData.BuffInfoList, buffInfo))
                {
                    // 设置buff启动时间
                    buffInfo.BuffStartTime = DateTime.Now.Ticks;
                    formula = buffInfo.GetAttachFormula(paramsPacker);
                    // 判断是否需要将buff放入TriggerTicker中
                    if (buffInfo.TriggerLevel1 == TriggerLevel1.Time && buffInfo.TriggerLevel2 == TriggerLevel2.TickTime)
                    {
                        TriggerTicker.Single.Add(buffInfo);
                    }

                    // 如果buff增加属性, 则将属性加入对象中
                    SkillBase.AdditionAttribute(buffInfo.ReceiveMember.ClusterData.AllData.MemberData, buffInfo);
                }
                break;

            case BuffDoType.Detach:
                Debug.Log("Buff Detach");
                buffInfo.ReceiveMember.ClusterData.AllData.BuffInfoList.Remove(buffInfo);
                formula = buffInfo.GetDetachFormula(paramsPacker);
                // 检查TriggerTicker中是否有该buff, 如果有则删除
                TriggerTicker.Single.Remove(buffInfo.AddtionId);

                // 如果buff增加了属性, 则将属性从对象属性中删除
                SkillBase.SubAttribute(buffInfo.ReceiveMember.ClusterData.AllData.MemberData, buffInfo.ChangedData);
                // 从buff列表中删除buff实例
                DelBuffInstance(buffInfo.AddtionId);
                break;
        }
        // TODO 数据是否完整有待商议
        SkillManager.Single.DoFormula(formula);
    }

    /// <summary>
    /// 执行buff触发效果
    /// </summary>
    /// <param name="buffInfo">技能对象</param>
    /// <param name="packer">技能数据包</param>
    public void DoBuffInfo([NotNull] BuffInfo buffInfo, [NotNull] FormulaParamsPacker packer)
    {
        //var objId = packer.ReleaseMember.ClusterData.AllData.MemberData.ObjID.ID;
        //var buffNum = buffInfo.Num;
        // 技能是否在CD
        if (!CDTimer.Instance().IsInCD(buffInfo.AddtionId))
        {
            CDTimer.Instance().SetInCD(buffInfo.AddtionId, 1);
            // 技能CDGroup
            // 技能可释放次数-暂时不做

            SkillManager.Single.DoFormula(buffInfo.GetActionFormula(packer));
        }
        // 否则技能在CD中不能释放
    }

    /// <summary>
    /// 按照buffID执行
    /// </summary>
    /// <param name="buffNum">buffID</param>
    /// <param name="packer">buff数据包</param>
    public void DoSkillNum(int buffNum, FormulaParamsPacker packer)
    {
        if (!buffDic.ContainsKey(buffNum))
        {
            throw new Exception("buffID不存在:" + buffNum);
        }

        var buffInfo = buffDic[buffNum];
        DoBuffInfo(buffInfo, packer);
    }




    /// <summary>
    /// buff挂载规则
    /// </summary>
    /// <param name="buffList">被挂载单位buff列表</param>
    /// <param name="buffInfo">被挂载buff</param>
    private bool BuffAttachRule([NotNull]IList<BuffInfo> buffList, [NotNull]BuffInfo buffInfo)
    {
        if (buffList.Count == 0 || buffInfo.BuffGroup < 0)
        {
            buffList.Add(buffInfo);
            return true;
        }

        var sameGroupBuffList = buffList.Where(buff => buff.BuffGroup == buffInfo.BuffGroup).ToList();
        // 查找是否有相同buffgroup的
        // 如果没有返回
        if (!sameGroupBuffList.Any())
        {
            buffList.Add(buffInfo);
            return true;
        }
        // 是否存在同组buff且不高于新buff的level的buff
        var replaceBuff = sameGroupBuffList.FirstOrDefault(tmpBuff => tmpBuff.BuffLevel < buffInfo.BuffLevel);
        if (replaceBuff == null)
        {
            Debug.Log("buff互斥");
            return false;
        }

        // Detach旧buff
        DoBuff(replaceBuff, BuffDoType.Detach,
            FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(replaceBuff.ReleaseMember,
                replaceBuff.ReceiveMember, replaceBuff, 1, replaceBuff.IsNotLethal));
        // 新buff放入列表
        buffList.Add(buffInfo);
        return true;
    }

    
    // TODO 反射相关类无法成为泛型的传递类型
    //private void ForeachPropertyAndField(VOBase memberData,
    //    VOBase changeData,
    //    VOBase changedData,
    //    IDictionary<string, ChangeDataType> changeDataTypeDic,
    //    Action<PropertyInfo, VOBase, VOBase, VOBase, IDictionary<string, ChangeDataType>> propertyAction,
    //    Action<FieldInfo, VOBase, VOBase, VOBase, IDictionary<string, ChangeDataType>> fieldAction)
    //{
    //    var propertyList = typeof(VOBase).GetProperties().Where((property) =>
    //    {
    //        if (property.GetCustomAttributes(typeof(SkillAddition), false).Any())
    //        {
    //            return true;
    //        }
    //        return false;
    //    });

    //    foreach (var property in propertyList)
    //    {
    //        propertyAction(property, memberData, changeData, changedData, changeDataTypeDic);
    //    }

    //    var fieldList = typeof(VOBase).GetFields().Where((property) =>
    //    {
    //        if (property.GetCustomAttributes(typeof(SkillAddition), false).Any())
    //        {
    //            return true;
    //        }
    //        return false;
    //    });
    //    foreach (var field in fieldList)
    //    {
    //        fieldAction(field, memberData, changeData, changedData, changeDataTypeDic);
    //    }
    //}
}

/// <summary>
/// buff事件类型
/// </summary>
public enum BuffDoType
{
    Action = 0,     // buff触发执行
    Attach,         // buff产生执行
    Detach          // buff销毁执行
}