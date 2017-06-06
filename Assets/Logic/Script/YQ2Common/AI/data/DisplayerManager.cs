using UnityEngine;
using System.Collections;
using System.Collections.Generic;

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
    private Dictionary<string, Stack<GameObject>> DisplayPool = new Dictionary<string, Stack<GameObject>>();

    public DisplayerManager()
    {
        _allMyDisPlayDict = new Dictionary<int, DisplayOwner>();
        _allEnemyDisPlayDict = new Dictionary<int, DisplayOwner>();
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
        if (DisplayPool.ContainsKey(soldiername) && DisplayPool[soldiername].Count > 0)
        {
            return DisplayPool[soldiername].Pop();
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
        var soldierType = obj.ClusterData.MemberData.Name;
        ClusterManager.Single.Remove(obj.ClusterData);
        if (!DisplayPool.ContainsKey(soldierType))
            DisplayPool.Add(soldierType, new Stack<GameObject>());
        DisplayPool[soldierType].Push(obj.GameObj);
    }
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
                break;
            case ObjectID.ObjectType.EnemyJiDi:
                _allEnemyDisPlayDict.Add(objId.ID, owner);
                break;
        }
    }

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

    public DisplayOwner GetElementById(ObjectID objId)
    {
        switch (objId.ObjType)
        {
            case ObjectID.ObjectType.MySoldier:
                if (_allMyDisPlayDict.ContainsKey(objId.ID))
                {
                    return _allMyDisPlayDict[objId.ID];
                }
                break;
            case ObjectID.ObjectType.EnemySoldier:
                if (_allEnemyDisPlayDict.ContainsKey(objId.ID))
                {
                    return _allEnemyDisPlayDict[objId.ID];
                }
                break;
        }
        return null;
    }
}
