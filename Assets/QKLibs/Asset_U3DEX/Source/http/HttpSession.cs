//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Collections;
//using MonoEX;
//using UnityEngine;

//public class HttpSession
//{
//    public string uid="";
//    public uint num = 1;//当前序号
//    public bool isDel {
//        get { return _isDel; }
       
//    }

//    public void SetDel()
//    {
//        if (_isDel) return;
//        _isDel = true;

//        if (onDisconnected!=null)
//        onDisconnected();
//    }

//    public void DoMsg(QK_JsonValue_Map msg)
//    {
//        if (onMsg != null) onMsg(msg);
//    }

//    public void DoBin(byte[] bin)
//    {
//        if (onBin != null) onBin(bin);
//    }

//    public event OnDisconnected onDisconnected;
//    public event OnMsg onMsg;
//    public event OnBin onBin;
//    public delegate void OnDisconnected();
//    public delegate void OnMsg(QK_JsonValue_Map msg);
//    public delegate void OnBin(byte[] bin);

//    bool _isDel = false;//是否已经被删除
//}

//public class HttpLoader
//{
//    public HttpLoader(HttpSession ownerSession, string url, QK_JsonValue_Map msg, byte flag)
//    {
//        Send(ownerSession, url, msg, flag);
//    }

//    /*
//    public   HttpLoader(HttpSession ownerSession, string url, byte[] msg, int flag, uint num)
//    {
//        Send(ownerSession, url, msg, flag, num);
//    }*/

//    void Send(HttpSession ownerSession, string url, QK_JsonValue_Map msg, byte flag)
//    {
//        uint num = ownerSession.num++;
//        Send(ownerSession,url, msg, flag, num);
//    }

//    void Send(HttpSession ownerSession, string url, QK_JsonValue_Map msg, byte flag, uint num)
//    {
//        if (m_CODoing) return;

//        m_CODoing = true;
//        CoroutineManage.Single.StartCoroutine(coSend( ownerSession, url,msg, flag, num));
//    }

//    IEnumerator coSend(HttpSession ownerSession, string url, QK_JsonValue_Map msg, byte flag, uint num)
//    {
//        for (int reTry = 0; reTry < 3; reTry++)
//        {
//            //WWWForm wform = new WWWForm();
//            //wform.AddField("msg", msg);
//            //wform.AddField("flag", flag);
//            //wform.AddField("num", num.ToString());
//            //wform.AddField("uid", ownerSession.uid); 
//            byte[] postData; HttpNM.EncodedExternal(string.IsNullOrEmpty(ownerSession.uid) ? "" : ownerSession.uid, msg, flag, out postData, num);
//            WWW www = new WWW(url, postData);
//            while (!www.isDone && string.IsNullOrEmpty(www.error))
//            {
//                if (ownerSession.isDel)
//                {
//                    SetError(ownerSession);

//                    yield break;
//                }
//                yield return null;
//            }

//            if (string.IsNullOrEmpty(www.error)) //没有产生错误
//            {
//                byte tmpflag;
//                uint tmpnum;
//                QK_JsonValue_Map jsonDoc;
//                byte[] buff;
//                string uid;
//                HttpNM.DecodeExternal(www.bytes, out uid, out buff, out jsonDoc, out tmpnum, out tmpflag);

//                if (jsonDoc != null)
//                {
//                    var retv = jsonDoc["ret"] as QK_JsonValue_Str;
//                    if (retv != null) //发生了错误
//                    {
//                        var strret = (string)retv;
//                        switch (strret)
//                        {
//                            //不可重试的错误
//                            case "99"://未知错误
//                            case "3"://上下文丢失
//                            case "4"://上行包格式错误
//                                {
//                                    SetError(ownerSession);
//                                    yield break;
//                                }
//                        }
//                    }
//                }
//                else
//                {
//                    if (string.IsNullOrEmpty(ownerSession.uid)) ownerSession.uid = uid;

//                    ByteArray ba = new ByteArray(buff);
//                    byte _nmtp; ba.ReadByte(out _nmtp);
//                    NMType nmtp = (NMType)_nmtp;
//                    byte[] msgbuff; ba.ReadBytes(out msgbuff);
//                    int notifyCount = 0; ba.ReadInt(out notifyCount);
//                    for (int i = 0; i < notifyCount; i++)
//                    {
//                        byte _ntp; ba.ReadByte(out _ntp);
//                        NMType ntp = (NMType)_ntp;
//                        byte[] nmsgbuff; ba.ReadBytes(out nmsgbuff);
//                        if (ntp == NMType.json)
//                        {
//                            QK_JsonValue_Map jsonMsgDoc = new QK_JsonValue_Map();
//                            jsonMsgDoc.Parse(Encoding.UTF8.GetString(nmsgbuff));
//                            ownerSession.DoMsg(jsonMsgDoc);
//                        }
//                        else
//                            ownerSession.DoBin(nmsgbuff);

//                    }

//                    if (nmtp == NMType.json)
//                    {
//                        Result = new QK_JsonValue_Map();
//                        Result.Parse(Encoding.UTF8.GetString(msgbuff));
//                        yield break;
//                    }
//                }

//            }//end if(string.IsNullOrEmpty

//            for (int i = 0; i < 50; i++) yield return null;//等待一段时间
//        }

//        SetError(ownerSession);
//    }

//    void SetError(HttpSession ownerSession)
//    {
//        HasError = true;
//        ownerSession.SetDel();
//    }
//    public bool IsDone { get { return Result != null || HasError; } }

//   // public byte[] Result_Bin = null;
//    public QK_JsonValue_Map Result = null;
//    public bool HasError = false;
//    bool m_CODoing = false;
//}