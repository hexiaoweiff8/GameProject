using System;
using System.Collections.Generic;
using QKNodeSDK_CLR;
using UnityEngine;


namespace QKNodeSDK_CLR
{
    public interface IQKnodeModule
    {
        bool Init(NodeEvents evts);
        string ModuleName { get; }
    }

    public class AssetsManage
    {
        public static bool Go(NodeEvents evts, List<IQKnodeModule> modules)
        {
            foreach (IQKnodeModule curr in modules)
            {
                try
                {
                    if (!curr.Init(evts))
                    {
                        Debug.LogError(string.Format("模块 {0} 初始化失败!", curr.ModuleName));
                        return false;
                    }
                }
                catch (Exception ex)
                {
                    Debug.LogError(string.Format("模块 {0} 初始化失败! {1}", curr.ModuleName, ex.ToString()));
                    return false;
                }
            }

            return true;
        }
    }
}