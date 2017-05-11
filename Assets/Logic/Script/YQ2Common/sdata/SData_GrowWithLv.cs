using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
public class GrowWithLvInfo
{
    const int max_lv = 80;
    internal static short IID;
    internal static short[] I_xs = new short[max_lv]; 

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        for (int i = 1; i <= max_lv;i++ )
        {
            I_xs[i - 1] = reader.ColumnName2Index(i.ToString());
        }
    } 

    public GrowWithLvInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(IID, row);
        for(int i=0;i<max_lv;i++) xs[i] = reader.GetF(I_xs[i],row);
    }
     
    public readonly int ID;
    public readonly float[] xs = new float[max_lv]; 
}

public class SData_GrowWithLv : MonoEX.Singleton<SData_GrowWithLv>
{
    public SData_GrowWithLv()
    {  
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 GrowWithLv");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "GrowWithLv");
            GrowWithLvInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                var sa = new GrowWithLvInfo(reader, row);
                if (!Data.ContainsKey(sa.ID))
                    Data.Add(sa.ID, sa);

                Data[sa.ID]  = sa;
            }
        }
    }

    public float Get(int id,int lv)
    {
        if (!Data.ContainsKey(id)) return 0;

        return Data[id].xs[lv-1] ;
    }
     
    Dictionary<int, GrowWithLvInfo> Data = new Dictionary<int, GrowWithLvInfo>();
} 
