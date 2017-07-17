del net-cs\*.cs
cd proto\
for /r %%i in (*.proto) do (
	protogen\protogen.exe -i:%%~ni%%~xi -o:..\Assets\scripts\net\socket\msg\%%~ni."cs"
)
cd ..
pause