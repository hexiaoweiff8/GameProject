using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.IO;
using System.Collections; 
public class MFAClip
{
    public string clipName;//剪辑名
    public int[] KeyFrameIndexs;//序列帧索引
    public float frameDelay;//帧延迟
}

public class MFAFrames : IDisposable
{
    public Mesh[] KeyFrames;//序列帧
    public void Dispose()
    {
        if (KeyFrames == null) return;

        int len = KeyFrames.Length;
        for (int i = 0; i < len; i++)
            Mesh.Destroy(KeyFrames[i]);

        KeyFrames = null;

    }
}

public class MFAModel : IDisposable
{ 

    public int DefaultHashClipName { get { return m_DefaultHashClipName; } }

    public MFAClip GetClip(int hashName)
    {
        return m_ClipsIndexByHashName.ContainsKey(hashName) ? m_ClipsIndexByHashName[hashName] : null;
    }

    public Mesh GetFrame(int index)
    {
        return m_Frames.KeyFrames[index];
    }

    /// <summary>
    /// 顶点格式
    /// </summary>
    enum VertexFormat
    {
        Short = 1,//短整数表示的模型 -32.768 ~+ 32.767
        Float = 2//浮点数表示的模型
    }
     
    VertexFormat CheckVertexFormat()
    { 
        //遍历顶点，确定存储方案
        foreach (Mesh currKF in m_Frames.KeyFrames)
        {
            Vector3[] vertices = currKF.vertices;
            //帧顶点
            foreach (Vector3 pos in vertices)
            {
                if (
                    pos.x < -32.768f || pos.x > 32.767f ||
                    pos.y < -32.768f || pos.y > 32.767f ||
                    pos.z < -32.768f || pos.z > 32.767f
                    )
                  return VertexFormat.Float;
            }
        }
        return VertexFormat.Short;
    }
     
    /// <summary>
    /// 序列化
    /// </summary>
    /// <param name="stream"></param>
    public void Serialize(Stream out_stream)
    {
        if (m_Frames==null||m_Frames.KeyFrames.Length<1) return;

        using (BinaryWriter sw = new BinaryWriter(out_stream))
        {
            Mesh firstMesh = m_Frames.KeyFrames[0];

            //模型版本号
            sw.Write((byte)1);


            VertexFormat vf = CheckVertexFormat();
            sw.Write((byte)vf);//顶点格式

            Debug.Log(string.Format("导出模型，顶点格式{0}",vf== VertexFormat.Float?"浮点":"短整"));


            //顶点数量
            sw.Write(firstMesh.vertexCount);


            Vector2[] uvs = firstMesh.uv;

            //uv信息
            for (int i = 0; i < uvs.Length; i++)
            {
                Vector2 uv = uvs[i];
                sw.Write(uv.x);
                sw.Write(uv.y);
            }

            //子网
            int[]  triangles = firstMesh.triangles;
            {
                sw.Write(triangles.Length); //子网索引数量
                foreach (int index in triangles) sw.Write((ushort)index);  //子网索引信息
            }

            sw.Write(m_Frames.KeyFrames.Length); //帧数

            //帧信息
            if (vf == VertexFormat.Float)
            {
                foreach (Mesh currKF in m_Frames.KeyFrames)
                {
                    Vector3[] vertices = currKF.vertices;
                    //帧顶点
                    foreach (Vector3 pos in vertices)
                    {
                        sw.Write(pos.x);
                        sw.Write(pos.y);
                        sw.Write(pos.z);
                    }
                }
            }
            else
            {
                foreach (Mesh currKF in m_Frames.KeyFrames)
                {
                    Vector3[] vertices = currKF.vertices;
                    //帧顶点
                    foreach (Vector3 pos in vertices)
                    {
                        sw.Write((short)(pos.x * 1000f));
                        sw.Write((short)(pos.y * 1000f));
                        sw.Write((short)(pos.z * 1000f));
                    }
                }
            }

            //动画信息 
            sw.Write(m_ClipsIndexByName.Count); //动作数量
            foreach (KeyValuePair<string, MFAClip> clipkv in m_ClipsIndexByName)
            {
                MFAClip clip = clipkv.Value;

                sw.Write(clipkv.Key);//动作名字
                sw.Write(clip.frameDelay);//动作帧延迟
                sw.Write(clip.KeyFrameIndexs.Length);//动作帧数
                for (int i = 0; i < clip.KeyFrameIndexs.Length; i++) sw.Write(clip.KeyFrameIndexs[i]);//帧数组
            } 
            sw.Close();
        }

      
    } 
     
