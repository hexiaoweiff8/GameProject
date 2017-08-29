using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEngine;


/// <summary>
/// 行为链构造器
/// </summary>
public static class FormulaConstructor
{

    /// <summary>
    /// 已注册行为链生成器的字典
    /// 新增构造器请在此处添加
    /// </summary>
    private static Dictionary<string, Type> registerFormulaItem = new Dictionary<string, Type>()
    {
        {"PointToPoint", typeof(PointToPointFormulaItem)},
        {"PointToObj", typeof(PointToObjFormulaItem)},
        {"Point", typeof(PointFormulaItem)},
        {"CollisionDetection", typeof(CollisionDetectionFormulaItem)},
        {"SlideCollisionDetection", typeof(SlideCollisionDetectionFormulaItem)},
        {"Skill", typeof(SkillFormulaItem)},
        {"Pause", typeof(PauseFormulaItem)},
        {"Move", typeof(MoveFormulaItem)},
        {"If", typeof(IfFormulaItem)},
        {"Buff", typeof(BuffFormulaItem)},
        {"HealthChange", typeof(HealthChangeFormulaItem)},
        {"ResistDemage", typeof(ResistDemageFormulaItem)},
        {"Remain", typeof(RemainFormulaItem)},
        {"TargetPointSelector", typeof(TargetPointSelectorFormulaItem)},
        {"Death", typeof(DeathFormulaItem)},
        {"SummonedUnit", typeof(SummonedFormulaItem)},
        {"LifeDrain", typeof(LifeDrainFormulaItem)},
        { "CleanBuff",typeof(CleanBuffFormulaItem)},
        { "CleanTarget",typeof(CleanTargetFormulaItem)},
        { "UpperLimit",typeof(UpperLimitFormulaItem)},
        { "ImmuneToDeath",typeof(ImmuneToDeathFormulaItem)},
        { "ShareDamage",typeof(ShareDamageFormulaItem)},
        { "ImmuneDemage",typeof(ImmuneDemageFormulaItem)},
        { "Liner",typeof(LinerFormulaItem)},
        { "For",typeof(ForFormulaItem)},
        { "SubCD",typeof(SubCDFormulaItem)},
        { "DelBuff",typeof(DelBuffFormulaItem)},
        
        
    };


    /// <summary>
    /// 解析技能
    /// </summary>
    /// <param name="info">字符串数据源</param>
    /// <returns>技能类</returns>
    public static SkillInfo SkillConstructor(string info)
    {
        // 技能信息
        SkillInfo skillInfo = null;

        if (info != null)
        {
            // 技能ID
            var skillId = 0;
            // 数据括号
            var dataBraket = false;
            // 当前行为栈层级
            var stackLevel = 0;
            // 创建临时堆栈, 存储不同层级的行为链
            var stack = new Stack<IFormulaItem>();
            // buff触发时行为
            IFormulaItem actionFormulaItem = new PauseFormulaItem();
            // buff创建行为
            IFormulaItem attachFormulaItem = new PauseFormulaItem();
            // buff销毁行为
            IFormulaItem detachFormulaItem = new PauseFormulaItem();
            IFormulaItem tmpItem = null;

            var isAction = true;
            var isAttach = false;
            var isDetach = false;

            // 解析字符串
            // 根据对应行为列表创建Formula
            var infoLines = info.Split('\n');
            for (var i = 0; i < infoLines.Length; i++)
            {
                var line = infoLines[i];
                // 消除空格
                line = line.Trim();
                // 跳过空行
                if (string.IsNullOrEmpty(line))
                {
                    continue;
                }
                // 跳过注释行
                if (line.StartsWith("//"))
                {
                    continue;
                }

                // 如果是技能描述开始
                if (line.StartsWith("SkillNum"))
                {
                    // 读取技能号
                    var pos = GetSmallBraketPos(line);
                    var start = pos[0];
                    var end = pos[1];

                    // 读取技能ID
                    var strSkillId = line.Substring(start + 1, end - start - 1);
                    skillId = Convert.ToInt32(strSkillId);
                    // 创建新技能
                    skillInfo = new SkillInfo(skillId);
                }

                else if (line.Equals("Action"))
                {
                    // buff触发时行为
                    //tmpItem = actionFormulaItem;
                    isAction = true;
                    isAttach = false;
                    isDetach = false;
                }
                else if (line.Equals("Attach"))
                {
                    // buff 创建时行为
                    //tmpItem = attachFormulaItem;

                    isAction = false;
                    isAttach = true;
                    isDetach = false;
                }
                else if (line.Equals("Detach"))
                {
                    // buff 销毁时行为
                    //tmpItem = detachFormulaItem;

                    isAction = false;
                    isAttach = false;
                    isDetach = true;
                }
                else if (line.StartsWith("{"))
                {
                    // 开始括号内容
                    stackLevel++;

                    // 将上级FormulaItem push进堆栈
                    stack.Push(tmpItem);
                    // 如果是第一级的则根据不同行为分派不同formulaItem
                    if (stackLevel == 1)
                    {
                        if (isAttach)
                        {
                            tmpItem = attachFormulaItem;
                        }
                        else if (isAction)
                        {
                            tmpItem = actionFormulaItem;
                        }
                        else if (isDetach)
                        {
                            tmpItem = detachFormulaItem;
                        }
                    }
                    else
                    {
                        tmpItem = null;
                    }
                }
                else if (line.StartsWith("}"))
                {
                    // 关闭括号内容
                    stackLevel--;
                    // 将上级FormulaItem pop出来
                    var prvLevelItem = stack.Pop();
                    if (prvLevelItem != null && tmpItem != null)
                    {
                        prvLevelItem.AddSubFormulaItem(tmpItem.GetFirst());
                        tmpItem = prvLevelItem;
                    }
                    else
                    {
                        tmpItem = null;
                    }
                }
                else if (line.StartsWith("["))
                {
                    // 数据开始
                    dataBraket = true;
                }
                else if (line.StartsWith("]"))
                {
                    // 数据结束
                    dataBraket = true;
                }
                else if (stackLevel > 0)
                {
                    // 解析行为脚本
                    tmpItem = TransBehavior(line, tmpItem);
                }
                else if (dataBraket)
                {
                    // 解析数据脚本
                    TransData(skillInfo, line);
                }
            }

            if (skillInfo == null)
            {
                throw new Exception("技能没有编号!");
            }
            // buff触发行为
            actionFormulaItem = actionFormulaItem.GetFirst();
            skillInfo.AddActionFormulaItem(actionFormulaItem);
            // buff创建行为
            attachFormulaItem = attachFormulaItem.GetFirst();
            skillInfo.AddAttachFormulaItem(attachFormulaItem);
            // buff销毁行为
            detachFormulaItem = detachFormulaItem.GetFirst();
            skillInfo.AddDetachFormulaItem(detachFormulaItem);

        }

        return skillInfo;
    }

