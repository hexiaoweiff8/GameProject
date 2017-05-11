using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Schema;
using UnityEngine;

/// <summary>
/// 集群行为
/// </summary>
public class ClusterData: PositionObject
{

    // ---------------------------设置属性-----------------------------
    /// <summary>
    /// 外部注入VO
    /// </summary>
    public void SetDataValue(VOBase data)
    {
        MemberData = data;
    }
    
    ///// <summary>
    ///// 与其他单位组队最大距离
    ///// 超过该距离则不与该单位组队
    ///// </summary>
    //public float MaxDistance {
    //    get { return maxDistance;}
    //    set { maxDistance = value < 0 ? 10 : value; }
    //}

    /// <summary>
    /// 旋转速度
    /// </summary>
    public float RotateSpeed {
        get { return rotateSpeed; }
        set { rotateSpeed = value < 0 ? 1 : value; }
    }

    /// <summary>
    /// 转向权重
    /// 值越大, 转向越快
    /// </summary>
    public float RotateWeight {
        get { return rotateWeight; }
        set { rotateWeight = value < 0 ? 1 : value; }
    }

    /// <summary>
    /// 目标位置
    /// </summary>
    public Vector3 TargetPos {
        get { return targetPos; }
        set {
            // TODO 切换当前状态
            targetPos = value;
        }
    }

    /// <summary>
    /// 组队ID
    /// </summary>
    public int GroupId {
        get { return groupId; }
        set {
            // 判断是否已有group, 如果有并且ID不同, 则删除原有group中的member
            if (value != groupId){
                if (group != null){
                    group.MemberList.Remove(this);
                }

                var newGroup = ClusterManager.GetGroupById(value);
                if (newGroup == null){
                    newGroup = new ClusterGroup(value);
                    ClusterManager.GroupList.Add(newGroup);
                    group = newGroup;
                }
                else if (group == null || group.GroupId != newGroup.GroupId){
                    group = newGroup;
                }
                
                // group列表中是否有改ID的group, 如果有则插入其中, 如果没有则创建
                groupId = value;
                if (!group.MemberList.Contains(this)){
                    group.MemberList.Add(this);
                }
            }
        }
    }

    /// <summary>
    /// 单位当前状态
    /// </summary>
    public SchoolItemState State = SchoolItemState.Unstart;

    /// <summary>
    /// 开始移动时调用
    /// </summary>
    public Action<GameObject> Moveing { get; set; }

    /// <summary>
    /// 拥挤等待时调用
    /// </summary>
    public Action<GameObject> Wait { get; set; }

    /// <summary>
    /// 移动到终点后调用
    /// 不是所有对象都会掉用该回调, 只有到达终点的会调用
    /// </summary>
    public Action<GameObject> Complete { get; set; }

    //-----------------------------只读属性----------------------------------

    /// <summary>
    /// 组队编号
    /// </summary>
    public ClusterGroup Group {
        get { return group; }
    }


    // -------------------------私有属性-------------------------


    /// <summary>
    /// 当前单位的目标点
    /// </summary>
    private Vector3 targetPos;

    /// <summary>
    /// 组编号
    /// </summary>
    private int groupId;

    /// <summary>
    /// 组对象
    /// </summary>
    private ClusterGroup group;

    ///// <summary>
    ///// 与其他单位间距
    ///// </summary>
    //private float distance = 1f;

    ///// <summary>
    ///// 与其他单位组队最大距离
    ///// 超过该距离则不与该单位组队
    ///// </summary>
    //private float maxDistance = 10;

    /// <summary>
    /// 移动速度
    /// </summary>
    //private float speed = 10;

    /// <summary>
    /// 旋转速度
    /// </summary>
    private float rotateSpeed = 1;

    /// <summary>
    /// 转向权重
    /// 值越大, 转向越快
    /// </summary>
    private float rotateWeight = 1;

    /// <summary>
    /// 是否可被阻挡
    /// 如果为true则遇到其他单位则将其挤开
    /// 如果为false则减速等待
    /// </summary>
    private bool couldObstruct = true;

    public void Destory() {
        // 销毁时从列表中消除当前队员
        Group.MemberList.Remove(this);
    }
}




/// <summary>
/// 集群编队
/// </summary>
public class ClusterGroup
{
    // --------------------------公有属性--------------------------------


