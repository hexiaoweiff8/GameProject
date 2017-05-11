using UnityEngine;
using System.Collections;
using Assets.scripts.interfaces;
using System.Collections.Generic;

public class ObjectBase:ILife,IMove,IFight {
    //实体ID 
    protected int _entityId = 0;
    //坐标
    protected Vector3 Position;
    //缩放
    public Vector3 Scale;
    //旋转
    public Vector3 Rotat;

    public ObjectID Id;


    private Vector3 _clickDir;

    public Vector3 ClickDir
    {
        get { return _clickDir; }
        set
        {
            _clickDir = value;
        }
    }
    /// <summary>
    /// 对象的实体ID
    /// </summary>
    public int EntityId;

    /// <summary>
    /// 当前所在区域，如果在该区域为true，不在为false;
    /// </summary>
    public List<bool> InRegions;

    public ObjectBase()
    {
        InRegions = new List<bool>();
        for (int i = 0; i < 15; i++)
        {
            InRegions.Add(false);
        }

    }

    public void ClearEnemyPos()
    {
    }
    public Vector3 GetPos3
    {
        get { return Position; }
        set
        {
            Position = value;
        }
    }

    public Vector3 Pos { get; set; }
    public float YOff { get; set; }
    private Quaternion _rodir;
    public Quaternion RotationDir
    {
        get
        {
            var a = _rodir.eulerAngles;
            a.z = 0;
            return Quaternion.Euler(a);
        }
        set
        {
            _rodir = value;

        }
    }
    /// <summary>
    /// 存储临时方向
    /// </summary>
    public Quaternion PreRotationDir;

    public Vector3 Rotation { get; set; }
    public Transform Tf { get; set; }


    public virtual ObjectID Activate(ObjectID Id)
    {
        throw new global::System.NotImplementedException();
    }

    public virtual bool Distroy(ObjectID Id)
    {
        return true;
    }

    public virtual bool Updata(float duringTime)
    {
        ClearEnemyPos();
        return true;
    }
}