    /*
     技能结构例子
     SkillNum(10000)
     {
        PointToPoint(1,key,0,1,10,1,1),    // 需要等待其结束, 特效key(对应key,或特效path), 释放位置, 命中位置, 速度10, 飞行轨迹类型
        Point(0,key,1,0,3),                // 不需要等待其结束, 特效key(对应key,或特效path), 释放位置, 播放速度, 持续3秒
        CollisionDetection(1, 1, 10, 0, 10001)
        {
            Calculate(1,0,%0)
        }
     }
     [
         // 触发事件Level1
         TriggerLevel1(1)
         // 触发事件Level2
         TriggerLevel2(1)
         // cd时间
         CDTime(10)
         // cd组ID(不一样的组ID不会共享同一个公共CD
         CDGroup(1)
         // 可释放次数
         ReleaseTime(10)
         Description(交换空间撒很快就阿萨德阖家安康收到货%0, %1)
         // 数据
         1, 100,,,,,
         2, 200
      
     ]
     -----------------特效-------------------- 
     PointToPoint 点对点特效        参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),命中位置(0放技能方, 1目标方),速度,飞行轨迹,缩放(三位)
     PointToObj 点对对象特效        参数 是否等待完成,特效Key,速度,飞行轨迹,缩放(三位)
     Point 点特效                   参数 是否等待完成,特效Key,检测位置(0放技能方, 1目标方),持续时间,缩放(三位)
     --Scope 范围特效                 参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),持续时间,范围半径

     --------------目标选择方式---------------
     CollisionDetection 碰撞检测    参数 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方), 检测范围形状(0圆, 1方), 
     目标阵营(-1:都触发, 0: 己方, 1: 非己方),范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
    {
      功能
    }
     SlideCollisionDetection 滑动碰撞检测   参数 是否等待完成, 滑动速度, 检测宽度, 检测总长度, 目标阵营(-1:都触发, 0: 己方, 1: 非己方)
    {
      功能
    }
     -----------------音效--------------------
     Audio 音效                       参数 是否等待完成,点音,持续音,持续时间

     -----------------buff--------------------
     Buff buff                        参数 是否等待完成,buffID

     -----------------结算--------------------
     --Calculate 结算                   参数 是否等待完成,伤害或治疗(0,1),伤害/治疗值
     HealthChange 生命值变动          参数 是否等待完成,生命值变动类型(0固定值,1百分比), 伤害/治疗(0伤害, 1治疗), 目标(0 释放者自己,1 选定的目标单位), 伤害/治疗值(如果是百分比的话这里填1为秒杀100%, 填0.01位1%)
     ResistDemage 伤害吸收            参数 是否等待完成,吸收量,吸收百分比(0-1),是否吸收过量伤害

     -----------------技能--------------------
     Skill 释放技能                   参数 是否等待完成,被释放技能,技能接收方(0释放者,1被释放者)

     -----------------位置--------------------
     Move 位置移动                    参数 是否等待完成,释放位置(0放技能方, 1目标方, 2目标点选择器选的的位置),移动速度,是否瞬移(0: 否, 1: 是(如果是瞬移则速度无效))

     -----------------条件选择----------------
     If 条件选择                      参数 是否等待完成,是否中断后续行为,条件, 条件内容
     --HealthScope 血量范围选择       参数 是否等待完成,血量下限(最小0), 血量上限(最大100)
    
     -----------------操作属性----------------
     ChangeData 动态变更属性          参数(属性名称(对应类里的属性名),变更值, 数据变更类型(0:绝对值(加), 1: 百分比(乘)))
     
     

     -----------------数据--------------------
     TriggerLevel1 事件触发level1             参数 0-6 参照TriggerLevel1枚举
     TriggerLevel2 事件触发level2             参数 0-20 参照TriggerLevel2枚举
     CDTime        cd时间                     参数 时间(正值)
     CDGroup       cd组(不同组的cd不同公共cd)  参数 0-无穷(整数)
     ReleaseTime   可释放次数                 参数 1-无穷(整数)
     Description   描述(中间替换符可被替换)    参数 描述描述中可填写占位符%0123...同样适用数据替换与技能值相同
     Icon          icon地址                   参数 地址(或key)
    
     */


