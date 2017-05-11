using UnityEngine;
using System.Collections.Generic;

//Gizmos 可矢量绘制


class Line
{
    public Line(float fromx, float fromz, float tox, float toz, UISpriteData sp, Texture texture,Color32 fromColor,Color32 toColor)
    { 
        const float lw = 1f;

        this.fromColor = fromColor;
        this.toColor = toColor;

        Vector3 lt = new Vector3(), rt = new Vector3(), lb = new Vector3(), rb = new Vector3();
        if(Mathf.Abs(fromx - tox) >Mathf.Abs(fromz- toz) )//横线
        {
            lt.x = fromx;
            lt.y = fromz - lw;

            rt.x = fromx ;
            rt.y = fromz + lw;

            lb.x = tox ;
            lb.y = toz - lw;

            rb.x = tox ;
            rb.y = toz + lw;
        }else //竖线
        {
            lt.x = fromx - lw;
            lt.y = fromz;

            rt.x = fromx + lw;
            rt.y = fromz;

            lb.x = tox - lw;
            lb.y = toz;

            rb.x = tox + lw;
            rb.y = toz;
        }

        vertexs[0] = lt;
        vertexs[1] = rt;
        vertexs[2] = rb;
        vertexs[3] = lb;

          
        int textureW = texture.width;
        int textureH = texture.height;
        float uvL = (float)sp.x / (float)textureW;
        float uvT = 1f - (float)(sp.y + sp.height) / (float)textureH;
        float uvR = (float)(sp.x + sp.width) / (float)textureW;
        float uvB = 1f - (float)sp.y / (float)textureH;

        uvs[0].x = uvL;
        uvs[0].y = uvT;
        uvs[1].x = uvR;
        uvs[1].y = uvT;
        uvs[2].x = uvR;
        uvs[2].y = uvB;
        uvs[3].x = uvL;
        uvs[3].y = uvB;
    }

    public Vector3[] vertexs = new Vector3[4];
    public Vector2[] uvs = new Vector2[]{
            new Vector2(),
            new Vector2(),
            new Vector2(),
            new Vector2()
        };
    public Color32 fromColor;
    public Color32 toColor;
}

/// <summary>
/// If you don't have or don't wish to create an atlas, you can simply use this script to draw a texture.
/// Keep in mind though that this will create an extra draw call with each UITexture present, so it's
/// best to use it only for backgrounds or temporary visible widgets.
/// </summary>

[ExecuteInEditMode]
[AddComponentMenu("QK/YQ2/UI/UIEagleEyeMap")]
public class UIEagleEyeMap : UIWidget
{  
     
    [HideInInspector][SerializeField] UIAtlas mAtlas = null;

    [HideInInspector][SerializeField] string VisualFieldSpriteName;//视野精灵名
    [HideInInspector][SerializeField] string VisualFieldLineSpriteName;//视野线条精灵名

    public Camera WorldCamera;//世界相机
    public Vector2 WorldOrigin;//世界原点
    public Vector2 WorldSize;//世界尺寸

    

    Vector2 m_Offset = new Vector2();
    Vector2 m_Scale;

    //通知视野发生变化
    public void SetVisualFieldChanged()
    {
        m_IsVisualFieldChanged = true;
    }

    public void SetWorldRectChanged()
    {
        m_Scale = new Vector2(
           (float)width / WorldSize.x,
           (float)height / WorldSize.y
        );

        m_Offset.x = WorldOrigin.x * m_Scale.x;
        m_Offset.y = WorldOrigin.y * m_Scale.y - height;
    }

	public Vector3 GetWordPositionByUV(float u,float v)
	{
		float x = (u * width - m_Offset.x) / m_Scale.x;
		float z = WorldSize.y - ((v*height - m_Offset.y) / m_Scale.y);

		return new Vector3 (x, 0, z);
	}









    //////////////////////
     
