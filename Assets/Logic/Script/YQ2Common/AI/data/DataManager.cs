using System;
using System.Collections.Generic;
using UnityEngine;
using Object = System.Object;

public class DataManager : MonoEX.Singleton<DataManager>
{

    private Dictionary<int, FightVO> _mySoldiersDict;
    private Dictionary<int, FightVO> _enemySoldiersDict;
    private Dictionary<int, JiDiVO> _myJidiDict;
    private Dictionary<int, JiDiVO> _enemyJidiDict;
    private Dictionary<int, TankVO> _myTankDict;
    private Dictionary<int, TankVO> _enemyTankDict;
    private Dictionary<int, ObstacleVO> _myObstacleDict;
    private Dictionary<int, ObstacleVO> _enemyObstacleDict;
    private Dictionary<int, VOBase> _npcObstacleDict; 

    public DataManager()
    {
        _mySoldiersDict = new Dictionary<int, FightVO>();
        _enemySoldiersDict = new Dictionary<int, FightVO>();
        _myJidiDict = new Dictionary<int, JiDiVO>();
        _enemyJidiDict = new Dictionary<int, JiDiVO>();
        _myTankDict = new Dictionary<int, TankVO>();
        _enemyTankDict = new Dictionary<int, TankVO>();
        _myObstacleDict = new Dictionary<int, ObstacleVO>();
        _enemyObstacleDict = new Dictionary<int, ObstacleVO>();
        _npcObstacleDict = new Dictionary<int, VOBase>();
    }
    /// <summary>
    /// 获取某一个阵营的所有对象包括士兵 装甲 飞机等 1我方 2敌方 3中立
    /// </summary>
    /// <param name="camp"></param>
    /// <returns></returns>
    public List<VOBase> GetAllCampObjs(int camp)
    {
        List<VOBase> res = new List<VOBase>();
        switch (camp)
        {
            case 1:
                foreach (var vo in _mySoldiersDict)
                {
                    res.Add(vo.Value);
                }

                foreach (var vo in _myTankDict)
                {
                    res.Add(vo.Value);
                }
                break;
            case 2:
                foreach (var vo in _enemySoldiersDict)
                {
                    res.Add(vo.Value);
                }

                foreach (var vo in _enemyTankDict)
                {
                    res.Add(vo.Value);
                }
                break;
            case 3:
                break;
        }
        return res;
    }

    public DisplayOwner Create(VOBase value, CreateActorParam otherParam)
    {
        DisplayOwner result = null;
        switch (value.ObjID.ObjType)
        {
            case ObjectID.ObjectType.MyJiDi:
                var myJidi = value as JiDiVO;
                result = CreateBase(myJidi, Utils.MyCamp, otherParam);
                break;
            case ObjectID.ObjectType.EnemyJiDi:
                var enemyjidi = value as JiDiVO;
                result = CreateBase(enemyjidi, Utils.EnemyCamp, otherParam);
                break;
            case ObjectID.ObjectType.MySoldier:
                var mysoldier = value as FightVO;
                // 设置阵营
                mysoldier.Camp = Utils.MyCamp;
                result = CreateSoldier(mysoldier, otherParam);
                break;
            case ObjectID.ObjectType.EnemySoldier:
                var enemysoldier = value as FightVO;
                // 设置阵营
                enemysoldier.Camp = Utils.EnemyCamp;
                result = CreateSoldier(enemysoldier, otherParam);
                break;
            case ObjectID.ObjectType.MyTank:
                var mytank = value as TankVO;
                CreateMyTank(mytank);
                break;
            case ObjectID.ObjectType.EnemyTank:
                var enemyTank = value as TankVO;
                CreateEnemyTank(enemyTank);
                break;
            case ObjectID.ObjectType.MyObstacle:
                var myobstacle = value as ObstacleVO;
                CreateMyObstacle(myobstacle);
                break;
            case ObjectID.ObjectType.EnemyObstacle:
                var enemyobstacle = value as ObstacleVO;
                CreateEnemyObstacle(enemyobstacle);
                break;

            case ObjectID.ObjectType.NPCObstacle:
                result = CreateNPCObstacle(value, otherParam);
                break;
        }
        return result;
    }


