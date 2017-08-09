using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class DisplayerManager : MonoEX.Singleton<DisplayerManager>
{
    /// <summary>
    /// 所有我方显示对象
    /// </summary>
    private Dictionary<int, DisplayOwner> _allMyDisPlayDict;
    
    /// <summary>
    /// 所有敌方显示对象
    /// </summary>
    private Dictionary<int, DisplayOwner> _allEnemyDisPlayDict;

    /// <summary>
    /// 显示对象 对象池
    /// </summary>
    private Dictionary<string, Stack<GameObject>> displayPool = new Dictionary<string, Stack<GameObject>>();

    /// <summary>
    /// 我方建筑
    /// </summary>
    private Dictionary<int, DisplayOwner> myBuilding;

    /// <summary>
    /// 敌方建筑
    /// </summary>
    private Dictionary<int, DisplayOwner> enemyBuilding;


    // ---------------------------公有方法-------------------------------

    public DisplayerManager()
    {
        _allMyDisPlayDict = new Dictionary<int, DisplayOwner>();
        _allEnemyDisPlayDict = new Dictionary<int, DisplayOwner>();
        myBuilding = new Dictionary<int, DisplayOwner>();
        enemyBuilding = new Dictionary<int, DisplayOwner>();
    }


    /// <summary>
    /// 获取对立阵营所有角色
    /// </summary>
    public Dictionary<int, DisplayOwner> GetOpposingCamps(ObjectID obj)
    {
        switch (obj.ObjType)
        {
            case ObjectID.ObjectType.MySoldier:
                return _allEnemyDisPlayDict;
            case ObjectID.ObjectType.EnemySoldier:
                return _allMyDisPlayDict;
        }
        return null;
    }

    /// <summary>
    /// 创建单位, 如果对象池内有引用直接使用
    /// </summary>
    /// <param name="soldiername"></param>
    /// <param name="param"></param>
    /// <returns></returns>
    public GameObject CreateAvatar(string soldiername, CreateActorParam param)
    {
        if (displayPool.ContainsKey(soldiername) && displayPool[soldiername].Count > 0)
        {
            var member = displayPool[soldiername].Pop();
            // 清空父级引用
            member.transform.parent = null;
            member.SetActive(true);
            return member;
        }
        return DP_FightPrefabManage.InstantiateAvatar(param);
    }

    /// <summary>
    /// 将对象放入对象池
    /// </summary>
    /// <param name="objID"></param>
    /// <param name="obj"></param>
    public void PushPool(ObjectID objID, DisplayOwner obj)
    {
        var control = obj.GameObj.GetComponent<RanderControl>();
        // 回收未确认下兵的单位时randerControl为null
        if (control != null)
        {
            control.DestoryFSM();
            if (control.bloodBarCom != null)
            {
                control.bloodBarCom.DestorySelf();
            }
            control.gameObject.SetActive(false);
            GameObject.Destroy(control);
        }
        var soldierType = obj.ClusterData.AllData.MemberData.Name;
        // 清理数据
        ClearDisplayer(obj);
        if (!displayPool.ContainsKey(soldierType))
            displayPool.Add(soldierType, new Stack<GameObject>());
        // 设置父级
        obj.GameObj.transform.parent = ParentManager.Instance().GetParent(ParentManager.PoolParent).transform;
        displayPool[soldierType].Push(obj.GameObj);
    }

    /// <summary>
    /// 添加单位
    /// </summary>
    /// <param name="objId">对象ID</param>
    /// <param name="owner">被添加对象</param>
    public void AddElement(ObjectID objId, DisplayOwner owner)
    {
        switch (objId.ObjType)
        {
            case ObjectID.ObjectType.MySoldier:
                _allMyDisPlayDict.Add(objId.ID, owner);
                break;
            case ObjectID.ObjectType.EnemySoldier:
                _allEnemyDisPlayDict.Add(objId.ID, owner);
                break;
            case ObjectID.ObjectType.MyJiDi:
                _allMyDisPlayDict.Add(objId.ID, owner);
                // 将基地放入建筑列表
                myBuilding.Add(objId.ID, owner);
                break;
            case ObjectID.ObjectType.EnemyJiDi:
                _allEnemyDisPlayDict.Add(objId.ID, owner);
                // 将基地放入建筑列表
                enemyBuilding.Add(objId.ID, owner);
                break;
            case  ObjectID.ObjectType.MyTower:
                // 我方防御塔放入我方列表
                _allMyDisPlayDict.Add(objId.ID, owner);
                // 将防御塔放入建筑列表
                myBuilding.Add(objId.ID, owner);
                break;
            case ObjectID.ObjectType.EnemyTower:
                // 敌方防御塔放入敌方列表
                _allEnemyDisPlayDict.Add(objId.ID, owner);
                // 将防御塔放入建筑列表
                enemyBuilding.Add(objId.ID, owner);
                break;
        }
    }

    /// <summary>
    /// 删除单位(对象池)
    /// </summary>
    /// <param name="objId">被删除单位ID</param>
    public void DeleteElement(ObjectID objId)
    {
        switch (objId.ObjType)
        {
            case ObjectID.ObjectType.MySoldier:
                if (_allMyDisPlayDict.ContainsKey(objId.ID))
                {
                    PushPool(objId, _allMyDisPlayDict[objId.ID]);
                    _allMyDisPlayDict.Remove(objId.ID);
                }
                else
                {
                    Debug.LogError("试图从我方士兵列表删除不存在的id------------" + objId.ID);
                }
                break;
            case ObjectID.ObjectType.EnemySoldier:
                if (_allEnemyDisPlayDict.ContainsKey(objId.ID))
                {
                    PushPool(objId, _allEnemyDisPlayDict[objId.ID]);
                    _allEnemyDisPlayDict.Remove(objId.ID);
                }
                else
                {
                    Debug.LogError("试图从敌人士兵列表删除不存在的id------------" + objId.ID);
                }
                break;
            case ObjectID.ObjectType.MyTower:
            case ObjectID.ObjectType.MyJiDi:
            {
                if (_allMyDisPlayDict.ContainsKey(objId.ID))
                {
                    PushPool(objId, _allMyDisPlayDict[objId.ID]);
                    _allMyDisPlayDict.Remove(objId.ID);
                }
                if (myBuilding.ContainsKey(objId.ID))
                {
                    myBuilding.Remove(objId.ID);
                }
            }
                break;

            case ObjectID.ObjectType.EnemyTower:
            case ObjectID.ObjectType.EnemyJiDi:
            {
                if (_allEnemyDisPlayDict.ContainsKey(objId.ID))
                {
                    PushPool(objId, _allEnemyDisPlayDict[objId.ID]);
                    _allEnemyDisPlayDict.Remove(objId.ID);
                }
                if (enemyBuilding.ContainsKey(objId.ID))
                {
                    enemyBuilding.Remove(objId.ID);
                }
            }
                break;
        }
    }

    /// <summary>
    /// 获取单位
    /// </summary>
    /// <param name="objId">被获取单位ID</param>
    /// <returns>被获取单位(如果不存在返回Null</returns>
    public DisplayOwner GetElementById(ObjectID objId)
    {
        if (objId == null)
        {
            return null;
        }
        return GetElementById(objId.ObjType, objId.ID);
    }


    /// <summary>
    /// 获取单位
    /// </summary>
    /// <param name="objType">单位类型</param>
    /// <param name="id">单位唯一Id</param>
    /// <returns>被获取单位(如果不存在返回Null</returns>
    public DisplayOwner GetElementById(ObjectID.ObjectType objType, int id)
    {
        switch (objType)
        {
            // TODO 基地目前从士兵列表中获取
            case ObjectID.ObjectType.MyJiDi:
            case ObjectID.ObjectType.MySoldier:
            case ObjectID.ObjectType.MyTower:
                if (_allMyDisPlayDict.ContainsKey(id))
                {
                    return _allMyDisPlayDict[id];
                }
                break;
            case ObjectID.ObjectType.EnemyJiDi:
            case ObjectID.ObjectType.EnemySoldier:
            case ObjectID.ObjectType.EnemyTower:
                if (_allEnemyDisPlayDict.ContainsKey(id))
                {
                    return _allEnemyDisPlayDict[id];
                }
                break;
        }
        return null;
    }

    /// <summary>
    /// 获取Display
    /// </summary>
    /// <param name="pObj">display对应的pObj</param>
    /// <returns>pObj对应的DisplayOwner</returns>
    public DisplayOwner GetElementByPositionObject(PositionObject pObj)
    {
        DisplayOwner result = null;

        if (pObj != null)
        {
            result = GetElementById(pObj.AllData.MemberData.ObjID);
        }
        return result;
    }

    /// <summary>
    /// 根据PositionObject列表获取对应DisplayOwner列表
    /// </summary>
    /// <param name="pObjList">被获取列表</param>
    /// <returns>返回对应列表, 如果没有对应单位返回null</returns>
    public IList<DisplayOwner> GetElementsByPositionObjectList(IList<PositionObject> pObjList)
    {
        List<DisplayOwner> result = null;

        if (pObjList != null && pObjList.Count > 0)
        {
            result = new List<DisplayOwner>(pObjList.Count);
            foreach (var pObj in pObjList)
            {
                var display = GetElementByPositionObject(pObj);
                if (display != null)
                {
                    result.Add(display);
                }
            }
        }
        return result;
    }

    /// <summary>
    /// 获取建筑列表
    /// </summary>
    /// <param name="objTypeArray">建筑类型</param>
    /// <returns></returns>
    public IList<DisplayOwner> GetBuildingByType(ObjectID.ObjectType[] objTypeArray)
    {
        IList<DisplayOwner> result = null;

        if (objTypeArray != null && objTypeArray.Length > 0)
        {
            result = new List<DisplayOwner>();
            foreach (var objType in objTypeArray)
            {
                foreach (var item in enemyBuilding)
                {
                    if (item.Value.ClusterData.AllData.MemberData.ObjID.ObjType == objType)
                    {
                        result.Add(item.Value);
                    }
                }
                foreach (var item in myBuilding)
                {
                    if (item.Value.ClusterData.AllData.MemberData.ObjID.ObjType == objType)
                    {
                        result.Add(item.Value);
                    }
                }
            }
        }

        return result;
    }

    /// <summary>
    /// 销毁单位
    /// </summary>
    /// <param name="display">被删除单位包装类</param>
    public void DelDisplay(DisplayOwner display)
    {
        display.ClusterData.StopMove();
        // 从本地列表中删除
        DeleteElement(display.ClusterData.AllData.MemberData.ObjID);
    }

    /// <summary>
    /// 销毁单位
    /// </summary>
    /// <param name="objId">被删除单位ObjectId对象</param>
    public void DelDisplay(ObjectID objId)
    {
        DelDisplay(GetElementById(objId));
    }


    /// <summary>
    /// 清空显示单位身上的脚本
    /// </summary>
    /// <param name="display">被清理单位包装类</param>
    private void ClearDisplayer(DisplayOwner display)
    {
        if (display != null)
        {
            ClusterManager.Single.Remove(display.ClusterData);
            display.GameObj.RemoveComponents(typeof(ClusterData));
            display.ClusterData = null;
            display.GameObj.RemoveComponents(typeof(TriggerRunner));
            display.GameObj.RemoveComponents(typeof(RanderControl));
            display.RanderControl = null;
        }
    }

    // ---------------------------私有方法----------------------------------


    /// <summary>
    /// 当对象池里的对象达到一定限度后 彻底销毁
    /// </summary>
    /// <param name="dict"></param>
    /// <param name="objID"></param>
    private void _destoryDisplay(Dictionary<int, DisplayOwner> dict, ObjectID objID)
    {
        ClusterManager.Single.Remove(dict[objID.ID].ClusterData);
        dict[objID.ID].RanderControl.DestoryFSM();
        dict[objID.ID].RanderControl.bloodBarCom.DestorySelf();
        GameObject.Destroy(dict[objID.ID].RanderControl.gameObject);
    }
}