    public ObjInfo AddObj(
        float x, float z,
        //float w, float h,
        UIWidget mb,//模板 
        int depth
        )
    {

        ObjInfo n = new ObjInfo();
        n.id = m_IDSeed++; 

       // n.width = w;
       // n.height = h;

        var newobj = GameObject.Instantiate(mb.gameObject);
        newobj.transform.parent = this.transform;
        newobj.transform.localScale = Vector3.one;
        n.widget = newobj.GetComponent<UIWidget>();
        n.widget.depth = depth;

        //加入到索引
        m_ObjsIndexByID.Add(n.id, n);

     
        //移动，刷新顶点位置
        MoveObj(n.id, x, z);

        return n;
    }



    public void MoveObj(int id, float x, float z)
    {
        if (!m_ObjsIndexByID.ContainsKey(id)) return;
        var n = m_ObjsIndexByID[id];

        _Move(n, x, z); 
    }

    public void MoveObj(int id, float x, float z, int depth)
    {
        if (!m_ObjsIndexByID.ContainsKey(id)) return;
        var n = m_ObjsIndexByID[id];
        n.widget.depth = depth;
        _Move(n, x, z);
    }



    //移除演员
    public void RemoveObj(int id)
    {
        if (!m_ObjsIndexByID.ContainsKey(id)) return;
        var info = m_ObjsIndexByID[id];
        GameObject.Destroy(info.widget.gameObject);
        m_ObjsIndexByID.Remove(id);
    }



    void _Move(ObjInfo n, float x, float z)
    {
        n.widget.transform.localPosition = new Vector3(
            x * m_Scale.x + m_Offset.x, 
            (WorldSize.y - z) * m_Scale.y + m_Offset.y, 
            0
            );
    }

    /////////////////////////















    //移除演员
    public void RemoveActor(int id)
    {
        if (!m_ActorsIndexByID.ContainsKey(id)) return;
        var info = m_ActorsIndexByID[id];
        var depth = info.depth;
        m_ActorsIndexByID.Remove(id);

        var depthList = m_ActorsIndexByDepth[depth];
        depthList.Remove(info);
        if (depthList.Count < 1) m_ActorsIndexByDepth.Remove(depth);

        m_IsActorChanged = true;
    }

    public void Clear()
    {
        m_ActorsIndexByID.Clear();
        m_ActorsIndexByDepth.Clear();
        m_IsActorChanged = true;
    }

    //添加演员
    public int AddActor(
        float x, float z,
        float w, float h,
        string spriteName,
        Color32 color,
        bool IsBottomAlign,
        int depth
        )
    {
        uint colorHashV = ColorHash(color);
        if (!mIndexColor.ContainsKey(colorHashV)) mIndexColor.Add(colorHashV, color);

        ActorInfo n = new ActorInfo();
        n.id = m_IDSeed++;
        n.ColorHashV = colorHashV;

        n.width = w;
        n.height = h;
        n.harfW = w/2;
        n.harfH = h/2;
        n.IsBottomAlign = IsBottomAlign;


        UISpriteData sp = mAtlas.GetSprite(spriteName);
        Texture texture = mainTexture;
        int textureW = texture.width;
        int textureH = texture.height;
        float uvL = (float)sp.x / (float)textureW;
        float uvT = 1f - (float)(sp.y + sp.height) / (float)textureH;
        float uvR = (float)(sp.x + sp.width) / (float)textureW;
        float uvB = 1f - (float)sp.y / (float)textureH;

        n.uvs[0].x = uvL;
        n.uvs[0].y = uvT;
        n.uvs[1].x = uvR;
        n.uvs[1].y = uvT;
        n.uvs[2].x = uvR;
        n.uvs[2].y = uvB;
        n.uvs[3].x = uvL;
        n.uvs[3].y = uvB;

        n.depth = depth;

        //加入到索引
        m_ActorsIndexByID.Add(n.id, n);

        if (!m_ActorsIndexByDepth.ContainsKey(depth))
            m_ActorsIndexByDepth.Add(depth, new HashSet<ActorInfo>());

        m_ActorsIndexByDepth[depth].Add(n);

        //移动，刷新顶点位置
        MoveActor(n.id, x, z);

        return n.id;
    }

