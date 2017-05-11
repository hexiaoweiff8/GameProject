using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QKSDK
{
    /// <summary>
    /// 数据传输器
    /// </summary>
    class DataTransmitter
    {
        /// <summary>
        /// 数据片
        /// </summary>
        struct DataPiece
        {
            public string Key;
            public string Value;
        }

        public DataTransmitter(string name)
        {
            mName = name;
        }

        /// <summary>
        /// 名字
        /// </summary>
        public string Name
        {
            get { return mName; }
        }

        /// <summary>
        /// 内容
        /// </summary>
        public Dictionary<string,string> Content
        {
            get 
            {
                Dictionary<string, string> tempResult = new Dictionary<string, string>();
                foreach(DataPiece temp in mTransList)
                {
                    tempResult[temp.Key] = temp.Value;
                }
                return tempResult;
            }
        }

        /// <summary>
        /// 添加键
        /// </summary>
        public void AddKey(string k)
        {
            mCurrPiece = new DataPiece() { Key = k, Value = string.Empty };
        }

        /// <summary>
        /// 添加值
        /// </summary>
        public void AddValue(string v)
        {
            if(!string.IsNullOrEmpty(mCurrPiece.Key))
            {
                mCurrPiece.Value = v;
                mTransList.Add(mCurrPiece);
            }
        }

        /// <summary>
        /// 名字
        /// </summary>
        string mName;

        /// <summary>
        /// 当前的数据片
        /// </summary>
        DataPiece mCurrPiece;

        /// <summary>
        /// 传输中的队列
        /// </summary>
        List<DataPiece> mTransList = new List<DataPiece>();
    }
}
