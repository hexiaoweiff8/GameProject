using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;
/// <summary>
/// 显示控制器
/// </summary>
interface I_DesplayController
{
    void Update(float lostTime);//更新

    void OnKeyChanged(DP_Key newKey);//帧改变

    void SetAlpha(float v);//设置透明度

    void SetBrightness(float v);//设置亮度

    void Destroy();

    void OnUISet3DPos(Vector3 pos3d);

    void OnEnable();

    float DirX { get; }
     
}

class DesplayController_Effect: I_DesplayController
{
    public DesplayController_Effect(GameObject gameObject,EffectResources res)
    { 
        this.gameObject = gameObject;
        m_Res = res;
        m_DirX = m_Res.dirx;
     }
    public void Update(float lostTime) { }

    public void OnKeyChanged(DP_Key newKey) {
        if(newKey.KeyType== DPKeyType.Reset)
        {
            ClearTrail();
        }
    }

    void ClearTrail()
    {
        var cms = this.gameObject.GetComponentsInChildren<TrailRenderer>();
        int len = cms.Length;

        //清一下拖尾
        for (int i = 0; i < len; i++)
            cms[i].Clear();  
    }

    public void SetAlpha(float v) { }

    public void SetBrightness(float v) { }
    public void Destroy()
    { }

    public float DirX { get { return m_DirX; } }

    public void OnUISet3DPos(Vector3 pos3d) { }

    public void OnEnable()
    {
        ClearTrail();
    }


    GameObject gameObject;
    EffectResources m_Res;
    float m_DirX;
}

/*
class DesplayController_Gongjian : I_DesplayController
{
    public DesplayController_Gongjian(GameObject gameObject,GongJianResources res)
    {
        this.gameObject = gameObject;
        m_Res = res;
    }
    public void Update(float lostTime) { }

    public void OnKeyChanged(DP_Key newKey) { }

    public void SetAlpha(float v) { }

    public void SetBrightness(float v) { }
    public void Destroy()
    { }

    public void OnEnable()
    {
        var cms = this.gameObject.GetComponentsInChildren<TrailRenderer>();
        int len = cms.Length;

        //激活的时候清一下拖尾
        for (int i = 0; i < len; i++) cms[i].Clear();
    }


    public float DirX { get { return m_Res.IsDirRight ? 1 : -1; } }

    public void OnUISet3DPos(Vector3 pos3d) { }
    GameObject gameObject;
    GongJianResources m_Res;
}*/


class Dir2Rotation
{
    //根据朝向获取角色旋转角度
    public static Quaternion Radian2ActRot(float dirx, float dirz)
    {
        float radian = AI_Math.Dir2Radian(dirx, dirz);
        int idx;
        if (radian < 2.61799387799149)//150
        {
            if (radian < 0.523598775598299)//30
                idx = 0;
            else if (radian < 1.5707963267949) //90
                idx = 1;
            else
                idx = 2;  //150
        }
        else
        {
            if (radian < 3.66519142918809) //210
                idx = 3;
            else if (radian < 4.71238898038469)//270
                idx = 4;
            else if (radian < 5.75958653158129) //330
                idx = 5;
            else
                idx = 0; //30
        }

        return rotations[idx];
    }
    static Quaternion[] rotations = new Quaternion[]{ 
                     Quaternion.Euler(0,  90, 0),
                        Quaternion.Euler(0, 30, 0),
                        Quaternion.Euler(0, 330, 0),
                        Quaternion.Euler(0, 270, 0),
                        Quaternion.Euler(0, 210, 0),
                        Quaternion.Euler(0, 150, 0),
                    };
}

/*
class DesplayController_Buff : I_DesplayController
{
    public DesplayController_Buff(GameObject gameObject, Texture texture, AIDirection dir, bool scaleAnimation, float liveTime)
    {
        cmAvatarAnimator = gameObject.GetComponent<AvatarAnimator_Manual>();
        cmAvatarAnimator.texture = texture;//设置纹理 
        if(scaleAnimation)
        {
            m_isLoop = false;
            animationSpeedScale = cmAvatarAnimator.GetClipLength("wait") / liveTime;
        }
        else
        {
            m_isLoop = true;
            animationSpeedScale = 1;
        }
      
        cmAvatarAnimator.flip = dir == AIDirection.Right ? Flip.Nothing : Flip.Horizontally;
         
                 
    }

    public void Update(float lostTime)
    {
        this.lostTime += lostTime * animationSpeedScale;
        cmAvatarAnimator.ManualPlayByTime("wait", this.lostTime, m_isLoop);
    }
     

    public void OnKeyChanged(DP_Key newKey)
    { 
        switch (newKey.KeyType)
        {
            case DPKeyType.MoveTo://移动到
                {
                    DPKey_MoveTo hKey = newKey as DPKey_MoveTo;
                     
                    //设置朝向
                    float cz = hKey.m_tox - hKey.m_fromx;

                    if (cz!=0)
                    cmAvatarAnimator.flip = cz > 0 ? Flip.Nothing : Flip.Horizontally;
                }
                break; 
        }; 

    }

    bool m_isLoop = true; 
    float animationSpeedScale;
    float lostTime = 0;//逝去时间
    AvatarAnimator_Manual cmAvatarAnimator = null;//动画组件
}

/// <summary>
/// 特效显示控制器
/// </summary>
class DesplayController_Texiao : I_DesplayController
{
    public DesplayController_Texiao(GameObject gameObject, Texture texture, AIDirection dir, bool scaleAnimation,float liveTime)
    {
        cmAvatarAnimator = gameObject.GetComponent<AvatarAnimator_Manual>();
        cmAvatarAnimator.texture = texture;//设置纹理 
        if(scaleAnimation)
        {
            m_isLoop = false;
            animationSpeedScale = cmAvatarAnimator.GetClipLength("wait") / liveTime;
        }
        else
        {
            m_isLoop = true;
            animationSpeedScale = 1;
        }
      
        cmAvatarAnimator.flip = dir == AIDirection.Right ? Flip.Nothing : Flip.Horizontally;
         
                 
    }

    public void Update(float lostTime)
    {
        this.lostTime += lostTime * animationSpeedScale;
        cmAvatarAnimator.ManualPlayByTime("wait", this.lostTime, m_isLoop);
    }
     

    public void OnKeyChanged(DP_Key newKey)
    { 

    }

    bool m_isLoop = true; 
    float animationSpeedScale;
    float lostTime = 0;//逝去时间
    AvatarAnimator_Manual cmAvatarAnimator = null;//动画组件
}
*/