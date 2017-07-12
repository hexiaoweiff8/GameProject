using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class FightDataSyncer : ILoopItem
{
    /// <summary>
    /// 单例
    /// </summary>
    public static FightDataSyncer Single
    {
        get
        {
            if (single == null)
            {
                single = new FightDataSyncer();
            }
            return single;
        }
    }

    /// <summary>
    /// 单例对象
    /// </summary>
    private static FightDataSyncer single = null;


    /// <summary>
    /// 添加数据
    /// 状态, FSM数据, 单位属性, 单位位置, 单位方向, 目标点列表(路径), 目标(技能/攻击目标)
    /// 障碍物
    /// 每个单位的当前数据(列表)(每个单位的,当前位置, 当前目标, 当前方向, 动作?)
    /// 攻击行为(带目标, 起点终点, 如果有)
    /// 技能行为(带目标, 起点终点, 如果有)
    /// 状态切换
    /// 状态机FSM数据
    /// </summary>
    public void AddData()
    {
        
    }


    public void Do()
    {
        // TODO 发送数据
        // 如果收到服务器的数据
        // 则用该帧作为编号发到服务器
        // 卡顿时所有单位停止移动
        // 收到数据同步
    }

    public bool IsEnd()
    {
        // TODO 判断是否战斗结束
        return false;
    }

    public void OnDestroy()
    {
        // TODO 销毁数据
    }
}

/// <summary>
/// 战斗同步数据
/// </summary>
public class FightSyncData
{
    /// 状态, FSM数据, 单位属性, 单位位置, 单位方向, 目标点列表(路径), 目标(技能/攻击目标)
    public SoldierFSMSystem FsmData { get; set; }


    public AllData AllData { get; set; }


    public ClusterData ClusterData { get; set; }

}