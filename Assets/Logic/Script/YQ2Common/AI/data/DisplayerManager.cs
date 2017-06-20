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

    public GameObject CreateAvatar(string soldiername, CreateActorParam param)
    {
        if (displayPool.ContainsKey(soldiername) && displayPool[soldiername].Count > 0)
        {
            return displayPool[soldiername].Pop();
        }
        return DP_FightPrefabManage.InstantiateAvatar(param);
    }

    public void PushPool(ObjectID objID, DisplayOwner obj)
    {
        var control = obj.GameObj.GetComponent<RanderControl>();
        // 回收未确认下兵的单位时randerControl为null
        if (control != null)
        {
            control.DestoryFSM();
            control.bloodBarCom.DestorySelf();
            control.gameObject.SetActive(false);
            GameObject.Destroy(control);
        }
        var soldierType = obj.ClusterData.AllData.MemberData.Name;
        ClusterManager.Single.Remove(obj.ClusterData);
        if (!displayPool.ContainsKey(soldierType))
            displayPool.Add(soldierType, new Stack<GameObject>());
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
        }
    }

    /// <summary>
    /// 获取单位
    /// </summary>
    /// <param name="objId">被获取单位ID</param>
    /// <returns>被获取单位(如果不存在返回Null</returns>
    public DisplayOwner GetElementById(ObjectID objId)
    {
        switch (objId.ObjType)
        {
            // TODO 基地目前从士兵列表中获取
            case ObjectID.ObjectType.MyJiDi:
            case ObjectID.ObjectType.MySoldier:
                if (_allMyDisPlayDict.ContainsKey(objId.ID))
                {
                    return _allMyDisPlayDict[objId.ID];
                }
                break;
            case ObjectID.ObjectType.EnemyJiDi:
            case ObjectID.ObjectType.EnemySoldier:
                if (_allEnemyDisPlayDict.ContainsKey(objId.ID))
                {
                    return _allEnemyDisPlayDict[objId.ID];
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


    //public List<DisplayOwner> GetElementsByScope(ICollisionGraphics graphics)
    //{
    //    List<DisplayOwner> result = null;
    //    var positionObjectInScope = ClusterManager.Single.GetPositionObjectListByGraphics(graphics);
    //    if (positionObjectInScope != null && positionObjectInScope.Count != 0)
    //    {
    //        result = new List<DisplayOwner>();

    //    }

    //    return result;
    //}


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
