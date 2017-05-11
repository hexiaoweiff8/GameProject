
using System.Collections.Generic;
using System.Collections;
using System;
using UnityEditor;
using UnityEngine;
using System.IO;

[CustomEditor(typeof(MFAExportTags))]
public class MFAExportTagsInspector : Editor
{

    MFAExportTags m_target;
    public override void OnInspectorGUI()
    {
        base.DrawDefaultInspector();

        m_target = target as MFAExportTags;

        if (GUILayout.Button("导出", GUILayout.Width(100)))
        {   
            Generate();
        }   
    }

    /// <summary>
    /// 必读tag
    /// </summary>
    bool CmpTag(string[] tglist1,string[] tglist2)
    {
        foreach (var tg1 in tglist1)
        {
            foreach (var tg2 in tglist2)
            {
                if (tg1 == tg2) return true;
            }
        }

        return false;
    }
     
    void Generate()
    {
        if (m_target.FilterTagList == null || m_target.FilterTagList.Length < 1)
        {
            Debug.Log("没有执行任何导出。");
            return;
        }
        MFAConfigPath.AutoSetupConfig();
        MFADatas.Single.AutoReload();

        int exCount = 0;
        foreach (var kv in MFADatas.Single.AnimationExport.m_Data)
        {
            var exInfo = kv.Value;

            if (!CmpTag(exInfo.FindTag, m_target.FilterTagList)) continue;//tag不匹配 

            exCount++;
          
            //执行导出
            MFAExportCore.GenerateOne(exInfo);
        }

        if (exCount < 1) Debug.Log("没有执行任何导出。");
    }

    
}



