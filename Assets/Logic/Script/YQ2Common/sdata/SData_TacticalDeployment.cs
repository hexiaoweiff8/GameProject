using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

/// <summary>
/// 阵法
/// </summary>
public class TacticalDeployment
{ 
    public Dictionary<byte, FightFormation>  formations = new Dictionary<byte,FightFormation>();    

    public void Serialize(Stream out_stream)
    {
        using (BinaryWriter sw = new BinaryWriter(out_stream))
        {
            sw.Write((byte)formations.Count);//阵数量
            foreach (KeyValuePair<byte, FightFormation> kv in formations)
            {
                FightFormation currFormation = kv.Value;

                sw.Write((byte)currFormation.id);//阵ID
                sw.Write(currFormation.QiZhiSBIndex);//抗旗帜士兵的索引位置
                sw.Write((short)currFormation.units.Length);//单位数量
                foreach (UnitsInfo currMassif in currFormation.units)
                {
                    sw.Write((byte)currMassif.x);//单位所在地块x
                    sw.Write((byte)currMassif.z);//单位所在地块z
                    sw.Write((byte)(currMassif.indent ? 1 : 0));//是否缩进
                    sw.Write((byte)(currMassif.isk ? 1 : 0));//是否关键单位
                } 
            }
            sw.Close();
        }
    }

     public void Deserialize(Stream in_stream)
    {
        //mBehindX = 255;
        mCount = 0;
        using (BinaryReader sr = new BinaryReader(in_stream))
        {
            byte fCount = sr.ReadByte();//阵数量
            formations.Clear();
            for(byte fi = 0;fi<fCount;fi++)
            {
                FightFormation nFormation = new FightFormation();
                nFormation.id = sr.ReadByte();//阵ID 
                nFormation.QiZhiSBIndex = sr.ReadInt16(); //抗旗帜士兵的索引位置
                short unitsCount = sr.ReadInt16();//单位数量
                nFormation.units = new UnitsInfo[unitsCount];
                for(int ui =0;ui<unitsCount;ui++)
                {
                    UnitsInfo units = new UnitsInfo();
                    units.x = sr.ReadByte();
                    units.z = sr.ReadByte();
                    units.indent = sr.ReadByte() == 1;
                    units.isk = sr.ReadByte() == 1;
                    nFormation.units[ui] = units;

                    /*
                    if (
                        units.x < mBehindX||
                        (units.x == mBehindX && units.z%2!=0)//奇数行优先
                        ) {
                        mBehindX = units.x; 
                        mBehindZ = units.z;
                    }*/
                    mCount++;
                }

                formations.Add(nFormation.id, nFormation);
            }
        }
    }

     public int Count { get { return mCount; } }
    // public byte BehindX { get { return mBehindX; } }
     //public byte BehindZ { get { return mBehindZ; } }
     
     int mCount;
    // byte mBehindX;
    // byte mBehindZ;
     
}

/// <summary>
/// 阵型
/// </summary>
public class FightFormation
{
    public byte id;
    public short QiZhiSBIndex = 0;//抗旗帜的士兵索引位置
    public UnitsInfo[] units;//单位地块坐标
}
 
public class UnitsInfo
{
    public byte x;
    public byte z;
    public bool indent;//是否缩进
    public bool isk;//是否关键单位
}
 

public class SData_TacticalDeployment : MonoEX.SingletonAuto<SData_TacticalDeployment>
{
    public const string ZhengFaDir = "ZhenFa";

    Dictionary<string, TacticalDeployment> m_Datas = new Dictionary<string, TacticalDeployment>();
}