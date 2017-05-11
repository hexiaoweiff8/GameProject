using UnityEngine;
using System.Collections;
using System;

/// <summary>
/// 动画事件触发器
/// </summary>
[AddComponentMenu("QK/Event/AnimationEventsTrigger")]
public class AnimationEventsTrigger : MonoBehaviour {
    void CallEvent(string evtName)
    {
        if (OnCallEvent != null) 
            OnCallEvent( gameObject,evtName);
    } 
    public static Action<GameObject, string> OnCallEvent = null;
}
