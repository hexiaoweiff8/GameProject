using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using UnityEngine;

public interface IModule
{
    IEnumerator Init();
}

public class U3DEX : MonoBehaviour
{
    public delegate void InitDone();

    public void Go(List<IModule> modules,InitDone callBack)
    {
        StartCoroutine(coGo(modules, callBack));
    }


    IEnumerator coGo(List<IModule> modules,InitDone callBack)
    {
        foreach (IModule curr in modules)
        {
            IEnumerator it = curr.Init();
            while(it.MoveNext())
                yield return null;
        }

        callBack();
        GameObject.Destroy(this);//销毁本组件
    }
}