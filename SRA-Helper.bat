@ECHO OFF
echo "Starting SRA-Helper..."
pushd %~dp0
start src\autoit\AutoIt3.exe "src\SRA-Helper.au3"
