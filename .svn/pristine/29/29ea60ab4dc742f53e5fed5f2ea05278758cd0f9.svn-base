using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEngine;
using UnityEditor;



[CustomEditor(typeof(AvatarAnimator_Manual), true)]
class AvatarAnimation_ManuaInspector : Editor
{
    AvatarAnimator_Manual model;

    void OnEnable()
    {
        model = target as AvatarAnimator_Manual;
        //model._Init();
        flip = model.flip;
    }


    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();


        model = target as AvatarAnimator_Manual;

        AvatarAnimationTemplate tmplt = model.AnimationTemplate;
        if (tmplt == null) return;

        if (tmplt.Clips == null || tmplt.Clips.Length < 1) return;

        GUIStyle TitleStyle = new GUIStyle();
        TitleStyle.normal.background = null;    //这是设置背景填充的
        TitleStyle.normal.textColor = new Color(0.7333333333333333f, 0.807843137254902f, 1f);
        TitleStyle.fontSize = 15;
        TitleStyle.fontStyle = FontStyle.Bold;

        EditorGUILayout.Separator();

        //绘制新建剪辑面板
        EditorGUILayout.LabelField(new GUIContent("测试动画播放"), TitleStyle);


        string[] str_clips = new string[tmplt.Clips.Length];
        for (int i = 0; i < tmplt.Clips.Length; i++) str_clips[i] = tmplt.Clips[i].clipName;

        //
        currClipIndex = EditorGUILayout.Popup("动画剪辑名", currClipIndex, str_clips);
        if(GUI.changed)
        {
            currFrame = 0;
            //model.ManualPlayByFrame(str_clips[currClipIndex], currFrame, isLoop);
        }

        currFrame = EditorGUILayout.IntField("当前帧", currFrame);
        isLoop = EditorGUILayout.ToggleLeft("循环", isLoop);

        GUILayout.BeginHorizontal();
        if (GUILayout.Button(new GUIContent("上一帧")))
        {
            currFrame--;
            model.ManualPlayByFrame(str_clips[currClipIndex], currFrame, isLoop);
        }

        if (GUILayout.Button(new GUIContent("下一帧")))
        {
            currFrame++;
            model.ManualPlayByFrame(str_clips[currClipIndex], currFrame, isLoop);
        }
        GUILayout.EndHorizontal();

        EditorGUILayout.Space();
        EditorGUILayout.Space();

        EditorGUILayout.Separator();


        flip = (Flip)EditorGUILayout.EnumPopup("反转", flip as System.Enum);
         if(GUI.changed) model.flip = flip;
        


        EditorGUILayout.Space();
        EditorGUILayout.Space();
    }

    bool isLoop = true;
    int currFrame = 0;
    int currClipIndex = 0;
    Flip flip = Flip.Nothing;
}
