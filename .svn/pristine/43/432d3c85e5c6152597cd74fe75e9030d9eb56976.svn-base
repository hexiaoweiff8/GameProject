using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace QKSDK
{
    class QKSDKTools : EditorWindow
    {
        [MenuItem("Tools/QKSDKTools", false, 0)]
        static void Menu_QKSDKTools()
        {
            //创建窗口
            Rect wr = new Rect(300, 300, 300, 500);
            QKSDKTools window = (QKSDKTools)EditorWindow.GetWindowWithRect(typeof(QKSDKTools), wr, true, "QKSDKTools");
            window.Show();
        }

        //绘制窗口时调用
        void OnGUI()
        {
            EditorGUILayout.BeginScrollView(new Vector2(10, 10), false, false);
            {
                mCurrTempAccount = EditorGUILayout.TextArea(PlayerPrefs.GetString("QKSDK_Cache_TempAccount"));
                GUILayout.Space(25);
                if (GUILayout.Button("清除当前临时账号", GUILayout.Width(100)))
                {
                    PlayerPrefs.DeleteKey("QKSDK_Cache_TempAccount");
                    PlayerPrefs.DeleteKey("QKSDK_Cache_TempPassword");
                    //关闭窗口
                    this.Close();
                }
            }
            EditorGUILayout.EndScrollView();

        }

        string mCurrTempAccount;
    }
}
