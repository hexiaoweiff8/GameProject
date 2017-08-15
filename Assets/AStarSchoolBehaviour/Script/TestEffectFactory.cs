using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 测试特效加载
/// </summary>
public class TestEffectFactory : MonoBehaviour
{

    void Update()
    {
        Control();
    }

    /// <summary>
    /// 控制方法
    /// </summary>
    private void Control()
    {

        // 鼠标左键
        if (Input.GetMouseButtonDown(0))
        {
            // 创建固定点
            //EffectsFactory.Single.CreatePointEffect("test/PointEffect", null,
            //    new Vector3(10, 10, 10), new Vector3(3, 3, 3), 1, 1).Begin();

            var testEffect = EffectsFactory.Single.CreateLinerEffect("linePrfb.prefab", null, GameObject.Find("AstarFight"), 3, null, 12);
            testEffect.Begin();
        }

        //// 鼠标右键
        //if (Input.GetMouseButtonDown(1))
        //{
        //    EffectsFactory.Single.CreatePointToPointEffect("test/TrailPrj", null, new Vector3(0, 0, 0),
        //        new Vector3(100, 0, 100), new Vector3(1, 1, 1), 100).Begin();
        //}
    }
}