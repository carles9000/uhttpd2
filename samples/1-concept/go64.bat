@echo off
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

del error.log
del concept.exe

c:\harbour\bin\hbmk2 concept.hbp -comp=msvc64

IF ERRORLEVEL 1 GOTO COMPILEERROR

del concept.exp
del concept.lib

@cls
concept.exe

GOTO EXIT


:COMPILEERROR

echo *** Error 

pause

:EXIT
