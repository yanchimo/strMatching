# �t�@�C���ǂݍ���
# StreamReader�̃R���X�g���N�^�ɒ��� �u$path + "\test.txt"�v����͂���ƃG���[�ɂȂ�̂ŕ�����
# $fileName = $path + "\a.txt"
$fileNameC = "c.txt"
$fileNameR = "r.txt"
$outputFileNameC = "outputc.txt"
$outputFileNameR = "outputr.txt"

# ���ёւ��ďd�����폜���邩
$autoSortFlag = $true

# C�̓��e��R�̒��g
$arrayBeforeC = @()
$arrayBeforeR = @()
# C�̃`�F�b�N���Ă���ӏ�
$arrayNumC = 0

$matchingNumC = -1
# ���ёւ��i�O��̕��ёւ��͂��Ȃ��ŉ��s�����邾���j��������̔z��
$arrayAfterC = @()
$arrayAfterR = @()


<#

    �t�@�C���̓ǂݍ���

#>
Write-Output("�t�@�C���ǂݍ���")
# C�̒��g�m�F
$file = New-Object System.IO.StreamReader($fileNameC, [System.Text.Encoding]::GetEncoding("sjis"))
while (($line = $file.ReadLine()) -ne $null)
{
    Write-Host($line)
    $arrayBeforeC += $line
}
$file.Close()

# R�̒��g�m�F
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

    C �� R����ёւ��ďd�����폜����iFlag��TRUE�̏ꍇ�̂݁j

#>
if ($autoSortFlag -eq $true){
    $arrayBeforeC = $arrayBeforeC | Sort-Object | Get-Unique
    $arrayBeforeR = $arrayBeforeR | Sort-Object | Get-Unique
}


<#

    C�@�Ɓ@R�̓��e���r����

#>
Write-Output "��r�J�n"
Write-Output ""
foreach($arrayStrR in $arrayBeforeR){
   
    Write-Output("��r���e�F" + $arrayBeforeC[$arrayNumC] + "-" + $arrayStrR)
    if($arrayBeforeC[$arrayNumC] -eq $arrayStrR){
        # ��v�����ꍇ�́AC��R��}��
        Write-Output ("��v")

        $arrayAfterC += $arrayBeforeC[$arrayNumC]
        $arrayBeforeC[$arrayNumC] = $null
        $arrayNumC ++
        $arrayAfterR += $arrayStrR
    } else {
        # ��v���Ȃ������ꍇ
        # ��v�t���O��������
        $matchingNumC = -1

        # �����񂪈�v���邩����
        $matchingNumC = [Array]::IndexOf($arrayBeforeC,$arrayStrR)
        if( $matchingNumC -le -1){
            Write-Output ("�s��v�{C�����s�{R��}��")

            # C��R�̓��e���Ȃ��ꍇ�́AC�̕������s����B
            $arrayAfterC += ""
            $arrayAfterR += $arrayStrR
        }else{
            Write-Output ("���ꂽ���Ɉ�v")

            # R��C�̓��e������ɂȂ�܂ŉ��s
            $differenceNum = $matchingNumC -  $arrayNumC
            Write-Output ("�s�̑���s�F" + $matchingNumC + "-" + $arrayNumC)
            for($idx=0; $idx -lt $differenceNum; $idx++) {
                Write-Output ("R�����s�{C��}��")
                $arrayAfterC += $arrayBeforeC[$arrayNumC]
                $arrayBeforeC[$arrayNumC] = $null
                $arrayNumC ++
                $arrayAfterR += ""
            }
            Write-Output ("�}�����܂�" + ":arrayBeforeC[" + $arrayNumC + "]=" + $arrayBeforeC[$arrayNumC])
            $arrayAfterC += $arrayBeforeC[$arrayNumC]
            $arrayBeforeC[$arrayNumC] = $null
            $arrayNumC ++
            $arrayAfterR += $arrayStrR
        }
        
    }
}

# C�̔�r���ĂȂ��iR�ɂȂ����j���o��
Write-Output("���̌��Ă���s:" + $arrayNumC)
while($arrayNumC -lt $arrayBeforeC.Count ){
    Write-Output  ("C�̕s������ǉ�" + $arrayBeforeR[$arrayNumC])
    $arrayAfterC += $arrayBeforeC[$arrayNumC]
    $arrayNumC ++
}


<#

    C�@�Ɓ@R�̕��ёւ���̓��e�������o��

#>
Write-Output("�����o��")

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




# �I��
Write-Host("�I��")