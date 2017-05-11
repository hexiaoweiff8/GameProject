--region *.lua
--20150807
--扩展一些方便写代码的通用接口
 
--- <summary>
--- 功能 : 当expression为真，返回v_true,否则返回 v_false
--- 有点类似于c的问号冒号表达式
--- </summary>
function ifv(expression,v_true,v_false)
    if(expression) then return v_true else return v_false end
end

--endregion

