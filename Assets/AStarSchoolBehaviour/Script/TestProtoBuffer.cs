using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProtoBuf;


//[global::System.Serializable, global::ProtoBuf.ProtoContract(Name = @"CMsgTeamDuangRequest")]
[ProtoContract]
public class TestProtoBuffer
{

    [ProtoMember(1)]
    public int TestProperty = 0;

}