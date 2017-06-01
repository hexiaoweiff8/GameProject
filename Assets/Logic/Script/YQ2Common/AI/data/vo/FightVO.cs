using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 通用可参与战斗的对象数据类
/// </summary>
public class FightVO : VOBase
{
    // TODO 技能对象

    /// <summary>
    /// 技能1
    /// </summary>
    public IList<SkillInfo> SkillInfoList { get; set; }

}