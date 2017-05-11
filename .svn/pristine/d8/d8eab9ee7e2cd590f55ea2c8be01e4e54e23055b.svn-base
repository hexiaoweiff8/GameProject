using UnityEngine;
using System.Collections;

/// <summary>
/// 世界中心组件
/// </summary>
[AddComponentMenu("QK/YQ2/WorldCenter")]
public class YQ2WorldCenter : MonoBehaviour {

    /// <summary>
    /// 长 x
    /// </summary>
    public float Length;

    /// <summary>
    /// 宽 z
    /// </summary>
    public float width;

    /// <summary>
    /// 高 y
    /// </summary>
    public float height;

    /// <summary>
    /// 菱形边长
    /// </summary>
    public float CellSideLength;


    /// <summary>
    /// 天空盒材质
    /// </summary>
    public Material SkyBoxMat;
    /*
    /// <summary>
    /// 相机远旋转
    /// </summary>
    public float FarCameraRotation = 45;

    /// <summary>
    /// 相机远高度
    /// </summary>
    public float FarCameraHeight=10;

    /// <summary>
    /// 相机近旋转
    /// </summary>
    public float NearCameraRotation = 5;

    /// <summary>
    /// 相机近高度
    /// </summary>
    public float NearCameraHeight = 2;

    /// <summary>
    /// 相机缺省高度
    /// </summary>
    public float DefaultCameraHeight = 2;*/

#if UNITY_EDITOR
    //public bool showHandles { get { return UnityEditor.Tools.current == UnityEditor.Tool.Rect; } }

    protected virtual void OnDrawGizmos()
    {
        if (!this.isActiveAndEnabled) return;

        Gizmos.color = Color.green;

        var w = (int)width / 2 * 3 * CellSideLength * 0.01f;
        Gizmos.DrawWireCube(
            transform.position,
            new Vector3(Length * 1.732f * CellSideLength * 0.01f, height, w)
            );
    }
#endif
}
