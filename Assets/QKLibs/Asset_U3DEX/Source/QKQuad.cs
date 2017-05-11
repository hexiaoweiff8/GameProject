using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public enum Pivot
{
    TopLeft,
    Top,
    TopRight,
    Left,
    Center,
    Right,
    BottomLeft,
    Bottom,
    BottomRight,
}

 
[RequireComponent(typeof(MeshRenderer))]
[AddComponentMenu("QK/QKQuad")]
public class QKQuad : MonoBehaviour
{
    [SerializeField]
    [HideInInspector]
    Pivot _pivot = Pivot.Center;

    public Pivot pivot
    {
        get { return _pivot; }
        set
        {
            _pivot = value;
            RecalculateVertices();
        }
    }

    void Start()
    {
        _Init();
    } 
    public void _Init()
    {
        Vector2[] uv = new Vector2[4];
        uv[0] = new Vector2(0, 1);
        uv[1] = new Vector2(1, 1);
        uv[2] = new Vector2(1, 0);
        uv[3] = new Vector2(0, 0);
         

        Vector4[] tangents = new Vector4[4];
        tangents[0] = new Vector4(-1, 0, 0, 1);
        tangents[1] = new Vector4(-1, 0, 0, 1);
        tangents[2] = new Vector4(-1, 0, 0, 1);
        tangents[3] = new Vector4(-1, 0, 0, 1);


        int[] triangles = new int[6];
        triangles[0] = 0;
        triangles[1] = 1;
        triangles[2] = 2;
        triangles[3] = 0;
        triangles[4] = 2;
        triangles[5] = 3;


        Mesh mesh = new Mesh();

        MeshFilter meshFilter = GetComponent<MeshFilter>();
        if (meshFilter == null) meshFilter = gameObject.AddComponent<MeshFilter>();
        meshFilter.sharedMesh = mesh;


        mesh.vertices = BuildVertices();
        mesh.uv = uv;
        mesh.triangles = triangles;
        mesh.tangents = tangents;
        mesh.RecalculateNormals();
        RecalculateVertices();
    }
 



    void RecalculateVertices()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.sharedMesh.vertices = BuildVertices();
        meshFilter.sharedMesh.RecalculateBounds();
    }

    Vector3[] BuildVertices()
    {
        Vector3[] vertices = new Vector3[4];
        float minx, maxx, miny, maxy;

        switch (_pivot)
        {
            case Pivot.TopLeft:
                {
                    miny = -1;
                    maxy = 0;
                    minx = 0;
                    maxx = 1;
                }
                break;
            case Pivot.Top:
                {
                    miny = -1;
                    maxy = 0;

                    minx = -0.5f;
                    maxx = 0.5f; 
                }
                break;
            case Pivot.TopRight:
                {
                    miny = -1;
                    maxy = 0;
                    minx = -1;
                    maxx = 0;
                }
                break;
            case Pivot.Left:
                {
                    minx = 0;
                    maxx = 1;
                     
                    miny = -0.5f;
                    maxy = 0.5f;
                }
                break;
            case Pivot.Right:
                {
                    minx = -1;
                    maxx = 0;
                     
                    miny = -0.5f;
                    maxy = 0.5f;
                }
                break;
            case Pivot.BottomLeft:
                {
                    miny = 0;
                    maxy = 1;
                    minx = 0;
                    maxx = 1;
                }
                break;
            case Pivot.Bottom:
                {
                    miny = 0;
                    maxy = 1;

                    minx = -0.5f;
                    maxx = 0.5f;
                }
                break;
            case Pivot.BottomRight:
                {
                    minx = -1;
                    maxx = 0;
                    miny = 0;
                    maxy = 1;
                }
                break;
            default:
                {
                    minx = -0.5f;
                    maxx = 0.5f;
                    miny = -0.5f;
                    maxy = 0.5f;
                }
                break;
        }

        vertices[0] = new Vector3(minx, maxy, 0);
        vertices[1] = new Vector3(maxx, maxy, 0);
        vertices[2] = new Vector3(maxx, miny, 0);
        vertices[3] = new Vector3(minx, miny, 0);
        return vertices;
    }
}

/*
 y朝上 正面向z的负方向 
 */