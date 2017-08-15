using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 清除攻击目标
/// </summary>

    class CleanTargetFormulaItem :  AbstractFormulaItem
    {

        /// <summary>
        /// 目标点
        /// 0: 自己的位置
        /// 1: 目标的位置
        /// 2: 目标点选择的位置
        /// </summary>
        public int TargetPos { get; private set; }


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

        public CleanTargetFormulaItem(string[] array)
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
            var targetPos = GetDataOrReplace<int>("TargetPos", array, 1, ReplaceDic);

            FormulaType = formulaType;
            TargetPos = targetPos;
        }

        /// <summary>
        /// 生成行为节点
        /// </summary>
        /// <param name="paramsPacker">数据</param>
        /// <returns>行为节点</returns>
        public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
        {
            if (paramsPacker == null)
            {
                return null;
            }

            // 替换替换符数据
            ReplaceData(paramsPacker);
            // 数据本地化
            var myTargetPos = TargetPos;
            var member = paramsPacker.ReleaseMember;
            var target = paramsPacker.ReceiverMenber;
            var myFormulaType = FormulaType;

            if (member == null || member.GameObj == null || member.ClusterData == null)
            {
                return null;
            }

            IFormula result = new Formula((callback, scope) =>
            {
                if (myTargetPos == 0)
                {
                        member.RanderControl.CleanTarget();                    
                }
                else if (myTargetPos == 1)
                {
                        target.RanderControl.CleanTarget();
                }
                callback();
            }, myFormulaType);
            return result;
        }
    }