    public void MoveActor(int id,float x,float z)
    {
        if (!m_ActorsIndexByID.ContainsKey(id)) return;
        ActorInfo n = m_ActorsIndexByID[id];

        _Move(n,x,z);

        m_IsActorChanged = true;
    }

     public void MoveActor(int id,float x,float z,int depth)
    {
        if (!m_ActorsIndexByID.ContainsKey(id)) return;
        ActorInfo n = m_ActorsIndexByID[id];
         if(n.depth!=depth)
         {
             var depthArray = m_ActorsIndexByDepth[n.depth];
             depthArray.Remove(n);
             if (depthArray.Count == 0) m_ActorsIndexByDepth.Remove(n.depth);

             n.depth = depth;
             if (!m_ActorsIndexByDepth.ContainsKey(depth)) m_ActorsIndexByDepth.Add(depth, new HashSet<ActorInfo>());
             m_ActorsIndexByDepth[depth].Add(n);
         }
        _Move(n, x, z);

        m_IsActorChanged = true;
    }
     

    void _Move(ActorInfo n,float x,float z)
    {
        if (!n.IsBottomAlign)
        {
            float harfW = n.harfW;
            float harfH = n.harfH;
            n.vertexs[0].x = (x - harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[0].y = (WorldSize.y - (z - harfH)) * m_Scale.y + m_Offset.y;
            n.vertexs[1].x = (x + harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[1].y = (WorldSize.y - (z - harfH)) * m_Scale.y + m_Offset.y;
            n.vertexs[2].x = (x + harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[2].y = (WorldSize.y - (z + harfH)) * m_Scale.y + m_Offset.y;
            n.vertexs[3].x = (x - harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[3].y = (WorldSize.y - (z + harfH)) * m_Scale.y + m_Offset.y;
        }
        else
        {
            float harfW = n.harfW;
            float H = n.height;
            n.vertexs[0].x = (x - harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[0].y = (WorldSize.y - z) * m_Scale.y + m_Offset.y;
            n.vertexs[1].x = (x + harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[1].y = (WorldSize.y - z) * m_Scale.y + m_Offset.y;
            n.vertexs[2].x = (x + harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[2].y = (WorldSize.y - (z + H)) * m_Scale.y + m_Offset.y;
            n.vertexs[3].x = (x - harfW) * m_Scale.x + m_Offset.x;
            n.vertexs[3].y = (WorldSize.y - (z + H)) * m_Scale.y + m_Offset.y;
        }
    }

    uint ColorHash(Color32 color)
    {
        return (uint)color.r | ((uint)color.g << 8) | ((uint)color.b << 16) | ((uint)color.a << 24);
    }
  
  
	public override Texture mainTexture
	{ 
        get { 
            return mAtlas == null?null:mAtlas.spriteMaterial.mainTexture;
        }
	}

	/// <summary>
	/// Material used by the widget.
	/// </summary>

	public override Material material
	{ 
        get{
            return mAtlas == null ? null : mAtlas.spriteMaterial;
        }
	}

    /*
    public void SetSprite(UISprite sprite)
    {
        if (sprite == mSprite) return;
        RemoveFromPanel();
        mSprite = sprite;
        MarkAsChanged();
    }*/

	/// <summary>
	/// Shader used by the texture when creating a dynamic material (when the texture was specified, but the material was not).
	/// </summary>

	public override Shader shader
	{
		get
		{  
            return mAtlas == null ? null : mAtlas.spriteMaterial.shader;
		} 
	}
     
     

	/// <summary>
	/// Adjust the draw region if the texture is using a fixed aspect ratio.
	/// </summary>

	protected override void OnUpdate ()
	{
		base.OnUpdate();

        //控制刷新帧率
        lostTime += Time.deltaTime;
        if (lostTime < 0.1f) return;        
        lostTime = 0f;

        if (m_IsActorChanged || m_IsVisualFieldChanged)
        {
            if (m_IsVisualFieldChanged && WorldCamera!=null)
            {
                Plane groundPlane = new Plane(new Vector3(0, -1, 0), Vector3.zero);//构建一个平面
                Ray ltRay = WorldCamera.ViewportPointToRay(new Vector3(0, 1, 0));
                Ray rtRay = WorldCamera.ViewportPointToRay(new Vector3(1, 1, 0));
                Ray rbRay = WorldCamera.ViewportPointToRay(new Vector3(1, 0, 0));
                Ray lbRay = WorldCamera.ViewportPointToRay(new Vector3(0, 0, 0));

                Vector3 mVisualField_ltPoint;
                Vector3 mVisualField_rtPoint;
                Vector3 mVisualField_rbPoint;
                Vector3 mVisualField_lbPoint;


                float ltEnter,rtEnter,rbEnter,lbEnter;
                if(groundPlane.Raycast(ltRay,out ltEnter))
                    mVisualField_ltPoint = ltRay.GetPoint(ltEnter);
                else
                    mVisualField_ltPoint = ltRay.GetPoint(1000);

                if(  groundPlane.Raycast(rtRay,out rtEnter))
                    mVisualField_rtPoint = rtRay.GetPoint(rtEnter);
                else
                    mVisualField_rtPoint = rtRay.GetPoint(1000);
                    
                if(  groundPlane.Raycast(rbRay,out rbEnter))
                    mVisualField_rbPoint = rbRay.GetPoint(rbEnter);
                else
                    mVisualField_rbPoint = rbRay.GetPoint(1000);


                if( groundPlane.Raycast(lbRay,out lbEnter))
                    mVisualField_lbPoint = lbRay.GetPoint(lbEnter);
                else
                    mVisualField_lbPoint = lbRay.GetPoint(1000);
                
                { 
                   UISpriteData sp = mAtlas.GetSprite(VisualFieldLineSpriteName);
                   Texture texture = mainTexture; 

                    mVisualField_ltPoint.x = mVisualField_ltPoint.x * m_Scale.x + m_Offset.x;
                    mVisualField_ltPoint.y = (WorldSize.y - mVisualField_ltPoint.z) * m_Scale.y + m_Offset.y;
                    mVisualField_ltPoint.z = 0;

                    mVisualField_rtPoint.x = mVisualField_rtPoint.x * m_Scale.x + m_Offset.x;
                    mVisualField_rtPoint.y = (WorldSize.y - mVisualField_rtPoint.z) * m_Scale.y + m_Offset.y;
                    mVisualField_rtPoint.z = 0;

                    mVisualField_rbPoint.x = mVisualField_rbPoint.x * m_Scale.x + m_Offset.x;
                    mVisualField_rbPoint.y = (WorldSize.y - mVisualField_rbPoint.z) * m_Scale.y + m_Offset.y;
                    mVisualField_rbPoint.z = 0;

                    mVisualField_lbPoint.x = mVisualField_lbPoint.x * m_Scale.x + m_Offset.x;
                    mVisualField_lbPoint.y = (WorldSize.y - mVisualField_lbPoint.z) * m_Scale.y + m_Offset.y;
                    mVisualField_lbPoint.z = 0;

                  
                    //限定视野左上角顶点位置
                    float VisualFieldMaxDepth = (float)height * 0.4f;
                    { 
                        if(Mathf.Abs( mVisualField_lbPoint.y  - mVisualField_ltPoint.y)>VisualFieldMaxDepth)
                        {
                            Ray ray = new Ray(mVisualField_lbPoint, mVisualField_ltPoint - mVisualField_lbPoint); 
                            mVisualField_ltPoint = ray.GetPoint(VisualFieldMaxDepth); 
                        }
                    }

                    //限定视野右上角顶点位置
                    {
                        if (Mathf.Abs(mVisualField_rbPoint.y - mVisualField_rtPoint.y) > VisualFieldMaxDepth)
                        {
                            Ray ray = new Ray(mVisualField_rbPoint, mVisualField_rtPoint - mVisualField_rbPoint); 
                            mVisualField_rtPoint = ray.GetPoint(VisualFieldMaxDepth);
                        }
                    } 
                   VisualFieldLines = new Line[]
                   {
                        new Line(mVisualField_rtPoint.x,mVisualField_rtPoint.y,mVisualField_rbPoint.x,mVisualField_rbPoint.y,sp,texture,new Color(1,1,1,0) ,Color.white),
                        new Line(mVisualField_rbPoint.x,mVisualField_rbPoint.y,mVisualField_lbPoint.x,mVisualField_lbPoint.y,sp,texture,Color.white ,Color.white),
                        new Line(mVisualField_lbPoint.x,mVisualField_lbPoint.y,mVisualField_ltPoint.x,mVisualField_ltPoint.y,sp,texture,Color.white ,new Color(1,1,1,0) ),
                   }; 


                   //视野区域填充 
                   {
                       mVisualFieldFillVertexs = new Vector3[4];
                       mVisualFieldFillUVs = new Vector2[4];
                       mVisualFieldFillColors = new Color32[4];

                       UISpriteData sp_fill = mAtlas.GetSprite(VisualFieldSpriteName);
                       Texture fill_texture = mainTexture;
                       mVisualFieldFillVertexs[0]=mVisualField_ltPoint;
                       mVisualFieldFillVertexs[1]=mVisualField_rtPoint;
                       mVisualFieldFillVertexs[2]=mVisualField_rbPoint;
                       mVisualFieldFillVertexs[3]=mVisualField_lbPoint;

                       int textureW = fill_texture.width;
                       int textureH = fill_texture.height;
                       float uvL = (float)(sp_fill.x + sp_fill.borderLeft) / (float)textureW;
                       float uvT = 1f - (float)(sp_fill.y + sp_fill.borderBottom) / (float)textureH;
                       float uvR = (float)(sp_fill.x + sp_fill.width - sp_fill.borderRight) / (float)textureW;
                       float uvB = 1f - (float)(sp_fill.y + sp_fill.height - sp_fill.borderTop) / (float)textureH;

                       mVisualFieldFillUVs[0] = new Vector2(uvL, uvT);
                       mVisualFieldFillUVs[1] = new Vector2(uvR, uvT);
                       mVisualFieldFillUVs[2] = new Vector2(uvR, uvB);
                       mVisualFieldFillUVs[3] = new Vector2(uvL, uvB);

                       mVisualFieldFillColors[0] = mVisualFieldFillColors[1] = mVisualFieldFillColors[2] = mVisualFieldFillColors[3] = Color.white;                       
                   }
                }
                m_IsVisualFieldChanged = false;
            }

            m_IsActorChanged = false;
            Invalidate(false);//刷新
        }
		 
	}

	/// <summary>
	/// Virtual function called by the UIPanel that fills the buffers.
	/// </summary>

	public override void OnFill (BetterList<Vector3> verts, BetterList<Vector2> uvs, BetterList<Color> cols)
	{
		Texture tex = mainTexture;
		if (tex == null) return;  
        foreach(KeyValuePair<int, HashSet<ActorInfo>> kv in m_ActorsIndexByDepth)
        {
            foreach(ActorInfo curr in kv.Value)
            {
                Vector3[] vertexs = curr.vertexs;
                verts.Add(vertexs[0]);
                verts.Add(vertexs[1]);
                verts.Add(vertexs[2]);
                verts.Add(vertexs[3]);

                Vector2[] actor_uvs = curr.uvs;
                uvs.Add(actor_uvs[0]);
                uvs.Add(actor_uvs[1]);
                uvs.Add(actor_uvs[2]);
                uvs.Add(actor_uvs[3]);

                Color32 color = mIndexColor[curr.ColorHashV];
                cols.Add(color);
                cols.Add(color);
                cols.Add(color);
                cols.Add(color);
            }
        }

        //绘制视野线条
        if (mVisualFieldFillVertexs != null && mVisualFieldFillVertexs.Length==4)
        {
            //Color32 lineColor = Color.white;
             
            int len = VisualFieldLines.Length;
            for (int i = 0; i < len; i++)
            {
                Line curr = VisualFieldLines[i];

                Vector3[] vertexs = curr.vertexs;
                verts.Add(vertexs[0]);
                verts.Add(vertexs[1]);
                verts.Add(vertexs[2]);
                verts.Add(vertexs[3]);

                Vector2[] actor_uvs = curr.uvs;
                uvs.Add(actor_uvs[0]);
                uvs.Add(actor_uvs[1]);
                uvs.Add(actor_uvs[2]);
                uvs.Add(actor_uvs[3]);

                cols.Add(curr.fromColor);
                cols.Add(curr.fromColor);
                cols.Add(curr.toColor);
                cols.Add(curr.toColor);
            } 

            //视野区域填充 
            { 
                verts.Add(mVisualFieldFillVertexs[0]);
                verts.Add(mVisualFieldFillVertexs[1]);
                verts.Add(mVisualFieldFillVertexs[2]);
                verts.Add(mVisualFieldFillVertexs[3]);
 
                uvs.Add(mVisualFieldFillUVs[0]);
                uvs.Add(mVisualFieldFillUVs[1]);
                uvs.Add(mVisualFieldFillUVs[2]);
                uvs.Add(mVisualFieldFillUVs[3]);

                cols.Add(mVisualFieldFillColors[0]);
                cols.Add(mVisualFieldFillColors[1]);
                cols.Add(mVisualFieldFillColors[2]);
                cols.Add(mVisualFieldFillColors[3]);
            }
        }

        int offset = 0;
		if (onPostFill != null)
			onPostFill(this, offset, verts, uvs, cols);
	}
     
    int m_IDSeed = 0;
    Dictionary<uint, Color32> mIndexColor = new Dictionary<uint, Color32>();
  
    SortedDictionary<int, HashSet<ActorInfo>> m_ActorsIndexByDepth = new SortedDictionary<int, HashSet<ActorInfo>>();//按照深度进行索引
    Dictionary<int, ActorInfo> m_ActorsIndexByID = new Dictionary<int, ActorInfo>();//按照id进行索引
    Dictionary<int, ObjInfo> m_ObjsIndexByID = new Dictionary<int, ObjInfo>();
    bool m_IsActorChanged = true;
    bool m_IsVisualFieldChanged = true;
    Line[] VisualFieldLines = null;


    Vector3[] mVisualFieldFillVertexs = null;
    Vector2[] mVisualFieldFillUVs = null;
    Color32[] mVisualFieldFillColors = null;

    /// <summary>
    /// 在画布上绘制的演员
    /// </summary>
    class ActorInfo
    {
        public int id;
        public Vector3[] vertexs = new Vector3[]{
            new Vector3(),
            new Vector3(),
            new Vector3(),
            new Vector3()
        };
        public Vector2[] uvs = new Vector2[]{
            new Vector2(),
            new Vector2(),
            new Vector2(),
            new Vector2()
        };
        public uint ColorHashV;
        public int depth;
        public float width;
        public float height;
        public float harfW;
        public float harfH;
        public bool IsBottomAlign;
    }

    //以对象形式存在物体
    public class ObjInfo
    {
        public int id;
        //public float width;
        //public float height; 
        public UIWidget widget;//控件
    }
    float lostTime = 0;
   
}
