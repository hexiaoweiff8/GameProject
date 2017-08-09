using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;

namespace DeveloperConsole
{
    static class ServerUtil
    {
        public static string Get(string url, Dictionary<string, string> dic)
        {
            string result = "";
            StringBuilder builder = new StringBuilder();
            builder.Append(url);
            if (dic.Count > 0)
            {
                builder.Append("?");
                int i = 0;
                foreach (var item in dic)
                {
                    if (i > 0)
                        builder.Append("&");
                    builder.AppendFormat("{0}={1}", item.Key, item.Value);
                    i++;
                }
            }
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(builder.ToString());
            //添加参数  
            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            Stream stream = resp.GetResponseStream();
            try
            {
                //获取内容  
                using (StreamReader reader = new StreamReader(stream))
                {
                    result = reader.ReadToEnd();
                }
            }
            finally
            {
                stream.Close();
            }
            return result;
        }
        public static string Post(string url, string postData)
        {
            // Create a new WebClient instance.
            WebClient myWebClient = new WebClient();

            // Apply ASCII Encoding to obtain the string as a byte array.
            byte[] postArray = Encoding.Default.GetBytes(postData);

            myWebClient.Headers.Add("Content-Type", "application/x-www-form-urlencoded");

            byte[] responseArray = null;

            try
            {
                //UploadData implicitly sets HTTP POST as the request method.
                responseArray = myWebClient.UploadData(url, postArray);
            }
            catch (WebException e)
            {
                ConsoleLog.Println("使用Post请求时出现错误:");
                ConsoleLog.Println("响应状态:" + e.Status);
                ConsoleLog.Println(e.Message);
                ConsoleLog.Println(e.StackTrace);
            }

            //Dispose WebClient
            myWebClient.Dispose();

            if (responseArray != null)
                return Encoding.UTF8.GetString(responseArray);
            else return "error";
        }
    }

    static class UserUtil
    {
        public static int getUserRID()
        {
            return Convert.ToInt32(Tools.CallMethod("userModel", "getRID")[0]);
            //return 105906188;
        }
    }

    static class Const
    {
        public const string Protocol = "http";
        public const string IP = "106.75.36.113";
        public const string Port = "2002";
        public const string PATH = "/gm/";
        public const string MSG_SINGLE_REWARD = "single_reward";
        public const string MSG_DEL = "delete_";
        public const string SEND_MAIL = "send_mail";
    }
}
