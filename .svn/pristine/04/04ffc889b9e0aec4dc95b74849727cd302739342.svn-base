using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using MonoEX;
using Debug = UnityEngine.Debug;

/// <summary>
/// 测试相机操作
/// </summary>
public class TestCameraTrans : MonoBehaviour
{

	void Start () {
	    // 初始化相机并设置协程
	    //DP_CameraTrackObjectManage.Single.LookAround(() => { });
//        var targerObj = GameObject.Find("followAndAroundTarget");
//        // 初始化相机并设置协程
//        DP_CameraTrackObjectManage.Single.LookFollowAround(targerObj.transform, () =>
//        {
//            Debug.Log("Execute End");
//        });
        // 获取camera 赋给ItemSelecter

        var camera = GameObject.Find("PTZCamera");
	    var followObj = GameObject.Find("CavalryHero_RH(Clone)");
	    //ItemSelecter.Single.camera = camera;
	    var TargetList = new List<MoveTarget>();
	    var cameraTarget1 = new MoveAndRotateTarget();
	    cameraTarget1.MoveSpeed = 10;
	    cameraTarget1.MoveTime = 10;
        cameraTarget1.MoveDirection = new Vector3(0,0,1);
	    cameraTarget1.RotateTime = 5;
        cameraTarget1.RotateTarget = new Vector3(-20, 0, 0);
        TargetList.Add(cameraTarget1);
        cameraTarget1 = new MoveAndRotateTarget();
        cameraTarget1.MoveSpeed = 5;
        cameraTarget1.MoveTime = 5;
        cameraTarget1.MoveDirection = new Vector3(0, 1, 0);
        cameraTarget1.RotateTime = 5;
        cameraTarget1.RotateTarget = new Vector3(0, 180, 0);
        TargetList.Add(cameraTarget1);
	    var followAround = new FollowAndAroundTarget();
	    followAround.StartAngle = 0;
	    followAround.EndAngle = 360;
	    followAround.RotateSpeed = 2f;
	    followAround.Radius = 100;
	    followAround.YOffset = 10;
	    followAround.TargetObj = followObj;
        TargetList.Add(followAround);
	    var follow = new FollowTarget();
	    follow.TargetObj = followObj;
	    follow.FollowTime = 10f;
        follow.Direction = new Vector3(0, 30, 0);
        follow.RelativePos = new Vector3(0, 20, -40);
        TargetList.Add(follow);
        Utils.Single.MoveAndRotateObj(TargetList, camera.gameObject, Application.targetFrameRate, () => { Debug.Log("Move End"); });

	    var forward = true;
	    var startPosX = followObj.transform.localPosition.x;
        // 让对象移动
	    MonoEX.TimerCallback tick = null;
	    tick = () =>
	    {
            followObj.transform.localPosition += new Vector3(forward ? 1 : -1, 0, 0);
            if (followObj.transform.localPosition.x > startPosX + 2000)
            {
                forward = false;
            }

	        if (followObj.transform.localPosition.x < startPosX)
	        {
	            forward = true;
	        }

            new Timer(0.01f).Play().OnComplete(tick);
            
	    };
	    new Timer(0.01f).Play().OnComplete(tick);
	}

	void Update () {

	}
}