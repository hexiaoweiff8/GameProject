using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;



/// <summary>
/// 技能信息
/// </summary>
public class SkillInfo : SkillBase
{
    /// <summary>
    /// 是否主动技能
    /// </summary>
    public bool IsActive { get; set; }

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
    /// 卡牌Icon地址
    /// </summary>
    public string Icon { get; set; }

    /// <summary>
    /// 技能附加行为
    /// </summary>
    private List<IFormulaItem> subFormulaItems = new List<IFormulaItem>(); 

    /// <summary>
    /// 构造技能信息
    /// </summary>
    /// <param name="skillNum">技能ID</param>
    public SkillInfo(int skillNum)
        : base()
    {
        Num = skillNum;
    }

    /// <summary>
    /// 添加子集行为链
    /// </summary>
    /// <param name="formulaItem">被添加行为链</param>
    public void AddSubFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        else
        {
            subFormulaItems.Add(formulaItem);
        }
    }

    /// <summary>
    /// 获取附加行为
    /// </summary>
    /// <param name="paramsPacker">参数封装</param>
    /// <returns>附加行为链列表</returns>
    public List<IFormula> GetSubFormulaList(FormulaParamsPacker paramsPacker)
    {
        if (subFormulaItems == null || subFormulaItems.Count == 0)
        {
            return null;
        }
        if (paramsPacker == null)
        {
            throw new Exception("参数封装为空.");
        }

        return subFormulaItems.Select(item => GetIFormula(paramsPacker, item)).ToList();
    }
}
