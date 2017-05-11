using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
class MFAConfigPath
{
    public static string GenerateCfgPath(string tabName)
    {
        return Application.dataPath + "/QKLibConfigs/MeshFrameAnimationConfig/" + tabName + ".csv";
    }


    /// <summary>
    /// 自动安装配置信息到工程
    /// </summary>
    public static void AutoSetupConfig()
    {

    }
} 
