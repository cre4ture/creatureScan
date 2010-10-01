rm -r creatureScan
mkdir creatureScan

cp ../creatureScan/creatureScan.exe creatureScan
cp -r ../creatureScan/data creatureScan
cp -r ../creatureScan/images creatureScan
cp -r ../creatureScan/ioplugins creatureScan

find creatureScan -name ".svn" | xargs rm -r

7zip\7za.exe a %1 creatureScan