rem builds a delphi project
setlocal

set projectdir=%1
set projectname=%2
set extraparams=%3

cd %projectdir%

"C:\Program Files (x86)\Borland\Delphi7\Bin\dcc32" %projectname% -U"%PUBLIC%\Documents\Soft Gems\Virtual Treeview\Source" -U"%delphilib%\gltrayicon" -U"%delphilib%\uli\SocketMultiplexer" -U"%delphilib%\xmlparser";"%delphilib%\uli\htmllib";"%delphilib%\uli";"%delphilib%\TRegExpr\Source" -B -$C- -$D- -$I- -$L- -$Q- -$R- -$Y- -v- -vr- -O %extraparams%

exit /B %errorlevel%

endlocal