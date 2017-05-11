using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;



/// <summary>
/// 音效 特效 震动 播放
/// </summary>
public class YQ2AudioFx : MonoBehaviour
{
    public int AudioFxID = 0;//效果ID
    public float LiveTime = 0;//用新的生存时间替代配置的生存时间，大于0生效
    public float DirX = 0, DirZ = 0; //朝向
    public ShakeManage shakeManage;//震动管理器
    public YQ2BatchRender batchRender;//批次渲染

    AudioFxInfo audioFxObj = null;
    private float m_Volume;

    void Start()
    {
        //QKGameSetting.OnSoundVolumeChg += OnSoundVolumeChg;

        if (audioFxObj==null) ReStart();
    }


    /// <summary>
    /// 根据参数重新启动效果
    /// </summary>
    public void ReStart()
    {
        //Volume = QKGameSetting.Volume;

        RemoveObjList.Clear();
        ActiveObjList.Clear();
        PreObjList.Clear();

        //销毁所有子物体 
        if (transform.childCount > 0)
        {
            List<GameObject> tList = new List<GameObject>();
            for(int i=0;i<transform.childCount;i++)
            {
                var gobj = transform.GetChild(i);
                tList.Add(gobj.gameObject);
            }

            foreach(var o in tList) GameObject.Destroy(o);
        }

        audioFxObj = SData_AudioFx.Single.Get(AudioFxID);
        if (audioFxObj != null)
        {
            InitTexiao();
            InitAudio();
            InitShake();

            //根据情况判定是否需要启动协程来监视对象生命期
            if (ActiveObjList.Count > 0||PreObjList.Count>0)
            {
                StartCoroutine(coUpdate());
            }
        }
    }

    public static YQ2AudioFx Go(GameObject obj, int AudioFxID)
    {
        YQ2AudioFx fx = GameObjectExtension.AutoInstance<YQ2AudioFx>(obj);
        fx.AudioFxID = AudioFxID;
        fx.DirX = 1;
        fx.DirZ = 0;
        fx.shakeManage = GameObject.FindObjectOfType<ShakeManage>();
        return fx;
    }

    public static List<string> GetPacks(int AudioFxID)
    {
        var re = new List<string>();
        var audioFxObj = SData_AudioFx.Single.Get(AudioFxID);
        if (audioFxObj == null) return re;


        var txs = audioFxObj.Texiaos;
        int len = txs.Length;
        for (int i = 0; i < len; i++)
        {
            var txInfo = txs[i];
            if (txInfo.ZiyuanType == ZiyuanTypeEnum.Lizi)
            {
                var len2 = txInfo.TexiaoName.Length;
                for (int i2 = 0; i2 < len2;i2++ )
                    re.Add(txInfo.TexiaoName[i2]);
            }

        }
        return re;
    }

    IEnumerator coUpdate()
    {
        while (ActiveObjList.Count > 0 || PreObjList.Count > 0)
        {
            float deltaTime = Time.deltaTime;
            if (ActiveObjList.Count > 0)
            {
                foreach (var curr in ActiveObjList)
                {
                    curr.live -= deltaTime;
                    if (curr.obj.NeedUpdate) curr.obj.Update(deltaTime);
                    if (curr.live <= 0) RemoveObjList.Add(curr);
                }

                if (RemoveObjList.Count > 0)
                {
                    foreach (var r in RemoveObjList)
                    {
                        r.obj.Destroy();
                        ActiveObjList.Remove(r);
                    }
                    RemoveObjList.Clear();
                }

            }

            if (PreObjList.Count > 0)
            {
                foreach (var curr in PreObjList)
                {
                    curr.startTime -= deltaTime;
                    if (curr.startTime <= 0) RemoveObjList.Add(curr);
                }

                if (RemoveObjList.Count > 0)
                {
                    foreach (var r in RemoveObjList)
                    {
                        PreObjList.Remove(r);
                        r.obj.SetActive(true);//激活游戏物体
                        if (!r.Deathless)
                            ActiveObjList.Add(r);//如果不是不死的游戏物体则加入活动队列 
                        else if (r.obj.NeedUpdate)//需要每帧刷新
                        {
                            r.live = 9999999;//对于一个不死的物体用超级长的时间来实现
                            ActiveObjList.Add(r);
                        }
                    }
                    RemoveObjList.Clear();
                }

            }

            yield return null;
        }
    }

