::<License>------------------------------------------------------------
::
:: Copyright (c) 2018 Shinnosuke Yakenohara
::
:: This program is free software: you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation, either version 3 of the License, or
:: (at your option) any later version.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program.  If not, see <http://www.gnu.org/licenses/>.
::
::-----------------------------------------------------------</License>

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
powershell -ExecutionPolicy Unrestricted "& \"%ps1FileFullPath%\" /r%param%"

exit /b


::引数生成サブルーチン
:concat
set param=%param% \"%~1\"

exit /b
