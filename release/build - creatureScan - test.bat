
setlocal

set jahr=%date:~-4%
set monat=%date:~-7,2%
set tag=%date:~-10,2%
set stunde=%time:~0,2%
set minute=%time:~3,2%
set sekunde=%time:~6,2%

set datestr=%jahr%%monat%%tag%%stunde%%minute%%sekunde%

D:\devel\creatureScan\release\build_creatureScan_zip.bat creatureScan_build_%datestr%.zip "-DPRERELEASE"

endlocal