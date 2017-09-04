using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/// <summary>
/// 战斗管理器
/// </summary>
public class FightManager
{
    /// <summary>
    /// 单例
    /// </summary>
    public static FightManager Single
    {
        get
        {
            if (single == null)
            {
                single = new FightManager();
            }

            return single;
        }
    }

    /// <summary>
    /// 单例对象
    /// </summary>
    private static FightManager single = null;

    /// <summary>
    /// 地图宽度
    /// </summary>
    public int MapWidth = 50;

    /// <summary>
    /// 地图高度
    /// </summary>
    public int MapHeight = 50;

    /// <summary>
    /// 单位宽度
    /// </summary>
    public static int UnitWidth = 1;

    /// <summary>
    /// 地图数据
    /// </summary>
    private int[][] mapInfoData;


    /// <summary>
    /// 受伤回调
    /// 参数: 被击单位Obj, 伤害值, 伤害类型
    /// </summary>
    private Action<HealthChangePacker> healthChangeAction = null;

    /// <summary>
    /// 单位死亡事件
    /// </summary>
    private Action<GameObject, int, MemberType> memberDeadAction = null;

    /// <summary>
    /// 游戏结束回调
    /// 参数: 胜利阵营
    /// </summary>
    private Action<int> endGameAction = null;

    /// <summary>
    /// 单位位置-阵营字典
    /// </summary>
    private Dictionary<int, Dictionary<MemberType, Vector3>> memberPosDic = new Dictionary<int, Dictionary<MemberType, Vector3>>(); 




    /// <summary>
    /// 开始战斗
    /// 场景必须切换完毕
    /// </summary>
    /// <param name="mapId">地图Id</param>
    /// <param name="mapDataPacker">战斗数据包装类</param>
    /// <param name="isOnline">是否在线游戏</param>
    public void StartFight(int mapId, MapManager.MapDataParamsPacker mapDataPacker, bool isOnline)
    {
        // 加载战斗数据
        // 加载障碍曾
        var mapInfoData = MapManager.Instance().GetMapInfoById(mapDataPacker.MapId, 1);
        // 加载建筑层
        var mapInfoBuildingData = MapManager.Instance().GetMapInfoById(mapDataPacker.MapId, 2);

        Debug.Log("加载完毕");

        if (AstarFight.Instance != null)
        {
            // 是否在线战斗
            if (isOnline)
            {
                // 设置线上战斗标识
                GlobalData.FightData.IsOnline = true;
                // 启动战斗数据同步
                FightDataSyncer.Single.Start();

                // 设置消息回调
                FightDataSyncer.Single.AddMsgDispatch(
                    MsgId.MsgAskBattleResponse,
                    (headData) =>
                    {
                        // 如果收到战斗请求回复
                        // 加载地图加载建筑
                        AstarFight.Instance.InitMap(mapInfoData, mapInfoBuildingData);
                        // 请求战斗开始
                        FightDataSyncer.Single.SendBattleStartMsg(null);
                    }, true);
                // 请求战斗
                FightDataSyncer.Single.SendAskBattleMsg(null);
                // 如果收到请求开始回复
                FightDataSyncer.Single.AddMsgDispatch(
                   MsgId.MsgBattleStartResponse,
                   (headData) =>
                   {
                       // 如果收到战斗请求回复

                       // TODO 开始战斗可以操作

                       Debug.Log("战斗开始");
                   }, true);
            }
            else
            {

                GlobalData.FightData.IsOnline = false;
                FightDataSyncer.Single.Clear();
                // 如果不是在线战斗
                // 直接加载战斗
                AstarFight.Instance.InitMap(mapInfoData, mapInfoBuildingData);
            }
        }
        else
        {
            Debug.LogError("AstarFight脚本未加载");
        }
    }

    /// <summary>
    /// 解析地图
    /// </summary>
    public void AnalysisMap()
    {
        AstarFight.Instance.AnalysisMap();
    }

