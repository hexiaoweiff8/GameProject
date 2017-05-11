  
#if !UNITY_FLASH
#define DYNAMIC_FONT
#endif

using UnityEngine;
using UnityEditor;

/// <summary>
/// Inspector class used to edit UILabels.
/// </summary>

[CanEditMultipleObjects]
[CustomEditor(typeof(UITextListContent), true)]
public class UITextListContentInspector : Editor
{

    UITextListContent model;
    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();

        model = target as UITextListContent;

        bool ww = GUI.skin.textField.wordWrap;
        GUI.skin.textField.wordWrap = true;
        //SerializedProperty sp = serializedObject.FindProperty("mText");
        /*
        if (model.mText)
        {
            NGUIEditorTools.DrawProperty("", sp, GUILayout.Height(128f));
        }
        else*/
        {
            GUIStyle style = new GUIStyle(EditorStyles.textField);
            style.wordWrap = true;

            float height = style.CalcHeight(new GUIContent(model.mText), Screen.width - 100f);
            //float height = 300;
            bool offset = true;
            
            if (height > 90f)
            {
                offset = false;
                height = style.CalcHeight(new GUIContent(model.mText), Screen.width - 20f);
            }
            else
            {
                GUILayout.BeginHorizontal();
                GUILayout.BeginVertical(GUILayout.Width(76f));
                GUILayout.Space(3f);
                GUILayout.Label("Text");
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
            }
            Rect rect = EditorGUILayout.GetControlRect(GUILayout.Height(height));

            GUI.changed = false;
            string text = EditorGUI.TextArea(rect, model.mText, style);
            if (GUI.changed) model.mText = text;

            if (offset)
            {
                GUILayout.EndVertical();
                GUILayout.EndHorizontal();
            }
        }

        GUI.skin.textField.wordWrap = ww;

    }
	   
     
}

