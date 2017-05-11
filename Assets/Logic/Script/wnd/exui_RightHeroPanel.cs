using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;
 
//左英雄面板
class exui_RightHeroPanel:IDisposable
{
    public exui_RightHeroPanel()
    {
        //克隆出其它英雄item
        var Instance = wnd_fight.Single.Instance;
        m_DefenceRoot = Instance.FindWidget("defence_widget/content");
        var heroContent = m_DefenceRoot.transform.FindChild("hero1/content").gameObject;

        //克隆出其它buff图标
        {
            var bufficon = GameObjectExtension.FindChild(heroContent.transform, "enemybuffgrid/buff_icon").gameObject;
            bufficon.name = "buff_icon1";
            bufficon.SetActive(false);
            var buffGird = bufficon.transform.parent.gameObject;

            for (int i = 2; i <= BuffIconManage.BuffIconCount; i++)
            {
                var newBuffIcon = GameObjectExtension.InstantiateFromPreobj(bufficon, buffGird);
                newBuffIcon.name = "buff_icon" + i.ToString();
            }
        }


        for (int i = 2; i < 6; i++)
        {
            var n = GameObjectExtension.InstantiateFromPreobj(heroContent, m_DefenceRoot.transform.FindChild("hero" + i.ToString()).gameObject);
            n.name = "content";
            n.SetActive(false);//隐藏面板
        }
        heroContent.SetActive(false);


        //绑定点击事件
        for (int i = 1; i < 6; i++)
        {
            var hc = m_DefenceRoot.transform.FindChild(string.Format("hero{0}/content", i)).gameObject;
            var headID = i;
            UIEventListener.Get(hc).onClick += (GameObject go) =>
            {
                foreach (var attrkv in m_HeroAttrsByFID)
                {
                    var attr = attrkv.Value;
                    if (attr.HeadID != headID) continue;

                    if (attr.UIHP.value >= QKMath.PRECISION)
                    {
                        DP_Battlefield.Single.CameraFocusFID(false, attr.Fid);
                        DP_CameraTrackObjectManage.Single.OnInterruptLookAround();
                    }
                }
            };
        }

        YQ2CameraCtrl.Single.OnInterruptObjMode += OnInterruptObjMode;
     }

    public void StopMPTweens()
    {
        foreach (var currkv in m_HeroAttrsByFID)
        {
            var attr = currkv.Value;
            attr.KillMPTweener();
        }
    }

    public int SetCurrHeroFID(int fid)
    {
        if (m_CurrHero != null && m_CurrHero.Fid == fid) return m_CurrHero.ActorID;//无需设置
        /*
        if (m_CurrHero != null)//之前的当前英雄平滑缩小
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
        }
        */
        m_CurrHero = m_HeroAttrsByFID.ContainsKey(fid) ? m_HeroAttrsByFID[fid] : null;

        /*
        //新的当前英雄平滑放大
        if (m_CurrHero != null)
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1.2f, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
            return m_CurrHero.ActorID;
        }*/

        if (m_CurrHero != null)
        {
            wnd_fight.Single.SetSelectHero(m_CurrHero.ui);
            return m_CurrHero.ActorID;
        }
        else
            wnd_fight.Single.SetSelectHero(null);

        return -1;
    }

    public bool SetCurrHeroActorID(int actorID)
    {
        if (m_CurrHero != null && m_CurrHero.ActorID == actorID) return true;//无需设置
        /*
        if (m_CurrHero != null)//之前的当前英雄平滑缩小
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
        }*/

        m_CurrHero = null;

        foreach (var h in m_HeroAttrsByFID)
        {
            if (h.Value.ActorID == actorID) { m_CurrHero = h.Value; break; }
        }
        /*
        //新的当前英雄平滑放大
        if (m_CurrHero != null)
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1.2f, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
        }
        */
        if (m_CurrHero != null)
            wnd_fight.Single.SetSelectHero(m_CurrHero.ui);
        else
            wnd_fight.Single.SetSelectHero(null);

        return m_CurrHero != null;
    }


    //目标相机模式被打断
    void OnInterruptObjMode()
    {
        SetCurrHeroFID(-1);
    }

    public void Reset()
    {
        StopAllTweener();
        foreach (var currkv in m_HeroAttrsByFID)
        {
            var attr = currkv.Value;
            attr.ui.SetActive(false);//隐藏掉头像面板
            attr.ui.transform.localScale = Vector3.one;
            attr.BuffIconManage.Reset();

            attr.UIDead.SetActive(false);
            attr.UIIcon.UseManualMaterial = false; 
        }
        m_HeroAttrsByFID.Clear();
        m_CurrHero = null;
        m_EmptyHeadID = 1;
    }

    /// <summary>
    /// 检查英雄是否存在
    /// </summary>
    public bool HasHeroByFID(int fid) { return m_HeroAttrsByFID.ContainsKey(fid); }

    public void Dispose()  {    StopAllTweener(); }

    void StopAllTweener()
    {
        foreach (var currkv in m_HeroAttrsByFID)
        {
            var attr = currkv.Value;
            attr.KillHPTweener();
            attr.KillMPTweener();
            //attr.KillHeadScaleTweener();
            attr.KillSoldiersCountTweener();
        }  
    }

