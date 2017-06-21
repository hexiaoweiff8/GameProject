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
    };


    /// <summary>
    /// 构建行为链
    /// </summary>
    /// <param name="info">字符串数据源</param>
    /// <returns>构建完成的行为链</returns>
    public static SkillInfo Constructor(string info)
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
            IFormulaItem tmpItem = null;

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
                else if (line.StartsWith("{"))
                {
                    // 开始括号内容
                    stackLevel++;

                    // 将上级FormulaItem push进堆栈
                    stack.Push(tmpItem);
                    tmpItem = null;
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
            // 技能行为
            if (tmpItem != null)
            {
                // 获得行为链生成器的head
                tmpItem = tmpItem.GetFirst();
                if (skillInfo == null)
                {
                    throw new Exception("技能没有编号!");
                }
                skillInfo.AddFormulaItem(tmpItem);
            }
        }

        return skillInfo;
    }

    /// <summary>
    /// 获取行为链
    /// </summary>
    /// <param name="type">行为类型名称</param>
    /// <param name="args">行为</param>
    /// <param name="startPos">施法者位置</param>
    /// <param name="targetPos">目标位置</param>
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
            var symbol = line.Substring(0, start).Trim();
            switch (symbol)
            {
                case "CDTime":
                {
                    skillInfo.CDTime = Convert.ToSingle(line.Substring(start + 1, length));
                }
                    break;
                case "CDGroup":
                {
                    skillInfo.CDGroup = Convert.ToInt32(line.Substring(start + 1, length));
                }
                    break;
                case "ReleaseTime":
                {
                    skillInfo.ReleaseTime = Convert.ToInt32(line.Substring(start + 1, length));
                }
                    break;
                case "TriggerLevel1":
                {
                    // 技能触发事件level1
                    var triggerType = (SkillTriggerLevel1) Convert.ToInt32(line.Substring(start + 1, end - start - 1));
                    skillInfo.TriggerLevel1 = triggerType;
                }
                    break;
                case "TriggerLevel2":
                {
                    // 技能触发事件level2
                    var triggerType = (SkillTriggerLevel2) Convert.ToInt32(line.Substring(start + 1, end - start - 1));
                    skillInfo.TriggerLevel2 = triggerType;
                }
                    break;
                case "Description":
                {
                    skillInfo.Description = line.Substring(start + 1, end - start - 1);
                }
                    break;
                case "Icon":
                {
                    skillInfo.Icon = line.Substring(start + 1, end - start - 1);
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

    // 结构例子
    /*
     SkillNum(10000)
     {
        PointToPoint(1,key,0,1,10,1,1),     // 需要等待其结束, 特效key(对应key,或特效path), 释放位置, 命中位置, 速度10, 飞行轨迹类型
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
     */
    // -----------------特效-------------------- 
    // PointToPoint 点对点特效        参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),命中位置(0放技能方, 1目标方),速度,飞行轨迹,缩放(三位)
    // PointToObj 点对对象特效        参数 是否等待完成,特效Key,速度,飞行轨迹,缩放(三位)
    // Point 点特效                   参数 是否等待完成,特效Key,检测位置(0放技能方, 1目标方),持续时间,缩放(三位)
    // --Scope 范围特效                 参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),持续时间,范围半径

    // --------------目标选择方式---------------
    // CollisionDetection 碰撞检测    参数 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方), 检测范围形状(0圆, 1方), 
    // 目标阵营(-1:都触发, 0: 己方, 1: 非己方),碰撞单位被释放技能ID范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
    //{
    //  功能
    //}
    // SlideCollisionDetection 滑动碰撞检测   参数 是否等待完成, 滑动速度, 检测宽度, 检测总长度, 目标阵营(-1:都触发, 0: 己方, 1: 非己方)
    //{
    //  功能
    //}
    // Skill 释放技能                   参数 是否等待完成,被释放技能,技能接收方(0释放者,1被释放者)
    // -----------------音效--------------------
    // Audio 音效                       参数 是否等待完成,点音,持续音,持续时间

    // -----------------buff--------------------
    // Buff buff                        参数 是否等待完成,buffID

    // -----------------结算--------------------
    // Calculate 结算                   参数 是否等待完成,伤害或治疗(0,1),伤害/治疗值

    // -----------------技能--------------------
    // Skill 释放技能                   参数 是否等待完成,技能编号

    // -----------------位置--------------------
    // Move 位置移动                    参数 是否等待完成,移动速度,是否瞬移(0: 否, 1: 是(如果是瞬移则速度无效))

    // -----------------条件选择----------------
    // If 条件选择                      参数 是否等待完成,条件
    // --HealthScope 血量范围选择       参数 是否等待完成,血量下限(最小0), 血量上限(最大100)
    // 

    // -----------------数据--------------------
    // TriggerLevel1 事件触发level1             参数 0-6 参照TriggerLevel1枚举
    // TriggerLevel2 事件触发level2             参数 0-20 参照TriggerLevel2枚举
    // CDTime        cd时间                     参数 时间(正值)
    // CDGroup       cd组(不同组的cd不同公共cd)  参数 0-无穷(整数)
    // ReleaseTime   可释放次数                 参数 1-无穷(整数)
    // Description   描述(中间替换符可被替换)    参数 描述描述中可填写占位符%0123...同样适用数据替换与技能值相同
    // Icon          icon地址                   参数 地址(或key)

}

/// <summary>
/// 技能触发类型第一级
/// </summary>
public enum SkillTriggerLevel1
{
    None = 0,   // 无触发条件
    Scope,      // 范围内触发
    Health,     // 血量触发(血量低于或高于XX触发)
    Fight,      // 战斗行为触发(攻击, 被攻击, 闪避...)
    Time,       // 时间触发(保持某状态一定时间)
    Buff,       // Buff触发(有正面Buff时或负面Buff时, 或指定Buff时触发)
    All         // 范围全地图触发(地方下兵或某数量大于1时触发)

}

/// <summary>
/// 技能触发类型第二级
/// </summary>
public enum SkillTriggerLevel2
{
    None = 0,               // 无触发条件
    Enemy,                  // 有敌方单位
    Friend,                 // 有友方单位
    NotFullHealthFriend,    // 有不满血友方单位
    FriendDeath,            // 有友方单位死亡
    EnemyDeath,             // 有敌方单位死亡
    EnemyHide,              // 有敌方隐形单位


    HealthScope,            // 血量在一定范围内
    Attack,                 // 攻击时
    Hit,                    // 命中时
    BeAttack,               // 被攻击时
    BeCure,                 // 被治疗时
    Dodge,                  // 闪避时
    Enter,                  // 入场时
    EnterEnd,               // 入场结束时
    Death,                  // 死亡时
    FatalHit,               // 受到致死攻击时

    SafeTime,               // 安全XX时长时
    ClearScope,             // 范围内XX时长无敌人时

    BuffDown,               // XXBuff消失时
    TakeBuffDie,            // 带XXBuff死亡时


}