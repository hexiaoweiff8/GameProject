using UnityEngine;
using System.Collections;
using DG.Tweening;
using UnityEngine.Rendering;

public class ChatBubbleAni : MonoBehaviour
{

    private  const float AniTime = 1f;//动画所用时间

    /// <summary>
    /// 气泡下一条信息的动画
    /// </summary>
    /// <param name="index"></param>
    public static void NextMessageAni(int index,GameObject go1,GameObject go2)
    {

        Sequence mysquence =  DOTween.Sequence(); 
        //print("调用NextMessageAni");
        if (index == 1)//显示1
        {
            //Tweener moveUp = go1.transform.DOLocalMoveY(60, AniTime);
            //Tweener alpha1 = go1.transform.GetComponent<Material>().DOColor(new Color(1, 1, 1, 0),AniTime);

            mysquence.Append(go1.transform.DOLocalMoveY(0, AniTime));
            mysquence.Join(go2.transform.DOLocalMoveY(60, AniTime));
            mysquence.AppendCallback(() =>
            {
                //print("动画完成！");
                go2.transform.localPosition = new Vector3(0,-60,0);

            });
            //Color go1_color = go1.GetComponent<UIWidget>().color;
            //mysquence.Join(DOTween.ToAlpha(() => go1_color, x => go1.GetComponent<UIWidget>().color = x, 0f, AniTime));

        }
        else//显示2
        {
            mysquence.Append(go2.transform.DOLocalMoveY(0, AniTime));
            mysquence.Join(go1.transform.DOLocalMoveY(60, AniTime));
            mysquence.AppendCallback(() =>
            {
                //print("动画完成！");
                go1.transform.localPosition = new Vector3(0, -60, 0);
            });
        }
        //mysquence.Play();

    }

    
}
