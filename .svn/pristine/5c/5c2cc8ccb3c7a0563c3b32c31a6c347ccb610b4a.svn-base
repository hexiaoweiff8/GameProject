//
//  QKCommand.mm
//  Unity-iPhone
//
//  Created by 刘威亚 on 16/10/24.
//
//

#include "QKCommand.h"
#include "PluginTransmitter.h"

void OnQKCommand(const char* eventName)
{
    QKSDK::QKCommand::OnQKCommand(string(eventName));
}

namespace QKSDK
{
    map<string,list<OnCommandCall> > QKCommand::m_Listeners = map<string,list<OnCommandCall> >();
    
    void QKCommand::OnQKCommand(const string& cmdName)
    {
        
        
        map< string,list<OnCommandCall> >::iterator f = m_Listeners.find(cmdName);
        if( f != m_Listeners.end())
        {
            list<OnCommandCall> tempList = f->second;
            if(tempList.size() > 0){
                
                map<string,string> result;
                
                map<string,string> params = PluginTransmitter::GetCache(cmdName);
                
                list<OnCommandCall>::iterator b = tempList.begin();
                for (;b != tempList.end();++b) {
                    map<string,string> tempReturns = (*(*b))(params);
                    
                    map<string,string>::iterator tR = tempReturns.begin();
                    for( ; tR != tempReturns.end() ; ++tR)
                    {
                        result[tR->first] = tR->second;
                    }
                }
                
                PluginTransmitter::TransToUnity(cmdName,result);
                PluginTransmitter::Clear(cmdName);
            }
        }
    }
    
    void QKCommand::RegListener(const string& cmdName,OnCommandCall callBack)
    {
        map< string,list<OnCommandCall> >::iterator f = m_Listeners.find(cmdName);
        if(f != m_Listeners.end())
        {
            f->second.remove(callBack);
            f->second.push_back(callBack);
        }
        else
        {
            list<OnCommandCall> temp;
            temp.push_back(callBack);
            m_Listeners[cmdName] = temp;
        }
        
        // 注册
        UnitySendMessage("QKSDK", "RegQKCommandListener", cmdName.c_str());
    }
    
    void QKCommand::UnRegListener(const string& cmdName,OnCommandCall callBack)
    {
        map< string,list<OnCommandCall> >::iterator f = m_Listeners.find(cmdName);
        if(f != m_Listeners.end())
        {
            f->second.remove(callBack);
            if(0 == f->second.size())
            {
                // 解除注册
                UnitySendMessage("QKSDK", "UnRegQKCommandListener", cmdName.c_str());
            }
        }
    }
    
    map<string,string> SendCommand(const string& cmdName,map<string,string> params)
    {
        PluginTransmitter::TransToUnity(cmdName,params);
        
        // 执行
        UnitySendMessage("QKSDK", "SendQKCommand", cmdName.c_str());
        
        map<string,string> result = PluginTransmitter::GetCache(cmdName);
        PluginTransmitter::Clear(cmdName);
        
        return result;
    }
}
