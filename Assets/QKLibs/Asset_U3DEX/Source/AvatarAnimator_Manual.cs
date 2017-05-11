using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public enum Flip
{
    Nothing,
    Horizontally,
    Vertically,
    Both,
}

[AddComponentMenu("QK/Animation/AvatarAnimator_Manual")]
[RequireComponent(typeof(Renderer))]
public class AvatarAnimator_Manual : MonoBehaviour
{
    public AvatarAnimationTemplate AnimationTemplate;
    public Texture texture = null;//纹理

    //[SerializeField]
    //[HideInInspector]
    Flip _aflip = Flip.Nothing;

    public Flip flip
    {
        get { return _aflip; }
        set
        {
            _aflip = value;
            UpdateTextureScale();
        }
    }

    public void ManualPlayByFrame(string clipName, int currFrame, bool isLoop)
    {
        if (CurrFrame == currFrame && CurrClip!=null&& CurrClip.name == clipName) return;

        AvatarAnimationClip clipObj = AnimationTemplate.GetClip(clipName);
        if (clipObj == null) return;

        if(currFrame>=clipObj.Frames.Length)
        {
            if (isLoop)
                currFrame %= clipObj.Frames.Length;
            else
                currFrame = clipObj.Frames.Length - 1;
        }
        else if (currFrame<0)
        {
            if (isLoop)
            {
                currFrame = Mathf.Abs(currFrame) % clipObj.Frames.Length;
                currFrame = clipObj.Frames.Length - currFrame - 1;
            }
            else
                currFrame = 0;
        }

        CurrClip = clipObj; 
        CurrFrame = currFrame;

        UpdateRender();
    }

    public float GetClipLength(string clipName)
    {
        AvatarAnimationClip clipObj = AnimationTemplate.GetClip(clipName);
        if (clipObj == null) return 0;

        return clipObj.frameDuration * clipObj.Frames.Length;
    }

    public void ManualPlayByTime(string clipName, float time, bool isLoop)
    {
       
        AvatarAnimationClip clipObj = AnimationTemplate.GetClip(clipName);
        if (clipObj == null) return;

        float countTime = clipObj.frameDuration * clipObj.Frames.Length;
        int currFrame = (int)(time / countTime * clipObj.Frames.Length);

        if (CurrFrame == currFrame && CurrClip != null && CurrClip.name == clipName) return;


        if (currFrame >= clipObj.Frames.Length)
        {
            if (isLoop)
                currFrame %= clipObj.Frames.Length;
            else
                currFrame = clipObj.Frames.Length - 1;
        }
        else if (currFrame < 0)
        {
            if (isLoop)
            {
                currFrame = Mathf.Abs(currFrame) % clipObj.Frames.Length;
                currFrame = clipObj.Frames.Length - currFrame;
            }
            else
                currFrame = 0;
        }

        CurrClip = clipObj;
        CurrFrame = currFrame;

        UpdateRender(); 
    }
     
      
         

    void UpdateTextureScale()
    {
        float textureScale_x = textureScale.x;
        float textureScale_y = textureScale.y;

        switch (_aflip)
        {
            case Flip.Both:
                {
                    textureScale_x = -textureScale_x;
                    textureScale_y = -textureScale_y;
                }
                break;
            case Flip.Vertically:
                {
                    textureScale_y = -textureScale_y;
                }
                break;
            case Flip.Horizontally:
                {
                    textureScale_x = -textureScale_x;
                }
                break;
        };

        if (material != null)
        {
            material.mainTextureScale = new Vector2(textureScale_x, textureScale_y);

            UpdateRender();
        } 
    }

    public void _Init()
    {
        Renderer cmRenderer = GetComponent<Renderer>();
        if (cmRenderer == null) return;
        material = cmRenderer.material;

        Texture mainTexture;

        if (texture != null)
            mainTexture = cmRenderer.material.mainTexture = texture;
        else
            mainTexture = cmRenderer.material.mainTexture;

        int textureWidth = mainTexture.width;
        int textureHeight = mainTexture.height;
        textureScale = new Vector2(
            (float)AnimationTemplate.FrameWidth / (float)textureWidth,
            (float)AnimationTemplate.FrameHeight / (float)textureHeight
            );


        maxFrameIndex = (int)(textureWidth / AnimationTemplate.FrameWidth - 1);
        maxClipIndex = (int)(textureHeight / AnimationTemplate.FrameHeight - 1);

        m_rightBlank = (textureWidth % AnimationTemplate.FrameWidth) / textureWidth;
        m_bottomBlank = (textureHeight % AnimationTemplate.FrameHeight) / textureHeight;

        if (AnimationTemplate.Clips != null)
        {
            ManualPlayByFrame(AnimationTemplate.Clips[0].clipName, 0, false);

            UpdateTextureScale();
        }
    }

    protected virtual void Start()
    {
        _Init();
    }


    protected void UpdateRender()
    {
        if (material == null) return; 

       AvatarAnimationFrame  frame = CurrClip.Frames[CurrFrame];
       int frameIndex = frame.xIndex;
       int clipIndex = frame.yIndex;
       float xoffset = 0;
       float yoffset = 0; 
        switch (_aflip)
        {
            case Flip.Both:
                {
                    clipIndex = -(maxClipIndex  - clipIndex);
                    frameIndex = -(maxFrameIndex - frameIndex);

                    xoffset = -m_rightBlank;
                    yoffset = -m_bottomBlank;
                }
                break;
            case Flip.Vertically:
                {
                    clipIndex = -(maxClipIndex  - clipIndex);
                  
                    yoffset = -m_bottomBlank;
                  
                }
                break;
            case Flip.Horizontally:
                {
                    frameIndex = -(maxFrameIndex - frameIndex);
                    xoffset = -m_rightBlank;
                }
                break;
        };

        xoffset += textureScale.x * frameIndex;
        yoffset += textureScale.y * clipIndex;

        //if (xoffset < 0) xoffset = 1 + xoffset;
        //if (yoffset < 0) yoffset = 1 + yoffset;

         material.mainTextureOffset = new Vector2(xoffset, yoffset); 
    }

    protected AvatarAnimationClip CurrClip = null;//当前剪辑
    protected int CurrFrame;//当前帧
   
    protected Material material = null;
    protected Vector2 textureScale;
    protected int maxFrameIndex;
    protected int maxClipIndex;
    float m_rightBlank = 0;
    float m_bottomBlank = 0;
  
}
 