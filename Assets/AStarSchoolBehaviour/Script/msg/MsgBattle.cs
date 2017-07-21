using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProtoBuf;

/// <summary>
/// 战斗请求消息
/// 消息ID: 11100
/// </summary>
[Serializable, ProtoContract(Name = @"MsgAskBattle")]
public class MsgAskBattleRequest
{

    /// <summary>
    /// 基地登记
    /// </summary>
    [ProtoMember(1, IsRequired = true, Name = @"BaseLevel")]
    public int BaseLevel = 0;

    /// <summary>
    /// 种族
    /// </summary>
    [ProtoMember(2, IsRequired = true, Name = @"Race")]
    public int Race = 0;

    /// <summary>
    /// 其他参数
    /// </summary>
    [ProtoMember(3, IsRequired = false, Name = @"Params")]
    public string Params = "";
}

/// <summary>
/// 战斗请求回复消息
/// 消息ID: 11101
/// </summary>
public class MsgAskBattleResponse
{
    /// <summary>
    /// 基地等级
    /// </summary>
    [ProtoMember(1, IsRequired = true, Name = @"BaseLevel")]
    public int BaseLevel = 1;

    /// <summary>
    /// 种族
    /// </summary>
    [ProtoMember(2, IsRequired = true, Name = @"Race")]
    public int Race = 0;

    /// <summary>
    /// 随机种子
    /// </summary>
    [ProtoMember(3, IsRequired = true, Name = @"RandomSeed")]
    public int RandomSeed = -1;

    /// <summary>
    /// 其他参数
    /// </summary>
    [ProtoMember(4, IsRequired = false, Name = @"Params")]
    public string Params = "";
}

/// <summary>
/// 确认操作消息
/// </summary>
[Serializable, ProtoContract(Name = @"MsgComfirmOperation")]
public class MsgComfirmOperation
{
    /// <summary>
    /// 被确认操作唯一编号
    /// </summary>
    [ProtoMember(1, IsRequired = true, Name = @"OpUniqueNum")]
    public int OpUniqueNum = 0;

    /// <summary>
    /// 操作来源用户Id
    /// </summary>
    [ProtoMember(2, IsRequired = true, Name = @"OpSourceUserId")]
    public int OpSourceUserId = 0;

    /// <summary>
    /// 操作参数
    /// </summary>
    [ProtoMember(3, IsRequired = false, Name = @"OpParams")]
    public string OpParams = null;
}


/// <summary>
/// 操作消息
/// </summary>
[Serializable, ProtoContract(Name = @"MsgOptional")]
public class MsgOptional
{
    /// <summary>
    /// 操作类型
    /// </summary>
    [ProtoMember(1, IsRequired = true, Name = @"OpType")]
    public int OpType = 0;

    /// <summary>
    /// 操作位置
    /// </summary>
    [ProtoMember(2, IsRequired = true, Name = @"OpPosX")]
    public float OpPosX = 0;

    /// <summary>
    /// 操作位置
    /// </summary>
    [ProtoMember(3, IsRequired = true, Name = @"OpPosY")]
    public float OpPosY = 0;

    /// <summary>
    /// 操作位置
    /// </summary>
    [ProtoMember(4, IsRequired = true, Name = @"OpPosZ")]
    public float OpPosZ = 0;

    /// <summary>
    /// 操作参数
    /// </summary>
    [ProtoMember(5, IsRequired = true, Name = @"OpParams")]
    public string OpParams = null;

    /// <summary>
    /// 操作唯一编号
    /// 每条操作消息只对应唯一操作编号
    /// </summary>
    [ProtoMember(6, IsRequired = false, Name = @"OpUniqueNum")]
    public int OpUniqueNum = 0;

    /// <summary>
    /// 其他参数
    /// </summary>
    [ProtoMember(7, IsRequired = false, Name = @"Params")]
    public string Params = "";

}

/// <summary>
/// 随机种子消息
/// </summary>
[Serializable, ProtoContract(Name = @"MsgRandomSeed")]
public class MsgRandomSeedRequest
{
    /// <summary>
    /// 随机种子
    /// </summary>
    [ProtoMember(1, IsRequired = true, Name = @"Params")]
    public int RandomSeed = -1;


    /// <summary>
    /// 其他参数
    /// </summary>
    [ProtoMember(2, IsRequired = true, Name = @"Params")]
    public string Params = "";
}