using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using QKFrameWork.CQKCommand;
using QKSDKUtils;

namespace QKSDK
{
    /// <summary>
    /// 提示类型
    /// </summary>
    enum CTipType
    {
        Yes,
        YesOrNo,
    }
    /// <summary>
    /// 蒙版
    /// </summary>
    static class CMaskPanel
    {
        public static void AutoInit(GameObject obj)
        {
            mUIObject = obj;
        }

        public static void Show(bool v)
        {
            mUIObject.SetActive(v);
        }

        static GameObject mUIObject;
    }
    /// <summary>
    /// 提标面板
    /// </summary>
    static class CTipPanel
    {
        /// <summary>
        /// 提示的回调
        /// </summary>
        public delegate void OnTipCallback(bool yes);

        /// <summary>
        /// 提示项
        /// </summary>
        class CTipItem
        {
            public CTipItem(CTipType t,string content, OnTipCallback callback)
            {
                TipType = t;
                TipContent = content;
                CallBack = callback;
            }

            public OnTipCallback CallBack;
            public string TipContent;
            public CTipType TipType;
        }

        class CYesMsgBox
        {
            public CYesMsgBox(GameObject obj)
            {
                mUIObject = obj;

                mYesBtn = obj.transform.FindChild("back_btn").gameObject;
                mContent = obj.transform.FindChild("txt").gameObject.GetComponent<UILabel>(); 

                UIEventListener.Get(mYesBtn).onClick += OnBtnClick;
            }

            public void Show(string content,OnTipCallback callBack)
            {
                mCallBack = callBack;
                mContent.text = content;
                mUIObject.SetActive(true);
            }

            protected void OnBtnClick(GameObject go)
            {
                if(null != mCallBack)
                {
                    mCallBack(true);
                    mCallBack = null;
                }
                mUIObject.SetActive(false);
            }
            
            /// <summary>
            /// 内容
            /// </summary>
            UILabel mContent = null;
            /// <summary>
            /// 确定按钮
            /// </summary>
            GameObject mYesBtn = null;
            /// <summary>
            /// 主面板
            /// </summary>
            GameObject mUIObject = null;
            /// <summary>
            /// 回调
            /// </summary>
            OnTipCallback mCallBack = null;
        }

        class CYesOrNoMsgBox
        {
            public CYesOrNoMsgBox(GameObject obj)
            {
                mUIObject = obj;

                mNoBtn = obj.transform.FindChild("cancel_btn").gameObject;
                mYesBtn = obj.transform.FindChild("define_btn").gameObject;
                mContent = obj.transform.FindChild("txt").gameObject.GetComponent<UILabel>(); 

                UIEventListener.Get(mNoBtn).onClick += OnNoClick;
                UIEventListener.Get(mYesBtn).onClick += OnYesClick;
            }

            public void Show(string content, OnTipCallback callBack)
            {
                mCallBack = callBack;
                mContent.text = content;
                mUIObject.SetActive(true);
            }

            protected void OnNoClick(GameObject go)
            {
                OnBtnClick(false);
            }

            protected void OnYesClick(GameObject go)
            {
                OnBtnClick(true);
            }

            protected void OnBtnClick(bool yes)
            {
                if (null != mCallBack)
                {
                    mCallBack(yes);
                    mCallBack = null;
                }
                mUIObject.SetActive(false);
            }

            /// <summary>
            /// 内容
            /// </summary>
            UILabel mContent = null;
            /// <summary>
            /// 取消按钮
            /// </summary>
            GameObject mNoBtn = null;
            /// <summary>
            /// 确定按钮
            /// </summary>
            GameObject mYesBtn = null;
            /// <summary>
            /// 主面板
            /// </summary>
            GameObject mUIObject = null;
            /// <summary>
            /// 回调
            /// </summary>
            OnTipCallback mCallBack = null;
        }
    
        /// <summary>
        /// 自动初始化
        /// </summary>
        public static void AutoInit(GameObject obj)
        {
            mUIObject = obj;
            mYesUI = new CYesMsgBox(GameObjectExtension.FindChild(obj.transform, "single_widget").gameObject);
            mYesOrNoUI = new CYesOrNoMsgBox(GameObjectExtension.FindChild(obj.transform, "double_widget").gameObject);
        }

        /// <summary>
        /// 显示一个提示信息
        /// </summary>
        /// <param name="t">提示信息的类型</param>
        /// <param name="content">内容</param>
        /// <param name="callback">回调</param>
        public static void ShowTip(CTipType t,string content,OnTipCallback callback)
        {
            mItems.Enqueue(new CTipItem(t,content, callback));
            AutoShow();
        }

