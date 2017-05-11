using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OOSync
{
    public class OOSyncClient : MonoEX.Singleton<OOSyncClient>
    {
        /// <summary>
        /// 执行封包分发
        /// </summary>
        /// <returns></returns>
        public bool DoDispatcher(QK_JsonValue_Map doc)
        {
            if (null == doc) return false;
            if ("_Sync" != doc.StrValue("n")) return false;//这不是一个同步包
            uint sid = uint.Parse(doc.StrValue("sid"));
            string tm = doc.StrValue("tm");
            if (tm == null) return false;
            DateTime svrTime = DateTime.FromFileTime(long.Parse(tm));//服务器的当前时间

            var svrNode = UpdateSvrTime(sid, svrTime);//服务器时间刷新到本地内存

            QK_JsonValue_Array paths = doc["o"] as QK_JsonValue_Array;
            if (paths == null) return false;//不是正确的同步消息

            foreach (KeyValuePair<string, QK_JsonValue> kvpath in paths)
            {
                var objs = kvpath.Value as QK_JsonValue_Array;
                if (objs == null) continue;//错误的协议

                var path = kvpath.Key;

                //获取本路径对应的对象
                var pathObj = GetObject(sid, path, true);

                foreach (KeyValuePair<string, QK_JsonValue> kvobj in objs)
                {
                    QK_JsonValue_Map objInfo = kvobj.Value as QK_JsonValue_Map;
                    if (objInfo == null) return false;

                    //取得对象id 
                    string name = objInfo.StrValue("n");
                    SyncObj currObj = pathObj.GetChild(name);

                    if (objInfo["d"] != null) //本对象被删除 
                        pathObj.RemoveChild(name);
                    else //变更属性
                    {
                        QK_JsonValue_Array mNode = objInfo["m"] as QK_JsonValue_Array;
                        if (mNode != null) //存在属性
                        {
                            foreach (KeyValuePair<string, QK_JsonValue> currkv in mNode)
                            {
                                string attName = currkv.Key;
                                QK_JsonValue_Str attValue_json = currkv.Value as QK_JsonValue_Str;
                                if (attValue_json == null) continue;

                                string attValue = (string)attValue_json;

                                currObj.SetValue(attName, attValue); 
                            }
                        }
                    }
                }//end  foreach (KeyValuePair<string, QK_JsonValue> kvobj in objs)
            }//end foreach (KeyValuePair<string, QK_JsonValue> kvpath in paths)

            return true;
        }

        internal void PostEvent(SyncObj obj,string attrName)
        {
            //精确绑定的事件
            {
                QKEvent evt = GetValueChangedEvent(obj.sid, obj.Path, attrName);
                if (evt != null) evt.Call(attrName);
            }

            //模糊绑定的事件
            {
                var evts = GetValueChangedEvents(obj.sid, obj.Path);
                if (evts!=null)
                foreach (var evtkv in evts)
                {
                    var kvAttrName = evtkv.Key;
                    var evt = evtkv.Value;
                    if (kvAttrName==""&&evt != null) evt.Call(attrName);
                }
            }

            //同时监听子对象的事件
            {
                var fullPath = obj.Path + "@" + attrName; 
                var path = obj.Path;
                do{
                    var evts = GetValueChangedEvents(obj.sid, path);
                    if (evts != null)
                    foreach (var evtkv in evts)
                    {
                        var kvAttrName = evtkv.Key;
                        var evt = evtkv.Value;
                        if (kvAttrName == "*" && evt != null) evt.Call(fullPath);
                    }

                    if (path == "") 
                        path = null;
                    else
                    {
                        int idx = path.LastIndexOf('/');
                        if (idx < 0) 
                            path = "";
                        else
                            path = path.Substring(0, idx);
                    }
                } while(path!=null);
            }
        }


        
         
        public SyncObj GetObject(uint sid, string objPath,bool autoCreate)
        { 
            if (!m_Objs.ContainsKey(sid)) return null;


            var pathObj = m_Objs[sid].RootObj;
            if (objPath != "")
            {
                var pNames = objPath.Split('/');
                for (int i = 0; i < pNames.Length; i++)
                {
                    pathObj = pathObj.GetChild(pNames[i], autoCreate);
                    if (pathObj == null) return null;
                }
            }
            return pathObj;
        } 

        /// <summary>
        /// 绑定值改变事件
        /// </summary>
        public void BindValueChangedEvent(uint sid, string objPath, string attrName, IEventCallback callBack)
        {
            if (!m_ValueChangedEvents.ContainsKey(sid))
                m_ValueChangedEvents.Add(sid, new Dictionary<string, Dictionary<string, QKEvent>>());

            var l1 = m_ValueChangedEvents[sid];
            if (!l1.ContainsKey(objPath))
                l1.Add(objPath, new Dictionary<string, QKEvent>());

            var l2 = l1[objPath];
            if (!l2.ContainsKey(attrName))
                l2.Add(attrName, new QKEvent());

            l2[attrName].AddCallback(callBack);
        }

        public void RemoveValueChangedEvent(uint sid, string objPath, string attrName, IEventCallback callBack)
        {
            if (!m_ValueChangedEvents.ContainsKey(sid)) return;

             var l1 = m_ValueChangedEvents[sid];
             if (!l1.ContainsKey(objPath)) return;

             var l2 = l1[objPath];
              if (!l2.ContainsKey(attrName)) return;

              l2[attrName].RemoveCallback(callBack);

              if (!l2[attrName].HasCallback)
              {
                  l2[attrName].Dispose();

                  l2.Remove(attrName);
                  if (l2.Count < 1)
                  {
                      l1.Remove(objPath);

                      if (l1.Count < 1) m_ValueChangedEvents.Remove(sid);
                  }
              }
        }

        //清除某属性绑定的所有事件
        public void RemoveValueChangedEvent(uint sid, string objPath)
        {
            if (!m_ValueChangedEvents.ContainsKey(sid)) return;

            var l1 = m_ValueChangedEvents[sid];
            if (!l1.ContainsKey(objPath)) return;

            var l2 = l1[objPath];

            foreach (var kv in l2)
            {
                var attrName = kv.Key;
                l2[attrName].Dispose();

            }


            l2.Clear();
            l1.Remove(objPath);

            if (l1.Count < 1) m_ValueChangedEvents.Remove(sid);
        }

        public QKEvent GetValueChangedEvent(uint sid, string objPath, string attrName)
        {
            if (!m_ValueChangedEvents.ContainsKey(sid)) return null;

            var l1 = m_ValueChangedEvents[sid];
            if (!l1.ContainsKey(objPath)) return null;

            var l2 = l1[objPath];
            if (!l2.ContainsKey(attrName)) return null;

            return l2[attrName];
        }

        Dictionary<string, QKEvent> GetValueChangedEvents(uint sid, string objPath )
        {
            if (!m_ValueChangedEvents.ContainsKey(sid)) return null;

            var l1 = m_ValueChangedEvents[sid];
            if (!l1.ContainsKey(objPath)) return null;

            return l1[objPath];;
        }

        //Dictionary<sid, Dictionary<objid, Dictionary<attrName, QKEvent>>>
        Dictionary<uint, Dictionary<string, Dictionary<string, QKEvent>>> m_ValueChangedEvents = new Dictionary<uint, Dictionary<string, Dictionary<string, QKEvent>>>();

        public void Clean()
        {
            /*
            foreach (var kv in m_Objs)
            {
               // var sid = kv.Key;
                //foreach (var obj in kv.Value.ObjectList)
                //{
                //    var objid = obj.Key;
                //    RemoveValueChangedEvent(sid, objid);//移除事件绑定
                //}
            }*/

            m_Objs.Clear();
        }

        /*
        void RemoveObject(uint sid, long objid)
        {
            RemoveValueChangedEvent(sid, objid);//移除事件绑定
            if (!m_Objs.ContainsKey(sid)) return;

            var l1=m_Objs[sid];
            if (!l1.ObjectList.ContainsKey(objid)) return;

            var obj = l1.ObjectList[objid];
            l1.ObjectList.Remove(objid);

            //清子对象
            var count = obj.ChildCount;
            for (var i = 0; i < count; i++)
                RemoveObject(sid, obj.GetChild(i).ID);
        }
        */
        /*
        internal SyncObj CreateObject(uint sid,long id,string tag)
        {
            SyncObj re = new SyncObj(sid, id, tag);
            if(!m_Objs.ContainsKey(sid)) m_Objs.Add(sid,new SvrNodeData());
            m_Objs[sid].ObjectList.Add(id, re);
            return re;
        }*/

        internal SvrNodeData UpdateSvrTime(uint sid, DateTime svrTime)
        {
            if (!m_Objs.ContainsKey(sid)) m_Objs.Add(sid, new SvrNodeData(sid));
            m_Objs[sid].TimeDifferenceSecond = (svrTime - DateTime.Now).TotalSeconds;
            return m_Objs[sid];
        }

        internal DateTime ToSvrTime(uint sid,DateTime time) {
            return time.AddSeconds(m_Objs[sid].TimeDifferenceSecond);
        }

        /// <summary>
        /// 存储来自服务器一个节点的数据
        /// </summary>
        internal class SvrNodeData
        {
            public double TimeDifferenceSecond;//和服务器之间的时间差 服务器时间-本地时间
            public SyncObj RootObj;
            public readonly uint sid;
            public SvrNodeData(uint sid)
            {
                this.sid = sid;
                Reset();
            }

            public void Reset()
            {
                RootObj = new SyncObj(sid);
            }
                //Dictionary<long, SyncObj> ObjectList = new Dictionary<long, SyncObj>();
        }

        internal SyncObj GetRootObj(byte sid) { return m_Objs.ContainsKey(sid) ? m_Objs[sid].RootObj : null; }

        Dictionary<uint, SvrNodeData> m_Objs = new Dictionary<uint, SvrNodeData>();
    }
}
