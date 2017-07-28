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
    private Dictionary<int, TurretVO> _myTurretDict;
    private Dictionary<int, TurretVO> _enemyTurretDict;
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
        _myTurretDict = new Dictionary<int, TurretVO>();
        _enemyTurretDict = new Dictionary<int, TurretVO>();
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
                myJidi.Camp = Utils.MyCamp;
                result = CreateBase(myJidi, otherParam);
                break;

            case ObjectID.ObjectType.EnemyJiDi:
                var enemyjidi = value as JiDiVO;
                enemyjidi.Camp = Utils.EnemyCamp;
                result = CreateBase(enemyjidi, otherParam);
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

            case ObjectID.ObjectType.MyTower:
                // 我方防御塔
                var myTurret = value as TurretVO;
                // 设置阵营
                myTurret.Camp = Utils.MyCamp;
                result = CreateTurret(myTurret, otherParam);
                break;

            case ObjectID.ObjectType.EnemyTower:
                // 敌方防御塔
                var enemyTurret = value as TurretVO;
                // 设置阵营
                enemyTurret.Camp = Utils.EnemyCamp;
                result = CreateTurret(enemyTurret, otherParam);
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
    private DisplayOwner CreateBase(JiDiVO jidiVo, CreateActorParam otherParam)
    {
        DisplayOwner result = null;
        if (jidiVo == null || otherParam == null)
        {
            return result;
        }
        // 根据等级获得对应数据
        var baseConfig = SData_armybase_c.Single.GetDataOfID(Utils.BaseBaseId + otherParam.Level);
        jidiVo.SetSoldierData(baseConfig);

        // 创建基地模型
        // 从AB包中加载
        // TODO 修改加载来源, 统一位置
        var baseObj = GameObjectExtension.InstantiateFromPacket("jidi", "zhujidi_model", null);

        // 设置父级
        ParentManager.Instance().SetParent(baseObj, ParentManager.BuildingParent);
        var mesh = baseObj.GetComponentInChildren<SkinnedMeshRenderer>();
        Texture texture = null;
        switch (jidiVo.Camp)
        {
            case Utils.MyCamp:
                _myJidiDict.Add(jidiVo.ObjID.ID, jidiVo);
                // 旋转角度
                baseObj.transform.Rotate(new Vector3(0, 90, 0));
                texture = PacketManage.Single.GetPacket("jidi").Load("zhujidi_b_texture") as Texture;
                break;
            case Utils.EnemyCamp:
                _enemyJidiDict.Add(jidiVo.ObjID.ID, jidiVo);
                // 旋转角度
                baseObj.transform.Rotate(new Vector3(0, -90, 0));
                texture = PacketManage.Single.GetPacket("jidi").Load("zhujidi_r_texture") as Texture;
                break;
        }
        mesh.material.mainTexture = texture;
        // 获取距离地面高度
        var height = SData_Constant.Single.GetDataOfID(Utils.SurfaceTypeConstantId).Value;
        baseObj.transform.position = new Vector3(otherParam.X, height, otherParam.Y);

        // TODO 添加BuildingClusterData
        var cluster = baseObj.AddComponent<ClusterData>();
        // 设置在地面上
        cluster.Height = SData_Constant.Single.GetDataOfID(Utils.SurfaceTypeConstantId).Value;
        cluster.CollisionGroup = Utils.SurfaceCollisionGroup;
        cluster.AllData.MemberData = jidiVo;
        cluster.X = otherParam.X;
        cluster.Y = otherParam.Y;
        cluster.Stop();
        ClusterManager.Single.Add(cluster);

        // 创建外层持有类
        var displayOwner = new DisplayOwner(baseObj, cluster);
        DisplayerManager.Single.AddElement(jidiVo.ObjID, displayOwner);

        // 创建RanderControl
        var randerControl = baseObj.AddComponent<RanderControl>();
        displayOwner.RanderControl = randerControl;
        randerControl.Begin();
        //// 创建MFAModelRander
        //var mfaModelRander = myBase.GetComponent<MFAModelRender>();
        //mfaModelRander.ObjId = cluster.MemberData.ObjID;

        //displayOwner.MFAModelRender = mfaModelRander;

        // 创建事件检查器
        var triggerRunner = baseObj.AddComponent<TriggerRunner>();
        triggerRunner.Display = displayOwner;

        return result;
    }

    /// <summary>
    /// 创建防御塔
    /// </summary>
    /// <param name="turretVo">防御塔数据</param>
    /// <param name="otherParam">其他参数</param>
    /// <returns></returns>
    private DisplayOwner CreateTurret(TurretVO turretVo, CreateActorParam otherParam)
    {
        if (turretVo == null || otherParam == null)
        {
            return null;
        }

        DisplayOwner result = null;

        // 加载数据
        var turretConfig = SData_armybase_c.Single.GetDataOfID(Utils.TurretBaseId + otherParam.Level);
        turretVo.SetSoldierData(turretConfig);

        // 从AB包中加载模型
        // TODO 修改加载来源, 统一位置
        var turretObj = GameObjectExtension.InstantiateFromPacket("turret", "TurretModel", null);

        // 设置父级
        ParentManager.Instance().SetParent(turretObj, ParentManager.BuildingParent);

        var mesh = turretObj.GetComponentInChildren<SkinnedMeshRenderer>();
        Texture texture = null;
        // 区分阵营加载不同皮肤
        switch (turretVo.Camp)
        {
            case Utils.MyCamp:
                // 我方阵营
                // 放入列表
                _myTurretDict.Add(turretVo.ObjID.ID, turretVo);
                // 旋转角度
                turretObj.transform.Rotate(new Vector3(0, 90, 0));
                // 更换皮肤
                texture = PacketManage.Single.GetPacket("turret").Load("FY_lan") as Texture;
                break;
            case Utils.EnemyCamp:
                // 敌方阵营
                // 放入列表
                _enemyTurretDict.Add(turretVo.ObjID.ID, turretVo);
                // 旋转角度
                turretObj.transform.Rotate(new Vector3(0, -90, 0));
                // 更换皮肤
                texture = PacketManage.Single.GetPacket("turret").Load("FY_hong") as Texture;
                break;
        }
        mesh.material.mainTexture = texture;

        // 设置位置
        var height = SData_Constant.Single.GetDataOfID(Utils.SurfaceTypeConstantId).Value;
        turretObj.transform.position = new Vector3(otherParam.X, height, otherParam.Y);

        // 添加ClusterData
        // TODO 添加BuildingClusterData
        var cluster = turretObj.AddComponent<ClusterData>();
        // 设置在地面上
        cluster.Height = SData_Constant.Single.GetDataOfID(Utils.SurfaceTypeConstantId).Value;
        cluster.CollisionGroup = Utils.SurfaceCollisionGroup;
        cluster.AllData.MemberData = turretVo;
        cluster.X = otherParam.X;
        cluster.Y = otherParam.Y;
        cluster.Stop();

        // 添加至ClusterManager中
        ClusterManager.Single.Add(cluster);

        // 创建外层持有类
        var displayOwner = new DisplayOwner(turretObj, cluster);
        DisplayerManager.Single.AddElement(turretVo.ObjID, displayOwner);

        // 创建RanderControl
        var randerControl = turretObj.AddComponent<RanderControl>();
        displayOwner.RanderControl = randerControl;
        // 启动RanderControl
        randerControl.Begin();

        // 创建事件检查器
        var triggerRunner = turretObj.AddComponent<TriggerRunner>();
        triggerRunner.Display = displayOwner;
        
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

    /// <summary>
    /// 创建单位
    /// </summary>
    /// <param name="soldier">单位数据</param>
    /// <param name="param">数据参数</param>
    /// <returns></returns>
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
        display.transform.position = new Vector3(param.X, 0, param.Y);
        // 设置父级
        ParentManager.Instance().SetParent(display, ParentManager.ClusterParent);

        // 创建渲染器
        var mfa = display.GetComponent<MFAModelRender>();
        mfa.ObjId = soldier.ObjID;

        // 创建集群数据
        mfa.Cluster = display.AddComponent<ClusterData>();
        mfa.Cluster.SetDataValue(soldier);


        // 设置空地高度
        switch (soldier.GeneralType)
        {
            // 空中单位高度
            case Utils.GeneralTypeAir:
                mfa.Cluster.Height = SData_Constant.Single.GetDataOfID(Utils.AirTypeConstantId).Value;
                mfa.Cluster.CollisionGroup = Utils.AirCollisionGroup;
                break;
            // 地面单位高度
            case Utils.GeneralTypeBuilding:
            case Utils.GeneralTypeSurface:
                mfa.Cluster.Height = SData_Constant.Single.GetDataOfID(Utils.SurfaceTypeConstantId).Value;
                mfa.Cluster.CollisionGroup = Utils.SurfaceCollisionGroup;
                break;
        }
        Debug.Log("类型: " + soldier.GeneralType + "高度: " + mfa.Cluster.Height);


        // 创建外层持有类
        var displayOwner = new DisplayOwner(display, mfa.Cluster, mfa);
        DisplayerManager.Single.AddElement(soldier.ObjID, displayOwner);

        // 创建RanderControl
        var randerControl = display.AddComponent<RanderControl>();
        displayOwner.RanderControl = randerControl;

        // 挂载事件处理器
        var triggerRunner = display.AddComponent<TriggerRunner>();
        // 设置数据
        triggerRunner.Display = displayOwner;

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
        displayOwner.ClusterData.AllData.SkillInfoList = SkillManager.Single.CreateSkillInfoList(new List<int>()
                {
                    soldier.Skill1,
                    soldier.Skill2,
                    soldier.Skill3,
                    soldier.Skill4,
                    soldier.Skill5,
                },
                displayOwner);
        // 创建单位是将技能属性(如果有)附加到单位上
        foreach (var skill in displayOwner.ClusterData.AllData.SkillInfoList)
        {
            SkillManager.Single.AttachSkillAttribute(skill, displayOwner.ClusterData.AllData.MemberData);
        }

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

        var result = new DisplayOwner(fixItem, fix);

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
