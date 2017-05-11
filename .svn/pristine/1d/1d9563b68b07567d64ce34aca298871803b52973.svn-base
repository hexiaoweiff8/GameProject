using UnityEngine;
using System.Collections;

/// <summary>
/// 动画控制器
/// </summary>
[AddComponentMenu("QK/Animation/AnimationController")]
public class AnimationController : MonoBehaviour { 
    /// <summary>
    /// 从头开始播放一个动画
    /// </summary>
    /// <param name="obj"></param>
    void Play(string gameObjectPath)
    {
        GameObject obj = GameObject.Find(gameObjectPath);
        if(obj==null)
        {
            Debug.LogWarning("动画控制器未找到游戏物体 路径:" + gameObjectPath);
            return;
        }

        Animator animator = obj.GetComponent<Animator>();
        if(animator==null)
        {
            Debug.LogWarning("动画控制器未找到动画组件 路径:" + gameObjectPath);
            return;
        }

        AnimatorClipInfo[] acInfos = animator.GetCurrentAnimatorClipInfo(0);
        if (acInfos == null || acInfos.Length<1)
        {
            Debug.LogWarning("动画控制器缺少剪辑 路径:" + gameObjectPath);
            return;
        }
        animator.enabled = true;//启用组件
        string clipName = acInfos[0].clip.name; 
        animator.PlayInFixedTime(clipName);//开始播放
    }
}
