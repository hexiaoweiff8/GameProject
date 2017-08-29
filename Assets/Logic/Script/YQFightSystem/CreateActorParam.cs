using UnityEngine;
using System.Collections;
/// <summary>
/// 创建模型参数集
/// </summary>
public class CreateActorParam
{
    public int CmType;
    //ModleMaskColor maskColor,
    public bool ColorMat;
    public int FlagColorIdx;
    public string MeshPackName;
    public string TexturePackName;
    public bool IsHero;
    public int SoldierID;
    //卡牌ID
    //public int CardID;

    /// <summary>
    /// 单位等级
    /// </summary>
    public int Level = 1;

    /// <summary>
    /// 加载单位X轴位置
    /// </summary>
    public float X;

    /// <summary>
    /// 加载单位Y轴位置
    /// </summary>
    public float Y;

    //public CreateActorParam(int cmType,
    //    //ModleMaskColor maskColor,
    //    bool colorMat,
    //    int flagColorIdx,
    //    string meshPackName,
    //    string texturePackName,
    //    bool isHero,
    //    int soldierID,
    //    int cardID = 0
    //    )
    //{
    //    //this.CmType = cmType;
    //    //this.ColorMat = colorMat;
    //    //this.FlagColorIdx = flagColorIdx;
    //    //this.MeshPackName = meshPackName;
    //    //this.TexturePackName = texturePackName;
    //    //this.IsHero = isHero;
    //    //this.SoldierID = soldierID;
    //    this.CardID = cardID;
    //}

    /// <summary>
    /// 创建单位(基地炮塔)
    /// </summary>
    /// <param name="x">单位位置x</param>
    /// <param name="y">单位位置y</param>
    /// <param name="level">单位等级</param>
    public CreateActorParam(float x,
        float y,
        int level)
    {
        this.X = x;
        this.Y = y;
        this.Level = level;
    }

    /// <summary>
    /// 创建单位(障碍物)
    /// </summary>
    /// <param name="x">单位位置x</param>
    /// <param name="y">单位位置y</param>
    public CreateActorParam(float x,
        float y)
    {
        this.X = x;
        this.Y = y;
    }

    /// <summary>
    /// 创建单位(障碍物)
    /// </summary>
    /// <param name="soldierId">单位数据唯一Id</param>
    public CreateActorParam(int soldierId)
    {
        SoldierID = soldierId;
    }
}
