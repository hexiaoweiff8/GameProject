
using System;
using System.Collections.Generic;
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
    protected Dictionary<string, string> ReplaceDic = new Dictionary<string, string>();  

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
    /// <param name="replaceDic">替换列表(如果数据需要替换会放入该列表, 否则返回数据不放入列表)</param>
    /// <returns>转换后数据</returns>
    protected T GetDataOrReplace<T>(string name, string[] array, int pos, Dictionary<string, string> replaceDic)
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
        if (replaceDic == null)
        {
            throw new Exception("替换列表为空.");
        }

        var resultType = -1;

        T result = default(T);
        var typeName = typeof (T).Name;
        if (result is int)
        {
            resultType = 1;
        }
        if (result is float)
        {
            resultType = 2;
        }
        if (typeName.Equals("String"))
        {
            resultType = 3;
        }
        if (result is Enum)
        {
            resultType = 4;
        }
        var item = array[pos];
        if (item.StartsWith("%"))
        {
            var replacePos = Convert.ToInt32(item.Trim().Replace("%", ""));
            if (replacePos < 0)
            {
                throw new Exception("");
            }
            ReplaceDic.Add(name, resultType + "," + replacePos);
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
        if (ReplaceDic.Count > 0)
        {
            foreach (var item in ReplaceDic)
            {
                var propertyName = item.Key;
                var value = item.Value.Split(',');
                var itemType = Convert.ToInt32(value[0]);
                var pos = Convert.ToInt32(value[1]);
                // 获取当前等级-1(从0开始)的数据
                // 如果当前等级小于1则赋予1
                var skillLevel = paramsPacker.SkillLevel - 1;
                if (skillLevel < 0) skillLevel = 0;
                var dataRow = paramsPacker.DataList[skillLevel];
                var property = type.GetProperty(propertyName);
                if (property == null)
                {
                    throw new Exception("属性不存在:" + propertyName);
                }
                switch (itemType)
                {
                    case 1:
                        // int
                        property.SetValue(this, Convert.ToInt32(dataRow[pos]), null);
                        break;
                    case 2:
                        // float
                        property.SetValue(this, Convert.ToSingle(dataRow[pos]), null);
                        break;
                    case 3:
                        // string
                        property.SetValue(this, dataRow[pos], null);
                        break;
                    case 4:
                        // 枚举
                        property.SetValue(this, Convert.ToInt32(dataRow[pos]), null);
                        break;
                }
            }
        }
    }


}