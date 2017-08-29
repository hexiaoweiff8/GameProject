using UnityEngine;
using System.Collections;

public class ShadowObj : MonoBehaviour
{
    public bool isrender = false;
    private float lastTime=0;
    private float curtTime=0;
    private Renderer render;

    void Start()
    {
        if (gameObject.GetComponent<Renderer>() == null)
        {
            this.enabled = false;
        }
        else
        {

            render = gameObject.GetComponent<Renderer>();
        }
    }

    void Update()
    {
        isrender = curtTime != lastTime ? true : false;
        if (isrender)
        {
            ShadowProjector.Instence.AddShadowObj(render);
        }
        else
        {
            ShadowProjector.Instence.DelShadowObj(render);
        }
        lastTime = curtTime;
    }


    void OnWillRenderObject()
    {
        if (Camera.current.name == "SceneryCamera")
        {
            //Debug.Log("对象进入渲染相机");
            curtTime = Time.time;
        }
        
    }

    void OnDisable()
    {
        ShadowProjector.Instence.DelShadowObj(render);

    }
    public static void ObjAddShadow(Transform tran)
    {
        for (int i = 0; i < tran.childCount; i++)
        {
            tran.GetChild(i).gameObject.AddComponent<ShadowObj>();
        }
    }
}
