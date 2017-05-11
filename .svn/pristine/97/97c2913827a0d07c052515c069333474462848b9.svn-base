using QKFrameWork.CQKCommand;
using QKSDKUtils;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace QKSDK
{

    public interface ISDKListener
    {
        /// <summary>
        /// 应用key
        /// </summary>
        string AppKey { get; }

        /// <summary>
        /// 应用安全码
        /// </summary>
        string AppSecret { get; }

        /// <summary>
        /// 用户区
        /// </summary>
        string Zone { get; }

        /// <summary>
        /// SDK初始化完成
        /// </summary>
        void OnSDKInitFinished();

        /// <summary>
        /// SDK登录成功
        /// </summary>
        /// <param name="user">用户信息</param>
        void OnSDKLoginSuccess(QKSDKUser user);

        /// <summary>
        /// SDK登录失败
        /// </summary>
        /// <param name="errorCode">错误码</param>
        /// <param name="msg">描述</param>
        void OnSDKLoginFailed(int errorCode, string msg);

        /// <summary>
        /// SDK支付返回
        /// </summary>
        /// <param name="ok">是否成功发起了支付</param>
        void OnSDKPayFinished(bool ok);

        /// <summary>
        /// 构建一个定单
        /// </summary>
        QKSDKPayOrder BuilderPayOreder(string goodsId);

        /// <summary>
        /// 检测一个定单
        /// </summary>
        void CheckPayOrder(string param);
    }

    public class SDKInstance : MonoBehaviour
    {
        public static ISDKListener Listener
        {
            get { return mListener; }
        }
        
        /// <summary>
        /// 获取渠道名字
        /// </summary>
        /// <returns></returns>
        public static string ChannelName
        {
            get
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// 版本标识
        /// </summary>
        public static string Version
        {
            get 
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// 版本名字
        /// </summary>
        public static string VersionName
        {
            get { return string.Empty; }
        }

        /// <summary>
        /// 设置SDK监听
        /// </summary>
        public static void SetSDKListener(ISDKListener listener)
        {
            mListener = listener;
            // 初始化配置
            SDKConfig.AutoInit(mListener);
        }


        /// <summary>
        /// 显示登录
        /// </summary>
        public static void ShowLoginUI()
        {
            SDKCommand.ShowLoginUI.Send();
        }

        /// <summary>
        /// 购买商品
        /// </summary>
        public static void Pay(string goodsId)
        {

        }

        #region 插件通信息关

        void RegQKCommandListener(string transName)
        {
            mTerminalPlugin.RegQKCommandListener(transName);
        }

        void UnRegQKCommandListener(string transName)
        {
            mTerminalPlugin.UnRegQKCommandListener(transName);
        }

        /// <summary>
        /// 开始一个数据传送
        /// </summary>
        /// <param name="name">名字</param>
        public void BeginTransmission(string name)
        {
            mTerminalPlugin.BeginTransmission(name);
        }

        /// <summary>
        /// 添加键名信息
        /// </summary>
        public void TransmissionKey(string k)
        {
            mTerminalPlugin.TransmissionKey(k);
        }

        /// <summary>
        /// 值信息
        /// </summary>
        public void TransmissionValue(string v)
        {
            mTerminalPlugin.TransmissionValue(v);
        }

        /// <summary>
        /// 结束一个传输
        /// </summary>
        public void EndTransmission(string name)
        {
            mTerminalPlugin.EndTransmission();
        }

        /// <summary>
        /// 执行一个命令
        /// </summary>
        /// <param name="name">名字</param>
        public void SendQKCommand(string name)
        {
            mTerminalPlugin.SendQKCommand(name);
        }

        #endregion

        void Start()
        {
            if (null != mTerminalPlugin)
            {
                mTerminalPlugin.Init();
            }

            if(null != mListener)
            {
                mListener.OnSDKInitFinished();
            }
        }

        void Awake()
        {
#if UNITY_EDITOR

#elif UNITY_IPHONE
            mTerminalPlugin = new TerminalPluginIOS();
#elif UNITY_ANDROID
            mTerminalPlugin = new TerminalPluginAndroid();
#else

#endif

            SDKCoroutine.AutoInit(this);

            UserHelper.AutoInit();

            BindCommandListener();
        }

        /// <summary>
        /// 绑定命令监听
        /// </summary>
        void BindCommandListener()
        {
            QKCommand.RegListener(SDKCommand.SDKLoginFinish.Name, OnSDKLoginFinished);
        }

        /// <summary>
        /// SDK登录完成
        /// </summary>
        void OnSDKLoginFinished(QKCommand cmd)
        {
            int errorCode = (int)cmd.Params["ErrorCode"];
            if (null != mListener)
            {
                if (0 == errorCode)
                {
                    mListener.OnSDKLoginSuccess((QKSDKUser)cmd.Params["User"]);
                }
                else
                {
                    mListener.OnSDKLoginFailed(errorCode,(string)cmd.Params["Msg"]);
                }
            }
        }

        /// <summary>
        /// 监听者
        /// </summary>
        static ISDKListener mListener = null;

        /// <summary>
        /// 终端
        /// </summary>
        static TerminalPlugin mTerminalPlugin = null;
    }
}