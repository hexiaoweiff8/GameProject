using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 持续技能
/// </summary>
public class RemainInfo : AbilityBase
{


    /// <summary>
    /// 作用范围
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



    public RemainInfo(int num) : base()
    {
        Num = num;
    }



}