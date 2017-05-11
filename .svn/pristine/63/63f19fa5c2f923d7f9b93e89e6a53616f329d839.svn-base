using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using UnityEngine;
using MonoEX;
using System.Xml;
using System.IO;
public class HotUpdate : MonoBehaviour
{
    public string url;
    public delegate void onProgress(float progress);
    public delegate void onComplate();
    public delegate void onNetError(ErrorNo errorNo, string errorMsg);
    public delegate void onUpgradeApp();
    

   
    /// <summary>
    /// 出现网络错误后，用户层可调用该接口重试
    /// </summary>
    public void ReTry()
    {
        if (m_CurrContext == null || m_CurrContext.m_State != STATE.netError) return;
        m_CurrContext.m_State = STATE.doing;
    } 

    /// <summary>
    /// 开始热更
    /// </summary>
    public void Go(
        onProgress OnProgress,
        onComplate OnComplate,
        onUpgradeApp OnUpgradeApp, 
        onNetError OnNetError
        )
    {
        if(m_CurrContext!=null) return;//正在工作时不允许启动第二个工作协程

        m_CurrContext = new context();

        m_CurrContext.m_State = STATE.doing;
        m_CurrContext.m_OnProgress = OnProgress;
        m_CurrContext.m_OnComplate = OnComplate;
        m_CurrContext.m_OnNetError = OnNetError;
        m_CurrContext.m_OnUpgradeApp = OnUpgradeApp;
        StartCoroutine(coGo(m_CurrContext));
    }

    public void Stop()
    {
        if (m_CurrContext == null || m_CurrContext.m_State == STATE.stopd) return;
        m_CurrContext.m_State = STATE.stopd;
    }

