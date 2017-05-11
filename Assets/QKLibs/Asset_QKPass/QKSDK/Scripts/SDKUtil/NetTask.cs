using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace QKSDK
{
    /// <summary>
    /// 网络请求完成的回调
    /// </summary>
    delegate void OnNetFinished(WWW www);

    class NetTask
    {
        public static void  AutoFinish(WWW www, OnNetFinished onFinish)
        {
            NetTask tempTask = new NetTask(www, onFinish);
            mTasks.Add(tempTask);
            tempTask.AutoFinish();
        }

        void AutoFinish()
        {
            SDKCoroutine.StartCoroutine(coAutoFinished());
        }

        IEnumerator coAutoFinished()
        {
            while (!mWWW.isDone)
            {
                yield return null;
            }

            mOnFinished(mWWW);
        }

        NetTask(WWW www, OnNetFinished onFinished)
        {
            mWWW = www;
            mOnFinished = onFinished;
        }

        /// <summary>
        /// 当前的网络链接
        /// </summary>
        WWW mWWW = null;

        /// <summary>
        /// 任务完成的回调
        /// </summary>
        OnNetFinished mOnFinished = null;

        /// <summary>
        /// 所有的网络任务
        /// </summary>
        static List<NetTask> mTasks = new List<NetTask>();
    }
}
