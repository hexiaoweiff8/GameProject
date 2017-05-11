using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using YQ2Common.CObjects;



public class SData_SuijiBox : MonoEX.Singleton<SData_SuijiBox>
{

    public SData_SuijiBox()
    {
        try
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SuijiBaoxiang");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "SuijiBaoxiang");

                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    SJBoxInfo sa = new SJBoxInfo(reader, row);
                    Data.Add(sa.ID, sa);
                }
            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "SuijiBaoxiang装载完毕");
        }
        catch (System.Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "SuijiBaoxiang初始化失败");
            throw ex;
        }
    }

    Dictionary<int, SJBoxInfo> Data = new Dictionary<int, SJBoxInfo>();


    #region(方法)

    public SJBoxInfo Get(int ID)
    {
        if (Data.ContainsKey(ID))
            return Data[ID];
        else
            return null;
    }

    #endregion

}

public class SJBoxInfo
{


    public SJBoxInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        Type = reader.GetI16(IType, row);
        ChujiangID = reader.GetI32(IChujiangID, row);
        Flag = reader.GetI16(IFlag, row);

    }


    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IType = reader.ColumnName2Index("Type");
        IChujiangID = reader.ColumnName2Index("ChujiangID");
        IFlag = reader.ColumnName2Index("Flag");
    }

    #region(属性)

    public readonly int ID = 0;
    public readonly int Type = 0;//招降武将ID
    public readonly int ChujiangID = 0;
    public readonly int Flag = 0;


    /**索引属性**/
    internal static short IID;
    internal static short IType;
    internal static short IChujiangID;
    internal static short IFlag;

    #endregion

}



