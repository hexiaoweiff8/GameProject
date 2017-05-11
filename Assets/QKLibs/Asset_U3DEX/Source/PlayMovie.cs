using UnityEngine;
using System.Collections;
using System;
//视频播放组件
[AddComponentMenu("QK/PlayMovie")]
public class PlayMovie : MonoBehaviour {
    //public UnityEngine.MovieTexture _MoiveTexture = null;
    public bool IsLoop {
        get {
            return m_IsLoop;
        }
        set
        {
            m_IsLoop = value;
           // if (_MoiveTexture != null) _MoiveTexture.loop = m_IsLoop;
           
            /* Handheld
             1. 将视频资源拷贝到外置存储(如sd卡)，通过外置存储绝对路径调用

string path = Application.persistentDataPath + "xxx.mp4";
 

　　2. 在Build Apk的时候，将视频资源放在StreamingAssets子目录下，通过视频名字调用

string path = "xxx.mp4";
             */

            //Handheld.PlayFullScreenMovie()
            //iPhoneUtils.PlayMovieURL //PlayMovie("IHSG_smash.ogg", Color.black, iPhoneMovieControlMode.CancelOnTouch);
        }
    }

    /// <summary>
    /// 播放完成的会调事件
    /// </summary>
    [System.NonSerialized]
    IQKEvent m_evt_PlayFinishd = null;
    public IQKEvent evt_PlayFinishd
    {
        get { return m_evt_PlayFinishd;}
        set { if (m_evt_PlayFinishd != null) m_evt_PlayFinishd.Dispose();  m_evt_PlayFinishd = value; }
    }

    [System.NonSerialized]
    object m_UserParam = null;
    public object UserParam {
        get { return m_UserParam; }
        set {
            IDisposable dsp = m_UserParam as IDisposable;
            if (dsp != null) dsp.Dispose();
            m_UserParam = value;
        }
    }

    [SerializeField]
    [HideInInspector] 
    bool m_IsLoop = false;
	// Use this for initialization
	void Start () {
        IsLoop = m_IsLoop; 
    }

    void OnEnable() { CoroutineManage.Single.RegComponentUpdate(IUpdate); }
	
	// Update is called once per frame
	void IUpdate () {
        /*
        if(_MoiveTexture != null&&m_st== MovieST.Play&&!_MoiveTexture.isPlaying)
        {
            Stop();
            if(evt_PlayFinishd!=null)
            {
                evt_PlayFinishd.Call(UserParam);
            }
            Debug.Log("播放完成");
        }*/
    }

	public void Play()
	{
        /*
        m_st = MovieST.Play;
        if (_MoiveTexture != null)
		_MoiveTexture.Play(); */
	}

	public void Pause()
	{
        /*
        m_st = MovieST.Pause;
        if (_MoiveTexture != null)
		_MoiveTexture.Pause(); */
	}
 
	public void Stop()
	{
        /*
        m_st = MovieST.Stop;
        if (_MoiveTexture != null)
		_MoiveTexture.Stop(); */
	}

    void OnDestroy()
    {
        evt_PlayFinishd = null;
        UserParam = null;
        CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
    }

    enum MovieST
    {
        Play,
        Pause,
        Stop
    }
    //MovieST m_st = MovieST.Stop;
}
