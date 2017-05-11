using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;
 
//左英雄面板
class exui_LeftHeroPanel:IDisposable
{
   
    public exui_LeftHeroPanel()
    {
        //克隆出其它英雄item
        var Instance = wnd_fight.Single.Instance;
        m_Attackroot = Instance.FindWidget("attack_widget/content");
        var heroContent = m_Attackroot.transform.FindChild("hero1/content").gameObject;

        //克隆出其它buff图标
        {
            var bufficon = GameObjectExtension.FindChild(heroContent.transform, "buffgird/buff_icon").gameObject;
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
            var n = GameObjectExtension.InstantiateFromPreobj(heroContent, m_Attackroot.transform.FindChild("hero" + i.ToString()).gameObject);
            n.name = "content";
            n.SetActive(false);//隐藏面板
        }
        heroContent.SetActive(false);

        //绑定点击事件
        for (int i = 1; i < 6; i++)
        {
            var hc = m_Attackroot.transform.FindChild(string.Format("hero{0}/content", i)).gameObject;
            var headID = i;
            UIEventListener.Get(hc).onClick += (GameObject go) =>
            {
                foreach (var attrkv in m_HeroAttrsByFID)
                {
                    var attr = attrkv.Value;
                    if (attr.HeadID != headID) continue;

                    if (attr.UIHP.value >= QKMath.PRECISION)
                    {
                        DP_Battlefield.Single.CameraFocusFID(true, attr.Fid);
                        DP_CameraTrackObjectManage.Single.OnInterruptLookAround();
                    }
                }
            };

            var skillIcon = hc.transform.FindChild("skill_widget").gameObject;
            UIEventListener.Get(skillIcon).onClick += (GameObject go) =>
            {
                foreach (var attrkv in m_HeroAttrsByFID)
                {
                    var attr = attrkv.Value;
                    if (attr.HeadID != headID) continue;

                    var aicmd = new AICmd_SDSkill();
                    aicmd.fid = attr.Fid;
                    DP_BattlefieldDraw.Single.PushAICmd(aicmd);

                    attr.UISDSkill.SetActive(false);//隐藏手动图标
                }
            };
        }

        YQ2CameraCtrl.Single.OnInterruptObjMode += OnInterruptObjMode;

        var PhotoStudioCameraObj = GameObject.Find("PhotoStudioCamera");
        CMPhotoStudio = PhotoStudioCameraObj.GetComponent<YQ2PhotoStudio>();
        CMPhotoStudioCamera = PhotoStudioCameraObj.GetComponent<Camera>();
    }

 

    //目标相机模式被打断
    void OnInterruptObjMode()
    {
        SetCurrHeroFID(-1);
    }

    public int SetCurrHeroFID(int fid)
    {
        if (m_CurrHero != null && m_CurrHero.Fid == fid) return m_CurrHero.ActorID;//无需设置
        
        if (m_CurrHero != null)//之前的当前英雄平滑缩小
        { 
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
        }
        
        m_CurrHero = m_HeroAttrsByFID.ContainsKey(fid) ? m_HeroAttrsByFID[fid] : null;
      
        //新的当前英雄平滑放大
        if(m_CurrHero!=null)
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1.2f, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);

