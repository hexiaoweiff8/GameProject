using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class QKMath
{
    //球形插值
    public static float SLerp(float from, float to, float t)
    {
        t = (float)Math.IEEERemainder(t, 1.0f);
        return Mathf.Lerp(from, to, t);
    }


    public static bool Equals(float a,float b) { return Mathf.Abs( a-b)<PRECISION; }

    public const float PRECISION = 0.000001f;
}