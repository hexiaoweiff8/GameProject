using UnityEngine;
using System.Collections;
using UnityEditor;
using QKSDK;

public class ImportQKSDK : EditorWindow
{

    [MenuItem("Tools/Import QKSDK", false, 0)]
    static void Menu_ImportQKSDK()
    {
        //创建窗口
        Rect wr = new Rect(300, 300, 300, 300);
        ImportQKSDK window = (ImportQKSDK)EditorWindow.GetWindowWithRect(typeof(ImportQKSDK), wr, true, "Import QKSDK");
        window.Show();
    }

    //绘制窗口时调用
    void OnGUI()
    {
        EditorGUILayout.BeginScrollView(new Vector2(10,10), false, false);
        {
            GUILayout.Space(25);
            mUseQKLoginUI = EditorGUILayout.ToggleLeft(new GUIContent("使用QK账号登录界面"), mUseQKLoginUI);
            GUILayout.Space(25);
            if (GUILayout.Button("导入QKSDK", GUILayout.Width(100)))
            {
                ImportGameObject();
                //关闭窗口
                this.Close();
            }
        }
        EditorGUILayout.EndScrollView();

    }


    void ImportGameObject()
    {
        // EasyTouch
        if (GameObject.FindObjectOfType<SDKInstance>() == null)
        {
            GameObject temp = new GameObject("QKSDK", typeof(SDKInstance));
            if(mUseQKLoginUI)
            {
                temp.AddComponent<QKAccoutSystemUI>();
            }
        }
        else
        {
            EditorUtility.DisplayDialog("警告", "QKSDK已经被添加到了场景中", "确定");
        }

        Selection.activeObject = GameObject.FindObjectOfType<SDKInstance>().gameObject;
    }

    bool mUseQKLoginUI = true;
}