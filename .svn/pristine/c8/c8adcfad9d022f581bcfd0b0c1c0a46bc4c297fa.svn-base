
using System.Collections.Generic;
using System.Collections;
using System;
using UnityEditor;
using UnityEngine;
using System.IO;

[CustomEditor(typeof(MFAExportList))]
public class MFAExportListInspector : Editor
{

    MFAExportList m_target;
    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();

        m_target = target as MFAExportList;

        if (GUILayout.Button("导出", GUILayout.Width(100)))
        {   
            Generate();
        }   
    }
     
    void Generate()
    {
        if (m_target.IDList == null || m_target.IDList.Length < 1)
        {
            Debug.Log("没有执行任何导出。");
            return;
        }
        MFAConfigPath.AutoSetupConfig();
        MFADatas.Single.AutoReload();

        foreach (var id in m_target.IDList)
        {
            var exInfo = MFADatas.Single.AnimationExport.Get(id);

            if (exInfo == null)
            {
                Debug.LogWarning("不存在的任务ID " + id);
                continue; 
            }

            //执行导出
            MFAExportCore.GenerateOne(exInfo);
        }
    }

    
}



