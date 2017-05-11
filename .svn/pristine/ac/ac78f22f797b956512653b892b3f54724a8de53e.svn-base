using QKFrameWork.CQKCommand;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using QKSDKUtils;
using UnityEngine;

namespace QKSDK
{
    static class UserHelper
    {
        /// <summary>
        /// 登录地址
        /// </summary>
        static string LoginUrl
        {
            get { return String.Format("http://{0}/UserLogin", SDKConfig.UserCenterDomain); }
        }

        /// <summary>
        /// 注册地址
        /// </summary>
        static string RegistUrl
        {
            get { return String.Format("http://{0}/UserRegist", SDKConfig.UserCenterDomain); }
        }

        /// <summary>
        /// 快速注册地址
        /// </summary>
        static string QuickRegistUrl
        {
            get { return String.Format("http://{0}/UserQuickRegist", SDKConfig.UserCenterDomain); }
        }

        public static void AutoInit()
        {
            BindGameCommandListener();
        }


        #region 游戏命令监听

        /// <summary>
        /// 绑定各游戏命令的监听
        /// </summary>
        static void BindGameCommandListener()
        {
            QKCommand.RegListener(GameCommand.ShowPayUI.Name, OnShowPayUI);
            QKCommand.RegListener(GameCommand.QuickLogin.Name, OnQuickLogin);
            QKCommand.RegListener(GameCommand.RequestLogin.Name, OnRequestLogin);
            QKCommand.RegListener(GameCommand.RequestRegist.Name, OnRequestRegist);
        }

        /// <summary>
        /// 请求登录
        /// FromType:来源的账号体系 AccountFromType
        /// Account:账号
        /// Password:密码
        /// </summary>
        static void OnRequestLogin(QKCommand cmd)
        {
            string fromType = (string)cmd.Params["FromType"];
            mCurrAccount = (string)cmd.Params["Account"];
            mCurrPassword = (string)cmd.Params["Password"];

            // 上传的参数
            Dictionary<string, string> upParams = new Dictionary<string, string>();
            upParams["AppKey"] = SDKConfig.AppKey;
            upParams["Account"] = mCurrAccount;
            upParams["Password"] = mCurrPassword;
            upParams["FromType"] = fromType;
            upParams["Sign"] = String.Format("AppKey={0}&Account={1}&FromType={2}&{3}",
                SDKConfig.AppKey, mCurrAccount, fromType, SDKConfig.AppSecret).TryToQKMD5();

            NetTask.AutoFinish(new WWW(LoginUrl, upParams.TryToString().TrySecEncode().TryToBytes()), OnUserLoginFinished);
        
        }

        /// <summary>
        /// 请求注册账号
        /// FromType:来源的账号体系 AccountFromType
        /// Account:账号
        /// Password:密码
        /// </summary>
        static void OnRequestRegist(QKCommand cmd)
        {
            string fromType = (string)cmd.Params["FromType"];
            mCurrAccount = (string)cmd.Params["Account"];
            mCurrPassword = (string)cmd.Params["Password"];

            // 上传的参数
            Dictionary<string, string> upParams = new Dictionary<string, string>();
            upParams["AppKey"] = SDKConfig.AppKey;
            upParams["Account"] = mCurrAccount;
            upParams["Password"] = mCurrPassword;
            upParams["FromType"] = fromType;
            upParams["Sign"] = String.Format("AppKey={0}&Account={1}&FromType={2}&{3}",
                SDKConfig.AppKey, mCurrAccount, fromType, SDKConfig.AppSecret).TryToQKMD5();

            NetTask.AutoFinish(new WWW(RegistUrl, upParams.TryToString().TrySecEncode().TryToBytes()), OnUserLoginFinished);
        
        }

        /// <summary>
        /// 快速登录
        /// </summary>
        static void OnQuickLogin(QKCommand cmd)
        {
            string fromType = AccountFromType.QK;

            // 有临时的账号密码
            if(SDKCookie.ContainKey("TempAccount") && SDKCookie.ContainKey("TempPassword"))
            {
                mCurrAccount = SDKCookie.GetValue("TempAccount");
                mCurrPassword = SDKCookie.GetValue("TempPassword");

                // 上传的参数
                Dictionary<string, string> upParams = new Dictionary<string, string>();
                upParams["AppKey"] = SDKConfig.AppKey;
                upParams["Account"] = mCurrAccount;
                upParams["Password"] = mCurrPassword;
                upParams["FromType"] = fromType;
                upParams["Sign"] = String.Format("AppKey={0}&Account={1}&FromType={2}&{3}",
                    SDKConfig.AppKey, mCurrAccount, fromType, SDKConfig.AppSecret).TryToQKMD5();

                NetTask.AutoFinish(new WWW(LoginUrl, upParams.TryToString().TrySecEncode().TryToBytes()), OnUserLoginFinished);
        
            }
            else
            {
                // 上传的参数
                Dictionary<string, string> upParams = new Dictionary<string, string>();
                upParams["AppKey"] = SDKConfig.AppKey;
                upParams["FromType"] = fromType;
                upParams["Sign"] = String.Format("AppKey={0}&FromType={1}&{2}",
                    SDKConfig.AppKey, fromType, SDKConfig.AppSecret).TryToQKMD5();

                NetTask.AutoFinish(new WWW(QuickRegistUrl, upParams.TryToString().TrySecEncode().TryToBytes()), OnUserLoginFinished);
            }
        }

        /// <summary>
        /// 显示支付界面
        /// </summary>
        static void OnShowPayUI(QKCommand cmd)
        {

        }

        #endregion

        static void OnUserLoginFinished(WWW www)
        {
            QKSDKReturn sdkReturn = null;
            if(string.IsNullOrEmpty(www.error))
            {
                sdkReturn = QKSDKReturn.Parse(www.text);
            }
            else
            {
                sdkReturn = new QKSDKReturn(404,www.error);
            }
            OnUserLoginFinished(sdkReturn);
        }

        static void OnUserLoginFinished(QKSDKReturn sdkReturn)
        {
            /// ErrorCode:错误码,0代码成功
            /// Msg:描述
            /// User:用户对象
            QKCommand tempCmd = SDKCommand.SDKLoginFinish;
            tempCmd.AddParam("ErrorCode", sdkReturn.ErrorCode);
            tempCmd.AddParam("Msg", sdkReturn.ErrorMsg);

            if (0 == sdkReturn.ErrorCode)
            {
                QKSDKUser tempUser = QKSDKUser.Parse(sdkReturn.Content.TrySecDecode());

                // 缓存非游客用户账号
                if(0 == tempUser.GuestMode)
                {
                    SDKConfig.CacheAccount(mCurrAccount, mCurrPassword);
                }
                else
                {
                    SDKCookie.SetValue("TempAccount",tempUser.Account);
                    SDKCookie.SetValue("TempPassword", tempUser.Account);
                }

                tempCmd.AddParam("User", tempUser);
            }

            tempCmd.Send();
        }

        /// <summary>
        /// 当前的账号
        /// </summary>
        static string mCurrAccount;
        /// <summary>
        /// 当前的密码
        /// </summary>
        static string mCurrPassword;
    }
}
