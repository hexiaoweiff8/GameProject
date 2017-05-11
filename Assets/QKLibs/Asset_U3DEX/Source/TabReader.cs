using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions; 
using System.IO;
using UnityEngine;



public class BSVTabReader : ITabReader
{

    public bool Load(string packName,string tabName)
    { 
        
        PacketRouting packetRouting = PacketManage.Single.GetPacket(packName);
        if (packetRouting == null) return false;
         
        byte[] byteFile = packetRouting.LoadBytes(tabName); 
        if (byteFile == null) return false;

        int byteStartIndex = 0;
        if (byteFile.Length >= 3)
        {
            if (byteFile[0] == 0xEF && byteFile[1] == 0xBB && byteFile[2] == 0xBF)
                byteStartIndex = 3;//跳过utf8文件头
        }

        m_Tab.Deserialization(byteFile, byteStartIndex, byteFile.Length - byteStartIndex); 
        return true;
    }
    public int GetI32(short column, int row)
    {
        return m_Tab.GetI32(column, row);
    }

    public short GetI16(short column, int row)
    {
        return m_Tab.GetI16(column, row);
    }

    public float GetF(short column, int row)
    {
        return m_Tab.GetF(column, row);
    }

    public string GetS(short column, int row)
    {
        return m_Tab.GetS(column, row);
    }

    public int GetRowCount()
    {
        return m_Tab.GetRowCount();
    }

    public short ColumnName2Index(string columnName)
    {
        return m_Tab.ColumnName2Index(columnName);
    }

    public void Dispose()
    {
        //m_Tab.Dispose();
    }

    BTab m_Tab = new BTab();
};


public class CSVTabReader : ITabReader
{

    public bool Load(string packName, string tabName)
    {
        CSVDoc doc = new CSVDoc();
       // doc.LoadCsvFile(packName, tabName);


        //对数据的有效性进行验证
        PacketRouting pack = PacketManage.Single.GetPacket(packName);
        if (pack == null)
        {
            Debug.LogError("LoadCsvFile 包不存在" + packName);
            return false;
        }

        string csvcontent = pack.LoadString(tabName);
        if (csvcontent == null)
        {
            Debug.LogError(string.Format("LoadCsvFile 文件不存在 {0}/{1}", packName, tabName));
            return false;
        }
        doc.LoadCsvFromMem(csvcontent);



        m_reader = new CSVReader(doc);
        return true;
    }

    public int GetI32(short column, int row)
    {
        return m_reader.GetI32(column, row);
    }

    public short GetI16(short column, int row)
    {
        return m_reader.GetI16(column, row);
    }

    public float GetF(short column, int row)
    {
        return m_reader.GetF(column, row);
    }

    public string GetS(short column, int row)
    {
        return m_reader.GetS(column, row);
    }

    public int GetRowCount()
    {
        return m_reader.RowCount;
    }

    public short ColumnName2Index(string columnName)
    {
        return m_reader.ColumnName2Index(columnName);
    }

    public void Dispose() { }
    CSVReader m_reader;
};



class U3dTabFactory : TabFactory
{
    public ITabReader CreateTab(TabType type)
    {
        if (type == TabType.BSV)
            return new BSVTabReader();
        else
            return new CSVTabReader();
    }
}
