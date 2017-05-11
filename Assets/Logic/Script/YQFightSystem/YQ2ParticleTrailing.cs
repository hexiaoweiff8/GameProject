using UnityEngine;
using System.Collections;

public class YQ2ParticleTrailing : MonoBehaviour
{
    public GameObject Particle = null;//拖尾的粒子

    const float disableTime = 5;//多少时间后不移动则禁用拖尾
    const float hideTime = 0f;//多少时间后不移动则隐藏拖尾
	// Use this for initialization
	void Start () {
        Particle.SetActive(false);//禁用
        m_LastPos = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
        var currPos = transform.position;
	    if(m_LastPos==currPos) //没有产生移动
        {
            var t = Time.deltaTime;

            if(m_st!= ST.disable)
            {
                m_LostDisableTime += t;
                if (m_LostDisableTime >= disableTime)
                {
                    Particle.SetActive(false);//禁用
                    m_st = ST.disable;
                }
            }

            if (m_st == ST.show)
            {
                m_LostHideTime += t;
                if(m_LostHideTime>=hideTime)
                {
                    Particle.transform.localPosition = new Vector3(9999999, 0, 0);
                    m_st = ST.hide;
                }
            }
        }else//产生了移动
        {
            m_LastPos = currPos;
            m_LostDisableTime = m_LostHideTime = 0;
            if (m_st != ST.show)
            {
                Particle.SetActive(true);
                Particle.transform.localPosition = Vector3.zero;
                m_st = ST.show;
            }
        }
	}

    Vector3 m_LastPos;
    float m_LostDisableTime = 0;
    float m_LostHideTime = 0;
    ST m_st = ST.disable;

    enum ST
    {
        disable,
        hide,
        show
    }
}
