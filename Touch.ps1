#変数宣言
$rec = "/r" #Recursive処理指定文字列
$isRec = $FALSE #Recursiveに処理するかどうか

$total = 0
$scsOfTotal = 0
$errOfTotal = 0
$file = 0
$scsOfFile = 0
$errOfFile = 0
$dir = 0
$scsOfDir = 0
$errOfDir = 0

#Recursiveに処理するかどうかをチェック
$isRec = $FALSE
$mxOfArgs = $Args.count
$removed = 0
for ($idx = 0 ; $idx -lt $mxOfArgs ; %idx++){
    
    if($Args[$idx] -eq $rec){ #Recursive処理指定文字列の場合
        $isRec = $TRUE
        $Args[$idx] = $null #処理対象から除外
        $removed++
        break
        
    }
}

#処理対象リスト作成
[String[]]$list = New-Object String[] ($mxOfArgs - $removed)

#除外引数を除いたリストを作る
$toAddIdx = 0
for ($idx = 0 ; $idx -lt $mxOfArgs ; $idx++){
    
    if($Args[$idx] -ne $null){
        $list[$toAddIdx] = $Args[$idx]
        $toAddIdx++
    }
}

#Recursiveに処理する場合
if($isRec) {
    
    foreach( $path in $list ){
        
        if(Test-Path $path -PathType Container) { #ディレクトリの場合
            
            Get-ChildItem  -Recurse -Force -Path $path | ForEach-Object {
                $list += $_.FullName
            }
        }
    }
}

#タイムスタンプ更新ループ
foreach ($path in $list) {
    
    echo $path
    
    if ((Test-Path $path -PathType container)){ #ディレクトリの場合
            
        try {
            Set-ItemProperty -Path $path `
                             -Name LastWriteTime `
                             -Value $(Get-Date)
            $scsOfDir++
            
        } catch {
            Write-Error $Error[0]
            $errOfDir++
        }
        $dir++
    
    } else { #ファイルの場合
        
        try {
            Set-ItemProperty -Path $path `
                             -Name LastWriteTime `
                             -Value $(Get-Date)
            $scsOfFile++
            
        } catch {
            Write-Error $Error[0]
            $errOfFile++
        }
        $file++
    }
}

#結果表示
$total = $file + $dir
$scsOfTotal = $scsOfFile + $scsOfDir
$errOfTotal = $errOfFile + $errOfDir

""
"ディレクトリの処理失敗数"
$errOfDir

"ファイルの処理失敗数"
$errOfFile

#失敗処理がある場合はpauseする
if ($errOfTotal -gt 0){
	Read-Host "続行するにはEnterキーを押してください . . ."
}
