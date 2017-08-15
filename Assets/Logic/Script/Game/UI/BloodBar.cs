using UnityEngine;
using System.Collections;

public class BloodBar : MonoBehaviour
{
    private UISprite BloodBarSprite1;
    private UISprite BloodBarSprite2;
    private UISprite shieldHP;

    private float timeFlag = 0f;
    // Use this for initialization
    void Start()
    {
        BloodBarSprite1 = transform.Find("delta").GetComponent<UISprite>();
        BloodBarSprite2 = transform.Find("fore").GetComponent<UISprite>();
        shieldHP = transform.Find("shield").GetComponent<UISprite>();
        this.gameObject.SetActive(false);
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

        timeFlag += Time.deltaTime;
        if (timeFlag > 0.3f)
        {
            ShowHurtNum(10,Random.Range(0,4));
            timeFlag = 0f;
        }
    }

    /// <summary>
    /// 设置血条百分比
    /// </summary>
    /// <param name="value"></param>
    public void SetBloodBarValue(float value)
    {
        if (value < 1)
        {
            this.gameObject.SetActive(true);
            shieldHP.gameObject.SetActive(true);
        }
        BloodBarSprite2.fillAmount = value;
    }



    public void ShowHurtNum(float hurtNum, int hurtType)
    {
        Transform deltaHP = GameObjectExtension.InstantiateFromPacket("ui_fightU", "deltaHP.prefab", this.gameObject).transform;
        deltaHP.localPosition = new Vector3(Random.value * 50 - 25, -Random.value * 20, 0);
        EventDelegate _event = new EventDelegate(this, "DestroyDeltaHP");
        _event.parameters[0] = new EventDelegate.Parameter(deltaHP);
        deltaHP.GetChild(0).GetComponent<TweenPosition>().AddOnFinished(_event);
        switch (hurtType)
        {
            case 0://普通
                deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.white;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "" + hurtNum;
                break;
            case 1://暴击
                deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = "zhandou_yuan_xuanzhong";
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.red;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "" + hurtNum;
                break;
            case 2://技能
                deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.blue;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "" + hurtNum;
                break;
            case 3://miss
                deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.gray;
                deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "miss";
                break;


        }
       
    }

    void DestroyDeltaHP(Transform go)
    {
        Object.Destroy(go.gameObject);
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
