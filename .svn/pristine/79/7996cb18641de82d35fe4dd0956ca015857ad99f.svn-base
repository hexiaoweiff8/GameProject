using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class AvatarActInfo
{
    internal static short IID;
    internal static short IActMB;
    internal static short IActID;
    internal static short IScale;
    internal static short IUpDown;
    internal static short ILeftRight;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IActMB = reader.ColumnName2Index("ActMB");
        IActID = reader.ColumnName2Index("ActID");
        IScale = reader.ColumnName2Index("Scale");
        IUpDown = reader.ColumnName2Index("UpDown");
        ILeftRight = reader.ColumnName2Index("LeftRight");
    }
    public AvatarActInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(IID, row);
        ActMB = reader.GetS(IActMB, row);
        ActID = reader.GetI16(IActID, row);
        LeftRight = reader.GetF(ILeftRight, row);
        UpDown = reader.GetF(IUpDown, row);
        Scale = reader.GetF(IScale, row);
    }

    public readonly string ActMB;
    public readonly short ID;
    public readonly short ActID;
    public readonly float LeftRight;
    public readonly float UpDown;
    public readonly float Scale;
}

public class SData_AvatarAct
{
    public SData_AvatarAct()
    { 
        Single = this;

        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 AvatarAct");

        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "AvatarAct");
            AvatarActInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                AvatarActInfo sa = new AvatarActInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }
    }

    public AvatarActInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    Dictionary<int, AvatarActInfo> Data = new Dictionary<int, AvatarActInfo>();
    public static SData_AvatarAct Single;
}