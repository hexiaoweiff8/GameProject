using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 消息工厂
/// </summary>
public static class MsgFactory
{
    /// <summary>
    /// 唯一Id起始值
    /// </summary>
    public static int UniqueIdStart
    {
        set { addtionOpUniqueNum = value; }
    }

    /// <summary>
    /// 操作唯一编号
    /// </summary>
    private static int addtionOpUniqueNum = 1024;

    /// <summary>
    /// 操作唯一编号
    /// </summary>
    private static int AddtionOpUniqueNum { get { return addtionOpUniqueNum++; } }

    /// <summary>
    /// 创建数据头消息
    /// </summary>
    /// <param name="userId"></param>
    /// <param name="msgId"></param>
    /// <param name="msgBody"></param>
    /// <returns></returns>
    public static MsgHead GetMsgHead(int userId, int msgId, byte[] msgBody)
    {
        MsgHead result = null;

        result = new MsgHead()
        {
            userId = userId,
            msgId = msgId,
            body = msgBody
        };

        return result;
    }

    /// <summary>
    /// 创建操作消息
    /// </summary>
    /// <param name="opType">操作类型</param>
    /// <param name="opPosX">操作位置x</param>
    /// <param name="opPosY">操作位置y</param>
    /// <param name="opPosZ">操作位置z</param>
    /// <param name="opParams">操作其他参数</param>
    /// <returns></returns>
    public static MsgOptional GetMsgOptional(int opType, float opPosX, float opPosY, float opPosZ, string opParams)
    {
        MsgOptional result = null;

        result = new MsgOptional()
        {
            OpType = opType,
            OpPosX = opPosX,
            OpPosY = opPosY,
            OpPosZ = opPosZ,
            OpParams = opParams,
            OpUniqueNum = AddtionOpUniqueNum
        };

        return result;
    }


    /// <summary>
    /// 创建操作确认消息
    /// </summary>
    /// <param name="opUniqueNum">操作唯一编号</param>
    /// <param name="opSourceUserId">操作来源用户Id</param>
    /// <param name="opParams">操作参数</param>
    /// <returns></returns>
    public static MsgComfirmOperation GetMsgComfirmOperation(int opUniqueNum, int opSourceUserId, string opParams)
    {
        MsgComfirmOperation result = null;

        result = new MsgComfirmOperation()
        {
            OpUniqueNum = opUniqueNum,
            OpSourceUserId = opSourceUserId,
            OpParams = opParams
        };

        return result;
    }

    /// <summary>
    /// 创建战斗请求消息
    /// </summary>
    /// <param name="baseLevel">基地等级</param>
    /// <param name="turretLevel">防御塔等级</param>
    /// <param name="race">种族</param>
    /// <param name="param">其他参数</param>
    /// <returns></returns>
    public static MsgAskBattleRequest GetMsgAskBattleRequest(int baseLevel, int turretLevel, int race, string param)
    {
        MsgAskBattleRequest result = null;

        result = new MsgAskBattleRequest()
        {
            BaseLevel = baseLevel,
            TurretLevel = turretLevel,
            Race = race,
            Params = param
        };

        return result;
    }

    /// <summary>
    /// 创建战斗回复消息
    /// </summary>
    /// <param name="baseLevel">基地等级</param>
    /// <param name="turretLevel">防御塔等级</param>
    /// <param name="race">种族</param>
    /// <param name="enemyBaseLevel">敌方基地等级</param>
    /// <param name="enemyTurretLevel">敌方防御塔等级</param>
    /// <param name="enemyRace">敌方种族</param>
    /// <param name="randomSeed">随机种子</param>
    /// <param name="uniqueIdStart">唯一Id起始值</param>
    /// <param name="param">其他参数</param>
    /// <returns></returns>
    public static MsgAskBattleResponse GetMsgAskBattleResponse(int baseLevel, int turretLevel, int race, int enemyBaseLevel, int enemyTurretLevel, int enemyRace, int randomSeed, int uniqueIdStart, string param)
    {
        MsgAskBattleResponse result = null;

        result = new MsgAskBattleResponse()
        {
            BaseLevel = baseLevel,
            TurretLevel = turretLevel,
            Race = race,
            EnemyBaseLevel = enemyBaseLevel,
            EnemyTurretLevel = enemyTurretLevel,
            EnemyRace = enemyRace,
            RandomSeed = randomSeed,
            UniqueIdStart = uniqueIdStart,
            Params = param
        };

        return result;
    }

    /// <summary>
    /// 战斗开始请求消息
    /// </summary>
    /// <param name="param">其他参数</param>
    /// <returns></returns>
    public static MsgBattleStartRequest GetMsgBattleStartRequest(string param)
    {
        MsgBattleStartRequest result = null;

        result = new MsgBattleStartRequest()
        {
            Params = param
        };

        return result;
    }


    /// <summary>
    /// 战斗开始请求回复消息
    /// </summary>
    /// <param name="param">其他参数</param>
    /// <returns></returns>
    public static MsgBattleStartResponse GetMsgBattleStartResponse(string param)
    {
        MsgBattleStartResponse result = null;

        result = new MsgBattleStartResponse()
        {
            Params = param
        };

        return result;
    }
}