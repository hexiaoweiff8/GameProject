using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class YQ2AABBBox2D
{
    public float minx;
    public float minz;
    public float maxx;
    public float maxz;

    public YQ2AABBBox2D(float minx, float minz, float maxx, float maxz)
    {
        this.minx = minx;
        this.minz = minz;
        this.maxx = maxx;
        this.maxz = maxz;
    }

    public void GetCenter(out float x,out float z)
    {
        x = minx + (maxx - minx) / 2;
        z = minz + (maxz - minz) / 2;
    }

    public bool Contains(float x, float z)
    {
        return x >= minx && x <= maxx && z >= minz && z <= maxz;
    }

    public float Distance(float x, float z)
    {
       return Distance(  minx,  minz,  maxx,  maxz ,  x,   z);
    }

    public static float Distance(float minx,float minz,float maxx,float maxz ,float x, float z)
    {
        if (minx <= x && maxx >= x)
        {
            if (z < minz)
                return minz - z;
            else if (z > maxz)
                return z - maxz;
            else
                return 0;//在包围盒内部
        }
        else if (minz <= z && maxz >= z)
        {
            if (x < minx)
                return minx - x;
            else if (x > maxx)
                return x - maxx;
            else
                return 0;//在包围盒内部
        }
        else //垂线无法测算距离
        {
            //取得包围盒4个点中最近的一个点
            float px = x > maxx ? maxx : minx;
            float pz = z > maxz ? maxz : minz;

            return AI_Math.V2Distance(px, pz, x, z);
        }
    }

    public bool Intersect(YQ2AABBBox2D box2)//,AABB boxIntersect
    {
        if (minx > box2.maxx ||
            maxx < box2.minx ||
            minz > box2.maxz ||
            maxz < box2.minz
            ) return false;
        /*
        if (boxIntersect != null)
        {
            float[] box_intersect_min = new float[3];
            float[] box_intersect_max = new float[3];
            box_intersect_min[0] = Math.max(min[0], box2_min[0]);
            box_intersect_max[0] = Math.min(max[0], box2_max[0]);
            box_intersect_min[1] = Math.max(min[1], box2_min[1]);
            box_intersect_max[1] = Math.min(max[1], box2_max[1]);
            box_intersect_min[2] = Math.max(min[2], box2_min[2]);
            box_intersect_max[2] = Math.min(max[2], box2_max[2]);
        }*/
        return true;
    }


    public YQ2AABBBox2D Clone() { return new YQ2AABBBox2D(minx, minz, maxx, maxz); }
}
