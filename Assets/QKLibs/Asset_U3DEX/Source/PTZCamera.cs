using JetBrains.Annotations;
using UnityEngine;
using System.Collections;

#if UNITY_EDITOR
using UnityEditor;
#endif

[ExecuteInEditMode]
[AddComponentMenu("QK/PTZCamera")]
public class PTZCamera : MonoBehaviour
{
    private static PTZCamera instence;
    public PTZCamera Instence
    {
        get
        {
            
            if (instence == null)
            {
                instence = GameObject.Find("PTZCamera").GetComponent<PTZCamera>();
                if (instence == null)
                {
                    Debug.LogError("PTZCamera 为空！！");
                }
            }
            return instence;
        }
        
    }

    void Awake()
    {
        instence = this;
        m_Cameras = GetComponentsInChildren<Camera>();
        UpdateAll();
    }

    public float Field
    {
        get { return m_Field; }
        set { 
            m_Field = value;
            UpdateField();
        }
    }

    public float NearClipPlane
    {
        get { return m_NearClipPlane; }
        set {
            m_NearClipPlane = value;
            UpdateNearClipPlane();
        }
    }
    public float FarClipPlane
    {
        get { return m_FarClipPlane; }
        set
        {
            m_FarClipPlane = value;
            UpdateFarClipPlane();
        }
    }
    void UpdateNearClipPlane()
    {
        int len = m_Cameras.Length;
        for (int i = 0; i < len; i++)
        {
            m_Cameras[i].nearClipPlane = m_NearClipPlane;
        }
    }
    void UpdateFarClipPlane()
    {
        int len = m_Cameras.Length;
        for (int i = 0; i < len; i++)
        {
            m_Cameras[i].farClipPlane = m_FarClipPlane;
        }
    }

    void UpdateField()
    {
        int len = m_Cameras.Length;
        for(int i=0;i<len;i++)
        {
            m_Cameras[i].fieldOfView = m_Field;
        }
    }

    void UpdateAll()
    {
        UpdateField();
        UpdateFarClipPlane();
        UpdateNearClipPlane();
    }

//#if UNITY_EDITOR
    void Update()
    {
        m_findNewCameraTime += Time.deltaTime;
        if (m_findNewCameraTime < 0.5f) return;
        m_findNewCameraTime = 0;

        //搜寻新增相机
        Camera[] cameras = GetComponentsInChildren<Camera>();
        if(CameraChanged(cameras))
        {
            m_Cameras = cameras;
            UpdateAll();
        }
    }

    bool CameraChanged(Camera[] cameras)
    {
        if (cameras.Length != m_Cameras.Length) return true;//数量不同，肯定变化了

        foreach (Camera c1 in cameras)
        {
            bool isFind = false;
            foreach (Camera c2 in m_Cameras)
            {
                if (c1 == c2) { isFind = true; break; }
            }
            if (!isFind) return true;//这是一个新增相机
        }
        return false;
    }

    float m_findNewCameraTime = 0;
//#endif

    [SerializeField]
    [HideInInspector]
    float m_Field = 60f;

     [SerializeField]
    [HideInInspector]
    float m_NearClipPlane = 0.2f;

     [SerializeField]
     [HideInInspector]
     float m_FarClipPlane = 10000f;

    Camera[] m_Cameras;

    public static void HideShadowCamera()
    {
        //foreach (var ca in instence.m_Cameras)
        //{
        //    if (ca.gameObject.name == "ShadowCamera")
        //    {
        //        ca.gameObject.SetActive(false);
        //        return;
        //    }
        //}
       
        if (instence.transform.FindChild("ShadowCamera").gameObject != null)
        {
            instence.transform.FindChild("ShadowCamera").gameObject.SetActive(false) ;
        }
        

    }

    public static void ShowShadowCamera()
    {
        //foreach (var ca in instence.m_Cameras)
        //{
        //    if (ca.gameObject.name == "ShadowCamera")
        //    {
        //        ca.gameObject.SetActive(true);
        //        return;
        //    }
        //}
        if (instence.transform.FindChild("ShadowCamera").gameObject != null)
        {
            instence.transform.FindChild("ShadowCamera").gameObject.SetActive(true) ;
        }
    }

}
