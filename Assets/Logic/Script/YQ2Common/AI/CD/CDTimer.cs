using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using Util;


/// <summary>
/// 技能CD计时器
/// </summary>
public class CDTimer : Singleton<CDTimer>
{
    /// <summary>
    /// CD对应列表
    /// </summary>
    private Dictionary<long, float> cdDic = new Dictionary<long, float>(); 

    /// <summary>
    /// 判断该单位的ID是否
    /// </summary>
    /// <param name="objId">单位ID</param>
    /// <param name="skillId">该单位的技能ID</param>
    /// <returns></returns>
    public bool IsInCD(int objId, int skillId)
    {
        var key = ((long)objId << 32) + skillId;
        var result = cdDic.ContainsKey(key);

        return result;
    }

    /// <summary>
    /// 设置对象ID/技能ID进CD状态
    /// </summary>
    /// <param name="objId">对象ID</param>
    /// <param name="skillId">技能ID</param>
    /// <param name="cdTime">cd时间</param>
    /// <param name="callback">CD到时回调</param>
    /// <returns></returns>
    public void SetInCD(int objId, int skillId, float cdTime, Action callback = null)
    {
        var key = ((long) objId << 32) + skillId;
        cdDic.Add(key, Time.realtimeSinceStartup);
        Timer timer = new Timer(cdTime);
        // 时间到消除CD
        timer.OnCompleteCallback(() =>
        {
            cdDic.Remove(key);
            if (callback != null)
            {
                callback();
            }
        }).Start();
    }
}