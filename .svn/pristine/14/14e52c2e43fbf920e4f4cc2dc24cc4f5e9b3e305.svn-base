using UnityEngine;
using System.Collections;
/// <summary>
/// 主场景单兵巡逻逻辑
/// </summary>
public class SinglePatrol : MonoBehaviour {
    private float _startTime;
    /// <summary>
    /// 出场等待时间
    /// </summary>
    private float _waitTime;
    /// <summary>
    /// 单兵一次巡逻总行军时间
    /// </summary>
    private float _runTime;
	// Use this for initialization
	void Start () {
        _startTime = Time.realtimeSinceStartup;
    }

    public void SetWaitTime(float time)
    {
        _waitTime = time;
    }
    /// <summary>
    /// 设置总行军时间
    /// </summary>
    /// <param name="runtime"></param>
    public void SetRunTime(float runtime)
    {
        _runTime = runtime;
    }
	
	// Update is called once per frame
	void Update () {
        var curr = Time.realtimeSinceStartup;
        if (curr - _startTime <= _waitTime) return;
        //在此处实现演员位置移动和转向的逻辑
        //gameObject.transform.localPosition = new Vector3(300, 0, 300);

	}
    /// <summary>
    /// 行军结束后重置到起始位置
    /// </summary>
    private void resPos()
    {
        gameObject.transform.localPosition = Vector3.zero;
        _startTime = Time.realtimeSinceStartup;
    }
}
