//
//  PluginTransmitter.h
//  Unity-iPhone
//
//  Created by 刘威亚 on 16/10/24.
//
//

#ifndef PluginTransmitter_h
#define PluginTransmitter_h

#include <iostream>
#include <map>
#include <string.h>
using namespace std;

extern "C"
{
    
    extern void BeginTransmission(const char* transName);
    extern void TransDataPiece(const char* transName,const char* key,const char* value);
    extern void EndTransmission(const char* transName);

}

namespace QKSDK
{
    class PluginTransmitter
    {
    public:
        static map<string,string> GetCache(const string& transName);
        static void Clear(const string& transName);
        static void TransToUnity(const string& transName,map<string,string> params);
    public:
        static void BeginTransmission(const string& transName);
        static void TransDataPiece(const string& transName,const string& key,const string& value);
        static void EndTransmission(const string& transName);
        
    private:
        // 传输缓存
        static map<string,map<string,string> > m_TransCache;
    };
}

#endif /* PluginTransmitter_h */
