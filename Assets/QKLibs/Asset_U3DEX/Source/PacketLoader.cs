using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEngine;
using System.Collections;

//资源包装载器
public class PacketLoader //: IPacketLoadingListener
{
    public enum ResultEnum
    {
        wait,
        Error,
        Done,
        Loading
    }

   

    public void Start(PackType pkType,List<string> packetList, Action<bool> DoneEvent)
    {
        if (m_Result != ResultEnum.wait) { if (DoneEvent != null) DoneEvent(false); return; }

        {
            m_waitPackets.Clear();
            foreach (string curr in packetList)
            {
                string packname = curr;
                m_waitPackets.Add(packname);
                m_LoadingProgress.Add(packname, 0.0f);
            }
        }

        m_Result = ResultEnum.Loading;
         
        if (m_waitPackets.Count < 1) //没有需要装载的
        {
            m_Result = ResultEnum.Done;
            if (DoneEvent != null) DoneEvent(true); 
        }
        else
        {
            foreach (string packeName in m_waitPackets)
            { 
                m_packets.Add(packeName);
                PacketManage.Single.LoadPacket(pkType, packeName,
                    (packetName, bundle) => OnPacketLoadDone(packetName, bundle, DoneEvent),
                    OnPacketLoadingProgress
                    );
            }
            m_waitPackets.Clear();

            OnPacketLoadDone("", null, DoneEvent);
        }
    }

    //包 装载完成通知
    public void OnPacketLoadDone(string packetName, PacketRouting bundle, Action<bool> DoneEvent)
    {
        m_packets.Remove(packetName); 
        if (m_Result == ResultEnum.Error) return;

        if (!string.IsNullOrEmpty( packetName)&&bundle == null)
        {  
            m_Result = ResultEnum.Error;
            if (DoneEvent != null) DoneEvent(false); 
        }

        if (m_packets.Count <= 0 && m_waitPackets.Count<=0)
        {
            if (m_LoadingProgress.ContainsKey(packetName))
            {
                m_LoadingProgress[packetName] = 1.0f;//该包装载进度100%
            } 
            m_Result = ResultEnum.Done;
            if (DoneEvent != null) DoneEvent(true); 
        }
    }

    public IEnumerator Wait()
    {
        while (Result != ResultEnum.Done)
        {
            if (Result == ResultEnum.Error) throw new Exception(); 
            yield return null;
        } 
    } 

    //包 装载进度通知
    public void OnPacketLoadingProgress(string packetName, float progress)
    {
        if (m_LoadingProgress.ContainsKey(packetName))
        {
            m_LoadingProgress[packetName] = progress;//设置装载进度
        }
        //ULDebug.Log(String.Format("{0} {1}%", packetName, progress));
    }

    public float Progress
    {
        get
        {
            if(m_LoadingProgress.Count==0) return 1.0f;

            float count = 1.0f/(float)m_LoadingProgress.Count;
            float re = 0;
            foreach (KeyValuePair<string, float> curr in m_LoadingProgress)
            {
                re += curr.Value * count;
            }
            return re;
        }
    }

    public ResultEnum Result { get { return m_Result; } }
    Dictionary<string, float> m_LoadingProgress = new Dictionary<string, float>();    
    HashSet<string> m_packets = new HashSet<string>();
    ResultEnum m_Result = ResultEnum.wait;
    List<string> m_waitPackets = new List<string>();
} 