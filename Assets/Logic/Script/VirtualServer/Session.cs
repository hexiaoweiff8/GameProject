using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QKNodeSDK_CLR
{
    public class Session
    {
        public Session(uint sid,ulong uid)
        {
            m_sid = sid;
            m_uid = uid;
        }

        public uint GetSID()
        {
            return m_sid;
        }

        public ulong GetUID()
        {
            return m_uid;
        }

        uint m_sid;
        ulong m_uid;
    }
}
