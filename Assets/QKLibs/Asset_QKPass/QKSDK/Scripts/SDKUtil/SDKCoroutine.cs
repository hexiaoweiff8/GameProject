using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace QKSDK
{
    class SDKCoroutine 
    {
        public static void AutoInit(MonoBehaviour mono)
        {
            mMonoBehaviour = mono;
        }

        public static void StartCoroutine(IEnumerator it)
        {
            if (null != mMonoBehaviour)
            {
                mMonoBehaviour.StartCoroutine(it);
            }
        }

        public static void StopCoroutine(IEnumerator it)
        {
            if (null != mMonoBehaviour)
            {
                mMonoBehaviour.StopCoroutine(it);
            }
        }


        static MonoBehaviour mMonoBehaviour = null;
    }
}