    /// <summary>
    /// 结束战斗
    /// </summary>
    public void EndFight()
    {
        // 结束流程
        // 清理数据
        FightDataStatistical.Single.Clear();
        FightDataSyncer.Single.Clear();
        PoolLoader.Instance().Clear();
        DisplayerManager.Single.Clear();
        DataManager.Single.Clear();
        ClusterManager.Single.ClearAll();
    }

    // 战斗关卡

    // 战斗地图加载

    /// <summary>
    /// 加载地图数据
    /// </summary>
    public void InitMap()
    {
        // 加载数据
        if (!GlobalData.FightData.IsSetData)
        {
            Debug.LogError("战斗数据未设置.");
            return;
        }
        // 加载障碍层
        var mapInfoData = MapManager.Instance().GetMapInfoById(GlobalData.FightData.MapId, 1);
        // 加载建筑层
        var mapInfoBuildingData = MapManager.Instance().GetMapInfoById(GlobalData.FightData.MapId, 2);

        InitMap(mapInfoData, mapInfoBuildingData);
    }

    // 地图数据请求
    // 数据回来之后调用AstarFight内的初始化并开始战斗
    // 如果是PVE则直接开始战斗


    /// <summary>
    /// 初始化地图
    /// </summary>
    public void InitMap(int[][] obMapInfo, int[][] buildingMapInfo)
    {
        Clear();
        // 清理数据
        // 加载障碍曾
        mapInfoData = obMapInfo;
        // 加载建筑层
        var mapInfoBuildingData = buildingMapInfo;
        
        // 初始化地图狂傲
        MapWidth = mapInfoData[0].Length;
        MapHeight = mapInfoData.Length;
        // 初始化地图单位宽度
        UnitWidth = (int)SData_Constant.Single.GetDataOfID(Utils.UnitWidthId).Value;
        LoadMap.Single.Init(mapInfoData, UnitWidth);
        // 初始化集群管理
        var loadMapPos = LoadMap.Single.GetCenter();
        ClusterManager.Single.Init(loadMapPos.x, loadMapPos.z, MapWidth, MapHeight, UnitWidth, mapInfoData);
        // 解析地图障碍层
        MapManager.Instance().AnalysisMap(mapInfoData);
        // 创建建筑层, 并传入基地等级
        MapManager.Instance().AnalysisMap(mapInfoBuildingData, new MapManager.MapDataParamsPacker()
        {
            MapId = GlobalData.FightData.MapId,
            BaseLevel = GlobalData.FightData.BaseLevel,
            TurretLevel = GlobalData.FightData.TurretLevel,
            Race = GlobalData.FightData.Race,
            EnemyBaseLevel = GlobalData.FightData.EnemyBaseLevel,
            EnemyRace = GlobalData.FightData.EnemyRace,
            EnemyTurretLevel = GlobalData.FightData.EnemyTurretLevel
        });
    }

    /// <summary>
    /// 清理数据
    /// </summary>
    public void Clear()
    {
        // 清理单位
        ClusterManager.Single.ClearAll();
        // 清理本地缓存
        mapInfoData = null;
        memberPosDic.Clear();
    }

    // ----------------------战斗位置相关------------------------


    /// <summary>
    /// 设置单位位置
    /// </summary>
    /// <param name="camp">阵营</param>
    /// <param name="memberType">单位类型</param>
    /// <param name="pos">基地位置</param>
    public void SetMemberPos(int camp, MemberType memberType, Vector3 pos)
    {
        if (memberPosDic.ContainsKey(camp))
        {
            if (memberPosDic[camp].ContainsKey(memberType))
            {
                memberPosDic[camp][memberType] = pos;
            }
            else
            {
                memberPosDic[camp].Add(memberType, pos);
            }
        }
        else
        {
            memberPosDic.Add(camp, new Dictionary<MemberType, Vector3>()
            {
                {memberType, pos}
            });
        }
    }

