using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

/*
public  static class HandlesExtension
{
    public static void WordCount(this  Handles self)
    {
    }
} 
*/

public static class HandlesExtension
{
    public static float CalculateButtonRadius(Vector3 pos3d, float screenRadius)
    {
        Camera camera = SceneView.currentDrawingSceneView.camera;
        Ray centerRay = camera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));
        Plane pl = new Plane(centerRay.direction, pos3d);//构建一个包含pos3d且平行于相机剪裁面的平面
        Vector3 pos2D = camera.WorldToScreenPoint(pos3d);
        pos2D.z = 0;
        pos2D.x += screenRadius;
        Ray ray2 = camera.ScreenPointToRay(pos2D);
        float enter; if (!pl.Raycast(ray2, out enter)) return 0f;
        return Vector3.Distance(ray2.GetPoint(enter), pos3d);
    }

    public static void DrawWireCube(Vector3 center, Vector3 size)
    {
        Vector3 harfSize = size / 2;

        Vector3 blt = center - harfSize;
        Vector3 frb = center + harfSize;
        Vector3 brt = new Vector3(frb.x, blt.y, blt.z);
        Vector3 brb = new Vector3(frb.x, frb.y, blt.z);
        Vector3 blb = new Vector3(blt.x, frb.y, blt.z);
        Vector3 flt = new Vector3(blt.x, blt.y, frb.z);
        Vector3 frt = new Vector3(frb.x, blt.y, frb.z);
        Vector3 flb = new Vector3(blt.x, frb.y, frb.z);

        UnityEditor.Handles.DrawLines(
            new Vector3[] { 
                blt,brt,
                brt,brb,
                brb,blb,
                blb,blt,

                flt,frt,
                frt,frb,
                frb,flb,
                flb,flt,

                flt,blt,
                frt,brt,
                frb,brb,
                flb,blb,
            }
            );

    }
}