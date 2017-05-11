using UnityEngine;
using System.Collections;
/// <summary>
/// 战斗单元的工厂类 主要提供给ulua逻辑 创建战斗对象
/// </summary>
public class FightUnitFactory {


    public static DisplayOwner CreateUnit(int unitType, CreateActorParam otherParam)
    {
        VOBase vo = new VOBase();
        switch (unitType)
        {
            case (int)ObjectID.ObjectType.MyJiDi:
                vo = null;
                break;
            case (int)ObjectID.ObjectType.EnemyJiDi:
                vo = null;
                break;
            case (int)ObjectID.ObjectType.MySoldier:
                vo = new FightVO();
                vo.ObjID = new ObjectID(ObjectID.ObjectType.MySoldier);
                break;
            case (int)ObjectID.ObjectType.EnemySoldier:
                vo = new FightVO();
                vo.ObjID = new ObjectID(ObjectID.ObjectType.EnemySoldier);
                break;
            case (int)ObjectID.ObjectType.MyTank:
                vo = null;
                break;
            case (int)ObjectID.ObjectType.EnemyTank:
                vo = null;
                break;
            case (int)ObjectID.ObjectType.MyObstacle:
                vo = null;
                break;
            case (int)ObjectID.ObjectType.EnemyObstacle:
                vo = null;
                break;
        }
        return DataManager.Single.Create(vo, otherParam);
    }
}
