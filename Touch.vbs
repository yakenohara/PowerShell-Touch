' <# License>------------------------------------------------------------
' 
'  Copyright (c) 2018 Shinnosuke Yakenohara
' 
'  This program is free software: you can redistribute it and/or modify
'  it under the terms of the GNU General Public License as published by
'  the Free Software Foundation, either version 3 of the License, or
'  (at your option) any later version.
' 
'  This program is distributed in the hope that it will be useful,
'  but WITHOUT ANY WARRANTY; without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'  GNU General Public License for more details.
' 
'  You should have received a copy of the GNU General Public License
'  along with this program.  If not, see <http://www.gnu.org/licenses/>
' 
' -----------------------------------------------------------</License #>

'設定
isDebug = false 'デバッグモード ps1がコール出来ない時にtrueにして調査する
ps1FileName = "Touch.ps1" '.ps1ファイル名

'ライブラリからオブジェクト生成
Set WSObj = WScript.CreateObject("WScript.Shell")
Set FSObj = createObject("Scripting.FileSystemObject")

'.ps1用パラメーター生成
paramStr = ""
For Each arg In WScript.Arguments
     paramStr = paramStr & " \""" & arg & "\"""
Next

'コマンド生成
cmdStr = "powershell -ExecutionPolicy Unrestricted " & _
         """& \"""& FSObj.getParentFolderName(WScript.ScriptFullName) & "\" & ps1FileName & "\""" & _
         " /r /p" & paramStr & """"

if isDebug Then 'デバッグモードの場合

    'execメソッドでps1を実行して標準出力を得る

    Set outExec = WSObj.Exec(cmdStr)
    Set StdOut = outExec.StdOut
    Set StdErr = outExec.StdErr

    szStr = "<STDOUT>" & vbCrLf
    Do While Not StdOut.AtEndOfStream
       szStr = szStr & StdOut.ReadLine() &vbCrLf
    Loop
    szStr = szStr & "</STDOUT>"
    
    seStr = "<STDERR>" & vbCrLf
    Do While Not StdErr.AtEndOfStream
       seStr = seStr & StdErr.ReadLine() &vbCrLf
    Loop
    seStr = seStr & "</STDERR>"
    
    msg = "<COMMAND>" & vbCrLf & cmdStr & vbCrLf & "</COMMAND>" & vbCrLf & szStr & vbCrLf & seStr
    
    WScript.Echo msg
    
Else 'デバッグモードでない場合
    
    'runメソッドでps1を実行して標準出力を得る
    WSObj.Run cmdStr

End If
