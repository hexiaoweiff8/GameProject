using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public interface I_AAttr
{
    float addBFB { get; } 
    float addV { get; } 
    void JV(int v); 
    void SetV(int v); 
    void JAddBFB(float v);
    void SetAddBFB(float v); 
    void JAddV(float v);
    void SetAddV(float v); 
    float ToFloat();

    float AddV { get; }
    float AddBFB { get; }

    float BaseV { get; }
}




public class AAttr : I_AAttr
{
    int _v;//当前值 
    float _addBFB;//增加的百分比 
    float _addV;//增加的数值 
    uint _v1;//当前值 
    uint _addBFB1;//增加的百分比 
    uint _addV1;//增加的数值 
    uint _v2;//当前值 
    uint _addBFB2;//增加的百分比 
    uint _addV2;//增加的数值 

    public float addBFB
    {
        get { return _addBFB; }
    }

    public  float   addV{
        get { return _addV; }
    }

    public AAttr()
    {
        _SetV(0);
        _SetAddBFB(0);
        _SetAddV(0);
    }

    public void JV(int v)
    {
        SetV(_v + v);
    }

    public   void SetV(int v)
    {
        CheckV();
        _SetV(v);
    }

    void _SetV(int v)
		{
			_v = v;
			_v1 = (uint)v&1983;
			_v2 = (uint)v^419;
		}

    public void JAddBFB(float v)
    {
        SetAddBFB(_addBFB + v);
    }

    public void SetAddBFB(float v)
    {
        CheckV();
        _SetAddBFB(v);
    }

    void _SetAddBFB(float v)
    {
        _addBFB = v;
        _addBFB1 = (uint)(int)(v * 10) ^ 943;
        _addBFB2 = (uint)(int)(v * 10) & 9991;
    }


    public void JAddV(float v)
    {
        SetAddV(_addV + v);
    }

    public void SetAddV(float v)
    {
        CheckV();
        _SetAddV(v);
    }

    void _SetAddV(float v)
    {
        _addV = v;
        _addV1 = (uint)(int)v & 2014;
        _addV2 = (uint)(int)v & 12234;
    }


    public void CheckV()
    {
        uint cv1 = ((uint)_v & 1983);
        uint cv2 = ((uint)_v ^ 419);
        bool re = (
           (cv1 == _v1) &&
           (cv2 == _v2)
       );

        if (!re)
        {
            throw new Exception("X WaiGua!!!");
        }
    }

    public float ToFloat()
    {
        return Math.Max((float)((_v + _addV) * (1.0f + _addBFB)), 0.0f);
    }


    public float AddV { get { return _addV; } }
    public float AddBFB { get { return _addBFB; } }


    public float BaseV { get { return _v; } }
}



public class AAttrLight : I_AAttr
{
    int _v;//当前值 
    float _addBFB;//增加的百分比 
    float _addV;//增加的数值 
    
    public float addBFB
    {
        get { return _addBFB; }
    }

    public float addV
    {
        get { return _addV; }
    }

    public AAttrLight()
    {
        _v = 0;
        _addBFB = 0;
        _addV = 0; 
    }

    public void JV(int v)
    {
        SetV(_v + v);
    }

    public void SetV(int v)
    { 
        _v = v; 
    }

  
    public void JAddBFB(float v)
    {
        SetAddBFB(_addBFB + v);
    }

    public void SetAddBFB(float v)
    { 
        _addBFB = v;
    }
     

    public void JAddV(float v)
    {
        SetAddV(_addV + v);
    }

    public void SetAddV(float v)
    {
        _addV = v; 
    }
     

    
    public float ToFloat()
    {
        return Math.Max((float)((_v + _addV) * (1.0f + _addBFB)), 0.0f);
    }



    public float AddV { get { return _addV; } }
    public float AddBFB { get { return _addBFB; } }

    public float BaseV { get { return _v; } }
}