    void InitShake()
    {
        var vibrations = audioFxObj.Vibrations;
        int len = vibrations.Length;
        for (int i = 0; i < len; i++)
        {
            var vibratioInfo = vibrations[i];
            float lvTime = LiveTime > 0 ? LiveTime : vibratioInfo.LiveTime;

            //创建实例   
            AddObj(
                 new FXObj_Shake(shakeManage, vibratioInfo), vibratioInfo.StartTime, lvTime,
                 vibratioInfo.AnimMode == VibrationAnimMode.Loop//永久生存
                );
        }
    }

    void InitAudio()
    {
        var audios = audioFxObj.Audios;
        int len = audios.Length;
        for (int i = 0; i < len; i++)
        {
            var audioInfo = audios[i];
            float lvTime = LiveTime > 0 ? LiveTime : audioInfo.LiveTime;

            var packName = audioInfo._2Dor3D == 2 ? "uisound" : audioInfo.Sound;
           
            //创建实例 
            GameObject gameObj;

            var pack = PacketManage.Single.GetPacket(packName);

            if (pack == null)
            {
                Debug.LogWarning(string.Format("不存在的音效包 [{0}]", packName));
                continue;
            }


            var aclip = pack.Load(audioInfo.Sound) as AudioClip;
            if (aclip==null)
            {
                Debug.LogWarning(string.Format("不存在的音效 {0}->{1}", packName, audioInfo.Sound));
                continue;
            }

            gameObj = new GameObject();
            gameObj.transform.parent = this.transform;
            gameObj.transform.localPosition = Vector3.zero;
            gameObj.transform.localRotation = Quaternion.identity;

            //挂音效组件
            var cmAudio = gameObj.AddComponent<AudioSource>();
            cmAudio.clip = aclip;
            cmAudio.loop = audioInfo.AnimMode == AudioAnimMode.Loop || audioInfo.AnimMode == AudioAnimMode.LiveLoop;
            cmAudio.spatialBlend = audioInfo._2Dor3D == 2 ? 0 : 1;
            cmAudio.minDistance = 50;//最小传播距离
            cmAudio.maxDistance = 10000;//最大传播距离
            cmAudio.volume = Volume;
            cmAudio.dopplerLevel = 0;

            AddObj(
                 new FXObj_GameObject(gameObj), audioInfo.SoundStart, lvTime,
                 audioInfo.AnimMode == AudioAnimMode.Loop//永久生存
                );
        }
    }