        static void AutoShow()
        {
            if(null == mCurrTipItem)
            {
                if(mItems.Count > 0)
                {
                    mUIObject.SetActive(true);

                    mCurrTipItem = mItems.Dequeue();

                    if(CTipType.YesOrNo == mCurrTipItem.TipType)
                    {
                        mYesOrNoUI.Show(mCurrTipItem.TipContent, OnMsgBoxReturn);
                    }
                    else
                    {
                        mYesUI.Show(mCurrTipItem.TipContent, OnMsgBoxReturn);
                    }
                }
                else
                {
                    mUIObject.SetActive(false);
                }
            }
        }

        static void OnMsgBoxReturn(bool yes)
        {
            if(null != mCurrTipItem.CallBack)
            {
                mCurrTipItem.CallBack(yes);
            }
            mCurrTipItem = null;

            AutoShow();
        }

        /// <summary>
        /// 当前的提示项
        /// </summary>
        static CTipItem mCurrTipItem = null;
        /// <summary>
        /// 所有的提示项
        /// </summary>
        static Queue<CTipItem> mItems = new Queue<CTipItem>();
        /// <summary>
        /// 根对象
        /// </summary>
        static GameObject mUIObject = null;
        /// <summary>
        /// Yes面板
        /// </summary>
        static CYesMsgBox mYesUI = null;
        /// <summary>
        /// Yes Or No 面板
        /// </summary>
        static CYesOrNoMsgBox mYesOrNoUI = null;
    }
    public class QKAccoutSystemUI : MonoBehaviour
    {
        #region 类型定义

        /// <summary>
        /// 界面类型 
        /// 0-默认 
        /// 1-账号登录 
        /// 2-账号注册 
        /// 3-游客绑定 
        /// 4-身份证绑定 
        /// 5-手机绑定 
        /// </summary>
        enum AccountSystemUIType
        {
            Default = 0,
            AccountLogin = 1,
            AccountReg = 2,
            GuestBind = 3,
            CardBind = 4,
            PhoneBind = 5,
        }

        class CLoginEntry
        {
            public CLoginEntry(GameObject obj)
            {
                mUIObject = obj;

                mQuickLogin = GameObjectExtension.FindChild(obj.transform, "quicklogin_btn").gameObject;
                mAccountLogin = GameObjectExtension.FindChild(obj.transform, "idlogin_btn").gameObject;
                mRegAccount = GameObjectExtension.FindChild(obj.transform, "idregister_btn").gameObject;

                UIEventListener.Get(mQuickLogin).onClick = OnQuickLogin;
                UIEventListener.Get(mRegAccount).onClick = OnRegAccount;
                UIEventListener.Get(mAccountLogin).onClick = OnAccountLogin;
            }

            public void SetActive(AccountSystemUIType t)
            {
                mUIObject.SetActive(t == AccountSystemUIType.Default);
            }

            void OnQuickLogin(GameObject go)
            {
                CMaskPanel.Show(true);
                GameCommand.QuickLogin.Send();
            }

            void OnAccountLogin(GameObject go)
            {
                QKAccoutSystemUI.ShowUIType(AccountSystemUIType.AccountLogin);
            }

            void OnRegAccount(GameObject go)
            {
                QKAccoutSystemUI.ShowUIType(AccountSystemUIType.AccountReg);
            }

            GameObject mUIObject;

            /// <summary>
            /// 快速登录
            /// </summary>
            GameObject mQuickLogin;

            /// <summary>
            /// 账号登录
            /// </summary>
            GameObject mAccountLogin;

            /// <summary>
            /// 注册账号
            /// </summary>
            GameObject mRegAccount;

        }

        class CAccountLogin
        {
            public CAccountLogin(GameObject obj)
            {
                mUIObject = obj;

                mAccount = GameObjectExtension.FindChild(obj.transform, "id/txt").gameObject.GetComponent<UIInput>();
                mPassword = GameObjectExtension.FindChild(obj.transform, "key/txt").gameObject.GetComponent<UIInput>();
                mReturnBtn = GameObjectExtension.FindChild(obj.transform, "back_btn").gameObject;
                mHeadPortrait = GameObjectExtension.FindChild(obj.transform, "headportrait").gameObject;
                mRegBtn = GameObjectExtension.FindChild(obj.transform, "register_btn").gameObject;
                mLoginBtn = GameObjectExtension.FindChild(obj.transform, "login_btn").gameObject;
                mForgotPassword = GameObjectExtension.FindChild(obj.transform, "lostkey_btn").gameObject;

                UIEventListener.Get(mReturnBtn).onClick += OnBack;
                UIEventListener.Get(mLoginBtn).onClick += OnLoginBtnClick;
                UIEventListener.Get(mRegBtn).onClick += OnRegBtnClick;
            }

