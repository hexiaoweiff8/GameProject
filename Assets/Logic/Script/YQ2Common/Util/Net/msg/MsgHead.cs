using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProtoBuf;

/// <summary>
/// 数据消息头
/// </summary>
[Serializable, ProtoContract(Name = @"MsgHead")]
public class MsgHead
{
    /// <summary>
    /// 数据Id
    /// </summary>
    [ProtoMember(1, IsRequired = true, Name = @"ID")]
    public int ID = 0;

    /// <summary>
    /// 消息ID
    /// </summary>
    [ProtoMember(2, IsRequired = true, Name = @"msgId")]
    public int msgId = 0;

    /// <summary>
    /// 用户ID
    /// </summary>
    [ProtoMember(3, IsRequired = true, Name = @"userId")]
    public int userId = 0;

    /// <summary>
    /// 版本
    /// </summary>
    [ProtoMember(4, IsRequired = true, Name = @"version")]
    public string version = null;

    /// <summary>
    /// 错误号
    /// </summary>
    [ProtoMember(5, IsRequired = true, Name = @"errno")]
    public int errno = 0;

    /// <summary>
    /// 
    /// </summary>
    [ProtoMember(6, IsRequired = true, Name = @"ext")]
    public int ext = 0;

    /// <summary>
    /// 数据体
    /// </summary>
    [ProtoMember(7, IsRequired = false, Name = @"body")]
    public byte[] body = null;

    /// <summary>
    /// 身份号
    /// </summary>
    [ProtoMember(8, IsRequired = false, Name = @"roleId")]
    public int roleId = 0;
}