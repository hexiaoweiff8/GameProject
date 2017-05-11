using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
 
/// <summary>
/// 相机区域碰检器
/// </summary>
[AddComponentMenu("QK/PseudoPhysics/BoxScrollObject")]

public class BoxScrollObject : ScrollObject
{
    
    public Bounds Cube = new Bounds(Vector3.zero, new Vector3(1, 1, 1));
    

    public override Bounds bounds  {  get { return Cube; } }

#if UNITY_EDITOR
    protected override void OnDrawGizmos()
    {
        if (Owner != null)
        {
            //自动纠正尺寸错误
            {
                bool needUpdate = false;
                Vector3 cube_extents = Cube.extents;
                Vector3 area_extents = Owner.Area.extents;
                if (cube_extents.x > area_extents.x)
                {
                    cube_extents.x = area_extents.x;
                    needUpdate = true;
                }

                if (cube_extents.y > area_extents.y)
                {
                    cube_extents.y = area_extents.y;
                    needUpdate = true;
                }

                if (cube_extents.z > area_extents.z)
                {
                    cube_extents.z = area_extents.z;
                    needUpdate = true;
                }

                if (needUpdate) Cube.extents = cube_extents;
            }

            //自动纠正位置错误
            {
                Vector3 pos;
                if (//m_PositionTransform != null && 
                    !Owner.GetInAreaPosition(ScrollViewPosition, this, out pos))
                        JumpTo(pos);
            }
        }

        base.OnDrawGizmos();

    } 
#endif
} 