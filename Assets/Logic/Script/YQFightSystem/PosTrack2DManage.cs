using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class PosTrack2D
{
    public Camera Camera2D;
    public Camera Camera3D;
    public GameObject Obj2D;
    public GameObject Obj3D;//追踪的游戏物体
    public Vector3 LateObj3DPos;
    public float YOffset3D = 0;//显示的Y偏移
}

class PosTrack2DManage  
{ 
    public void UpdatePos()
    {
        //立即合成相机变换，包含震动，偏移，主位置等
        YQ2CameraCtrl.Single.MixerTransform();

        foreach(var curr in TrackObjs)
        {
            if(
                curr.Camera2D == null ||
                curr.Camera3D==null||
                curr.Obj2D==null
                )
            {
                NeedRemove.Add(curr);
                continue;
            }
             
            if (curr.Obj3D != null)
            {
                curr.LateObj3DPos = curr.Obj3D.transform.position;
                curr.LateObj3DPos.y += curr.YOffset3D; 
            }

            Vector3 vPos = curr.Camera3D.WorldToScreenPoint(curr.LateObj3DPos);
            if (vPos.z > 0)//在屏幕内
            {
                vPos.z = 1f;
                curr.Obj2D.transform.position = curr.Camera2D.ScreenToWorldPoint(vPos);
            }
            else//在屏幕外 
                curr.Obj2D.transform.localPosition = TmpPos; //移动到一个很远的地方
        }

        if(NeedRemove.Count>0)
        {
            foreach (var curr in NeedRemove)
                TrackObjs.Remove(curr);
            NeedRemove.Clear();
        }
    }

    public void Add(PosTrack2D obj)
    {
        TrackObjs.Add(obj);
    }

    public void Remove(PosTrack2D obj)
    {
        TrackObjs.Remove(obj);
    }

    List<PosTrack2D> NeedRemove = new List<PosTrack2D>();
    HashSet<PosTrack2D> TrackObjs = new HashSet<PosTrack2D>();
    Vector3 TmpPos = new Vector3(99999, 99999, 0); 
} 