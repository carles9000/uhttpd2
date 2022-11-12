@echo off

rem if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_x64
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

del app.exe

c:\harbour\bin\hbmk2 app.hbp -comp=msvc64

IF ERRORLEVEL 1 GOTO COMPILEERROR

del app.exp
del app.lib

@cls
app.exe

GOTO EXIT


:COMPILEERROR

echo *** Error 

pause

:EXIT
