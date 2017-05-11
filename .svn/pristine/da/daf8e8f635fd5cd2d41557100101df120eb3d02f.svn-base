using UnityEngine;


/// <summary>
/// 显示单位包装对象
/// </summary>
public class DisplayOwner
{
    /// <summary>
    /// 显示对象Obj引用
    /// </summary>
    public GameObject GameObj { get; set; }

    /// <summary>
    /// 集群数据引用
    /// </summary>
    public ClusterData ClusterData { get; set; }

    /// <summary>
    /// 显示数据引用
    /// </summary>
    public MFAModelRender MFAModelRender { get; set; }

    /// <summary>
    /// 显示对象引用
    /// </summary>
    public RanderControl RanderControl { get; set; }

    /// <summary>
    /// 对象数据引用
    /// </summary>
    public VOBase MemberData { get; set; }



    public DisplayOwner(GameObject gameObj, ClusterData clusterData, MFAModelRender modelRender, RanderControl randerControl, VOBase memberData)
    {
        GameObj = gameObj;
        ClusterData = clusterData;
        MFAModelRender = modelRender;
        RanderControl = randerControl;
        MemberData = memberData;
    }


    /// <summary>
    /// 销毁对象
    /// </summary>
    public void Destroy()
    {
        GameObject.Destroy(GameObj);
        ClusterData = null;
        MFAModelRender = null;
        MemberData = null;
    }


    /// <summary>
    /// 清空数据
    /// </summary>
    public void CleanData()
    {
        ClusterData = null;
        MFAModelRender = null;
        MemberData = null;
    }
}
