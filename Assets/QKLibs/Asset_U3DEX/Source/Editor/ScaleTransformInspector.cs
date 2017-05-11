using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ScaleTransform), true)]
class ScaleTransformInspector : Editor
{
    ScaleTransform model;
    void OnEnable()
    {
        model = target as ScaleTransform; 
    }

    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();
        Vector3 v = model.Value;
        v = EditorGUILayout.Vector3Field("value", v);
        if (GUI.changed) model.Value = v;
 

    } 
} 