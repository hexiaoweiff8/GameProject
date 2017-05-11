
using System.Collections.Generic;
using System.Collections;
using System;
using UnityEditor;
using UnityEngine;
using System.IO;

[CustomEditor(typeof(MFAExportRange))]
public class MFAExportRangeInspector : Editor
{

    MFAExportRange m_target;
    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();

        m_target = target as MFAExportRange;

        if (GUILayout.Button("导出", GUILayout.Width(100)))
        {
            Generate();
        }   
    }
     
    void Generate()
    {
        MFAConfigPath.AutoSetupConfig();
        MFADatas.Single.AutoReload();

        int beginID = m_target.BeginID;
        int endID = m_target.EndID;
        if (endID < beginID) endID = beginID;

        int exCount = 0;
        foreach (var kv in MFADatas.Single.AnimationExport.m_Data)
         {
             var id = kv.Key;
             if (id < beginID || id > endID) continue;//id超出范围

             exCount++;
             var exInfo = kv.Value;

             //执行导出
             MFAExportCore.GenerateOne(exInfo);
         }

         if (exCount < 1) Debug.Log("没有执行任何导出。");
    }



}
