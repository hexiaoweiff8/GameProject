using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(BoxScrollObject), true)]
public class BoxScrollObjectInspector : Editor
{
   
    void OnEnable()
    {
        model = target as BoxScrollObject;
    }

    
    
     void OnSceneGUI ()
    {

        if (!model.showHandles)  return;

        const float handleSize = 10f; 
        Camera camera = SceneView.lastActiveSceneView.camera;
        Vector3 center = model.ScrollViewPosition;
          

        Handles.color = model.GizmosCubeColor;

        if (m_EditorStae != EditorStae.CenterHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center, handleSize);
            if (Handles.Button(center, Quaternion.identity, hsize, hsize, Handles.SphereCap))
                m_EditorStae = EditorStae.CenterHandel;
        }

        if (m_EditorStae != EditorStae.MinHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center + model.Cube.min, handleSize);
            if (Handles.Button(center + model.Cube.min, Quaternion.identity, hsize, hsize, Handles.SphereCap))
               m_EditorStae = EditorStae.MinHandel;
        }

        if (m_EditorStae != EditorStae.MaxHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center + model.Cube.max, handleSize);
            if (Handles.Button(center + model.Cube.max, Quaternion.identity, hsize, hsize, Handles.SphereCap))
              m_EditorStae = EditorStae.MaxHandel;
        }

         switch(m_EditorStae)
         {
             case EditorStae.CenterHandel:
                 {
                     Vector3 newCenter = Handles.PositionHandle(center, Quaternion.identity);
                     if(newCenter!=center)
                     {
                         model.JumpTo(newCenter);
                     }
                 }
                 break;
             case EditorStae.MaxHandel:
                 {
                     Vector3 newMax = Handles.PositionHandle(center + model.Cube.max, Quaternion.identity);
                     if(newMax!=center + model.Cube.max)
                     {
                         Vector3 areamax = model.Owner.transform.position +  model.Owner.Area.max;
                         if (newMax.x > areamax.x) newMax.x = areamax.x;
                         if (newMax.y > areamax.y) newMax.y = areamax.y;
                         if (newMax.z > areamax.z) newMax.z = areamax.z;

                         Vector3 min = center + model.Cube.min;
                         float ex = (newMax.x - min.x) / 2;
                         float ey = (newMax.y - min.y) / 2;
                         float ez = (newMax.z - min.z) / 2;
                         if (ex < 0) ex = 0;
                         if (ey < 0) ey = 0;
                         if (ez < 0) ez = 0;

                         model.Cube = new Bounds(model.Cube.min + new Vector3(ex, ey, ez), new Vector3(ex, ey, ez) * 2);
                          
                     }
                 }
                 break;
             case EditorStae.MinHandel:
                 {
                     Vector3 newMin = Handles.PositionHandle(center + model.Cube.min, Quaternion.identity);
                     if (newMin != center + model.Cube.min)
                     {
                         Vector3 areamin = model.Owner.transform.position + model.Owner.Area.min;
                         if (newMin.x < areamin.x) newMin.x = areamin.x;
                         if (newMin.y < areamin.y) newMin.y = areamin.y;
                         if (newMin.z < areamin.z) newMin.z = areamin.z;


                         Vector3 max = center + model.Cube.max;
                         float ex = (max.x - newMin.x) / 2;
                         float ey = (max.y - newMin.y) / 2;
                         float ez = (max.z - newMin.z) / 2;
                         if (ex < 0) ex = 0;
                         if (ey < 0) ey = 0;
                         if (ez < 0) ez = 0;

                         model.Cube = new Bounds(model.Cube.max - new Vector3(ex, ey, ez), new Vector3(ex, ey, ez) * 2);

                     }
                 }
                 break;
         } 
    }
     

     enum EditorStae
     {
         CenterHandel,//正在操作中心点
         MinHandel,//最小点
         MaxHandel,//最大点
     }
     BoxScrollObject model;
     EditorStae m_EditorStae = EditorStae.CenterHandel;
}