using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(PTZCamera), true)]
class PTZCameraInspector : Editor
{
    PTZCamera model;
    void OnEnable()
    {
        model = target as PTZCamera;
    }

    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();
        {
            float v = model.Field;
            v = EditorGUILayout.FloatField("Field", v);
            if (GUI.changed) model.Field = v;
        }

        {
            float v = model.FarClipPlane;
            v = EditorGUILayout.FloatField("FarClipPlane", v);
            if (GUI.changed) model.FarClipPlane = v;
        }

        {
            float v = model.NearClipPlane;
            v = EditorGUILayout.FloatField("NearClipPlane", v);
            if (GUI.changed) model.NearClipPlane = v;
        }
    }
}