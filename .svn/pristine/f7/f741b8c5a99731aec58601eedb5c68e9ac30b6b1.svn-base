using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using UnityEngine;
public   class Module_NGui : IModule
{
    public   IEnumerator Init() 
    {

        //初始化romcfg
        GameObject wndConfig = GameObjectExtension.InstantiateFromPacket("rom_share", "WndConfig", null);
        GameObject.DontDestroyOnLoad(wndConfig);
         
        yield break;
    }
}

//修改过的地方，搜注释 “//QK”

