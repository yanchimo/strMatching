# ファイル読み込み
# StreamReaderのコンストラクタに直接 「$path + "\test.txt"」を入力するとエラーになるので分ける
# $fileName = $path + "\a.txt"
$fileNameC = "c.txt"
$fileNameR = "r.txt"
$outputFileNameC = "outputc.txt"
$outputFileNameR = "outputr.txt"

# 並び替えて重複を削除するか
$autoSortFlag = $true

# Cの内容とRの中身
$arrayBeforeC = @()
$arrayBeforeR = @()
# Cのチェックしている箇所
$arrayNumC = 0

$matchingNumC = -1
# 並び替え（前後の並び替えはしないで改行を入れるだけ）をした後の配列
$arrayAfterC = @()
$arrayAfterR = @()


<#

    ファイルの読み込み

#>
Write-Output("ファイル読み込み")
# Cの中身確認
$file = New-Object System.IO.StreamReader($fileNameC, [System.Text.Encoding]::GetEncoding("sjis"))
while (($line = $file.ReadLine()) -ne $null)
{
    Write-Host($line)
    $arrayBeforeC += $line
}
$file.Close()

# Rの中身確認
Write-Output("")
$file = New-Object System.IO.StreamReader($fileNameR, [System.Text.Encoding]::GetEncoding("sjis"))
while (($line = $file.ReadLine()) -ne $null)
{
    Write-Host($line)
    $arrayBeforeR += $line
}
$file.Close()

Write-Output("C-count" + $arrayBeforeC.Count)
Write-Output("R-count" + $arrayBeforeR.Count)


<#

    C と Rを並び替えて重複を削除する（FlagがTRUEの場合のみ）

#>
if ($autoSortFlag -eq $true){
    $arrayBeforeC = $arrayBeforeC | Sort-Object | Get-Unique
    $arrayBeforeR = $arrayBeforeR | Sort-Object | Get-Unique
}


<#

    C　と　Rの内容を比較する

#>
Write-Output "比較開始"
Write-Output ""
foreach($arrayStrR in $arrayBeforeR){
   
    Write-Output("比較内容：" + $arrayBeforeC[$arrayNumC] + "-" + $arrayStrR)
    if($arrayBeforeC[$arrayNumC] -eq $arrayStrR){
        # 一致した場合は、CとRを挿入
        Write-Output ("一致")

        $arrayAfterC += $arrayBeforeC[$arrayNumC]
        $arrayBeforeC[$arrayNumC] = $null
        $arrayNumC ++
        $arrayAfterR += $arrayStrR
    } else {
        # 一致しなかった場合
        # 一致フラグを初期化
        $matchingNumC = -1

        # 文字列が一致するか検索
        $matchingNumC = [Array]::IndexOf($arrayBeforeC,$arrayStrR)
        if( $matchingNumC -le -1){
            Write-Output ("不一致＋Cを改行＋Rを挿入")

            # CにRの内容がない場合は、Cの方を改行する。
            $arrayAfterC += ""
            $arrayAfterR += $arrayStrR
        }else{
            Write-Output ("ずれた個所に一致")

            # RをCの内容が同一になるまで改行
            $differenceNum = $matchingNumC -  $arrayNumC
            Write-Output ("行の相違行：" + $matchingNumC + "-" + $arrayNumC)
            for($idx=0; $idx -lt $differenceNum; $idx++) {
                Write-Output ("Rを改行＋Cを挿入")
                $arrayAfterC += $arrayBeforeC[$arrayNumC]
                $arrayBeforeC[$arrayNumC] = $null
                $arrayNumC ++
                $arrayAfterR += ""
            }
            Write-Output ("挿入します" + ":arrayBeforeC[" + $arrayNumC + "]=" + $arrayBeforeC[$arrayNumC])
            $arrayAfterC += $arrayBeforeC[$arrayNumC]
            $arrayBeforeC[$arrayNumC] = $null
            $arrayNumC ++
            $arrayAfterR += $arrayStrR
        }
        
    }
}

# Cの比較してない（Rにない分）を出力
Write-Output("今の見ている行:" + $arrayNumC)
while($arrayNumC -lt $arrayBeforeC.Count ){
    Write-Output  ("Cの不足分を追加" + $arrayBeforeR[$arrayNumC])
    $arrayAfterC += $arrayBeforeC[$arrayNumC]
    $arrayNumC ++
}


<#

    C　と　Rの並び替え後の内容を書き出す

#>
Write-Output("書き出し")

$file = New-Object System.IO.StreamWriter($outputFileNameC, $false, [System.Text.Encoding]::GetEncoding("sjis"))
foreach($str_name in $arrayAfterC){
    $file.WriteLine($str_name)
} 
$file.Close()


$file = New-Object System.IO.StreamWriter($outputFileNameR, $false, [System.Text.Encoding]::GetEncoding("sjis"))
foreach($str_name in $arrayAfterR){
    $file.WriteLine($str_name)
} 
$file.Close()




# 終了
Write-Host("終了")