            return m_CurrHero.ActorID;
        } 
        /*
        if (m_CurrHero != null)
        {
            wnd_fight.Single.SetSelectHero(m_CurrHero.ui);
            return m_CurrHero.ActorID;
        }*/
        return -1;
    }

    public bool SetCurrHeroActorID(int actorID)
    {
        if (m_CurrHero != null && m_CurrHero.ActorID == actorID) return true;//无需设置

    
        if (m_CurrHero != null)//之前的当前英雄平滑缩小
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
        }
 
        m_CurrHero = null;

        foreach (var h in m_HeroAttrsByFID)
        {
            if (h.Value.ActorID == actorID) { m_CurrHero = h.Value; break; }
        }

      
        //新的当前英雄平滑放大
        if (m_CurrHero != null)
        {
            m_CurrHero.KillHeadScaleTweener();
            m_CurrHero.HeadScaleTweener = m_CurrHero.ui.transform.DOScale(1.2f, 0.3f).SetAutoKill().SetEase(Ease.OutQuart); 
        }

        /*
        if (m_CurrHero != null)
            wnd_fight.Single.SetSelectHero(m_CurrHero.ui);
*/
        return m_CurrHero != null;
    }


    public void StopMPTweens()
    {
        foreach (var currkv in m_HeroAttrsByFID)
        {
            var attr = currkv.Value;
            attr.KillMPTweener();
        }
    }

    public void Reset()
    {
        StopAllTweener();
        foreach (var currkv in m_HeroAttrsByFID)
        {
            var attr = currkv.Value;
            attr.ui.SetActive(false);//隐藏掉头像面板
            attr.ui.transform.localScale = Vector3.one;
            attr.UISDSkillYinchangSlider.alpha = 0;//隐藏手动技能吟唱
            attr.UISDSkill.transform.localPosition = attr.UISDSkillEndPos;
            attr.UISDSkill.SetActive(false);//隐藏掉手动技能面板
            attr.BuffIconManage.Reset();
            attr.UIDead.SetActive(false);
            attr.UIIcon.UseManualMaterial = false;
        }
        m_HeroAttrsByFID.Clear();
        m_CurrHero = null;
        m_CameraFocusFID = 999;
        m_CurrYinchangHero = -1;
        m_EmptyHeadID = 1;

        DisablePhtoStudio();
      
              
    }

    void DisablePhtoStudio()
    {
        Vector3 pos = Vector3.zero;

        if (CMPhotoStudio != null)
        { 
            if (CMPhotoStudio.actor != null)
            {
                CMPhotoStudio.actor.layer = 8;//还原到角色层
                pos = CMPhotoStudio.actor.transform.position;
            }
            CMPhotoStudio.actor = null;
            CMPhotoStudio.enabled = false;
        }
        if (CMPhotoStudioCamera != null) CMPhotoStudioCamera.enabled = false;


        wnd_fight.Single.HideAvatarTexture(pos);
    }

     void StopAllTweener()
    {
        foreach (var currkv in m_HeroAttrsByFID)
        {
            var attr = currkv.Value;
            attr.KillHPTweener();
            attr.KillMPTweener();
            attr.KillHeadScaleTweener();
            attr.KillSoldiersCountTweener();
            attr.KillSkillIconTweener();
            attr.KillYinchangTweener();
        }  
    }

    /// <summary>
    /// 检查英雄是否存在
    /// </summary>
     public bool HasHeroFID(int fid) { return m_HeroAttrsByFID.ContainsKey(fid); }

    public void Dispose()     {   StopAllTweener(); }

    public void ActiveShoudongFID(  int fid )
    { 
        var heroAttr = m_HeroAttrsByFID[fid]; 
        heroAttr.KillSkillIconTweener();

        heroAttr.UISDSkill.SetActive(true);//激活手动技能按钮
        heroAttr.UISDSkill.transform.localPosition = heroAttr.UISDSkillStartPos;//设定初始位置
        var toPos = heroAttr.UISDSkillEndPos;//取得目标位置
        heroAttr.SkillIconTweener = heroAttr.UISDSkill.transform.DOLocalMove(toPos, 0.3f).SetAutoKill().SetEase(Ease.OutQuart);
    }

    public void CDChangeFID( int fid,   float StartBfb, float fullTime)
    { 
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.KillMPTweener();

        heroAttr.UIMP.value = StartBfb;
        heroAttr.MPTweener = DOTween.To(() => heroAttr.UIMP.value, (v) => heroAttr.UIMP.value = v, 1, fullTime).SetAutoKill().SetEase(Ease.Linear); 
    }

    public void BuffIconChangeFID(int fid, int bid, string icon)
    {
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.BuffIconManage.BuffIconChange(bid, icon);
    }

    public void HPChangeFID(  int fid,   float hpBfb)
    { 
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.KillHPTweener();
        heroAttr.HPTweener = DOTween.To(() => heroAttr.UIHP.value, (v) => heroAttr.UIHP.value = v, hpBfb, 0.1f).SetAutoKill().SetEase(Ease.OutQuart); 

        //英雄已经挂了
        if (hpBfb < QKMath.PRECISION) { 
            heroAttr.KillMPTweener();//停止手动CD
            heroAttr.UIHP.value = 0;
            heroAttr.UIMP.value = 0;
            heroAttr.UISDSkill.SetActive(false);//隐藏手动图标

            //设置死亡标记
            heroAttr.UIDead.SetActive(true);
            heroAttr.UIIcon.UseManualMaterial = true;

            heroAttr.UIBinsi.SetActive(false);//隐藏濒死状态

            HideBigYinchangAvatar(heroAttr);
        }
    }

    public void YinchangFID(int fid, float time,bool Daduan = false)
    {
        if (!m_HeroAttrsByFID.ContainsKey(fid)) return;

        var heroAttr = m_HeroAttrsByFID[fid];

        if (time == 0)
        {
            HideBigYinchangAvatar(heroAttr);

            heroAttr.KillYinchangTweener();
            heroAttr.UISDSkillYinchangSlider.value = 0;
            //heroAttr.UISDSkillYinchang.SetActive(false);
            heroAttr.UISDSkillYinchangTweener.PlayReverse();
            if (Daduan)//显示打断
            {
                heroAttr.UIFailTweener.ResetToBeginning();
                heroAttr.UIFailTweener.DOPlayForward();
            }
        }
        else
        {

            ShowBigYinchangAvatar(heroAttr);

            heroAttr.UISDSkillYinchang.SetActive(true);
            heroAttr.KillYinchangTweener();
            heroAttr.UISDSkillYinchangSlider.value = 0;
            heroAttr.UISDSkillYinchangTweener.PlayForward();

            heroAttr.UISDSkillYinchangSlider.alpha = 1;
            heroAttr.YinchangTweener = DOTween.To(() => heroAttr.UISDSkillYinchangSlider.value, (v) => heroAttr.UISDSkillYinchangSlider.value = v, 1, time).SetAutoKill().SetEase(Ease.Linear);
        }
         
    }

    /// <summary>
    /// 显示放大的角色效果
    /// </summary>
    void ShowBigYinchangAvatar(HeroAttr attr)
    {
        Transform tr; float dirX;
        DP_BattlefieldDraw.Single.GetActorTransfrom(attr.ActorID, out tr, out dirX);

        if (tr == null) return;

        m_CurrYinchangHero = attr.DataID;

    
        
        DisablePhtoStudio();
         
        CMPhotoStudio.actor = tr.gameObject;
        CMPhotoStudio.offset = new Vector3(0,18,0);
        //CMPhotoStudio.Distance = 100;
        //CMPhotoStudio.roomRotation = tr.transform.eulerAngles;
        CMPhotoStudio.SetDirty();
        CMPhotoStudio.enabled = true; 
        CMPhotoStudioCamera.enabled = true;

        wnd_fight.Single.ShowAvatarTexture();
    }

    void HideBigYinchangAvatar(HeroAttr attr)
    {
        if (m_CurrYinchangHero != attr.DataID) return;

        DisablePhtoStudio();
    }

    public void SoldiersCountChangeFID( int fid , int num)
    {
        var heroAttr = m_HeroAttrsByFID[fid];
        heroAttr.KillSoldiersCountTweener();
        heroAttr.SoldiersCountTweener = DOTween.To(() => int.Parse(heroAttr.UISoldierNum.text), (int v) => heroAttr.UISoldierNum.text = v.ToString(), num, 0.1f).SetAutoKill().SetEase(Ease.OutQuart); 
    }

    /// <summary>
    /// 创建英雄
    /// </summary>
    /// <param name="fid">阵位ID</param>
    /// <param name="dataID">静态数据ID</param>
    /// <param name="actorID">演员ID</param>
    public void CreateHero(byte fid, int dataID,int actorID,int hxj)
    {
        if (HasHeroFID(fid)) return;
        var attr = new HeroAttr();
        attr.Fid = fid;
        attr.DataID = dataID;
        attr.ActorID = actorID;
        attr.HeadID = m_EmptyHeadID++;
        attr.ui = m_Attackroot.transform.FindChild("hero" + attr.HeadID.ToString() + "/content").gameObject;
        attr.ui.SetActive(true);
        

        var heroInfo = SData_Hero.Get(dataID);

        var head_imgT = GameObjectExtension.FindChild(attr.ui.transform, "head_widget/head_img");

        var UIBuffGrid = GameObjectExtension.FindChild(attr.ui.transform, "buffgird").gameObject.GetComponent<UIGrid>();//buff格子
        attr.BuffIconManage = new BuffIconManage(UIBuffGrid,true); 
        for (int i = 1; i <= BuffIconManage.BuffIconCount; i++)
        {
            var bufficon = UIBuffGrid.transform.Find("buff_icon" + i.ToString()).GetComponent<UISprite>();
            attr.BuffIconManage.AddFreeIcon(bufficon); 
        }


        attr.UIDead = GameObjectExtension.FindChild(attr.ui.transform, "dead").gameObject;

        attr.UIIcon = head_imgT.gameObject.GetComponent<QKUISprite>();
        attr.UISoldierNum = GameObjectExtension.FindChild(attr.ui.transform, "soldier_num/txt").gameObject.GetComponent<UILabel>();
        attr.UIHP = GameObjectExtension.FindChild(attr.ui.transform, "hpmp_widget/hp_bg").gameObject.GetComponent<UIProgressBar>();
        attr.UIMP = GameObjectExtension.FindChild(attr.ui.transform, "hpmp_widget/mp_bg").gameObject.GetComponent<UIProgressBar>();

        

       
        attr.UIHead = GameObjectExtension.FindChild(attr.ui.transform, "bg/head_widget").gameObject;
        attr.UIBinsi = GameObjectExtension.FindChild(attr.ui.transform, "binsi").gameObject;

        attr.UISDSkill = GameObjectExtension.FindChild(attr.ui.transform, "skill_widget").gameObject;
        attr.UISDSkillBirth = GameObjectExtension.FindChild(attr.ui.transform, "skill_widgetBirth").gameObject;

        attr.UISDSkillYinchang = GameObjectExtension.FindChild(attr.ui.transform, "spellslider_bg").gameObject;
        attr.UISDSkillYinchangSlider = attr.UISDSkillYinchang.GetComponent<UISlider>();
        attr.UISDSkillYinchangTweener = attr.UISDSkillYinchang.GetComponent<UITweener>();
        attr.UIFailTweener = GameObjectExtension.FindChild(attr.ui.transform, "fail").GetComponent<UITweener>();

        var starLabel = GameObjectExtension.FindChild(attr.ui.transform, "star_bg/txt").GetComponent<UILabel>();
        starLabel.text = hxj.ToString();
        

        attr.UISDSkillYinchangSlider.alpha = 0;
        attr.UIType = GameObjectExtension.FindChild(attr.ui.transform, "type").GetComponent<UISprite>();

        var hr = (heroInfo as HeroDataInfo);
        if (hr == null) 
            attr.UIType.gameObject.SetActive(false);
        else
            attr.UIType.spriteName = "t" + hr.TypeIcon.ToString();


        attr.UISDSkillEndPos = attr.UISDSkill.transform.localPosition;
        attr.UISDSkillStartPos = attr.UISDSkillBirth.transform.localPosition;

        var skill_icon = GameObjectExtension.FindChild(attr.UISDSkill.transform, "skill_icon").gameObject.GetComponent<UISprite>();

        string icon="";
        foreach (var currSkill in heroInfo.SkillObjs)
        {
            if (currSkill == null || currSkill.SkillType != SkillType.Shoudong) continue;

            icon = currSkill.Icon;

            //设置手动技能名
            var sdNameLabel = GameObjectExtension.FindChild(attr.ui.transform, "spellslider_bg/txt").gameObject.GetComponent<UILabel>();
            sdNameLabel.text = currSkill.Name;

            break;
        }

        attr.UIMP.value = 0;
        GameObjectExtension.FindChild(attr.ui.transform, "mp_bg/mp_fx").gameObject.SetActive(false);//默认隐藏进度满特效

        skill_icon.spriteName = icon.ToString();//设置手动技能图标 "skillicon" +
        attr.UISDSkill.SetActive(false);

        //LuaHeroInfoLibs.SetHeroIcon(attr.UIIcon, heroInfo); //设置英雄头像       
        m_HeroAttrsByFID.Add(fid, attr);

        //相机默认锁定这个英雄
        if (fid < m_CameraFocusFID) { DP_Battlefield.Single.CameraFocusFID(true, fid); m_CameraFocusFID = fid; }
    }


    class HeroAttr
    {
        public GameObject ui;
        public GameObject UIDead;
        public QKUISprite UIIcon;
        public UILabel UISoldierNum;

        public UIProgressBar UIHP;
        public UIProgressBar UIMP;
        public GameObject UIHead;
        public Vector3 UISDSkillStartPos;
        public Vector3 UISDSkillEndPos;
        public GameObject UISDSkill;
        public GameObject UISDSkillBirth; 
        public GameObject UISDSkillYinchang; 
        public UISlider UISDSkillYinchangSlider;
        public UISprite UIType;
        public UITweener UISDSkillYinchangTweener;
        public UITweener UIFailTweener;
        public GameObject UIBinsi;

        public BuffIconManage BuffIconManage;
        public Tweener HPTweener = null;
        public Tweener MPTweener = null;
         public Tweener HeadScaleTweener = null;//头像缩放补间
        public Tweener SoldiersCountTweener = null;
        public Tweener SkillIconTweener = null;//手动技能补间
        public Tweener YinchangTweener = null;//吟唱tween

        public int DataID;//数据ID
        public int ActorID;//演员ID
        public int Fid; //阵位ID
        public int HeadID;//界面上的位置
        public void KillHeadScaleTweener() { if (HeadScaleTweener != null) { HeadScaleTweener.Kill(); HeadScaleTweener = null; } }
        public void KillMPTweener() { if (MPTweener != null) { MPTweener.Kill(); MPTweener = null; } }
        public void KillHPTweener() { if (HPTweener != null) { HPTweener.Kill(); HPTweener = null; } }
        public void KillYinchangTweener() { if (YinchangTweener != null) { YinchangTweener.Kill(); YinchangTweener = null; } }

        public void KillSoldiersCountTweener() { if (SoldiersCountTweener != null) { SoldiersCountTweener.Kill(); SoldiersCountTweener = null; } }

        public void KillSkillIconTweener() { if (SkillIconTweener != null) { SkillIconTweener.Kill(); SkillIconTweener = null; } }

    }
    Dictionary<int, HeroAttr> m_HeroAttrsByFID = new Dictionary<int, HeroAttr>();
    GameObject m_Attackroot;
    HeroAttr m_CurrHero = null;
    int m_CameraFocusFID = 999;
    int m_CurrYinchangHero = -1;
    int m_EmptyHeadID = 1;//当前空的头像位置

    //GameObject PhotoStudioCameraObj;
    YQ2PhotoStudio CMPhotoStudio;
    Camera CMPhotoStudioCamera;
}
 

