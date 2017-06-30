using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;


/// <summary>
/// 技能基类
/// </summary>
public class SkillBase
{

    /// <summary>
    /// ID
    /// </summary>
    public int Num { get; protected set; }
     
    /// <summary>
    /// 唯一自增ID
    /// </summary>
    public long AddtionId { get; private set; }

    /// <summary>
    /// 保存技能等级数据列表
    /// </summary>
    public List<List<string>> DataList = new List<List<string>>();

    /// <summary>
    /// 触发条件Level1
    /// </summary>
    public TriggerLevel1 TriggerLevel1 { get; set; }

    /// <summary>
    /// 触发条件Level2
    /// </summary>
    public TriggerLevel2 TriggerLevel2 { get; set; }

    /// <summary>
    /// 技能的持有者
    /// </summary>
    public DisplayOwner ReleaseMember { get; set; }

    /// <summary>
    /// buff的Tick时间(单位 秒)
    /// 每次tick执行一次
    /// </summary>
    public float TickTime { get; set; }


    /// <summary>
    /// 修改数据
    /// 使用反射赋值
    /// </summary>
    public VOBase ChangeData { get; set; }

    /// <summary>
    /// 已经修改的数据总量
    /// 在buff Detach时进行删除用
    /// </summary>
    public VOBase ChangedData { get; set; }

    /// <summary>
    /// 数据变更类型字典
    /// (数据变更字段, 数据变更类型0:绝对值(加),1:百分比(1+值 乘))
    /// </summary>
    public Dictionary<string, ChangeDataType> ChangeDataTypeDic = new Dictionary<string, ChangeDataType>();

    /// <summary>
    /// 技能的数据域
    /// </summary>
    public SkillDataScope SkillDataScope = new SkillDataScope();

    /// <summary>
    /// buff触发行为
    /// </summary>
    protected IFormulaItem actionFormulaItem = null;

    /// <summary>
    /// buff 创建行为
    /// </summary>
    protected IFormulaItem attachFormulaItem = null;

    /// <summary>
    /// buff 结束行为
    /// </summary>
    protected IFormulaItem detachFormulaItem = null;

    /// <summary>
    /// 技能唯一自增ID
    /// </summary>
    protected static long addtionId = 1024;


    public SkillBase()
    {
        AddtionId = addtionId++;
    }





