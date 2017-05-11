using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//[SerializeField]
[AddComponentMenu("QK/Animation/AvatarAnimationClip")]
public class AvatarAnimationClip : MonoBehaviour
{
    public string clipName;//剪辑名
    public float frameDuration;//单帧持续时间
    public AvatarAnimationFrame[] Frames;//帧序列
}


