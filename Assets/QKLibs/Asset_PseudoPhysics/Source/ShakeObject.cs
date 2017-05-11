using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;

/// <summary>
/// 震动物体组件
/// </summary>
[AddComponentMenu("QK/PseudoPhysics/ShakeObject")]
[RequireComponent(typeof(TransformMixer))]
public class ShakeObject : MonoBehaviour
{ 
    void Awake()
    {
        m_TransformMixer = GetComponent<TransformMixer>();
    }

    /// <summary>
    /// 震动
    /// </summary>
    public Tweener Shake(ShakeCurve curve, float duration)
    {
        PositionTransform pt = gameObject.AddComponent<PositionTransform>();//新增一个位置变换组件

        //震动发生时，取宿主的旋转量，震动过程中不随宿主旋转而改变震动方向
        Quaternion mainRotation = m_TransformMixer.MainRotationTransform.Value;

        float t = 0;
        return DOTween.To(
            () => t,
            x =>
            {
                t = x;
                pt.Value = mainRotation * new Vector3(curve.ShakeX.Evaluate(t), curve.ShakeY.Evaluate(t), curve.ShakeZ.Evaluate(t));
            },
            1f,
            duration
            )
            .SetAutoKill(true)
            .SetRecyclable(false)
            .SetEase(Ease.OutExpo)
            .OnKill(() =>  GameObject.Destroy(pt));
    }

    TransformMixer m_TransformMixer;
} 
