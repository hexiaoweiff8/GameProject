using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace YQ2Common.CObjects
{
    public static class CExtendClass
    {
        /// <summary>
        /// 试着转换成JLItem
        /// </summary>
        public static JLItem TryToJLItem(this string str)
        {
            return JLItem.Parse(str);
        }

        /// <summary>
        /// 试着转换成List<JLItem>
        /// </summary>
        public static List<JLItem> TryToJLItemList(this string str)
        {
            List<JLItem> result = new List<JLItem>();

            string[] items = str.Split(';');
            foreach (string tempItem in items)
            {
                result.Add(JLItem.Parse(tempItem));
            }
            return result;
        }

        /// <summary>
        ///  试着转换成字符串
        /// </summary>
        public static string TryToString(this List<JLItem> items)
        {
            StringBuilder sb = new StringBuilder();
            foreach(JLItem tempItem in items)
            {
                if(0 != sb.Length)
                {
                    sb.Append(";");
                }
                sb.Append(tempItem.ToString());
            }
            return sb.ToString();
        }
    }
}
