using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;


public class RangeXingzhuangInfo
{
    public const int maxlen = 11;
    public void Serialize(Stream out_stream)
    {
        using (BinaryWriter sw = new BinaryWriter(out_stream))
        {
            //写入形状数量
            sw.Write((byte)Shapes.Count); 

            foreach (var kv in Shapes)
            {
                var shapeID = kv.Key;
                //写入形状代号
                sw.Write((byte)kv.Key); 

                int dirStart, dirEnd;
                if (shapeID == XingzhuangEnum.Circular)//圆形
                { dirStart = dirEnd = (int)AIDirection.All; }
                else
                { dirStart = (int)AIDirection.Right - 1; dirEnd = (int)AIDirection.UpRight - 1; }

                int maxw = shapeID == XingzhuangEnum.Rect ? maxlen : 1;

                for(int h=0;h<2;h++)
                {
                    
                    for (var d = dirStart; d <= dirEnd; d++)
                    {
                        RangeShape rs = kv.Value[h, d];
                        for (int w = 0; w < maxw; w++)
                        {
                            for (int height = 0; height < maxlen; height++)
                            {
                                var grid = rs.Grids[w][height];
                                if (grid == null)
                                {
                                    sw.Write((short)0);//格子数量
                                }
                                else
                                {
                                    sw.Write((short)grid.Grids.Count);//格子数量
                                    foreach (var cg in grid.Grids)
                                    {
                                        sw.Write((short)cg.OffsetX);
                                        sw.Write((short)cg.OffsetZ);
                                        sw.Write((byte)cg.AngleOrder);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public void Deserialize(Stream in_stream)
    {
        Shapes.Clear();

        using (BinaryReader sr = new BinaryReader(in_stream))
        {
            //读入形状数量
            int shapeCount = sr.ReadByte();

            for (int s = 0; s < shapeCount; s++)
            {

                //读入形状代号
                XingzhuangEnum shapeID = (XingzhuangEnum)sr.ReadByte();

                int dirStart, dirEnd;
                if (shapeID == XingzhuangEnum.Circular)//圆形
                { dirStart = dirEnd = 0; }
                else
                { dirStart = 0; dirEnd = 1; }

                int maxw = shapeID == XingzhuangEnum.Rect ? maxlen : 1;

                var rsShapes = new RangeShape[2, shapeID == XingzhuangEnum.Circular ? 1 : 6];


                for (int h = 0; h < 2; h++)
                {
                    for (var d = dirStart; d <= dirEnd; d++)
                    {
                        var rs = rsShapes[h, d] = new RangeShape();
                        rs.Grids = new RangeGrids[maxw][];

                        for (int w = 0; w < maxw; w++)
                        {
                            rs.Grids[w] = new RangeGrids[maxlen];

                            for (int height = 0; height < maxlen; height++)
                            {
                                //读取格子数量
                                var gcount = sr.ReadInt16();
                                if (gcount > 0)
                                {
                                    var currGrids = rs.Grids[w][height] = new RangeGrids();
                                    for (int gi = 0; gi < gcount; gi++)
                                    {
                                        var ox = sr.ReadInt16();
                                        var oz = sr.ReadInt16();
                                        var ao = sr.ReadByte();

                                        currGrids.Grids.Add(new RangeGrid() { OffsetX = ox, OffsetZ = oz, AngleOrder = ao });
                                    }
                                }
                                else
                                {
                                    rs.Grids[w][height] = null;
                                }
                            }
                        }
                    }
                }

                Shapes.Add(shapeID, rsShapes);
            }
        }

        //镜像出其它朝向
        for (int shapeID = (int)XingzhuangEnum.Rect; shapeID <= (int)XingzhuangEnum.Sector; shapeID++)
        {
            var spInfos = Shapes[(XingzhuangEnum)shapeID];
            for (int L = 0; L < 2; L++)//单双行
            {
                var rightShape = spInfos[L, (int)AIDirection.Right - 1];//朝右的图形
                var rightUpShape = spInfos[L, (int)AIDirection.UpRight - 1];//朝右上的图形

                bool originIsDH = L == 0;

                RangeShape rightDownShape;
                //镜像产生右下图形
                {
                    rightDownShape = rightUpShape.Clone();
                    rightDownShape.ForeachGrid((g) => g.OffsetZ = (short)(-g.OffsetZ));
                    spInfos[L, (int)AIDirection.RightDown - 1] = rightDownShape;
                }

                //镜像产生左下图形
                {
                    RangeShape leftDownShape = rightDownShape.Clone();
                    leftDownShape.ForeachGrid((g) => HorizontalFlip(originIsDH, g));
                    spInfos[L, (int)AIDirection.DownLeft - 1] = leftDownShape;
                }

                //镜像产生左图形
                RangeShape leftShape;
                {
                    leftShape = rightShape.Clone();
                    leftShape.ForeachGrid((g) => HorizontalFlip(originIsDH, g));
                    spInfos[L, (int)AIDirection.Left - 1] = leftShape;
                }

                //镜像产生左上图形
                RangeShape leftupShape;
                {
                    leftupShape = rightUpShape.Clone();
                    leftupShape.ForeachGrid((g) => HorizontalFlip(originIsDH, g));
                    spInfos[L, (int)AIDirection.LeftUp - 1] = leftupShape;
                }

                //角顺序逆转
                rightDownShape.ReverseAngleOrder();
                leftShape.ReverseAngleOrder();
                leftupShape.ReverseAngleOrder();
            }
        }
    }

   


    /// <summary>
    /// 水平翻转图形
    /// </summary>
    /// <param name="originIsDH">原点是否在单行上</param>
    /// <param name="g"></param>
    void HorizontalFlip(bool originIsDH, RangeGrid g)
    {
        //原点格在单行上  z差值为单行的x=x-1
        //原点格在双行上  z差值为单行的x=x+1
        g.OffsetX = (short)(-g.OffsetX);
        if(Math.Abs(g.OffsetZ)%2==1)//z差值为单行
        {
            if (originIsDH)
                g.OffsetX--;
            else
                g.OffsetX++;
        }
    }
    //Dictionary<图形编号,RangeShape[单双行,朝向代号]  >   单行0，双行1
    public Dictionary<XingzhuangEnum, RangeShape[,]> Shapes = new Dictionary<XingzhuangEnum, RangeShape[,]>();
} 

public class SData_RangeXingzhuang:MonoEX.Singleton<SData_RangeXingzhuang>
{
#if !YQ2_SERVER
    public SData_RangeXingzhuang()
    {
        PacketRouting pk = PacketManage.Single.GetPacket("bsv");
        byte[] bytes = pk.LoadBytes( "RangeXingzhuang.bytes" ); 
        using (MemoryStream ms = new MemoryStream(bytes))
        {
            m_RangeXingzhuangInfo = new RangeXingzhuangInfo();
            m_RangeXingzhuangInfo.Deserialize(ms); 
        }
    }
#else
    public SData_RangeXingzhuang()
    {}
#endif

    public RangeShape Get(XingzhuangEnum shape, bool isDanHang, AIDirection dir)
    {
        var reshape = m_RangeXingzhuangInfo.Shapes[shape][isDanHang ? 0 : 1, shape == XingzhuangEnum.Circular ? 0: (int)(dir-1)];
         return reshape;
    }

    RangeXingzhuangInfo m_RangeXingzhuangInfo;
}

/// <summary>
/// 范围外观
/// </summary>
public class RangeShape
{
    //[宽,长]
    public RangeGrids[][] Grids;

    public RangeShape Clone()
    {
        RangeShape re = new RangeShape();
        int len = Grids.Length;
        re.Grids = new RangeGrids[len][];
        for(int i=0;i<len;i++)
        {
            var currGridA =Grids[i];

            int len2 = currGridA.Length;
            var gs = re.Grids[i] = new RangeGrids[len2];
            for(int i2=0;i2<len2;i2++)
            {
                var cv = currGridA[i2];
                gs[i2] = cv == null ? null : cv.Clone();
            }
        }
        return re;
    }

    /// <summary>
    /// 角顺序逆转
    /// </summary>
    /// <param name="shape"></param>
    public void ReverseAngleOrder( )
    {
        //统计最大编号
        short maxAngleOrder = 0;
        ForeachGrid((grid) => { if (grid.AngleOrder > maxAngleOrder) maxAngleOrder = grid.AngleOrder; });

        maxAngleOrder++;

        //进行逆转
        ForeachGrid((grid) => grid.AngleOrder = (byte)(maxAngleOrder - grid.AngleOrder));
    }

    public void ForeachGrid(Action<RangeGrid> callBack)
    {
        int len = Grids.Length;
        for (int i = 0; i < len; i++)
        {
            var currGridA = Grids[i];
            int len2 = currGridA.Length;
            for (int i2 = 0; i2 < len2; i2++)
            {
                if (currGridA[i2] != null)
                {
                    foreach (var c in currGridA[i2].Grids)
                        callBack(c);
                }
            }
        }
    }
}

public class RangeGrid
{
    public short OffsetX;
    public short OffsetZ;
    public byte AngleOrder;//角顺序
    public RangeGrid Clone()
    {
        RangeGrid re = new RangeGrid();
        re.OffsetX = OffsetX;
        re.OffsetZ = OffsetZ;
        re.AngleOrder = AngleOrder;
        return re;
    }
}

public class RangeGrids
{
    public List<RangeGrid> Grids = new List<RangeGrid>();
    public RangeGrids Clone()
    {
        RangeGrids re = new RangeGrids();
        foreach(var curr in Grids)
        {
            re.Grids.Add(curr.Clone());
        }
        return re;
    }
}