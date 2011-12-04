rem builds a delphi project
setlocal

set projectdir=%1
set projectname=%2
set config=%3

cd %projectdir%

call "C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\bin\rsvars.bat"
msbuild %projectname%.dproj /t:Rebuild /p:Config=%config%

exit /B %errorlevel%

endlocal