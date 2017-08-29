using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using JetBrains.Annotations;
using UnityEngine;

/// <summary>
/// 范围功能管理器
/// </summary>
public class RemainManager
{


    /// <summary>
    /// 单例
    /// </summary>
    public static RemainManager Single
    {
        get
        {
            if (single == null)
            {
                single = new RemainManager();
            }
            return single;
        }
    }

    /// <summary>
    /// 单例实体
    /// </summary>
    private static RemainManager single = null;

    /// <summary>
    /// remain原始数据字典
    /// 读取后不作变更
    /// (remainID,remainInfo类)
    /// </summary>
    private IDictionary<int, RemainInfo> remainDic = new Dictionary<int, RemainInfo>();

    /// <summary>
    /// remain具体实现的字典
    /// (remainAddtionId, remainInfo类)
    /// </summary>
    private IDictionary<long, RemainInfo> remainInstanceDic = new Dictionary<long, RemainInfo>();



    /// <summary>
    /// 添加remain原始类到缓存中
    /// </summary>
    /// <param name="remainInfo">remain类</param>
    public void AddRemainInfo(RemainInfo remainInfo)
    {
        if (remainInfo == null)
        {
            throw new Exception("技能对象为空!");
        }
        // 是否已存在remainID
        if (remainDic.ContainsKey(remainInfo.Num))
        {
            throw new Exception("已存在remain编号:" + remainInfo.Num);
        }
        remainDic.Add(remainInfo.Num, remainInfo);
    }

    /// <summary>
    /// 是否包含指定Id的唯一实现
    /// </summary>
    /// <param name="remainAddtionId"></param>
    /// <returns></returns>
    public bool ContainsInstanceRemainId(long remainAddtionId)
    {
        return remainInstanceDic.ContainsKey(remainAddtionId);
    }

    /// <summary>
    /// 获得remain的指定实例
    /// </summary>
    /// <param name="remainAddtionId">remain实例唯一ID</param>
    /// <returns>如果存在返回指定对象, 不存在返回null</returns>
    public RemainInfo GetRemainInstance(long remainAddtionId)
    {
        if (ContainsInstanceRemainId(remainAddtionId))
        {
            return remainInstanceDic[remainAddtionId];
        }
        return null;
    }

    /// <summary>
    /// 删除remain具体实现
    /// </summary>
    /// <param name="remainAddtionId">remain具体实现唯一ID</param>
    public void DelRemainInstance(long remainAddtionId)
    {
        remainInstanceDic.Remove(remainAddtionId);
    }


    /// <summary>
    /// 加载Remain类
    /// 如果缓存中没有就从文件照片那个加载
    /// </summary>
    /// <param name="remainId">RemainID</param>
    /// <param name="release">Remain的释放者</param>
    /// <param name="level">Remain等级</param>
    /// <returns></returns>
    public RemainInfo CreateRemainInfo(int remainId, DisplayOwner release, int level = 1)
    {
        RemainInfo result = null;

        // 验证技能ID的有效性
        if (remainId > 0)
        {
            // 检查缓存
            if (remainDic.ContainsKey(remainId))
            {
                // 复制buff
                result = remainDic[remainId];
            }
            else
            {
                // 加载文件内容
                var buffTxt = GetRemainScript(remainId, SkillManager.Single.RunType);
                if (!string.IsNullOrEmpty(buffTxt))
                {
                    result = FormulaConstructor.RemainConstructor(buffTxt);
                    // 将其放入缓存
                    AddRemainInfo(result);
                }
            }
        }

        if (result == null)
        {
            return null;
        }

        result = CopyRemainInfo(result);
        result.ReplaceData(level);
        // 将实现放入实现列表
        remainInstanceDic.Add(result.AddtionId, result);
        result.ReleaseMember = release;
        return result;
    }


    /// <summary>
    /// 获取技能脚本
    /// </summary>
    /// <param name="remainNum"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    public string GetRemainScript(int remainNum, int type = 0)
    {
        var result = "";
        switch (type)
        {
            case 0:
                result = PacketManage.Single.GetPacket(SkillManager.SkillPacketName).LoadString("RemainScript" + remainNum + ".txt");
                break;
            case 1:
                var file =
                    new FileInfo(Application.streamingAssetsPath + Path.DirectorySeparatorChar + "RemainScript" +
                                 remainNum + ".txt");
                if (file.Exists)
                {
                    // 加载文件内容
                    result = Utils.LoadFileInfo(file);
                }
                break;
        }

        return result;
    }



    /// <summary>
    /// 复制RemainInfo信息
    /// </summary>
    /// <param name="remainInfo">被复制信息</param>
    /// <returns>复制数据</returns>
    public RemainInfo CopyRemainInfo([NotNull]RemainInfo remainInfo)
    {
        RemainInfo result = null;
        result = new RemainInfo(remainInfo.Num)
        {
            ActionTime = remainInfo.ActionTime,
            ActionCamp = remainInfo.ActionCamp,
            CouldActionOnAir = remainInfo.CouldActionOnAir,
            CouldActionOnBuilding = remainInfo.CouldActionOnBuilding,
            CouldActionOnSurface = remainInfo.CouldActionOnSurface,
            DataList = remainInfo.DataList,
            DuringTime = remainInfo.DuringTime,
            FixPostion = remainInfo.FixPostion,
            HasActionFormula = remainInfo.HasActionFormula,
            HasAttachFormula = remainInfo.HasAttachFormula,
            HasDetachFormula = remainInfo.HasDetachFormula,
            IsFollow = remainInfo.IsFollow,
            Range = remainInfo.Range,
            ReplaceSourceDataDic = remainInfo.ReplaceSourceDataDic
        };
        result.AddActionFormulaItem(remainInfo.GetActionFormulaItem());
        result.AddAttachFormulaItem(remainInfo.GetAttachFormulaItem());
        result.AddDetachFormulaItem(remainInfo.GetDetachFormulaItem());

        return result;
    }


}