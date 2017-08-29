
using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/// <summary>
/// 行为链单元构造器接口
/// </summary>
public interface IFormulaItem
{
    /// <summary>
    /// 行为类型
    /// 0: 不等待其执行结束继续
    /// 1: 等待期执行结束调用callback
    /// </summary>
    int FormulaType { get; }


    /// <summary>
    /// 下一个节点
    /// </summary>
    IFormulaItem NextFormulaItem { get; set; }

    /// <summary>
    /// 上一个节点
    /// </summary>
    IFormulaItem PreviewFormulaItem { get; set; }

    /// <summary>
    /// 是否包含下一节点
    /// </summary>
    /// <returns>是否有下一节点</returns>
    bool HasNext();

    /// <summary>
    /// 添加下一节点
    /// </summary>
    /// <param name="nextBehavior">下一个节点</param>
    /// <returns>下一个节点</returns>
    IFormulaItem After(IFormulaItem nextBehavior);



    IFormulaItem GetFirst();



    /// <summary>
    /// 生成行为单元
    /// </summary>
    /// <returns>行为单元对象</returns>
    IFormula GetFormula(FormulaParamsPacker paramsPacker);

    /// <summary>
    /// 获得子集行为节点单元
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    IFormulaItem GetSubIFormulaItem();



    /// <summary>
    /// 获得子集行为节点单元
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    IFormulaItem AddSubFormulaItem(IFormulaItem formulaItem);
}


public abstract class AbstractFormulaItem : IFormulaItem
{

    /// <summary>
    /// 行为节点类型
    /// 0: 不等待该节点执行完毕
    /// 1: 等待该节点执行完毕后再继续执行之后的节点
    /// </summary>
    public int FormulaType { get; protected set; }

    /// <summary>
    /// 下一节点
    /// </summary>
    public IFormulaItem NextFormulaItem { get; set; }

    /// <summary>
    /// 上一节点
    /// </summary>
    public IFormulaItem PreviewFormulaItem { get; set; }

    /// <summary>
    /// 子行为链
    /// </summary>
    protected IFormulaItem SubFormulaItem { get; set; }

    /// <summary>
    /// 被替换列表
    /// </summary>
    protected Dictionary<string, List<string>> ReplaceDic = new Dictionary<string, List<string>>();

    /// <summary>
    /// 被替换列表
    /// </summary>
    protected Dictionary<string, string> ReplaceSourceDataDic = new Dictionary<string, string>();  

    /// <summary>
    /// 是否包含下一节点
    /// </summary>
    /// <returns></returns>
    public bool HasNext()
    {
        if (NextFormulaItem == null)
        {
            return false;
        }
        return true;
    }

    /// <summary>
    /// 添加下一节点
    /// </summary>
    /// <param name="nextBehavior">下一节点</param>
    /// <returns>当前节点</returns>
    public IFormulaItem After(IFormulaItem nextBehavior)
    {
        if (nextBehavior != null)
        {
            // 如果后一个单位不为空则向后移
            if (NextFormulaItem != null)
            {
                NextFormulaItem.After(NextFormulaItem);
            }
            NextFormulaItem = nextBehavior;
            nextBehavior.PreviewFormulaItem = this;

            return nextBehavior;
        }
        return this;
    }

    /// <summary>
    /// 获得行为链的head
    /// </summary>
    /// <returns>行为链Head</returns>
    public IFormulaItem GetFirst()
    {
        IFormulaItem result = this;

        while (result.PreviewFormulaItem != null)
        {
            result = result.PreviewFormulaItem;
        }
        return result;
    }

    /// <summary>
    /// 获取行为节点具体实现
    /// </summary>
    /// <param name="paramsPacker">数据对象</param>
    /// <returns></returns>
    public abstract IFormula GetFormula(FormulaParamsPacker paramsPacker);

    /// <summary>
    /// 获取该节点的子集行为
    /// </summary>
    /// <returns>子集行为链Head</returns>
    public IFormulaItem GetSubIFormulaItem()
    {
        return SubFormulaItem;
    }