    void InitTexiao()
    {
        var txs = audioFxObj.Texiaos;
        int len = txs.Length;
        for (int i = 0; i < len; i++)
        {
            var txInfo = txs[i];
            float lvTime = LiveTime > 0 ? LiveTime : txInfo.LiveTime;

            //创建实例
            GameObject gameObj = null;
            switch (txInfo.ZiyuanType)
            {
                case ZiyuanTypeEnum.Jianyu://箭雨
                    {
                        //string gjres = string.Format("GongJian{0:D2}", txInfo.JianID);
                        var pack = PacketManage.Single.GetPacket("gongjian");
                 

                        GameObject preObj = pack.Load(txInfo.TexiaoName[0]) as GameObject;

                        gameObj = GameObject.Instantiate(preObj);

                        /*
                        //设置朝向
                        var quad = gameObj.GetComponent<YQ2BathQuad>();
                        if (DirX < 0)//朝左
                        {
                            float swaptmp = quad.lt_u; quad.lt_u = quad.rb_u; quad.rb_u = swaptmp;
                        }
                        quad.OwnerBatch = batchRender;

                        gameObj.transform.parent = this.transform;
                        gameObj.transform.localPosition = new Vector3(txInfo.OffSetX, txInfo.OffSetY, txInfo.OffSetZ);
                        gameObj.transform.localScale = Vector3.one;



                        AddObj(
                             new FXObj_GameObject(gameObj), txInfo.StartTime, lvTime,
                             txInfo.ZiyuanType == ZiyuanTypeEnum.Jianyu ||//箭雨
                             txInfo.AnimMode == TexiaoAnimMode.Loop//永久生存
                            );*/
                        //计算旋转值
                        //var euler = gameObj.transform.localEulerAngles;
                        //euler.y -= (180 / Mathf.PI * AI_Math.Dir2Radian(DirX, DirZ));
                       // Debug.Log(string.Format("jianyu dirx:{0} dirz:{1}", DirX, DirZ));
                        //gameObj.transform.localEulerAngles = euler;
                        gameObj.transform.parent = this.transform;
                        gameObj.transform.localRotation = Quaternion.identity;
                        gameObj.transform.localPosition = new Vector3(txInfo.OffSetX, txInfo.OffSetY, txInfo.OffSetZ);
                        gameObj.transform.localScale = preObj.transform.localScale;



                        AddObj(
                             new FXObj_GameObject(gameObj), txInfo.StartTime, lvTime,
                             txInfo.ZiyuanType == ZiyuanTypeEnum.Jianyu ||//箭雨
                             txInfo.AnimMode == TexiaoAnimMode.Loop//永久生存
                            );
                    }
                    break;
                default://粒子
                    {
                        for (int j = 0; j < txInfo.TexiaoName.Length; j++)
                        {
                            try
                            {
                                var txName = txInfo.TexiaoName[j];
                                Debug.Log("AudioFx InitTexiao " + txName);

                                var pack = PacketManage.Single.GetPacket(txName);
                                if (pack != null)
                                {
                                    GameObject preObj = pack.Load(txName) as GameObject;
                                    gameObj = GameObject.Instantiate(preObj);

                                    if (txInfo.AnimMode == TexiaoAnimMode.Scale)//自动缩放，这类粒子资源必须是1秒的 
                                        gameObj.SetParticleSystemPlaySpeed(1.0f / lvTime);

                                    //计算旋转值
                                    //var euler = gameObj.transform.localEulerAngles;
                                    //euler.y -= (180 / Mathf.PI * AI_Math.Dir2Radian(DirX, DirZ));
                                    //gameObj.transform.localEulerAngles = euler;

                                    gameObj.transform.parent = this.transform;
                                    gameObj.transform.localRotation = Quaternion.identity;
                                    gameObj.transform.localPosition = new Vector3(txInfo.OffSetX, txInfo.OffSetY, txInfo.OffSetZ);
                                    gameObj.transform.localScale = Vector3.one;



                                    AddObj(
                                         new FXObj_GameObject(gameObj), txInfo.StartTime, lvTime,
                                         txInfo.ZiyuanType == ZiyuanTypeEnum.Jianyu ||//箭雨
                                         txInfo.AnimMode == TexiaoAnimMode.Loop//永久生存
                                        );
                                }
                                else
                                {
                                    Debug.LogWarning("装载粒子失败,未找到资源包 " + txInfo.TexiaoName);
                                }
                            }
                            catch (Exception)
                            {
                                Debug.LogWarning("装载粒子失败 " + txInfo.TexiaoName[j]);
                            }
                        }
                    }
                    break;
            }


          
        }
    }

    void AddObj(IFXObj obj, float startTime, float live, bool deathless)
    {
        if (startTime == 0 && deathless) return;

        var aobj = new ActiveObj() { startTime = startTime, live = live, obj = obj, Deathless = deathless };
        if (startTime > 0)
        {
            obj.SetActive(false);
            PreObjList.Add(aobj);
        }
        else
            ActiveObjList.Add(aobj);
    }
    /// <summary>
    /// 音量设置和获取
    /// </summary>
    public float Volume
    {
        get { return m_Volume; }
        set
        {
            m_Volume = value;
            ////这里应该处理下正在播放的音效
            for(int i = 0; i < ActiveObjList.Count;++i)
            {
                if(ActiveObjList[i].obj != null )
                {
                    ActiveObjList[i].obj.SetVolume(m_Volume);
                }
            }
            for(int i = 0; i < PreObjList.Count;++i)
            {
                if (PreObjList[i].obj != null)
                {
                    PreObjList[i].obj.SetVolume(m_Volume);
                }
            }
        }
    }
    
