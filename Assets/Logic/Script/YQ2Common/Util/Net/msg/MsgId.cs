using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 消息ID
/// </summary>
public enum MsgId
{
    MsgOptional = 11001,            // 操作消息
    MsgComfirmOperation = 11002,    // 操作确认消息

    MsgRandomSeedRequest = 11004,   // 请求随机种子
    MsgRandomSeedResponse = 11003,  // 反馈随机种子消息
    MsgBattleStartRequest = 11004,  // 战斗开始请求
    MsgBattleStartResponse = 11005, // 战斗开始回复
    MsgAskBattleRequest = 11100,    // 请求战斗消息
    MsgAskBattleResponse = 11101,   // 回复请求战斗消息


    MsgString = 11999               // 字符串消息
}