rem builds a delphi project
setlocal

set projectdir=%1
set projectname=%2

cd %projectdir%

dcc32 %projectname% -U"%PUBLIC%\Documents\Soft Gems\Virtual Treeview\Source" -U"%delphilib%\gltrayicon" -U"%delphilib%\uli\SocketMultiplexer" -U"%delphilib%\xmlparser";"%delphilib%\uli\htmllib";"%delphilib%\uli";"%delphilib%\TRegExpr\Source" -B -$C- -$D- -$I- -$L- -$Q- -$R- -$Y- -v- -vr- -O

exit /B %errorlevel%

endlocal