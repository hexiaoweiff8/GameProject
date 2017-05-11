using UnityEngine;
using System.Collections;

/// <summary>
/// 精灵遮蔽效果实现
/// 需要配合shader使用
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(UISprite))]
[AddComponentMenu("QK/UI/UISpriteMask")]
public class UISpriteMask : MonoBehaviour
{
    private float wr;
    private float hr;
    private float offX;
    private float offY;
    private UISprite s;


    void Awake()
    {
        s = GetComponent<UISprite>();

        wr = s.GetAtlasSprite().width * 1.0f / s.atlas.spriteMaterial.mainTexture.width;
        offX = s.GetAtlasSprite().x * 1.0f / s.atlas.spriteMaterial.mainTexture.width;

        hr = s.GetAtlasSprite().height * 1.0f / s.atlas.spriteMaterial.mainTexture.height;
        offY = (s.GetAtlasSprite().y + s.GetAtlasSprite().height) * 1.0f / s.atlas.spriteMaterial.mainTexture.height;
    }

    private void Start()
    {

        s.atlas.spriteMaterial.SetFloat("_WidthRate", wr);
        s.atlas.spriteMaterial.SetFloat("_HeightRate", hr);
        s.atlas.spriteMaterial.SetFloat("_XOffset", offX);
        s.atlas.spriteMaterial.SetFloat("_YOffset", offY);
    } 
}
