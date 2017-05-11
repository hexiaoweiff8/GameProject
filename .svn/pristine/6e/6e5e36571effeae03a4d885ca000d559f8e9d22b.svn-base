#if UNITY_ANDROID

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace QKSDK
{
    class TerminalPluginAndroid : TerminalPlugin
    {

        public TerminalPluginAndroid()
        {
            mJavaClass = new AndroidJavaClass("com.qikuai.qksdk.QKPlugins");
        }

        public override void Init()
        {
            mJavaClass.CallStatic("InitPlugins");
        }

        protected override void BeginTransToTerminal(string transName)
        {
            mJavaClass.CallStatic("BeginTransmission", transName);
        }

        protected override void TransToTerminal(string transName, string k, string v)
        {
            mJavaClass.CallStatic("TransDataPiece", transName, k, v);
        }

        protected override void EndTransToTerminal(string transName)
        {
            mJavaClass.CallStatic("EndTransmission", transName);
        }

        protected override void TerminalDoQKCommand(string transName)
        {
            mJavaClass.CallStatic("OnQKCommand", transName);
        }

        /// <summary>
        /// 用于调用Java接口
        /// </summary>
        private AndroidJavaClass mJavaClass;
    }
}

#endif
