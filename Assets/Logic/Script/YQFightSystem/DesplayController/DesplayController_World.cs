using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;

class DesplayController_World : I_DesplayController
{
    public DesplayController_World()
    {
        var sun = GameObject.Find("SceneRoot/sun");
        this.sun = sun.GetComponent<Light>();
    }
    public void Update(float lostTime) {
       // UpdateSceneBrightness();
    }
    public void OnEnable() { }
    public void OnKeyChanged(DP_Key newKey)
    {
        switch (newKey.KeyType)
        {
            case DPKeyType.FightAIEnd://战斗AI已经结束
                {
                    wnd_fight.Single.OnFightAIEnd();
                }
                break;
            case DPKeyType.FightEnd://战斗结束
                {
                    var key = newKey as DPKey_FightEnd;

                    //解除屏幕锁定
                    DP_CameraTrackObjectManage.Single.UnLockOP();

                    //抛出战斗结束事件
                    DP_FightEvent.PostFightEnd(key.Result);
                }
                break;
            case DPKeyType.ShowFightCountDown://显示战斗倒计时
                {
                    var key = newKey as DPKey_ShowFightCountDown;

                    //考虑演示层和显示层时间差因素，取得最终的剩余时间
                    float eTime = key.DurationTime - (DP_BattlefieldDraw.Single.TotalLostTime - key.StartTime);

                    wnd_fight.Single.ShowFightCountDown(eTime,key.IsRed);
                }
                break;
            case DPKeyType.LianzhanChange://连斩改变
                {
                    var key = newKey as DPKey_LianzhanChange;
                    wnd_fight.Single.OnLianzhanChanged(key.lianzhanCount);
                }
                break;
                /*
            case DPKeyType.SceneBrightnessTo://场景亮度改变
                {
                    SceneBrightnessKey = newKey as DPKey_SceneBrightnessTo;

                    UpdateSceneBrightness(); 
                }
                break; */
        }
    }

    public void SetAlpha(float v) { }
    public void Destroy() { }

    public float DirX { get { return 0; } }

    public void OnUISet3DPos(Vector3 pos3d) { }

    public void SetBrightness(float v) {
        if (v < 0.001f) v = 0.001f;
        sun.intensity = v * 1.5f;
    }

    /*
    void UpdateSceneBrightness()
    {
        if (SceneBrightnessKey == null) return;

        float lostTime = DP_BattlefieldDraw.Single.TotalLostTime - SceneBrightnessKey.StartTime;
        float t = SceneBrightnessKey.len == 0 ? 1 : lostTime / SceneBrightnessKey.len;

        switch (SceneBrightnessKey.makingUpFunc)
        {
            case MakingUpFunc.Linear:
                SceneBrightness = DP_TweenFuncs.Tween_Linear_Float(SceneBrightnessKey.m_from, SceneBrightnessKey.m_to, t);
                break;
            case MakingUpFunc.Acceleration:
                SceneBrightness = DP_TweenFuncs.Tween_Accelerated_Float(SceneBrightnessKey.m_from, SceneBrightnessKey.m_to, t);
                break;
            default:
                SceneBrightness = DP_TweenFuncs.Tween_Deceleration_Float(SceneBrightnessKey.m_from, SceneBrightnessKey.m_to, t);
                break;
        }

        //调整场景的亮度
        sun.intensity = SceneBrightness * 1.5f;
        
 
        if (t >= 1) SceneBrightnessKey = null;
    }
    */
    //float SceneBrightness = 1;//场景亮度
    //DPKey_SceneBrightnessTo SceneBrightnessKey = null;
    Light sun = null;
}