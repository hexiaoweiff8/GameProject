using UnityEngine;
using System.Collections;

public class BloodBar : MonoBehaviour
{
    private UISprite BloodBarSprite1;
    private UISprite BloodBarSprite2;
    private UISprite shieldHP;
    private static bool isStart = false;

    //private float timeFlag = 0f;
    // Use this for initialization
    void Start()
    {
        BloodBarSprite1 = transform.Find("delta").GetComponent<UISprite>();
        BloodBarSprite2 = transform.Find("fore").GetComponent<UISprite>();
        shieldHP = transform.Find("shield").GetComponent<UISprite>();
        this.gameObject.SetActive(false);

        if (!isStart)
        {
            FightManager.Single.SetHealthChangeAction(ShowHurtNum);
            isStart = true;
        }
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

        //timeFlag += Time.deltaTime;
        //if (timeFlag > 0.3f)
        //{
        //    ShowHurtNum(10,Random.Range(0,4));
        //    timeFlag = 0f;
        //}
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


    /// <summary>
    /// 目标受到伤害或者加血等的血条上的文字效果
    /// </summary>
    /// <param name="packer">生命值变更包装类</param>
    public static void ShowHurtNum(FightManager.HealthChangePacker packer)
    {
        if (packer.ObjType == ObjectID.ObjectType.MyJiDi || packer.ObjType == ObjectID.ObjectType.EnemyJiDi)
        {
            Tools.CallMethod("userInfo_controller", "changeJiDiHP", (int)packer.ObjType, packer.CurrentHp, packer.TotalHp);
        }
        else
        {
            int hurtNum_int = (int)packer.ChangeValue;
            BloodBar mgo = packer.GameObj.GetComponent<RanderControl>().bloodBarCom;
            Transform deltaHP = GameObjectExtension.InstantiateFromPacket("ui_fightu", "deltaHP.prefab", mgo.gameObject).transform;
            deltaHP.localPosition = new Vector3(Random.value * 50 - 25, -Random.value * 20, 0);
            EventDelegate _event = new EventDelegate(mgo, "DestroyDeltaHP");
            _event.parameters[0] = new EventDelegate.Parameter(deltaHP);
            deltaHP.GetChild(0).GetComponent<TweenPosition>().AddOnFinished(_event);
            switch (packer.HurtType)
            {
                case FightManager.HurtType.NormalAttack://普通
                    deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.white;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "" + hurtNum_int;
                    break;
                case FightManager.HurtType.Crit://暴击
                    deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = "zhandou_yuan_xuanzhong";
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.red;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "" + hurtNum_int;
                    break;
                case FightManager.HurtType.SkillAttack://技能
                    deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.blue;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "" + hurtNum_int;
                    break;
                case FightManager.HurtType.Miss://miss
                    deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.gray;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "miss";
                    break;
                case FightManager.HurtType.Cure://治疗
                    deltaHP.GetChild(0).GetComponent<UISprite>().spriteName = null;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().color = Color.green;
                    deltaHP.GetChild(0).GetChild(0).GetComponent<UILabel>().text = "+" + hurtNum_int;
                    break;


            }
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
