using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System;


[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))] 
[RequireComponent(typeof(MFALodMesh))] 
[AddComponentMenu("MeshFrameAnimation/MFAModelRender")]
public class MFAModelRender : MonoBehaviour {
    public string MeshPackName;//资源所在包 
    public string TexturePackName;//纹理所在包
    public bool IsLoop = true;//是否循环播放
    public Camera m_qkcamera = null;//摄像机
    public Color flagColor;//标志色
    public bool ignoreTimeScale = false;//是否忽略时间缩放
    public float speedScale = 1;//播放速度缩放
    public bool EnableLodTexture =false;//是否启用lod纹理
    /// <summary>
    /// 标记当前
    /// </summary>
    public int cardID;
    /// <summary>
    /// 持有集群的数据
    /// </summary>
    public ClusterData Cluster;
    /// <summary>
    /// 显示对象持有的id 通过这个id 可以实现和数据的关联
    /// </summary>
    public ObjectID ObjId;
    /*
    void LogOut(string msg)
    {   
        using (StreamWriter log = new StreamWriter("D:/u3ddbg.log", true))
        {

           // log.WriteLine("time:" + System.DateTime.Now.ToLongTimeString());
            log.WriteLine(msg);
            log.Close();
        }
    }*/

    void OnDestroy()
    {

        if (m_LodMaterial != null)
        {
            var len = m_LodMaterial.Length;
            for (int i = 0; i < len; i++) Material.Destroy(m_LodMaterial[i]);
        }
        m_LodMaterial = null;
    }

    Renderer m_render = null;

  
    public void SetClip(int hashClipName)
    {
        if (_HashClipName == hashClipName) return;
        _HashClipName = hashClipName;
        m_ClipChanged = true;
    }

    public void SetLostTime(float time)
    {
        m_LostTime = time;
    }
    
    void AddTime(float lostTime)
    {
        m_LostTime += lostTime * speedScale;
    }


    public void SetDir(bool isRight)
    {
        m_isRight = isRight;

        UpdateDir();
    }

    void UpdateDir()
    {
        if (m_isBoard)
            transform.rotation = m_qkcamera.transform.rotation;
        else
        {
           
            transform.rotation = m_isRight?Quaternion.Euler(0,90,0):Quaternion.Euler(0,-90,0);//  Quaternion.identity;
        }
    }

    public void SetAlpha(float v)
    {
        m_Color.a = v;

        if (m_render!=null)   
            m_render.material.color = m_Color;
    }  

    public void SetMat(Material mat)
    {
        //强制重新设置材质
        IsSetMateriald = false;
        m_CurrMeshLod = -1;

        //替换各lod等级的材质
        int len = m_LodMaterial.Length;
        for (int i = 0; i < len;i++ )  m_LodMaterial[i].shader = mat.shader; //替换shader

    }

    /// <summary>
    /// 设置shader参数
    /// </summary>
    public void SetShaderParam(string propertyName,float v)
    {
        //强制重新设置材质
        IsSetMateriald = false;
        m_CurrMeshLod = -1;

        //替换各lod等级的材质
        int len = m_LodMaterial.Length;
        for (int i = 0; i < len; i++) m_LodMaterial[i].SetFloat(propertyName, v);
    }

    /// <summary>
    /// 设置纹理
    /// </summary>
    /// <param name="lodLevel">0-n  近-远</param>
    /// <param name="textureName">新的纹理名</param>
    public void SetTexture(int lodLevel, string textureName)
    {
        //强制重新设置材质
        IsSetMateriald = false;
        m_CurrMeshLod = -1;

        var matIndex = EnableLodTexture ? lodLevel : 0;
        PacketRouting pack = PacketManage.Single.GetPacket(TexturePackName);
        m_LodMaterial[matIndex] =
            MFAModelManage.Single.GetMaterial(m_LodMaterial[matIndex].shader, pack.Load(textureName) as Texture);
    }


    /// <summary>
    /// lodLevel 0-n  近-远
    /// </summary>
    public void SetLodMesh(int lodLevel, string MeshName)
    {
        m_CurrMeshLod = -1;//lod等级变更，强制刷新
        m_SortLodMesh[lodLevel].MeshName = MeshName;//修改mesh名
    }

    public string GetLodMesh(int lodLevel)  {   return m_SortLodMesh[lodLevel].MeshName;  }

    public int LodCount { get { return m_SortLodMesh.Length; } }

    bool m_isRight = false;//是否朝向右边
    bool m_isBoard = false;

    MFALodMesh[] m_SortLodMesh; 
    MeshFilter m_MeshFilter;
    Material[] m_LodMaterial;//各lod的材质
    Color m_Color = Color.white;//材质颜色
    float m_LostTime = 0;

    int m_CurrMeshLod = -1;
    int m_CurrKeyFrame = -1; //当前帧
    int _HashClipName = InvalidHashClipName;
    const int InvalidHashClipName = ~((int)0); 
    bool m_ClipChanged = true;
    Dictionary<int, int> m_LoopClips = new Dictionary<int, int>();
    bool IsSetMateriald = false;
}
