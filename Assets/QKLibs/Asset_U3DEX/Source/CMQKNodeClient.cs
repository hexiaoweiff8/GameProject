using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX; 
using UnityEngine;


public class CMQKNodeClient : MonoBehaviour
{ 
    public readonly QKNodeClient ClientHandel = new QKNodeClient();
    /*
    void OnEnable() { CoroutineManage.Single.RegComponentUpdate(IUpdate); }
 */
    void OnDestroy()
    {
       // CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
        ClientHandel.Dispose();
    } 
   
    void Update()
    {
        ClientHandel.Update();
    } 
}
