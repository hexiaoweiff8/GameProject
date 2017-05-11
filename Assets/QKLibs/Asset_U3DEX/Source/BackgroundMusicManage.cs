using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.Collections; 
/// <summary>
/// 背景音乐管理器
/// </summary>
public class BackgroundMusicManage : MonoEX.SingletonAuto<BackgroundMusicManage>
{ 
     
    float m_Volume = 1;//音量

     

    /// <summary>
    /// 音量设置和获取
    /// </summary>
    public float Volume {
        get { return m_Volume; }
        set {
            m_Volume = value;
            if (!coDoing)//任务协程处于休眠状态
            {
                if (m_CurrBackgroundMusic != null)
                    m_CurrBackgroundMusic.volume = m_Volume;//立即设置背景音量
            }
        }
    }
    

    //播放背景音乐
    public void Play(string packname, string clipname, float fadeOutTime)
    {
        missionInfo newMission = new missionInfo();
        newMission.isPlay = true;
        newMission.packname = packname;
        newMission.clipname = clipname;
        newMission.fadeOutTime = fadeOutTime;
        AddMission(newMission);
         
    }

    //终止播放背景音
    public void Stop(float fadeOutTime)
    {
        missionInfo newMission = new missionInfo();
        newMission.isPlay = false;
        newMission.fadeOutTime = fadeOutTime;
        AddMission(newMission);
    }


    //背景音淡入协程
    IEnumerator coFadeInBackgroundMusic(float fadeInTime)
    {
        AudioSource audio = m_CurrBackgroundMusic;
        float lostTime = 0;
        float volume = audio.volume;
        
        if (fadeInTime > 0)
        {
            while (audio.volume < m_Volume)
            {
                audio.volume = Mathf.Lerp(volume, m_Volume, Math.Min( lostTime / fadeInTime,1) );
                yield return null;
                lostTime += Time.deltaTime;
                if (audio != m_CurrBackgroundMusic)//当前播放的音乐已经改变
                    break;
            }
        }  
        
        audio.volume = m_Volume;
    }


    //背景音淡出协程
    IEnumerator coFadeOutBackgroundMusic(string packName,AudioSource audio, float fadeOutTime)
    {
        float lostTime = 0;
        float volume = audio.volume;

        if (fadeOutTime>0)
        {
            while (audio.volume > 0.0001)
            {
                audio.volume = Mathf.Lerp(volume, 0, lostTime / fadeOutTime);
                yield return null;
                lostTime += Time.deltaTime;
            }
        }

        GameObject.DestroyObject(audio);

        //资源引用处理
        ResourceRefManage.Single.SubRef(packName);
    }

    void AddMission(missionInfo info)
    {
        m_Missions.Add(info);
        if (coDoing == false) 
            CoroutineManage.Single.StartCoroutine(coMission());
    }

    IEnumerator coMission()
    { 
        coDoing = true;
        while (m_Missions.Count > 0)
        { 
            missionInfo msInfo = m_Missions[0];
            m_Missions.RemoveAt(0);
            if (msInfo.isPlay)
            {
                if (m_CurrPackname == msInfo.packname && m_CurrClipname == msInfo.clipname)
                    continue;//播放的和当前是同一首
            } 
            //当前背景音淡出
            if (m_CurrBackgroundMusic != null)
            {
                CoroutineManage.Single.StartCoroutine(coFadeOutBackgroundMusic(m_CurrPackname, m_CurrBackgroundMusic, msInfo.fadeOutTime));
                m_CurrBackgroundMusic = null;
                m_CurrPackname = "";
                m_CurrClipname = "";
            } 
            //播放新的背景音
            if (msInfo.isPlay)
            {
               IEnumerator it = _coPlay(msInfo.packname, msInfo.clipname, msInfo.fadeOutTime);
               while (it.MoveNext()) yield return null;
            } 
        }
        coDoing = false;
    }

    IEnumerator _coPlay(string packname, string clipname, float fadeOutTime)
    {
        //装入资源包
        List<string> pkList = new List<string>();
        pkList.Add(packname);
        PacketLoader pkLoader = new PacketLoader();
        pkLoader.Start(PackType.Res, pkList,null); 
        IEnumerator pkIt = pkLoader.Wait();
        bool needWait = true;
        while (needWait)
        {
            try
            {
                needWait = pkIt.MoveNext();
            }
            catch (Exception)
            {
                //装载资源遇到问题
                Debug.Log(string.Format("BackgroundMusic 装载包遇到错误 包:{0}", packname));
                yield break;
            }

            yield return null;
        } 
        //将包加入资源引用管理
        ResourceRefManage.Single.AddRef(packname);

        PacketRouting packetRouting = PacketManage.Single.GetPacket(packname);
        if (packetRouting == null)
        {
            Debug.LogError(string.Format("BackgroundMusicManage.Play 不存在的包 packname:{0} clipname:{1}", packname, clipname));
            yield break;//包不存在
        } 
        AudioClip clip = packetRouting.Load(clipname) as AudioClip;
        if (clip == null)
        {
            Debug.LogError(string.Format("BackgroundMusicManage.Play 不存在的音频剪辑 packname:{0} clipname:{1}", packname, clipname));
            yield break;//音频剪辑无效
        } 
        if (m_BackgroundMusicObj == null)
        {
            m_BackgroundMusicObj = new GameObject("BackgroundMusic");
            GameObject.DontDestroyOnLoad(m_BackgroundMusicObj);
        } 
        //创建一个新的AudioSource来播放
        m_CurrPackname = packname;
        m_CurrClipname = clipname;
        m_CurrBackgroundMusic = m_BackgroundMusicObj.AddComponent<AudioSource>();
        m_CurrBackgroundMusic.clip = clip;
        m_CurrBackgroundMusic.loop = true;
        m_CurrBackgroundMusic.volume = 0;
        m_CurrBackgroundMusic.Play();
        CoroutineManage.Single.StartCoroutine(coFadeInBackgroundMusic(fadeOutTime));//淡入背景音
    }

    struct missionInfo
    {
        public bool isPlay;
        public string packname;
        public string clipname;
        public float fadeOutTime;
    }
    List<missionInfo> m_Missions = new List<missionInfo>();
    bool coDoing = false; 
     
    string m_CurrPackname = "";
    string m_CurrClipname = ""; 
    AudioSource m_CurrBackgroundMusic = null;//当前正在播放的背景音
    GameObject m_BackgroundMusicObj = null;
    public void SetVolume(float soundVolume )
    {
        Volume = soundVolume;
    }
} 
 
