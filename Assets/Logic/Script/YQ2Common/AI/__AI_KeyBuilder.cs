using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/*
class AI_KeyBuilder
{
    /// <summary>
    /// 帧序列
    /// </summary> 
    public static void Reset(float startTime,TexiaoKey[] keys, bool needFlip,float liveTime)
    {
        m_keys = keys;
        m_keyStartTime = 0;
        m_FromV = needFlip ? -keys[0].value : keys[0].value;
        i = 0;
        m_needFlip = needFlip;
        m_liveTime = liveTime;
        m_startTime = startTime;
    }

    public static bool BuildNext(out MakingUpFunc mfunc, out float startTime, out float fromV, out float toV, out float time)
    {
        if (i >= m_keys.Length)
        {
            mfunc = MakingUpFunc.Linear;
            startTime = fromV = toV = time = 0;
            return false;
        }

        TexiaoKey k = m_keys[i++];
        mfunc = k.func;
        startTime = m_startTime + m_keyStartTime * m_liveTime;
        fromV = m_FromV;
        toV = m_needFlip ? -k.value : k.value;
        time = (k.startTime - m_keyStartTime) * m_liveTime;//帧生命 
        m_keyStartTime = k.startTime;
        m_FromV = toV;
        return true;
    }

     
    static float m_FromV  ;
    static TexiaoKey[] m_keys;
    static float m_keyStartTime;
    static float m_liveTime;
    static bool m_needFlip;
    static float m_startTime;
    static int i;
} 
*/