using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ScrollAreaLimiter), true)]
class ScrollAreaLimiterInspector : Editor
{
    void OnEnable()
    {
        model = target as ScrollAreaLimiter;
    }
    
    void OnSceneGUI()
    { 
         if(UnityEditor.Tools.current != UnityEditor.Tool.Rect) return;
         

        CenterHandle();
        AreaHandle();
        SoftAreaHandle();
        
    }

    void CenterHandle()
    {
        Vector3 center = model.transform.position;
        Handles.color = Color.yellow;

        if (m_EditorStae != EditorStae.CenterHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center , handleSize);
            if (Handles.Button(center, Quaternion.identity, hsize, hsize, Handles.SphereCap))
                m_EditorStae = EditorStae.CenterHandel;
        }

        if(m_EditorStae== EditorStae.CenterHandel)
        {
            Vector3 newCenter = Handles.PositionHandle(center, Quaternion.identity);
            if (newCenter != center)  model.transform.position = newCenter; 
        }
    }

    void SoftAreaHandle()
    {
        Handles.color = Color.white;
        Vector3 center = model.transform.position;
        HandlesExtension.DrawWireCube(center + model.SoftArea.center, model.SoftArea.size);

        Handles.color = model.GizmosSoftCubeColor;


        if (m_EditorStae != EditorStae.SoftAreaMinHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center + model.SoftArea.min, handleSize);
            if (Handles.Button(center + model.SoftArea.min, Quaternion.identity, hsize, hsize, Handles.SphereCap))
                m_EditorStae = EditorStae.SoftAreaMinHandel;
        }

        if (m_EditorStae != EditorStae.SoftAreaMaxHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center + model.SoftArea.max, handleSize);
            if (Handles.Button(center + model.SoftArea.max, Quaternion.identity, hsize, hsize, Handles.SphereCap))
                m_EditorStae = EditorStae.SoftAreaMaxHandel;
        }

        switch (m_EditorStae)
        {

            case EditorStae.SoftAreaMaxHandel:
                {
                    Vector3 newMax = Handles.PositionHandle(center + model.SoftArea.max, Quaternion.identity);
                    if (newMax != center + model.SoftArea.max)
                    {

                        Vector3 min = center + model.SoftArea.min;
                        float ex = (newMax.x - min.x) / 2;
                        float ey = (newMax.y - min.y) / 2;
                        float ez = (newMax.z - min.z) / 2;
                        if (ex < 0) ex = 0;
                        if (ey < 0) ey = 0;
                        if (ez < 0) ez = 0;

                        model.SoftArea = new Bounds(model.SoftArea.min + new Vector3(ex, ey, ez), new Vector3(ex, ey, ez) * 2);

                    }
                }
                break;
            case EditorStae.SoftAreaMinHandel:
                {
                    Vector3 newMin = Handles.PositionHandle(center + model.SoftArea.min, Quaternion.identity);
                    if (newMin != center + model.SoftArea.min)
                    {

                        Vector3 max = center + model.SoftArea.max;
                        float ex = (max.x - newMin.x) / 2;
                        float ey = (max.y - newMin.y) / 2;
                        float ez = (max.z - newMin.z) / 2;
                        if (ex < 0) ex = 0;
                        if (ey < 0) ey = 0;
                        if (ez < 0) ez = 0;

                        model.SoftArea = new Bounds(model.SoftArea.max - new Vector3(ex, ey, ez), new Vector3(ex, ey, ez) * 2);

                    }
                }
                break;
        }
    }

   
    void AreaHandle()
    { 
        Vector3 center = model.transform.position; 
        Handles.color = model.GizmosCubeColor; 

        if (m_EditorStae != EditorStae.AreaMinHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center + model.Area.min, handleSize);
            if (Handles.Button(center + model.Area.min, Quaternion.identity, hsize, hsize, Handles.SphereCap))
                m_EditorStae = EditorStae.AreaMinHandel;
        }

        if (m_EditorStae != EditorStae.AreaMaxHandel)
        {
            float hsize = HandlesExtension.CalculateButtonRadius(center + model.Area.max, handleSize);
            if (Handles.Button(center + model.Area.max, Quaternion.identity, hsize, hsize, Handles.SphereCap))
                m_EditorStae = EditorStae.AreaMaxHandel;
        }

        switch (m_EditorStae)
        {

            case EditorStae.AreaMaxHandel:
                {
                    Vector3 newMax = Handles.PositionHandle(center + model.Area.max, Quaternion.identity);
                    if (newMax != center + model.Area.max)
                    {

                        Vector3 min = center + model.Area.min;
                        float ex = (newMax.x - min.x) / 2;
                        float ey = (newMax.y - min.y) / 2;
                        float ez = (newMax.z - min.z) / 2;
                        if (ex < 0) ex = 0;
                        if (ey < 0) ey = 0;
                        if (ez < 0) ez = 0;

                        model.Area = new Bounds(model.Area.min + new Vector3(ex, ey, ez), new Vector3(ex, ey, ez) * 2);

                    }
                }
                break;
            case EditorStae.AreaMinHandel:
                {
                    Vector3 newMin = Handles.PositionHandle(center + model.Area.min, Quaternion.identity);
                    if (newMin != center + model.Area.min)
                    {

                        Vector3 max = center + model.Area.max;
                        float ex = (max.x - newMin.x) / 2;
                        float ey = (max.y - newMin.y) / 2;
                        float ez = (max.z - newMin.z) / 2;
                        if (ex < 0) ex = 0;
                        if (ey < 0) ey = 0;
                        if (ez < 0) ez = 0;

                        model.Area = new Bounds(model.Area.max - new Vector3(ex, ey, ez), new Vector3(ex, ey, ez) * 2);

                    }
                }
                break;
        }
    }

    enum EditorStae
    {
        CenterHandel,//正在操作中心点
        AreaMinHandel,//区域最小点
        AreaMaxHandel,//区域最大点
        SoftAreaMinHandel,//弹性区域最小点
        SoftAreaMaxHandel,//弹性区域最大点
    }
    ScrollAreaLimiter model;
    const float handleSize = 10f;
    EditorStae m_EditorStae = EditorStae.CenterHandel;
}