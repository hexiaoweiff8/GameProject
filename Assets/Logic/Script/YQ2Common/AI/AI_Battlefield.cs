using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
 
public class AI_Battlefield //: MonoEX.Singleton<AI_Battlefield>
{
 

    int mDPID_Seed = 0;
    public int NewDPID { get { return mDPID_Seed++; } }


    public const float OneFrameTime = 0.2f;


    //已经开战的时间,从冲锋开始算
    public float FightLostTime {  get { return m_totalLostTime - m_FightStartTime; }  }


    //预备区加入一支军队

    bool m_QixiEntered = false;

    /// <summary>
    /// 生成本次战斗所需的动态资源包队列
    /// 如果是主场景则添加临时测试资源
    /// </summary>
    public List<string> GeneratePackList(Boolean IsFromMainScene = false)
    {
        
        HashSet<string> packList = new HashSet<string>();

        //战斗手动聚光灯依赖纹理
        packList.Add("ani_ll_003");
        packList.Add("light_ll_005");
        packList.Add("light_ll_018");

        //战斗特效材质
        packList.Add("tx_materials");

        packList.Add("spotlight");//聚光灯预置

        //分尸资源包
        packList.Add("fenshi");

        //脚下烟尘
        packList.Add("yanwu_zl_006");
        packList.Add("yanwu_tuowei");
        
        return packList.ToList();
    }



   // public YQ2QuadTree<AI_Object> QuadTreeMap = null;
    float m_totalLostTime = 0;//离战斗开始逝去的时间 

    FightParameter m_FightParameter;
    QKRandom m_Random;
    float m_FightStartTime;//记录战斗开始的时间

    
    bool WaitDie = false;
    //delayEndTime
}

