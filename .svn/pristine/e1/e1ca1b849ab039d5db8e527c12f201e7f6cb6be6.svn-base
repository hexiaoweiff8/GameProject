using UnityEngine;
using System.Collections;

public class CMShowFPS : MonoBehaviour {

    /// <summary>
    /// 每次刷新计算的时间      帧/秒
    /// </summary>
    public float updateInterval = 0.5f;
    /// <summary>
    /// 最后间隔结束时间
    /// </summary>
    private double lastInterval;
    private int frames = 0;
    private float currFPS;


    // Use this for initialization
    void Start()
    {
        //Application.targetFrameRate = 300;
        lastInterval = Time.realtimeSinceStartup;
        frames = 0; 
    }

    void OnEnable() {
        CoroutineManage.AutoInstance();
        CoroutineManage.Single.RegComponentUpdate(IUpdate); 
    }

    // Update is called once per frame
    void IUpdate()
    {

        ++frames;
        float timeNow = Time.realtimeSinceStartup;
        if (timeNow > lastInterval + updateInterval)
        {
            currFPS = (float)(frames / (timeNow - lastInterval));
            frames = 0;
            lastInterval = timeNow;
        }
    }

    private void OnGUI()
    {
        GUI.backgroundColor = Color.black;
        GUI.color = Color.red;
        
        GUIStyle style = new GUIStyle();
        style.normal.background = null;    //这是设置背景填充的
        style.normal.textColor = Color.red;
        style.fontSize = 30;

        GUILayout.Label("FPS:" + currFPS.ToString("f2"), style);
    }

    void OnDestroy()
    {
        CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
    }
}
