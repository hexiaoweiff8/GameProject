using System;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
//using HighlightingSystem;

public class CameraController : MonoBehaviour
{
    public static Camera MainSceneCamera;

    #region Private References      
    //[SerializeField, Range(0.0f, 1.0f)]
    //private float _lerpRate;
    [SerializeField, Range(0.0f, 5.0f)]
    private float _lerpTime = 0.25f;
    [SerializeField, Range(0.01f, 1.0f)]
    private float _moveSpeed = 0.17f;

    private float _xMovement;
    private float _yMovement;
    private float _xRotation;
    private float _yYRotation;

    //原摄像机位置,原旋转
    private Vector3 origCameraPosition;
    private Quaternion origCameraRotation;
    //当前状态枚举 
    private static UIState _uiState;
    public static CameraState _cameraState;
    //当前是否正在播放相机动画
    private static bool isPlayingAnime = false;
    //通过场景交互打开游戏UI时的标记
    private static bool isFacing2Obj = false;
    #endregion

    #region Public Enum
    /* 观察状态,控制相机从UI物体处移回free视角位置 */
    public enum UIState
    {
        Free,
        InSubMenu,
    }
    /* 相机当前状态,处于移动下不显示3d物体上的tips */
    public enum CameraState
    {
        isStatic,
        isMoving,
    }
    #endregion

    #region Private Methods
    private void Move(float xMovement, float yMovement)
    {
        if (_uiState == UIState.InSubMenu || isPlayingAnime)
            return;
        _xMovement += xMovement;
        _yMovement += yMovement;

        if (_xMovement > 10)
            _xMovement = 10;
        if (_xMovement < -10)
            _xMovement = -10;
    }
    private void Rotate(float xMovement, float yMovement)
    {
        if (_uiState == UIState.InSubMenu)
            return;
        _xRotation += xMovement;
        _yYRotation += yMovement;
    }

    /* 场景中可交互物体射线检测 */
    private void InteractiveCheck()
    {
        if (isPlayingAnime || isFacing2Obj)
            return;
        RaycastHit hit;
#if UNITY_EDITOR
        if (UICamera.hoveredObject &&
            UICamera.hoveredObject.GetComponent<Collider>() == null &&
            Physics.Raycast(MainSceneCamera.ScreenPointToRay(Input.mousePosition), out hit))
        {
            if (hit.collider.tag == "Clickable")
            {
                HandleOnRaycastHit(hit);
            }
        }
#endif
#if UNITY_ANDROID
        if (Input.touchCount > 0 &&
            !UICamera.Raycast(Input.GetTouch(0).position) &&
            Physics.Raycast(MainSceneCamera.ScreenPointToRay(Input.GetTouch(0).position), out hit))
        {
            if (hit.collider.tag == "Clickable")
            {
                HandleOnRaycastHit(hit);
            }
        }
#endif
    }

    /* 播放镜头拉近动画,打开UI界面 */
    private void HandleOnEnterUI(RaycastHit hit)
    {
        isPlayingAnime = true;
        origCameraRotation = transform.rotation;
        origCameraPosition = transform.position;
        transform.DOMove(hit.transform.Find("viewPoint").position, 0.5f)
            .OnComplete(() =>
            {
                isPlayingAnime = false;
                isFacing2Obj = true;
                //Tools.CallMethod("", "showWND",hit.transform.name);
                AppFacade.Instance.GetManager<LuaManager>().CallFunction("showWND", hit.transform.name);
            });
        //transform.DOLookAt(hit.transform.position - hit.transform.Find("viewPoint").position, 1f);
        transform.DORotateQuaternion(hit.transform.Find("viewPoint").rotation, 0.5f);
        //transform.DOLookAt(hit.transform.Find("viewPoint").forward, 1f);
        _uiState = UIState.InSubMenu;
    }

    /* 检测当前如果在UI处于显示状态,则关闭UI,还原摄像机位置 */
    private void HandleOnExitUI()
    {
        //从子菜单切换到自由视角
        if (_uiState == UIState.InSubMenu)
        {
            isPlayingAnime = true;
            transform.DOMove(origCameraPosition, 0.5f)
                .OnComplete(() =>
                {
                    isPlayingAnime = false;
                    isFacing2Obj = false;
                });
            transform.DORotateQuaternion(origCameraRotation, 0.5f);
            _uiState = UIState.Free;
        }
    }

    /* 响应鼠标移动/手指触摸屏幕事件 */
    private void HandleOnTouch()
    {
        if (_uiState == UIState.InSubMenu || isPlayingAnime)
            return;

        if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)
            if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
                InteractiveCheck();

        //水平轴值影响水平方向旋转
        //_xRotation = Mathf.Lerp(_xRotation, 0, _lerpRate);
        //_yYRotation = Mathf.Lerp(_yYRotation, 0, _lerpRate);
        //transform.eulerAngles += new Vector3(0, _xRotation, -_yYRotation);
        //transform.eulerAngles += new Vector3(0, _xRotation, 0);

