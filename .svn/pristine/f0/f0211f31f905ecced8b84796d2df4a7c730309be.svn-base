using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;
[AddComponentMenu("QK/PseudoPhysics/ShakeManage")]
public class ShakeManage : MonoBehaviour
{
    public ShakeObject mShakeObject;

    void Awake()
    {
        m_ShakeCurves = GetComponents<ShakeCurve>();
    }

    public Tweener Shake(string tag, float duration)
    {
        foreach (ShakeCurve curr in m_ShakeCurves)
        {
            if (curr.tag == tag) 
               return mShakeObject.Shake(curr, duration); 
        }
        return null;
    }

    ShakeCurve[] m_ShakeCurves;
}