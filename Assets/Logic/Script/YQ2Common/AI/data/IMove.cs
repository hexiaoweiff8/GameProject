using UnityEngine;

namespace Assets.scripts.interfaces
{
    /// <summary>
    /// 可移动的物体 可以有影子 可以进行坐标转换
    /// </summary>
    public interface IMove
    {
        /// <summary>
        /// 坐标
        /// </summary>
        Vector3 Pos { get; set; }

        /// <summary>
        /// 和影子的高度偏移
        /// </summary>
        float YOff { get; set; }

        Quaternion RotationDir { get; set; }

        Vector3 Rotation { get; set; }


        Transform Tf { get; set; }
    }
}