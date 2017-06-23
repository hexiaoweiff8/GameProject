using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 技能基类
/// </summary>
public class SkillBase
{

    /// <summary>
    /// ID
    /// </summary>
    public int Num { get; protected set; }
     
    /// <summary>
    /// 唯一自增ID
    /// </summary>
    public long AddtionId { get; private set; }

    /// <summary>
    /// 保存技能等级数据列表
    /// </summary>
    public List<List<string>> DataList = new List<List<string>>();

    /// <summary>
    /// 触发条件Level1
    /// </summary>
    public TriggerLevel1 TriggerLevel1 { get; set; }

    /// <summary>
    /// 触发条件Level2
    /// </summary>
    public TriggerLevel2 TriggerLevel2 { get; set; }

    /// <summary>
    /// 技能的持有者
    /// </summary>
    public DisplayOwner ReleaseMember { get; set; }


    /// <summary>
    /// buff触发行为
    /// </summary>
    protected IFormulaItem actionFormulaItem = null;

    /// <summary>
    /// buff 创建行为
    /// </summary>
    protected IFormulaItem attachFormulaItem = null;

    /// <summary>
    /// buff 结束行为
    /// </summary>
    protected IFormulaItem detachFormulaItem = null;

    /// <summary>
    /// 技能唯一自增ID
    /// </summary>
    protected static long addtionId = 1024;


    public SkillBase()
    {
        AddtionId = addtionId++;
    }
}
