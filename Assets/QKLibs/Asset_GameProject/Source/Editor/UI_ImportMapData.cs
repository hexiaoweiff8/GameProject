using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

public class UI_ImportMapData
{

    [MenuItem("Tools/Import MapData", false, 120)]
    static void Menu_ImportConfigs()
    {
        // 将map文件copy过来
        var mapFilePath = Application.dataPath + @"\..\..\ResProject\Now\Assets\StreamingAssets\MapData\mapdata";

        var fileInfo = new FileInfo(mapFilePath);
        if (fileInfo.Exists)
        {
            fileInfo.CopyTo(Application.dataPath + @"\StreamingAssets\MapData\mapdata", true);
            Debug.Log("文件引入完成");
        }
        else
        {
            Debug.LogError("MapData文件不存在, 请先生成.");
        }
    }
}