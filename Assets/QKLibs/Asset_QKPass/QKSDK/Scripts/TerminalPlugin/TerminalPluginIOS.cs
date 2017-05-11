#if UNITY_IPHONE

using System.Runtime.InteropServices;
namespace QKSDK
{
    class TerminalPluginIOS : TerminalPlugin 
    {
        /// <summary>
        /// 初始化SDK实例
        /// </summary>
        [DllImport("__Internal")]
        private static extern void InitPlugins();

        /// <summary>
        /// 开始一个传输
        /// </summary>
        [DllImport("__Internal")]
        private static extern void BeginTransmission(string name);

        /// <summary>
        /// 传输一个数据包
        /// </summary>
        /// <param name="transName">名字</param>
        /// <param name="k">键</param>
        /// <param name="v">值</param>
        [DllImport("__Internal")]
        private static extern void TransDataPiece(string transName, string k, string v);

        /// <summary>
        /// 结束一个传输
        /// </summary>
        [DllImport("__Internal")]
        private static extern void EndTransmission(string name);

        /// <summary>
        /// QKCommand命令
        /// </summary>
        [DllImport("__Internal")]
        private static extern void OnQKCommand(string eventName);

        public override void Init()
        {
            InitSDKInstance();
        }

        protected override void BeginTransToTerminal(string transName)
        {
            BeginTransmission(transName);
        }

        protected override void TransToTerminal(string transName, string k, string v)
        {
            TransDataPiece(transName,k,v);
        }

        protected override void EndTransToTerminal(string transName)
        {
            EndTransmission(transName);
        }

        protected override void TerminalDoQKCommand(string transName)
        {
            OnQKCommand(transName);
        }
    }

}
#endif