    /// <summary>
    /// 获取单位位置
    /// </summary>
    /// <param name="camp">单位阵营</param>
    /// <param name="memberType">单位类型</param>
    public Vector3 GetPos(int camp, MemberType memberType)
    {
        Vector3 result = Vector3.zero;
        if (memberPosDic.ContainsKey(camp) && memberPosDic[camp].ContainsKey(memberType))
        {
            result = memberPosDic[camp][memberType];
        }
        return result;
    }

    ///// <summary>
    ///// 获取排头兵位置
    ///// </summary>
    ///// <param name="camp">阵营</param>
    ///// <returns>排头兵位置</returns>
    //public Vector3 GetFirstSoldierPos(int camp)
    //{
    //    Vector3 result = Vector3.zero;
    //}


    // ----------------------战斗抛事件相关----------------------

    /// <summary>
    /// 伤害类型
    /// </summary>
    /// <param name="obj">被变更单位</param>
    /// <param name="currentHp">当前血量</param>
    /// <param name="changeValue">变更血量</param>
    /// <param name="type">生命变更类型</param>
    /// <param name="totalHp">总血量</param>
    /// <param name="objType">单位类型</param>
    public void DoHealthChangeAction(GameObject obj, float totalHp, float currentHp, float changeValue, HurtType type, ObjectID.ObjectType objType)
    {
        if (healthChangeAction != null)
        {
            healthChangeAction(new HealthChangePacker(obj, totalHp, currentHp, changeValue, type, objType));
        }
    }

    /// <summary>
    /// 胜利阵营
    /// </summary>
    /// <param name="fieldCamp">失败方阵营</param>
    public void DoEndGameAction(int fieldCamp)
    {
        if (endGameAction != null)
        {
            endGameAction(fieldCamp);
        }
    }

    /// <summary>
    /// 单位死亡事件
    /// </summary>
    /// <param name="obj">死亡单位对象</param>
    /// <param name="camp">死亡单位阵营</param>
    /// <param name="memberType">单位类型</param>
    public void DoMemberDeadAction(GameObject obj, int camp, MemberType memberType)
    {
        if (memberDeadAction != null)
        {
            memberDeadAction(obj, camp, memberType);
        }
    }

    /// <summary>
    /// 设置收到伤害事件
    /// </summary>
    /// <param name="action"></param>
    public void SetHealthChangeAction(Action<HealthChangePacker> action)
    {
        healthChangeAction = action;
    }

    /// <summary>
    /// 设置游戏结束事件
    /// </summary>
    /// <param name="action"></param>
    public void SetEndGameAction(Action<int> action)
    {
        endGameAction = action;
    }

    /// <summary>
    /// 设置单位死亡事件
    /// </summary>
    /// <param name="action"></param>
    public void SetMemberDeadAction(Action<GameObject, int, MemberType> action)
    {
        memberDeadAction = action;
    }



    /// <summary>
    /// 获取伤害类型
    /// </summary>
    /// <param name="trigger"></param>
    /// <returns></returns>
    public static HurtType GetDemageHurtType(TriggerData trigger)
    {
        // 转换伤害类型
        var hurtType = HurtType.NormalAttack;
        if (trigger.IsCrit)
        {
            hurtType = HurtType.Crit;
        }
        else
        {
            switch (trigger.DemageType)
            {
                case DemageType.NormalAttackDemage:
                    hurtType = HurtType.NormalAttack;
                    break;
                case DemageType.SkillAttackDemage:
                    hurtType = HurtType.SkillAttack;
                    break;
            }
        }

        return hurtType;
    }

    /// <summary>
    /// 抛出伤害类型
    /// </summary>
    public enum HurtType
    {
        NormalAttack = 0,
        SkillAttack = 1,
        Cure = 2,
        Crit = 3,
        Miss = 4
    }

