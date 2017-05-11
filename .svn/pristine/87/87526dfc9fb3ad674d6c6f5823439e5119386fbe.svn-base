using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;

public class SData_Id2String : MonoEX.Singleton<SData_Id2String>
{
    public SData_Id2String()
    {
        Debug.Logout(MonoEX.LOG_TYPE.LT_INFO,"开始装载 Id2String"); 

        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "Id2String");
            short IID = reader.ColumnName2Index("id");
            short Istr = reader.ColumnName2Index("str");
            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                int id = reader.GetI32(IID, row);
                string str = reader.GetS(Istr, row);
                if (Data.ContainsKey(id))
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + id.ToString());
                Data.Add(id, str);
            }
        }
    }

    public string Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    Dictionary<int, string> Data = new Dictionary<int, string>(); 
}
