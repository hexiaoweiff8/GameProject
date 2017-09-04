using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ShadowProjector : MonoBehaviour
{
    private static ShadowProjector instence;
	public static ShadowProjector Instence
	{
	    get
	    {
	        if (instence == null)
	        {
	             instence = new ShadowProjector();
	        }
            return instence;
	    }
        //set { instence = value; }
	}
    


    private Projector _projector;
    //
    private Camera _lightCamera = null;
    private RenderTexture _shadowTex;
    //
    public Camera _mainCamera;
    public List<Renderer> _shadowCasterList = new List<Renderer>();
    //public List<BoxCollider> _boxCasterList = new List<BoxCollider>();
    private BoxCollider _boundsCollider;
    public float boundsOffset = 2;//边界偏移，
    public Shader shadowReplaceShader;

    void Awake()
    {
        instence = this;
        //shadowReplaceShader = Resources.Load<Shader>("Shader/ProjectorShader/ShadowReplace");
        //this.GetComponent<Projector>().material = Resources.Load<Material>("Shader/ProjectorShader/ShadowProjector");
        //Debug.Log("加载阴影替换ShadowReplace成功！！！！！！！");
    }

	void Start () 
    {
        _projector = GetComponent<Projector>();
        //_mainCamera = GameObject.Find("PTZCamera/SceneryCamera").GetComponent<Camera>();//GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        //
        if(_lightCamera == null)
        {
            _lightCamera = gameObject.AddComponent<Camera>();
            _lightCamera.orthographic = true;
            _lightCamera.cullingMask = LayerMask.GetMask("Scenery");
            _lightCamera.clearFlags = CameraClearFlags.SolidColor;
            _lightCamera.backgroundColor = new Color(0,0,0,0);
            _shadowTex = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB32);
            Debug.Log("屏幕长宽为:" + Screen.width + "*" + Screen.height);
            _shadowTex.filterMode = FilterMode.Bilinear;
            _lightCamera.targetTexture = _shadowTex;
            _lightCamera.SetReplacementShader(shadowReplaceShader, "RenderType");
            _projector.material.SetTexture("_ShadowTex", _shadowTex);

            _projector.ignoreLayers = LayerMask.GetMask("Default","TransparentFX","Ignore Raycast","Water","UI","Scenery","Avatar","Arrows","Effects","PhotoStudio","Quad","3DUI","QKPassUI");
        }
        Debug.Log("图层设置成功！！！！！！！！！！");

        _boundsCollider = new GameObject("Test use to show bounds").AddComponent<BoxCollider>();
	}

    void LateUpdate()
    {
        //求阴影产生物体的包围盒
        Bounds b = new Bounds();
        for (int i = 0; i < _shadowCasterList.Count; i++)
        {
            if (_shadowCasterList[i] != null)
            {
                b.Encapsulate(_shadowCasterList[i].bounds);
            }
        }
        b.extents += Vector3.one * boundsOffset;

//        Bounds bc = new Bounds();
//        for (int i = 0; i < _boxCasterList.Count; i++)
//        {
//            if (_boxCasterList[i] != null)
//            {
//                bc.Encapsulate(_boxCasterList[i].bounds);
//            }
//        }
//        bc.extents += Vector3.one * boundsOffset;
#if UNITY_EDITOR
        _boundsCollider.center = b.center;
        _boundsCollider.size = b.size;
#endif
        //根据mainCamera来更新lightCamera和projector的位置，和设置参数
        ShadowUtils.SetLightCamera(b, _lightCamera);
        _projector.aspectRatio = _lightCamera.aspect;
        _projector.orthographicSize = _lightCamera.orthographicSize;
        _projector.nearClipPlane = _lightCamera.nearClipPlane;
        _projector.farClipPlane = _lightCamera.farClipPlane;
        
	}


    public void AddShadowObj(Renderer render)
    {
        if (!_shadowCasterList.Contains(render))
        {
            _shadowCasterList.Add(render);
        }
    }
    public void DelShadowObj(Renderer render)
    {
        if (_shadowCasterList.Contains(render))
        {
            _shadowCasterList.Remove(render);
        }
    }



}
