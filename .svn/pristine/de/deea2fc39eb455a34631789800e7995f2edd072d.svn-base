using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class YQ2PhotoStudio:MonoBehaviour
{
    public GameObject actor;//演员
    //public GameObject lastActor;//已经被设置了层的演员
    public Vector3 offset;//偏移量
   // public Vector3 roomRotation;//照相馆的旋转
    public Vector3 cameraRotation;//相机的旋转
    public float Distance;//距离  
    //List<int> actorsLayer = new List<int>();//备份的演员原所属层

    RenderTexture _TargetTexture= null;
    public RenderTexture TargetTexture
    {
        get { return _TargetTexture; }
    }

   const int PhotoStudioLayer = 13;
    void OnEnable()
    {
        _TargetTexture = GetComponent<Camera>().targetTexture = new RenderTexture(512, 512, 24, RenderTextureFormat.ARGB32);
        wnd_fight.Single.CMAvatarTexture.mainTexture = TargetTexture;
    } 

    /*
    void OnPostRender()
    //void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (actors.Count == 0) return;

        //恢复游戏物体原所属层 
        var it = actorsLayer.GetEnumerator();
        foreach (var curr in actors)
        {
            it.MoveNext();
            curr.layer = it.Current;
        } 
    }*/

    /*
   //void OnPreRender()
    void OnPreCull()
    {
        if (actors.Count == 0) return;

        //移动摄像机位置
        { 
            var dir = Vector3.Normalize(transform.rotation * Vector3.forward);
            var pos = origin + (-dir  * Distance);

            transform.position = pos; 
        }

        //记录游戏物体原所属层，并设置层
        actorsLayer.Clear();
        foreach (var curr in actors)
        {
            actorsLayer.Add(curr.layer);
            curr.layer = PhotoStudioLayer;
        }
    }*/
    public void Update()
    {
        SetDirty();
    }

    public void SetDirty()
    {
        if (actor == null) return;


        //移动摄像机位置
        {

            var tmpRoomRotation = actor.transform.eulerAngles;
            tmpRoomRotation.y -= 90;
            if (tmpRoomRotation.y < 0) tmpRoomRotation.y = 360 + tmpRoomRotation.y;

            transform.rotation = Quaternion.Euler(tmpRoomRotation) * Quaternion.Euler(cameraRotation);

            var dir = Vector3.Normalize(transform.rotation * Vector3.forward);
            var pos = actor.transform.position + offset + (-dir * Distance);

            transform.position = pos;
            
        }

        //记录游戏物体原所属层，并设置层 
        actor.layer = PhotoStudioLayer; 
    }
}