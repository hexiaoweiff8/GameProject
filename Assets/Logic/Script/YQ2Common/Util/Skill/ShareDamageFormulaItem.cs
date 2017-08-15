using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 分摊伤害
/// </summary>
class ShareDamageFormulaItem : AbstractFormulaItem
    {
    /// <summary>
    /// Buff状态
    /// 0: action
    /// 1: attach
    /// 2: dettach
    /// </summary>
    public int BuffState { get; private set; }



    ///// <summary>
    ///// 初始化
    ///// </summary>
    ///// <param name="formulaType">单元行为类型(0: 不等待完成, 1: 等待其执行完毕)</param>

    //public MoveFormulaItem(int formulaType, float speed, int isBlink)
    //{
    //    FormulaType = formulaType;
    //}

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>单元行为类型(0: 不等待完成, 1: 等待其执行完毕)
    /// 1>目标点

    public ShareDamageFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 2;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }

        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var buffstate = GetDataOrReplace<int>("BuffState", array, 1, ReplaceDic);

        FormulaType = formulaType;
        BuffState = buffstate;

        //判断字典的KEY值是否存在，不存在则new一个LIST，插入到字典当中，存在就直接取

        if (!SkillDataBuffer.SkillDataCache.ContainsKey("shareDamageMember"))
        {
            List<DisplayOwner> shareDamageMember = new List<DisplayOwner>();
            SkillDataBuffer.SkillDataCache.Add("shareDamageMember", shareDamageMember);
        }
    }

    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">数据</param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {

        Debug.Log("BuffState----" + BuffState);


        if (paramsPacker == null)
        {
            return null;
        }

        // 替换替换符数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myFormulaType = FormulaType;
        var member = paramsPacker.ReleaseMember;
        var target = paramsPacker.ReceiverMenber;
        var myskill = paramsPacker.Skill;
        var myTrigger = paramsPacker.TriggerData;

        if (member == null || member.GameObj == null || member.ClusterData == null)
        {
            return null;
        }


        IFormula result = new Formula((callback, scope) =>
        {
            callback();
        }, myFormulaType);

       

        if (target == null || target.ClusterData == null)
        {
            Debug.Log("目标已经死亡");
            return result;
        }
  
        if (BuffState == 0)
        {

            if (myTrigger.HealthChangeLevel == 1)
            {
                return result;
            }

            //如果承伤列表中没有人则返回
            if (SkillDataBuffer.SkillDataCache["shareDamageMember"].Count == 0)
            {
                return result;
            }
            
            var Damage = myTrigger.HealthChangeValue;
            //计算平均数值
            var AverageDamage = Damage / SkillDataBuffer.SkillDataCache["shareDamageMember"].Count;
            Debug.Log("平均伤害数值" + AverageDamage);


            for (int i = 0; i < SkillDataBuffer.SkillDataCache["shareDamageMember"].Count; i++)
            {
                if (SkillDataBuffer.SkillDataCache["shareDamageMember"][i] == null || SkillDataBuffer.SkillDataCache["shareDamageMember"][i].ClusterData == null)
                {                  
                    Debug.Log("目标已经死亡");
                    //删除该元素
                    SkillDataBuffer.SkillDataCache["shareDamageMember"].Remove(SkillDataBuffer.SkillDataCache["shareDamageMember"][i]);
                }
            }

                for (int i = 0; i < SkillDataBuffer.SkillDataCache["shareDamageMember"].Count; i++)
            {
               // var shareMember = SkillDataBuffer.SkillDataCache["shareDamageMember"][i];

                if (target.ClusterData.AllData.MemberData.ObjID.ID == SkillDataBuffer.SkillDataCache["shareDamageMember"][i].ClusterData.AllData.MemberData.ObjID.ID)
                {
                    //如果是承伤发起者则修改自己受到的伤害数值
                    myTrigger.HealthChangeValue -= (AverageDamage * (SkillDataBuffer.SkillDataCache["shareDamageMember"].Count - 1));
                    myTrigger.HealthChangeLevel = 1;
                }
                else
                {
                    //如果是其他被承伤者则抛出伤害事件
                    SkillManager.Single.SetTriggerData(new TriggerData()
                    {            
                        HealthChangeValue = AverageDamage,
                        ReceiveMember = member,
                        ReleaseMember = SkillDataBuffer.SkillDataCache["shareDamageMember"][i],
                        HealthChangeLevel = 1,
                        TypeLevel1 = TriggerLevel1.Fight,
                        TypeLevel2 = TriggerLevel2.BeAttack                      
                    });
                }
            }
        }


        else if (BuffState == 1)
        {
            for (int i = 0; i < SkillDataBuffer.SkillDataCache["shareDamageMember"].Count; i++)
            {
                var shareMember = SkillDataBuffer.SkillDataCache["shareDamageMember"][i];
                //如果承伤成员列表中存在该单位则直接返回
                if (target.ClusterData.AllData.MemberData.ObjID.ID == shareMember.ClusterData.AllData.MemberData.ObjID.ID)
                {
                    Debug.Log("Target has in list");
                    return result;
                }
            }
            //如果没有则添加
            SkillDataBuffer.SkillDataCache["shareDamageMember"].Add(target);
        }
        else if (BuffState == 2)
        {
            for (int i = 0; i < SkillDataBuffer.SkillDataCache["shareDamageMember"].Count; i++)
            {
                var shareMember = SkillDataBuffer.SkillDataCache["shareDamageMember"][i];
                //如果找到了该单位则将其从列表中移出
                if (target.ClusterData.AllData.MemberData.ObjID.ID == shareMember.ClusterData.AllData.MemberData.ObjID.ID)
                {
                    SkillDataBuffer.SkillDataCache["shareDamageMember"].Remove(SkillDataBuffer.SkillDataCache["shareDamageMember"][i]);
                    break;
                }
            }
        }
        else
        {
            Debug.Log("BuffState输入有误" );
        }
        return result;
    }

}