    /// <summary>
    /// 热更协程
    /// </summary>
    IEnumerator coGo(context currContext)
    {
        using (
            SafeRecall_0 safeRecall = new SafeRecall_0(() =>  m_CurrContext = null )
            )
        {

            //装载内部版本文件包
            {
                List<string> packs = new List<string>();
                packs.Add("rom_version");

                PacketLoader loader = new PacketLoader();
                loader.Start(PackType.Res, packs, null);

                //等待资源装载完成
                while (loader.Result == PacketLoader.ResultEnum.Loading)
                    yield return null;
            }



            //比对包外应用版本号
            {
                AppVersionComparison();
                NotifyProgress(currContext, 0.01f);
                yield return null;
            }


            //获取远程资源包主版本  
            MainVersionContent remote_main_pack_version = null;
            {
                IEnumerator coit = coPackMainVersionComparison(
                    currContext,
                    (vf) => remote_main_pack_version = vf
                    );
                while (coit.MoveNext()) yield return null;
            }
            if (currContext.m_State == STATE.stopd) yield break;//已经终止

            NotifyProgress(currContext, 0.02f);
            yield return null;


            string runtimePlatform = RuntimePlatformStr();

            //主资源版本信息
            string exmain_pack_path = FileSystem.persistentDataPath + "/pack_main_version.xml";
            {
                MainVersionContent local_main_pack_version = MainVersionContent.FromFile(exmain_pack_path);//从外部文件夹获取资源主版本 
                if (local_main_pack_version == null) //从外部文件读取失败，则从资源包读取
                {
                    //string path = string.Format("{0}/pack_main_version", runtimePlatform);
                    //TextAsset versionAsset = Resources.Load(path) as TextAsset;
                    //string xmlstr = FileSystem.byte2string(versionAsset.bytes);

                    string xmlstr = PacketManage.Single.GetPacket("rom_version").LoadString("pack_main_version");

                    local_main_pack_version = MainVersionContent.FromXmlDocument(xmlstr);

                    //将版本信息写入外部文件夹
                    local_main_pack_version.OutFile(exmain_pack_path);
                }


                //检查应用标识和平台标识是否一致
                bool IdentifierError;
                do
                {
                    IdentifierError = false;
                    if (
                        local_main_pack_version.Identifier != remote_main_pack_version.Identifier ||
                        local_main_pack_version.Platform != remote_main_pack_version.Platform
                        )
                    {
                        IdentifierError = true;
                        currContext.m_State = STATE.netError;
                        if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.RemoteMainVersionFmtError, "远程版本文件标识符错误");
                        while (true)
                        {
                            if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                yield break;
                            else if (currContext.m_State == STATE.doing)//用户选择重试
                                break;
                            else
                            {
                                yield return null;
                                if (currContext.m_State == STATE.stopd) yield break;
                            }
                        }
                    }
                } while (IdentifierError);

                //检查大版本更新
                if (local_main_pack_version.AppVersion != remote_main_pack_version.AppVersion)
                {
                    //应用软件升级
                    if (currContext.m_OnUpgradeApp != null) currContext.m_OnUpgradeApp();

                    yield break;
                }

                //比对主版本号
                if (int.Parse(local_main_pack_version.PackVersion) >= int.Parse(remote_main_pack_version.PackVersion))
                {
                    NotifyProgress(currContext, 1f);
                    if (currContext.m_OnComplate != null) currContext.m_OnComplate();

                    yield break; //本地资源主版本号>=远程资源主版本号 表示无需更新资源
                }
            }
            NotifyProgress(currContext, 0.03f);
            yield return null;

            Dictionary<string, int> remote_res_version = new Dictionary<string, int>();//远程资源版本信息
            Dictionary<string, int> remote_script_version = new Dictionary<string, int>();//远程脚本版本信息
            Dictionary<string, int> local_res_version = new Dictionary<string, int>();//本地资源版本信息
            Dictionary<string, int> local_script_version = new Dictionary<string, int>();//本地远程脚本版本信息

            //获取远程版本比对信息
            string remote_Identifier = "";
            string remote_Platform = "";
            {
                XmlDocument remote_version_doc = null;
                do
                {
                    string version_url = url + "/pack_version.zip";//版本文件url

                    WWW www = new WWW(version_url);
                    yield return www;

                    if (www.error == null)
                    {
                        //解压缩版本比对文件
                        byte[] xmlbytes = MonoEX.LZMA.Decompress(www.bytes, 0);
                        string xmlstr = FileSystem.byte2string(xmlbytes);
                        try
                        {
                            remote_version_doc = new XmlDocument();
                            remote_version_doc.LoadXml(xmlstr);
                            XmlElement xmlNode = remote_version_doc.SelectSingleNode("xml") as XmlElement;
                            remote_Identifier = xmlNode.GetAttribute("Identifier");
                            remote_Platform = xmlNode.GetAttribute("Platform");
                            {
                                XmlElement resNode = remote_version_doc.SelectSingleNode("xml/pack_res") as XmlElement;
                                foreach (XmlNode aNode in resNode.SelectNodes("a"))
                                {
                                    XmlElement aElement = aNode as XmlElement;
                                    string n = aElement.GetAttribute("n");
                                    int v = int.Parse(aElement.GetAttribute("v"));
                                    remote_res_version.Add(n, v);
                                }
                            }

                            {
                                XmlElement resNode = remote_version_doc.SelectSingleNode("xml/pack_script") as XmlElement;
                                foreach (XmlNode aNode in resNode.SelectNodes("a"))
                                {
                                    XmlElement aElement = aNode as XmlElement;
                                    string n = aElement.GetAttribute("n");
                                    int v = int.Parse(aElement.GetAttribute("v"));
                                    remote_script_version.Add(n, v);
                                }
                            }
                        }
                        catch (Exception)
                        {
                            remote_version_doc = null;
                        }

                        if (remote_version_doc == null)
                        {
                            currContext.m_State = STATE.netError;
                            if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.RemoteVersionFmtError, "远程版本信息文件格式有误");
                            while (true)
                            {
                                if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                    yield break;
                                else if (currContext.m_State == STATE.doing)//用户选择重试
                                    break;
                                else
                                {
                                    yield return null;
                                    if (currContext.m_State == STATE.stopd) yield break;
                                }
                            }
                        }
                    }
                    else
                    {
                        currContext.m_State = STATE.netError;
                        if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.GetRemoteVersionFailed, "获取" + version_url + "失败");
                        while (true)
                        {
                            if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                yield break;
                            else if (currContext.m_State == STATE.doing)//用户选择重试
                                break;
                            else
                            {
                                yield return null;

                                if (currContext.m_State == STATE.stopd) yield break;
                            }
                        }
                    }
                } while (remote_version_doc == null);
            }

            NotifyProgress(currContext, 0.04f);
            yield return null;

            //获取本地包内版本信息文件
            {
                //string path = string.Format("{0}/pack_version", runtimePlatform);
                //TextAsset versionAsset = Resources.Load(path) as TextAsset;
                //string xmlstr = FileSystem.byte2string(versionAsset.bytes);

                var xmlstr =  PacketManage.Single.GetPacket("rom_version").LoadString("pack_version");

                XmlDocument local_version_doc = new XmlDocument();
                local_version_doc.LoadXml(xmlstr);

                //检查应用标识和平台标识是否一致
                bool IdentifierError;
                do
                {
                    IdentifierError = false;
                    XmlElement xmlNode = local_version_doc.SelectSingleNode("xml") as XmlElement;
                    if (
                        remote_Identifier != xmlNode.GetAttribute("Identifier") ||
                        remote_Platform != xmlNode.GetAttribute("Platform")
                        )
                    {
                        IdentifierError = true;
                        currContext.m_State = STATE.netError;
                        if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.RemoteVersionFmtError, "远程版本文件标识符错误");
                        while (true)
                        {
                            if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                yield break;
                            else if (currContext.m_State == STATE.doing)//用户选择重试
                                break;
                            else
                            {
                                yield return null;
                                if (currContext.m_State == STATE.stopd) yield break;
                            }
                        }
                    }

                } while (IdentifierError);

                {
                    XmlElement resNode = local_version_doc.SelectSingleNode("xml/pack_res") as XmlElement;
                    foreach (XmlNode aNode in resNode.SelectNodes("a"))
                    {
                        XmlElement aElement = aNode as XmlElement;
                        string n = aElement.GetAttribute("n");
                        int v = int.Parse(aElement.GetAttribute("v"));
                        local_res_version.Add(n, v);
                    }
                }

                {
                    XmlElement resNode = local_version_doc.SelectSingleNode("xml/pack_script") as XmlElement;
                    foreach (XmlNode aNode in resNode.SelectNodes("a"))
                    {
                        XmlElement aElement = aNode as XmlElement;
                        string n = aElement.GetAttribute("n");
                        int v = int.Parse(aElement.GetAttribute("v"));
                        local_script_version.Add(n, v);
                    }
                }
            }


            NotifyProgress(currContext, 0.05f);
            yield return null;

            List<string> NeedDownloadRes = BuildNeedDownload(remote_res_version, local_res_version, "pack_res");
            List<string> NeedDownloadScript = BuildNeedDownload(remote_script_version, local_script_version, "pack_script");


            NotifyProgress(currContext, 0.06f);
            yield return null;

            float start_p = 0.06f;
            int pack_count = NeedDownloadRes.Count + NeedDownloadScript.Count;
            int currindex = 0;

            //更新资源
            foreach (string name in NeedDownloadRes)
            {
                bool isok = false;
                int reUpdate = 0;
                do
                {
                    string pack_url = string.Format("{0}/pack_res/{1}.zip", url, name);
                    //UnityEngine.Debug.Log("热更资源" + pack_url + "路径" + name);
                    WWW www = new WWW(pack_url);
                    yield return www;

                    if (www.error == null)
                    {
                        //byte[] filebytes = MonoEX.LZMA.Decompress(www.bytes, 0);
                        byte[] filebytes = www.bytes;

                        string pack_file = FileSystem.MakeExternalPackPath("pack_res", name);
                        string pack_file_version = FileSystem.MakeExternalPackPath("pack_res", name + ".xml");

                        //判定是否可以读取信息 读取信息失败则重新下载一次
                        if (reUpdate <= 1)
                        {
                            int fileleng = filebytes.Length - 20;
                            byte[] tail = new byte[20];
                            Buffer.BlockCopy(filebytes, fileleng, tail, 0, 20);

                            string tailstr = Encoding.Default.GetString(tail);
                            string[] tailInfo = tailstr.Split('#');

                            //判断文件完整性
                            int filel = Int32.Parse(tailInfo[2]);
                            string farversion = remote_res_version[name].ToString();
                            //判断当前版本信息与自身携带的信息
                            if (tailInfo.Length != 3 || tailInfo[0] != farversion || fileleng < filel)
                            {
                                if (reUpdate < 1)
                                {
                                    //失败 重新下载一次
                                    reUpdate++;
                                    //UnityEngine.Debug.Log("失败一次 重新下载 版本号对比：" + tailInfo[0] + "-----" + farversion);
                                    continue;
                                }
                                else
                                {
                                    //失败过一次则直接解压
                                    //UnityEngine.Debug.Log("失败第二次 直接解压 文件长度对比：" + fileleng + "-----" + filel);
                                    FileStream fren = File.OpenWrite(pack_file);
                                    fren.Write(filebytes, 0, filebytes.Length);
                                    fren.Close();
                                }
                            }
                            else
                            {
                                using (FileStream fren = new FileStream(pack_file, FileMode.Create))
                                {
                                    fren.Write(filebytes, 0, fileleng);
                                    fren.Close();
                                }
                                //保存版本信息
                                //UnityEngine.Debug.Log("更新成功");
                                VersionContent version = new VersionContent(farversion);
                                version.OutFile(pack_file_version);
                            }
                        }
                        else
                        {
                            //UnityEngine.Debug.Log("更新成功 版本失败");
                            using (FileStream fren = File.OpenWrite(pack_file))
                            {
                                fren.Write(filebytes, 0, filebytes.Length);
                                fren.Close();
                            }
                        }

                        reUpdate = 0;

                        isok = true;
                        currindex++;
                        NotifyProgress(currContext, start_p + (1f - start_p) * ((float)currindex / (float)pack_count));
                    }
                    else
                    {
                        currContext.m_State = STATE.netError;
                        if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.GetRemotePackFailed, "获取" + pack_url + "失败");
                        while (true)
                        {
                            if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                yield break;
                            else if (currContext.m_State == STATE.doing)//用户选择重试
                                break;
                            else
                            {
                                yield return null;
                                if (currContext.m_State == STATE.stopd) yield break;
                            }
                        }
                    }
                } while (!isok);
            }

            //更新脚本
            foreach (string name in NeedDownloadScript)
            {
                bool isok = false;
                do
                {
                    string pack_url = string.Format("{0}/pack_script/{1}.zip", url, name);
                    WWW www = new WWW(pack_url);
                    yield return www;

                    if (www.error == null)
                    {
                        byte[] filebytes = MonoEX.LZMA.Decompress(www.bytes, 0);
                        string pack_file = FileSystem.MakeExternalPackPath("pack_script", name);
                        using (FileStream fs = File.OpenWrite(pack_file))
                        {
                            fs.Write(filebytes, 0, filebytes.Length);
                            fs.Close();
                        }

                        //保存版本信息
                        string pack_file_version = FileSystem.MakeExternalPackPath("pack_script", name + ".xml");
                        VersionContent version = new VersionContent(remote_script_version[name].ToString());
                        version.OutFile(pack_file_version);

                        isok = true;
                        currindex++;
                        NotifyProgress(currContext, start_p + (1f - start_p) * ((float)currindex / (float)pack_count));
                    }
                    else
                    {
                        currContext.m_State = STATE.netError;
                        if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.GetRemotePackFailed, "获取" + pack_url + "失败");
                        while (true)
                        {
                            if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                yield break;
                            else if (currContext.m_State == STATE.doing)//用户选择重试
                                break;
                            else
                            {
                                yield return null;
                                if (currContext.m_State == STATE.stopd) yield break;
                            }
                        }
                    }
                } while (!isok);
            }

            remote_main_pack_version.OutFile(exmain_pack_path);//更新完成后改写主资源版本信息

            DoComplate(currContext);
        }
    }


    void DoComplate(context currContext)
    {
        NotifyProgress(currContext, 1f);
        if (currContext.m_OnComplate != null) currContext.m_OnComplate();

        //启动一个协程，延迟一段时间卸载资源包
        StartCoroutine(UnLoadRomUpd());
    }

    IEnumerator UnLoadRomUpd()
    {
        yield return new WaitForSeconds(1);//等待1秒

        //卸载更新所需的资源包
        PacketManage.Single.UnLoadPacket("rom_upd");
    }

    /// <summary>
    /// 包主版本号比对
    /// </summary>
    /// <returns></returns>
    IEnumerator coPackMainVersionComparison(context currContext, Action<MainVersionContent> recall)
    {

        using (SafeRecall_1<MainVersionContent> SafeRecall = new SafeRecall_1<MainVersionContent>(recall))
        {
            MainVersionContent remote_version = null;
            do
            {
                string version_url = url + "/pack_main_version.xml";//包主版本文件url

                WWW www = new WWW(version_url);
                while(!www.isDone&&www.error==null) yield return null;

                if (www.error == null)
                {
                    string xmlstr = FileSystem.byte2string(www.bytes);
                    try
                    {
                        remote_version = MainVersionContent.FromXmlDocument(xmlstr);
                        
                    }
                    catch (Exception)
                    {
                        remote_version = null;
                    }

                    if (remote_version == null)
                    {
                        currContext.m_State = STATE.netError;
                        if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.RemoteMainVersionFmtError, "远程版本信息文件格式有误");
                        while (true)
                        {
                            if (currContext.m_State == STATE.stopd)//用户选择停止工作
                                yield break;
                            else if (currContext.m_State == STATE.doing)//用户选择重试
                                break;
                            else
                            {
                                yield return null;
                                if (currContext.m_State == STATE.stopd) yield break;
                            }
                        }
                    }
                }
                else
                {
                    currContext.m_State = STATE.netError;
                    if (currContext.m_OnNetError != null) currContext.m_OnNetError(ErrorNo.GetRemoteMainVersionFailed, "获取" + version_url + "失败");
                    while (true)
                    {
                        if (currContext.m_State == STATE.stopd)//用户选择停止工作
                            yield break;
                        else if (currContext.m_State == STATE.doing)//用户选择重试
                            break;
                        else
                        {
                            yield return null;

                            if (currContext.m_State == STATE.stopd) yield break;
                        }
                    }
                }
            } while (remote_version == null);

            SafeRecall.Value = remote_version;
        }
         
    } 
        
    /// <summary>
    /// 应用版本比对，包内版本和包外记录的版本之间对比
    /// </summary>
    void AppVersionComparison()
    {
        bool needCreateAppVersion = true;
        string appVersionPath = FileSystem.persistentDataPath + "/lastclean_app_version.";

        try
        {
            if (FileSystem.IsFileExists(appVersionPath))
            {
                string exappVersion = LoadVersionXml(FileSystem.byte2string(FileSystem.ReadFile(appVersionPath)));
                if (exappVersion == Application.version) needCreateAppVersion = false;
            }
        }
        catch (Exception) { }

        if (needCreateAppVersion)//首次更新或应用程序已升级
        {
            //删除所有外部包和外部版本信息
            {
                DirectoryInfo dirInfo = new DirectoryInfo(FileSystem.persistentDataPath + "/pack_res");
                if (dirInfo.Exists)
                {
                    FileInfo[] files = dirInfo.GetFiles();
                    foreach (FileInfo curr in files)
                    {
                        if (curr.Extension == "" || curr.Extension == ".manifest"|| curr.Extension == ".xml")
                            curr.Delete();
                    }
                }
                else
                    dirInfo.Create();
            }

            {
                DirectoryInfo dirInfo = new DirectoryInfo(FileSystem.persistentDataPath + "/pack_script");
                if (dirInfo.Exists)
                {
                    FileInfo[] files = dirInfo.GetFiles();
                    foreach (FileInfo curr in files)
                    {
                        if (curr.Extension == "" || curr.Extension == ".manifest"|| curr.Extension == ".xml")
                            curr.Delete();
                    }
                }
                else
                    dirInfo.Create();
            }

            //删除主资源版本文件
            {
                string mainVersionPath = FileSystem.persistentDataPath + "/pack_main_version.xml";
                FileInfo mainVersionInfo = new FileInfo(mainVersionPath);
                if (mainVersionInfo.Exists) mainVersionInfo.Delete();
            }


            //创建版本文件 
            VersionContent version = new VersionContent(Application.version);
            version.OutFile(appVersionPath); 
        }
        

        {
            {
                DirectoryInfo dirInfo = new DirectoryInfo(FileSystem.persistentDataPath + "/pack_res");
                if (!dirInfo.Exists) dirInfo.Create();
            }

            {
                DirectoryInfo dirInfo = new DirectoryInfo(FileSystem.persistentDataPath + "/pack_script");
                if (!dirInfo.Exists) dirInfo.Create();
            }
        }
    }

    //统计需要更新的文件
    List<string> BuildNeedDownload(Dictionary<string, int> remote_version, Dictionary<string, int> local_version, string packPath)
    {
        List<string> NeedDownload = new List<string>();
        foreach (KeyValuePair<string, int> remoteCurr in remote_version)
        {
            string name = remoteCurr.Key;

            if (name.Length > 4 && name.Substring(0, 4) == "rom_") continue;//这类文件是绝对不允许热更的

            int version = remoteCurr.Value;
            bool needDownload = false;
            if (!local_version.ContainsKey(name))//可能是新增的文件
                needDownload = true;
            else
            {
                if (version > local_version[name])//可能是变更过的文件
                    needDownload = true;
            }

            if (needDownload) //从外部文件夹读取版本信息，进一步判断
            {
                string versionPath = FileSystem.MakeExternalPackPath(packPath, string.Format("{0}.xml", name));
                if (FileSystem.IsFileExists(versionPath))
                {
                    try
                    {
                        string strVersion = LoadVersionXml(FileSystem.byte2string(FileSystem.ReadFile(versionPath)));
                        if (int.Parse(strVersion) >= version) needDownload = false;//版本号是最新的，无需更新
                    }
                    catch (Exception) { }
                }
            }

            if (needDownload) //加入到更新队列 
                NeedDownload.Add(name);
        }
        return NeedDownload;
    }

    string LoadVersionXml(string xmlContent)
    {
        try
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xmlContent);
            XmlElement versionNode = doc.SelectSingleNode("xml/version") as XmlElement; 
            return versionNode.GetAttribute("v");
        }catch(Exception)
        {
            return null;
        }
    }


    string RuntimePlatformStr()
    {
        switch(Application.platform)
        {
            case  RuntimePlatform.WindowsEditor:
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.WindowsWebPlayer:
                return "win64";
            case RuntimePlatform.IPhonePlayer:
            case RuntimePlatform.OSXEditor:
            case RuntimePlatform.OSXPlayer:
            case RuntimePlatform.OSXWebPlayer:
            case RuntimePlatform.OSXDashboardPlayer:
               return "ios";
            default:
                return "android";
        };
         
    }


    void NotifyProgress(context coContext, float progress)
    {
        if (coContext.m_OnProgress != null) coContext.m_OnProgress(progress);

    }

    enum STATE
    {
        stopd,//已停止
        doing,//正在工作
        netError,//网络错误
    };

    public enum ErrorNo
    {
        GetRemoteMainVersionFailed,//获取远程主版本信息失败
        RemoteMainVersionFmtError,//远程主版本文件格式错误
        GetRemoteVersionFailed,//获取远程版本信息失败
        RemoteVersionFmtError,//远程版本文件格式错误
        GetRemotePackFailed,//获取远程包信息失败
    }

    class context
    {
        public STATE m_State = STATE.stopd;
        public HotUpdate.onProgress m_OnProgress;
        public HotUpdate.onComplate m_OnComplate;
        public HotUpdate.onNetError m_OnNetError;
        public HotUpdate.onUpgradeApp m_OnUpgradeApp;
    }

    context m_CurrContext = null;
}

class SafeRecall_1<T>:IDisposable  where T:class
{
    public SafeRecall_1(Action<T> recall)
    {
        m_recall = recall;
    }

    public void Dispose()
    {
        m_recall(m_v);
    }

    public T Value {
        set { m_v = value; }
        get { return m_v; }
    }

    T m_v = null;
    Action<T> m_recall;
}


class SafeRecall_0 : IDisposable 
{
    public SafeRecall_0(Action recall)
    {
        m_recall = recall;
    }

    public void Dispose()
    {
        m_recall();
    }
     
    Action m_recall;
}