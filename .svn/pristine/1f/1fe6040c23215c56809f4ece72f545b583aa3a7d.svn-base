using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
 
class DesplayController_SquareFlag : I_DesplayController
{
    public DesplayController_SquareFlag(GameObject obj,SquareFlagResources res)
    {
        gameObject = obj;
        renders = gameObject.GetComponentsInChildren<Renderer>();
        //m_res = res;

        if (res.FlogColorIndex == 1)
            gameObject.transform.localRotation = Quaternion.Euler(0,180,0);
    }
    public void OnEnable() { }
    public void Update(float lostTime) { }

    public void OnKeyChanged(DP_Key newKey) { }

    public void SetAlpha(float v) {
        var len = renders.Length;
        for(int i=0;i<len;i++)
        {
            var color = renders[i].material.color;
            color.a = v;
            renders[i].material.color = color;
        }
    }

    public void SetBrightness(float v) { }

    public void Destroy() { }

    public void OnUISet3DPos(Vector3 pos3d) { }

    public float DirX { get { return 1; } }

    GameObject gameObject;
    Renderer[] renders;
    //SquareFlagResources m_res;
} 