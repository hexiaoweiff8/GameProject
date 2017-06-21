using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;



/// <summary>
/// 技能信息
/// </summary>
public class SkillInfo
{
    /// <summary>
    /// 技能ID
    /// </summary>
    public int SkillNum { get; private set; }

    /// <summary>
    /// 保存技能等级数据列表
    /// </summary>
    public List<List<string>> DataList = new List<List<string>>();

    /// <summary>
    /// 触发条件Level2
    /// </summary>
    public SkillTriggerLevel1 TriggerLevel1 { get; set; }

    /// <summary>
    /// 触发条件Level1
    /// </summary>
    public SkillTriggerLevel2 TriggerLevel2 { get; set; }

    /// <summary>
    /// 技能CD时间
    /// </summary>
    public float CDTime { get; set; }

    /// <summary>
    /// 技能CD组ID(不同组ID不会公用一个公共CD)
    /// </summary>
    public int CDGroup { get; set; }

    /// <summary>
    /// 技能可释放次数
    /// </summary>
    public int ReleaseTime { get; set; }

    /// <summary>
    /// 描述
    /// </summary>
    public string Description { get; set; }

    /// <summary>
    /// 卡牌Icon地址
    /// </summary>
    public string Icon { get; set; }

    /// <summary>
    /// 技能行为单元
    /// </summary>
    private IFormulaItem formulaItem = null;

    /// <summary>
    /// 构造技能信息
    /// </summary>
    /// <param name="skillNum">技能ID</param>
    public SkillInfo(int skillNum)
    {
        SkillNum = skillNum;
    }

    /// <summary>
    /// 添加行为生成器
    /// </summary>
    /// <param name="formulaItem">行为单元生成器</param>
    public void AddFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        if (this.formulaItem == null)
        {
            this.formulaItem = formulaItem;
        }
        else
        {
            formulaItem.After(formulaItem);
        }
    }

    /// <summary>
    /// 获取行为链
    /// </summary>
    /// <param name="paramsPacker">参数封装</param>
    /// <returns>行为链</returns>
    public IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            throw new Exception("参数封装为空.");
        }
        IFormula result = null;

        if (formulaItem == null)
        {
            return null;
        }
        // 循环构建行为链构造器
        var tmpItem = formulaItem;
        // 数据列表放入packer中
        paramsPacker.DataList = DataList;
        // 技能ID放入packer中
        paramsPacker.SkillNum = SkillNum;
        while (tmpItem != null)
        {
            if (result != null)
            {
                result = result.After(tmpItem.GetFormula(paramsPacker));
            }
            else
            {
                result = tmpItem.GetFormula(paramsPacker);
            }
            tmpItem = tmpItem.NextFormulaItem;
        }

        // 构造器不为空
        if (result != null)
        {
            // 获取构造器链head
            result = result.GetFirst();
        }
        return result;
    }

    /// <summary>
    /// 获取替换数据后的技能说明
    /// </summary>
    /// <returns>技能说明(用数据替换掉替换符的说明)</returns>
    public string GetReplacedDescription(int level)
    {
        if (level <= 0)
        {
            return null;
        }
        if (DataList == null || DataList.Count == 0)
        {
            throw new Exception("没有数据,DataList为空");
        }
        if (level > DataList.Count)
        {
            throw new Exception("输入等级:"+ level + "大于最高等级" + DataList.Count);
        }

        // 复制说明, 防止修改原有数据
        var result = string.Copy(Description);

        var dataLine = DataList[level - 1];
        for (var i = 0; i < dataLine.Count; i++)
        {
            result = result.Replace("{%" + i + "}", dataLine[i]);
        }

        return result;
    }
}
