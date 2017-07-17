using System;
using JetBrains.Annotations;
using UnityEngine;


/// <summary>
/// 显示单位包装对象
/// </summary>
[Serializable]
public class DisplayOwner
{
    /// <summary>
    /// 显示对象Obj引用
    /// </summary>
    public GameObject GameObj { get; set; }

    /// <summary>
    /// 集群数据引用
    /// </summary>
    public PositionObject ClusterData { get; set; }

    /// <summary>
    /// 显示数据引用
    /// </summary>
    public MFAModelRender MFAModelRender { get; set; }

    /// <summary>
    /// 显示对象引用
    /// </summary>
    public RanderControl RanderControl { get; set; }

    ///// <summary>
    ///// 对象数据引用
    ///// </summary>
    //public VOBase MemberData { get; set; }


    public DisplayOwner([NotNull] GameObject gameObj, [NotNull] PositionObject clusterData)
    {
        GameObj = gameObj;
        ClusterData = clusterData;
    }

    public DisplayOwner([NotNull] GameObject gameObj, [NotNull] PositionObject clusterData, MFAModelRender mfa)
    {
        GameObj = gameObj;
        ClusterData = clusterData;
        MFAModelRender = mfa;
    }

    public DisplayOwner([NotNull]GameObject gameObj, [NotNull]PositionObject clusterData, MFAModelRender modelRender, [NotNull]RanderControl randerControl)
    {
        GameObj = gameObj;
        ClusterData = clusterData;
        MFAModelRender = modelRender;
        RanderControl = randerControl;
        //MemberData = memberData;
    }


    /// <summary>
    /// 销毁对象
    /// </summary>
    public void Destroy()
    {
        GameObject.Destroy(GameObj);
        CleanData();
    }


    /// <summary>
    /// 清空数据
    /// </summary>
    public void CleanData()
    {
        ClusterData = null;
        MFAModelRender = null;
        //MemberData = null;
    }
}
