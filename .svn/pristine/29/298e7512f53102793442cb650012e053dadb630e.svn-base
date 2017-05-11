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
