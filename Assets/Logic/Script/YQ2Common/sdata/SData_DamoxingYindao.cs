using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

public class  DamoxingYindaoInfo
{
    //半径，单双行，引导编号
    public class Offset
    {
        public short offsetX;
        public short offsetZ;
    }

    public Offset[] GetMoveGuideOffset(int r, int danShuang, int ydCode)
    {
        return Data[r+1][danShuang][ydCode];
    }

    public void Serialize(Stream out_stream)
    {
        using (BinaryWriter sw = new BinaryWriter(out_stream))
        {
            //格式版本号
            sw.Write((byte)1); 

            //半径总数
            sw.Write((byte)Data.Length); 

            for(int i=0;i<Data.Length;i++)
            {
                var Datai=Data[i];
                sw.Write((byte)Datai.Length); 
                for(int j=0;j<Datai.Length;j++)
                {
                    var Dataij = Datai[j];
                    sw.Write((byte)Dataij.Length);
                    for(int k=0;k<Dataij.Length;k++)
                    {
                        var Dataijk = Dataij[k];
                        sw.Write((byte)Dataijk.Length);
                          for(int l=0;l<Dataijk.Length;l++)
                          {
                              var Dataijkl = Dataijk[l];
                              sw.Write((short)Dataijkl.offsetX);
                              sw.Write((short)Dataijkl.offsetZ);
                          }
                    }
                }
            }
        }
    }

    public Offset[] GetBody(int r, int danShuang)
    {
        return Body[r][danShuang];
    }



    public void Deserialize(Stream in_stream)
    {
        using (BinaryReader sr = new BinaryReader(in_stream))
        {
            //版本号
            byte version = sr.ReadByte();

            //半径总数
            byte bj = sr.ReadByte();
            Data = new Offset[bj][][][];

            for (int i = 0; i < Data.Length; i++)
            {
                var ilen = sr.ReadByte();
                var Datai = Data[i]= new Offset[ilen][][]; 
                for (int j = 0; j < Datai.Length; j++)
                {
                    var jlen = sr.ReadByte();
                    var Dataij = Datai[j] = new Offset[jlen][]; 
                    for (int k = 0; k < Dataij.Length; k++)
                    {
                        var klen = sr.ReadByte(); 
                        var Dataijk = Dataij[k] = new Offset[klen];
                        
                        for (int l = 0; l < Dataijk.Length; l++)
                        {
                            var Dataijkl = Dataijk[l] = new Offset();
                            Dataijkl.offsetX = sr.ReadInt16();
                            Dataijkl.offsetZ = sr.ReadInt16();
                        }
                    }
                }
            }

            Body = new Offset[Data.Length][][];
            for (int i = 0; i < Body.Length; i++)//半径
            {
                var Datai = Data[i];
                var Bodyi = Body[i] = new Offset[Datai.Length][];
                for (int j = 0; j < Datai.Length; j++)//单双行
                {
                    var Dataij = Datai[j];
                    Dictionary<short,HashSet< short>> offsetList = new Dictionary<short, HashSet< short>>();
                     for (int k = 0; k < Dataij.Length; k++)
                     {
                         var Dataijk = Dataij[k];
                         for (int l = 0; l < Dataijk.Length; l++)
                         {
                             var offset = Dataijk[l];
                             if (!offsetList.ContainsKey(offset.offsetX))
                                 offsetList.Add(offset.offsetX, new HashSet<short>());
                              
                             offsetList[offset.offsetX].Add(offset.offsetZ);
                         }
                     }

                     List<Offset> tmpList = new List<Offset>();
                    foreach(var curr in offsetList)
                    {
                        var offsetx = curr.Key;
                        foreach(var offsetz in curr.Value)
                        {
                            tmpList.Add(new Offset() { offsetX = offsetx , offsetZ=offsetz});
                        }
                    }
                    Bodyi[j] = tmpList.ToArray();
                }
            }
        }
    }
    public Offset[][][][] Data;//Offset[半径][单双行][引导编号][]
    public Offset[][][] Body;//Offset[半径][单双行][]
}

public class SData_DamoxingYindao : MonoEX.Singleton<SData_DamoxingYindao>
{
    public SData_DamoxingYindao()
    {
        PacketRouting pk = PacketManage.Single.GetPacket("bsv");
        byte[] bytes = pk.LoadBytes("DamoxingYindao.bytes"); 
        using (MemoryStream ms = new MemoryStream(bytes))
        {
            m_DamoxingYindaoInfo = new DamoxingYindaoInfo();
            m_DamoxingYindaoInfo.Deserialize(ms); 
        }
    }
    public DamoxingYindaoInfo.Offset[] GetMoveGuideOffset(int r, int danShuang, int ydCode)
    {
        return m_DamoxingYindaoInfo.GetMoveGuideOffset(r, danShuang, ydCode);
    }

     public DamoxingYindaoInfo.Offset[] GetBody(int r, int danShuang)
    {
        return m_DamoxingYindaoInfo.GetBody(r, danShuang);
    }

    DamoxingYindaoInfo m_DamoxingYindaoInfo;
} 