class BuffIconManage
{
    public const int BuffIconCount = 5;
    public BuffIconManage(UIGrid grid,bool isLeftBar)
    {
        m_Grid = grid;
        m_IsLeftBar = isLeftBar;
    }

    public void AddFreeIcon(UISprite icon)
    {
        UIBuffIcons_Free.Add(icon);
    }

    public void BuffIconChange(int bid, string icon)
    {
        if(string.IsNullOrEmpty(icon))//删
        {
            bool isDie = false;
            foreach (var curr in UIBuffIcons_Active) { 
                if (curr.bid == bid)
                {
                    isDie = true;
                    curr.sp.gameObject.SetActive(false);//隐藏
                    UIBuffIcons_Active.Remove(curr);
                    UIBuffIcons_Free.Add(curr.sp);
                    break;
                }
            }

            if(!isDie)
            {
                foreach (var curr in UIBuffIcons_Hide)
                {
                    if (curr.bid == bid)
                    {
                        isDie = true;
                        UIBuffIcons_Hide.Remove(curr); 
                        break;
                    }
                }
            } 
        }else//加
        {
            var n = new ActiveBuffIcon() {  bid=bid, icon = icon};
            UIBuffIcons_Hide.Add(n);
        }

        //隐藏的buff图标 如果满足显示条件，则显示出来
        if (UIBuffIcons_Free.Count > 0 && UIBuffIcons_Hide.Count>0)
        {
            NeedRemove.Clear();
            foreach(var curr in UIBuffIcons_Hide)
            {
                if (IsInActive(curr.icon)) continue;//显示里有一样的图标

                curr.sp = UIBuffIcons_Free[0];
                curr.sp.spriteName = curr.icon;
                curr.sp.gameObject.SetActive(true);

                //设置显示位置
                var x = curr.sp.width * UIBuffIcons_Active.Count;
                curr.sp.transform.localPosition = new Vector3(x, m_IsLeftBar ? -curr.sp.height : curr.sp.height, 0);
                m_Grid.Reposition();

                UIBuffIcons_Free.RemoveAt(0);
                UIBuffIcons_Active.Add(curr);
                NeedRemove.Add(curr);

                if (UIBuffIcons_Free.Count < 1) break;//自由的图标已消耗干净
            }

            if(NeedRemove.Count>0)
            {
                foreach (var curr in NeedRemove) UIBuffIcons_Hide.Remove(curr);
            }
        }
    }

    bool IsInActive(string icon)
    {
        foreach (var curr in UIBuffIcons_Active) { if (curr.icon == icon)return true; }
        return false;
    }

    public void Reset()
    {
        foreach (var curr in UIBuffIcons_Active) { UIBuffIcons_Free.Add(curr.sp); curr.sp.gameObject.SetActive(false); }
        UIBuffIcons_Active.Clear();
        UIBuffIcons_Hide.Clear();
    }

    //活动的buff图标
    class ActiveBuffIcon
    {
        public UISprite sp;
        public int bid;
        public string icon;
    }

    List<ActiveBuffIcon> NeedRemove = new List<ActiveBuffIcon>();
    List<UISprite> UIBuffIcons_Free = new List<UISprite>();//自由的技能buff图标
    List<ActiveBuffIcon> UIBuffIcons_Active = new List<ActiveBuffIcon>();//活动的技能buff图标
    List<ActiveBuffIcon> UIBuffIcons_Hide = new List<ActiveBuffIcon>();//因为展现的buff图标过多或者图标重复，暂时没有显示出来的图标
    UIGrid m_Grid;
    bool m_IsLeftBar;

}