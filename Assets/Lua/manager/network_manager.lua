-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local class = require("common/middleclass")

local network_manager = class("network_manager")

function network_manager:instance()
    if self._instance == nil then
        self._instance = network_manager()
    end
    return self._instance
end

function network_manager:on_init()
    print("network_manager.on_init")
end

function network_manager:on_unload()
    print("network_manager.on_unload")
end

function network_manager.on_socket_data(key, data)
    if key == Protocal.Message then
        local header = header_pb.Header();
        header:ParseFromString(data);
        printe('ID==>' .. header.ID);
        printw('msgId==>' .. header.msgId);
        printf('userId==>' .. header.userId);
        printw('version==>' .. header.version);
        lgyPrint('errno==>' .. header.errno);
        lgyPrint('ext==>' .. header.ext);
        if header.errno == 0 then --错误码为0
            -- 2017-08-04 加入记录接收请求回执时间
            NetworkDelay_Manager:RecordReceiveTime(header.ID)
            -- add end
            Event.Brocast(tostring(header.msgId), header.body)
        else
            Event.Brocast("errno"..tostring(header.msgId),header.errno)
        end
    end
end

return network_manager
