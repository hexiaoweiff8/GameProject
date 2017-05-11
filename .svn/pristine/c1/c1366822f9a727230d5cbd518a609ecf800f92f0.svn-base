//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using UnityEngine;

//public class CMHttpSession:MonoBehaviour
//{
//    public CMHttpSession()
//    {
//        mSession.onDisconnected += OnDisconnected;
//        mSession.onMsg += OnMsg;
//        mSession.onBin += OnBin;
//    }

//    public HttpLoader CreateLoader(string url,QK_JsonValue_Map msg,byte flag)
//    {
//        return new HttpLoader(mSession, url, msg, flag);
//    }

//    public void Close()
//    {
//        if (!mSession.isDel) mSession.SetDel();

//        ReCreateConn(); 
//    }

//    public HttpSession Handle { get { return mSession; } }

//    void OnDisconnected()
//    {
//        ReCreateConn();
//        if (onDisconnected != null) onDisconnected();
//    }

//    void ReCreateConn()
//    {

//        mSession.onDisconnected -= OnDisconnected;
//        mSession.onMsg -= OnMsg;
//        mSession.onBin -= OnBin;

//        mSession = new HttpSession();

//        mSession.onDisconnected += OnDisconnected;
//        mSession.onMsg += OnMsg;
//        mSession.onBin += OnBin;
//    }


//    void OnMsg(QK_JsonValue_Map jsonDoc)
//    {
//        if (onMsg != null) onMsg(jsonDoc);
//    }

//    void OnBin(byte[] bin)
//    {
//        if (onBin != null) onBin(bin);
//    }

//    public event HttpSession.OnDisconnected onDisconnected;
//    public event HttpSession.OnMsg onMsg;
//    public event HttpSession.OnBin onBin;

//    HttpSession mSession = new HttpSession();
   
//} 