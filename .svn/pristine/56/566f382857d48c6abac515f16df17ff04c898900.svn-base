using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_UILiteral : MonoEX.Singleton<SData_UILiteral>
{
    public void setData(LuaTable table1, LuaTable table2)
    {
        var head = new string[table1.Length];
        SDataUtils.dealTable(table1, (Object o1, Object o2) =>
        {
            head[(int)(double)o1 - 1] = (string)o2;
        });
        SDataUtils.dealTable(table2, (Object o1, Object o2) =>
        {
            UILiteralInfo dif = new UILiteralInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (short)(double)o22; break;
					case "Literal": dif.Literal = (string)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public UILiteralInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("UILiteralInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, UILiteralInfo> Data = new Dictionary<int, UILiteralInfo>();
}


public struct UILiteralInfo
{
	 /// <summary>
	 ///10002
	 /// </summary>
	public short ID;
	 /// <summary>
	 ///#N件套属性:
	 /// </summary>
	public string Literal;
}