    /// <summary>
    /// 创建基地
    /// </summary>
    /// <param name="jidiVo">基地数据</param>
    /// <param name="camp">基地阵营</param>
    /// <param name="otherParam">其他参数</param>
    /// <returns></returns>
    private DisplayOwner CreateBase(JiDiVO jidiVo, int camp, CreateActorParam otherParam)
    {
        DisplayOwner result = null;
        if (jidiVo == null)
        {
            return result;
        }
        // 设置阵营
        jidiVo.Camp = camp;
        // 根据等级获得对应数据
        var enemyJidiConfig = SData_armybase_c.Single.GetDataOfID(Utils.BaseBaseId + otherParam.Level);
        jidiVo.SetSoldierData(enemyJidiConfig);
        _myJidiDict.Add(jidiVo.ObjID.ID, jidiVo);

        // 创建基地模型
        // 从AB包中加载
        var baseObj = GameObjectExtension.InstantiateFromPacket("jidi", "zhujidi_model", null);
        // 设置父级
        ParentManager.Instance().SetParent(baseObj, ParentManager.BuildingParent);
        var mesh = baseObj.GetComponentInChildren<SkinnedMeshRenderer>();
        Texture texture = null;
        switch (camp)
        {
            case Utils.MyCamp:
                baseObj.transform.Rotate(new Vector3(0, 90, 0));
                texture = PacketManage.Single.GetPacket("jidi").Load("zhujidi_b_texture") as Texture;
                break;
            case Utils.EnemyCamp:
                baseObj.transform.Rotate(new Vector3(0, -90, 0));
                texture = PacketManage.Single.GetPacket("jidi").Load("zhujidi_r_texture") as Texture;
                break;
        }
        mesh.material.mainTexture = texture;
        baseObj.transform.position = new Vector3(otherParam.X, -35, otherParam.Y);


        var cluster = baseObj.AddComponent<ClusterData>();
        cluster.AllData.MemberData = jidiVo;
        //cluster.GroupId = 999;
        cluster.AllData.MemberData.MoveSpeed = -1;
        cluster.Diameter = 40;
        cluster.X = otherParam.X;
        cluster.Y = otherParam.Y;
        cluster.Stop();
        ClusterManager.Single.Add(cluster);

        // 创建RanderControl
        //var randerControl = myBase.AddComponent<RanderControl>();


        // 创建外层持有类
        var displayOwner = new DisplayOwner(baseObj, cluster, null, null);
        DisplayerManager.Single.AddElement(jidiVo.ObjID, displayOwner);

        //// 创建MFAModelRander
        //var mfaModelRander = myBase.GetComponent<MFAModelRender>();
        //mfaModelRander.ObjId = cluster.MemberData.ObjID;

        //displayOwner.MFAModelRender = mfaModelRander;

        return result;
    }

    private JiDiVO getMyJidi(int id)
    {
        if (_myJidiDict.ContainsKey(id)) return _myJidiDict[id];
        return null;
    }

    private void DeleteMyJidi(int id)
    {
        try
        {
            _myJidiDict.Remove(id);
        }
        catch
        {
            throw new Exception(String.Format("我方基地列表中不存在这个id {0}", id));
        }
    }

    private JiDiVO GetEnemyJidi(int id)
    {
        if (_enemyJidiDict.ContainsKey(id)) return _enemyJidiDict[id];
        return null;
    }

    private void DeleteEnemyJidi(int id)
    {
        try
        {
            _enemyJidiDict.Remove(id);
        }
        catch
        {
            throw new Exception(String.Format("敌方基地列表中不存在这个id {0}", id));
        }
    }

