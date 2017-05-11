using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEngine;
using UnityEditor;

/*
[CustomEditor(typeof(AvatarAnimationTemplate), true)]
class AvatarAnimationTemplateInspector : Editor
{
    AvatarAnimationTemplate model;
    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();

        model = target as AvatarAnimationTemplate;

        GUIStyle TitleStyle = new GUIStyle();
        TitleStyle.normal.background = null;    //这是设置背景填充的
        TitleStyle.normal.textColor = new Color(0.7333333333333333f, 0.807843137254902f, 1f);
        TitleStyle.fontSize = 15;
        TitleStyle.fontStyle = FontStyle.Bold;

        if (model.Clips!=null)
        {
            foreach (AvatarAnimationClip clip in model.Clips)
            {
                //绘制剪辑名
                EditorGUILayout.LabelField(new GUIContent(clip.name == null ? "nil" : clip.name), TitleStyle);

                //更名

                //index

                //AvatarAnimationFrame[] Frames;//帧序列


            }
        }

        //绘制新建剪辑面板
        EditorGUILayout.LabelField(new GUIContent("新动画剪辑"), TitleStyle);

        GUILayout.BeginHorizontal();
        EditorGUILayout.LabelField(new GUIContent("名称"));
        newClipName = EditorGUILayout.TextArea(newClipName);

        if (GUILayout.Button(new GUIContent("创建")))
        {
            if (model.GetClip(newClipName)!=null)
                Debug.LogError("剪辑名重复");
            else if(string.IsNullOrEmpty(newClipName))
                Debug.LogError("剪辑名不能为空");
            else
            {
                model.AddClip(newClipName);
                newClipName = "";
            }
        }

        GUILayout.EndHorizontal();

        
        
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.Space(); 
    }

    string newClipName = "";
}*/

/*
 
        GUILayout.Label(operationName + " on axis", EditorStyles.boldLabel);

        GUILayout.BeginHorizontal();
            xCheckbox = GUILayout.Toggle(xCheckbox, "X");
            yCheckbox = GUILayout.Toggle(yCheckbox, "Y");
            zCheckbox = GUILayout.Toggle(zCheckbox, "Z");
        GUILayout.EndHorizontal();

        EditorGUILayout.Space();
 */
/*
 [CustomEditor(typeof(TestInspector))]
public class TestInspectorEditor : Editor
{
    private SerializedObject obj;
    private SerializedProperty lookAtPoint;
    private SerializedProperty pos;
    private SerializedProperty testObj;

    // 添加TestInspector组件的GameObject被选中时触发该函数
    void OnEnable()
    {
        obj = new SerializedObject(target);
        lookAtPoint = obj.FindProperty("lookAtPoint");
        pos = obj.FindProperty("pos");
        testObj = obj.FindProperty("testObj");
    }

    // 重写Inspector检视面板
    public override void OnInspectorGUI()
    {
        obj.Update();

        EditorGUILayout.PropertyField(lookAtPoint);
        EditorGUILayout.PropertyField(pos);
        EditorGUILayout.PropertyField(testObj, true);   // 第二个参数表示有子节点需要显示

        obj.ApplyModifiedProperties();
    }

}
 */