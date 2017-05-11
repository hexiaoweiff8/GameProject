using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[AddComponentMenu("QK/YQ2/BatchRender")]
public class YQ2BatchRender : MonoBehaviour
{
    public Material material;//阴影渲染材料

    public enum QuadType
    {
        Shadow,//阴影
        Vertical,//垂直的
        Horizontal,//水平的
    }
    public QuadType mQuadType = QuadType.Shadow;

    //public static YQ2BatchRender Single = null;

    public YQ2BatchRender()
    {
        //Single = this;
    }
    /*
    void OnEnable()
    {
        CoroutineManage.Single.RegComponentUpdate(IUpdate);
    }
    void OnDisable()
    {
        CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
    }
    */

    void OnPostRender()
    {
        if (material == null) return;
        if (needRemove.Count > 0)
        {
            foreach (YQ2BathQuad curr in needRemove) if (shadows.Contains(curr)) shadows.Remove(curr);
            needRemove.Clear();
        }

        if (needAdd.Count > 0)
        {
            foreach (YQ2BathQuad curr in needAdd) if (!shadows.Contains(curr)) shadows.Add(curr);
            needAdd.Clear();
        }

        var camera_rotation = gameObject.transform.rotation;
         

        GL.Color(Color.white);
     //   GL.PushMatrix();
        material.SetPass(0);

        GL.Begin(GL.TRIANGLES);

        Vector3 tmp_ltv = new Vector3();
        Vector3 tmp_rtv = new Vector3();
        Vector3 tmp_rbv = new Vector3();
        Vector3 tmp_lbv = new Vector3();
        
        switch(mQuadType)
        {
            case QuadType.Shadow:
                foreach (YQ2BathQuad curr in shadows)
                {
                    if (!curr.isVisible) continue;

                    Vector3 pos = curr.gameObject.transform.position;
                    float x = pos.x;
                    float z = pos.z;
                    float harfW = curr.width * 0.5f;
                    float harfH = curr.height * 0.5f;

                    float ltv_x = x - harfW;
                    float ltv_z = z - harfH;
                    float rbv_x = x + harfW;
                    float rbv_z = z + harfH;

                    const float shadow_y = 0.01f;

                    GL.TexCoord2(curr.lt_u, curr.rb_v);
                    GL.Vertex3(ltv_x, shadow_y, ltv_z);

                    GL.TexCoord2(curr.lt_u, curr.lt_v);
                    GL.Vertex3(ltv_x, shadow_y, rbv_z);

                    GL.TexCoord2(curr.rb_u, curr.rb_v);
                    GL.Vertex3(rbv_x, shadow_y, ltv_z);


                    GL.TexCoord2(curr.lt_u, curr.lt_v);
                    GL.Vertex3(ltv_x, shadow_y, rbv_z);

                    GL.TexCoord2(curr.rb_u, curr.lt_v);
                    GL.Vertex3(rbv_x, shadow_y, rbv_z);

                    GL.TexCoord2(curr.rb_u, curr.rb_v);
                    GL.Vertex3(rbv_x, shadow_y, ltv_z);
                }
                break;
            case QuadType.Vertical:
                foreach (YQ2BathQuad curr in shadows)
                {
                    if (!curr.isVisible) continue;

                    Vector3 pos = curr.gameObject.transform.position;
                    float x = pos.x;
                    float y = pos.y;
                    float z = pos.z;
                    float harfW = curr.width * 0.5f;
                    float harfH = curr.height * 0.5f;

                    tmp_ltv.x = -harfW;
                    tmp_ltv.z = 0;
                    tmp_ltv.y = harfH;

                    tmp_rtv.x = harfW;
                    tmp_rtv.z = 0;
                    tmp_rtv.y = harfH;

                    tmp_rbv.x = harfW;
                    tmp_rbv.z = 0;
                    tmp_rbv.y = -harfH;

                    tmp_lbv.x = -harfW;
                    tmp_lbv.z = 0;
                    tmp_lbv.y = -harfH;

                    var rotation = curr.gameObject.transform.rotation * camera_rotation;

                    tmp_lbv = pos + rotation * tmp_lbv;
                    tmp_ltv = pos + rotation * tmp_ltv;
                    tmp_rtv = pos + rotation * tmp_rtv;
                    tmp_rbv = pos + rotation * tmp_rbv; 
                     

                    GL.TexCoord2(curr.lt_u, curr.rb_v);
                    GL.Vertex(tmp_ltv);

                    GL.TexCoord2(curr.lt_u, curr.lt_v);
                    GL.Vertex(tmp_lbv);

                    GL.TexCoord2(curr.rb_u, curr.rb_v);
                    GL.Vertex(tmp_rtv);


                    GL.TexCoord2(curr.lt_u, curr.lt_v);
                    GL.Vertex(tmp_lbv);

                    GL.TexCoord2(curr.rb_u, curr.lt_v);
                    GL.Vertex(tmp_rbv);

                    GL.TexCoord2(curr.rb_u, curr.rb_v);
                    GL.Vertex(tmp_rtv);
                }
                break;
            case QuadType.Horizontal:
                foreach (YQ2BathQuad curr in shadows)
                {
                    if (!curr.isVisible) continue;

                    Vector3 pos = curr.gameObject.transform.position;
                    float x = pos.x;
                    float y = pos.y;
                    float z = pos.z;
                    
                    float harfW = curr.width * 0.5f;
                    float harfH = curr.height * 0.5f;

                    float ltv_x = x - harfW;
                    float ltv_z = z - harfH;
                    float rbv_x = x + harfW;
                    float rbv_z = z + harfH;
                     

                    GL.TexCoord2(curr.lt_u, curr.rb_v);
                    GL.Vertex3(ltv_x, y, ltv_z);

                    GL.TexCoord2(curr.lt_u, curr.lt_v);
                    GL.Vertex3(ltv_x, y, rbv_z);

                    GL.TexCoord2(curr.rb_u, curr.rb_v);
                    GL.Vertex3(rbv_x, y, ltv_z);


                    GL.TexCoord2(curr.lt_u, curr.lt_v);
                    GL.Vertex3(ltv_x, y, rbv_z);

                    GL.TexCoord2(curr.rb_u, curr.lt_v);
                    GL.Vertex3(rbv_x, y, rbv_z);

                    GL.TexCoord2(curr.rb_u, curr.rb_v);
                    GL.Vertex3(rbv_x, y, ltv_z);
                }
                break;
        };
       
        GL.End();

      //  GL.PopMatrix();
    }

    public void RegShadow(YQ2BathQuad shadow)
    {
        if (needRemove.Contains(shadow)) needRemove.Remove(shadow);
        if (!needAdd.Contains(shadow)) needAdd.Add(shadow);
    }

    public void UnRegShadow(YQ2BathQuad shadow)
    {
        if (needAdd.Contains(shadow)) needAdd.Remove(shadow);
        if (!needRemove.Contains(shadow)) needRemove.Add(shadow);
    }

    HashSet<YQ2BathQuad> needRemove = new HashSet<YQ2BathQuad>();
    HashSet<YQ2BathQuad> needAdd = new HashSet<YQ2BathQuad>();
    HashSet<YQ2BathQuad> shadows = new HashSet<YQ2BathQuad>();
}