    /// <summary>
    /// 获取行为链
    /// </summary>
    /// <param name="paramsPacker">构造数据</param>
    /// <param name="formulaItem">行为链构造器</param>
    /// <returns></returns>
    protected IFormula GetIFormula(FormulaParamsPacker paramsPacker, IFormulaItem formulaItem)
    {
        IFormula result = null;
        // 循环构建行为链构造器
        var tmpItem = formulaItem;
        // 数据列表放入packer中
        paramsPacker.DataList = DataList;
        // 技能ID放入packer中
        paramsPacker.SkillNum = Num;
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
    /// 附加时的增加属性
    /// </summary>
    public static void AdditionAttribute(VOBase memberData, SkillBase skill)
    {
        if (memberData == null
            || skill == null
            || skill.ChangeData == null
            || skill.ChangeDataTypeDic == null)
        {
            return;
        }

        skill.ChangedData = new VOBase();

        // 获取可被变更的数据列表
        var propertyList = typeof(VOBase).GetProperties().Where((property) =>
        {
            if (property.GetCustomAttributes(typeof(SkillAddition), false).Any())
            {
                return true;
            }
            return false;
        });

        foreach (var property in propertyList)
        {
            AdditionProperty(property, memberData, skill.ChangeData, skill.ChangedData, skill.ChangeDataTypeDic);
        }

        var fieldList = typeof(VOBase).GetFields().Where((property) =>
        {
            if (property.GetCustomAttributes(typeof(SkillAddition), false).Any())
            {
                return true;
            }
            return false;
        });
        foreach (var field in fieldList)
        {
            AdditionField(field, memberData, skill.ChangeData, skill.ChangedData, skill.ChangeDataTypeDic);
        }
    }

    /// <summary>
    /// 加属性值
    /// </summary>
    /// <param name="property"></param>
    /// <param name="memberData"></param>
    public static void AdditionProperty(PropertyInfo property, VOBase memberData, VOBase changeData, VOBase changedData, IDictionary<string, ChangeDataType> changeDataTypeDic)
    {


        var propertyName = property.Name;
        ChangeDataType changeDataType = ChangeDataType.Absolute;
        // 读取赋值类型, 如果没有则默认使用绝对值
        if (changeDataTypeDic.ContainsKey(propertyName))
        {
            changeDataType = changeDataTypeDic[propertyName];
        }
        // 修改float类型属性
        if (property.PropertyType == typeof(float))
        {
            var sourceValue = Convert.ToSingle(property.GetValue(memberData, null));
            var plusValue = Convert.ToSingle(property.GetValue(changeData, null)) * (changeDataType == ChangeDataType.Absolute ? 1 : sourceValue);
            property.SetValue(memberData, sourceValue + plusValue, null);
            // 保存变更数据
            property.SetValue(changedData, plusValue, null);
        }
        // 修改bool类型属性
        else if (property.PropertyType == typeof(bool))
        {
            property.SetValue(memberData, Convert.ToBoolean(property.GetValue(changeData, null)), null);
            // 保存变更数据
            property.SetValue(changedData, property.GetValue(memberData, null), null);
        }
        // 修改int,short,long类型属性
        else if (property.PropertyType == typeof(long) || property.PropertyType == typeof(short) || property.PropertyType == typeof(int))
        {
            var sourceValue = Convert.ToInt64(property.GetValue(memberData, null));
            var plusValue = Convert.ToInt64(property.GetValue(changeData, null)) * (changeDataType == ChangeDataType.Absolute ? 1 : sourceValue);
            property.SetValue(memberData, Convert.ChangeType((sourceValue + plusValue), property.PropertyType), null);
            // 保存变更数据
            property.SetValue(changedData, Convert.ChangeType(plusValue, property.PropertyType), null);
        }
    }

    /// <summary>
    /// 加字段值
    /// </summary>
    /// <param name="field"></param>
    /// <param name="memberData"></param>
    /// <param name="skill"></param>
    public static void AdditionField(FieldInfo field, VOBase memberData, VOBase changeData, VOBase changedData, IDictionary<string, ChangeDataType> changeDataTypeDic)
    {
        var propertyName = field.Name;
        ChangeDataType changeDataType = ChangeDataType.Absolute;
        // 读取赋值类型, 如果没有则默认使用绝对值
        if (changeDataTypeDic.ContainsKey(propertyName))
        {
            changeDataType = changeDataTypeDic[propertyName];
        }
        // 修改float类型属性
        if (field.FieldType == typeof(float))
        {
            var sourceValue = Convert.ToSingle(field.GetValue(memberData));
            var plusValue = Convert.ToSingle(field.GetValue(changeData)) * (changeDataType == ChangeDataType.Absolute ? 1 : sourceValue);
            field.SetValue(memberData, sourceValue + plusValue);
            // 保存变更数据
            field.SetValue(changedData, plusValue);
        }
        // 修改bool类型属性
        else if (field.FieldType == typeof(bool))
        {
            field.SetValue(memberData, Convert.ToBoolean(field.GetValue(changeData)));
            // 保存变更数据
            field.SetValue(changedData, field.GetValue(memberData));
        }
        // 修改int,short,long类型属性
        else if (field.FieldType == typeof(long) || field.FieldType == typeof(short) || field.FieldType == typeof(int))
        {
            var sourceValue = Convert.ToInt64(field.GetValue(memberData));
            var plusValue = Convert.ToInt64(field.GetValue(changeData)) * (changeDataType == ChangeDataType.Absolute ? 1 : sourceValue);
            field.SetValue(memberData, Convert.ChangeType((sourceValue + plusValue), field.FieldType));
            // 保存变更数据
            field.SetValue(changedData, Convert.ChangeType(plusValue, field.FieldType));
        }
    }

    /// <summary>
    /// 减去增加的属性
    /// </summary>
    public static void SubAttribute(VOBase memberData, VOBase changedData)
    {
        if (memberData == null || changedData == null)
        {
            return;
        }
        
        // 获取可被变更的数据列表
        var propertyList = typeof(VOBase).GetProperties().Where((property) =>
        {
            if (property.GetCustomAttributes(typeof(SkillAddition), false).Any())
            {
                return true;
            }
            return false;
        });

        foreach (var property in propertyList)
        {
            // 修改float类型属性
            if (property.PropertyType == typeof(float))
            {
                var sourceValue = Convert.ToSingle(property.GetValue(memberData, null));
                var subValue = Convert.ToSingle(property.GetValue(changedData, null));
                property.SetValue(memberData, sourceValue - subValue, null);
            }
            // 修改bool类型属性
            else if (property.PropertyType == typeof(bool))
            {
                property.SetValue(memberData, Convert.ToBoolean(property.GetValue(changedData, null)), null);
            }
            // 修改int,short,long类型属性
            else if (property.PropertyType == typeof(long) || property.PropertyType == typeof(short) || property.PropertyType == typeof(int))
            {
                var sourceValue = Convert.ToInt64(property.GetValue(memberData, null));
                var plusValue = Convert.ToInt64(property.GetValue(changedData, null));
                property.SetValue(memberData, Convert.ChangeType((sourceValue - plusValue), property.PropertyType), null);
            }
        }

        var fieldList = typeof(VOBase).GetFields().Where((property) =>
        {
            if (property.GetCustomAttributes(typeof(SkillAddition), false).Any())
            {
                return true;
            }
            return false;
        });
        foreach (var field in fieldList)
        {
            // 修改float类型属性
            if (field.FieldType == typeof(float))
            {
                var sourceValue = Convert.ToSingle(field.GetValue(memberData));
                var subValue = Convert.ToSingle(field.GetValue(changedData));
                field.SetValue(memberData, sourceValue - subValue);
            }
            // 修改bool类型属性
            else if (field.FieldType == typeof(bool))
            {
                field.SetValue(memberData, Convert.ToBoolean(field.GetValue(changedData)));
            }
            // 修改int,short,long类型属性
            else if (field.FieldType == typeof(long) || field.FieldType == typeof(short) || field.FieldType == typeof(int))
            {
                var sourceValue = Convert.ToInt64(field.GetValue(memberData));
                var plusValue = Convert.ToInt64(field.GetValue(changedData));
                field.SetValue(memberData, Convert.ChangeType((sourceValue - plusValue), field.FieldType));
            }
        }
    }

}


/// <summary>
/// 技能数据域
/// </summary>
public class SkillDataScope
{

