using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;
using System.IO;

class MFAAnimationExportInfo
{
    const int ModeLodCount = 3;
    static internal short IID;
    static internal short IFileSuffix;
    static internal short ITags;
    static internal short IFindTag;
    static internal short IModelClips;
    static internal short IPack;
    static internal short ITexture;
    static internal short IGameObjNameSuffix;
    static internal short[] ILodModes = new short[ModeLodCount];
    public static void FillFieldIndex(CSVReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IFileSuffix = reader.ColumnName2Index("FileSuffix");
        ITags = reader.ColumnName2Index("Tags");
        IFindTag = reader.ColumnName2Index("FindTag");
        IModelClips = reader.ColumnName2Index("ModelClips");
        IPack = reader.ColumnName2Index("Pack");
        IGameObjNameSuffix = reader.ColumnName2Index("GameObjNameSuffix");
        ITexture = reader.ColumnName2Index("Texture");

        for (int i = 0; i < ModeLodCount; i++)
            ILodModes[i] = reader.ColumnName2Index("LodModel" + (i + 1).ToString());
    }

    public MFAAnimationExportInfo(CSVReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        FileSuffix = reader.GetS(IFileSuffix, row);

        var tags_str = reader.GetS(ITags, row);
        Tags = tags_str.Split(';');

        var findtags_str = reader.GetS(IFindTag, row);
        FindTag = findtags_str.Split(';');

        ModelClips = reader.GetS(IModelClips, row);
        Pack = reader.GetS(IPack, row).ToLower();

        List<string> lodModelList = new List<string>();
        for (int i = 0; i < ModeLodCount; i++)
        {
            var md = reader.GetS(ILodModes[i], row);
            if (!string.IsNullOrEmpty(md))
                lodModelList.Add(md);
        }
        LodModes = lodModelList.ToArray();

        GameObjNameSuffix = reader.GetS(IGameObjNameSuffix, row);

        


        var texture_str = reader.GetS(ITexture, row);
        if (!string.IsNullOrEmpty(texture_str.Trim()))
            Texture = texture_str.Split(';');
        else
            Texture = null;
    }

    public readonly string[] Texture;
    public readonly string[] LodModes;
    public readonly string[] Tags;
    public readonly string[] FindTag;
    public readonly string FileSuffix;
    public readonly string ModelClips;
    public readonly string Pack;
    public readonly string GameObjNameSuffix;
    public readonly int ID;
}

class MFAData_AnimationExport
{
    public MFAData_AnimationExport()
    {
        string path = MFAConfigPath.GenerateCfgPath("AnimationExport");
        FileInfo finfo = new FileInfo(path);
        m_LastWriteTime = finfo.LastWriteTime;

        ReLoad(path);
    }

    public void AutoReload()
    {
        string path = MFAConfigPath.GenerateCfgPath("AnimationExport");
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
        var nr = FileSystem.byte2string(FileSystem.ReadFile(path));
        doc.LoadCsvFromMem(nr);
        var reader = new CSVReader(doc);

        MFAAnimationExportInfo.FillFieldIndex(reader);

        int count = reader.RowCount;
        for (int row = 0; row < count; row++)
        {
            var info = new MFAAnimationExportInfo(reader, row);
            m_Data.Add(info.ID, info);
        }
    }

    public MFAAnimationExportInfo Get(int ID)
    {
        return m_Data.ContainsKey(ID) ? m_Data[ID] : null;
    }

    DateTime m_LastWriteTime;
    public Dictionary<int, MFAAnimationExportInfo> m_Data = new Dictionary<int, MFAAnimationExportInfo>();

}
