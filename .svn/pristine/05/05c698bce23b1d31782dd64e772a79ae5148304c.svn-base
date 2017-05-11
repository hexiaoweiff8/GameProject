del net-cs\*.cs
cd proto\
for /r %%i in (*.proto) do (
	..\protogen\protogen.exe -i:%%~ni%%~xi -o:..\msg\%%~ni."cs"
)
cd ..