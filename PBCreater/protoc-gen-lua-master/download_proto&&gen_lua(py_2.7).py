# -*- coding: utf-8 -*-
import httplib2
import os
import sys
import time as timer

protocol = 'http'
ip = '106.75.36.113'
port = 80
path = '/doc/proto/'
files = ('c2gw.proto',
         'gw2c.proto',
         'chat.proto',
         'header.proto',
         'role.proto')
batFile = 'pblua自动生成.bat'

# 检查系统环境变量PYTHONPATH 是否存在protobuf python库
if os.environ.get("PYTHONPATH") is None or os.environ.get("PYTHONPATH").find('protobuf') == -1:
    print 'protobuf依赖库没有被导入,将添加临时环境变量到PYTHONPATH中'
    os.environ["PYTHONPATH"] = os.path.dirname(os.path.dirname(__file__)).replace('\\','/') + '/protobuf-2.6.1/python'

h = httplib2.Http()
h.add_credentials('tzbd2','tzbd2@0726')
count = 0
time_start = timer.time()
for file in files:
    url = protocol + '://' + ip + ':' + str(port) + path + file

    resp, content = h.request(url)

    filename = url.split('/')[len(url.split('/'))-1]

    print 'download ' + filename,
    
    if resp['status'] == '200':  
        with open('proto/'+filename, 'wb') as f:  
            f.write(content)
            f.close()
        print '.....Done!'
        count += 1

time_end = timer.time()

print str(count) + ' files saved in ' + str(round(time_end - time_start,3)) + 's'

os.system('start ' + batFile.decode('utf-8').encode('gbk'))