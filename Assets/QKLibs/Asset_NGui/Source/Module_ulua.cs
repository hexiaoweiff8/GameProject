using System.Collections;
using UnityEngine;
public class Module_ulua : IModule
{
    public IEnumerator Init()
    {
        var go = GameObject.Find("GameManager");
        GameObject.DontDestroyOnLoad(go);
        yield break;
    }
}

//修改过的地方，搜注释 “//QK”

