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

    void Start()
    {
        MFALodMesh[] lodMeshs = GetComponents<MFALodMesh>();

        //根据lod从小到大排序
        for (int i = 0; i < lodMeshs.Length - 1; i++)
        {
            int index = i;
            for (int i2 = i + 1; i2 < lodMeshs.Length; i2++)
            {
                if (lodMeshs[i2].Lod < lodMeshs[index].Lod) index = i2;
            }
            if (index != i)
            {
                MFALodMesh z = lodMeshs[index];
                lodMeshs[index] = lodMeshs[i];
                lodMeshs[i] = z;
            }
        }



        m_SortLodMesh = lodMeshs;


        m_render = GetComponent<Renderer>();
        Shader shader = m_render.material.shader;


        var matLodCount = EnableLodTexture ? m_SortLodMesh.Length : 1;
        m_LodMaterial = new Material[matLodCount];


        //装载各lod版本的Mesh
        for(int i=0;i<m_SortLodMesh.Length;i++)
        {
            MFAModelManage.Single.GetModel(MeshPackName, m_SortLodMesh[i].MeshName);
        }

        PacketRouting pack = PacketManage.Single.GetPacket(TexturePackName);
        for (int i = 0; i < matLodCount; i++)
        {
            try
            {
                m_LodMaterial[i] = MFAModelManage.Single.GetMaterial(shader, pack.Load(m_SortLodMesh[i].TextureName) as Texture);
            }
            catch (Exception)
            {
                Debug.LogError(string.Format("pack:{0} tName:{1}", this.TexturePackName, m_SortLodMesh[i].TextureName));
            }
        }
        var loopClips = GetComponents<MFAModelLoopClip>();
        foreach (var kv in loopClips)
            if (!m_LoopClips.ContainsKey(kv.BeforeClipName.GetHashCode()))
                m_LoopClips.Add(kv.BeforeClipName.GetHashCode(), kv.LoopClipName.GetHashCode());

        m_MeshFilter = GetComponent<MeshFilter>();
    }

    

    Renderer m_render = null;
    /// <summary>
    /// 根据距离获取最适合显示的mesh
    /// </summary>
    /// <param name="distance"></param>
    /// <returns></returns>
    int GetMesh(float distance)
    {
        int len = m_SortLodMesh.Length;
        MFALodMesh remesh = null;
        for (int i = 0; i < len; i++)
        {
            remesh = m_SortLodMesh[i];
            if (distance <= remesh.Lod)
                return i;
        }
        return len - 1;
    }

  
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

    //void Awake ()   { }

    void OnEnable() { 
        CoroutineManage.Single.RegComponentUpdate(IUpdate); 
    }
    void OnDisable() { CoroutineManage.Single.RegComponentUpdate(IUpdate); }

    void IUpdate()
    {
        //bool isRendering = m_renderCount != m_lastCount ? true : false;
        //m_lastCount = m_renderCount;
         
        
        if (
            //!isRendering
            m_render == null||
            !m_render.isVisible
            )
        {
            //RenderStatistics.Single.SetST(gameObject,  0);
            return;
        }


        AddTime(ignoreTimeScale ? Time.unscaledDeltaTime : Time.deltaTime);
        Refresh();
    }

    //void OnWillRenderObject() { m_renderCount++; }
    

    void Refresh()
    {
        float distance = Vector3.Distance(m_qkcamera.gameObject.transform.position, transform.position); 

        RefreshMesh(distance); 
    }

    void RefreshMesh(float distance)
    { 
        int meshLod = GetMesh(distance);
        MFALodMesh mesh = m_SortLodMesh[meshLod];

        MFAModel model = MFAModelManage.Single.GetModel(MeshPackName, mesh.MeshName);
        if (model == null) return;


        if (_HashClipName == InvalidHashClipName)
        {
            _HashClipName = model.DefaultHashClipName; 
        }

        //计算当前帧
        int currFrame = 0;
        MFAClip clip = null;
        try
        {
            clip = model.GetClip(_HashClipName); 
            currFrame = (int)(m_LostTime / clip.frameDelay);
        }
        catch (Exception)
        {
            Debug.LogError(string.Format("clip null!  pack:{0} clipHash:{1} meshName:{2}", this.MeshPackName, _HashClipName, mesh.MeshName));
            Debug.LogError("wait2:" + ("wait2".GetHashCode()) );
            Debug.LogError("wait:" + ("wait".GetHashCode()));
            Debug.LogError("attack3:" + ("attack3".GetHashCode()));
            Debug.LogError("attack2:" + ("attack2".GetHashCode()));
            Debug.LogError("attack:" + ("attack".GetHashCode()));
            Debug.LogError("run:" + ("run".GetHashCode()));
            Debug.LogError("yinchang:" + ("yinchang".GetHashCode())); 
        }
       

        int frameLen = clip.KeyFrameIndexs.Length;

        bool isPlyEnd = false;

        if (currFrame >= frameLen-1)
        {
            if (IsLoop)
                currFrame %= frameLen;
            else
            {
                currFrame = frameLen - 1;
                isPlyEnd =true;
            }
        }
        else if (currFrame < 0)
        {
            if (IsLoop)
            {
                currFrame = Mathf.Abs(currFrame) % frameLen;
                currFrame = frameLen - currFrame;
            }
            else
            { 
                currFrame =  frameLen - 1;
                isPlyEnd =true;
            }
        }
      if (m_CurrKeyFrame == currFrame && !m_ClipChanged && m_CurrMeshLod == meshLod) 
            return;//没有发生改变
   

        m_ClipChanged = false;
        m_CurrKeyFrame = currFrame;

        Mesh keyFrame = model.GetFrame(clip.KeyFrameIndexs[m_CurrKeyFrame]);//取得关键帧

        if (m_CurrMeshLod != meshLod)
        {
            MFALodMesh ldms = m_SortLodMesh[meshLod];
            
             
            //更换 纹理 
            if (EnableLodTexture || !IsSetMateriald)
            {
                IsSetMateriald = true;
                m_render.material = m_LodMaterial[EnableLodTexture ? meshLod : 0];
                m_render.material.color = m_Color;
            }

            if (
                //m_CurrMeshLod < 0 || 
                ldms.isBoard != m_isBoard
                )
                //m_SortLodMesh[m_CurrMeshLod].isBoard)
            {
                m_isBoard = ldms.isBoard;
                UpdateDir();
                
            }

            //设置当前lod
            m_CurrMeshLod = meshLod;

        }
        //RenderStatistics.Single.SetST(gameObject, m_SortLodMesh[m_CurrMeshLod].Lod);

        m_MeshFilter.sharedMesh = keyFrame;

        //非循环动画播放完的时候播放设定好的循环动画
        if(isPlyEnd&&m_LoopClips.ContainsKey(_HashClipName)) 
        { 
            SetClip(m_LoopClips[_HashClipName] );
            SetLostTime(0);
            speedScale = 1;
            IsLoop = true;
        }
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