    /// <summary>
    /// 解析buff
    /// </summary>
    /// <param name="info">字符串数据源</param>
    /// <returns>buff类</returns>
    public static BuffInfo BuffConstructor(string info)
    {
        BuffInfo result = null;

        if (info != null)
        {
            // 技能ID
            var buffId = 0;
            // 数据括号
            var dataBraket = false;
            // 当前行为栈层级
            var stackLevel = 0;
            // 创建临时堆栈, 存储不同层级的行为链
            var stack = new Stack<IFormulaItem>();
            // buff触发时行为
            IFormulaItem actionFormulaItem = new PauseFormulaItem();
            // buff创建行为
            IFormulaItem attachFormulaItem = new PauseFormulaItem();
            // buff销毁行为
            IFormulaItem detachFormulaItem = new PauseFormulaItem();
            IFormulaItem tmpItem = null;

            var isAction = false;
            var isAttach = false;
            var isDetach = false;

            // 解析字符串
            // 根据对应行为列表创建Formula
            var infoLines = info.Split('\n');
            for (var i = 0; i < infoLines.Length; i++)
            {
                var line = infoLines[i];
                // 消除空格
                line = line.Trim();
                // 跳过空行
                if (string.IsNullOrEmpty(line))
                {
                    continue;
                }
                // 跳过注释行
                if (line.StartsWith("//"))
                {
                    continue;
                }

                // 如果是技能描述开始
                if (line.StartsWith("BuffNum"))
                {
                    // 读取技能号
                    var pos = GetSmallBraketPos(line);
                    var start = pos[0];
                    var end = pos[1];

                    // 读取技能ID
                    var strSkillId = line.Substring(start + 1, end - start - 1);
                    buffId = Convert.ToInt32(strSkillId);
                    // 创建新技能
                    result = new BuffInfo(buffId);
                }
                else if (line.Equals("Action"))
                {
                    // buff触发时行为
                    //tmpItem = actionFormulaItem;
                    isAction = true;
                    isAttach = false;
                    isDetach = false;
                }
                else if (line.Equals("Attach"))
                {
                    // buff 创建时行为
                    //tmpItem = attachFormulaItem;

                    isAction = false;
                    isAttach = true;
                    isDetach = false;
                }
                else if (line.Equals("Detach"))
                {
                    // buff 销毁时行为
                    //tmpItem = detachFormulaItem;

                    isAction = false;
                    isAttach = false;
                    isDetach = true;
                }
                else if (line.StartsWith("{"))
                {
                    // 开始括号内容
                    stackLevel++;

                    // 将上级FormulaItem push进堆栈
                    stack.Push(tmpItem);
                    // 如果是第一级的则根据不同行为分派不同formulaItem
                    if (stackLevel == 1)
                    {
                        if (isAttach)
                        {
                            tmpItem = attachFormulaItem;
                        }
                        else if (isAction)
                        {
                            tmpItem = actionFormulaItem;
                        }
                        else if (isDetach)
                        {
                            tmpItem = detachFormulaItem;
                        }
                    }
                    else
                    {
                        tmpItem = null;
                    }
                }
                else if (line.StartsWith("}"))
                {
                    // 关闭括号内容
                    stackLevel--;
                    // 将上级FormulaItem pop出来
                    var prvLevelItem = stack.Pop();
                    if (prvLevelItem != null && tmpItem != null)
                    {
                        prvLevelItem.AddSubFormulaItem(tmpItem.GetFirst());
                        tmpItem = prvLevelItem;
                    }
                    else
                    {
                        tmpItem = null;
                    }
                }
                else if (line.StartsWith("["))
                {
                    // 数据开始
                    dataBraket = true;
                }
                else if (line.StartsWith("]"))
                {
                    // 数据结束
                    dataBraket = true;
                }
                else if (stackLevel > 0)
                {
                    // 解析行为脚本
                    tmpItem = TransBehavior(line, tmpItem);
                }
                else if (dataBraket)
                {
                    // 解析数据脚本
                    TransData(result, line);
                }
            }

            if (result == null)
            {
                throw new Exception("技能没有编号!");
            }
            // buff触发行为
            actionFormulaItem = actionFormulaItem.GetFirst();
            result.AddActionFormulaItem(actionFormulaItem);
            // buff创建行为
            attachFormulaItem = attachFormulaItem.GetFirst();
            result.AddAttachFormulaItem(attachFormulaItem);
            // buff销毁行为
            detachFormulaItem = detachFormulaItem.GetFirst();
            result.AddDetachFormulaItem(detachFormulaItem);
        }

        return result;
    }



    // buff结构例子
    /*
    BuffNum(10000)
    // buff被触发时行为
    Action
    {
       PointToPoint(1,key,0,1,10,1,1),     // 需要等待其结束, 特效key(对应key,或特效path), 释放位置, 命中位置, 速度10, 飞行轨迹类型
       Point(0,key,1,0,3),                // 不需要等待其结束, 特效key(对应key,或特效path), 释放位置, 播放速度, 持续3秒
       CollisionDetection(1, 1, 10, 0, 10001)
       {
           Calculate(1,0,%0)
       }
    }
    // buff 创建时行为
    Attach
    {
        XXXXXXXXXXXXXXXX
    }
    // buff消失时行为
    Detach 
    {
        XXXXXXXXXXXXXXXXXXX
    }
    [
        // 触发事件Level1
        TriggerLevel1(1)
        // 触发事件Level2
        TriggerLevel2(1)
        
        // buff结束事件Level1
        DetachTriggerLevel1(1)
        // buff结束事件Level2
        DetachTriggerLevel2(1)
        
        // buff存在时间
        BuffTime(10)
        // buff检测时间
        TickTime(1)
        // buff类型
        BuffType(1)
        // buffLevel, 如果buff互斥则level高的会替换掉level低的, 反之不会
        BuffLevel(10)
        BuffGroup(1)
        // 是否为增益buff
        IsBeneficial(true)
        // 调整值
        ChangeData(属性名称(对应类里的属性名),变更值, 数据变更类型(0:绝对值(加), 1: 百分比(乘)))
        // 数值变更类型 0: 绝对值(加), 1: 百分比(乘)
        // ChangeDataType(0)
        // 是否死亡消失
        IsDeadDisappear(true)
        // 是否不致死 默认致死
        IsNotLethal(true)
        // detach条件 key为每个节点存储在技能中的数据, 操作符判断相等与大小, 值
        DetachQualified(key,<,10)
     
        Description(交换空间撒很快就阿萨德阖家安康收到货%0, %1)
        // 数据
        1, 100,,,,,
        2, 200
      
    ]
    */


