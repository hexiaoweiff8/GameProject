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
                // TODO 需要根据等级获得对应数据
                var myJidiConfig = SData_armybase_c.Single.GetDataOfID(220001001);
                myJidi.SetSoldierData(myJidiConfig);
                result = CreateMyJidi(myJidi);
                break;
            case ObjectID.ObjectType.EnemyJiDi:
                var enemyjidi = value as JiDiVO;
                // TODO 需要根据等级获得对应数据
                var enemyJidiConfig = SData_armybase_c.Single.GetDataOfID(220001001);
                enemyjidi.SetSoldierData(enemyJidiConfig);
                result = CreateEnemyJidi(enemyjidi);
                break;
            case ObjectID.ObjectType.MySoldier:
                var mysoldier = value as FightVO;
                mysoldier.Camp = 1;
                var soldierid = otherParam.SoldierID;
                var config = SData_armybase_c.Single.GetDataOfID(soldierid);
                mysoldier.SetSoldierData(config);
                // 加载并设置技能
                mysoldier.SkillInfoList = SkillManager.Single.LoadSkillInfoList(new List<int>()
                {
                    mysoldier.Skill1,
                    mysoldier.Skill2,
                    mysoldier.Skill3,
                    mysoldier.Skill4,
                    mysoldier.Skill5,
                });
                result = CreateSoldier(mysoldier, otherParam);
                break;
            case ObjectID.ObjectType.EnemySoldier:
                var enemysoldier = value as FightVO;
                enemysoldier.Camp = 2;
                var enemyId = otherParam.SoldierID;
                var enemyConfig = SData_armybase_c.Single.GetDataOfID(enemyId);
                enemysoldier.SetSoldierData(enemyConfig);
                // 加载并设置技能
                enemysoldier.SkillInfoList = SkillManager.Single.LoadSkillInfoList(new List<int>()
                {
                    enemysoldier.Skill1,
                    enemysoldier.Skill2,
                    enemysoldier.Skill3,
                    enemysoldier.Skill4,
                    enemysoldier.Skill5,
                });
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
        }
        return result;
    }

    private DisplayOwner CreateMyJidi(JiDiVO myjidi)
    {
        DisplayOwner result = null;
        if (myjidi != null)
        {
            _myJidiDict.Add(myjidi.ObjID.ID, myjidi);
            // 创建基地模型
            // 从AB包中加载
            var myBase = GameObjectExtension.InstantiateFromPacket("jidi", "zhujidi_model", null);
            var mesh = myBase.GetComponentInChildren<SkinnedMeshRenderer>();
            mesh.material.mainTexture = PacketManage.Single.GetPacket("jidi").Load("zhujidi_b_texture") as Texture;
            // TODO 设置角度与位置
            myBase.transform.position = new Vector3(-140, -38, -20);
            myBase.transform.Rotate(new Vector3(0, 90, 0));


            var cluster = myBase.AddComponent<ClusterData>();
            cluster.MemberData = myjidi;
            cluster.GroupId = 999;
            cluster.MemberData.MoveSpeed = -1;
            cluster.Diameter = 40;
            cluster.X = -140;
            cluster.Y = -20;
            cluster.Stop();
            ClusterManager.Single.Add(cluster);

            // 创建外层持有类
            var displayOwner = new DisplayOwner(myBase, cluster, null, null);
            DisplayerManager.Single.AddElement(myjidi.ObjID, displayOwner);
        }

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

    private DisplayOwner CreateEnemyJidi(JiDiVO enemyjidi)
    {
        DisplayOwner result = null;
        if (enemyjidi != null)
        {
            _enemyJidiDict.Add(enemyjidi.ObjID.ID, enemyjidi);
            // 创建基地模型
            // 从AB包中加载
            var enemyBase = GameObjectExtension.InstantiateFromPacket("jidi", "zhujidi_model", null);
            var mesh = enemyBase.GetComponentInChildren<SkinnedMeshRenderer>();
            mesh.material.mainTexture = PacketManage.Single.GetPacket("jidi").Load("zhujidi_r_texture") as Texture;
            // TODO 设置角度与位置
            enemyBase.transform.position = new Vector3(1330, -38, -20);
            enemyBase.transform.Rotate(new Vector3(0, -90, 0));


            var cluster = enemyBase.AddComponent<ClusterData>();
            cluster.MemberData = enemyjidi;
            cluster.MemberData.MoveSpeed = -1;
            cluster.Diameter = 40;
            cluster.GroupId = 999;
            cluster.X = 1330;
            cluster.Y = -20;
            cluster.Stop();
            ClusterManager.Single.Add(cluster);

            // 创建外层持有类
            var displayOwner = new DisplayOwner(enemyBase, cluster, null, null);
            DisplayerManager.Single.AddElement(enemyjidi.ObjID, displayOwner);
        }
        return result;
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
        //var display = DP_FightPrefabManage.InstantiateAvatar(param);
        //通过对象池创建角色
        var display = DisplayerManager.Single.CreateAvatar(soldier.Name,param);

        var mfa = display.GetComponent<MFAModelRender>();
        mfa.ObjId = soldier.ObjID;

        mfa.Cluster = display.AddComponent<ClusterData>();
        mfa.Cluster.SetDataValue(soldier);


        // 创建外层持有类
        var displayOwner = new DisplayOwner(display, mfa.Cluster, mfa, null);
        DisplayerManager.Single.AddElement(soldier.ObjID, displayOwner);
        // 启动单位状态机
        //randerControl.StartFSM(displayOwner);

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