    void  OnSoundVolumeChg(float volume)
    {
        Volume = volume;
    }
    void OnDestroy()
    {
        //QKGameSetting.OnSoundVolumeChg -= OnSoundVolumeChg;
    }
    class ActiveObj
    {
        public bool Deathless;//是否是不死的
        public IFXObj obj;//对象
        public float live;//生命
        public float startTime;
    }

    List<ActiveObj> RemoveObjList = new List<ActiveObj>();
    List<ActiveObj> ActiveObjList = new List<ActiveObj>();//需要记时销毁的活动对象
    List<ActiveObj> PreObjList = new List<ActiveObj>();//准备激活的对象
    /*
      var res = act.Res;
string gjres = string.Format("GongJian{0:D2}", res.GongJianID);
        
//创建游戏物体
var pack = PacketManage.Single.GetPacket("gongjian");
GameObject gameObj = pack.Load(gjres) as GameObject;

dspActor.gameObject = GameObject.Instantiate(gameObj);

//应用初始位置
dspActor.gameObject.transform.localPosition = new Vector3(res.x, res.y, res.z);

//设置朝向
var quad = dspActor.gameObject.GetComponent<YQ2BathQuad>();
if (!res.IsDirRight)
{
    float swaptmp = quad.lt_u; quad.lt_u = quad.rb_u; quad.rb_u = swaptmp;
}
quad.OwnerBatch = gongJianBatchRender;
//dspActor.gameObject.transform.rotation = Dir2Rotation.Radian2ActRot(res.dirx, res.dirz);

//创建动画控制器
dspActor.desplayController = new DesplayController_Effect(dspActor.gameObject);
     */
}




//抽象效果物体
interface IFXObj
{
    void SetActive(bool isActive);
    void Destroy();

    void Update(float lostTime);
    void SetVolume(float soundVolume);

    bool NeedUpdate { get; }
}

//游戏物体类型的效果
class FXObj_GameObject : IFXObj
{
    public FXObj_GameObject(GameObject obj)
    {
        m_obj = obj;
    }

    public void SetActive(bool isActive)
    {
        m_obj.SetActive(isActive);
    }

    public void Destroy()
    {
        GameObject.Destroy(m_obj);
    }

    public void SetVolume(float soundVolume)
    {
        if(m_obj != null)
        {
            AudioSource  asObj = m_obj.GetComponent<AudioSource>();
            if(asObj != null)
            {
                asObj.volume = soundVolume;
            }

        }
    }
    public void Update(float lostTime) { }

    public bool NeedUpdate { get { return false; } }

    GameObject m_obj;
}



//震动类型的效果
class FXObj_Shake : IFXObj
{
    public FXObj_Shake(ShakeManage shakeManage, VibrationInfo shakeInfo)
    {
        m_shakeManage = shakeManage;
        m_shakeInfo = shakeInfo;
        //m_liveTime = liveTime;
    }

    public void SetActive(bool isActive)
    {
        if (m_isActive == isActive) return;
        m_isActive = isActive;

        Destroy();

        if (m_isActive)
        {
            m_Tweener = m_shakeManage.Shake(m_shakeInfo.Vibration, m_shakeInfo.LiveTime);
        }
    }

    public void Destroy()
    {
        if (m_Tweener != null && m_Tweener.IsActive())
            m_Tweener.Kill();
    }


    public void Update(float lostTime)
    {
        lostTime += lostTime;
        if (
            (m_shakeInfo.AnimMode == VibrationAnimMode.Loop || m_shakeInfo.AnimMode == VibrationAnimMode.LiveLoop) &&
            lostTime > m_shakeInfo.LiveTime
            )
        {
            //对于循环的震动，重新启动之
            lostTime -= m_shakeInfo.LiveTime;
            Destroy();
            m_Tweener = m_shakeManage.Shake(m_shakeInfo.Vibration, m_shakeInfo.LiveTime);
        }
    }
    public void SetVolume(float soundVolume)
    {
        
    }
    public bool NeedUpdate { get { return true; } }

    ShakeManage m_shakeManage;
    VibrationInfo m_shakeInfo;
    //float m_liveTime;
    float lostTime = 0;
    bool m_isActive = false;
    Tweener m_Tweener = null;
}