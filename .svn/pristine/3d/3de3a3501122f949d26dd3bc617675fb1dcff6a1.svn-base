using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX; 
//资源引用管理器
public class ResourceRefManage : SingletonAuto<ResourceRefManage>
{

    public ResourceRefManage()
    {
        AddResidentPack("packets");
        AddResidentPack("pack_script");
        AddResidentPack("core");
        AddResidentPack("rom_share");
    }
  
    public void AddRef(string packName)
    {
        if (m_RefInfo.ContainsKey(packName))
            m_RefInfo[packName]++;
        else
            m_RefInfo.Add(packName, 1);
    }

    public void SubRef(string packName)
    {
        m_RefInfo[packName]--;
        if (m_RefInfo[packName] <= 0)
        {
            m_RefInfo.Remove(packName);
            UnLoadUnusedPack(packName);//卸载资源包 
        }
    }

    //卸载一个资源包，如果资源包处于被引用状态则不被卸载
    void UnLoadUnusedPack(string packName)
    {
        if (m_RefInfo.ContainsKey(packName)) return; 
        if (m_ResidentPacks.Contains(packName)) return;//常驻包不允许删除

        PacketManage.Single.UnLoadPacket(packName);//卸载资源包 
    }

    /// <summary>
    /// 增加一个常驻包
    /// </summary>
    public void AddResidentPack(string packName)
    {
        m_ResidentPacks.Add(packName);
    }

    public void DumpInfo()
    {
        foreach(var curr in m_RefInfo)
        { 
            Debug.Logout(
                    MonoEX.LOG_TYPE.LT_DEBUG,
                   string.Format("包名:{0} 引用数:{1} 是否常驻:{2}", curr.Key, curr.Value, m_ResidentPacks.Contains(curr.Key))
                );
        }
    }

    //引用信息 包名，引用数
    Dictionary<string, int> m_RefInfo = new Dictionary<string, int>();

    HashSet<string> m_ResidentPacks = new HashSet<string>();
}
