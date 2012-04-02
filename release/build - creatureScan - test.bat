
setlocal

set jahr=%date:~-4%
set monat=%date:~-7,2%
set tag=%date:~-10,2%

set datestr=%jahr%%monat%%tag%_%random%

build_creatureScan_zip.bat creatureScan_build_%datestr%.zip "-DPRERELEASE" TestRelease

endlocal