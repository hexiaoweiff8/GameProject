using YQ2Common.CSecurity;

namespace YQ2Common.CObjects
{
    /// <summary>
    /// Http的错误类型
    /// </summary>
    public enum CHttpErrorCode
    {
        Success = 0,
        Expired = 1,        // 通信过期 该请求者过期了，一般是顶号了。
        Busying = 2,        // 服务器繁忙    结果尚在执行中，稍后再试
        ContextLost = 3,    // 丢失上下文    上下文丢失，通讯过程中数据丢失了
        ErrorFromat = 4,    // 错误的请求格式 请求时的通信格式出错
        NetError = 5,       // 通讯失败
        Unkonw = 99         // 未知错误 
    }

    public static class CHttpReturn
    {
        /// <summary>
        /// 创建Http请求返回对象
        /// </summary>
        public static byte[] BuildReturn(CHttpErrorCode reType, string content,string ext)
        {
            QK_JsonValue_Map jsonMap = new QK_JsonValue_Map();
            jsonMap.addStrValue("ErrorCode", ((int)reType).ToString());
            jsonMap.addStrValue("Content", content);
            jsonMap.addStrValue("Ext", ext);
            return CSafeData.SecEncode(jsonMap.ToString());
        }
    }
}
