using UnityEngine;
using System.Collections;
/// <summary>
/// 创建模型参数集
/// </summary>
public class CreateActorParam
{
    public AvatarCM CmType;
    //ModleMaskColor maskColor,
    public bool ColorMat;
    public int FlagColorIdx;
    public string MeshPackName;
    public string TexturePackName;
    public bool IsHero;
    public int SoldierID;
    //卡牌ID
    public int CardID;

    public CreateActorParam(AvatarCM cmType,
        //ModleMaskColor maskColor,
        bool colorMat,
        int flagColorIdx,
        string meshPackName,
        string texturePackName,
        bool isHero,
        int soldierID,
        int cardID = 0
        )
    {
        this.CmType = cmType;
        this.ColorMat = colorMat;
        this.FlagColorIdx = flagColorIdx;
        this.MeshPackName = meshPackName;
        this.TexturePackName = texturePackName;
        this.IsHero = isHero;
        this.SoldierID = soldierID;
        this.CardID = cardID;
    }
    public CreateActorParam(int cmType,
        //ModleMaskColor maskColor,
    bool colorMat,
    int flagColorIdx,
    string meshPackName,
    string texturePackName,
    bool isHero,
    int soldierID,
    int cardID = 0)
    {
        this.CmType = (AvatarCM)cmType;
        this.ColorMat = colorMat;
        this.SoldierID = soldierID;
        this.FlagColorIdx = flagColorIdx;
        this.MeshPackName = meshPackName;
        this.TexturePackName = texturePackName;
        this.IsHero = isHero;
        this.CardID = cardID;
    }
}