    /// <summary>
    /// 单位类型
    /// </summary>
    public enum MemberType
    {
        Base = 1,
        Turret = 2,
        Soldier = 3,
        Tank = 4,
    }

    /// <summary>
    /// 生命值变更时间包装类
    /// </summary>
    public class HealthChangePacker
    {
        /// <summary>
        /// 单位
        /// </summary>
        public GameObject GameObj { get; private set; }

        /// <summary>
        /// 总血量
        /// </summary>
        public float TotalHp { get; private set; }

        /// <summary>
        /// 当前血量
        /// </summary>
        public float CurrentHp { get; private set; }

        /// <summary>
        /// 变更量
        /// </summary>
        public float ChangeValue { get; private set; }

        /// <summary>
        /// 生命值变更类型
        /// </summary>
        public HurtType HurtType { get; private set; }

        /// <summary>
        /// 单位类型
        /// </summary>
        public ObjectID.ObjectType ObjType { get; private set; }

        /// <summary>
        /// 初始化
        /// </summary>
        /// <param name="gameObj"></param>
        /// <param name="totalHp"></param>
        /// <param name="currentHp"></param>
        /// <param name="changeValue"></param>
        /// <param name="hurtType"></param>
        /// <param name="objType"></param>
        public HealthChangePacker(GameObject gameObj, float totalHp, float currentHp, float changeValue,
            HurtType hurtType, ObjectID.ObjectType objType)
        {
            GameObj = gameObj;
            TotalHp = totalHp;
            CurrentHp = currentHp;
            ChangeValue = changeValue;
            HurtType = hurtType;
            ObjType = objType;
        }
    }
}


/// <summary>
/// 战斗数据统计
/// </summary>
public class FightDataStatistical
{
    /// <summary>
    /// 单例
    /// </summary>
    public static FightDataStatistical Single
    {
        get
        {
            if (single == null)
            {
                single = new FightDataStatistical();
            }

            return single;
        }
    }

    /// <summary>
    /// 单例对象
    /// </summary>
    private static FightDataStatistical single = null;

    // 记录每个单位的数据
    // 伤害, 治疗, (分技能普攻)杀敌, 技能释放次数
    // 记录一个阵营的伤害, 治疗, 杀敌, 技能次数, 场上人数
    // 记录全部的伤害, 治疗, 杀敌, 技能次数, 场上人数, 费用总和
    // 统计场上单位费用总和
    // 费用

    /// <summary>
    /// 记录float数据
    /// </summary>
    private Dictionary<string, float> floatDic = new Dictionary<string, float>();

    /// <summary>
    /// 记录int数据
    /// </summary>
    private Dictionary<string, int> intDic = new Dictionary<string, int>();

    /// <summary>
    /// 费用值数据列表
    /// </summary>
    private List<ArmyTypeData> costDataList = new List<ArmyTypeData>();


    // -----------------------单人生命值变更统计------------------------------

    /// <summary>
    /// 统计花费
    /// </summary>
    /// <param name="data">被统计数据</param>
    public void AddCostData(ArmyTypeData data)
    {
        if (data != null && !costDataList.Contains(data))
        {
            costDataList.Add(data);
        }
    }

    /// <summary>
    /// 删除花费
    /// </summary>
    /// <param name="data"></param>
    public void DelCostData(ArmyTypeData data)
    {
        if (costDataList.Contains(data))
        {
            costDataList.Remove(data);
        }
    }

