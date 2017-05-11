using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(PositionTransform), true)]
class PositionTransformInspector : Editor
{
    PositionTransform model;
    void OnEnable()
    {
        model = target as PositionTransform; 
    }

    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();
        Vector3 v = model.Value;
        v = EditorGUILayout.Vector3Field("value", v);
        if (GUI.changed) model.Value = v;
 

    } 
} 