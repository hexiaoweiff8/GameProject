using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;
using System.IO;

class MFAClipDefineInfo
{
    static internal short IName;
    static internal short IClipName;
    static internal short IFrameRange;

    public static void FillFieldIndex(CSVReader reader)
    {
        IName = reader.ColumnName2Index("Name");
        IClipName = reader.ColumnName2Index("ClipName"); 
        IFrameRange = reader.ColumnName2Index("FrameRange"); 
    }

    public MFAClipDefineInfo(CSVReader reader, int row)
    {
        Name = reader.GetS(IName, row);
        ClipName= reader.GetS(IClipName, row);

        var frameRange_str = reader.GetS(IFrameRange, row);
        _FrameRanges = frameRange_str.Split(';');
    }

    public void BuildLinks(MFAData_Frames ClipDefine)
    {
        int len = _FrameRanges.Length;
        FrameRanges = new MFAFramesInfo[len];
        for (int i = 0; i < len; i++)
        {
            FrameRanges[i] = ClipDefine.Get(_FrameRanges[i]);
            if (FrameRanges[i] == null) throw new Exception(string.Format("ClipDefine 表引用了不存在的帧 Name:{0} ClipDefineName:{1}", Name, _FrameRanges[i]));
        }
    }

    readonly string[] _FrameRanges;
    public MFAFramesInfo[] FrameRanges;
    public readonly string ClipName;
    public readonly string Name;
} 

class MFAData_ClipDefine
{
    const string TabName = "ClipDefine";
    public MFAData_ClipDefine()
    {
        string path = MFAConfigPath.GenerateCfgPath(TabName);
        FileInfo finfo = new FileInfo(path);
        m_LastWriteTime = finfo.LastWriteTime;

        ReLoad(path);
    }

    public void AutoReload()
    {
        string path = MFAConfigPath.GenerateCfgPath(TabName);
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

        MFAClipDefineInfo.FillFieldIndex(reader);

        int count = reader.RowCount;
        for (int row = 0; row < count; row++)
        {
            var info = new MFAClipDefineInfo(reader, row);

            if (m_Data.ContainsKey(info.Name))
            {
                throw new Exception(string.Format("表{0}中存在重复的名称 {1}", TabName,info.Name));
            }
            m_Data.Add(info.Name, info);
        }
    }

    public MFAClipDefineInfo Get(string name)
    {
        return m_Data.ContainsKey(name) ? m_Data[name] : null;
    }

    public void BuildLinks(MFAData_Frames ClipDefine)
    {
        foreach (var curr in m_Data) curr.Value.BuildLinks(ClipDefine);
    }

    DateTime m_LastWriteTime;
    Dictionary<string, MFAClipDefineInfo> m_Data = new Dictionary<string, MFAClipDefineInfo>(); 

} 