    /// <summary>
    /// 数据域-float
    /// </summary>
    private Dictionary<string, float> dataScopeFloat = new Dictionary<string, float>();

    /// <summary>
    /// 数据域-int
    /// </summary>
    private Dictionary<string, int> dataScopeInt = new Dictionary<string, int>();

    /// <summary>
    /// 数据域-long
    /// </summary>
    private Dictionary<string, long> dataScopeLong = new Dictionary<string, long>();

    /// <summary>
    /// 数据域-bool
    /// </summary>
    private Dictionary<string, bool> dataScopeBool = new Dictionary<string, bool>();

    ///// <summary>
    ///// 数据域-string
    ///// </summary>
    //private Dictionary<string, string> dataScopeString = new Dictionary<string, string>();



    public float? GetFloat(string key)
    {
        if (dataScopeFloat.ContainsKey(key))
        {
            return dataScopeFloat[key];
        }
        else
        {
            return null;
        }
    }


    public int? GetInt(string key)
    {
        if (dataScopeInt.ContainsKey(key))
        {
            return dataScopeInt[key];
        }
        else
        {
            return null;
        }
    }


    public long? GetLong(string key)
    {
        if (dataScopeLong.ContainsKey(key))
        {
            return dataScopeLong[key];
        }
        else
        {
            return null;
        }
    }


    public bool? GetBool(string key)
    {
        if (dataScopeBool.ContainsKey(key))
        {
            return dataScopeBool[key];
        }
        else
        {
            return null;
        }
    }


    //public string GetString(string key)
    //{
    //    return dataScopeString[key];
    //}


    public void SetFloat(string key, float value)
    {
        if (dataScopeFloat.ContainsKey(key))
        {
            dataScopeFloat[key] = value;
        }
        else
        {
            dataScopeFloat.Add(key, value);
        }
    }
    public void SetInt(string key, int value)
    {
        if (dataScopeInt.ContainsKey(key))
        {
            dataScopeInt[key] = value;
        }
        else
        {
            dataScopeInt.Add(key, value);
        }
    }
    public void SetLong(string key, long value)
    {
        if (dataScopeLong.ContainsKey(key))
        {
            dataScopeLong[key] = value;
        }
        else
        {
            dataScopeLong.Add(key, value);
        }
    }
    public void SetBool(string key, bool value)
    {
        if (dataScopeBool.ContainsKey(key))
        {
            dataScopeBool[key] = value;
        }
        else
        {
            dataScopeBool.Add(key, value);
        }
    }
    //public void SetString(string key, string value)
    //{
    //    if (dataScopeString.ContainsKey(key))
    //    {
    //        dataScopeString[key] = value;
    //    }
    //    else
    //    {
    //        dataScopeString.Add(key, value);
    //    }
    //}

    //public T Get<T>(string key)
    //{
    //    T result = default (T);
    //    var type = typeof (T);
    //    if (type == typeof(float))
    //    {
    //        result = (T)Convert.ChangeType(dataScopeFloat[key], type);
    //    }
    //    else if (type == typeof(int))
    //    {
    //        result = (T)Convert.ChangeType(dataScopeInt[key], type);
    //    }
    //    else if (type == typeof(long))
    //    {
    //        result = (T)Convert.ChangeType(dataScopeLong[key], type);
    //    }
    //    else if (type == typeof(bool))
    //    {
    //        result = (T)Convert.ChangeType(dataScopeBool[key], type);
    //    }
    //    else if (type == typeof(string))
    //    {
    //        result = (T)Convert.ChangeType(dataScopeString[key], type);
    //    }
    //    return result;
    //}


    //public void Set<T>(string key, T value)
    //{
    //    if (typeof (T) == typeof (float))
    //    {
    //        dataScopeFloat.Add(key, (float)value);
    //    }
    //    else if (typeof(T) == typeof(int))
    //    {

    //    }
    //    else if (typeof(T) == typeof(long))
    //    {

    //    }
    //    else if (typeof(T) == typeof(bool))
    //    {

    //    }
    //    else if (typeof(T) == typeof(string))
    //    {

    //    }
    //}
}