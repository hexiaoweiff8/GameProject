using System;
using UnityEngine;
using System.Collections;
using Util;

public class TestTimer : MonoBehaviour
{

    public string log = "";

    private Timer timer;

	void Update () {
        if (Input.GetMouseButtonDown(1))
        {
            System.Diagnostics.Stopwatch stopwatch = new System.Diagnostics.Stopwatch();
            stopwatch.Start();
            timer = new Timer(0.5f, true);
            timer.Start().OnCompleteCallback(() =>
            {
                stopwatch.Stop();
                Debug.Log(stopwatch.Elapsed + ", " + timer.ToString());
                //timer.Kill();
            }).OnKill(() =>
            {
                Debug.Log("Kill");
            });


            // LooperImpl.Single.Remove(10000);
            //for(var i = 0; i < 1000; i++)
            //    key = LooperImpl.Single.Add(new LoopItemImpl()
            //    {
            //        DoAction = () => { double x = Math.Sqrt(100); },
            //        DoOnDestory = () => { Debug.Log("destory"); }
            //    });

        }
	    if (Input.GetKeyUp(KeyCode.Escape))
	    {
	        if (timer.IsPause)
	        {
	            timer.GoOn();
	        }
	        else
	        {
	            timer.Pause();
	        }
	    }
    }
}