            public void SetActive(AccountSystemUIType t)
            {
                mUIObject.SetActive(t == AccountSystemUIType.AccountLogin);
            }

            void OnBack(GameObject go)
            {
                QKAccoutSystemUI.ShowUIType(AccountSystemUIType.Default);
            }

            void OnRegBtnClick(GameObject go)
            {
                QKAccoutSystemUI.ShowUIType(AccountSystemUIType.AccountReg);
            }

            void OnLoginBtnClick(GameObject go)
            {
                CMaskPanel.Show(true);

                string account = mAccount.value;
                string password = mPassword.value;

                GameCommand.RequestLogin
                    .AddParam("FromType", AccountFromType.QK)
                    .AddParam("Account", account)
                    .AddParam("Password", password)
                    .Send();
            }

            /// <summary>
            /// 界面UI
            /// </summary>
            GameObject mUIObject;

            /// <summary>
            /// 账号
            /// </summary>
            UIInput mAccount;

            /// <summary>
            /// 密码
            /// </summary>
            UIInput mPassword;

            /// <summary>
            /// 返回
            /// </summary>
            GameObject mReturnBtn;

            /// <summary>
            /// 头像
            /// </summary>
            GameObject mHeadPortrait;

            /// <summary>
            /// 注册按钮
            /// </summary>
            GameObject mRegBtn;

            /// <summary>
            /// 登录
            /// </summary>
            GameObject mLoginBtn;

            /// <summary>
            /// 忘记密码
            /// </summary>
            GameObject mForgotPassword;
        }

        class CRegistLogin
        {
            public CRegistLogin(GameObject obj)
            {
                mUIObject = obj;

                mAccount = GameObjectExtension.FindChild(obj.transform, "id/txt").gameObject.GetComponent<UIInput>();
                mPassword = GameObjectExtension.FindChild(obj.transform, "key/txt").gameObject.GetComponent<UIInput>();
                mRePassword = GameObjectExtension.FindChild(obj.transform, "key_define/txt").gameObject.GetComponent<UIInput>();
                mReturnBtn = GameObjectExtension.FindChild(obj.transform, "back_btn").gameObject;
                mHeadPortrait = GameObjectExtension.FindChild(obj.transform, "headportrait").gameObject;
                mRegBtn = GameObjectExtension.FindChild(obj.transform, "register_btn").gameObject;

                UIEventListener.Get(mReturnBtn).onClick += OnBack;
                UIEventListener.Get(mRegBtn).onClick += OnRegClick;
            }

            public void SetActive(AccountSystemUIType t)
            {
                mUIObject.SetActive(t == AccountSystemUIType.AccountReg);
            }

            void OnBack(GameObject go)
            {
                QKAccoutSystemUI.ShowUIType(AccountSystemUIType.Default);
            }

            void OnRegClick(GameObject go)
            {
                CMaskPanel.Show(true);

                string account = mAccount.value;
                string password = mPassword.value;

                GameCommand.RequestRegist
                    .AddParam("FromType", AccountFromType.QK)
                    .AddParam("Account", account)
                    .AddParam("Password", password)
                    .Send();
            }

            /// <summary>
            /// 界面
            /// </summary>
            GameObject mUIObject;

            /// <summary>
            /// 账号
            /// </summary>
            UIInput mAccount;

            /// <summary>
            /// 密码
            /// </summary>
            UIInput mPassword;

            /// <summary>
            /// 重复密码
            /// </summary>
            UIInput mRePassword;

            /// <summary>
            /// 返回
            /// </summary>
            GameObject mReturnBtn;

            /// <summary>
            /// 头像
            /// </summary>
            GameObject mHeadPortrait;

            /// <summary>
            /// 注册按钮
            /// </summary>
            GameObject mRegBtn;
        }

        class CCardTab
        {
            public CCardTab(GameObject obj)
            {
                mCardNum = GameObjectExtension.FindChild(obj.transform, "idnum/txt").gameObject.GetComponent<UIInput>();
                mName = GameObjectExtension.FindChild(obj.transform, "name/txt").gameObject.GetComponent<UIInput>();
                mSubmit = GameObjectExtension.FindChild(obj.transform, "submit_btn").gameObject;
            }

