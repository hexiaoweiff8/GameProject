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
            OpParams = opParams
        };

        return result;
    }
}