using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
 
class DesplayController_3DObj : I_DesplayController
{
    public DesplayController_3DObj(GameObject obj )
    {
        gameObject = obj;
        renders = gameObject.GetComponentsInChildren<Renderer>();
    }
    public void OnEnable() { }
    public void Update(float lostTime) { }

    public void OnKeyChanged(DP_Key newKey) { }

    public void SetAlpha(float v) {
        var len = renders.Length;
        for(int i=0;i<len;i++)
        {
            renders[i].material.color = new Color(v,v,v,v);//这里同时改了颜色，因为有可能有加色模式的效果
        }

        //ParticleSystem a;
        //a.shape.
    }

    public void SetBrightness(float v) { }

    public void Destroy() { }

    public void OnUISet3DPos(Vector3 pos3d) { }

    public float DirX { get { return 1; } }

    GameObject gameObject;
    Renderer[] renders;
} 