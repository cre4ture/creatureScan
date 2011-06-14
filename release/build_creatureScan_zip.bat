rem rebuild all projects (automatically builds without debug flags)

call project_build.bat ../cSplugins/fullhtml_betauni/ fullhtml_betauni
if errorlevel 1 exit /B 1
call project_build.bat ../cSplugins/fullhtml/ fullhtml
if errorlevel 1 exit /B 1
call project_build.bat ../ creatureScan
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
find creatureScan -name ".svn" | xargs rm -r

7zip\7za.exe a %1 creatureScan

sleep 3
