using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 using System.IO;
using System.Xml;

public class VersionContent
{
    public VersionContent(string version)
    {
        m_version = version;
    }
     

    public static VersionContent FromXmlDocument(string xml)
    {
        try
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);
            return FromXmlDocument(doc);
        }
        catch (Exception)
        {
            return null;
        }
    }

    public static VersionContent FromXmlDocument(XmlDocument doc)
    {
        XmlElement xmlEl = doc.SelectSingleNode("xml") as XmlElement;
       
        XmlElement versionEl = doc.SelectSingleNode("xml/version") as XmlElement;
        string version = versionEl.GetAttribute("v");

        return new VersionContent(version);
    }

    public static VersionContent FromFile(string filePath)
    {
        try
        {
            if (!FileSystem.IsFileExists(filePath)) return null;

            XmlDocument doc = new XmlDocument();
            doc.Load(filePath);
            return FromXmlDocument(doc); 
        }catch(Exception)
        {
            return null;
        }
    }

    public void OutFile(string filePath )
    {
        FileInfo finfo = new FileInfo(filePath);
        using (FileStream fs = finfo.Create())
        {
            string content  = string.Format("<xml>  <version v=\"{0}\" />  </xml>", m_version);
               

            byte[] bytes = Encoding.UTF8.GetBytes(content);
            fs.Write(bytes, 0, bytes.Length);
            fs.Close();
        }
    }

    public string Version {
        get { return m_version; }
        set { m_version = value; }
    }
     
    string m_version = null;
} 



public class MainVersionContent
{ 
    public MainVersionContent(string appVersion,string packVersion, string identifier, string platform)
    {
        m_packVersion = packVersion;
        m_identifier = identifier;
        m_platform = platform;
        m_appVersion = appVersion;
    }

    public static MainVersionContent FromXmlDocument(string xml)
    {
        try
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);
            return FromXmlDocument(doc);
        }
        catch (Exception)
        {
            return null;
        }
    }

    public static MainVersionContent FromXmlDocument(XmlDocument doc)
    {
        try
        {
            XmlElement xmlEl = doc.SelectSingleNode("xml") as XmlElement;
            string identifier = xmlEl.GetAttribute("Identifier");
            string platform = xmlEl.GetAttribute("Platform");

            XmlElement appVerEl = doc.SelectSingleNode("xml/AppVer") as XmlElement;
            string app_ver = appVerEl.GetAttribute("v");

            XmlElement packVerEl = doc.SelectSingleNode("xml/PakVer") as XmlElement;
            string pack_ver = packVerEl.GetAttribute("v");

            return new MainVersionContent(app_ver,pack_ver, identifier, platform); 
        }catch(Exception)
        {
            return null;
        }
    }

    public static MainVersionContent FromFile(string filePath)
    {
        try
        {
            if (!FileSystem.IsFileExists(filePath)) return null;

            XmlDocument doc = new XmlDocument();
            doc.Load(filePath);
            return FromXmlDocument(doc); 
        }catch(Exception)
        {
            return null;
        }
    }

    public void OutFile(string filePath )
    {
        FileInfo finfo = new FileInfo(filePath);
        using (FileStream fs = finfo.Create())
        {
            string content  = string.Format("<xml Identifier=\"{0}\" Platform=\"{1}\" >  <AppVer v=\"{2}\" />   <PakVer v=\"{3}\" /> </xml>", m_identifier, m_platform,m_appVersion,m_packVersion);
             
            byte[] bytes = Encoding.UTF8.GetBytes(content);
            fs.Write(bytes, 0, bytes.Length);
            fs.Close();
        }
    }

    public string AppVersion {
        get { return m_appVersion; }
        set { m_appVersion = value; }
    }

    public string PackVersion
    {
        get { return m_packVersion; }
        set { m_packVersion = value; }
    }

    public string Identifier
    {
        get { return m_identifier; }
        set { m_identifier = value; }
    }
    public string Platform
    {
        get { return m_platform; }
        set { m_platform = value; }
    } 


    string m_identifier = null;
    string m_platform = null;
    string m_packVersion = null;
    string m_appVersion = null;
} 


   