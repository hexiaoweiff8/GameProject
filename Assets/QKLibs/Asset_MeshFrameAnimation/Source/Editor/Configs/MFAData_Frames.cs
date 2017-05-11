using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;
using System.IO;

class MFAFramesInfo
{
    static internal short IName; 
    static internal short IResClipName;
    static internal short IResStartFrameIndex;
    static internal short IResEndFrameIndex;
    static internal short IResTag;
    static internal short IExportFrameCount;
    static internal short IIsLoop;
    public static void FillFieldIndex(CSVReader reader)
    {
        IName = reader.ColumnName2Index("Name");
        IResClipName = reader.ColumnName2Index("ResClipName");
        IResStartFrameIndex = reader.ColumnName2Index("ResStartFrameIndex");
        IResEndFrameIndex = reader.ColumnName2Index("ResEndFrameIndex");
        IResTag = reader.ColumnName2Index("ResTag");
        IExportFrameCount = reader.ColumnName2Index("ExportFrameCount");
        IIsLoop = reader.ColumnName2Index("IsLoop");
    }

  

    public MFAFramesInfo(CSVReader reader, int row)
    {
        Name = reader.GetS(IName, row);
        ResClipName = reader.GetS(IResClipName, row);
        ResStartFrameIndex = reader.GetI16(IResStartFrameIndex, row);
        ResEndFrameIndex = reader.GetI16(IResEndFrameIndex, row);
        ResTag = reader.GetS(IResTag, row);
        ExportFrameCount = reader.GetI16(IExportFrameCount, row);
        IsLoop = reader.GetI16(IIsLoop, row) == 1;
    }

    public int ResFrameCount { get { return ResEndFrameIndex - ResStartFrameIndex + 1; } }

    public readonly string Name;
    public readonly string ResClipName;
    public readonly short ResStartFrameIndex;
    public readonly short ResEndFrameIndex;
    public readonly string ResTag;
    public readonly short ExportFrameCount;
    public readonly bool IsLoop;
}

class MFAData_Frames
{
    public MFAData_Frames()
    {
        string path = MFAConfigPath.GenerateCfgPath("Frames");
        FileInfo finfo = new FileInfo(path);
        var lastWriteTime = finfo.LastWriteTime;
        if (lastWriteTime != m_LastWriteTime)
        {
            m_LastWriteTime = lastWriteTime;
            ReLoad(path);
        }
    }

    void ReLoad(string path)
    {
        m_Data.Clear();

        var doc = new CSVDoc();
        doc.LoadCsvFromMem(FileSystem.byte2string(FileSystem.ReadFile(path)));
        var reader = new CSVReader(doc);

        MFAFramesInfo.FillFieldIndex(reader);

        int count = reader.RowCount;
        for (int row = 0; row < count; row++)
        {
            var info = new MFAFramesInfo(reader, row);
            m_Data.Add(info.Name, info);
        }
    }


    public void AutoReload()
    {
        string path = MFAConfigPath.GenerateCfgPath("Frames");
        FileInfo finfo = new FileInfo(path);
        var lastWriteTime = finfo.LastWriteTime;
        if (lastWriteTime != m_LastWriteTime)
        {
            m_LastWriteTime = lastWriteTime;
            ReLoad(path);
        }
    }

    public MFAFramesInfo Get(string name)
    {
        return m_Data.ContainsKey(name) ? m_Data[name] : null;
    }

    DateTime m_LastWriteTime;
    Dictionary<string, MFAFramesInfo> m_Data = new Dictionary<string, MFAFramesInfo>(); 
}