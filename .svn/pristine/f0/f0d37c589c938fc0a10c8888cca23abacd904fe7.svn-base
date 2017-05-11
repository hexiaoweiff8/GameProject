using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEditor;
using UnityEngine;
 
[CustomEditor(typeof(UIAttributePage))]
class UIAttributePageInspector : Editor
{

    UIAttributePage model;
    public override void OnInspectorGUI()
    {
        model = target as UIAttributePage;
        int tabGrop = EditorGUILayout.IntField("TabGrop", model.TabGrop);
        if (model.TabGrop != tabGrop) 
            model.TabGrop = tabGrop;

        base.DrawDefaultInspector();
    }
}