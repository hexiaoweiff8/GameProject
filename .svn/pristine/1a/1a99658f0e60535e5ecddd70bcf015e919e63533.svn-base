//重载UIButton，预览后 普通状态的精灵被禁用状态精灵覆盖 bug

using UnityEngine;
using System.Collections.Generic;
using System;

[AddComponentMenu("QK/UI/QKUIButton")]
public class QKUIButton : UIButton
{
    public UnityEngine.Sprite normalSpriteSprite2D;

    public string normalSpriteSprite;

    protected override void OnInit()
    {
        base.OnInit();
        mSprite = (mWidget as UISprite);
        mSprite2D = (mWidget as UI2DSprite);
        if (mSprite != null) mNormalSprite = normalSpriteSprite;
        if (mSprite2D != null) mNormalSprite2D = normalSpriteSprite2D;

        SetState(State.Normal, true);
    } 
} 