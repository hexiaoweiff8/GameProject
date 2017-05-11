//
//  PluginTransmitter.mm
//  Unity-iPhone
//
//  Created by 刘威亚 on 16/10/24.
//
//

#include "PluginTransmitter.h"

void BeginTransmission(const char* transName)
{
    QKSDK::PluginTransmitter::BeginTransmission(string(transName));
}

void TransDataPiece(const char* transName,const char* key,const char* value)
{
    QKSDK::PluginTransmitter::TransDataPiece(string(transName),string(key),string(value));
}

void EndTransmission(const char* transName)
{
    QKSDK::PluginTransmitter::EndTransmission(string(transName));
}

namespace QKSDK
{
    map<string,map<string,string> > PluginTransmitter::m_TransCache = map<string,map<string,string> >();
    
    void PluginTransmitter::TransToUnity(const string& transName,map<string,string> params)
    {
        if(params.size() > 0){
            // 结果传输
            UnitySendMessage("QKSDK", "BeginTransmission",transName.c_str());
            map<string,string>::iterator b = params.begin();
            for(; b != params.end() ; ++b){
                // 数据片
                UnitySendMessage("QKSDK", "TransmissionKey", b->first.c_str());
                UnitySendMessage("QKSDK", "TransmissionValue", b->second.c_str());
            }
            // 结束
            UnitySendMessage("QKSDK", "EndTransmission",transName.c_str());
        }
    }
    
    void PluginTransmitter::BeginTransmission(const string& transName)
    {
        m_TransCache[transName] = map<string,string>();
    }
    
    void PluginTransmitter::TransDataPiece(const string& transName,const string& key,const string& value)
    {
        m_TransCache[transName][key] = value;
    }
    
    void PluginTransmitter::EndTransmission(const string& transName)
    {
        
    }
    
    map<string,string> PluginTransmitter::GetCache(const string& transName)
    {
        map<string,map<string,string> >::iterator f = m_TransCache.find(transName);
        if(f != m_TransCache.end())
        {
            return f->second;
            
        }
        return map<string,string>();
    }
    
    void PluginTransmitter::Clear(const string& transName)
    {
        m_TransCache.erase(transName);
    }
}
