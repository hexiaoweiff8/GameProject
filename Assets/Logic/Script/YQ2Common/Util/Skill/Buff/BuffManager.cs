using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;


/// <summary>
/// buff管理器
/// </summary>
public class BuffManager : Singleton<BuffManager>
{
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
    /// 添加buff类到缓存中
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
    public bool ContainsBuffId(long buffAddtionId)
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
        if (ContainsBuffId(buffAddtionId))
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
    /// <param name="buffId"></param>
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
    public BuffInfo CopySkillInfo(BuffInfo buffInfo)
    {
        BuffInfo result = null;
        if (buffInfo != null)
        {
            result = new BuffInfo(buffInfo.Num);
            result.BuffLevel = buffInfo.BuffLevel;
            result.BuffTime = buffInfo.BuffTime;
            result.BuffType = buffInfo.BuffType;
            result.ChangeData = buffInfo.ChangeData;
            result.ChangeDataType = buffInfo.ChangeDataType;
            result.DataList = buffInfo.DataList;
            result.Description = buffInfo.Description;
            result.ExistType = buffInfo.ExistType;
            result.Icon = buffInfo.Icon;
            result.IsBeneficial = buffInfo.IsBeneficial;
            result.IsDeadDisappear = buffInfo.IsDeadDisappear;
            result.ReceiveMember = buffInfo.ReceiveMember;
            result.ReleaseMember = buffInfo.ReleaseMember;
            result.TickTime = buffInfo.TickTime;
            result.TriggerLevel1 = buffInfo.TriggerLevel1;
            result.TriggerLevel2 = buffInfo.TriggerLevel2;
            result.AddActionFormulaItem(buffInfo.GetActionFormulaItem());
            result.AddAttachFormulaItem(buffInfo.GetAttachFormulaItem());
            result.AddDetachFormulaItem(buffInfo.GetDetachFormulaItem());
        }

        return result;
    }


    // -----------------------buff效果执行----------------------------


    /// <summary>
    /// buff的Attach事件
    /// </summary>
    /// <param name="buffInfo">buff数据</param>
    /// <param name="buffDoType">buff执行类型</param>
    public void DoBuff(BuffInfo buffInfo, BuffDoType buffDoType)
    {
        if (buffInfo == null || buffInfo.ReleaseMember == null || buffInfo.ReceiveMember == null)
        {
            throw new Exception("参数错误.");
        }

        IFormula formula = null;
        switch (buffDoType)
        {
            case BuffDoType.Action:
                formula = buffInfo.GetActionFormula(FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buffInfo.ReleaseMember,
                    buffInfo.ReceiveMember, 1));
                break;

            case BuffDoType.Attach:
                // TODO 走一套互斥或叠加或共存的检测流程
                buffInfo.ReceiveMember.ClusterData.AllData.BuffInfoList.Add(buffInfo);
                // 设置buff启动时间
                buffInfo.BuffStartTime = DateTime.Now.Ticks;
                formula = buffInfo.GetAttachFormula(FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buffInfo.ReleaseMember,
                    buffInfo.ReceiveMember, 1));
                break;

            case BuffDoType.Detach:
                buffInfo.ReceiveMember.ClusterData.AllData.BuffInfoList.Remove(buffInfo);
                formula = buffInfo.GetDetachFormula(FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buffInfo.ReleaseMember,
                    buffInfo.ReceiveMember, 1));
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
    public void DoBuffInfo(BuffInfo buffInfo, FormulaParamsPacker packer)
    {
        if (buffInfo == null)
        {
            throw new Exception("buff类为空.");
        }
        else
        {
            var objId = packer.ReleaseMember.ClusterData.AllData.MemberData.ObjID.ID;
            var buffNum = buffInfo.Num;
            // 技能是否在CD
            if (!CDTimer.Instance().IsInCD(objId, buffNum))
            {
                CDTimer.Instance().SetInCD(objId, buffNum, 1);
                // 技能CDGroup
                // 技能可释放次数-暂时不做

                SkillManager.Single.DoFormula(buffInfo.GetActionFormula(packer));
            }
            // 否则技能在CD中不能释放
        }
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