using System;
public class AI_Math
{

    public const float MapScale = 1.0f;//地图比例尺

    public static float V2Distance(float x1,float z1,float x2,float z2)
    {
        float tx = x1 - x2;
        float tz = z1 - z2;

        return (float)Math.Sqrt(tx * tx + tz * tz);
    }
} 
