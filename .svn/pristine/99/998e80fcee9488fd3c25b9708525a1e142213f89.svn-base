using UnityEngine;
using System.Collections;

public class WndScaleTest : MonoBehaviour
{

    public float FadeTime=0.5f;//过渡时间

 
    public void DoTest()
    {
        if (GameConfig.Single == null)
        {
            Debug.Log("请在Game模式下测试");
            return;
        }

        TweenScale cmscale = GetComponent<TweenScale>();
        if (cmscale != null) GameObject.Destroy(cmscale);
        
        cmscale = gameObject.AddComponent<TweenScale>();
        
        //var gamecfg =  GameObject.Instantiate(Resources.Load("rom_share/GameConfig")) as GameObject;
        //GameConfig cmGameCfg = gamecfg.GetComponent<GameConfig>();

        cmscale.from = Vector3.zero;
        cmscale.to = Vector3.one;
        cmscale.style = UITweener.Style.Once;
        cmscale.duration = FadeTime;
        cmscale.animationCurve = WndConfig.Single.WndScaleEnterCurve;
        cmscale.PlayForward();
    }
}
