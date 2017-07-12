using UnityEngine;
using System.Collections;

public class BloodBar : MonoBehaviour
{
    private UISprite BloodBarSprite1;
    private UISprite BloodBarSprite2;
    // Use this for initialization
    void Start()
    {
        BloodBarSprite1 = transform.Find("bg1").GetComponent<UISprite>();
        BloodBarSprite2 = transform.Find("bg2").GetComponent<UISprite>();
    }


    void Awake()
    {
        Start();
    }

    // Update is called once per frame
    void Update()
    {
        if (BloodBarSprite1.fillAmount > BloodBarSprite2.fillAmount)
        {
            BloodBarSprite1.fillAmount -= 0.015f;
        }
    }

    /// <summary>
    /// 设置血条百分比
    /// </summary>
    /// <param name="value"></param>
    public void SetBloodBarValue(float value)
    {
        BloodBarSprite2.fillAmount = value;
    }

    //TODODO 将来用对象池
    /// <summary>
    /// 销毁自身
    /// </summary>
    public void DestorySelf()
    {
        Object.Destroy(gameObject);
    }
}