    /// <summary>
    /// 路径宽度
    /// </summary>
    public float PathWeight {
        get { return pathWeight; }
        set { pathWeight = value; } }

    /// <summary>
    /// 目标位置
    /// 设置目标的同时 所有成员状态会重置为未开始
    /// </summary>
    public Vector3 Target {
        get {
            if (MemberList != null && MemberList.Count > 0) {
                return MemberList[0].TargetPos;
            }
            return Vector3.zero;
        }
        set {
            // 一旦变更, 虽有所属成员状态全部变成Unstart
            foreach (var member in MemberList) {
                member.State = SchoolItemState.Unstart;
                member.TargetPos = value;
            }
            //targetPos = value;
            startPos = GroupPos;
            CompleteMemberCount = 0;
            IsComplete = false;
        }
    }

    /// <summary>
    /// 队伍位置
    /// 这个位置代表队伍中心位置
    /// </summary>
    public Vector3 GroupPos { get; set; }

    /// <summary>
    /// 队伍起始位置
    /// </summary>
    public Vector3 StartPos { get { return startPos; } }

    /// <summary>
    /// 成员列表
    /// </summary>
    public List<ClusterData> MemberList = new List<ClusterData>();

    /// <summary>
    /// 组编号
    /// </summary>
    public int GroupId;

    /// <summary>
    /// 创建group时给予ID
    /// </summary>
    /// <param name="groupId"></param>
    public ClusterGroup(int groupId) {
        GroupId = groupId;
    }

    /// <summary>
    /// 达成Complete的百分比
    /// 比如集群10个单位, 此处填50, 则5个单位complete该group则complete
    /// </summary>
    public int ProportionOfComplete {
        get { return proportionOfComplete; }
        set {
            // 非法值
            if (value < 0 || value > 100) {
                proportionOfComplete = 20;
            }
            proportionOfComplete = value;
        }
    }

    /// <summary>
    /// 已到达队员数量
    /// </summary>
    public int CompleteMemberCount { get; set; }

    /// <summary>
    /// 组队到达
    /// </summary>
    public Action<ClusterGroup> Complete { get; set; }

    /// <summary>
    /// 队伍是否已到达
    /// </summary>
    public bool IsComplete { get; set; }


    // -----------------------------私有属性-----------------------------

    /// <summary>
    /// 存储阵容对应GroupId
    /// </summary>
    private static Dictionary<int, long> groupIdDic = new Dictionary<int, long>();

    /// <summary>
    /// 达成Complete的百分比
    /// 默认20
    /// </summary>
    private int proportionOfComplete = 10;

    /// <summary>
    /// 目标位置
    /// </summary>
    //private Vector3 targetPos;

    /// <summary>
    /// 路径起始点
    /// </summary>
    private Vector3 startPos;

    /// <summary>
    /// 路径宽度
    /// 默认宽度1
    /// </summary>
    private float pathWeight = 1.5f;

    /// <summary>
    /// 清除队伍信息
    /// </summary>
    public void CleanGroup() {
        // 清除所有从属单位
        foreach (var member in MemberList) {
            GameObject.Destroy(member.gameObject);
        }
        MemberList.Clear();
    }



    /// <summary>
    /// 生成对应阵营编队ID
    /// 生成的编队ID使用GetGroupId传入阵营编号获取
    /// </summary>
    /// <param name="compNum">阵营编号</param>
    public static void CreateGroupId(int compNum)
    {
        if (!groupIdDic.ContainsKey(compNum))
        {
            groupIdDic.Add(compNum, 0);
        }
        groupIdDic[compNum]++;
    }

    /// <summary>
    /// 根据阵营编号获取对应编队ID
    /// </summary>
    /// <param name="compNum">阵营ID</param>
    /// <returns>对应阵营的编队ID, 如果不存在则抛出Exception</returns>
    public static long GetGroupId(int compNum)
    {
        if (!groupIdDic.ContainsKey(compNum))
        {
            throw new Exception("不存在阵营编号:" + compNum);
        }
        return groupIdDic[compNum];
    }

}

/// <summary>
/// 集群单位状态
/// </summary>
public enum SchoolItemState
{
    // 未开始状态
    Unstart,
    // 移动中状态
    Moving,
    // 等待中状态
    Waiting,
    // 结束状态
    Complete,
}