    public void Deserialize(
        //string name,
        Stream in_stream)
    {
        Clear();
        using (BinaryReader sr = new BinaryReader(in_stream))
        {
            //模型版本号
            byte version = sr.ReadByte();


            VertexFormat vf = (VertexFormat)sr.ReadByte();//顶点格式


            //顶点数量
            int vertexCount = sr.ReadInt32();

            Vector2[] UV = new Vector2[vertexCount];
            //uv信息
            for (int i = 0; i < vertexCount; i++)
            {
                Vector2 uv = new Vector2();
                uv.x = sr.ReadSingle();
                uv.y = sr.ReadSingle();
                UV[i] = uv;
            }

            //子网
            int[] trangles;
            { 
                {
                    int indexCount = sr.ReadInt32();//子网索引数量
                    trangles = new int[indexCount];
                    for (int j = 0; j < indexCount; j++)
                        trangles[j] = sr.ReadUInt16();  //子网索引信息
                }
            }

            //帧信息
            {
                m_Frames = new MFAFrames();
                int frameCount = sr.ReadInt32();//帧数
                m_Frames.KeyFrames = new Mesh[frameCount]; 
               
                for(int i=0;i<frameCount;i++)
                {
                    Mesh newKF = new Mesh(); 
                    
                    
                    //帧顶点
                    Vector3[] possitionArray = new Vector3[vertexCount];

                    if (vf == VertexFormat.Float)
                    {
                        for (int vi = 0; vi < vertexCount; vi++)
                        {
                            Vector3 v3 = new Vector3();
                            v3.x = sr.ReadSingle();
                            v3.y = sr.ReadSingle();
                            v3.z = sr.ReadSingle();
                            possitionArray[vi] = v3;
                        }
                    }
                    else
                    {
                        for (int vi = 0; vi < vertexCount; vi++)
                        {
                            Vector3 v3 = new Vector3();
                            v3.x = (float)sr.ReadInt16() / 1000f;
                            v3.y = (float)sr.ReadInt16() / 1000f;
                            v3.z = (float)sr.ReadInt16() / 1000f;
                            possitionArray[vi] = v3;
                        }
                    }


                    newKF.vertices = possitionArray;
                    newKF.uv = UV;
                    newKF.triangles = trangles;
                    newKF.RecalculateBounds();
                 

                    m_Frames.KeyFrames[i] = newKF; 
                }
            }

            //动画信息 
            int clipCount = sr.ReadInt32();//动作数量
            m_ClipsIndexByName.Clear();
            m_ClipsIndexByHashName.Clear();
            for (int i = 0; i < clipCount;i++ ) 
            {
                MFAClip nClip = new MFAClip();
                nClip.clipName = sr.ReadString();//动作名字
                nClip.frameDelay = sr.ReadSingle();//动作帧延迟

                int clipFrameCount = sr.ReadInt32();//动作帧数
                nClip.KeyFrameIndexs = new int[clipFrameCount];
                for (int j = 0; j < clipFrameCount; j++) nClip.KeyFrameIndexs[j] = sr.ReadInt32();//帧数组

                m_ClipsIndexByName.Add(nClip.clipName, nClip);
                m_ClipsIndexByHashName.Add(nClip.clipName.GetHashCode(), nClip);
            } 
             
            sr.Close();


            UpdateDefaultHashClipName();
        }

        //Name = name;
    }

    public void UpdateDefaultHashClipName()
    {
        if (m_ClipsIndexByHashName.Count > 0)
        {
            Dictionary<int, MFAClip>.Enumerator it = m_ClipsIndexByHashName.GetEnumerator();
            it.MoveNext();
            m_DefaultHashClipName = it.Current.Key;
        }
        else
            m_DefaultHashClipName = -1;
    }

    public void Dispose()
    {
        Clear();
    }

    public void Clear()
    {
        if (m_Frames != null) { m_Frames.Dispose(); m_Frames = null; }
        m_ClipsIndexByName.Clear();
        m_ClipsIndexByHashName.Clear();
        m_DefaultHashClipName = -1;
    }

    public  Dictionary<string, MFAClip> m_ClipsIndexByName = new Dictionary<string,MFAClip>();
    public Dictionary<int, MFAClip> m_ClipsIndexByHashName = new Dictionary<int, MFAClip>();
    public MFAFrames m_Frames;
   // public string Name;

    int m_DefaultHashClipName = -1;
}