        //水平轴值影响水平方向移动
        //_damp = transform.position.x * _dampScale;

        _xMovement = Mathf.Lerp(_xMovement, 0, Time.deltaTime / _lerpTime);

        transform.position += new Vector3(_xMovement * (_moveSpeed/* - _damp*/), 0, 0);
    }

    /* 鼠标移动/手指触摸时进行射线检测 */
    private void HandleOnRaycastHit(RaycastHit hit)
    {
        /* 如果点击可互动物体,显示UI界面 */
        if (Input.GetMouseButtonDown(0) && _uiState == UIState.Free)
        {
            HandleOnEnterUI(hit);
        }
        //var highlighter = hit.transform.GetComponent<Highlighter>();
        //if (highlighter == null)
        //    highlighter = hit.transform.gameObject.AddComponent<Highlighter>();
        //highlighter.On(Color.green);
    }

    /* 相机状态检查 */
    private void CameraStateCheck()
    {
        if (Input.GetMouseButton(0))
        {
            if (Input.GetAxisRaw("Mouse X") != 0 && _cameraState != CameraState.isMoving)
            {
                _cameraState = CameraState.isMoving;
                push_CameraToggle2Moving_Event();
            }
        }
        if (Input.GetMouseButtonUp(0))
        {
            if (_cameraState == CameraState.isMoving)
            {
                _cameraState = CameraState.isStatic;
                push_CameraToggle2Static_Event();
            } 
        }
    }
    #endregion

    #region Unity CallBacks
    void Start()
    {
        MainSceneCamera = GetComponent<Camera>();

        //InputManager.MouseMoved += Rotate;
        //InputManager.FingerMoved += Rotate;
#if UNITY_EDITOR
        InputManager.MouseMoved += Move;
#endif
#if UNITY_ANDROID
        InputManager.FingerMoved += Move;
#endif
        _uiState = UIState.Free;
        _cameraState = CameraState.isStatic;
    }
    void Update()
    {
        HandleOnTouch();
        InteractiveCheck();
#if UNITY_EDITOR
        //HandleOnExitUI();
#endif
        CameraStateCheck();
    }
    void OnDestroy()
    {
#if UNITY_EDITOR
        InputManager.MouseMoved -= Move;
#endif
#if UNITY_ANDROID
        InputManager.FingerMoved -= Move;
#endif

        HandleOnCameraToggle2Static.Clear();
        HandleOnCameraToggle2Static = null;
        HandleOnCameraToggle2Moving.Clear();
        HandleOnCameraToggle2Moving = null;
    }
#endregion

    #region CameraStateEvent

    private List<Action> HandleOnCameraToggle2Static = new List<Action>();
    private List<Action> HandleOnCameraToggle2Moving = new List<Action>();

    public void Add_OnCameraToggle2Static_EventListener(Action OnCameraToggle2Static)
    {
        if (!HandleOnCameraToggle2Static.Contains(OnCameraToggle2Static))
            HandleOnCameraToggle2Static.Add(OnCameraToggle2Static);
    }
    public void Add_OnCameraToggle2Moving_EventListener(Action OnCameraToggle2Moving)
    {
        if (!HandleOnCameraToggle2Moving.Contains(OnCameraToggle2Moving))
            HandleOnCameraToggle2Moving.Add(OnCameraToggle2Moving);
    }
    public void Remove_OnCameraToggle2Static_EventListener(Action OnCameraToggle2Static)
    {
        if (HandleOnCameraToggle2Static.Contains(OnCameraToggle2Static))
            HandleOnCameraToggle2Static.Remove(OnCameraToggle2Static);
    }
    public void Remove_OnCameraToggle2Moving_EventListener(Action OnCameraToggle2Moving)
    {
        if (HandleOnCameraToggle2Moving.Contains(OnCameraToggle2Moving))
            HandleOnCameraToggle2Moving.Remove(OnCameraToggle2Moving);
    }
    private void push_CameraToggle2Static_Event()
    {
        foreach (var func in HandleOnCameraToggle2Static)
            func();
    }
    private void push_CameraToggle2Moving_Event()
    {
        foreach (var func in HandleOnCameraToggle2Moving)
            func();
    }

#endregion

    #region UIEvent
    public void HandleOnWNDShowFinish(string wnd_base_id)
    {
        Debug.LogWarning("camera stop " + wnd_base_id);
        _uiState = UIState.InSubMenu;
    }
    public void HandleOnWNDHide(string wnd_base_id)
    {
        Debug.LogWarning("camera move " + wnd_base_id);
        //当前是通过场景交互打开的UI,退出时播放相机拉远动画
        if (isFacing2Obj)
        {
            HandleOnExitUI();
            return;
        }
        //当前是通过非场景交互方式打开的UI,则不需要播放动画
        _uiState = UIState.Free;
    }
#endregion
}