            /// <summary>
            /// 身份证号
            /// </summary>
            UIInput mCardNum;

            /// <summary>
            /// 姓名
            /// </summary>
            UIInput mName;

            /// <summary>
            /// 提交
            /// </summary>
            GameObject mSubmit;
        }

        class CPhoneTab
        {
            public CPhoneTab(GameObject obj)
            {

            }

            /// <summary>
            /// 手机号
            /// </summary>
            UIInput mPhoneNum;

            /// <summary>
            /// 验证码
            /// </summary>
            UIInput mVerCode;

            /// <summary>
            /// 获取验证码
            /// </summary>
            GameObject mGetVerCode;

            /// <summary>
            /// 提交
            /// </summary>
            GameObject mSubmit;
        }

        class CRealAuthenticate
        {
            public CRealAuthenticate(GameObject obj)
            {
                mUIObject = obj;

                mReturn = GameObjectExtension.FindChild(obj.transform, "back_btn").gameObject;
                mCardTab = new CCardTab(GameObjectExtension.FindChild(obj.transform, "idcard_page").gameObject);
                mPhoneTab = new CPhoneTab(GameObjectExtension.FindChild(obj.transform, "mobileregister_page").gameObject);

                UIEventListener.Get(mReturn).onClick += OnBack;
            }

            public void SetActive(AccountSystemUIType t)
            {
                mUIObject.SetActive(t == AccountSystemUIType.PhoneBind || t == AccountSystemUIType.CardBind);
            }

            void OnBack(GameObject go)
            {
                QKAccoutSystemUI.ShowUIType(AccountSystemUIType.Default);
            }
            /// <summary>
            /// 界面
            /// </summary>
            GameObject mUIObject;

            /// <summary>
            /// 返回
            /// </summary>
            GameObject mReturn;

            /// <summary>
            /// 身份证认证
            /// </summary>
            CCardTab mCardTab;

            /// <summary>
            /// 手机绑定
            /// </summary>
            CPhoneTab mPhoneTab;
        }

        class CLoginUI
        {
            public CLoginUI(GameObject obj)
            {
                mUIObject = obj;

                mCloseBtn = GameObjectExtension.FindChild(obj.transform, "panel/close_btn").gameObject;

                mLoginEntry = new CLoginEntry(GameObjectExtension.FindChild(obj.transform, "panel/main_widget").gameObject);

                mAccountLogin = new CAccountLogin(GameObjectExtension.FindChild(obj.transform, "panel/idlogin_widget").gameObject);

                mRegistAccount = new CRegistLogin(GameObjectExtension.FindChild(obj.transform, "panel/register_widget").gameObject);

                mRealAuth = new CRealAuthenticate(GameObjectExtension.FindChild(obj.transform, "panel/id&phone_widget").gameObject);

                CTipPanel.AutoInit(GameObjectExtension.FindChild(obj.transform, "tips_panel").gameObject);

                UIEventListener.Get(mCloseBtn).onClick += OnClick;
            }

            public void SetActive(AccountSystemUIType t)
            {
                mUIObject.SetActive(t != AccountSystemUIType.GuestBind);
                mLoginEntry.SetActive(t);
                mAccountLogin.SetActive(t);
                mRegistAccount.SetActive(t);
                mRealAuth.SetActive(t);
            }

            void OnClick(GameObject go)
            {
                QKAccoutSystemUI.CloseUI();
            }

            /// <summary>
            /// 界面Object
            /// </summary>
            GameObject mUIObject;

            /// <summary>
            /// 关闭按钮
            /// </summary>
            GameObject mCloseBtn;

            /// <summary>
            /// 登录入口
            /// </summary>
            CLoginEntry mLoginEntry;

            /// <summary>
            /// 账号登录
            /// </summary>
            CAccountLogin mAccountLogin;

            /// <summary>
            /// 注册账号
            /// </summary>
            CRegistLogin mRegistAccount;

            /// <summary>
            /// 实名认证
            /// </summary>
            CRealAuthenticate mRealAuth;
        }

        class CBindUI
        {
            public CBindUI(GameObject obj)
            {
                mUIObject = obj;

                mAccount = GameObjectExtension.FindChild(obj.transform, "id/txt").gameObject.GetComponent<UIInput>();
                mPassword = GameObjectExtension.FindChild(obj.transform, "key/txt").gameObject.GetComponent<UIInput>();
                mRePassword = GameObjectExtension.FindChild(obj.transform, "key_define/txt").gameObject.GetComponent<UIInput>();
                mCloseBtn = GameObjectExtension.FindChild(obj.transform, "close_btn").gameObject;
                mRegBtn = GameObjectExtension.FindChild(obj.transform, "register_btn").gameObject;

                UIEventListener.Get(mCloseBtn).onClick += OnClose;

            }

