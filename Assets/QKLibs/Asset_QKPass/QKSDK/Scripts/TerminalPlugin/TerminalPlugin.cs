using QKFrameWork.CQKCommand;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QKSDK
{
    abstract class TerminalPlugin
    {
        /// <summary>
        /// 开始一个数据传送
        /// </summary>
        /// <param name="name">名字</param>
        public void BeginTransmission(string name)
        {
            mTransmitter = new DataTransmitter(name);
        }

        /// <summary>
        /// 添加键名信息
        /// </summary>
        public void TransmissionKey(string k)
        {
            if (null != mTransmitter)
            {
                mTransmitter.AddKey(k);
            }
        }

        /// <summary>
        /// 值信息
        /// </summary>
        public void TransmissionValue(string v)
        {
            if (null != mTransmitter)
            {
                mTransmitter.AddValue(v);
            }
        }

        /// <summary>
        /// 结束一个传输
        /// </summary>
        public void EndTransmission()
        {
            if (null != mTransmitter)
            {
                mTransCache[mTransmitter.Name] = mTransmitter.Content;
            }
        }

        /// <summary>
        /// 发送一个命令
        /// </summary>
        public void SendQKCommand(string eventName)
        {
            if (mTransCache.ContainsKey(eventName))// 缓存里有该事件的数据
            {
                // 读取数据，创建命令对象
                QKCommand cmd = new QKCommand(eventName);
                
                foreach(KeyValuePair<string,string> kv in mTransCache[eventName])
                {
                    cmd.AddParam(kv.Key, kv.Value);
                }
                
                // 发送命令
                cmd.Send();
                mTransCache.Remove(eventName); // 清除使用过的数据

                //  返回命令的返回信息
                BeginTransToTerminal(cmd.Name);// 开始一个传输任务
                foreach(KeyValuePair<string,object> kv in cmd.Returns)
                {
                    TransToTerminal(cmd.Name, kv.Key, kv.Value as string);
                }
                EndTransToTerminal(cmd.Name); // 结束一个传输任务
            }
        }

        /// <summary>
        /// 添加一个事件监听
        /// </summary>
        public void RegQKCommandListener(string eventName)
        {
            // 监听QKCommand
            QKCommand.RegListener(eventName, OnQKCommand);
        }

        /// <summary>
        /// 解除一个事件监听
        /// </summary>
        public void UnRegQKCommandListener(string eventName)
        {
            // 监听QKCommand
            QKCommand.UnRegListener(eventName, OnQKCommand);
        }

        #region 抽象方法

        /// <summary>
        /// 初始化
        /// </summary>
        public abstract void Init();

        /// <summary>
        /// 开始一个传输
        /// </summary>
        protected abstract void BeginTransToTerminal(string transName);

        /// <summary>
        /// 传输数据
        /// </summary>
        /// <param name="transName">传输名</param>
        /// <param name="k">键</param>
        /// <param name="v">值</param>
        protected abstract void TransToTerminal(string transName, string k, string v);

        /// <summary>
        /// 结束一个传输任务
        /// </summary>
        protected abstract void EndTransToTerminal(string transName);

        /// <summary>
        /// QKSDK命令
        /// </summary>
        protected abstract void TerminalDoQKCommand(string transName);

        #endregion

        /// <summary>
        /// 当接收到监听的命令时
        /// </summary>
        protected void OnQKCommand(QKCommand cmd)
        {
            BeginTransToTerminal(cmd.Name);// 开始传送数据
            // 传送所有的参数
            foreach (KeyValuePair<string, object> kv in cmd.Params)
            {
                TransToTerminal(cmd.Name, kv.Key, kv.Value as string);
            }
            EndTransToTerminal(cmd.Name);// 传送数据结束

            // 执行命令
            TerminalDoQKCommand(cmd.Name);

            if (mTransCache.ContainsKey(cmd.Name))// 是否有返回
            {

                foreach (KeyValuePair<string, string> kv in mTransCache[cmd.Name])
                {
                    cmd.AddReturn(kv.Key, kv.Value);
                }
            }
        }

        /// <summary>
        /// 传输器
        /// </summary>
        DataTransmitter mTransmitter = null;

        /// <summary>
        /// 传输的数据缓存
        /// </summary>
        Dictionary<string, Dictionary<string, string>> mTransCache = new Dictionary<string, Dictionary<string, string>>();
    }
}