    /// <summary>
    /// 解析Remain
    /// </summary>
    /// <param name="info">字符串数据源</param>
    /// <returns>Remain类</returns>
    public static RemainInfo RemainConstructor(string info)
    {
        RemainInfo result = null;

        if (info != null)
        {
            // 技能ID
            var remainId = 0;
            // 数据括号
            var dataBraket = false;
            // 当前行为栈层级
            var stackLevel = 0;
            // 创建临时堆栈, 存储不同层级的行为链
            var stack = new Stack<IFormulaItem>();
            // Remain触发时行为
            IFormulaItem actionFormulaItem = new PauseFormulaItem();
            // Remain创建行为
            IFormulaItem attachFormulaItem = new PauseFormulaItem();
            // Remain销毁行为
            IFormulaItem detachFormulaItem = new PauseFormulaItem();
            IFormulaItem tmpItem = null;

            var isAction = false;
            var isAttach = false;
            var isDetach = false;

            // 解析字符串
            // 根据对应行为列表创建Formula
            var infoLines = info.Split('\n');
            for (var i = 0; i < infoLines.Length; i++)
            {
                var line = infoLines[i];
                // 消除空格
                line = line.Trim();
                // 跳过空行
                if (string.IsNullOrEmpty(line))
                {
                    continue;
                }
                // 跳过注释行
                if (line.StartsWith("//"))
                {
                    continue;
                }

                // 如果是技能描述开始
                if (line.StartsWith("RemainNum"))
                {
                    // 读取技能号
                    var pos = GetSmallBraketPos(line);
                    var start = pos[0];
                    var end = pos[1];

                    // 读取技能ID
                    var strSkillId = line.Substring(start + 1, end - start - 1);
                    remainId = Convert.ToInt32(strSkillId);
                    // 创建新技能
                    result = new RemainInfo(remainId);
                }
                else if (line.Equals("Action"))
                {
                    // Remain触发时行为
                    //tmpItem = actionFormulaItem;
                    isAction = true;
                    isAttach = false;
                    isDetach = false;
                }
                else if (line.Equals("Enter"))
                {
                    // Remain 创建时行为
                    //tmpItem = attachFormulaItem;

                    isAction = false;
                    isAttach = true;
                    isDetach = false;
                }
                else if (line.Equals("Out"))
                {
                    // Remain 销毁时行为
                    //tmpItem = detachFormulaItem;

                    isAction = false;
                    isAttach = false;
                    isDetach = true;
                }
                else if (line.StartsWith("{"))
                {
                    // 开始括号内容
                    stackLevel++;

                    // 将上级FormulaItem push进堆栈
                    stack.Push(tmpItem);
                    // 如果是第一级的则根据不同行为分派不同formulaItem
                    if (stackLevel == 1)
                    {
                        if (isAttach)
                        {
                            tmpItem = attachFormulaItem;
                            result.HasAttachFormula = true;
                        }
                        else if (isAction)
                        {
                            tmpItem = actionFormulaItem;
                            result.HasActionFormula = true;
                        }
                        else if (isDetach)
                        {
                            tmpItem = detachFormulaItem;
                            result.HasDetachFormula = true;
                        }
                    }
                    else
                    {
                        tmpItem = null;
                    }
                }
                else if (line.StartsWith("}"))
                {
                    // 关闭括号内容
                    stackLevel--;
                    // 将上级FormulaItem pop出来
                    var prvLevelItem = stack.Pop();
                    if (prvLevelItem != null && tmpItem != null)
                    {
                        prvLevelItem.AddSubFormulaItem(tmpItem.GetFirst());
                        tmpItem = prvLevelItem;
                    }
                    else
                    {
                        tmpItem = null;
                    }
                }
                else if (line.StartsWith("["))
                {
                    // 数据开始
                    dataBraket = true;
                }
                else if (line.StartsWith("]"))
                {
                    // 数据结束
                    dataBraket = true;
                }
                else if (stackLevel > 0)
                {
                    // 解析行为脚本
                    tmpItem = TransBehavior(line, tmpItem);
                }
                else if (dataBraket)
                {
                    // 解析数据脚本
                    TransData(result, line);
                }
            }

            if (result == null)
            {
                throw new Exception("技能没有编号!");
            }
            // remain触发(时间)行为
            actionFormulaItem = actionFormulaItem.GetFirst();
            result.AddActionFormulaItem(actionFormulaItem);
            // remain进入范围行为
            attachFormulaItem = attachFormulaItem.GetFirst();
            result.AddAttachFormulaItem(attachFormulaItem);
            // remain出范围行为
            detachFormulaItem = detachFormulaItem.GetFirst();
            result.AddDetachFormulaItem(detachFormulaItem);
        }

        return result;
    }
    // remain结构例子
    /*
    RemainNum(10000)
    // remain时间行为
    Action
    {
       PointToPoint(1,key,0,1,10,1,1),     // 需要等待其结束, 特效key(对应key,或特效path), 释放位置, 命中位置, 速度10, 飞行轨迹类型
       Point(0,key,1,0,3),                // 不需要等待其结束, 特效key(对应key,或特效path), 释放位置, 播放速度, 持续3秒
       CollisionDetection(1, 1, 10, 0, 10001)
       {
           Calculate(1,0,%0)
       }
    }
    // 进入remain时行为
    Enter
    {
        XXXXXXXXXXXXXXXX
    }
    // 出remain时行为
    Out 
    {
        XXXXXXXXXXXXXXXXXXX
    }
    [
        Range       // 作用范围
        DuringTime  // 作用总时间
        ActionTime  // Action时间间隔
        IsFollow    // 是否跟随释放者
        ActionCamp  // 作用阵营
        CouldActionOnAir        // 是否可以作用到空中单位
        CouldActionOnSurface    // 是否可以作用到地面单位
        CouldActionOnBuilding   // 是否可以作用到建筑单位
        // 数据
        1, 100,,,,,
        2, 200
      
    ]
    */


