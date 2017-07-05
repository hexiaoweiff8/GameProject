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
    /// 公共cd时间
    /// </summary>
    public float PublicCDTime = 1;


    /// <summary>
    /// CD对应列表
    /// </summary>
    private Dictionary<long, float> cdDic = new Dictionary<long, float>(); 

    /// <summary>
    /// cd组列表
    /// </summary>
    private Dictionary<long, float> cdGroupDic = new Dictionary<long, float>(); 

    ///// <summary>
    ///// 判断该单位的ID是否
    ///// </summary>
    ///// <param name="objId">单位ID</param>
    ///// <param name="skillId">该单位的技能ID</param>
    ///// <returns></returns>
    //public bool IsInCD(int objId, int skillId)
    //{
    //    var key = ((long)objId << 32) + skillId;
    //    var result = cdDic.ContainsKey(key);

    //    return result;
    //}

    /// <summary>
    /// 技能是否CD
    /// </summary>
    /// <param name="skillId">技能Num</param>
    /// <param name="objId">单位唯一ID</param>
    /// <param name="cdGroup">cd组</param>
    /// <returns></returns>
    public bool IsInCD(int skillId, int objId, int cdGroup)
    {
        var keyForCD = Utils.GetKey(objId, skillId);
        if (cdGroup < 0)
        {
            return cdDic.ContainsKey(keyForCD);
        }
        else
        {
            var key = Utils.GetKey(objId, cdGroup);
            return cdDic.ContainsKey(keyForCD) || cdGroupDic.ContainsKey(key);
        }
    }

    ///// <summary>
    ///// 设置对象ID/技能ID进CD状态
    ///// </summary>
    ///// <param name="objId">对象ID</param>
    ///// <param name="skillId">技能ID</param>
    ///// <param name="cdTime">cd时间</param>
    ///// <param name="callback">CD到时回调</param>
    ///// <returns></returns>
    //public void SetInCD(int objId, int skillId, float cdTime, Action callback = null)
    //{
    //    var key = ((long) objId << 32) + skillId;
    //    cdDic.Add(key, Time.realtimeSinceStartup);
    //    Timer timer = new Timer(cdTime);
    //    // 时间到消除CD
    //    timer.OnCompleteCallback(() =>
    //    {
    //        cdDic.Remove(key);
    //        if (callback != null)
    //        {
    //            callback();
    //        }
    //    }).Start();
    //}

    /// <summary>
    /// 设置技能进cd状态
    /// </summary>
    /// <param name="skillId">技能唯一ID</param>
    /// <param name="objId">单位唯一ID</param>
    /// <param name="cdTime">cd时间</param>
    /// <param name="cdGroup">cd分组</param>
    /// <param name="callback">cd结束回调</param>
    public void SetInCD(int skillId, float cdTime, int objId = -1, int cdGroup = -1, Action callback = null)
    {
        var keyForCD = Utils.GetKey(objId, skillId);
        // 设置cd
        if (!cdDic.ContainsKey(keyForCD))
        {
            cdDic.Add(keyForCD, Time.realtimeSinceStartup);
        }
        else
        {
            cdDic[keyForCD] = Time.realtimeSinceStartup;
        }

        var timer = new Timer(cdTime);
        // 时间到消除CD
        timer.OnCompleteCallback(() =>
        {
            cdDic.Remove(keyForCD);
            if (callback != null)
            {
                callback();
            }
        }).Start();


        if (cdGroup < 0 || objId < 0)
        {
            return;
        }
        var key = Utils.GetKey(objId, cdGroup);
        // 设置该组公共cd
        if (!cdGroupDic.ContainsKey(key))
        {
            cdGroupDic.Add(key, Time.realtimeSinceStartup);
        }
        else
        {
            cdGroupDic[key] = Time.realtimeSinceStartup;
        }
        timer = new Timer(PublicCDTime);
        timer.OnCompleteCallback(() =>
        {
            // 时间到消除CD
            cdGroupDic.Remove(key);
        }).Start();
    }
}