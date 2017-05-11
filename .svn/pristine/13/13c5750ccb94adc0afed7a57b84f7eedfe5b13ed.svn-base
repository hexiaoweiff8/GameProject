using System;
using System.Collections.Generic;
using System.Linq;
using System.Text; 
namespace OOSync
{
    /// <summary>
    /// 同步对象
    /// </summary>
    public class SyncObj
    {
        internal SyncObj(uint sid)
        {
            this.sid = sid;
            this.Name = "";
            m_Parent = null;
        }

        public SyncObj(uint sid, SyncObj parent, string name)
        {   
            this.sid = sid;
            this.Name = name;
            m_Parent = parent;
        }

      
        public string GetValue(string attrName){
            if (!key_values.ContainsKey(attrName))  return null; 

            return key_values[attrName]; 
        }

        /// <summary>
        /// 属性是一个终点时间，取当前时间距离属性标识的终点时间还剩多少秒
        /// </summary>
        /// <param name="attrName"></param>
        /// <returns></returns>
        public long GetRemainingTime(string attrName)
        {
           DateTime endTime = DateTime.FromFileTime(long.Parse(key_values[attrName])); //服务器上的终止时间
           DateTime currTime = OOSyncClient.Single.ToSvrTime(sid, DateTime.Now);
           double t = (endTime - currTime).TotalSeconds - 1;
           return (long)t;
        }

         
        public int ChildCount { get { return m_childs.Count; } }

         

        //public long ID { get { return id; } }


        public void SetValue(string attrName, string value)
        {
            if (key_values.ContainsKey(attrName))
                key_values[attrName] = value;
            else
                key_values.Add(attrName, value);

            //抛出事件
            OOSyncClient.Single.PostEvent(this, attrName);
        }

        public SyncObj GetChild(string name,bool autoCreate = true)
        {
            if (HasChild(name)) return m_childs[name];
            if (!autoCreate) return null;//不允许自动创建，只能返回null

            var obj = new SyncObj(sid,this,name);
            m_childs.Add(name, obj);
            return obj;
        }

        public void Delete()
        {
            Parent.RemoveChild(this);
        }

        public void RemoveChild(SyncObj obj)
        {
            var n = obj.Name;
            if (!HasChild(n) || m_childs[n] != obj) return;
            RemoveChild(n);
        }

        public void RemoveChild(string name) { m_childs.Remove(name); }

        public bool HasChild(string name) { return m_childs.ContainsKey(name); }


        public string Path
        {
            get
            {
                //处理根对象
                if (Parent == null)
                    return  "";

                var p = Parent.Path;
                return p == null ? null : (p == "" ? Name : p + "/" + Name);
            }
        }
        public SyncObj Parent { get { return m_Parent; } }

        
        //long id;
        public readonly uint sid;
        public readonly string Name;

        SyncObj m_Parent;
        Dictionary<string, string> key_values = new Dictionary<string,string>();//键值对 

        internal Dictionary<string, SyncObj> m_childs = new Dictionary<string, SyncObj>();//子对象
    }

   
}
