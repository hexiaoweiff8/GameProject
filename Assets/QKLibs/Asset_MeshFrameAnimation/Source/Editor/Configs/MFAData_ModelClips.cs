using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;
using System.IO;
class MFAModelClipsInfo
{
    static internal short IName;
    static internal short IClips;

    public static void FillFieldIndex(CSVReader reader)
    {
        IName = reader.ColumnName2Index("Name");
        IClips = reader.ColumnName2Index("Clips"); 
    }

    public MFAModelClipsInfo(CSVReader reader, int row)
    {
        Name = reader.GetS(IName, row);
        var clips_str = reader.GetS(IClips, row);
        _Clips = clips_str.Split(';');
    }

    public void BuildLinks(MFAData_ClipDefine ClipDefine)
    {
        int len = _Clips.Length;
        Clips = new MFAClipDefineInfo[len];
        for (int i = 0; i < len; i++)
        {
            Clips[i] = ClipDefine.Get(_Clips[i]);
            if (Clips[i] == null) throw new Exception(string.Format("ModelClips 表引用了不存在的剪辑 Name:{0} ClipDefineName:{1}",Name, _Clips[i]));
        }
    }

    public MFAClipDefineInfo[] Clips;
    readonly string[] _Clips;
    public readonly string Name;
}

class MFAData_ModelClips
{
    public MFAData_ModelClips()
    {
        string path = MFAConfigPath.GenerateCfgPath("ModelClips");
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

        MFAModelClipsInfo.FillFieldIndex(reader);

        int count = reader.RowCount;
        for (int row = 0; row < count; row++)
        {
            var info = new MFAModelClipsInfo(reader, row);
            m_Data.Add(info.Name, info);
        }
    }



    public void AutoReload()
    {
        string path = MFAConfigPath.GenerateCfgPath("ModelClips");
        FileInfo finfo = new FileInfo(path);
        var lastWriteTime = finfo.LastWriteTime;
        if (lastWriteTime != m_LastWriteTime)
        {
            m_LastWriteTime = lastWriteTime;
            ReLoad(path);
        }
    }


    public MFAModelClipsInfo Get(string name)
    {
        return m_Data.ContainsKey(name) ? m_Data[name] : null;
    }

    public void BuildLinks(MFAData_ClipDefine ClipDefine)
    {
        foreach (var curr in m_Data) curr.Value.BuildLinks(ClipDefine);
    }

    DateTime m_LastWriteTime;
    Dictionary<string, MFAModelClipsInfo> m_Data = new Dictionary<string, MFAModelClipsInfo>(); 

} 