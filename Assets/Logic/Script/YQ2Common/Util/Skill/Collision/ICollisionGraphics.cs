using UnityEngine;

/// <summary>
/// 碰撞检测图形接口
/// </summary>
public interface ICollisionGraphics
{
    /// <summary>
    /// 获取图形类型
    /// </summary>
    /// <returns></returns>
    GraphicType GraphicType { get; }

    /// <summary>
    /// 图形所在位置
    /// </summary>
    Vector2 Postion { get; set; }

    /// <summary>
    /// 检测与其他图形的碰撞
    /// </summary>
    /// <param name="graphics">其他图形对象</param>
    /// <returns></returns>
    bool CheckCollision(ICollisionGraphics graphics);

    /// <summary>
    /// 获取外接矩形
    /// </summary>
    /// <returns></returns>
    RectGraphics GetExternalRect();
}