    private DisplayOwner CreateSoldier(FightVO soldier, CreateActorParam param)
    {
        if (soldier.ObjID.ObjType == ObjectID.ObjectType.MySoldier)
        {
            _mySoldiersDict.Add(soldier.ObjID.ID, soldier);
        }
        if (soldier.ObjID.ObjType == ObjectID.ObjectType.EnemySoldier)
        {
            _enemySoldiersDict.Add(soldier.ObjID.ID, soldier);
        }
        // 设置数据
        var soldierId = param.SoldierID;
        var config = SData_armybase_c.Single.GetDataOfID(soldierId);
        soldier.SetSoldierData(config);

        //var display = DP_FightPrefabManage.InstantiateAvatar(param);
        //通过对象池创建角色
        var display = DisplayerManager.Single.CreateAvatar(soldier.Name, param);
        // 设置父级
        ParentManager.Instance().SetParent(display, ParentManager.ClusterParent);

        // 创建渲染
        var mfa = display.GetComponent<MFAModelRender>();
        mfa.ObjId = soldier.ObjID;

        // 创建集群数据
        mfa.Cluster = display.AddComponent<ClusterData>();
        mfa.Cluster.SetDataValue(soldier);

        // 创建外层持有类
        var displayOwner = new DisplayOwner(display, mfa.Cluster, mfa, null);
        DisplayerManager.Single.AddElement(soldier.ObjID, displayOwner);

        // 启动单位状态机
        //randerControl.StartFSM(displayOwner);

        // 设置目标选择权重数据
        var aimData = SData_armyaim_c.Single.GetDataOfID(soldier.ArmyID);
        mfa.Cluster.AllData.SelectWeightData = new SelectWeightData(aimData);

        if (soldier.AttackType == Utils.BulletTypeScope)
        {
            // 加载单位的AOE数据
            var aoeData = SData_armyaoe_c.Single.GetDataOfID(soldier.ArmyID);
            mfa.Cluster.AllData.AOEData = new ArmyAOEData(aoeData);
        }

        // 加载并设置技能
        displayOwner.ClusterData.AllData.SkillInfoList = SkillManager.Single.LoadSkillInfoList(new List<int>()
                {
                    soldier.Skill1,
                    soldier.Skill2,
                    soldier.Skill3,
                    soldier.Skill4,
                    soldier.Skill5,
                });

        return displayOwner;
    }

    public FightVO GetMySoldier(int id)
    {
        if (_mySoldiersDict.ContainsKey(id)) return _mySoldiersDict[id];
        return null;
    }

    private void DeleteSoldier(ObjectID obj)
    {
        switch (obj.ObjType)
        {
            case ObjectID.ObjectType.MySoldier:
                _mySoldiersDict.Remove(obj.ID);
                break;
            case ObjectID.ObjectType.EnemySoldier:
                _enemySoldiersDict.Remove(obj.ID);
                break;
        }
        DisplayerManager.Single.DeleteElement(obj);
    }

    public FightVO GetEnemySoldier(int id)
    {
        if (_enemySoldiersDict.ContainsKey(id)) return _enemySoldiersDict[id];
        return null;
    }

    private void CreateMyTank(TankVO tank)
    {
        _myTankDict.Add(tank.ObjID.ID, tank);
    }

    private TankVO GetMyTank(int id)
    {
        if (_myTankDict.ContainsKey(id)) return _myTankDict[id];
        return null;
    }

    private void DeleteMyTank(int id)
    {
        try
        {
            _myTankDict.Remove(id);
        }
        catch
        {
            throw new Exception(String.Format("我方坦克列表中不存在这个id {0}", id));
        }
    }

    private void CreateEnemyTank(TankVO tank)
    {
        _enemyTankDict.Add(tank.ObjID.ID, tank);
    }

    private TankVO GetEnemyTank(int id)
    {
        if (_enemyTankDict.ContainsKey(id)) return _enemyTankDict[id];
        return null;
    }

    private void DeleteEnemyTank(int id)
    {
        try
        {
            _enemyTankDict.Remove(id);
        }
        catch
        {
            throw new Exception(String.Format("敌方坦克列表中不存在这个id {0}", id));
        }
    }

    private void CreateMyObstacle(ObstacleVO obstacle)
    {
        _myObstacleDict.Add(obstacle.ObjID.ID, obstacle);
    }

    private ObstacleVO GetMyObstacle(int id)
    {
        if (_myObstacleDict.ContainsKey(id)) return _myObstacleDict[id];
        return null;
    }

    private void DeleteMyObstacle(int id)
    {
        try
        {
            _myObstacleDict.Remove(id);
        }
        catch
        {
            throw new Exception(String.Format("我方障碍物列表中不存在这个id {0}", id));
        }
    }

