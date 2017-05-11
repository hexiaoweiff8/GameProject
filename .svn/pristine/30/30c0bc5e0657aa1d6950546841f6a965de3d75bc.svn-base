//
//  QKCommand.hpp
//  Unity-iPhone
//
//  Created by 刘威亚 on 16/10/24.
//
//

#ifndef QKCommand_hpp
#define QKCommand_hpp

#include <iostream>
#include <map>
#include <list>
#include <string.h>
using namespace std;

extern "C"
{
    extern void OnQKCommand(const char* eventName);
}

namespace QKSDK
{
    typedef map<string,string> (*OnCommandCall)(map<string,string> param);
    
    class QKCommand
    {
    public:
        static void OnQKCommand(const string& cmdName);
        
    public:
        
        static void RegListener(const string& cmdName,OnCommandCall callBack);
        
        static void UnRegListener(const string& cmdName,OnCommandCall callBack);
        
        static map<string,string> SendCommand(const string& cmdName,map<string,string> params = map<string,string>());
   
    private:
        static map<string,list<OnCommandCall> > m_Listeners;
        
    };
}

#endif /* QKCommand_hpp */