    /// <summary>
    /// 条件获取花费
    /// </summary>
    /// <returns></returns>
    public int GetCostData(int camp, 
        int armyId = -1,
        int armyType = -1, 
        int generalType = -1,
        int isAntiAir = -1,
        int isAntiSurface = -1,
        int isAntiHide = -1,
        int isAntiGroup = -1,
        int isHide = -1,
        int isGroup = -1
        )
    {
        var result = 0;

        var list = costDataList.Where(cost => cost.Camp == camp);
        if (armyId >= 0)
        {
            list = list.Where(cost => cost.ArmyId == armyId);
        }
        // 查询种族
        if (armyType >=  0)
        {
            list = list.Where(cost => cost.ArmyType == armyType);
        }
        // 查询空地属性
        if (generalType >= 0)
        {
            list = list.Where(cost => cost.GeneralType == generalType);
        }
        // 查询对空单位
        if (isAntiAir >= 0)
        {
            list = list.Where(cost => cost.IsAntiAir == isAntiAir);
        }
        // 查询对地单位
        if (isAntiSurface >= 0)
        {
            list = list.Where(cost => cost.IsAntiSurface == isAntiSurface);
        }
        // 查询反隐单位
        if (isAntiHide >= 0)
        {
            list = list.Where(cost => cost.IsAntiHide == isAntiHide);
        }
        // 查询反群单位
        if (isAntiGroup >= 0)
        {
            list = list.Where(cost => cost.IsAntiGroup == isAntiGroup);
        }
        // 查询隐形单位
        if (isHide >= 0)
        {
            list = list.Where(cost => cost.IsHide == isHide);
        }
        // 查询群单位
        if (isGroup >= 0)
        {
            list = list.Where(cost => cost.IsGroup == isGroup);
        }
        // 统计费用
        foreach (var costData in list)
        {
            result += costData.SingleCost;
        }

        return result;
    }

    /// <summary>
    /// 添加伤害统计
    /// </summary>
    /// <param name="key">key</param>
    /// <param name="changeValue">变更量</param>
    /// <param name="camp">阵营</param>
    /// <param name="changeType">变更类型</param>
    /// <param name="demageType">伤害类型</param>
    /// <param name="attackOrBeAttach">攻击/被攻击</param>
    public void AddHealthChange(string key, float changeValue, int camp, DemageOrCure changeType, DemageType demageType, AttackOrBeAttach attackOrBeAttach = AttackOrBeAttach.BeAttach)
    {
        var tmpKey = key + "%" + camp + "%" + changeType + "%" + demageType + "%" + attackOrBeAttach;
        SetFloat(tmpKey, changeValue);
        AddCampHealthChange(camp, changeValue, changeType, attackOrBeAttach);
    }

    /// <summary>
    /// 获取单位伤害统计
    /// </summary>
    /// <param name="key"></param>
    /// <param name="camp">阵营</param>
    /// <param name="changeType">变更类型</param>
    /// <param name="demageType">伤害类型</param>
    /// <param name="attackOrBeAttach"></param>
    /// <returns>变更量</returns>
    public float GetHealthChange(string key, int camp, DemageOrCure changeType, DemageType demageType, AttackOrBeAttach attackOrBeAttach = AttackOrBeAttach.BeAttach)
    {
        var tmpKey = key + "%" + camp + "%" + changeType + "%" + demageType + "%" + attackOrBeAttach;
        return GetFloat(tmpKey);
    }


    // -----------------------击杀统计------------------------------


    /// <summary>
    /// 添加杀敌数量
    /// </summary>
    /// <param name="key"></param>
    /// <param name="killCount">本次杀敌数量</param>
    /// <param name="camp">阵营</param>
    public void AddKillCount(string key, int killCount, int camp)
    {
        var tmpKey = key + "%" + camp + "%Kill";
        AddInt(tmpKey, killCount);
    }

    /// <summary>
    /// 获取杀敌数量
    /// </summary>
    /// <param name="key"></param>
    /// <param name="camp">阵营</param>
    /// <returns></returns>
    public int GetKillCount(string key, int camp)
    {
        var tmpKey = key + "%" + camp + "%Kill";
        return GetInt(tmpKey);
    }


    // -----------------------死亡统计------------------------------

