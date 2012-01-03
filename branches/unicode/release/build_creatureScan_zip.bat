rem rebuild all projects (automatically builds without debug flags)

setlocal

set zipfile=%1
set extraparams=%2
set config=%3

rem build plugin fullhtml_betauni with old Delphi7 compiler

call project_build.bat ../cSplugins/fullhtml_betauni/ fullhtml_betauni %extraparams%
if errorlevel 1 exit /B 1

rem build creatureScan with new Delphi XE2 compiler

call project_build_XE2.bat ../ creatureScan %config%
if errorlevel 1 exit /B 1

rem collect all data in creatureScan folder

rm -r creatureScan
mkdir creatureScan

cp ../creatureScan/creatureScan.exe creatureScan
cp ../creatureScan/cpphtmlparser.dll creatureScan
cp -r ../creatureScan/data creatureScan
cp -r ../creatureScan/images creatureScan
cp -r ../creatureScan/ioplugins creatureScan

rem remove unwanted files

rm creatureScan/ioplugins/*.rsm
rem find creatureScan -name ".svn" | xargs rm -r

7zip\7za.exe a %zipfile% creatureScan

sleep 3

endlocal