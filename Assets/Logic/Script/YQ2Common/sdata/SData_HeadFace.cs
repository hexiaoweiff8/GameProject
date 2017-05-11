using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;


public enum PlayerFaceType
{
    Normal = 1,
    TimeFace = 3,
    HeroFace = 2,
}
public class SData_HeadFace
{
    public static SData_HeadFace Single
    {
        get
        {
            if (null == mSingle)
            {
                mSingle = new SData_HeadFace();
            }
            return mSingle;
        }
    }

    public List<int> NormalFace
    {
        get
        {
            return mNormalFace;
        }
    }

    public List<int> TimeFace
    {
        get { return mTimeFace; }
    }

    public List<int> HeroFaces
    {
        get
        {
            return mHeroFace;
        }
    }

    public void LoadFaces()
    {
        try
        {
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "NormalHead");
                short Iid = reader.ColumnName2Index("ID");
                short Istr = reader.ColumnName2Index("Type");
                short Iskin = reader.ColumnName2Index("Skin");

                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    int id = reader.GetI16(Iid, row);
                    int t = reader.GetI16(Istr, row);
                    string skin = reader.GetS(Iskin, row);

                    Fid2String.Add(id, skin);

                    switch (t)
                    {
                        case (int)PlayerFaceType.HeroFace:
                            if (!mHeroFace.Contains(id)) mHeroFace.Add(id);
                            break;
                        case (int)PlayerFaceType.Normal:
                            if (!mNormalFace.Contains(id)) mNormalFace.Add(id);
                            break;
                        case (int)PlayerFaceType.TimeFace:
                            if (!mTimeFace.Contains(id)) mTimeFace.Add(id);
                            break;
                    }
                }
            }
        }
        catch (System.Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "NormalHead初始化失败!");
            throw ex;
        }
    }

    int GetDefautNormalFace()
    {
        if (mNormalFace.Count == 0)
        {
            return 0;
        }

        int[] faceArray = mNormalFace.ToArray();

        if (faceArray.Length == 1)
        {
            return faceArray[0];
        }
        Random r = new Random(faceArray.Length - 1);
        return faceArray[r.Next()];
    }

    public uint GetIDbyS(string S)
    {
        foreach (KeyValuePair<int, string> item in Fid2String)
        {
            if (item.Value == S)
            {
                return (uint)item.Key;
            }
        }
        return (uint)0;
    }

    public bool ishasHead(int id)
    {
        if (Fid2String.ContainsKey(id))
            return true;
        else
            return false;

    }

    public SData_HeadFace()
    {
        LoadFaces();
    }
    readonly List<int> mHeroFace = new List<int>();
    readonly List<int> mNormalFace = new List<int>();
    readonly List<int> mTimeFace = new List<int>();
    readonly Dictionary<int, string> Fid2String = new Dictionary<int, string>();
    static SData_HeadFace mSingle = null;
}
