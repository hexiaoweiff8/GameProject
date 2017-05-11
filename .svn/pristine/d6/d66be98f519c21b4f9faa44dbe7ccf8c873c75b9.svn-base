using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[AddComponentMenu("QK/Animation/AvatarAnimationTemplate")]
public class AvatarAnimationTemplate :MonoBehaviour
{
    public float FrameWidth = 10;
    public float FrameHeight = 10;

    //[SerializeField]
    //[HideInInspector] 
    public  AvatarAnimationClip[] Clips = null;
 

    public AvatarAnimationClip GetClip(string clipName)
    {
        if (Clips == null) return null;

        foreach (AvatarAnimationClip curr in Clips)
            if (curr.clipName == clipName) return curr;
        return null;
    }

    public void AddClip(string clipName)
    {
        int oldlen = Clips==null?0:Clips.Length;
        AvatarAnimationClip[] newClips = new AvatarAnimationClip[oldlen+1];

        int i;
        for(i=0;i<oldlen;i++)
            newClips[i] = Clips[i];

        AvatarAnimationClip newObj = new AvatarAnimationClip();
        newObj.clipName = clipName;
        newClips[i] = newObj;
        Clips = newClips;
    }
}
