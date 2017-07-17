using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProtoBuf;


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
    
}