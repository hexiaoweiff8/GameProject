using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class DP_TweenFuncs
{
    //加速浮点补间函数 
    public static float Tween_Accelerated_Float(float startV, float endV, float t)
    {
        if (t > 1) t = 1;
        return startV + (endV - startV) * (float)Math.Pow(t, 2.0f);
    }
    //减速浮点补间函数 
    public static float Tween_Deceleration_Float(float startV, float endV, float t)
    {
        if (t > 1) t = 1;
        return startV + (endV - startV) * (float)Math.Sqrt(t);
    }

    /// <summary>
    /// 线性浮点补间函数 
    /// </summary>
    /// <param name="startV"></param>
    /// <param name="endV"></param>
    /// <param name="t"></param>
    /// <returns></returns>
    public static float Tween_Linear_Float(float startV, float endV, float t)
    {
        if (t > 1) t = 1;
        return startV + (endV - startV) * t;
    }

}