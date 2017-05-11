using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(RotationTransform), true)]
class RotationTransformInspector : Editor
{
    RotationTransform model;
    void OnEnable()
    {
        model = target as RotationTransform; 
    }

    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();
        Quaternion v = model.Value;

        EditorGUILayout.BeginHorizontal();

        Vector3 euler = v.eulerAngles; 
        euler = EditorGUILayout.Vector3Field("x", euler);
        if (GUI.changed)  
        {
            v.eulerAngles = euler;
            model.Value = v;
        }

        EditorGUILayout.EndHorizontal();
    } 
} 