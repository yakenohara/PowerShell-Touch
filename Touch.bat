@echo off

::定数
set ps1FileName=Touch.ps1

::初期化
set ps1FileFullPath=%~dp0%ps1FileName%


::引数生成ループ
set param=
for %%f in (%*) do (
  call :concat %%f
)

::Call powershell
powershell "& \"%ps1FileFullPath%\"%param%"

::エラーチェック
if %ERRORLEVEL% == 1 (
  echo.
  pause
)

exit /b


::引数生成サブルーチン
:concat
set param=%param% \"%~1\"

exit /b