    private void CreateEnemyObstacle(ObstacleVO obstacle)
    {
        _enemyObstacleDict.Add(obstacle.ObjID.ID, obstacle);
    }

    private ObstacleVO GetEnemyObstacle(int id)
    {
        if (_enemyObstacleDict.ContainsKey(id)) return _enemyObstacleDict[id];
        return null;
    }

    private void DeleteEnemyObstacle(int id)
    {
        try
        {
            _enemyObstacleDict.Remove(id);
        }
        catch
        {
            throw new Exception(String.Format("敌方障碍物列表中不存在这个id {0}", id));
        }
    }

    /// <summary>
    /// 创建中立障碍物
    /// </summary>
    /// <param name="vo">数据</param>
    private DisplayOwner CreateNPCObstacle(VOBase vo, CreateActorParam otherParam)
    {
        _npcObstacleDict.Add(vo.ObjID.ID, vo);
        var fixItem = GameObject.CreatePrimitive(PrimitiveType.Cube);
        // 设置父级
        ParentManager.Instance().SetParent(fixItem, ParentManager.ObstacleParent);
        fixItem.layer = LayerMask.NameToLayer("Scenery");//TODODO 下边测试
        //fixItem.name += i;
        var fix = fixItem.AddComponent<FixtureData>();
        var unitWidth = ClusterManager.Single.UnitWidth;
        var mapWidth = ClusterManager.Single.MapWidth;
        var mapHeight = ClusterManager.Single.MapHeight;
        var offsetPos = LoadMap.Single.transform.position;
        fix.AllData.MemberData = new VOBase()
        {
            ObjID = new ObjectID(ObjectID.ObjectType.NPCObstacle),
            SpaceSet = 1 * unitWidth,
        };
        fix.transform.localScale = new Vector3(unitWidth, unitWidth, unitWidth);
        fix.transform.position = Utils.NumToPosition(offsetPos, new Vector2(otherParam.X, otherParam.Y), unitWidth, mapWidth, mapHeight);
        fix.X = otherParam.X * unitWidth - mapWidth * unitWidth * 0.5f + offsetPos.x;
        fix.Y = otherParam.Y * unitWidth - mapHeight * unitWidth * 0.5f + offsetPos.z;
        fix.Diameter = 1 * unitWidth;
        var result = new DisplayOwner(fixItem, fix, null, null);

        ClusterManager.Single.Add(fix);

        DisplayerManager.Single.AddElement(vo.ObjID, result);

        return result;
    }

    public T Retrieve<T>(ObjectID ObjID) where T : class
    {
        Object value = null;
        if (null == ObjID)
        {
            return null;
        }

        switch (ObjID.ObjType)
        {
            case ObjectID.ObjectType.MyJiDi:
                value = getMyJidi(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemyJiDi:
                value = GetEnemyJidi(ObjID.ID);
                break;
            case ObjectID.ObjectType.MySoldier:
                value = GetMySoldier(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemySoldier:
                value = GetEnemySoldier(ObjID.ID);
                break;
            case ObjectID.ObjectType.MyTank:
                value = GetMyTank(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemyTank:
                value = GetEnemyTank(ObjID.ID);
                break;
            case ObjectID.ObjectType.MyObstacle:
                value = GetMyObstacle(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemyObstacle:
                value = GetEnemyObstacle(ObjID.ID);
                break;
        }
        return (T) value;
    }

    public void Delete<T>(ObjectID ObjID)
    {
        switch (ObjID.ObjType)
        {
            case ObjectID.ObjectType.MyJiDi:
                DeleteMyJidi(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemyJiDi:
                DeleteEnemyJidi(ObjID.ID);
                break;
            case ObjectID.ObjectType.MySoldier:
                DeleteSoldier(ObjID);
                break;
            case ObjectID.ObjectType.EnemySoldier:
                DeleteSoldier(ObjID);
                break;
            case ObjectID.ObjectType.MyTank:
                DeleteMyTank(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemyTank:
                DeleteEnemyTank(ObjID.ID);
                break;
            case ObjectID.ObjectType.MyObstacle:
                DeleteMyObstacle(ObjID.ID);
                break;
            case ObjectID.ObjectType.EnemyObstacle:
                DeleteEnemyObstacle(ObjID.ID);
                break;
        }
    }
}