            public void SetActive(AccountSystemUIType t)
            {
                mUIObject.SetActive(t == AccountSystemUIType.GuestBind);
            }

            void OnClose(GameObject go)
            {
                QKAccoutSystemUI.CloseUI();
            }

            /// <summary>
            /// 界面
            /// </summary>
            GameObject mUIObject;

            /// <summary>
            /// 账号
            /// </summary>
            UIInput mAccount;

            /// <summary>
            /// 密码
            /// </summary>
            UIInput mPassword;

            /// <summary>
            /// 确认密码
            /// </summary>
            UIInput mRePassword;

            /// <summary>
            /// 注册并绑定
            /// </summary>
            GameObject mRegBtn;

            /// <summary>
            /// 关闭
            /// </summary>
            GameObject mCloseBtn;

        }

        #endregion

        const string QKPassPackName = "gameplatform_qkpass";

        static void ShowUIType(AccountSystemUIType t)
        {
            if(null != mSingle)
            {
                mSingle.ShowAccountSystemUI(t);
            }
        }

        static void CloseUI()
        {
            if(null != mSingle)
            {
                mSingle.mSystemObject.SetActive(false);
            }
        }

        IEnumerator coLoadResource()
        {
            if (!mResLoaded)
            {
                PacketLoader packloader = new PacketLoader();
                var packs = new List<String>();
                packs.Add(QKPassPackName);

                bool LoadOK = false;

                packloader.Start(PackType.Res, packs, (isok) => LoadOK = true);

                while (!LoadOK) yield return null;

                mResLoaded = true;
            }

            if (mSystemObject == null)
            {
                ResourceRefManage.Single.AddRef(QKPassPackName);

                var pack = PacketManage.Single.GetPacket(QKPassPackName);

                //装载资源
                mSystemObject = GameObject.Instantiate(pack.Load("loginbox.prefab") as GameObject);
                GameObject.DontDestroyOnLoad(mSystemObject);

                // 绑定UI
                mBindUI = new CBindUI(mSystemObject.transform.FindChild("accountbinding").gameObject);
                // 登录UI
                mLoginUI = new CLoginUI(mSystemObject.transform.FindChild("bg").gameObject);

                CMaskPanel.AutoInit(mSystemObject.transform.FindChild("mask").gameObject);
            }

            ShowAccountSystemUI(mUIType);
        }

        void ShowAccountSystemUI(AccountSystemUIType t)
        {
            mSystemObject.SetActive(true);
            mLoginUI.SetActive(t);
            mBindUI.SetActive(t);
            mUIType = t;
        }

        void Awake()
        {
            mSingle = this;
            QKCommand.RegListener(SDKCommand.ShowLoginUI.Name, OnShowLoginUI);
            QKCommand.RegListener(SDKCommand.SDKLoginFinish.Name, OnSDKLoginFinished);
        }

        void OnSDKLoginFinished(QKCommand cmd)
        {
            CMaskPanel.Show(false);

            int errorCode = (int)cmd.Params["ErrorCode"];
            if (0 == errorCode)
            {
                CloseUI();
            }
            else
            {
                CTipPanel.ShowTip(CTipType.Yes, (string)cmd.Params["Msg"], null);
            }
        }

        /// <summary>
        /// 显示登录
        /// </summary>
        void OnShowLoginUI(QKCommand cmd)
        {
            if (cmd.Params.ContainsKey("Type"))
            {
                mUIType = (AccountSystemUIType)(int)cmd.Params["Type"];
            }
            else
            {
                mUIType = AccountSystemUIType.Default;
            }
            CoroutineManage.Single.StartCoroutine(coLoadResource());
        }

        /// <summary>
        /// 正在加载
        /// </summary>
        bool mResLoaded = false;

        /// <summary>
        /// 绑定UI
        /// </summary>
        CBindUI mBindUI;

        /// <summary>
        /// 登录UI
        /// </summary>
        CLoginUI mLoginUI;

        /// <summary>
        /// 系统对象
        /// </summary>
        GameObject mSystemObject;

        /// <summary>
        /// 界面类型
        /// </summary>
        AccountSystemUIType mUIType;

        /// <summary>
        /// 账号系统实例
        /// </summary>
        static QKAccoutSystemUI mSingle = null;
    }
}
