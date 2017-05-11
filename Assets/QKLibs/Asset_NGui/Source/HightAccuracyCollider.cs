using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 高精度碰检组件
/// </summary>
[AddComponentMenu("QK/HightAccuracyCollider")]
public class HightAccuracyCollider : MonoBehaviour
{
    /*
    void Start()
    {
       // g_Widgets.Add(this);
    }

    void OnDestroy()
    {
        //g_Widgets.Remove(this);
    }*/

    void OnPress(bool isPressed)
    {
        if (isPressed)
        {
            GameObject obj = Raycast();
            if (obj != null)
            {
                m_pressdObj = obj;
                m_pressdObj.SendMessage("OnPixelPress", isPressed);
            }
        }
        else
        {
            if (m_pressdObj != null)
            {
                m_pressdObj.SendMessage("OnPixelPress", isPressed);
                m_pressdObj = null;
            }
        }
    }


    void OnClick()
    {
        GameObject obj = Raycast();
        if(obj!=null) obj.SendMessage("OnPixelClick");//通知被点击  
    }


    GameObject Raycast()
    {
        Ray ray = UICamera.currentRay; //取得点击射线
        RaycastHit[] hits = Physics.RaycastAll(ray);//取得所有被射线击中的游戏物体

        SortedDictionary<float, List<RaycastHit>> sortedHits = new SortedDictionary<float, List<RaycastHit>>();

        //按照距离从近到远进行排序
        foreach (RaycastHit curr in hits)
        {
            if (!sortedHits.ContainsKey(curr.distance))
                sortedHits.Add(curr.distance, new List<RaycastHit>());

            sortedHits[curr.distance].Add(curr);
        }

        //对物体进行深入检查
        foreach (KeyValuePair<float, List<RaycastHit>> curr in sortedHits)
        {
            foreach (RaycastHit hit in curr.Value)
            {
                HightAccuracyCollider cmPixelWidget = hit.transform.GetComponent<HightAccuracyCollider>();
                if (cmPixelWidget == null || !cmPixelWidget.enabled) continue;

                Renderer cmRenderer = hit.transform.GetComponent<Renderer>();
                if (cmRenderer == null) continue;
                Material mat = cmRenderer.material;
                if (mat == null) continue;

                Texture2D tx2d = mat.mainTexture as Texture2D;
                if (tx2d == null) continue;

                var coordx = hit.textureCoord.x;
                var coordy = hit.textureCoord.y;
                coordx *= mat.mainTextureScale.x;
                coordy *= mat.mainTextureScale.y;
                coordx += mat.mainTextureOffset.x;
                coordy += mat.mainTextureOffset.y;

                coordx = SLerpUV(coordx);
                coordy = SLerpUV(coordy);

                Color color = tx2d.GetPixel((int)(tx2d.width * coordx), (int)(tx2d.height * coordy));
                if (color.a > 0.01)  return hit.transform.gameObject; 
            }
        }

        return null;
    }

    //对UV进行球形插值，保证范围在0-1之间
    float SLerpUV(float v)
    {
       float re =(float) Math.IEEERemainder(v, 1.0f);
        if(re<0) re = 1.0f - Mathf.Abs(re);
        return re;
    }

    GameObject m_pressdObj = null;
    //static HashSet<HightAccuracyCollider> g_Widgets = new HashSet<HightAccuracyCollider>();
}