    /// <summary>
    /// 添加被杀数量
    /// </summary>
    /// <param name="key"></param>
    /// <param name="killCount">本次杀敌数量</param>
    /// <param name="camp">阵营</param>
    /// <param name="armyType">种族</param>
    /// <param name="generalType">空地建筑属性</param>
    public void AddBeKillCount(string key, int killCount, int camp, int armyType, int generalType)
    {
        var tmpKey = key + "%" + camp + "%" + armyType + "%" + generalType + "%Kill";
        AddInt(tmpKey, killCount);
        SubMemberCount(camp, armyType, generalType);
    }

    /// <summary>
    /// 获取被杀数量
    /// </summary>
    /// <param name="key"></param>
    /// <param name="camp">阵营</param>
    /// <param name="armyType">种族</param>
    /// <param name="generalType">空地建筑属性</param>
    /// <returns></returns>
    public int GetBeKillCount(string key, int camp, int armyType, int generalType)
    {
        var tmpKey = key + "%" + camp + "%" + armyType + "%" + generalType + "%Kill";
        return GetInt(tmpKey);
    }



    // -----------------------技能释放数量统计------------------------------


    /// <summary>
    /// 添加杀敌数量
    /// </summary>
    /// <param name="key"></param>
    /// <param name="skillCount">本次杀敌数量</param>
    /// <param name="camp">阵营</param>
    public void AddSkillCount(string key, int skillCount, int camp)
    {
        var tmpKey = key + "%" + camp + "%Skill";
        AddInt(tmpKey, skillCount);
    }

    /// <summary>
    /// 获取杀敌数量
    /// </summary>
    /// <param name="key"></param>
    /// <param name="camp">阵营</param>
    /// <returns></returns>
    public int GetSkillCount(string key, int camp)
    {
        var tmpKey = key + "%" + camp + "%Skill";
        return GetInt(tmpKey);
    }


    // -----------------------阵营人数统计------------------------------

    /// <summary>
    /// 添加阵营生命值变更
    /// </summary>
    /// <param name="camp">阵营</param>
    /// <param name="changeValue">变更值</param>
    /// <param name="demageOrCure">值变更类型</param>
    /// <param name="attackOrBeAttach">攻击或被攻击</param>
    private void AddCampHealthChange(int camp, float changeValue, DemageOrCure demageOrCure, AttackOrBeAttach attackOrBeAttach = AttackOrBeAttach.BeAttach)
    {
        var key = camp + "%" + demageOrCure + "%" + attackOrBeAttach;
        SetFloat(key, changeValue);
        AddAllhealthChange(changeValue, demageOrCure, attackOrBeAttach);
    }

    /// <summary>
    /// 获取阵营生命值变更
    /// </summary>
    /// <param name="camp"></param>
    /// <param name="demageOrCure"></param>
    /// <param name="attackOrBeAttach">攻击或被攻击</param>
    public float GetCampHealthChange(int camp, DemageOrCure demageOrCure, AttackOrBeAttach attackOrBeAttach)
    {
        var key = camp + "%" + demageOrCure + "%" + attackOrBeAttach;
        return GetFloat(key);
    }


    // -----------------------全场生命变更统计------------------------------

    /// <summary>
    /// 添加所有生命值变更统计
    /// </summary>
    /// <param name="changeValue">变更值</param>
    /// <param name="demageOrCure">变更类型</param>
    /// <param name="attackOrBeAttach">攻击或被攻击</param>
    private void AddAllhealthChange(float changeValue, DemageOrCure demageOrCure, AttackOrBeAttach attackOrBeAttach = AttackOrBeAttach.BeAttach)
    {
        var key = demageOrCure + "%" + attackOrBeAttach;
        SetFloat(key, changeValue);
    }