    /// <summary>
    /// 获取行为链
    /// </summary>
    /// <param name="type">行为类型名称</param>
    /// <param name="args">行为</param>
    /// TODO 封装施法者与目标对象
    /// <returns></returns>
    private static IFormulaItem GetFormula(string type, string args)
    {

        IFormulaItem result = null;
        // 错误消息
        string errorMsg = null;
        if (string.IsNullOrEmpty(type))
        {
            errorMsg = "函数类型为空";
        }
        if (string.IsNullOrEmpty(errorMsg))
        {
            // 分割数据
            var argsArray = args.Split(',');
            // 注册列表中是否包含该类型
            if (registerFormulaItem.ContainsKey(type))
            {
                // 获取该行为的Type
                var formulaItemType = registerFormulaItem[type];
                // 反射方式实例化行为链构造器(因为实例化的是构造器, 所以不用担心效率问题, 实际技能是使用构造器生产产生)
                result = (IFormulaItem)formulaItemType.InvokeMember("", BindingFlags.Public | BindingFlags.CreateInstance,
                    null, null, new object[] { argsArray });
            }
            else
            {
                throw new Exception("未知行为类型: " + type);
            }
        }
        // 如果错误信息不为空则抛出错误
        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }
        return result;
    }

    /// <summary>
    /// 解析行为
    /// </summary>
    /// <param name="line">脚本行</param>
    /// <param name="tmpItem">行为生成类</param>
    /// <returns></returns>
    private static IFormulaItem TransBehavior(string line, IFormulaItem tmpItem)
    {

        // 解析内容
        // TODO 判断Formula的stack等级是否与当前stack等级一直? 不一致则新建将其加入上一级formula的子集
        // 参数列表内容
        var pos = GetSmallBraketPos(line);
        var start = pos[0];
        var end = pos[1];

        // 行为类型
        var type = line.Substring(0, start);
        // 行为参数
        var args = line.Substring(start + 1, end - start - 1);
        // 消除参数空格
        args = args.Replace(" ", "");
        // 使用参数+名称获取IFormula
        var item = GetFormula(type, args);
        // formula加入暂停item
        var pauseItem = GetFormula("Pause", "1");

        tmpItem = tmpItem == null ? pauseItem : tmpItem.After(pauseItem);
        tmpItem = tmpItem.After(item);

        return tmpItem;
    }

    /// <summary>
    /// 解析数据
    /// </summary>
    /// <param name="skillInfo">技能类</param>
    /// <param name="line">数据行</param>
    private static void TransData(SkillInfo skillInfo, string line)
    {

        // 解析数据
        if (skillInfo == null)
        {
            throw new Exception("技能ID未指定.技能类为空");
        }

        var pos = GetSmallBraketPos(line, false);
        var start = pos[0];
        var end = pos[1];
        // 编号长度
        var length = end - start - 1;
        if (end > 0 && start > 0)
        {
            var strVal = line.Substring(start + 1, length).Trim();
            var symbol = line.Substring(0, start).Trim();
            switch (symbol)
            {
                case "CDTime":
                {
                    skillInfo.CDTime = skillInfo.GetDataOrReplace<float>("CDTime", strVal);
                    //skillInfo.CDTime = Convert.ToSingle(line.Substring(start + 1, length).Trim());
                }
                    break;
                case "CDGroup":
                {
                    skillInfo.CDGroup = skillInfo.GetDataOrReplace<int>("CDGroup", strVal);
                }
                    break;
                case "ChangeData":
                {
                    // 使用反射获得数据
                    if (skillInfo.ChangeData == null)
                    {
                        skillInfo.ChangeData = new VOBase();
                    }
                    // 获取值
                    var values = strVal.Split(',');
                    // 属性名称
                    var propertyName = values[0];
                    // 属性值
                    var propertyValue = values[1];
                    // 属性值类型
                    var propertyType = (ChangeDataType) Enum.Parse(typeof (ChangeDataType), values[2]);
                    // 反射获取类中的属性
                    var property = skillInfo.ChangeData.GetType().GetProperty(propertyName);
                    FieldInfo field = null;
                    if (property == null)
                    {
                        field = skillInfo.ChangeData.GetType().GetField(propertyName);
                        if (field == null)
                        {
                            throw new Exception("属性不存在, 请检查是否正确, 区分大小写:" + propertyName);
                        }
                    }
                    // 如果该属性不可以被控制报错
                    if ((property == null || !property.GetCustomAttributes(typeof (SkillAddition), false).Any())
                        && (field == null || !field.GetCustomAttributes(typeof (SkillAddition), true).Any()))
                    {
                        throw new Exception("该属性不可被技能控制:" + propertyName);
                    }
                    // 设置属性值
                    if (property != null)
                    {
                        property.SetValue(skillInfo.ChangeData, Convert.ChangeType(propertyValue, property.PropertyType),
                            null);
                    }
                    if (field != null)
                    {
                        field.SetValue(skillInfo.ChangeData, Convert.ChangeType(propertyValue, field.FieldType));
                    }
                    // 设置该属性的附加类型
                    skillInfo.ChangeDataTypeDic.Add(propertyName, propertyType);
                }
                    break;
                case "DemageChange":
                {
                    // 解析数据
                    var values = strVal.Split(',');
                    //// 类型 (0:伤害增强/1:伤害减免)
                    //var type = Convert.ToInt32(values[0].Trim());
                    //// 伤害增强/减免值(百分比, 1为100%)
                    //var demageVal = Convert.ToSingle(values[1].Trim());
                    //// 产生伤害增强/减免概率(百分比, 1为100%)
                    //var probability = Convert.ToSingle(values[2].Trim());
                    //// 目标/来源类型
                    //var targetType = (DemageAdditionOrReductionTargetType)Enum.Parse(typeof(DemageAdditionOrReductionTargetType), values[3].Trim());

                    skillInfo.DemageChangeType = skillInfo.GetDataOrReplace<int>("DemageChangeType", values[0].Trim());
                    skillInfo.DemageChange = skillInfo.GetDataOrReplace<float>("DemageChange", values[1].Trim());
                    skillInfo.DemageChangeProbability = skillInfo.GetDataOrReplace<float>("DemageChangeProbability",
                        values[2].Trim());
                    skillInfo.DemageChangeTargetType =
                        skillInfo.GetDataOrReplace<DemageAdditionOrReductionTargetType>("DemageChangeTargetType",
                            values[3].Trim());
                    ;
                }
                    break;
                case "IsActive":
                {
                    var values = strVal.Split(',');
                    if (values.Length == 2)
                    {
                        skillInfo.IsActive = skillInfo.GetDataOrReplace<bool>("IsActive", values[0].Trim());
                        skillInfo.WeightData =
                            new SelectWeightData(SData_armyaim_c.Single.GetDataOfID(Convert.ToInt32(values[1].Trim())));
                    }
                    else
                    {
                        skillInfo.IsActive = skillInfo.GetDataOrReplace<bool>("IsActive", values[0].Trim());
                    }
                }
                    break;
                case "IntervalTime":
                {
                    skillInfo.IntervalTime = skillInfo.GetDataOrReplace<float>("IntervalTime", strVal);
                }
                    break;
                case "ReleaseTime":
                {
                    skillInfo.ReleaseTime = skillInfo.GetDataOrReplace<int>("ReleaseTime", strVal);
                }
                    break;
                case "TriggerLevel1":
                {
                    // 技能触发事件level1
                    skillInfo.TriggerLevel1 = skillInfo.GetDataOrReplace<TriggerLevel1>("TriggerLevel1", strVal);
                }
                    break;
                case "TriggerLevel2":
                {
                    // 技能触发事件level2
                    skillInfo.TriggerLevel2 = skillInfo.GetDataOrReplace<TriggerLevel2>("TriggerLevel2", strVal);
                }
                    break;

                case "TriggerProbability":
                {
                    //技能触发概率
                    skillInfo.TriggerProbability = skillInfo.GetDataOrReplace<float>("TriggerProbability", strVal);
                }
                    break;

                case "Description":
                {
                    skillInfo.Description = skillInfo.GetDataOrReplace<string>("Description", strVal);
                }
                    break;
                case "Icon":
                {
                    skillInfo.Icon = skillInfo.GetDataOrReplace<string>("Icon", strVal);
                }
                    break;
                case "SkillName":
                {
                    skillInfo.SkillName = skillInfo.GetDataOrReplace<string>("SkillName", strVal);
                }
                    break;


            }
        }
        else if (start < 0 && end < 0)
        {
            // 解析数据脚本
            var dataArray = line.Split(',');
            var dataList = dataArray.ToList();
            skillInfo.DataList.Add(dataList);
        }
        else
        {
            ValidSmallBraketIndex(start, end, line);
        }
    }


    /// <summary>
    /// 解析buff数据
    /// </summary>
    /// <param name="buffInfo">buff类</param>
    /// <param name="line">数据行</param>
    private static void TransData(BuffInfo buffInfo, string line)
    {

        // 解析数据
        if (buffInfo == null)
        {
            throw new Exception("buffID未指定.buff类为空");
        }

        var pos = GetSmallBraketPos(line, false);
        var start = pos[0];
        var end = pos[1];
        // 编号长度
        var length = end - start - 1;
        if (end > 0 && start > 0)
        {
            var symbol = line.Substring(0, start).Trim();
            var strVal = line.Substring(start + 1, length).Trim();
            switch (symbol)
            {
                case "BuffTime":
                {
                    buffInfo.BuffTime = buffInfo.GetDataOrReplace<float>("BuffTime", strVal);
                }
                    break;
                case "TickTime":
                    {
                        buffInfo.TickTime = buffInfo.GetDataOrReplace<float>("TickTime", strVal);
                    }
                    break;
                case "BuffType":
                    {
                        buffInfo.BuffType = buffInfo.GetDataOrReplace<BuffType>("BuffType", strVal);
                    }
                    break;
                case "TriggerLevel1":
                    {
                        // 技能触发事件level1
                        buffInfo.TriggerLevel1 = buffInfo.GetDataOrReplace<TriggerLevel1>("TriggerLevel1", strVal);
                    }
                    break;
                case "TriggerLevel2":
                    {
                        // 技能触发事件level2
                        buffInfo.TriggerLevel2 = buffInfo.GetDataOrReplace<TriggerLevel2>("TriggerLevel2", strVal);
                    }
                    break;
                case "TriggerProbability":
                    {
                        //BUFF触发概率
                        buffInfo.TriggerProbability = buffInfo.GetDataOrReplace<float>("TriggerProbability", strVal);
                    }
                    break;

                case "DetachTriggerLevel1":
                    {
                        // buff Detach触发条件level1
                        buffInfo.DetachTriggerLevel1 = buffInfo.GetDataOrReplace<TriggerLevel1>("DetachTriggerLevel1", strVal);
                    }
                    break;
                case "DetachTriggerLevel2":
                    {
                        // buff Detach触发条件level2
                        buffInfo.DetachTriggerLevel2 = buffInfo.GetDataOrReplace<TriggerLevel2>("DetachTriggerLevel2", strVal);
                    }
                    break;
                case "BuffLevel":
                    {
                        // buff优先级
                        buffInfo.BuffLevel = buffInfo.GetDataOrReplace<int>("BuffLevel", strVal);
                    }
                    break;
                case "BuffGroup":
                    {
                        // buff组
                        buffInfo.BuffGroup = buffInfo.GetDataOrReplace<int>("BuffGroup", strVal);
                    }
                    break;
                case "IsBeneficial":
                    {
                        buffInfo.IsBeneficial = buffInfo.GetDataOrReplace<bool>("IsBeneficial", strVal);
                    }
                    break;
                case "ChangeData":
                    {
                        // 使用反射获得数据
                        if (buffInfo.ChangeData == null)
                        {
                            buffInfo.ChangeData = new VOBase();
                        }
                        // 获取值
                        var values = line.Substring(start + 1, end - start - 1).Split(',');
                        // 属性名称
                        var propertyName = values[0].Trim();
                        // 属性值
                        var propertyValue = values[1].Trim();
                        // 属性值类型
                        var propertyType = (ChangeDataType)Enum.Parse(typeof(ChangeDataType), values[2].Trim());
                        // 反射获取类中的属性
                        var property = buffInfo.ChangeData.GetType().GetProperty(propertyName); FieldInfo field = null;
                        if (property == null)
                        {
                            field = buffInfo.ChangeData.GetType().GetField(propertyName);
                            if (field == null)
                            {
                                throw new Exception("属性不存在, 请检查是否正确, 区分大小写:" + propertyName);
                            }
                        }
                        // 如果该属性不可以被控制报错
                        if ((property == null || !property.GetCustomAttributes(typeof(SkillAddition), false).Any())
                            && (field == null || !field.GetCustomAttributes(typeof(SkillAddition), true).Any()))
                        {
                            throw new Exception("该属性不可被技能控制:" + propertyName);
                        }
                        // 设置属性值
                        if (property != null)
                        {
                            property.SetValue(buffInfo.ChangeData, Convert.ChangeType(propertyValue, property.PropertyType), null);
                        }
                        if (field != null)
                        {
                            field.SetValue(buffInfo.ChangeData, Convert.ChangeType(propertyValue, field.FieldType));
                        }
                        // 设置该属性的附加类型
                        buffInfo.ChangeDataTypeDic.Add(propertyName, propertyType);
                    }
                    break;
                case "DemageChange":
                    {
                        // 解析数据
                        var values = strVal.Split(',');
                        // 类型 (0:伤害增强/1:伤害减免)
                        //var type = Convert.ToInt32(values[0].Trim());
                        //// 伤害增强/减免值(百分比, 1为100%)
                        //var demageVal = Convert.ToSingle(values[1].Trim());
                        //// 产生伤害增强/减免概率(百分比, 1为100%)
                        //var probability = Convert.ToSingle(values[2].Trim());
                        //// 目标/来源类型
                        //var targetType = (DemageAdditionOrReductionTargetType)Enum.Parse(typeof(DemageAdditionOrReductionTargetType), values[3].Trim());

                        buffInfo.DemageChangeType = buffInfo.GetDataOrReplace<int>("DemageChangeType", values[0].Trim());
                        buffInfo.DemageChange = buffInfo.GetDataOrReplace<float>("DemageChange", values[1].Trim());
                        buffInfo.DemageChangeProbability = buffInfo.GetDataOrReplace<float>("DemageChangeProbability", values[2].Trim());
                        buffInfo.DemageChangeTargetType = buffInfo.GetDataOrReplace<DemageAdditionOrReductionTargetType>("DemageChangeTargetType", values[3].Trim());
                    }
                    break;
                case "DetachQualified":
                    {
                        // buff的Detach条件
                        var param = strVal.Split(',');
                        var key = param[0];
                        var op = param[1];
                        var value = param[2];
                        buffInfo.DetachQualifiedKeyList.Add(key);
                        buffInfo.DetachQualifiedOptionList.Add(op);
                        buffInfo.DetachQualifiedValueList.Add(value);
                    }
                    break;
                case "IsDeadDisappear":
                    {
                        // buff存在状态
                        buffInfo.IsDeadDisappear = buffInfo.GetDataOrReplace<bool>("IsDeadDisappear", strVal);
                    }
                    break;
                case "IsNotLethal":
                    {
                        // buff是否不致死
                        buffInfo.IsNotLethal = buffInfo.GetDataOrReplace<bool>("IsNotLethal", strVal);
                    }
                    break;
                case "IsCouldNotClear":
                    {
                        // buff是否不可清除
                        buffInfo.IsCouldNotClear = buffInfo.GetDataOrReplace<bool>("IsCouldNotClear", strVal);
                    }
                    break;
                case "Description":
                    {
                        // buff说明
                        buffInfo.Description = buffInfo.GetDataOrReplace<string>("Description", strVal);
                    }
                    break;
                case "Icon":
                    {
                        // buff Icon
                        buffInfo.Icon = buffInfo.GetDataOrReplace<string>("Icon", strVal);
                    }
                    break;
                case "HpScopeMax":
                    {
                        // 触发Action生命上限
                        buffInfo.HpScopeMax = buffInfo.GetDataOrReplace<float>("HpScopeMax", strVal);
                    }
                    break;
                case "HpScopeMin":
                    {
                        // 触发Action生命下限
                        buffInfo.HpScopeMin = buffInfo.GetDataOrReplace<float>("HpScopeMin", strVal);
                    }
                    break;
                case "DetachHpScopeMax":
                    {
                        // 触发Detach生命上限
                        buffInfo.DetachHpScopeMax = buffInfo.GetDataOrReplace<float>("DetachHpScopeMax", strVal);
                    }
                    break;
                case "DetachHpScopeMin":
                    {
                        // 触发Detah生命下限
                        buffInfo.DetachHpScopeMin = buffInfo.GetDataOrReplace<float>("DetachHpScopeMin", strVal);
                    }
                    break;

                    
            }
        }
        else if (start < 0 && end < 0)
        {
            // 解析数据脚本
            var dataArray = line.Split(',');
            var dataList = dataArray.ToList();
            buffInfo.DataList.Add(dataList);
        }
        else
        {
            ValidSmallBraketIndex(start, end, line);
        }
    }


    /// <summary>
    /// 解析Remain数据
    /// </summary>
    /// <param name="remainInfo">Remain类</param>
    /// <param name="line">数据行</param>
    private static void TransData(RemainInfo remainInfo, string line)
    {

        // 解析数据
        if (remainInfo == null)
        {
            throw new Exception("remainID未指定.remain类为空");
        }

        var pos = GetSmallBraketPos(line, false);
        var start = pos[0];
        var end = pos[1];
        // 编号长度
        var length = end - start - 1;
        if (end > 0 && start > 0)
        {
            var strVal = line.Substring(start + 1, length).Trim();
            var symbol = line.Substring(0, start).Trim();
            switch (symbol)
            {
                // 总持续时间
                case "DuringTime":
                {

                    remainInfo.DuringTime = remainInfo.GetDataOrReplace<float>("DuringTime", strVal);
                }
                    break;
                // 作用时间间隔
                case "ActionTime":
                {
                    remainInfo.ActionTime = remainInfo.GetDataOrReplace<float>("ActionTime", strVal);
                }
                    break;
                // 作用范围
                case "Range":
                {
                    remainInfo.Range = remainInfo.GetDataOrReplace<float>("Range", strVal);
                }
                    break;
                // 是否跟随
                case "IsFollow":
                {
                    remainInfo.IsFollow = remainInfo.GetDataOrReplace<bool>("IsFollow", strVal);
                }
                    break;
                // 作用阵营
                case "ActionCamp":
                {
                    remainInfo.ActionCamp = remainInfo.GetDataOrReplace<int>("ActionCamp", strVal);
                }
                    break;
                // 是否可以作用到空中单位
                case "CouldActionOnAir":
                {
                    remainInfo.CouldActionOnAir = remainInfo.GetDataOrReplace<bool>("CouldActionOnAir", strVal);
                }
                    break;
                // 是否可以作用到地面单位
                case "CouldActionOnSurface":
                {
                    remainInfo.CouldActionOnSurface = remainInfo.GetDataOrReplace<bool>("CouldActionOnSurface", strVal);
                }
                    break;
                // 是否可以作用到建筑
                case "CouldActionOnBuilding":
                {
                    remainInfo.CouldActionOnBuilding = remainInfo.GetDataOrReplace<bool>("CouldActionOnBuilding", strVal);
                }
                    break;
            }
        }
        else if (start < 0 && end < 0)
        {
            // 解析数据脚本
            var dataArray = line.Split(',');
            var dataList = dataArray.ToList();
            remainInfo.DataList.Add(dataList);
        }
        else
        {
            ValidSmallBraketIndex(start, end, line);
        }
    }

    /// <summary>
    /// 获取一行数据中的小括号位置
    /// </summary>
    /// <param name="line">行</param>
    /// <param name="vel">如果是数据行</param>
    /// <returns></returns>
    private static int[] GetSmallBraketPos(string line, bool vel = true)
    {
        var start = line.IndexOf("(", StringComparison.Ordinal);
        var end = line.IndexOf(")", StringComparison.Ordinal);

        if ((start < 0 || end < 0) && vel)
        {
            throw new Exception("转换行为链失败: ()符号不完整:" + line);
        }
        // 编号长度
        var length = end - start - 1;
        if (length <= 0 && vel)
        {
            throw new Exception("转换行为链失败: ()顺序错误:" + line);
        }

        return new[] {start, end};
    }

    /// <summary>
    /// 验证行是否合法
    /// </summary>
    /// <param name="start">小括号start位置</param>
    /// <param name="end">小括号end位置</param>
    /// <param name="line">该数据行</param>
    private static void ValidSmallBraketIndex(int start, int end, string line)
    {
        if (start < 0 || end < 0)
        {
            throw new Exception("转换行为链失败: ()符号不完整" + line);
        }
    }

}

