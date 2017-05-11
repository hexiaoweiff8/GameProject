using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 粒子系统扩展
/// </summary>
public static class ParticleSystemEX
{
    //设置播放速度
    public static void SetParticleSystemPlaySpeed(this GameObject self,float speed)
    {
        ParticleSystem[] cms = self.GetComponentsInChildren<ParticleSystem>();
        foreach (var curr in cms) curr.playbackSpeed = speed;  
    }

    /*
      /*获取粒子系统播放时长
             static float ParticleSystemLength(Transform transform)
	{
		ParticleSystem []particleSystems = transform.GetComponentsInChildren<ParticleSystem>();
		float maxDuration = 0;
		foreach(ParticleSystem ps in particleSystems){
			if(ps.enableEmission){
				if(ps.loop){
					return -1f;
				}
				float dunration = 0f;
				if(ps.emissionRate <=0){
					dunration = ps.startDelay + ps.startLifetime;
				}else{
					dunration = ps.startDelay + Mathf.Max(ps.duration,ps.startLifetime);
				}
				if (dunration > maxDuration) {
					maxDuration = dunration;
				}
			}
		}
		return maxDuration;
	}
             */


} 