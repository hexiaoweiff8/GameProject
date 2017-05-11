using UnityEngine;
using System.Collections;
using System.Collections.Generic;



[AddComponentMenu("QK/Animation/AvatarAnimator_Auto")]
public class AvatarAnimator_Auto: AvatarAnimator_Manual
{
    public void Play(string clipName, bool randomStart, bool isLoop)
    { 
        AvatarAnimationClip clipObj = AnimationTemplate.GetClip(clipName);
        if (clipObj == null) return;

        CurrClip = clipObj;
        isPlaying = true;
        IsLoop = isLoop;
        lostTime = 0;

        int currFrame = randomStart ? UnityEngine.Random.Range(0, CurrClip.Frames.Length - 1) : 0;
        ManualPlayByFrame(clipName, currFrame, isLoop); 
    }

     void OnEnable()
    {
        if (CoroutineManage.Single!=null)
        CoroutineManage.Single.RegComponentUpdate(IUpdate);
    }

    void OnDestroy()
    {
        if (CoroutineManage.Single != null)
        CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
    }

    public void Stop()
    {
        isPlaying = false;
    }
    
    void IUpdate()
    {
        if (!isPlaying) return;

        lostTime += Time.deltaTime;

       // AvatarAnimationFrame frame = CurrClip.Frames[CurrFrame];
        float duration = CurrClip.frameDuration;
        if (lostTime >= duration)
        {
            lostTime -= duration;
            CurrFrame++;

            if (CurrFrame >= CurrClip.Frames.Length)
            {
                if (IsLoop)
                {
                    CurrFrame = 0;
                    UpdateRender();
                }
                else
                {
                    CurrFrame = CurrClip.Frames.Length - 1;
                    isPlaying = false;
                }
            }
            else
                UpdateRender();
        }
    }

    bool isPlaying;
    protected bool IsLoop;//是否循环播放
    protected float lostTime;//逝去时间 

}