/// <summary>
/// 技能触发类型第一级
/// </summary>
public enum TriggerLevel1
{
    None = 0,       // 无触发条件
    Scope = 1,      // 范围内触发
    Health = 2,     // 血量触发(血量低于或高于XX触发)
    Fight = 3,      // 战斗行为触发(攻击, 被攻击, 闪避...)
    Time = 4,       // 时间触发(保持某状态一定时间)
    Buff = 5,       // Buff触发(有正面Buff时或负面Buff时, 或指定Buff时触发)
    All = 6         // 范围全地图触发(地方下兵或某数量大于1时触发)

}

/// <summary>
/// 技能触发类型第二级
/// </summary>
public enum TriggerLevel2
{
    None = 0,                   // 无触发条件
    Enemy = 1,                  // 有敌方单位
    Friend = 2,                 // 有友方单位
    NotFullHealthFriend = 3,    // 有不满血友方单位
    FriendDeath = 4,            // 有友方单位死亡
    EnemyDeath = 5,             // 有敌方单位死亡
    EnemyHide = 6,              // 有敌方隐形单位


    HealthChange = 7,           // 血量变动
    Attack = 8,                 // 攻击时
    Hit = 9,                    // 命中时
    BeAttack = 10,              // 被攻击时
    BeCure = 11,                // 被治疗时
    BeHurt = 21,                // 被伤害时
    BeNormalAttackHurt = 22,    // 被伤普通攻击害时
    BeSkillHurt = 23,           // 被伤技能害时
    Absorption = 12,            // 伤害吸收时
    Dodge = 13,                 // 闪避时
    Enter = 14,                 // 入场时
    EnterEnd = 15,              // 入场结束时
    Death = 16,                 // 死亡时
    LethalHit = 17,             // 受到致死攻击时

    TickTime = 18,              // 每XX秒触发一次
    SafeTime = 19,              // 安全XX时长时
    ClearScope = 20,            // 范围内XX时长无敌人时
}