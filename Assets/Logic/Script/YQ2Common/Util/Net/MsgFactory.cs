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
}