    /// <summary>
    /// 获取所有生命值变更统计
    /// </summary>
    /// <param name="demageOrCure">变更类型</param>
    /// <param name="attackOrBeAttach">攻击或被攻击</param>
    /// <returns></returns>
    public float GetAllHealthChange(DemageOrCure demageOrCure, AttackOrBeAttach attackOrBeAttach)
    {
        var key = demageOrCure + "%" + attackOrBeAttach;
        return GetFloat(key);
    }


    // -----------------------场上人数统计------------------------------

    /// <summary>
    /// 添加单位
    /// </summary>
    /// <param name="camp">阵营</param>
    /// <param name="count">数量</param>
    /// <param name="armyType">种族</param>
    /// <param name="generalType">空地建筑属性</param>
    public void AddMemberCount(int camp, int count, int armyType, int generalType)
    {
        AddInt(camp + "%" + armyType + "%" + generalType, count);
        AddInt(camp + "%" + armyType, count);
        AddInt(camp + "%" + generalType, count);
        AddInt("" + camp, count);
    }

    /// <summary>
    /// 减去单位
    /// </summary>
    /// <param name="camp">阵营</param>
    /// <param name="armyType">种族</param>
    /// <param name="generalType">空地建筑属性</param>
    private void SubMemberCount(int camp, int armyType, int generalType)
    {
        var key = camp + "%" + armyType + "%" + generalType;
        // 设置类型数量
        var value = GetInt(key);
        value--;
        if (value < 0)
        {
            value = 0;
        }
        AddInt(key, value);

        var key2 = camp + "%" + armyType;
        // 设置类型数量
        value = GetInt(key2);
        value--;
        if (value < 0)
        {
            value = 0;
        }
        AddInt(key2, value);

        var key3 = camp + "%" + generalType;
        // 设置类型数量
        value = GetInt(key3);
        value--;
        if (value < 0)
        {
            value = 0;
        }
        AddInt(key3, value);


        var key4 = "" + camp;
        // 设置阵营数量
        value = GetInt(key4);
        value--;
        if (value < 0)
        {
            value = 0;
        }
        AddInt(key4, value);
    }

    /// <summary>
    /// 获取场上人数
    /// </summary>
    /// <param name="camp">阵营</param>
    /// <param name="armyType">种族</param>
    /// <param name="generalType">空地建筑属性</param>
    /// <returns></returns>
    public int GetMemberCount(int camp, int armyType = -1, int generalType = -1)
    {
        var key = "" + camp;
        if (armyType != -1)
        {
            key += "%" + armyType;
        }

        if (generalType != -1)
        {
            key += "%" + generalType;
        }
        return GetInt(key);
    }


    // -----------------------基础数据控制------------------------------


    /// <summary>
    /// 设置float数据
    /// </summary>
    /// <param name="key"></param>
    /// <param name="value"></param>
    public void SetFloat(string key, float value)
    {
        if (floatDic.ContainsKey(key))
        {
            floatDic[key] += value;
        }
        else
        {
            floatDic.Add(key, value);
        }
    }

    /// <summary>
    /// 获取float数据
    /// </summary>
    /// <param name="key"></param>
    /// <returns></returns>
    public float GetFloat(string key)
    {
        if (floatDic.ContainsKey(key))
        {
            return floatDic[key];
        }
        return 0;
    }


    /// <summary>
    /// 设置int值
    /// </summary>
    /// <param name="key"></param>
    /// <param name="value"></param>
    public void AddInt(string key, int value)
    {
        if (intDic.ContainsKey(key))
        {
            intDic[key] += value;
        }
        else
        {
            intDic.Add(key, value);
        }
    }

    /// <summary>
    /// 获取int值
    /// </summary>
    /// <param name="key"></param>
    /// <returns></returns>
    public int GetInt(string key)
    {
        if (intDic.ContainsKey(key))
        {
            return intDic[key];
        }
        return 0;
    }



    /// <summary>
    /// 清空数据
    /// </summary>
    public void Clear()
    {
        floatDic.Clear();
        intDic.Clear();
    }
}