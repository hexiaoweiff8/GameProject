using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;


/// <summary>
/// 修改数据行为
/// </summary>
public class ChangeDataFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 被变更属性名称
    /// </summary>
    public string PropertyName { get; set; }

    /// <summary>
    /// 数据变更值
    /// </summary>
    public string Value { get; set; }

    /// <summary>
    /// 数据变更类型
    /// </summary>
    public ChangeDataType ChangeDataType { get; set; }

    /// <summary>
    /// 接收单位(0: 自己,1:目标)
    /// </summary>
    public int ReceivePos { get; set; }

    /// <summary>
    /// 属性
    /// </summary>
    private PropertyInfo property = null;

    /// <summary>
    /// 字段
    /// </summary>
    private FieldInfo field = null;

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public ChangeDataFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }

        var argsCount = 5;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        PropertyName = array[1];
        Value = GetDataOrReplace<string>("Value", array, 2, ReplaceDic);
        ChangeDataType = GetDataOrReplace<ChangeDataType>("ChangeDataType", array, 3, ReplaceDic);
        ReceivePos = GetDataOrReplace<int>("ReceivePos", array, 4, ReplaceDic);

        property = typeof (VOBase).GetProperty(PropertyName);
        if (property == null)
        {
            field = typeof (VOBase).GetField(PropertyName);
            if (field == null)
            {
                throw new Exception("VOBase中不存在:" + PropertyName);
            }
        }
    }

    /// <summary>
    /// 生成行为
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;

        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }
        else if (string.IsNullOrEmpty(PropertyName) || property == null)
        {
            errorMsg = "属性名称为空.";
        }
        else if (string.IsNullOrEmpty(Value))
        {
            errorMsg = "属性值为空";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        // 替换数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myFormulaType = FormulaType;
        var myPropertyName = PropertyName;
        var myValue = Value;
        var myChangeDataType = ChangeDataType;
        var myProperty = property;
        var myField = field;
        var target = ReceivePos == 0 ? paramsPacker.ReleaseMember.ClusterData.AllData.MemberData : paramsPacker.ReceiverMenber.ClusterData.AllData.MemberData;

        result = new Formula((callback) =>
        {
            var changeData = new VOBase();
            // 给目标增加属性
            if (myProperty != null)
            {
                myProperty.SetValue(changeData, Convert.ChangeType(myValue, myProperty.PropertyType), null);
            }
            else if (myField != null)
            {
                myField.SetValue(changeData, Convert.ChangeType(myValue, myField.FieldType));
            }

            ChangeDataType tmpType = ChangeDataType.Absolute;
            if (paramsPacker.Skill.ChangeDataTypeDic.ContainsKey(myPropertyName))
            {
                tmpType = paramsPacker.Skill.ChangeDataTypeDic[myPropertyName];
                paramsPacker.Skill.ChangeDataTypeDic[myPropertyName] = myChangeDataType;
            }
            else
            {
                paramsPacker.Skill.ChangeDataTypeDic.Add(myPropertyName, myChangeDataType);
            }
            SkillBase.AdditionField(myField, target, changeData, paramsPacker.Skill.ChangedData, paramsPacker.Skill.ChangeDataTypeDic);

            paramsPacker.Skill.ChangeDataTypeDic[myPropertyName] = tmpType;
        },
        myFormulaType);

        return result;
    }
}