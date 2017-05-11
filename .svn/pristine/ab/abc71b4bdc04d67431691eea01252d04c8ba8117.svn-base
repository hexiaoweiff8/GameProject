using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEngine;
using UnityEditor;
using System.IO;
using System.ComponentModel;
  

[CustomEditor(typeof(QKQuad), true)]
class QKQuadInspector : Editor
{
    QKQuad model;

    void OnEnable()
    {
        model = target as QKQuad;
        model._Init();
    }


    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();
        model = target as QKQuad;

        Pivot pivot = (Pivot)EditorGUILayout.EnumPopup(new GUIContent("重心点位置"), (Enum)model.pivot);
        if (pivot != model.pivot)
            model.pivot = pivot; 

        //mesh导出命令
        if (GUILayout.Button("网格另存为预置", GUILayout.Width(100)))
        {
            MeshFilter meshFilter = model.GetComponent<MeshFilter>();
            if(meshFilter.sharedMesh!=null)
            {
                string path = EditorUtility.SaveFilePanel("保存网格预置", "", "Collider", "prefab");
                if(!string.IsNullOrEmpty(path))
                { 
                   
                    path = "Assets" + path.Substring(Application.dataPath.Length, path.Length - Application.dataPath.Length);
                     UnityEngine. Debug.Log(path);
 
                     AssetDatabase.CreateAsset(meshFilter.sharedMesh, path);
                }
            }
        }
        
    } 
}
 