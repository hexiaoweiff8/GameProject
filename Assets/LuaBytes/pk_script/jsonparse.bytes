JsonParse = {}


--- <summary>
--- 解释收到的包
--- </summary>
--- <returns type="QKJsonDoc"></returns>
function JsonParse.RecvNM(nmstr)
	local jsonnm = QKJsonDoc.NewMap()
	jsonnm:Parse(nmstr)
	return jsonnm
end 

--- <summary>
--- 功能 : 生成发送包JsonDoc
--- nmhead : string 包名
--- </summary>
--- <returns type="QKJsonDoc"></returns>
function JsonParse.SendNM(nmhead)
	local jsonnm = QKJsonDoc.NewMap()
    jsonnm:Add("n",nmhead)
	return jsonnm
end

--- <summary>
--- 功能 : 将json文档转化成lua表
--- jsonDoc : QKJsonDoc
--- </summary>
--- <returns type="table"></returns>
function JsonParse.JsonDoc2Table(jsonDoc)
    local re = {}
    local eachFunc = function(k,v) 
        re[k] = v
    end
    jsonDoc:Foreach(eachFunc)
    return re
end

function JsonParse.JsonDocKey2Array(jsonDoc)
    local re = {}
    local eachFunc = function(k,_) 
        table.insert(re,k)
    end
    jsonDoc:Foreach(eachFunc)
    return re
end

--- <summary>
--- 功能 : 将json文档的key生成为数字类型的数组
--- jsonDoc : QKJsonDoc
--- </summary>
--- <returns type="table"></returns>
function JsonParse.JsonDocKey2NumberArray(jsonDoc)
    local re = {}
    local eachFunc = function(k,_)
        table.insert(re,tonumber(k) )
    end
    jsonDoc:Foreach(eachFunc)
    return re
end