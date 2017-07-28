using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
class MapGridRender : MonoBehaviour
{
    void Awake()
    {
        mat = PacketManage.Single.GetPacket("rom_share").Load("DefaultMat_Topmust") as Material;
        
    }
    
    void OnPostRender()
    {
        if (!enabled||
            AI_Single.Single == null||
            AI_Single.Single.Battlefield==null||
            AI_Single.Single.Battlefield.GridMap ==null||
            AI_Single.Single.Battlefield.GridMap.m_Grids == null
            ) return;
        
        var grids = AI_Single.Single.Battlefield.GridMap.m_Grids;
        int w = AI_Single.Single.Battlefield.GridMap.m_width;
        int h = AI_Single.Single.Battlefield.GridMap.m_height;
        var gobjs = AI_Single.Single.Battlefield.GridMap.m_Grids;

        float hx = DiamondGridMap.harf_wxs * SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang - 0.05f;
        float hy = SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang - 0.05f;
        float harfC = SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang / 2 - 0.05f;

        var p1 = new Vector3(-hx, 0.1f, -harfC);
        var p2 = new Vector3(0, 0.1f, -SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang);
        var p3 = new Vector3(hx, 0.1f, -harfC);
        var p4 = new Vector3(hx, 0.1f, harfC);
        var p5 = new Vector3(0, 0.1f, SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang);
        var p6 = new Vector3(-hx, 0.1f, harfC);


        var p1_tmp = new Vector3(0, 0.1f, 0);
        var p2_tmp = new Vector3(0, 0.1f, 0);
        var p3_tmp = new Vector3(0, 0.1f, 0);
        var p4_tmp = new Vector3(0, 0.1f, 0);
        var p5_tmp = new Vector3(0, 0.1f, 0);
        var p6_tmp = new Vector3(0, 0.1f, 0);

        mat.SetPass(0);
       //  GL.PushMatrix();
       // GL.MultMatrix(
            //g.transform.transform.localToWorldMatrix
       //     Matrix4x4.identity
       //     );

        GL.Begin(GL.LINES);
        
        for (int z = 0; z < h; z++)
        {
            for (int x = 0; x < w; x++)
            {
                //绘制一个格子
                var g = gobjs[z, x];
                var WorldX = g.WorldX;
                var WorldZ = g.WorldZ;

                p1_tmp.x = p1.x + WorldX;
                p1_tmp.z = p1.z + WorldZ;

                p2_tmp.x = p2.x + WorldX;
                p2_tmp.z = p2.z + WorldZ;

                p3_tmp.x = p3.x + WorldX;
                p3_tmp.z = p3.z + WorldZ;

                p4_tmp.x = p4.x + WorldX;
                p4_tmp.z = p4.z + WorldZ;

                p5_tmp.x = p5.x + WorldX;
                p5_tmp.z = p5.z + WorldZ;

                p6_tmp.x = p6.x + WorldX;
                p6_tmp.z = p6.z + WorldZ;

                Color dcolor = g.IsObstacle ? Color.red  :  Color.green ;
                GL.Color(dcolor);
                GL.Vertex(p1_tmp);
                GL.Vertex(p2_tmp);
              

                GL.Vertex(p2_tmp);
                GL.Vertex(p3_tmp);
                //GL.Color(dcolor);

                GL.Vertex(p3_tmp);
                GL.Vertex(p4_tmp);
                //GL.Color(dcolor);

                GL.Vertex(p4_tmp);
                GL.Vertex(p5_tmp);
                //GL.Color(dcolor);
               
                GL.Vertex(p5_tmp);
                GL.Vertex(p6_tmp);
                //GL.Color(dcolor);
              
                GL.Vertex(p6_tmp);
                GL.Vertex(p1_tmp);
              //  GL.Color(dcolor);
            }
        }
        GL.End();
       // GL.PopMatrix();

    }
     

    Material mat;
} 
