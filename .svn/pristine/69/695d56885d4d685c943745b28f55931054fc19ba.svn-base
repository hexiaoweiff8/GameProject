using UnityEngine;
using System.Collections;

using DG.Tweening;

class DesplayController_BelowPanel : I_DesplayController
{
    //static int dyDepth = 5000000;
    public DesplayController_BelowPanel(
        Camera eyeCamera,
        Camera uiCamera,
        PosTrack2DManage m_PosTrack2DManage,
        BelowPanelResources res, GameObject gameObject)
    {
        this.gameObject = gameObject;

        m_PosTrack2D = new PosTrack2D();
        m_PosTrack2D.Obj2D = gameObject;

        float dirx;Transform tr; DP_BattlefieldDraw.Single.GetActorTransfrom(res.HeroActorID,out tr,out dirx);
        m_PosTrack2D.Obj3D = tr.gameObject;
        m_PosTrack2D.Camera3D = eyeCamera;
        m_PosTrack2D.Camera2D = uiCamera;
        m_PosTrack2DManage.Add(m_PosTrack2D);

        GameObject powerObj = gameObject.transform.FindChild("power").gameObject;

        PowerBar = powerObj.GetComponent<UIProgressBar>();
        PowerBar.alpha = 0;//默认隐藏
        m_Res = res;
    }
    public void OnEnable() { }
    public void SetBrightness(float v)  {    }

    public void Update(float lostTime)
    {
        if (PowerHideTime > 0)
        {
            PowerHideTime -= lostTime;
            if (PowerHideTime <= 0)
            {
                //隐藏蓄力进度条
                if (tw != null) tw.Kill();
                tw = DOTween.To(() => PowerBar.alpha, (a) => PowerBar.alpha = a, 0, 0.3f)
                    .SetEase(Ease.Linear)//线性变化
                    .SetAutoKill(true)//渐隐
                    .OnKill(() => tw = null);

                if (m_Res.IsAttack)
                    wnd_fight.Single.LeftHeroPanel.YinchangFID(m_Res.Fid, 0);
            }
        }

        //DepthOffset = DP_BattlefieldDraw.Single.m_UIDepthOffset;
        //DP_BattlefieldDraw.Single.m_UIDepthOffset += 2;
    }

    //int DepthOffset;
    public void OnUISet3DPos(Vector3 pos3d)
    {
        //m_PosTrack2D.Pos = pos3d;
        /*
        float z = pos3d.z;
        if (!QKMath.Equals(z, lastz))
        {
            lastz = z;
            headSprite.depth = (int)(1000000 - z * 10 + DepthOffset);
            jtSprite.depth = headSprite.depth + 1;
        } */
    }

    public void OnKeyChanged(DP_Key newKey)
    {

        switch (newKey.KeyType)
        { 
            case DPKeyType.Yinchang://吟唱
                {
                    var hKey = newKey as DPKey_Yinchang;

                    if (hKey.len > 0)
                    {
                        //更改蓄力进度条值
                        if (twValue != null) twValue.Kill();

                        PowerBar.value = 0;
                        twValue = DOTween.To(() => PowerBar.value, (a) => PowerBar.value = a, 1,hKey.len)
                           .SetEase(Ease.Linear)
                           .SetAutoKill(true)
                           .OnKill(() => twValue = null);

                        //显示蓄力进度
                        if (tw != null) tw.Kill();
                        tw = DOTween.To(() => PowerBar.alpha, (a) => PowerBar.alpha = a, 1, 0.3f)
                            .SetEase(Ease.Linear)//线性变化
                            .SetAutoKill(true)//渐显
                            .OnKill(() => tw = null);

                        //更新蓄力进度条显示时间
                        PowerHideTime = hKey.len;

                        if (m_Res.IsAttack)
                            wnd_fight.Single.LeftHeroPanel.YinchangFID(m_Res.Fid, hKey.len);

                    } else //立即隐藏进度条
                    {
                        if (tw != null) { tw.Kill(); tw = null; }
                        if (twValue != null) { twValue.Kill(); twValue = null; }
                        PowerHideTime = 0.1f;

                        if (m_Res.IsAttack)
                            wnd_fight.Single.LeftHeroPanel.YinchangFID(m_Res.Fid, 0,true);
                    }
                }
                break; 
           
        }

    }

    public void SetAlpha(float v) { PowerBar.alpha = v; }

    public void Destroy()
    {
        if (tw != null) { tw.Kill(); tw = null; }
        if (twValue != null) { twValue.Kill(); twValue = null; } 
    }

    public float DirX { get { return 0; } }
    //float lastz = -999999999;
    GameObject gameObject;
    UIProgressBar PowerBar; 
    float PowerHideTime = 0;
    Tweener tw = null;
    Tweener twValue = null;
    BelowPanelResources m_Res;
    PosTrack2D m_PosTrack2D;
}
