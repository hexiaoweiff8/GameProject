using UnityEngine;
using System.Collections;

public class TestFormulaConstruct : MonoBehaviour
{
    public GameObject Parent;


    private string formulaStr = @"SkillNum(1000)
{
        PointToPoint(1,test/TrailPrj,1,0,10,1),
        Point(1,test/ExplordScope,0,0,3),
        PointToPoint(1,test/TrailPrj,0,1,10,1),
        Point(1,test/ExplordScope,1,0,3),
}";
    // CollisionDetection 碰撞检测    参数 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方),检测范围形状(0圆, 1方), 
    // 目标阵营(-1:都触发, 0: 己方, 1: 非己方),碰撞单位被释放技能ID , 
    // 范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
    private string formulaStr2 = @"SkillNum(1001)
{
        PointToPoint(1,test/TrailPrj,1,0,10,1),
        Point(1,test/ExplordScope,0,0,3),
        CollisionDetection(0, 10, 1, 0, -1, 1002, 10)
}";
    private string formulaStr3 = @"SkillNum(1002)
{
        PointToPoint(1,test/TrailPrj,1,0,10,1),
        Point(1,test/ExplordScope,0,0,3),
        PointToPoint(1,test/TrailPrj,0,1,10,1),
        Point(1,test/ExplordScope,1,0,3),
}";



    private SkillInfo skillInfo = null;

    private SkillInfo skillInfo2 = null;

    private SkillInfo skillInfo3 = null;

	void Start () {

        // 加载技能内容
        skillInfo = FormulaConstructor.SkillConstructor(formulaStr);
        skillInfo2 = FormulaConstructor.SkillConstructor(formulaStr2);
        skillInfo3 = FormulaConstructor.SkillConstructor(formulaStr3);

    }
	

	void Update () {
	    if (Input.GetMouseButtonUp(0))
	    {
            // 创建技能
	        var formula = skillInfo2.GetFormula(new FormulaParamsPacker()
	        {
	            StartPos = new Vector3(10, 0, 10),
                TargetPos = new Vector3(100, 0, 0),
                //GType = GraphicType.Circle
            });

            // TODO 如何封装数据?
            SkillManager.Single.DoFormula(formula.GetFirst());
	    }
	}
}