    /// <summary>
    /// 增加子集行为
    /// </summary>
    /// <param name="formulaItem">被添加进行为链的节点, 不能为null</param>
    /// <returns>当前被添加节点</returns>
    public IFormulaItem AddSubFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        if (SubFormulaItem == null)
        {
            SubFormulaItem = formulaItem;
        }
        else
        {
            SubFormulaItem.After(formulaItem);
        }
        return formulaItem;
    }

    /// <summary>
    /// 获取位置
    /// </summary>
    /// <param name="posType">位置类型</param>
    /// <param name="paramsPacker">数据包装类</param>
    /// <param name="scope">数据域</param>
    /// <returns></returns>
    public static Vector3 GetPosByType(int posType, FormulaParamsPacker paramsPacker, DataScope scope)
    {

        // 获取目标位置
        var posX = 0f;
        var posY = 0f;
        var height = paramsPacker.ReleaseMember.ClusterData.Height;
        switch (posType)
        {
            case 0:
                {
                    posX = paramsPacker.ReleaseMember.ClusterData.X;
                    posY = paramsPacker.ReleaseMember.ClusterData.Y;
                }
                break;
            case 1:
                {
                    posX = paramsPacker.ReceiverMenber.ClusterData.X;
                    posY = paramsPacker.ReceiverMenber.ClusterData.Y;
                    height = paramsPacker.ReceiverMenber.ClusterData.Height;
                }
                break;
            case 2:
                {
                    posX = scope.GetFloat(Utils.TargetPointSelectorXKey) ?? 0f;
                    posY = scope.GetFloat(Utils.TargetPointSelectorYKey) ?? 0f;
                }
                break;
        }
        var pos = new Vector3(posX, height, posY);

        return pos;
    }


    /// <summary>
    /// 获得数据或替换
    /// </summary>
    /// <param name="name">数据名称</param>
    /// <param name="array">数据列表</param>
    /// <param name="pos">当前数据位置</param>
    /// <returns>转换后数据</returns>
    protected T GetDataOrReplace<T>(string name, string[] array, int pos)
    {
        if (string.IsNullOrEmpty(name))
        {
            throw new Exception("字段名为空.");
        }
        if (array == null || array.Length == 0)
        {
            throw new Exception("数据为空.");
        }
        if (pos < 0)
        {
            throw new Exception("数据位置非法pos:" + pos);
        }
        //if (replaceDic == null)
        //{
        //    throw new Exception("替换列表为空.");
        //}

        var resultType = -1;

        var result = default(T);
        var type = typeof (T);
        var typeName = type.Name;
        if (typeName.Equals("Int32"))
        {
            resultType = 1;
        }
        if (typeName.Equals("Single"))
        {
            resultType = 2;
        }
        if (typeName.Equals("String"))
        {
            resultType = 3;
        }
        else if (result is Enum)
        {
            resultType = 4;
        }
        if (typeName.Equals("Boolean"))
        {
            resultType = 5;
        }
        if (typeName.Equals("FormulaItemValueComputer"))
        {
            resultType = 6;
        }
        var item = array[pos];
        // 数据是否需要替换
        if (item.Contains("{%") || item.Contains("<"))
        {
            ReplaceSourceDataDic.Add(name, resultType + "," + item);
            //var replacePos = Convert.ToInt32(item.Trim().Replace("{%", ""));
            //if (replacePos < 0)
            //{
            //    throw new Exception("");
            //}
            //if (ReplaceDic.ContainsKey(name))
            //{
            //    ReplaceDic[name].Add(resultType + "," + replacePos);
            //}
            //else
            //{
            //    ReplaceDic.Add(name, new List<string>() { resultType + "," + replacePos });
            //}
        }
        else
        {
            switch (resultType)
            {
                case 1:
                    // int
                    result = (T)Convert.ChangeType(item, typeof(T));
                    break;
                case 2:
                    // float
                    result = (T)Convert.ChangeType(item, typeof(T));
                    break;
                case 3:
                    // string
                    result = (T)(object)item;
                    break;
                case 4:
                    // enum
                    result = (T)Enum.Parse(typeof(T), item);
                    break;
                case 5:
                    // bool
                    result = (T)Convert.ChangeType(item, typeof(T));
                    break;
                case 6:
                    // 数值计算类, 支持加减乘数公式
                    result = (T)Convert.ChangeType((new FormulaItemValueComputer(item)), typeof(T));
                    break;
            }
        }


        return result;
    }

    /// <summary>
    /// 将属性替换为对应数据
    /// </summary>
    /// <param name="paramsPacker">数据packer</param>
    protected void ReplaceData(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            throw new Exception("数据Packer为空.");
        }
        var type = this.GetType();

        // 遍历替换列表 如果存在数据则替换对应数据
        if (ReplaceSourceDataDic.Count > 0)
        {

            // 技能等级
            var skillLevel = paramsPacker.SkillLevel - 1;
            if (skillLevel < 0) skillLevel = 0;
            // 该等级的数据列表
            var dataRow = paramsPacker.DataList[skillLevel];
            var dataClassType = paramsPacker.ReleaseMember.ClusterData.AllData.MemberData.GetType();

            foreach (var item in ReplaceSourceDataDic)
            {
                var propertyName = item.Key;
                var value = item.Value.Split(',');
                var itemType = Convert.ToInt32(value[0]);
                var strInfo = value[1];

                // 替换DataList中数据
                for (var i = 0; i < dataRow.Count; i++)
                {
                    strInfo = strInfo.Replace("{%" + i + "}", dataRow[i]);
                }

                // 获取strInfo中所有被替换数据
                // 循环这些被替换数据
                // 先替换数据, 再转换类型
                var strParts = strInfo.Split('<', '>');
                var dataStr = "";
                for (var i = 0; i < strParts.Length; i++)
                {
                    var tmpStr = strParts[i].Trim();
                    // 判断字符串有效
                    if (!string.IsNullOrEmpty(tmpStr))
                    {
                        if (i%2 == 1)
                        {
                            // 替换数据
                            dataStr += GetPropertyOrFieldValue(dataClassType, tmpStr, paramsPacker.ReleaseMember.ClusterData.AllData.MemberData);
                        }
                        else
                        {
                            dataStr += tmpStr;
                        }
                    }
                }

                var property = type.GetProperty(propertyName);
                if (property == null)
                {
                    throw new Exception("数据目标属性不存在:" + propertyName);
                }
                switch (itemType)
                {
                    case 1:
                        // int
                        property.SetValue(this, Convert.ToInt32(dataStr), null);
                        break;
                    case 2:
                        // float
                        property.SetValue(this, Convert.ToSingle(dataStr), null);
                        break;
                    case 3:
                        // string
                        property.SetValue(this, dataStr, null);
                        break;
                    case 4:
                        // 枚举
                        property.SetValue(this, Convert.ToInt32(dataStr), null);
                        break;
                    case 5:
                        // 枚举
                        property.SetValue(this, Convert.ToBoolean(dataStr), null);
                        break;
                    case 6:
                        // 计算公式类
                        property.SetValue(this, new FormulaItemValueComputer(dataStr), null);
                        break;
                }
            }
        }
    }

    /// <summary>
    /// 获取属性的值
    /// </summary>
    /// <param name="type">被获取类型</param>
    /// <param name="propertyOrFieldName">字段名称</param>
    /// <param name="obj">被获取对象</param>
    /// <returns>获取的值</returns>
    public static string GetPropertyOrFieldValue(Type type, string propertyOrFieldName, object obj)
    {
        string result = null;
        var dataProperty = type.GetProperty(propertyOrFieldName);
        if (dataProperty == null)
        {
            var dataField = type.GetField(propertyOrFieldName);
            if (dataField == null)
            {
                throw new Exception("数据源属性不存在:" + propertyOrFieldName);
            }
            else
            {
                result = "" + dataField.GetValue(obj);
            }
        }
        else
        {
            result = "" + dataProperty.GetValue(obj, null);
        }
        return result;;
    }


    /// <summary>
    /// 行为数据计算器
    /// 用于计算
    /// </summary>
    public class FormulaItemValueComputer
    {
        /// <summary>
        /// 被计算的字符串值
        /// </summary>
        public string StringVal = null;

        /// <summary>
        /// 生成计算类
        /// </summary>
        /// <param name="stringVal">被计算字符串</param>
        public FormulaItemValueComputer(string stringVal)
        {
            StringVal = stringVal;
        }


        /// <summary>
        /// 获取值
        /// </summary>
        /// <returns></returns>
        public float GetValue()
        {
            var result = 0f;
            if (!string.IsNullOrEmpty(StringVal))
            {
                // 生成计算类
                var compute = new Compute(StringVal);
                // 返回计算值
                return compute.GetValue();
            }

            return result;
        }

        /// <summary>
        /// 加减乘除计算类
        /// </summary>
        private class Compute
        {
            /// <summary>
            /// 本地计算
            /// </summary>
            private List<Compute> computeList = new List<Compute>();

            /// <summary>
            /// 计算类型
            /// </summary>
            private ComputeType computeType = ComputeType.None;

            /// <summary>
            /// 被计算字符串
            /// </summary>
            private string myFormula = null;


            public Compute(string formula)
            {
                if (string.IsNullOrEmpty(formula))
                {
                    return;
                }
                myFormula = formula;
                // 检测当前节点的计算类型
                if (formula.Contains("-"))
                {
                    computeType = ComputeType.Sub;
                }
                else if (formula.Contains("+"))
                {
                    computeType = ComputeType.Plus;
                }
                else if (formula.Contains("/"))
                {
                    computeType = ComputeType.Div;
                }
                else if (formula.Contains("*"))
                {
                    computeType = ComputeType.Mult;
                }
                else
                {
                    return;
                }

                char sign = '\0';
                switch (computeType)
                {
                    // 乘
                    case ComputeType.Mult:
                        sign = '*';
                        break;
                    // 除
                    case ComputeType.Div:
                        sign = '/';
                        break;
                    // 加
                    case ComputeType.Plus:
                        sign = '+';
                        break;
                    // 减
                    case ComputeType.Sub:
                        sign = '-';
                        break;
                }

                var array = formula.Split(sign);
                foreach (var item in array)
                {
                    AddCompute(new Compute(item));
                }
            }

            /// <summary>
            /// 添加子集运算
            /// </summary>
            /// <param name="compute">被添加子集运算</param>
            public void AddCompute(Compute compute)
            {
                if (compute == null)
                {
                    return;
                }
                computeList.Add(compute);
            }

            /// <summary>
            /// 获取值
            /// </summary>
            /// <returns></returns>
            public float GetValue()
            {
                var result = 0f;
                switch (computeType)
                {
                        // 乘
                    case ComputeType.Mult:
                        result = computeList[0].GetValue();
                        for (var i = 1; i < computeList.Count; i++)
                        {
                            result *= computeList[i].GetValue();
                        }
                        break;
                        // 除
                    case ComputeType.Div:
                        result = computeList[0].GetValue();
                        for (var i = 1; i < computeList.Count; i++)
                        {
                            result /= computeList[i].GetValue();
                        }
                        break;
                        // 加
                    case ComputeType.Plus:
                        computeList.ForEach(item => result += item.GetValue());
                        break;
                        // 减
                    case ComputeType.Sub:
                        result = computeList[0].GetValue();
                        for (var i = 1; i < computeList.Count; i++)
                        {
                            result -= computeList[i].GetValue();
                        }
                        break;
                        // 无操作
                    case ComputeType.None:
                        result = Convert.ToSingle(myFormula);
                        break;
                }

                return result;
            }


            /// <summary>
            /// 计算类型
            /// </summary>
            public enum ComputeType
            {
                None,   // 无计算
                Plus,   // 加
                Sub,    // 减
                Mult,   // 乘
                Div     // 除
            }
        }
    }


}