    public void CDChangeFID(int fid, float StartBfb, float fullTime)
    {
        //if (!HasHero(dataID)) CreateHero(fid, dataID);
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.KillMPTweener();

        heroAttr.UIMP.value = StartBfb;
        //if (fullTime > 99999) { heroAttr.UIMP.value = 0; }
        heroAttr.MPTweener = DOTween.To(() => heroAttr.UIMP.value, (v) => heroAttr.UIMP.value = v, 1, fullTime).SetAutoKill().SetEase(Ease.Linear);
    }

    public void BuffIconChangeFID(int fid, int bid, string icon)
    {
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.BuffIconManage.BuffIconChange(bid, icon);
    }

    
    public void HPChangeFID( int fid,float hpBfb)
    {
        //if (!HasHero(dataID)) CreateHero(fid, dataID);

        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.KillHPTweener();
        heroAttr.HPTweener = DOTween.To(() => heroAttr.UIHP.value, (v) => heroAttr.UIHP.value = v, hpBfb, 0.1f).SetAutoKill().SetEase(Ease.OutQuart);


        //英雄已经挂了 
        if (hpBfb < QKMath.PRECISION)
        {
            heroAttr.KillMPTweener();//停止手动CD
            heroAttr.UIHP.value = 0;
            heroAttr.UIMP.value = 0;

            //设置死亡标记
            heroAttr.UIDead.SetActive(true);
            heroAttr.UIIcon.UseManualMaterial = true; 
        } 
    }

    public void CreateHero(byte fid, int dataID,int actorID)
    {
        if (HasHeroByFID(fid)) return;
        var attr = new HeroAttr();
        attr.Fid = fid;
        attr.DataID = dataID;
        attr.ActorID = actorID;
        attr.HeadID = m_EmptyHeadID++;
        attr.ui = m_DefenceRoot.transform.FindChild("hero" + attr.HeadID.ToString() + "/content").gameObject;
        attr.ui.SetActive(true);
        

        var heroInfo = SData_Hero.Get(dataID);
        
        var head_imgT = GameObjectExtension.FindChild(attr.ui.transform, "head_widget/head_img");

        var UIBuffGrid = GameObjectExtension.FindChild(attr.ui.transform, "enemybuffgrid").gameObject.GetComponent<UIGrid>();//buff格子
        attr.BuffIconManage = new BuffIconManage(UIBuffGrid,false);
        for (int i = 1; i <= BuffIconManage.BuffIconCount; i++)
        {
            var bufficon = UIBuffGrid.transform.Find("buff_icon" + i.ToString()).GetComponent<UISprite>();
            attr.BuffIconManage.AddFreeIcon(bufficon);
        }

        attr.UIDead = GameObjectExtension.FindChild(attr.ui.transform, "dead").gameObject;
        attr.UIIcon = head_imgT.gameObject.GetComponent<QKUISprite>();
        //attr.UIName =   GameObjectExtension.FindChild(attr.ui.transform, "name_bg/txt").gameObject.GetComponent<UILabel>();
        attr.UIHP =  GameObjectExtension.FindChild(attr.ui.transform, "hpmp_widget/hp_bg").gameObject.GetComponent<UIProgressBar>();
        attr.UIMP =   GameObjectExtension.FindChild(attr.ui.transform, "hpmp_widget/mp_bg").gameObject.GetComponent<UIProgressBar>();
        attr.UIHead = GameObjectExtension.FindChild(attr.ui.transform, "bg/head_widget").gameObject;

        attr.UISoldierNum = GameObjectExtension.FindChild(attr.ui.transform, "soldier_num/txt").gameObject.GetComponent<UILabel>(); 
        attr.UIMP.value = 0;

        //LuaHeroInfoLibs.SetHeroIcon(attr.UIIcon, heroInfo); //设置英雄头像       
        m_HeroAttrsByFID.Add(attr.Fid, attr);
    }


    public void SoldiersCountChangeFID(int fid, int num)
    {
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.KillSoldiersCountTweener();
        heroAttr.SoldiersCountTweener = DOTween.To(() => int.Parse(heroAttr.UISoldierNum.text), (int v) => heroAttr.UISoldierNum.text = v.ToString(), num, 0.1f).SetAutoKill().SetEase(Ease.OutQuart);
    }

    class HeroAttr
    {
        public GameObject ui;
        public GameObject UIDead;
        public QKUISprite UIIcon; 
        public UIProgressBar UIHP;
        public UIProgressBar UIMP;
        public GameObject UIHead;
        public UILabel UISoldierNum;

        public Tweener HPTweener = null;
        public Tweener MPTweener = null;
       // public Tweener HeadScaleTweener = null;//头像缩放补间
        public Tweener SoldiersCountTweener = null;

        public BuffIconManage BuffIconManage;
         
        public int DataID;//数据ID
        public int ActorID;//演员ID
        public int Fid; //阵位ID
        public int HeadID;//界面上的头像位置
        
        //public void KillHeadScaleTweener() { if (HeadScaleTweener != null) { HeadScaleTweener.Kill(); HeadScaleTweener = null; } }

        public void KillMPTweener() { if (MPTweener != null) { MPTweener.Kill(); MPTweener = null; } }
        public void KillHPTweener() { if (HPTweener != null) { HPTweener.Kill(); HPTweener = null; } }
        public void KillSoldiersCountTweener() { if (SoldiersCountTweener != null) { SoldiersCountTweener.Kill(); SoldiersCountTweener = null; } }

    }
    Dictionary<int, HeroAttr> m_HeroAttrsByFID = new Dictionary<int, HeroAttr>();
    GameObject m_DefenceRoot;
    HeroAttr m_CurrHero = null;
    int m_EmptyHeadID = 1;
}
 